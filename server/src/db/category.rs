use std::fmt::Display;

use anyhow::Context;
use futures_core::stream::Stream;
use futures_util::stream::StreamExt;
use serde::Deserialize;
use sqlx::types::Json;

use super::{Database, Transaction, UserId};
use crate::Result;

#[derive(Clone, Copy, Debug, sqlx::Type)]
#[sqlx(transparent)]
pub struct CategoryId(pub(super) i32);

impl CategoryId {
    pub fn new(id: i32) -> Self {
        Self(id)
    }
}

impl From<CategoryId> for i32 {
    fn from(value: CategoryId) -> Self {
        value.0
    }
}

impl Display for CategoryId {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        self.0.fmt(f)
    }
}

#[derive(Clone, Copy, Debug, sqlx::Type, Deserialize)]
#[sqlx(transparent)]
pub struct SubcategoryId(pub(super) i32);

impl SubcategoryId {
    pub fn new(id: i32) -> Self {
        Self(id)
    }
}

impl From<SubcategoryId> for i32 {
    fn from(value: SubcategoryId) -> Self {
        value.0
    }
}

impl Display for SubcategoryId {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        self.0.fmt(f)
    }
}

#[derive(Debug, Deserialize)]
pub struct SubcategoryResult {
    pub id: SubcategoryId,
    pub title: String,
    pub color: Option<String>,
}

#[derive(Debug)]
pub struct CategoryRawResult {
    pub id: CategoryId,
    pub raw_title: String,
    pub color: Option<String>,
    pub is_enabled: Option<bool>,
    pub subcategories: Option<Json<Vec<SubcategoryResult>>>,
}

#[derive(Debug)]
pub struct CategoryResult {
    pub id: CategoryId,
    pub raw_title: String,
    pub color: Option<String>,
    pub is_enabled: bool,
    pub subcategories: Vec<SubcategoryResult>,
}

impl From<CategoryRawResult> for CategoryResult {
    fn from(raw: CategoryRawResult) -> Self {
        Self {
            id: raw.id,
            raw_title: raw.raw_title,
            color: raw.color,
            is_enabled: raw.is_enabled.unwrap_or(true),
            subcategories: raw.subcategories.map(|json| json.0).unwrap_or_default(),
        }
    }
}

impl Database {
    pub fn get_categories(
        &self,
        user_id: UserId,
    ) -> impl Stream<Item = Result<CategoryResult>> + '_ {
        sqlx::query_as!(
            CategoryRawResult,
            r#"
                SELECT
                    c.id as "id: CategoryId",
                    c.raw_title,
                    co.color,
                    co.is_enabled as "is_enabled: Option<bool>",
                    (
                        SELECT
                            json_agg(json_build_object(
                                'id', s.id,
                                'title', s.title,
                                'color', s.color
                            ))
                        FROM
                            subcategories s
                        WHERE
                            s.category_id = c.id AND
                            s.user_id = $1
                    ) as "subcategories: Json<Vec<SubcategoryResult>>"
                FROM
                    categories c
                LEFT JOIN
                    categories_override co ON
                        co.category_id = c.id AND
                        co.user_id = $1
                ORDER BY
                    c.raw_title
            "#,
            user_id.0
        )
        .fetch(self)
        .map(|v| {
            v.context("Error loading user categories")
                .map(Into::into)
                .map_err(Into::into)
        })
    }

    pub async fn update_category(
        &self,
        user_id: UserId,
        category_id: CategoryId,
        color: &str,
        is_enabled: bool,
    ) -> Result<CategoryResult> {
        self.in_transaction(|tx| {
            Box::pin(async {
                tx.update_category(user_id, category_id, color, is_enabled)
                    .await?;
                tx.get_category(user_id, category_id).await
            })
        })
        .await
    }

    pub async fn create_subcategory(
        &self,
        user_id: UserId,
        category_id: CategoryId,
        title: &str,
        color: &str,
    ) -> Result<SubcategoryResult> {
        sqlx::query_as!(
            SubcategoryResult,
            r#"
                INSERT INTO subcategories (
                    user_id,
                    category_id,
                    title,
                    color
                ) VALUES (
                    $1,
                    $2,
                    $3,
                    $4
                )
                RETURNING
                    id as "id: SubcategoryId",
                    title,
                    color
            "#,
            user_id.0,
            category_id.0,
            title,
            color
        )
        .fetch_one(self)
        .await
        .context("Failed to create subcategory")
        .map_err(Into::into)
    }

    pub async fn update_subcategory(
        &self,
        user_id: UserId,
        subcategory_id: SubcategoryId,
        title: &str,
        color: &str,
    ) -> Result<SubcategoryResult> {
        sqlx::query_as!(
            SubcategoryResult,
            r#"
                UPDATE
                    subcategories
                SET
                    title = $3,
                    color = $4
                WHERE
                    id = $2 AND
                    user_id = $1
                RETURNING
                    id as "id: SubcategoryId",
                    title,
                    color
            "#,
            user_id.0,
            subcategory_id.0,
            title,
            color
        )
        .fetch_one(self)
        .await
        .context("Failed to update subcategory")
        .map_err(Into::into)
    }

    pub async fn delete_subcategory(
        &self,
        user_id: UserId,
        subcategory_id: SubcategoryId,
    ) -> Result<SubcategoryId> {
        sqlx::query_scalar!(
            r#"
                DELETE FROM
                    subcategories
                WHERE
                    id = $2 AND
                    user_id = $1
                RETURNING
                    id as "id: SubcategoryId"
            "#,
            user_id.0,
            subcategory_id.0
        )
        .fetch_one(self)
        .await
        .context("Failed to delete subcategory")
        .map_err(Into::into)
    }
}

impl<'c> Transaction<'c> {
    pub async fn update_category(
        &mut self,
        user_id: UserId,
        category_id: CategoryId,
        color: &str,
        is_enabled: bool,
    ) -> Result<()> {
        sqlx::query!(
            r#"
                INSERT INTO categories_override (
                    user_id,
                    category_id,
                    color,
                    is_enabled
                ) VALUES (
                    $1,
                    $2,
                    $3,
                    $4
                ) ON CONFLICT (
                    user_id,
                    category_id
                ) DO UPDATE SET
                    color = EXCLUDED.color,
                    is_enabled = EXCLUDED.is_enabled
            "#,
            user_id.0,
            category_id.0,
            color,
            is_enabled
        )
        .execute(self)
        .await
        .context("Failed to update category")?;
        Ok(())
    }

    pub async fn get_category(
        &mut self,
        user_id: UserId,
        category_id: CategoryId,
    ) -> Result<CategoryResult> {
        sqlx::query_as!(
            CategoryRawResult,
            r#"
                SELECT
                    c.id as "id: CategoryId",
                    c.raw_title,
                    co.color,
                    co.is_enabled as "is_enabled: Option<bool>",
                    (
                        SELECT
                            json_agg(json_build_object(
                                'id', s.id,
                                'title', s.title,
                                'color', s.color
                            ))
                        FROM
                            subcategories s
                        WHERE
                            s.category_id = c.id AND
                            s.user_id = $1
                    ) as "subcategories: Json<Vec<SubcategoryResult>>"
                FROM
                    categories c
                LEFT JOIN
                    categories_override co ON
                        co.category_id = c.id AND
                        co.user_id = $1
                WHERE
                    c.id = $2
            "#,
            user_id.0,
            category_id.0
        )
        .fetch_one(self)
        .await
        .context("Failed to get category")
        .map(Into::into)
        .map_err(Into::into)
    }
}
