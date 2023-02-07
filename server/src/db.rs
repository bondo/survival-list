use futures_core::stream::Stream;
use futures_util::stream::StreamExt;
use std::{env, fs};

use anyhow::Result;
use dotenvy::dotenv;
use sqlx::{self, migrate::MigrateError, postgres::PgPoolOptions, PgPool};
use tonic::Status;

#[derive(Clone)]
pub struct Database {
    pool: PgPool,
}

pub struct GetTasksResult {
    pub id: i32,
    pub title: Option<String>,
}

pub struct CreateTaskResult {
    pub id: i32,
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

    pub fn get_tasks<'a>(&'a self) -> impl Stream<Item = Result<GetTasksResult, Status>> + 'a {
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
        .fetch(&self.pool)
        .map(|i| i.or(Err(Status::internal("unexpected error loading tasks"))))
    }

    pub async fn create_task(&self, title: &str) -> Result<CreateTaskResult, Status> {
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
        .map_err(|_| Status::internal("Failed to create task"))
    }
}
