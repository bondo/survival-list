use axum::{
    response::{IntoResponse, Response},
    Json,
};
use hyper::StatusCode;
use serde_json::{json, Value};

use crate::error::Error;

pub struct SuccessResponse {
    pub status: StatusCode,
    pub value: Value,
}

impl IntoResponse for SuccessResponse {
    fn into_response(self) -> Response {
        (self.status, Json(json!({"result":self.value}))).into_response()
    }
}

pub struct ErrorResponse {
    pub error: Error,
}

impl IntoResponse for ErrorResponse {
    fn into_response(self) -> Response {
        (
            self.error.status(),
            Json(json!({ "result": format!("{}", self.error) })),
        )
            .into_response()
    }
}
