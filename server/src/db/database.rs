use std::{env, fs};

use anyhow::Result;
use dotenvy::dotenv;
use sqlx::{self, migrate::MigrateError, postgres::PgPoolOptions, PgPool};

#[derive(Clone)]
pub struct Database {
    pub(super) pool: PgPool,
}

impl Database {
    pub async fn new() -> Result<Self, sqlx::Error> {
        let url = fs::read_to_string("/secrets/POSTGRES_CONNECTION/latest").unwrap_or_else(|_| {
            dotenv().ok();
            env::var("DATABASE_URL").expect(
                "File /secrets/POSTGRES_CONNECTION/latest or environment variable DATABASE_URL missing",
            )
        });

        let pool = PgPoolOptions::new().connect(url.as_str()).await?;

        Ok(Database { pool })
    }

    pub async fn migrate(&self) -> Result<(), MigrateError> {
        sqlx::migrate!().run(&self.pool).await
    }
}
