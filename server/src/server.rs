use std::net::SocketAddr;

use anyhow::{Context, Result};
use tokio::signal;
use tonic::transport::Server;

use crate::{
    auth::Auth,
    db::Database,
    service::{build_reflection_service, build_v1_service},
};

pub async fn start(addr: SocketAddr) -> Result<()> {
    println!("Creating database connection");

    let database = Database::new()
        .await
        .context("should be able to connect to database")?;

    println!("Migrating database");

    database
        .migrate()
        .await
        .context("should be able to migrate database")?;

    println!("Creating auth instance");

    let auth = Auth::new().await;

    println!("Creating reflection service");

    let reflection_service =
        build_reflection_service().context("reflection service build failed")?;

    println!("Creating v1 service");

    let v1_service = build_v1_service(&auth, &database);

    println!("Building server");

    Server::builder()
        .add_service(reflection_service)
        .add_service(v1_service)
        .serve_with_shutdown(addr, create_signal())
        .await?;

    Ok(())
}

async fn create_signal() {
    signal::ctrl_c()
        .await
        .expect("failed to create shutdown signal")
}
