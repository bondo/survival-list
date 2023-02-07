use futures_util::pin_mut;
use futures_util::stream::StreamExt;
use tokio::sync::mpsc;
use tokio_stream::wrappers::ReceiverStream;
use tonic::{Request, Response, Status};

use crate::db::Database;

mod gen;

use self::gen::survival::{
    survival_server::Survival, CreateTaskReply, CreateTaskRequest, GetTasksReply, GetTasksRequest,
};

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

#[tonic::async_trait]
impl Survival for SurvivalService {
    async fn create_task(
        &self,
        request: Request<CreateTaskRequest>,
    ) -> Result<Response<CreateTaskReply>, Status> {
        let request = request.into_inner();
        let value = self.db.create_task(&request.title).await?;
        Ok(Response::new(CreateTaskReply { id: value.id }))
    }

    type GetTasksStream = ReceiverStream<Result<GetTasksReply, Status>>;
    async fn get_tasks(
        &self,
        _request: Request<GetTasksRequest>,
    ) -> Result<Response<Self::GetTasksStream>, Status> {
        let (tx, rx) = mpsc::channel(4);

        let db = self.db.clone();
        tokio::spawn(async move {
            let tasks = db.get_tasks();
            pin_mut!(tasks);

            while let Some(res) = tasks.next().await {
                tx.send(res.map(|task| GetTasksReply {
                    id: task.id,
                    title: task.title.unwrap_or("N/A".to_string()),
                }))
                .await
                .unwrap();
            }
        });

        Ok(Response::new(ReceiverStream::new(rx)))
    }
}
