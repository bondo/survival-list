use std::net::SocketAddr;

use anyhow::{Context, Result};
use axum::Server;

use crate::{db::Database, router, state::State};

pub async fn start(addr: SocketAddr) -> Result<()> {
    let database = Database::new()
        .await
        .context("should be able to connect to database")?;

    database
        .migrate()
        .await
        .context("should be able to migrate database")?;

    let state = State::new(database);

    let app = router::build(state);

    let make_service = app.into_make_service();

    Server::bind(&addr)
        .serve(make_service)
        .with_graceful_shutdown(shutdown_signal())
        .await?;

    Ok(())
}

async fn shutdown_signal() {
    // Wait for the CTRL+C signal
    tokio::signal::ctrl_c()
        .await
        .expect("failed to install CTRL+C signal handler");
}
