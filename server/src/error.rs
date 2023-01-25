use std::{error, fmt, str};

use hyper::StatusCode;

#[derive(Debug)]
pub enum ClientError {
    BadRequest(String),
    NotFoundError,
    PayloadTooLarge,
}

impl ClientError {
    fn status(&self) -> StatusCode {
        match self {
            Self::BadRequest(_) => StatusCode::BAD_REQUEST,
            Self::NotFoundError => StatusCode::NOT_FOUND,
            Self::PayloadTooLarge => StatusCode::PAYLOAD_TOO_LARGE,
        }
    }
}

impl From<hyper::Error> for ClientError {
    fn from(error: hyper::Error) -> Self {
        Self::BadRequest(format!("{error}"))
    }
}

impl From<serde_json::Error> for ClientError {
    fn from(error: serde_json::Error) -> Self {
        Self::BadRequest(format!("{error}"))
    }
}

impl From<str::Utf8Error> for ClientError {
    fn from(error: str::Utf8Error) -> Self {
        Self::BadRequest(format!("{error}"))
    }
}

impl fmt::Display for ClientError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Self::BadRequest(e) => write!(f, "bad request: {e}"),
            Self::NotFoundError => write!(f, "not found"),
            Self::PayloadTooLarge => write!(f, "payload too large"),
        }
    }
}

impl error::Error for ClientError {}

#[derive(Debug)]
pub enum ServerError {
    HyperHttpError(hyper::http::Error),
    SqlxError(sqlx::Error),
}

impl From<hyper::http::Error> for ServerError {
    fn from(error: hyper::http::Error) -> Self {
        Self::HyperHttpError(error)
    }
}

impl From<sqlx::Error> for ServerError {
    fn from(error: sqlx::Error) -> Self {
        Self::SqlxError(error)
    }
}

impl fmt::Display for ServerError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Self::HyperHttpError(e) => write!(f, "hyper http error: {}", e),
            Self::SqlxError(e) => write!(f, "sqlx error: {}", e),
        }
    }
}

impl error::Error for ServerError {}

#[derive(Debug)]
pub enum Error {
    ClientError(ClientError),
    ServerError(ServerError),
}

impl Error {
    pub fn status(&self) -> StatusCode {
        match self {
            Self::ClientError(e) => e.status(),
            Self::ServerError(_) => StatusCode::INTERNAL_SERVER_ERROR,
        }
    }
}

impl From<ClientError> for Error {
    fn from(error: ClientError) -> Self {
        Self::ClientError(error)
    }
}

impl From<ServerError> for Error {
    fn from(error: ServerError) -> Self {
        Self::ServerError(error)
    }
}

impl fmt::Display for Error {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Self::ClientError(e) => write!(f, "client error: {e}"),
            Self::ServerError(e) => {
                if cfg!(debug_assertions) {
                    write!(f, "server error: {e}")
                } else {
                    write!(f, "server error")
                }
            }
        }
    }
}

impl error::Error for Error {}
