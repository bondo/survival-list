use futures_core::stream::Stream;
use futures_util::stream::StreamExt;
use std::{env, fmt::Display, fs};

use anyhow::Result;
use dotenvy::dotenv;
use sqlx::{
    self, migrate::MigrateError, postgres::PgPoolOptions, types::time::PrimitiveDateTime, PgPool,
};
use tonic::Status;

#[derive(Clone)]
pub struct Database {
    pool: PgPool,
}

#[derive(Clone, Copy, Debug, sqlx::Type)]
#[sqlx(transparent)]
pub struct TaskId(i32);

impl TaskId {
    pub fn new(id: i32) -> Self {
        Self(id)
    }
}

impl Into<i32> for TaskId {
    fn into(self) -> i32 {
        self.0
    }
}

impl Display for TaskId {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        self.0.fmt(f)
    }
}

#[derive(Debug)]
pub struct TaskResult {
    pub id: TaskId,
    pub title: Option<String>,
}

#[derive(Debug)]
pub struct ToggleResult {
    pub id: TaskId,
    pub completed_at: Option<PrimitiveDateTime>,
}

#[derive(Debug)]
pub struct DeleteResult {
    pub id: TaskId,
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

    #[allow(clippy::needless_lifetimes)]
    pub fn get_tasks<'a>(&'a self) -> impl Stream<Item = Result<TaskResult, Status>> + 'a {
        sqlx::query_as!(
            TaskResult,
            r#"
                SELECT
                    id as "id: TaskId",
                    title
                FROM
                    tasks
            "#
        )
        .fetch(&self.pool)
        .map(|i| i.or(Err(Status::internal("unexpected error loading tasks"))))
    }

    pub async fn create_task(&self, title: &str) -> Result<TaskResult, Status> {
        sqlx::query_as!(
            TaskResult,
            r#"
                INSERT INTO tasks (
                    title
                )
                VALUES (
                    $1
                )
                RETURNING
                    id as "id: TaskId",
                    title
            "#,
            title
        )
        .fetch_one(&self.pool)
        .await
        .map_err(|_| Status::internal("Failed to create task"))
    }

    pub async fn update_task(&self, id: TaskId, title: &str) -> Result<TaskResult, Status> {
        sqlx::query_as!(
            TaskResult,
            r#"
                UPDATE
                    tasks
                SET
                    title = $2
                WHERE
                    id = $1
                RETURNING
                    id as "id: TaskId",
                    title
            "#,
            id.0,
            title,
        )
        .fetch_one(&self.pool)
        .await
        .map_err(|_| Status::internal("Failed to update task"))
    }

    pub async fn toggle_task_completed(
        &self,
        id: TaskId,
        is_completed: bool,
    ) -> Result<ToggleResult, Status> {
        sqlx::query_as!(
            ToggleResult,
            r#"
                UPDATE
                    tasks
                SET
                    completed_at = CASE
                        WHEN $2 THEN CURRENT_TIMESTAMP AT TIME ZONE 'UTC'
                        ELSE NULL
                    END
                WHERE
                    id = $1
                RETURNING
                    id as "id: TaskId",
                    completed_at
            "#,
            id.0,
            is_completed,
        )
        .fetch_one(&self.pool)
        .await
        .map_err(|_| Status::internal("Failed to update task"))
    }

    pub async fn delete_task(&self, id: TaskId) -> Result<TaskId, Status> {
        sqlx::query_as!(
            DeleteResult,
            r#"
                DELETE FROM
                    tasks
                WHERE
                    id = $1
                RETURNING
                    id as "id: TaskId"
            "#,
            id.0,
        )
        .fetch_one(&self.pool)
        .await
        .map_err(|_| Status::internal("Failed to update task"))
        .map(|result| result.id)
    }
}
