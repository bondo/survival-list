use std;

use anyhow::{Context, Result};

mod db;
mod error;
mod response;
mod router;
mod server;
mod state;

#[tokio::main]
async fn main() -> Result<()> {
    pretty_env_logger::init();

    let port = std::env::var("PORT")
        .ok()
        .and_then(|p| p.parse().ok())
        .unwrap_or(8080);
    let addr = ([0, 0, 0, 0], port).into();

    println!("Listening on http://{}", addr);

    server::start(addr).await.context("server startup error")
}
