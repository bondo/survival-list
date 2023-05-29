use futures_core::stream::Stream;
use futures_util::stream::StreamExt;
use sqlx::types::Uuid;
use std::fmt::Display;

use anyhow::Result;
use tonic::Status;

use super::{Database, Tx, UserId};

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
    ) -> impl Stream<Item = Result<GroupResult, Status>> + '_ {
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
            "#,
            user_id.0
        )
        .fetch(self)
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
        let mut tx = self.begin_transaction().await?;

        let result = async {
            let group = self.create_group(&mut tx, title).await?;

            self.join_group(&mut tx, user_id, group.id).await?;

            Ok(group)
        }
        .await;

        self.end_transaction(tx, result).await
    }

    pub async fn join_group_by_uid(
        &self,
        user_id: UserId,
        uid: &Uuid,
    ) -> Result<GroupResult, Status> {
        let mut tx = self.begin_transaction().await?;

        let result = async {
            let group = self.get_group_by_uid(&mut tx, uid).await?;

            self.join_group(&mut tx, user_id, group.id).await?;

            Ok(group)
        }
        .await;

        self.end_transaction(tx, result).await
    }

    async fn create_group(&self, tx: &mut Tx<'_>, title: &str) -> Result<GroupResult, Status> {
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
        .fetch_one(tx)
        .await
        .map_err(|_| Status::internal("Failed to create group"))
    }

    async fn get_group_by_uid(&self, tx: &mut Tx<'_>, uid: &Uuid) -> Result<GroupResult, Status> {
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
        .fetch_one(tx)
        .await
        .map_err(|_| Status::not_found("Group not found"))
    }

    async fn join_group(
        &self,
        tx: &mut Tx<'_>,
        user_id: UserId,
        group_id: GroupId,
    ) -> Result<(), Status> {
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
        .execute(tx)
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
                    title,
                    uid
            "#,
            user_id.0,
            group_id.0,
            title
        )
        .fetch_one(self)
        .await
        .map_err(|_| Status::internal("Failed to update group"))
    }

    async fn delete_group_if_empty(
        &self,
        tx: &mut Tx<'_>,
        group_id: GroupId,
    ) -> Result<(), Status> {
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
        .execute(tx)
        .await
        .map_err(|_| Status::internal("Failed to delete group"))?;

        Ok(())
    }

    pub async fn leave_group(&self, user_id: UserId, group_id: GroupId) -> Result<GroupId, Status> {
        let mut tx = self.begin_transaction().await?;

        let result = async {
            // Unset task group where viewer is responsible
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
                user_id.0,
                group_id.0,
            )
            .execute(&mut tx)
            .await
            .map_err(|_| Status::internal("Failed to leave group"))?;

            // Remove viewer from group
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
            .execute(&mut tx)
            .await
            .map_err(|_| Status::internal("Failed to leave group"))?;

            self.delete_group_if_empty(&mut tx, group_id).await?;

            Ok(group_id)
        }
        .await;

        self.end_transaction(tx, result).await
    }
}
