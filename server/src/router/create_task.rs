use axum::{extract, response::IntoResponse, Json};
use hyper::StatusCode;
use serde::Deserialize;
use serde_json::json;

use crate::{
    response::{ErrorResponse, SuccessResponse},
    state::State,
};

#[derive(Deserialize)]
pub struct CreateTaskPayload {
    title: String,
}

pub async fn handler(
    extract::State(state): extract::State<State>,
    Json(payload): Json<CreateTaskPayload>,
) -> impl IntoResponse {
    match state.db.create_task(&payload.title).await {
        Ok(value) => SuccessResponse {
            status: StatusCode::CREATED,
            value: json!(value),
        }
        .into_response(),
        Err(error) => ErrorResponse {
            error: error.into(),
        }
        .into_response(),
    }
}
