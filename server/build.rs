use dotenv::dotenv;
use sqlx::postgres::PgPoolOptions;
use std::env;

mod container;
use container::error::Error;

#[tokio::main]
async fn main() -> Result<(), Error> {
    if Ok("release".to_string()) == env::var("PROFILE") {
        return Ok(());
    }

    dotenv().ok();
    let database_url = env::var("DATABASE_URL").expect("Environment variable DATABASE_URL missing");

    println!("cargo:rerun-if-changed=migrations");

    container::cleanup()?;
    container::setup()?;

    let pool = PgPoolOptions::new().connect(database_url.as_str()).await?;

    sqlx::migrate!().run(&pool).await?;

    Ok(())
}