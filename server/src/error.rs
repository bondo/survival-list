use tonic::Status;
use tracing::error;

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

pub type Result<T> = std::result::Result<T, Error>;

impl From<Error> for Status {
    fn from(value: Error) -> Self {
        match &value {
            Error::Anyhow(e) => {
                error!("{value}: {e:?}\n");
                Status::internal(value.to_string())
            }
            Error::InternalState(e) => {
                error!("{value}: {e:?}\n");
                Status::internal(value.to_string())
            }
            Error::InvalidArgument(message) => Status::invalid_argument(*message),
            Error::NotFound(message) => Status::not_found(*message),
            Error::PermissionDenied(message) => Status::permission_denied(*message),
        }
    }
}
