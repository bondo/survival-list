use futures_core::stream::Stream;
use futures_util::stream::StreamExt;
use std::fmt::Display;

use anyhow::Result;
use tonic::Status;

use super::{database::Database, UserId};

#[derive(Clone, Copy, Debug, sqlx::Type)]
#[sqlx(transparent)]
pub struct GroupId(i32);

impl GroupId {
    pub fn new(id: i32) -> Self {
        Self(id)
    }
}

impl From<GroupId> for i32 {
    fn from(value: GroupId) -> Self {
        value.0
    }
}

impl Display for GroupId {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        self.0.fmt(f)
    }
}

#[derive(Debug)]
pub struct GroupResult {
    pub id: GroupId,
    pub title: String,
}

#[derive(Debug)]
pub struct DeleteResult {
    pub id: GroupId,
}

impl Database {
    #[allow(clippy::needless_lifetimes)]
    pub fn get_user_groups<'a>(
        &'a self,
        user_id: UserId,
    ) -> impl Stream<Item = Result<GroupResult, Status>> + 'a {
        sqlx::query_as!(
            GroupResult,
            r#"
                SELECT
                    g.id as "id: GroupId",
                    g.title
                FROM
                    groups g
                INNER JOIN
                    users_groups ug ON
                        ug.group_id = g.id
                WHERE
                    ug.user_id = $1
            "#,
            user_id.0
        )
        .fetch(&self.pool)
        .map(|i| {
            i.or(Err(Status::internal(
                "unexpected error loading user groups",
            )))
        })
    }

    pub async fn create_and_join_group(
        &self,
        user_id: UserId,
        title: &str,
    ) -> Result<GroupResult, Status> {
        let group = self.create_group(title).await?;

        self.join_group(user_id, group.id).await?;

        Ok(group)
    }

    async fn create_group(&self, title: &str) -> Result<GroupResult, Status> {
        sqlx::query_as!(
            GroupResult,
            r#"
                INSERT INTO groups (
                    title
                )
                VALUES (
                    $1
                )
                RETURNING
                    id as "id: GroupId",
                    title
            "#,
            title
        )
        .fetch_one(&self.pool)
        .await
        .map_err(|_| Status::internal("Failed to create group"))
    }

    pub async fn join_group(&self, user_id: UserId, group_id: GroupId) -> Result<(), Status> {
        // TODO: Check for invite? Generate random invite string?
        sqlx::query!(
            r#"
                INSERT INTO users_groups (
                    user_id,
                    group_id
                )
                VALUES (
                    $1,
                    $2
                )
            "#,
            user_id.0,
            group_id.0
        )
        .execute(&self.pool)
        .await
        .map_err(|_| Status::internal("Failed to update group"))?;

        Ok(())
    }

    pub async fn update_group(
        &self,
        user_id: UserId,
        group_id: GroupId,
        title: &str,
    ) -> Result<GroupResult, Status> {
        sqlx::query_as!(
            GroupResult,
            r#"
                UPDATE
                    groups g
                SET
                    title = $3
                WHERE
                    g.id = $2 AND
                    EXISTS (
                        SELECT
                        FROM
                            users_groups ug
                        WHERE
                            ug.group_id = g.id AND
                            ug.user_id = $1
                    )
                RETURNING
                    id as "id: GroupId",
                    title
            "#,
            user_id.0,
            group_id.0,
            title
        )
        .fetch_one(&self.pool)
        .await
        .map_err(|_| Status::internal("Failed to update group"))
    }

    async fn delete_group_if_empty(&self, group_id: GroupId) -> Result<(), Status> {
        sqlx::query!(
            r#"
                DELETE FROM
                    groups g
                WHERE
                    id = $1 AND
                    NOT EXISTS (
                        SELECT
                        FROM
                            users_groups ug
                        WHERE
                            ug.group_id = g.id
                    )
            "#,
            group_id.0,
        )
        .execute(&self.pool)
        .await
        .map_err(|_| Status::internal("Failed to delete group"))?;

        Ok(())
    }

    pub async fn leave_group(&self, user_id: UserId, group_id: GroupId) -> Result<GroupId, Status> {
        sqlx::query!(
            r#"
                DELETE FROM
                    users_groups ug
                WHERE
                    ug.user_id = $1 AND
                    ug.group_id = $2
            "#,
            user_id.0,
            group_id.0,
        )
        .execute(&self.pool)
        .await
        .map_err(|_| Status::internal("Failed to leave group"))?;

        self.delete_group_if_empty(group_id).await?;

        Ok(group_id)
    }
}
