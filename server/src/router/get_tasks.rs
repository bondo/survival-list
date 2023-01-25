use axum::{extract, response::IntoResponse};
use hyper::StatusCode;
use serde_json::json;

use crate::{
    response::{ErrorResponse, SuccessResponse},
    state::State,
};

pub async fn handler(extract::State(state): extract::State<State>) -> impl IntoResponse {
    match state.db.get_tasks().await {
        Ok(value) => SuccessResponse {
            status: StatusCode::OK,
            value: json!(value),
        }
        .into_response(),
        Err(error) => ErrorResponse {
            error: error.into(),
        }
        .into_response(),
    }
}
