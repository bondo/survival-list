use std::fmt::Display;

use anyhow::Result;
use futures_core::Stream;
use futures_util::StreamExt;
use tonic::Status;

use super::{Database, GroupId};

#[derive(Clone, Copy, Debug, sqlx::Type, PartialEq, Eq)]
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
    pub fn get_group_participants<'a>(
        &'a self,
        user_id: UserId,
        group_id: GroupId,
    ) -> impl Stream<Item = Result<UserResult, Status>> + 'a {
        sqlx::query_as!(
            UserResult,
            r#"
                SELECT
                    u.id as "id: UserId",
                    u.uid,
                    u.name,
                    u.picture_url
                FROM
                    users u
                INNER JOIN
                    users_groups ug ON
                        ug.user_id = u.id
                WHERE
                    ug.group_id = $2 AND
                    EXISTS (
                        SELECT
                        FROM
                            users_groups viewer_groups
                        WHERE
                            viewer_groups.user_id = $1 AND
                            viewer_groups.group_id = $2
                    )
            "#,
            user_id.0,
            group_id.0
        )
        .fetch(self)
        .map(|i| {
            i.or(Err(Status::internal(
                "unexpected error loading group participants",
            )))
        })
    }

    pub async fn upsert_user_id(&self, uid: &str) -> Result<UserId, Status> {
        sqlx::query_scalar!(
            r#"
                INSERT INTO users (
                    uid,
                    name
                )
                VALUES (
                    $1,
                    '?'
                )
                ON CONFLICT (uid) DO UPDATE SET
                    -- No-op to allow RETURNING
                    uid = EXCLUDED.uid
                RETURNING
                    id as "id: UserId"
            "#,
            uid,
        )
        .fetch_one(self)
        .await
        .map_err(|_| Status::internal("Failed to upsert user id"))
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
                    name = EXCLUDED.name,
                    picture_url = EXCLUDED.picture_url
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
        .fetch_one(self)
        .await
        .map_err(|_| Status::internal("Failed to upsert user"))
    }
}
