use tonic::{Request, Response, Status};

use crate::state::State;

mod gen;

use self::gen::survival::{
    survival_server::{self, Survival},
    CreateTaskReply, CreateTaskRequest, GetTasksReply, GetTasksRequest,
};

pub use survival_server::SurvivalServer;

pub static FILE_DESCRIPTOR_SET: &[u8] = include_bytes!("gen/descriptor");

pub struct SurvivalService {
    state: State,
}

impl SurvivalService {
    pub fn new(state: State) -> Self {
        Self { state }
    }
}

#[tonic::async_trait]
impl Survival for SurvivalService {
    async fn create_task(
        &self,
        request: Request<CreateTaskRequest>,
    ) -> Result<Response<CreateTaskReply>, Status> {
        let request = request.into_inner();
        let value = self.state.db.create_task(&request.title).await?;
        Ok(Response::new(CreateTaskReply { id: value.id }))
    }

    async fn get_tasks(
        &self,
        request: Request<GetTasksRequest>,
    ) -> Result<Response<GetTasksReply>, Status> {
        let _request = request.into_inner();
        let value = self.state.db.get_tasks().await?;
        Ok(Response::new(GetTasksReply {
            id: value.into_iter().map(|v| v.id).collect(),
        }))
    }
}
