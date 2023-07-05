use dotenvy::dotenv;
use sqlx::postgres::PgPoolOptions;
use std::env;

mod container;
use container::error::Error;

#[tokio::main]
async fn main() -> Result<(), Error> {
    if env::var("PROFILE").map(|s| s == "release").unwrap_or(false) {
        return Ok(());
    }

    tonic_build::configure()
        .out_dir("src/service/proto")
        .compile(
            &[
                "../proto/api/v1/api.proto",
                "../proto/google/type/date.proto",
                "../proto/ping/v1/ping.proto",
            ],
            &["../proto/"],
        )?;

    println!("cargo:rerun-if-changed=migrations");

    dotenv().ok();

    let offline = env::var("SQLX_OFFLINE")
        .map(|s| s.eq_ignore_ascii_case("true") || s == "1")
        .unwrap_or(false);
    if offline {
        return Ok(());
    }

    let database_url = env::var("DATABASE_URL").expect("Environment variable DATABASE_URL missing");

    container::cleanup()?;
    container::setup()?;

    let pool = PgPoolOptions::new().connect(database_url.as_str()).await?;

    sqlx::migrate!().run(&pool).await?;

    Ok(())
}
