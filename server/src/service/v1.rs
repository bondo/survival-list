use std::cmp::Ordering;

use futures_util::pin_mut;
use futures_util::stream::StreamExt;
use log::error;
use sqlx::types::time::Date;
use tokio::sync::mpsc;
use tokio_stream::wrappers::ReceiverStream;
use tonic::{Request, Response, Status};

use crate::db::{Database, TaskId, TaskPeriodInput};

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
        match (start_date, end_date) {
            (Some(start_date), None) => Ok(TaskPeriodInput::OnlyStart(
                Date::try_from(start_date).map_err(Status::invalid_argument)?,
            )),
            (None, Some(end_date)) => Ok(TaskPeriodInput::OnlyEnd(
                Date::try_from(end_date).map_err(Status::invalid_argument)?,
            )),
            (Some(start_date), Some(end_date)) => {
                let start = Date::try_from(start_date).map_err(Status::invalid_argument)?;
                let end = Date::try_from(end_date).map_err(Status::invalid_argument)?;

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

#[tonic::async_trait]
impl api_server::Api for Service {
    async fn create_task(
        &self,
        request: Request<CreateTaskRequest>,
    ) -> Result<Response<CreateTaskResponse>, Status> {
        let request = request.into_inner();
        let period = TaskPeriodInput::from_proto_dates(request.start_date, request.end_date)?;
        let task = self.db.create_task(&request.title, &period).await?;
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
        let request = request.into_inner();
        let period = TaskPeriodInput::from_proto_dates(request.start_date, request.end_date)?;
        let task = self
            .db
            .update_task(TaskId::new(request.id), &request.title, &period)
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
        let request = request.into_inner();
        let task = self
            .db
            .toggle_task_completed(TaskId::new(request.id), request.is_completed)
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
        let request = request.into_inner();
        let id = self.db.delete_task(TaskId::new(request.id)).await?;
        Ok(Response::new(DeleteTaskResponse { id: id.into() }))
    }

    type GetTasksStream = ReceiverStream<Result<GetTasksResponse, Status>>;
    async fn get_tasks(
        &self,
        _request: Request<GetTasksRequest>,
    ) -> Result<Response<Self::GetTasksStream>, Status> {
        let (tx, rx) = mpsc::channel(10);

        let db = self.db.clone();
        tokio::spawn(async move {
            let tasks = db.get_tasks();
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
}
