use futures_core::stream::Stream;
use futures_util::stream::StreamExt;
use std::fmt::Display;

use anyhow::Result;
use sqlx::{
    self,
    postgres::types::PgInterval,
    types::{
        time::{Date, PrimitiveDateTime},
        Uuid,
    },
};
use tonic::Status;

use super::{database::Database, GroupId, UserId};

#[derive(Clone, Copy, Debug, sqlx::Type)]
#[sqlx(transparent)]
pub struct TaskId(i32);

impl TaskId {
    pub fn new(id: i32) -> Self {
        Self(id)
    }
}

impl From<TaskId> for i32 {
    fn from(value: TaskId) -> Self {
        value.0
    }
}

impl Display for TaskId {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        self.0.fmt(f)
    }
}

#[derive(Debug)]
struct TaskRawResult {
    pub id: i32,
    pub title: Option<String>,
    pub completed_at: Option<PrimitiveDateTime>,
    pub start_date: Option<Date>,
    pub end_date: Option<Date>,
    pub estimate: Option<PgInterval>,
    pub responsible_id: i32,
    pub responsible_name: String,
    pub responsible_picture_url: Option<String>,
    pub group_id: Option<i32>,
    pub group_title: Option<String>,
    pub group_uid: Option<Uuid>,
}

#[derive(Debug)]
pub struct TaskResult {
    pub id: TaskId,
    pub title: Option<String>,
    pub completed_at: Option<PrimitiveDateTime>,
    pub start_date: Option<Date>,
    pub end_date: Option<Date>,
    pub estimate: Option<TaskEstimate>,
    pub responsible_id: UserId,
    pub responsible_name: String,
    pub responsible_picture_url: Option<String>,
    pub group_id: Option<GroupId>,
    pub group_title: Option<String>,
    pub group_uid: Option<Uuid>,
}

impl TryFrom<TaskRawResult> for TaskResult {
    type Error = Status;

    fn try_from(value: TaskRawResult) -> std::result::Result<Self, Self::Error> {
        Ok(Self {
            id: TaskId(value.id),
            title: value.title,
            completed_at: value.completed_at,
            start_date: value.start_date,
            end_date: value.end_date,
            estimate: match value.estimate {
                None => Ok(None),
                Some(v) => v.try_into().map(Some),
            }?,
            responsible_id: UserId(value.responsible_id),
            responsible_name: value.responsible_name,
            responsible_picture_url: value.responsible_picture_url,
            group_id: value.group_id.map(GroupId),
            group_title: value.group_title,
            group_uid: value.group_uid,
        })
    }
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

pub enum TaskPeriodInput {
    OnlyStart(Date),
    OnlyEnd(Date),
    StartAndEnd { start: Date, end: Date },
}

impl TaskPeriodInput {
    pub fn start_date(&self) -> Option<&Date> {
        match self {
            Self::OnlyStart(date) => Some(date),
            Self::OnlyEnd(_) => None,
            Self::StartAndEnd { start, .. } => Some(start),
        }
    }

    pub fn end_date(&self) -> Option<&Date> {
        match self {
            Self::OnlyStart(_) => None,
            Self::OnlyEnd(date) => Some(date),
            Self::StartAndEnd { end, .. } => Some(end),
        }
    }
}

#[derive(Debug)]
pub struct TaskEstimate {
    pub days: i32,
    pub hours: i32,
    pub minutes: i32,
}

impl TryFrom<PgInterval> for TaskEstimate {
    type Error = Status;

    fn try_from(value: PgInterval) -> Result<Self, Self::Error> {
        if value.months != 0 {
            return Err(Status::internal("Unexpected month value in estimate"));
        }
        let total_minutes = value.microseconds / (60_000_000);
        let hours: i32 = (total_minutes / 60)
            .try_into()
            .map_err(|_| Status::internal("Failed to parse estimate hours"))?;
        let minutes: i32 = (total_minutes % 60)
            .try_into()
            .map_err(|_| Status::internal("Failed to parse estimate minutes"))?;
        Ok(Self {
            days: value.days,
            hours,
            minutes,
        })
    }
}

impl From<TaskEstimate> for PgInterval {
    fn from(value: TaskEstimate) -> Self {
        Self {
            months: 0,
            days: value.days,
            microseconds: ((value.hours as i64) * 60 + (value.minutes as i64)) * 60_000_000,
        }
    }
}

pub struct CreateTaskParams {
    pub user_id: UserId,
    pub responsible_id: UserId,
    pub title: String,
    pub period: TaskPeriodInput,
    pub group_id: Option<GroupId>,
    pub estimate: Option<TaskEstimate>,
}

pub struct UpdateTaskParams {
    pub user_id: UserId,
    pub responsible_id: UserId,
    pub task_id: TaskId,
    pub title: String,
    pub period: TaskPeriodInput,
    pub group_id: Option<GroupId>,
    pub estimate: Option<TaskEstimate>,
}

impl Database {
    #[allow(clippy::needless_lifetimes)]
    pub fn get_tasks<'a>(
        &'a self,
        user_id: UserId,
    ) -> impl Stream<Item = Result<TaskResult, Status>> + 'a {
        sqlx::query_as!(
            TaskRawResult,
            r#"
                SELECT
                    t.id,
                    t.title,
                    t.completed_at,
                    t.start_date,
                    t.end_date,
                    t.estimate,
                    u.id as responsible_id,
                    u.name as responsible_name,
                    u.picture_url as responsible_picture_url,
                    g.id as "group_id: Option<i32>",
                    g.title as "group_title: Option<String>",
                    g.uid as "group_uid: Option<Uuid>"
                FROM
                    tasks t
                INNER JOIN
                    users u ON
                        u.id = t.responsible_user_id
                LEFT JOIN
                    groups g ON
                        g.id = t.group_id
                WHERE
                    -- Hide old items
                    (
                        t.completed_at IS NULL OR
                        t.completed_at > CURRENT_TIMESTAMP - INTERVAL '1 day'
                    ) AND
                    -- Permission check
                    (
                        -- Viewer is responsible
                        t.responsible_user_id = $1 OR
                        -- Viewer is in task group
                        EXISTS (
                            SELECT
                            FROM
                                users_groups ug
                            WHERE
                                ug.group_id = t.group_id AND
                                ug.user_id = $1
                        )
                    )
            "#,
            user_id.0
        )
        .fetch(&self.pool)
        .map(|i| {
            i.or(Err(Status::internal("unexpected error loading tasks")))?
                .try_into()
        })
    }

    async fn get_task_unchecked(&self, task_id: TaskId) -> Result<TaskResult, Status> {
        sqlx::query_as!(
            TaskRawResult,
            r#"
                SELECT
                    t.id,
                    t.title,
                    t.completed_at,
                    t.start_date,
                    t.end_date,
                    t.estimate,
                    u.id as responsible_id,
                    u.name as responsible_name,
                    u.picture_url as responsible_picture_url,
                    g.id as "group_id: Option<i32>",
                    g.title as "group_title: Option<String>",
                    g.uid as "group_uid: Option<Uuid>"
                FROM
                    tasks t
                INNER JOIN
                    users u ON
                        u.id = t.responsible_user_id
                LEFT JOIN
                    groups g ON
                        g.id = t.group_id
                WHERE
                    t.id = $1
            "#,
            task_id.0,
        )
        .fetch_one(&self.pool)
        .await
        .map_err(|_| Status::internal("Failed to fetch task"))?
        .try_into()
    }

    async fn validate_responsible_and_group(
        &self,
        user_id: UserId,
        responsible_id: UserId,
        group_id: Option<GroupId>,
    ) -> Result<(), Status> {
        if let Some(group_id) = group_id {
            let is_valid = sqlx::query_scalar!(
                r#"
                    SELECT
                        -- Viewer in group
                        EXISTS (
                            SELECT
                            FROM
                                users_groups
                            WHERE
                                user_id = $1 AND
                                group_id = $3
                        ) AND
                        -- Responsible in group
                        EXISTS (
                            SELECT
                            FROM
                                users_groups
                            WHERE
                                user_id = $2 AND
                                group_id = $3
                        )
                "#,
                user_id.0,
                responsible_id.0,
                group_id.0
            )
            .fetch_one(&self.pool)
            .await
            .map_err(|_| Status::internal("Failed to validate responsible and group"))?;

            if let Some(is_valid) = is_valid {
                if !is_valid {
                    return Err(Status::invalid_argument("Invalid responsible and/or group"));
                }
            } else {
                return Err(Status::internal(
                    "Failed to fetch responsible and group validation",
                ));
            }
        } else if user_id != responsible_id {
            return Err(Status::invalid_argument(
                "Responsible must be self when no group",
            ));
        }
        Ok(())
    }

    pub async fn create_task(&self, params: CreateTaskParams) -> Result<TaskResult, Status> {
        self.validate_responsible_and_group(params.user_id, params.responsible_id, params.group_id)
            .await?;

        let task_id = sqlx::query_scalar!(
            r#"
                INSERT INTO tasks (
                    responsible_user_id,
                    title,
                    start_date,
                    end_date,
                    group_id,
                    estimate
                )
                VALUES (
                    $1,
                    $2,
                    $3,
                    $4,
                    $5,
                    $6
                )
                RETURNING
                    id as "id: TaskId"
            "#,
            params.responsible_id.0,
            params.title,
            params.period.start_date(),
            params.period.end_date(),
            params.group_id.map(|id| id.0),
            params.estimate.map(PgInterval::from),
        )
        .fetch_one(&self.pool)
        .await
        .map_err(|_| Status::internal("Failed to create task"))?;

        self.get_task_unchecked(task_id).await
    }

    pub async fn update_task(&self, params: UpdateTaskParams) -> Result<TaskResult, Status> {
        self.validate_responsible_and_group(params.user_id, params.responsible_id, params.group_id)
            .await?;

        let task_id = sqlx::query_scalar!(
            r#"
                UPDATE
                    tasks t
                SET
                    title = $3,
                    start_date = $4,
                    end_date = $5,
                    responsible_user_id = $6,
                    group_id = $7,
                    estimate = $8
                WHERE
                    t.id = $2 AND
                    -- Permission check
                    (
                        -- Viewer is responsible
                        t.responsible_user_id = $1 OR
                        -- Viewer is in task group
                        EXISTS (
                            SELECT
                            FROM
                                users_groups ug
                            WHERE
                                ug.group_id = t.group_id AND
                                ug.user_id = $1
                        )
                    )
                RETURNING
                    id as "id: TaskId"
            "#,
            params.user_id.0,
            params.task_id.0,
            params.title,
            params.period.start_date(),
            params.period.end_date(),
            params.responsible_id.0,
            params.group_id.map(|id| id.0),
            params.estimate.map(PgInterval::from),
        )
        .fetch_one(&self.pool)
        .await
        .map_err(|_| Status::internal("Failed to update task"))?;

        self.get_task_unchecked(task_id).await
    }

    pub async fn toggle_task_completed(
        &self,
        user_id: UserId,
        task_id: TaskId,
        is_completed: bool,
    ) -> Result<ToggleResult, Status> {
        sqlx::query_as!(
            ToggleResult,
            r#"
                UPDATE
                    tasks t
                SET
                    completed_at = CASE
                        WHEN $3 THEN CURRENT_TIMESTAMP AT TIME ZONE 'UTC'
                        ELSE NULL
                    END
                WHERE
                    t.id = $2 AND
                    -- Permission check
                    (
                        -- Viewer is responsible
                        t.responsible_user_id = $1 OR
                        -- Viewer is in task group
                        EXISTS (
                            SELECT
                            FROM
                                users_groups ug
                            WHERE
                                ug.group_id = t.group_id AND
                                ug.user_id = $1
                        )
                    )
                RETURNING
                    id as "id: TaskId",
                    completed_at
            "#,
            user_id.0,
            task_id.0,
            is_completed,
        )
        .fetch_one(&self.pool)
        .await
        .map_err(|_| Status::internal("Failed to update task"))
    }

    pub async fn delete_task(&self, user_id: UserId, task_id: TaskId) -> Result<TaskId, Status> {
        sqlx::query_as!(
            DeleteResult,
            r#"
                DELETE FROM
                    tasks t
                WHERE
                    t.id = $2 AND
                    -- Permission check
                    (
                        -- Viewer is responsible
                        t.responsible_user_id = $1 OR
                        -- Viewer is in task group
                        EXISTS (
                            SELECT
                            FROM
                                users_groups ug
                            WHERE
                                ug.group_id = t.group_id AND
                                ug.user_id = $1
                        )
                    )
                RETURNING
                    id as "id: TaskId"
            "#,
            user_id.0,
            task_id.0,
        )
        .fetch_one(&self.pool)
        .await
        .map_err(|_| Status::internal("Failed to delete task"))
        .map(|result| result.id)
    }
}
