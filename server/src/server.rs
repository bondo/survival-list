use std::net::SocketAddr;

use anyhow::{Context, Result};
use tokio::signal;
use tonic::transport::Server;
use tracing::info;

use crate::{
    auth::Auth,
    db::Database,
    service::{build_ping_service, build_v1_service},
};

pub struct Options<A: Auth> {
    pub addr: SocketAddr,
    pub auth: A,
    pub database_url: String,
}

pub async fn start<A: Auth>(options: Options<A>) -> Result<()> {
    info!("Creating database connection");
    let database = Database::new(&options.database_url)
        .await
        .context("should be able to connect to database")?;

    info!("Migrating database");
    database
        .migrate()
        .await
        .context("should be able to migrate database")?;

    info!("Creating v1 service");
    let v1_service = build_v1_service(options.auth, &database);

    info!("Creating ping service");
    let ping_service = build_ping_service();

    info!("Building server");
    Server::builder()
        .add_service(v1_service)
        .add_service(ping_service)
        .serve_with_shutdown(options.addr, create_signal())
        .await?;

    Ok(())
}

async fn create_signal() {
    signal::ctrl_c()
        .await
        .expect("failed to create shutdown signal")
}
