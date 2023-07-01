use anyhow::Context;
use futures_core::stream::Stream;
use futures_util::stream::StreamExt;
use sqlx::types::Uuid;
use std::fmt::Display;

use super::{Database, Transaction, UserId};
use crate::error::Error;

#[derive(Clone, Copy, Debug, sqlx::Type)]
#[sqlx(transparent)]
pub struct GroupId(pub(super) i32);

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
    pub uid: Uuid,
}

#[derive(Debug)]
pub struct DeleteResult {
    pub id: GroupId,
}

impl Database {
    pub fn get_user_groups(
        &self,
        user_id: UserId,
    ) -> impl Stream<Item = Result<GroupResult, Error>> + '_ {
        sqlx::query_as!(
            GroupResult,
            r#"
                SELECT
                    g.id as "id: GroupId",
                    g.title,
                    g.uid
                FROM
                    groups g
                INNER JOIN
                    users_groups ug ON
                        ug.group_id = g.id
                WHERE
                    ug.user_id = $1
                ORDER BY
                    g.created_at
            "#,
            user_id.0
        )
        .fetch(self)
        .map(|v| v.context("Error loading user groups").map_err(Into::into))
    }

    pub async fn create_and_join_group(
        &self,
        user_id: UserId,
        title: &str,
    ) -> Result<GroupResult, Error> {
        self.in_transaction(|tx| {
            Box::pin(async {
                let group = tx.create_group(title).await?;

                tx.join_group(user_id, group.id).await?;

                Ok(group)
            })
        })
        .await
    }

    pub async fn join_group_by_uid(
        &self,
        user_id: UserId,
        uid: &Uuid,
    ) -> Result<GroupResult, Error> {
        self.in_transaction(|tx| {
            Box::pin(async {
                let group = tx.get_group_by_uid(uid).await?;

                tx.join_group(user_id, group.id).await?;

                Ok(group)
            })
        })
        .await
    }

    pub async fn update_group(
        &self,
        user_id: UserId,
        group_id: GroupId,
        title: &str,
    ) -> Result<GroupResult, Error> {
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
                    title,
                    uid
            "#,
            user_id.0,
            group_id.0,
            title
        )
        .fetch_one(self)
        .await
        .context("Failed to update group")
        .map_err(Into::into)
    }

    pub async fn leave_group(&self, user_id: UserId, group_id: GroupId) -> Result<GroupId, Error> {
        self.in_transaction(|tx| {
            Box::pin(async {
                // Unset task group where viewer is responsible
                tx.unset_task_group_for_responsible(group_id, user_id)
                    .await?;

                // Remove viewer from group
                tx.remove_user_from_group(user_id, group_id).await?;

                tx.delete_group_if_empty(group_id).await?;

                Ok(group_id)
            })
        })
        .await
    }
}

impl<'c> Transaction<'c> {
    pub async fn remove_user_from_group(
        &mut self,
        user_id: UserId,
        group_id: GroupId,
    ) -> Result<(), Error> {
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
        .execute(self)
        .await
        .context("Failed to leave group")?;
        Ok(())
    }

    pub async fn unset_task_group_for_responsible(
        &mut self,
        group_id: GroupId,
        responsible_id: UserId,
    ) -> Result<(), Error> {
        sqlx::query!(
            r#"
                UPDATE
                    tasks t
                SET
                    group_id = NULL
                WHERE
                    t.responsible_user_id = $1 AND
                    t.group_id = $2
            "#,
            responsible_id.0,
            group_id.0,
        )
        .execute(self)
        .await
        .context("Failed to leave group")?;
        Ok(())
    }

    pub async fn create_group(&mut self, title: &str) -> Result<GroupResult, Error> {
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
                    title,
                    uid
            "#,
            title
        )
        .fetch_one(self)
        .await
        .context("Failed to create group")
        .map_err(Into::into)
    }

    pub async fn get_group_by_uid(&mut self, uid: &Uuid) -> Result<GroupResult, Error> {
        sqlx::query_as!(
            GroupResult,
            r#"
                SELECT
                    id as "id: GroupId",
                    title,
                    uid
                FROM
                    groups
                WHERE
                    uid = $1
            "#,
            uid
        )
        .fetch_one(self)
        .await
        .map_err(|_| Error::NotFound("Group not found"))
    }

    pub async fn join_group(&mut self, user_id: UserId, group_id: GroupId) -> Result<(), Error> {
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
        .execute(self)
        .await
        .context("Failed to update group")?;

        Ok(())
    }

    pub async fn delete_group_if_empty(&mut self, group_id: GroupId) -> Result<(), Error> {
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
        .execute(self)
        .await
        .context("Failed to delete group")?;

        Ok(())
    }
}
