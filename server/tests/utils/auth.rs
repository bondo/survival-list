use tonic::{service::Interceptor, Request, Status};

use server::{Auth, AuthExtension};

#[derive(Clone)]
pub(crate) struct AuthStub;

impl Interceptor for AuthStub {
    fn call(&mut self, mut request: Request<()>) -> std::result::Result<Request<()>, Status> {
        if let Some(uid) = request.metadata().get("test-user-uid") {
            let uid = uid.to_str().unwrap().to_owned();
            request.extensions_mut().insert(AuthExtension { uid });
            Ok(request)
        } else {
            Err(Status::unauthenticated("test-user-uid not set"))
        }
    }
}

impl Auth for AuthStub {}
