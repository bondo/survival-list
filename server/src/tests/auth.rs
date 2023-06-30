use tonic::{service::Interceptor, Request, Status};

use crate::auth::{Auth, AuthExtension};

#[derive(Clone)]
pub struct AuthStub {
    uid: Option<String>,
}

impl AuthStub {
    pub fn new(uid: Option<String>) -> Self {
        Self { uid }
    }
}

impl Interceptor for AuthStub {
    fn call(&mut self, mut request: Request<()>) -> Result<Request<()>, Status> {
        if let Some(uid) = self.uid.clone() {
            request.extensions_mut().insert(AuthExtension { uid });
            Ok(request)
        } else {
            Err(Status::unauthenticated("No user authenticated"))
        }
    }
}

impl Auth for AuthStub {}
