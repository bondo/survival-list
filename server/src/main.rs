use std::{env, str};

use axum::{
    extract,
    http::StatusCode,
    response::{IntoResponse, Response},
    routing::{get, post},
    Json, Router,
};
use serde::Deserialize;
use serde_json::{json, Value};

mod db;
use db::Database;

mod error;
use error::Error;

mod state;
use state::State;

#[tokio::main]
async fn main() {
    pretty_env_logger::init();

    let port = env::var("PORT")
        .ok()
        .and_then(|p| p.parse().ok())
        .unwrap_or(8080);
    let addr = ([0, 0, 0, 0], port).into();

    let database: Database = Database::new()
        .await
        .expect("should be able to connect to database");

    database
        .migrate()
        .await
        .expect("should be able to migrate database");

    let state = State::new(database);

    let app = Router::new()
        .route("/task", post(create_task))
        .route("/tasks", get(get_tasks))
        .with_state(state);

    let make_service = app.into_make_service();

    let server = axum::Server::bind(&addr)
        .serve(make_service)
        .with_graceful_shutdown(shutdown_signal());

    println!("Listening on http://{}", addr);
    if let Err(e) = server.await {
        eprintln!("server error: {}", e);
    }
}

async fn shutdown_signal() {
    // Wait for the CTRL+C signal
    tokio::signal::ctrl_c()
        .await
        .expect("failed to install CTRL+C signal handler");
}

#[derive(Deserialize)]
struct CreateTaskPayload {
    title: String,
}

async fn create_task(
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

struct SuccessResponse {
    status: StatusCode,
    value: Value,
}

impl IntoResponse for SuccessResponse {
    fn into_response(self) -> Response {
        (self.status, Json(json!({"result":self.value}))).into_response()
    }
}

struct ErrorResponse {
    error: Error,
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

async fn get_tasks(extract::State(state): extract::State<State>) -> impl IntoResponse {
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
