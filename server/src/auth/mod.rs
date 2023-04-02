use std::sync::Arc;

use log::info;
use tonic::{service::Interceptor, Request, Status};

use self::jwk_auth::JwkAuth;

mod fetch_keys;
mod get_max_age;
mod jwk;
mod jwk_auth;
mod verifier;

#[derive(Clone)]
pub struct Auth {
    jwk: Arc<JwkAuth>,
}

#[derive(Debug)]
struct User {
    uid: String,
}

impl Auth {
    pub async fn new() -> Self {
        Self {
            jwk: Arc::new(JwkAuth::new().await),
        }
    }

    fn get_authenticated_user(&mut self, request: &Request<()>) -> Option<User> {
        let token = request.metadata().get("authorization")?.to_str().ok()?;
        let user = self.parse_and_verify_auth_header(token)?;
        Some(user)
    }

    fn parse_and_verify_auth_header(&mut self, header: &str) -> Option<User> {
        let token = get_token_from_header(header)?;
        self.verify_token(&token)
    }

    fn verify_token(&mut self, token: &str) -> Option<User> {
        if cfg!(debug_assertions) {
            return Some(User {
                uid: "1234".to_string(),
            });
        }
        let verified_token = self.jwk.verify(token);
        info!("Verified token data: {verified_token:?}");
        verified_token.map(|token| User {
            uid: token.claims.sub,
        })
    }
}

pub struct AuthExtension {
    pub uid: String,
}

impl Interceptor for Auth {
    fn call(&mut self, mut request: Request<()>) -> Result<Request<()>, Status> {
        if let Some(user) = self.get_authenticated_user(&request) {
            info!("Authenticated user {user:?}, uid({})", user.uid);
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

fn get_token_from_header(header: &str) -> Option<String> {
    let prefix_len = "Bearer ".len();

    match header.len() {
        l if l < prefix_len => None,
        _ => Some(header[prefix_len..].to_string()),
    }
}
