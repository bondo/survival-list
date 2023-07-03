use std::{env, fs};

use anyhow::Context;
use dotenvy::dotenv;
use tracing::info;

pub(crate) use auth::{Auth, AuthExtension, AuthImpl};
pub(crate) use db::Database;
pub(crate) use error::{Error, Result};

mod auth;
mod db;
mod error;
mod server;
mod service;

#[cfg(test)]
mod tests;

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    pretty_env_logger::init();

    let port = std::env::var("PORT")
        .ok()
        .and_then(|p| p.parse().ok())
        .unwrap_or(8080);
    let addr = ([0, 0, 0, 0], port).into();

    info!("Listening on http://{addr}");

    let database_url =
        fs::read_to_string("/secrets/POSTGRES_CONNECTION/latest").unwrap_or_else(|_| {
            dotenv().ok();
            env::var("DATABASE_URL").expect(
            "File /secrets/POSTGRES_CONNECTION/latest or environment variable DATABASE_URL missing",
        )
        });

    info!("Creating auth instance");
    let auth = AuthImpl::new().await;

    let options = server::Options {
        addr,
        auth,
        database_url,
    };

    server::start(options).await.context("server startup error")
}
