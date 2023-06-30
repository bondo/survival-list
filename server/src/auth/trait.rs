use tonic::service::Interceptor;

pub trait Auth: Clone + Send + Interceptor + 'static {}

pub struct AuthExtension {
    pub uid: String,
}
