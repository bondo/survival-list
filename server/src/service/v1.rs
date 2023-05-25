use futures_util::pin_mut;
use futures_util::stream::StreamExt;
use log::error;
use sqlx::types::{time::Date, Uuid};
use tokio::sync::mpsc;
use tokio_stream::wrappers::ReceiverStream;
use tonic::{Request, Response, Status};

use crate::{
    auth::AuthExtension,
    db::{
        CreateTaskParams, Database, GroupId, TaskEstimate, TaskGroup, TaskId, TaskPeriod,
        TaskRecurrence, TaskRecurrenceFrequency, TaskResponsible, UpdateTaskParams, UserId,
    },
};

use super::proto::{api::v1::*, google::r#type::Date as ProtoDate};

pub struct Service {
    db: Database,
}

impl Service {
    pub fn new(db: Database) -> Self {
        Self { db }
    }
}

impl Service {
    fn get_user_uid<T>(&self, request: &Request<T>) -> Result<String, Status> {
        if let Some(auth) = request.extensions().get::<AuthExtension>() {
            Ok(auth.uid.clone())
        } else {
            Err(Status::internal("failed to read user uid"))
        }
    }

    async fn get_user_id<T>(&self, request: &Request<T>) -> Result<UserId, Status> {
        let uid = self.get_user_uid(request)?;
        self.db.upsert_user_id(&uid).await
    }
}

#[tonic::async_trait]
impl api_server::Api for Service {
    async fn login(
        &self,
        request: Request<LoginRequest>,
    ) -> Result<Response<LoginResponse>, Status> {
        let uid = self.get_user_uid(&request)?;
        let request = request.into_inner();
        let picture_url: Option<&str> = if request.picture_url.is_empty() {
            None
        } else {
            Some(&request.picture_url)
        };
        let user = self
            .db
            .upsert_user(&uid, &request.name, picture_url)
            .await?;
        Ok(Response::new(LoginResponse {
            user: Some(User {
                id: user.id.into(),
                name: user.name,
                picture_url: user.picture_url.unwrap_or_default(),
            }),
        }))
    }

    async fn create_task(
        &self,
        request: Request<CreateTaskRequest>,
    ) -> Result<Response<CreateTaskResponse>, Status> {
        let user_id = self.get_user_id(&request).await?;
        let request = request.into_inner();
        let responsible_id = if request.responsible_id == i32::default() {
            user_id
        } else {
            UserId::new(request.responsible_id)
        };
        let group_id = if request.group_id == i32::default() {
            None
        } else {
            Some(GroupId::new(request.group_id))
        };
        let task = self
            .db
            .create_task(CreateTaskParams {
                user_id,
                responsible_id,
                title: request.title,
                period: (request.start_date, request.end_date).try_into()?,
                group_id,
                estimate: match request.estimate {
                    None => Ok(None),
                    Some(estimate) => estimate.try_into().map(Some),
                }?,
                recurrence: match request.recurring {
                    None => Ok(None),
                    Some(create_task_request::Recurring::Every(frequency)) => {
                        frequency.try_into().map(TaskRecurrence::Every).map(Some)
                    }
                    Some(create_task_request::Recurring::Checked(frequency)) => frequency
                        .try_into()
                        .map(TaskRecurrence::WhenChecked)
                        .map(Some),
                }?,
            })
            .await?;
        Ok(Response::new(CreateTaskResponse {
            id: task.id.into(),
            title: task.title.unwrap_or_else(|| {
                error!("v1:create_task: Got task without title (id {})", task.id);
                "N/A".to_string()
            }),
            start_date: task.period.start().map(Into::into),
            end_date: task.period.end().map(Into::into),
            estimate: task.estimate.map(Into::into),
            responsible: Some(task.responsible.into()),
            group: task.group.map(Into::into),
            recurring: task.recurrence.map(|r| match r {
                TaskRecurrence::Every(frequency) => {
                    create_task_response::Recurring::Every(frequency.into())
                }
                TaskRecurrence::WhenChecked(frequency) => {
                    create_task_response::Recurring::Checked(frequency.into())
                }
            }),
            disabled: task.disabled,
        }))
    }

    async fn update_task(
        &self,
        request: Request<UpdateTaskRequest>,
    ) -> Result<Response<UpdateTaskResponse>, Status> {
        let user_id = self.get_user_id(&request).await?;
        let request = request.into_inner();
        let responsible_id = if request.responsible_id == i32::default() {
            user_id
        } else {
            UserId::new(request.responsible_id)
        };
        let group_id = if request.group_id == i32::default() {
            None
        } else {
            Some(GroupId::new(request.group_id))
        };
        let task = self
            .db
            .update_task(UpdateTaskParams {
                user_id,
                responsible_id,
                task_id: TaskId::new(request.id),
                title: request.title,
                period: (request.start_date, request.end_date).try_into()?,
                group_id,
                estimate: match request.estimate {
                    None => Ok(None),
                    Some(estimate) => estimate.try_into().map(Some),
                }?,
                recurrence: match request.recurring {
                    None => Ok(None),
                    Some(update_task_request::Recurring::Every(frequency)) => {
                        frequency.try_into().map(TaskRecurrence::Every).map(Some)
                    }
                    Some(update_task_request::Recurring::Checked(frequency)) => frequency
                        .try_into()
                        .map(TaskRecurrence::WhenChecked)
                        .map(Some),
                }?,
            })
            .await?;
        Ok(Response::new(UpdateTaskResponse {
            id: task.id.into(),
            title: task.title.unwrap_or_else(|| {
                error!("v1:update_task: Got task without title (id {})", task.id);
                "N/A".to_string()
            }),
            is_completed: task.completed_at.is_some(),
            start_date: task.period.start().map(Into::into),
            end_date: task.period.end().map(Into::into),
            estimate: task.estimate.map(Into::into),
            responsible: Some(task.responsible.into()),
            group: task.group.map(Into::into),
            recurring: task.recurrence.map(|r| match r {
                TaskRecurrence::Every(frequency) => {
                    update_task_response::Recurring::Every(frequency.into())
                }
                TaskRecurrence::WhenChecked(frequency) => {
                    update_task_response::Recurring::Checked(frequency.into())
                }
            }),
            disabled: task.disabled,
        }))
    }

    async fn toggle_task_completed(
        &self,
        request: Request<ToggleTaskCompletedRequest>,
    ) -> Result<Response<ToggleTaskCompletedResponse>, Status> {
        let user_id = self.get_user_id(&request).await?;
        let request = request.into_inner();
        let task = self
            .db
            .toggle_task_completed(user_id, TaskId::new(request.id), request.is_completed)
            .await?;
        Ok(Response::new(ToggleTaskCompletedResponse {
            id: task.id.into(),
            is_completed: task.completed_at.is_some(),
            tasks_created: vec![],
            tasks_updated: vec![],
            tasks_deleted: vec![],
        }))
    }

    async fn delete_task(
        &self,
        request: Request<DeleteTaskRequest>,
    ) -> Result<Response<DeleteTaskResponse>, Status> {
        let user_id = self.get_user_id(&request).await?;
        let request = request.into_inner();
        let id = self
            .db
            .delete_task(user_id, TaskId::new(request.id))
            .await?;
        Ok(Response::new(DeleteTaskResponse { id: id.into() }))
    }

    type GetTasksStream = ReceiverStream<Result<GetTasksResponse, Status>>;
    async fn get_tasks(
        &self,
        request: Request<GetTasksRequest>,
    ) -> Result<Response<Self::GetTasksStream>, Status> {
        let user_id = self.get_user_id(&request).await?;
        let (tx, rx) = mpsc::channel(10);

        let db = self.db.clone();
        tokio::spawn(async move {
            let tasks = db.get_tasks(user_id);
            pin_mut!(tasks);

            while let Some(res) = tasks.next().await {
                tx.send(res.map(|task| GetTasksResponse {
                    id: task.id.into(),
                    title: task.title.unwrap_or_else(|| {
                        error!("v1:get_tasks: Got task without title (id {})", task.id);
                        "N/A".to_string()
                    }),
                    is_completed: task.completed_at.is_some(),
                    start_date: task.period.start().map(Into::into),
                    end_date: task.period.end().map(Into::into),
                    estimate: task.estimate.map(Into::into),
                    responsible: Some(task.responsible.into()),
                    group: task.group.map(Into::into),
                    recurring: task.recurrence.map(|r| match r {
                        TaskRecurrence::Every(frequency) => {
                            get_tasks_response::Recurring::Every(frequency.into())
                        }
                        TaskRecurrence::WhenChecked(frequency) => {
                            get_tasks_response::Recurring::Checked(frequency.into())
                        }
                    }),
                    disabled: task.disabled,
                }))
                .await
                .unwrap();
            }
        });

        Ok(Response::new(ReceiverStream::new(rx)))
    }

    async fn create_group(
        &self,
        request: Request<CreateGroupRequest>,
    ) -> Result<Response<CreateGroupResponse>, Status> {
        let user_id = self.get_user_id(&request).await?;
        let request = request.into_inner();
        let group = self
            .db
            .create_and_join_group(user_id, &request.title)
            .await?;
        Ok(Response::new(CreateGroupResponse {
            id: group.id.into(),
            title: group.title,
            uid: group.uid.to_string(),
        }))
    }

    async fn join_group(
        &self,
        request: Request<JoinGroupRequest>,
    ) -> Result<Response<JoinGroupResponse>, Status> {
        let user_id = self.get_user_id(&request).await?;
        let request = request.into_inner();
        let uid =
            Uuid::parse_str(&request.uid).map_err(|_| Status::invalid_argument("Invalid uid"))?;
        let group = self.db.join_group_by_uid(user_id, &uid).await?;
        Ok(Response::new(JoinGroupResponse {
            id: group.id.into(),
            title: group.title,
            uid: group.uid.to_string(),
        }))
    }

    async fn update_group(
        &self,
        request: Request<UpdateGroupRequest>,
    ) -> Result<Response<UpdateGroupResponse>, Status> {
        let user_id = self.get_user_id(&request).await?;
        let request = request.into_inner();
        let group = self
            .db
            .update_group(user_id, GroupId::new(request.id), &request.title)
            .await?;
        Ok(Response::new(UpdateGroupResponse {
            id: group.id.into(),
            title: group.title,
            uid: group.uid.to_string(),
        }))
    }

    async fn leave_group(
        &self,
        request: Request<LeaveGroupRequest>,
    ) -> Result<Response<LeaveGroupResponse>, Status> {
        let user_id = self.get_user_id(&request).await?;
        let request = request.into_inner();
        let id = self
            .db
            .leave_group(user_id, GroupId::new(request.id))
            .await?;
        Ok(Response::new(LeaveGroupResponse { id: id.into() }))
    }

    type GetGroupsStream = ReceiverStream<Result<GetGroupsResponse, Status>>;
    async fn get_groups(
        &self,
        request: Request<GetGroupsRequest>,
    ) -> Result<Response<Self::GetGroupsStream>, Status> {
        let user_id = self.get_user_id(&request).await?;
        let (tx, rx) = mpsc::channel(10);

        let db = self.db.clone();
        tokio::spawn(async move {
            let groups = db.get_user_groups(user_id);
            pin_mut!(groups);

            while let Some(res) = groups.next().await {
                tx.send(res.map(|group| GetGroupsResponse {
                    id: group.id.into(),
                    title: group.title,
                    uid: group.uid.to_string(),
                }))
                .await
                .unwrap();
            }
        });

        Ok(Response::new(ReceiverStream::new(rx)))
    }

    type GetGroupParticipantsStream = ReceiverStream<Result<GetGroupParticipantsResponse, Status>>;
    async fn get_group_participants(
        &self,
        request: Request<GetGroupParticipantsRequest>,
    ) -> Result<Response<Self::GetGroupParticipantsStream>, Status> {
        let user_id = self.get_user_id(&request).await?;
        let request = request.into_inner();
        let (tx, rx) = mpsc::channel(10);

        let db = self.db.clone();
        tokio::spawn(async move {
            let participants = db.get_group_participants(user_id, GroupId::new(request.group_id));
            pin_mut!(participants);

            while let Some(res) = participants.next().await {
                tx.send(res.map(|user| GetGroupParticipantsResponse {
                    user: Some(User {
                        id: user.id.into(),
                        name: user.name,
                        picture_url: user.picture_url.unwrap_or_default(),
                    }),
                }))
                .await
                .unwrap();
            }
        });

        Ok(Response::new(ReceiverStream::new(rx)))
    }
}

impl TryFrom<(Option<ProtoDate>, Option<ProtoDate>)> for TaskPeriod {
    type Error = Status;

    fn try_from((start, end): (Option<ProtoDate>, Option<ProtoDate>)) -> Result<Self, Self::Error> {
        fn convert(date: Option<ProtoDate>) -> Result<Option<Date>, Status> {
            match date {
                None => Ok(None),
                Some(date) => date.try_into().map(Some).map_err(Status::invalid_argument),
            }
        }
        let start = convert(start)?;
        let end = convert(end)?;
        Ok((start, end).try_into().map_err(Status::invalid_argument)?)
    }
}

impl From<TaskEstimate> for Duration {
    fn from(value: TaskEstimate) -> Self {
        Self {
            days: value.days,
            hours: value.hours,
            minutes: value.minutes,
        }
    }
}

impl TryFrom<Duration> for TaskEstimate {
    type Error = Status;

    fn try_from(value: Duration) -> Result<Self, Self::Error> {
        if value.days < 0 || value.hours < 0 || value.minutes < 0 {
            return Err(Status::invalid_argument(
                "Negative days, hours or minutes in estimate not supported",
            ));
        }
        Ok(Self {
            days: value.days,
            hours: value.hours,
            minutes: value.minutes,
        })
    }
}

impl From<&Date> for ProtoDate {
    fn from(value: &Date) -> Self {
        value.to_owned().into()
    }
}

impl From<TaskResponsible> for User {
    fn from(value: TaskResponsible) -> Self {
        User {
            id: value.id.into(),
            name: value.name,
            picture_url: value.picture_url.unwrap_or_default(),
        }
    }
}

impl From<TaskGroup> for Group {
    fn from(value: TaskGroup) -> Self {
        Group {
            id: value.id.into(),
            title: value.title,
            uid: value.uid.to_string(),
        }
    }
}

impl From<TaskRecurrenceFrequency> for RecurringEvery {
    fn from(value: TaskRecurrenceFrequency) -> Self {
        Self {
            days: value.days,
            months: value.months,
        }
    }
}

impl TryFrom<RecurringEvery> for TaskRecurrenceFrequency {
    type Error = Status;

    fn try_from(value: RecurringEvery) -> Result<Self, Self::Error> {
        if value.days < 0 || value.months < 0 {
            return Err(Status::invalid_argument(
                "Negative days or months in RecurringEvery not supported",
            ));
        }
        if value.days == 0 && value.months == 0 {
            return Err(Status::invalid_argument(
                "Either days or months must be greater in 0 in RecurringEvery",
            ));
        }
        Ok(Self {
            days: value.days,
            months: value.months,
        })
    }
}

impl From<TaskRecurrenceFrequency> for RecurringWhenChecked {
    fn from(value: TaskRecurrenceFrequency) -> Self {
        Self {
            days: value.days,
            months: value.months,
        }
    }
}

impl TryFrom<RecurringWhenChecked> for TaskRecurrenceFrequency {
    type Error = Status;

    fn try_from(value: RecurringWhenChecked) -> Result<Self, Self::Error> {
        if value.days < 0 || value.months < 0 {
            return Err(Status::invalid_argument(
                "Negative days or months in RecurringWhenChecked not supported",
            ));
        }
        if value.days == 0 && value.months == 0 {
            return Err(Status::invalid_argument(
                "Either days or months must be greater in 0 in RecurringWhenChecked",
            ));
        }
        Ok(Self {
            days: value.days,
            months: value.months,
        })
    }
}
