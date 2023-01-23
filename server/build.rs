use sqlx::postgres::PgPoolOptions;
use std::env;

mod container;
use container::error::Error;

#[tokio::main]
async fn main() -> Result<(), Error> {
    if Ok("release".to_string()) == env::var("PROFILE") {
        return Ok(());
    }

    println!("cargo:rerun-if-changed=migrations");

    container::cleanup()?;
    container::setup()?;

    let pool = PgPoolOptions::new()
        .connect("postgresql://postgres:postgres@127.0.0.1:5435/postgres")
        .await?;

    sqlx::migrate!().run(&pool).await?;

    Ok(())
}
