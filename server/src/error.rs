use log::error;
use tonic::Status;

#[derive(thiserror::Error, Debug)]
pub enum Error {
    #[error("an internal server error occurred")]
    Anyhow(#[from] anyhow::Error),

    #[error("an internal server error occurred")]
    InternalState(&'static str),

    #[error("{0}")]
    InvalidArgument(&'static str),

    #[error("{0}")]
    NotFound(&'static str),

    #[error("{0}")]
    PermissionDenied(&'static str),
}

impl From<Error> for Status {
    fn from(value: Error) -> Self {
        match &value {
            Error::Anyhow(e) => {
                error!("internal server error: {}", e);
                Status::internal(value.to_string())
            }
            Error::InternalState(e) => {
                error!("internal state error: {}", e);
                Status::internal(value.to_string())
            }
            Error::InvalidArgument(message) => Status::invalid_argument(*message),
            Error::NotFound(message) => Status::not_found(*message),
            Error::PermissionDenied(message) => Status::permission_denied(*message),
        }
    }
}
