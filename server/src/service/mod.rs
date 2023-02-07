use futures_util::pin_mut;
use futures_util::stream::StreamExt;
use log::error;
use tokio::sync::mpsc;
use tokio_stream::wrappers::ReceiverStream;
use tonic::{Request, Response, Status};

mod gen;

use self::gen::survival::TaskResponse;
use self::gen::survival::{survival_server::Survival, CreateTaskRequest, GetTasksRequest};
use crate::db::{Database, TaskResult};

pub use self::gen::survival::survival_server::SurvivalServer;
pub use self::gen::FILE_DESCRIPTOR_SET;

pub struct SurvivalService {
    db: Database,
}

impl SurvivalService {
    pub fn new(db: Database) -> Self {
        Self { db }
    }
}

impl From<TaskResult> for TaskResponse {
    fn from(task: TaskResult) -> Self {
        TaskResponse {
            id: task.id,
            title: task.title.unwrap_or_else(|| {
                error!("Got task without title (id {})", task.id);
                "N/A".to_string()
            }),
        }
    }
}

#[tonic::async_trait]
impl Survival for SurvivalService {
    async fn create_task(
        &self,
        request: Request<CreateTaskRequest>,
    ) -> Result<Response<TaskResponse>, Status> {
        let request = request.into_inner();
        let value = self.db.create_task(&request.title).await?;
        Ok(Response::new(value.into()))
    }

    type GetTasksStream = ReceiverStream<Result<TaskResponse, Status>>;
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
                tx.send(res.map(Into::into)).await.unwrap();
            }
        });

        Ok(Response::new(ReceiverStream::new(rx)))
    }
}
