use std::{env, fs};

use dotenvy::dotenv;
use serde::Serialize;
use sqlx::{migrate::MigrateError, postgres::PgPoolOptions, PgPool};

use crate::error::ServerError;

#[derive(Clone)]
pub struct Database {
    pool: PgPool,
}

#[derive(Serialize)]
pub struct GetTasksResult {
    pub id: i32,
    pub title: Option<String>,
}

#[derive(Serialize)]
pub struct CreateTaskResult {
    pub id: i32,
}

impl Database {
    pub async fn new() -> Result<Self, ServerError> {
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

    pub async fn get_tasks(&self) -> Result<Vec<GetTasksResult>, ServerError> {
        sqlx::query_as!(
            GetTasksResult,
            "
                SELECT
                    id,
                    title
                FROM
                    tasks
            "
        )
        .fetch_all(&self.pool)
        .await
        .map_err(|e| e.into())
    }

    pub async fn create_task(&self, title: &str) -> Result<CreateTaskResult, ServerError> {
        sqlx::query_as!(
            CreateTaskResult,
            r#"
                INSERT INTO tasks (
                    title
                )
                VALUES (
                    $1
                )
                RETURNING
                    id
            "#,
            title
        )
        .fetch_one(&self.pool)
        .await
        .map_err(|e| e.into())
    }
}
