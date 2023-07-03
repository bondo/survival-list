use tonic::{Request, Response, Status};

use super::proto::ping::v1::*;

pub struct Service;

#[tonic::async_trait]
impl ping_api_server::PingApi for Service {
    async fn ping(
        &self,
        _: Request<PingRequest>,
    ) -> std::result::Result<Response<PingResponse>, Status> {
        Ok(Response::new(PingResponse {
            message: "pong".to_string(),
        }))
    }
}
