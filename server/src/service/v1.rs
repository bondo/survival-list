use std::cmp::Ordering;

use futures_util::pin_mut;
use futures_util::stream::StreamExt;
use log::error;
use sqlx::types::time::Date;
use tokio::sync::mpsc;
use tokio_stream::wrappers::ReceiverStream;
use tonic::{Request, Response, Status};

use crate::{
    auth::AuthExtension,
    db::{Database, GroupId, TaskId, TaskPeriodInput, UserId},
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

impl TaskPeriodInput {
    fn from_proto_dates(
        start_date: Option<ProtoDate>,
        end_date: Option<ProtoDate>,
    ) -> Result<TaskPeriodInput, Status> {
        fn convert(date: ProtoDate) -> Result<Date, Status> {
            date.try_into().map_err(Status::invalid_argument)
        }

        match (start_date, end_date) {
            (Some(start_date), None) => Ok(TaskPeriodInput::OnlyStart(convert(start_date)?)),

            (None, Some(end_date)) => Ok(TaskPeriodInput::OnlyEnd(convert(end_date)?)),

            (Some(start_date), Some(end_date)) => {
                let start = convert(start_date)?;
                let end = convert(end_date)?;

                if end.cmp(&start) == Ordering::Less {
                    return Err(Status::failed_precondition("End before start"));
                }

                Ok(TaskPeriodInput::StartAndEnd { start, end })
            }

            (None, None) => Err(Status::failed_precondition(
                "Either start or end date required",
            )),
        }
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
        let picture_url: Option<&str> = {
            if request.picture_url.is_empty() {
                None
            } else {
                Some(&request.picture_url)
            }
        };
        self.db
            .upsert_user(&uid, &request.name, picture_url)
            .await?;
        Ok(Response::new(LoginResponse {}))
    }

    async fn create_task(
        &self,
        request: Request<CreateTaskRequest>,
    ) -> Result<Response<CreateTaskResponse>, Status> {
        let user_id = self.get_user_id(&request).await?;
        let request = request.into_inner();
        let period = TaskPeriodInput::from_proto_dates(request.start_date, request.end_date)?;
        let task = self
            .db
            .create_task(user_id, &request.title, &period)
            .await?;
        Ok(Response::new(CreateTaskResponse {
            id: task.id.into(),
            title: task.title.unwrap_or_else(|| {
                error!("v1:create_task: Got task without title (id {})", task.id);
                "N/A".to_string()
            }),
            start_date: task.start_date.map(Into::into),
            end_date: task.end_date.map(Into::into),
        }))
    }

    async fn update_task(
        &self,
        request: Request<UpdateTaskRequest>,
    ) -> Result<Response<UpdateTaskResponse>, Status> {
        let user_id = self.get_user_id(&request).await?;
        let request = request.into_inner();
        let period = TaskPeriodInput::from_proto_dates(request.start_date, request.end_date)?;
        let task = self
            .db
            .update_task(user_id, TaskId::new(request.id), &request.title, &period)
            .await?;
        Ok(Response::new(UpdateTaskResponse {
            id: task.id.into(),
            title: task.title.unwrap_or_else(|| {
                error!("v1:update_task: Got task without title (id {})", task.id);
                "N/A".to_string()
            }),
            is_completed: task.completed_at.is_some(),
            start_date: task.start_date.map(Into::into),
            end_date: task.end_date.map(Into::into),
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
                    start_date: task.start_date.map(Into::into),
                    end_date: task.end_date.map(Into::into),
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
                }))
                .await
                .unwrap();
            }
        });

        Ok(Response::new(ReceiverStream::new(rx)))
    }
}
