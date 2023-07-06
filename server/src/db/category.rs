use std::fmt::Display;

use anyhow::Context;
use futures_core::stream::Stream;
use futures_util::stream::StreamExt;
use serde::Deserialize;
use sqlx::types::Json;

use super::{Database, UserId};
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
    pub is_enabled: bool,
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
            is_enabled: raw.is_enabled,
            subcategories: raw.subcategories.map(|json| json.0).unwrap_or_default(),
        }
    }
}

impl Database {
    pub fn get_user_categories(
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
                    co.is_enabled,
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
                        co.category_id = c.id
                WHERE
                    co.user_id = $1
                ORDER BY
                    c.created_at
            "#,
            user_id.0
        )
        .fetch(self)
        .map(|v| {
            v.map(Into::into)
                .context("Error loading user categories")
                .map_err(Into::into)
        })
    }
}
