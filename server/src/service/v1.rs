use futures_util::pin_mut;
use futures_util::stream::StreamExt;
use log::error;
use tokio::sync::mpsc;
use tokio_stream::wrappers::ReceiverStream;
use tonic::{Request, Response, Status};

use crate::db::{Database, TaskId};

include!("proto/api.v1.rs");

pub struct Service {
    db: Database,
}

impl Service {
    pub fn new(db: Database) -> Self {
        Self { db }
    }
}

#[tonic::async_trait]
impl api_server::Api for Service {
    async fn create_task(
        &self,
        request: Request<CreateTaskRequest>,
    ) -> Result<Response<CreateTaskResponse>, Status> {
        let request = request.into_inner();
        let task = self.db.create_task(&request.title).await?;
        Ok(Response::new(CreateTaskResponse {
            id: task.id.into(),
            title: task.title.unwrap_or_else(|| {
                error!("v1:create_task: Got task without title (id {})", task.id);
                "N/A".to_string()
            }),
        }))
    }

    async fn update_task(
        &self,
        request: Request<UpdateTaskRequest>,
    ) -> Result<Response<UpdateTaskResponse>, Status> {
        let request = request.into_inner();
        let task = self
            .db
            .update_task(TaskId::new(request.id), &request.title)
            .await?;
        Ok(Response::new(UpdateTaskResponse {
            id: task.id.into(),
            title: task.title.unwrap_or_else(|| {
                error!("v1:update_task: Got task without title (id {})", task.id);
                "N/A".to_string()
            }),
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
                }))
                .await
                .unwrap();
            }
        });

        Ok(Response::new(ReceiverStream::new(rx)))
    }
}
