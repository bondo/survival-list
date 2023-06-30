use tonic::{Request, Response, Status};

use super::proto::api::ping::*;

pub struct Service;

#[tonic::async_trait]
impl api_server::Api for Service {
    async fn ping(&self, _: Request<PingRequest>) -> Result<Response<PingResponse>, Status> {
        Ok(Response::new(PingResponse {
            message: "pong".to_string(),
        }))
    }
}
