use futures_util::pin_mut;
use futures_util::stream::StreamExt;
use sqlx::types::{time::Date, Uuid};
use tokio::sync::mpsc;
use tokio_stream::wrappers::ReceiverStream;
use tonic::{Request, Response, Status};

use crate::{
    db::{
        CategoryId, CreateTaskParams, Database, GroupId, SubcategoryId, SubcategoryResult,
        TaskEstimate, TaskGroup, TaskId, TaskPeriod, TaskRecurrenceEvery, TaskRecurrenceFrequency,
        TaskRecurrenceInput, TaskRecurrenceOutput, TaskResponsible, TaskResult, UpdateTaskParams,
        UserId,
    },
    AuthExtension, Error, Result,
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
    fn get_user_uid<T>(&self, request: &Request<T>) -> Result<String> {
        if let Some(auth) = request.extensions().get::<AuthExtension>() {
            Ok(auth.uid.clone())
        } else {
            Err(Error::InternalState("failed to read user uid"))
        }
    }

    async fn get_user_id<T>(&self, request: &Request<T>) -> Result<UserId> {
        let uid = self.get_user_uid(request)?;
        self.db.upsert_user_id(&uid).await
    }
}

#[tonic::async_trait]
impl api_server::Api for Service {
    async fn login(
        &self,
        request: Request<LoginRequest>,
    ) -> std::result::Result<Response<LoginResponse>, Status> {
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
    ) -> std::result::Result<Response<CreateTaskResponse>, Status> {
        let user_id = self.get_user_id(&request).await?;
        let request = request.into_inner();

        let task = self
            .db
            .create_task(CreateTaskParams {
                user_id,
                responsible_id: if request.responsible_id == i32::default() {
                    user_id
                } else {
                    UserId::new(request.responsible_id)
                },
                title: request.title,
                period: (request.start_date, request.end_date).try_into()?,
                group_id: if request.group_id == i32::default() {
                    None
                } else {
                    Some(GroupId::new(request.group_id))
                },
                category_id: if request.category_id == i32::default() {
                    None
                } else {
                    Some(CategoryId::new(request.category_id))
                },
                subcategory_id: if request.subcategory_id == i32::default() {
                    None
                } else {
                    Some(SubcategoryId::new(request.subcategory_id))
                },
                estimate: request.estimate.map(TryInto::try_into).transpose()?,
                recurrence: request
                    .recurring
                    .map(|r| match r {
                        create_task_request::Recurring::Every(frequency) => {
                            frequency.try_into().map(TaskRecurrenceInput::Every)
                        }
                        create_task_request::Recurring::Checked(frequency) => {
                            frequency.try_into().map(TaskRecurrenceInput::Checked)
                        }
                    })
                    .transpose()?,
            })
            .await?;

        Ok(Response::new(task.into()))
    }

    async fn update_task(
        &self,
        request: Request<UpdateTaskRequest>,
    ) -> std::result::Result<Response<UpdateTaskResponse>, Status> {
        let user_id = self.get_user_id(&request).await?;
        let request = request.into_inner();

        let task = self
            .db
            .update_task(UpdateTaskParams {
                user_id,
                responsible_id: if request.responsible_id == i32::default() {
                    user_id
                } else {
                    UserId::new(request.responsible_id)
                },
                task_id: TaskId::new(request.id),
                title: request.title,
                period: (request.start_date, request.end_date).try_into()?,
                group_id: if request.group_id == i32::default() {
                    None
                } else {
                    Some(GroupId::new(request.group_id))
                },
                category_id: if request.category_id == i32::default() {
                    None
                } else {
                    Some(CategoryId::new(request.category_id))
                },
                subcategory_id: if request.subcategory_id == i32::default() {
                    None
                } else {
                    Some(SubcategoryId::new(request.subcategory_id))
                },
                estimate: request.estimate.map(TryInto::try_into).transpose()?,
                recurrence: request
                    .recurring
                    .map(|r| match r {
                        update_task_request::Recurring::Every(frequency) => {
                            frequency.try_into().map(TaskRecurrenceInput::Every)
                        }
                        update_task_request::Recurring::Checked(frequency) => {
                            frequency.try_into().map(TaskRecurrenceInput::Checked)
                        }
                    })
                    .transpose()?,
            })
            .await?;

        Ok(Response::new(task.into()))
    }

    async fn toggle_task_completed(
        &self,
        request: Request<ToggleTaskCompletedRequest>,
    ) -> std::result::Result<Response<ToggleTaskCompletedResponse>, Status> {
        let user_id = self.get_user_id(&request).await?;
        let request = request.into_inner();

        let result = self
            .db
            .toggle_task_completed(user_id, TaskId::new(request.id), request.is_completed)
            .await?;
        Ok(Response::new(ToggleTaskCompletedResponse {
            id: result.id.into(),
            is_completed: result.completed_at.is_some(),
            can_update: result.can_update,
            can_toggle: result.can_toggle,
            can_delete: result.can_delete,
            task_created: result.task_created.map(Into::into),
            task_deleted: result
                .task_deleted
                .map(|id| DeleteTaskResponse { id: id.into() }),
            task_updated: result.task_updated.map(Into::into),
        }))
    }

    async fn delete_task(
        &self,
        request: Request<DeleteTaskRequest>,
    ) -> std::result::Result<Response<DeleteTaskResponse>, Status> {
        let user_id = self.get_user_id(&request).await?;
        let request = request.into_inner();

        let id = self
            .db
            .delete_task(user_id, TaskId::new(request.id))
            .await?;

        Ok(Response::new(DeleteTaskResponse { id: id.into() }))
    }

    type GetTasksStream = ReceiverStream<std::result::Result<GetTasksResponse, Status>>;
    async fn get_tasks(
        &self,
        request: Request<GetTasksRequest>,
    ) -> std::result::Result<Response<Self::GetTasksStream>, Status> {
        let user_id = self.get_user_id(&request).await?;
        let (tx, rx) = mpsc::channel(10);

        let db = self.db.clone();
        tokio::spawn(async move {
            let tasks = db.get_tasks(user_id);
            pin_mut!(tasks);

            while let Some(res) = tasks.next().await {
                tx.send(
                    res.map(|task| GetTasksResponse {
                        id: task.id.into(),
                        title: task.title,
                        is_completed: task.completed_at.is_some(),
                        start_date: task.period.start().map(Into::into),
                        end_date: task.period.end().map(Into::into),
                        estimate: task.estimate.map(Into::into),
                        responsible: Some(task.responsible.into()),
                        group: task.group.map(Into::into),
                        recurring: task.recurrence.map(|r| match r {
                            TaskRecurrenceOutput::Every(every) => {
                                get_tasks_response::Recurring::Every(every.into())
                            }
                            TaskRecurrenceOutput::Checked(frequency) => {
                                get_tasks_response::Recurring::Checked(frequency.into())
                            }
                        }),
                        can_update: task.can_update,
                        can_toggle: task.can_toggle,
                        can_delete: task.can_delete,
                        is_friend_task: task.is_friend_task,
                        category_id: task.category_id.map(Into::into).unwrap_or_default(),
                        subcategory_id: task.subcategory_id.map(Into::into).unwrap_or_default(),
                    })
                    .map_err(Into::into),
                )
                .await
                .unwrap();
            }
        });

        Ok(Response::new(ReceiverStream::new(rx)))
    }

    async fn create_group(
        &self,
        request: Request<CreateGroupRequest>,
    ) -> std::result::Result<Response<CreateGroupResponse>, Status> {
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
    ) -> std::result::Result<Response<JoinGroupResponse>, Status> {
        let user_id = self.get_user_id(&request).await?;
        let request = request.into_inner();
        let uid =
            Uuid::parse_str(&request.uid).map_err(|_| Error::InvalidArgument("Invalid uid"))?;

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
    ) -> std::result::Result<Response<UpdateGroupResponse>, Status> {
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
    ) -> std::result::Result<Response<LeaveGroupResponse>, Status> {
        let user_id = self.get_user_id(&request).await?;
        let request = request.into_inner();

        let id = self
            .db
            .leave_group(user_id, GroupId::new(request.id))
            .await?;

        Ok(Response::new(LeaveGroupResponse { id: id.into() }))
    }

    async fn update_category(
        &self,
        request: Request<UpdateCategoryRequest>,
    ) -> std::result::Result<Response<UpdateCategoryResponse>, Status> {
        let user_id = self.get_user_id(&request).await?;
        let request = request.into_inner();

        let category = self
            .db
            .update_category(
                user_id,
                CategoryId::new(request.id),
                &request.color,
                request.is_enabled,
            )
            .await?;

        Ok(Response::new(UpdateCategoryResponse {
            id: category.id.into(),
            raw_title: category.raw_title,
            color: category.color.unwrap_or_default(),
            is_enabled: category.is_enabled,
            subcategories: category.subcategories.into_iter().map(Into::into).collect(),
        }))
    }

    async fn create_subcategory(
        &self,
        request: Request<CreateSubcategoryRequest>,
    ) -> std::result::Result<Response<CreateSubcategoryResponse>, Status> {
        let user_id = self.get_user_id(&request).await?;
        let request = request.into_inner();

        let subcategory = self
            .db
            .create_subcategory(
                user_id,
                CategoryId::new(request.category_id),
                &request.title,
                &request.color,
            )
            .await?;

        Ok(Response::new(CreateSubcategoryResponse {
            id: subcategory.id.into(),
            title: subcategory.title,
            color: subcategory.color.unwrap_or_default(),
        }))
    }

    async fn update_subcategory(
        &self,
        request: Request<UpdateSubcategoryRequest>,
    ) -> std::result::Result<Response<UpdateSubcategoryResponse>, Status> {
        let user_id = self.get_user_id(&request).await?;
        let request = request.into_inner();

        let subcategory = self
            .db
            .update_subcategory(
                user_id,
                SubcategoryId::new(request.id),
                &request.title,
                &request.color,
            )
            .await?;

        Ok(Response::new(UpdateSubcategoryResponse {
            id: subcategory.id.into(),
            title: subcategory.title,
            color: subcategory.color.unwrap_or_default(),
        }))
    }

    async fn delete_subcategory(
        &self,
        request: Request<DeleteSubcategoryRequest>,
    ) -> std::result::Result<Response<DeleteSubcategoryResponse>, Status> {
        let user_id = self.get_user_id(&request).await?;
        let request = request.into_inner();

        let id = self
            .db
            .delete_subcategory(user_id, SubcategoryId::new(request.id))
            .await?;

        Ok(Response::new(DeleteSubcategoryResponse { id: id.into() }))
    }

    type GetGroupsStream = ReceiverStream<std::result::Result<GetGroupsResponse, Status>>;
    async fn get_groups(
        &self,
        request: Request<GetGroupsRequest>,
    ) -> std::result::Result<Response<Self::GetGroupsStream>, Status> {
        let user_id = self.get_user_id(&request).await?;
        let (tx, rx) = mpsc::channel(10);

        let db = self.db.clone();
        tokio::spawn(async move {
            let groups = db.get_user_groups(user_id);
            pin_mut!(groups);

            while let Some(res) = groups.next().await {
                tx.send(
                    res.map(|group| GetGroupsResponse {
                        id: group.id.into(),
                        title: group.title,
                        uid: group.uid.to_string(),
                    })
                    .map_err(Into::into),
                )
                .await
                .unwrap();
            }
        });

        Ok(Response::new(ReceiverStream::new(rx)))
    }

    type GetGroupParticipantsStream =
        ReceiverStream<std::result::Result<GetGroupParticipantsResponse, Status>>;
    async fn get_group_participants(
        &self,
        request: Request<GetGroupParticipantsRequest>,
    ) -> std::result::Result<Response<Self::GetGroupParticipantsStream>, Status> {
        let user_id = self.get_user_id(&request).await?;
        let request = request.into_inner();
        let (tx, rx) = mpsc::channel(10);

        let db = self.db.clone();
        tokio::spawn(async move {
            let participants = db.get_group_participants(user_id, GroupId::new(request.group_id));
            pin_mut!(participants);

            while let Some(res) = participants.next().await {
                tx.send(
                    res.map(|user| GetGroupParticipantsResponse {
                        user: Some(User {
                            id: user.id.into(),
                            name: user.name,
                            picture_url: user.picture_url.unwrap_or_default(),
                        }),
                    })
                    .map_err(Into::into),
                )
                .await
                .unwrap();
            }
        });

        Ok(Response::new(ReceiverStream::new(rx)))
    }

    type GetCategoriesStream = ReceiverStream<std::result::Result<GetCategoriesResponse, Status>>;
    async fn get_categories(
        &self,
        request: Request<GetCategoriesRequest>,
    ) -> std::result::Result<Response<Self::GetCategoriesStream>, Status> {
        let user_id = self.get_user_id(&request).await?;
        let (tx, rx) = mpsc::channel(10);

        let db = self.db.clone();
        tokio::spawn(async move {
            let categories = db.get_categories(user_id);
            pin_mut!(categories);

            while let Some(res) = categories.next().await {
                tx.send(
                    res.map(|category| GetCategoriesResponse {
                        id: category.id.into(),
                        raw_title: category.raw_title,
                        color: category.color.unwrap_or_default(),
                        is_enabled: category.is_enabled,
                        subcategories: category.subcategories.into_iter().map(Into::into).collect(),
                    })
                    .map_err(Into::into),
                )
                .await
                .unwrap();
            }
        });

        Ok(Response::new(ReceiverStream::new(rx)))
    }
}

impl TryFrom<(Option<ProtoDate>, Option<ProtoDate>)> for TaskPeriod {
    type Error = Error;

    fn try_from((start, end): (Option<ProtoDate>, Option<ProtoDate>)) -> Result<Self> {
        fn convert(date: Option<ProtoDate>) -> Result<Option<Date>> {
            date.map(TryInto::try_into).transpose()
        }
        let start = convert(start)?;
        let end = convert(end)?;
        (start, end).try_into()
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
    type Error = Error;

    fn try_from(value: Duration) -> Result<Self> {
        if value.days < 0 || value.hours < 0 || value.minutes < 0 {
            return Err(Error::InvalidArgument(
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

impl From<TaskRecurrenceEvery> for RecurringEveryResponse {
    fn from(value: TaskRecurrenceEvery) -> Self {
        Self {
            days: value.frequency.days,
            months: value.frequency.months,
            num_ready_to_start: value.pending.num_ready_to_start,
            num_ready_to_start_is_lower_bound: value.pending.num_ready_to_start_is_lower_bound,
            num_reached_deadline: value.pending.num_reached_deadline,
            num_reached_deadline_is_lower_bound: value.pending.num_reached_deadline_is_lower_bound,
        }
    }
}

impl TryFrom<RecurringEveryRequest> for TaskRecurrenceFrequency {
    type Error = Error;

    fn try_from(value: RecurringEveryRequest) -> Result<Self> {
        if value.days < 0 || value.months < 0 {
            return Err(Error::InvalidArgument(
                "Negative days or months in RecurringEveryRequest not supported",
            ));
        }
        if value.days == 0 && value.months == 0 {
            return Err(Error::InvalidArgument(
                "Either days or months must be greater in 0 in RecurringEveryRequest",
            ));
        }
        Ok(Self {
            days: value.days,
            months: value.months,
        })
    }
}

impl From<TaskRecurrenceFrequency> for RecurringChecked {
    fn from(value: TaskRecurrenceFrequency) -> Self {
        Self {
            days: value.days,
            months: value.months,
        }
    }
}

impl TryFrom<RecurringChecked> for TaskRecurrenceFrequency {
    type Error = Error;

    fn try_from(value: RecurringChecked) -> Result<Self> {
        if value.days < 0 || value.months < 0 {
            return Err(Error::InvalidArgument(
                "Negative days or months in RecurringChecked not supported",
            ));
        }
        if value.days == 0 && value.months == 0 {
            return Err(Error::InvalidArgument(
                "Either days or months must be greater in 0 in RecurringChecked",
            ));
        }
        Ok(Self {
            days: value.days,
            months: value.months,
        })
    }
}

impl From<TaskResult> for CreateTaskResponse {
    fn from(value: TaskResult) -> Self {
        Self {
            id: value.id.into(),
            title: value.title,
            start_date: value.period.start().map(Into::into),
            end_date: value.period.end().map(Into::into),
            estimate: value.estimate.map(Into::into),
            responsible: Some(value.responsible.into()),
            group: value.group.map(Into::into),
            recurring: value.recurrence.map(|r| match r {
                TaskRecurrenceOutput::Every(every) => {
                    create_task_response::Recurring::Every(every.into())
                }
                TaskRecurrenceOutput::Checked(frequency) => {
                    create_task_response::Recurring::Checked(frequency.into())
                }
            }),
            can_update: value.can_update,
            can_toggle: value.can_toggle,
            can_delete: value.can_delete,
            category_id: value.category_id.map(Into::into).unwrap_or_default(),
            subcategory_id: value.subcategory_id.map(Into::into).unwrap_or_default(),
        }
    }
}

impl From<TaskResult> for UpdateTaskResponse {
    fn from(value: TaskResult) -> Self {
        Self {
            id: value.id.into(),
            title: value.title,
            is_completed: value.completed_at.is_some(),
            start_date: value.period.start().map(Into::into),
            end_date: value.period.end().map(Into::into),
            estimate: value.estimate.map(Into::into),
            responsible: Some(value.responsible.into()),
            group: value.group.map(Into::into),
            recurring: value.recurrence.map(|r| match r {
                TaskRecurrenceOutput::Every(every) => {
                    update_task_response::Recurring::Every(every.into())
                }
                TaskRecurrenceOutput::Checked(frequency) => {
                    update_task_response::Recurring::Checked(frequency.into())
                }
            }),
            can_update: value.can_update,
            can_toggle: value.can_toggle,
            can_delete: value.can_delete,
            category_id: value.category_id.map(Into::into).unwrap_or_default(),
            subcategory_id: value.subcategory_id.map(Into::into).unwrap_or_default(),
        }
    }
}

impl From<SubcategoryResult> for Subcategory {
    fn from(value: SubcategoryResult) -> Self {
        Self {
            id: value.id.into(),
            title: value.title,
            color: value.color.unwrap_or_default(),
        }
    }
}
