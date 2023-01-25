use std::{fmt, str};

use axum::http::StatusCode;

#[derive(Debug)]
pub enum ClientError {
    BadRequest(String),
}

impl std::error::Error for ClientError {}

impl ClientError {
    fn status(&self) -> StatusCode {
        match self {
            Self::BadRequest(_) => StatusCode::BAD_REQUEST,
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
        write!(f, "client error: ")?;
        match self {
            Self::BadRequest(e) => write!(f, "bad request: {e}"),
        }
    }
}

#[derive(Debug)]
pub enum ServerError {
    HyperHttpError(hyper::http::Error),
    SqlxError(sqlx::Error),
}

impl std::error::Error for ServerError {}

impl ServerError {
    fn status(&self) -> StatusCode {
        StatusCode::INTERNAL_SERVER_ERROR
    }
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
        write!(f, "server error")?;
        if cfg!(debug_assertions) {
            match self {
                Self::HyperHttpError(e) => write!(f, ": hyper http error: {e}"),
                Self::SqlxError(e) => write!(f, ": sqlx error: {e}"),
            }?
        }
        Ok(())
    }
}

#[derive(Debug)]
pub enum Error {
    ClientError(ClientError),
    ServerError(ServerError),
}

impl std::error::Error for Error {}

impl Error {
    pub fn status(&self) -> StatusCode {
        match self {
            Self::ClientError(e) => e.status(),
            Self::ServerError(e) => e.status(),
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
            Self::ClientError(e) => e.fmt(f),
            Self::ServerError(e) => e.fmt(f),
        }
    }
}
