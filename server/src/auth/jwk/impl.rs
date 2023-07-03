use std::sync::Arc;

use tonic::{service::Interceptor, Request, Status};
use tracing::info;

use super::jwk_auth::JwkAuth;
use crate::{Auth, AuthExtension};

#[derive(Debug)]
struct User {
    uid: String,
}

#[derive(Clone)]
pub struct AuthImpl {
    jwk: Arc<JwkAuth>,
}

impl AuthImpl {
    pub async fn new() -> Self {
        Self {
            jwk: Arc::new(JwkAuth::new().await),
        }
    }

    fn get_authenticated_user(&self, request: &Request<()>) -> Option<User> {
        let token = request.metadata().get("authorization")?.to_str().ok()?;
        let user = self.parse_and_verify_auth_header(token)?;
        Some(user)
    }

    fn parse_and_verify_auth_header(&self, header: &str) -> Option<User> {
        let token = get_token_from_header(header)?;
        self.verify_token(&token)
    }

    fn verify_token(&self, token: &str) -> Option<User> {
        let verified_token = self.jwk.verify(token);
        info!("Verified token data: {verified_token:?}");
        verified_token.map(|token| User {
            uid: token.claims.sub,
        })
    }
}

impl Interceptor for AuthImpl {
    fn call(&mut self, mut request: Request<()>) -> std::result::Result<Request<()>, Status> {
        if let Some(user) = self.get_authenticated_user(&request) {
            info!("Authenticated user {user:?}");
            request
                .extensions_mut()
                .insert(AuthExtension { uid: user.uid });
            Ok(request)
        } else {
            info!("Token auth failed");
            Err(Status::unauthenticated("No valid auth token"))
        }
    }
}

impl Auth for AuthImpl {}

fn get_token_from_header(header: &str) -> Option<String> {
    let prefix_len = "Bearer ".len();

    match header.len() {
        l if l < prefix_len => None,
        _ => Some(header[prefix_len..].to_string()),
    }
}
