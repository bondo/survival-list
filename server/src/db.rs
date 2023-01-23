use dotenv::dotenv;
use sqlx::{migrate::MigrateError, postgres::PgPoolOptions, types::time::Date, PgPool};
use std::{env, fs};

pub struct Database {
    pool: PgPool,
}

#[derive(Debug)]
pub struct GetTasksResult {
    pub id: i32,
    pub title: Option<String>,
    pub start_date: Option<Date>,
    pub end_date: Option<Date>,
}

impl Database {
    pub async fn new() -> Result<Self, sqlx::Error> {
        let url = fs::read_to_string("/secrets/POSTGRES_CONNECTION").unwrap_or_else(|_| {
            dotenv().ok();
            env::var("DATABASE_URL").expect(
                "File /secrets/POSTGRES_CONNECTION or environment variable DATABASE_URL missing",
            )
        });
        let pool = PgPoolOptions::new().connect(url.as_str()).await?;
        Ok(Database { pool })
    }

    pub async fn migrate(&self) -> Result<(), MigrateError> {
        sqlx::migrate!().run(&self.pool).await
    }

    pub async fn get_tasks(&self) -> Result<Vec<GetTasksResult>, sqlx::Error> {
        sqlx::query_as!(
            GetTasksResult,
            "
                SELECT
                    id,
                    title,
                    start_date,
                    end_date
                FROM
                    tasks
            "
        )
        .fetch_all(&self.pool)
        .await
    }
}
