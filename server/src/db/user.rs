use std::fmt::Display;

use anyhow::Result;
use sqlx::{self};
use tonic::Status;

use super::database::Database;

#[derive(Clone, Copy, Debug, sqlx::Type)]
#[sqlx(transparent)]
pub struct UserId(pub(super) i32);

impl UserId {
    pub fn new(id: i32) -> Self {
        Self(id)
    }
}

impl From<UserId> for i32 {
    fn from(value: UserId) -> Self {
        value.0
    }
}

impl Display for UserId {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        self.0.fmt(f)
    }
}

#[derive(Debug)]
pub struct UserResult {
    pub id: UserId,
    pub uid: String,
    pub name: String,
    pub picture_url: Option<String>,
}

impl Database {
    pub async fn load_user_id(&self, uid: &str) -> Result<UserId, Status> {
        sqlx::query_scalar!(
            r#"
                SELECT
                    u.id as "id: UserId"
                FROM
                    users u
                WHERE
                    u.uid = $1
            "#,
            uid,
        )
        .fetch_one(&self.pool)
        .await
        .map_err(|_| Status::not_found("user does not exist"))
    }

    pub async fn upsert_user(
        &self,
        uid: &str,
        name: &str,
        picture_url: Option<&str>,
    ) -> Result<UserResult, Status> {
        sqlx::query_as!(
            UserResult,
            r#"
                INSERT INTO users (
                    uid,
                    name,
                    picture_url
                )
                VALUES (
                    $1,
                    $2,
                    $3
                )
                ON CONFLICT (uid) DO UPDATE SET
                    name = $2,
                    picture_url = $3
                RETURNING
                    id as "id: UserId",
                    uid,
                    name,
                    picture_url
            "#,
            uid,
            name,
            picture_url
        )
        .fetch_one(&self.pool)
        .await
        .map_err(|_| Status::internal("Failed to upsert user"))
    }
}
