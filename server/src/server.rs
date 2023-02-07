use std::net::SocketAddr;

use anyhow::{Context, Result};
use tokio::signal;
use tonic::{codegen::CompressionEncoding, transport::Server};

use crate::{
    db::Database,
    service::{SurvivalServer, SurvivalService, FILE_DESCRIPTOR_SET},
};

pub async fn start(addr: SocketAddr) -> Result<()> {
    let database = Database::new()
        .await
        .context("should be able to connect to database")?;

    database
        .migrate()
        .await
        .context("should be able to migrate database")?;

    let reflection = tonic_reflection::server::Builder::configure()
        .register_encoded_file_descriptor_set(FILE_DESCRIPTOR_SET)
        .build()
        .context("reflection service build failed")?;

    let service = SurvivalService::new(database);
    let server = SurvivalServer::new(service)
        .accept_compressed(CompressionEncoding::Gzip)
        .send_compressed(CompressionEncoding::Gzip);

    Server::builder()
        .add_service(reflection)
        .add_service(server)
        .serve_with_shutdown(addr, create_signal())
        .await?;

    Ok(())
}

async fn create_signal() {
    signal::ctrl_c()
        .await
        .expect("failed to create shutdown signal")
}
