use axum::{routing, Router};

use crate::state::State;

mod create_task;
mod get_tasks;

pub fn build(state: State) -> Router {
    Router::new()
        .route("/task", routing::post(create_task::handler))
        .route("/tasks", routing::get(get_tasks::handler))
        .with_state(state)
}
