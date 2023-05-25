use futures_core::stream::Stream;
use futures_util::stream::StreamExt;
use std::{cmp::Ordering, fmt::Display};

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
    pub recurrence_frequency: Option<PgInterval>,
    pub recurrence_is_every: Option<bool>,
    pub recurrence_current_task_id: Option<i32>,
}

#[derive(Debug)]
pub struct TaskResult {
    pub id: TaskId,
    pub title: Option<String>,
    pub completed_at: Option<PrimitiveDateTime>,
    pub period: TaskPeriod,
    pub estimate: Option<TaskEstimate>,
    pub responsible: TaskResponsible,
    pub group: Option<TaskGroup>,
    pub recurrence: Option<TaskRecurrence>,
    pub disabled: bool,
}

impl TryFrom<TaskRawResult> for TaskResult {
    type Error = Status;

    fn try_from(value: TaskRawResult) -> std::result::Result<Self, Self::Error> {
        Ok(Self {
            id: TaskId(value.id),
            title: value.title,
            completed_at: value.completed_at,
            period: (value.start_date, value.end_date)
                .try_into()
                .map_err(Status::internal)?,
            estimate: match value.estimate {
                None => Ok(None),
                Some(v) => v.try_into().map(Some),
            }?,
            responsible: TaskResponsible {
                id: UserId(value.responsible_id),
                name: value.responsible_name,
                picture_url: value.responsible_picture_url,
            },
            group: match (value.group_id, value.group_title, value.group_uid) {
                (None, None, None) => Ok(None),
                (Some(id), Some(title), Some(uid)) => Ok(Some(TaskGroup {
                    id: GroupId(id),
                    title,
                    uid,
                })),
                _ => Err(Status::internal("Unexpected group result")),
            }?,
            recurrence: match (value.recurrence_frequency, value.recurrence_is_every) {
                (None, None) => Ok(None),
                (Some(frequency), Some(true)) => Ok(Some(TaskRecurrence::Every(frequency.into()))),
                (Some(frequency), Some(false)) => {
                    Ok(Some(TaskRecurrence::WhenChecked(frequency.into())))
                }
                _ => Err(Status::internal("Unexpected recurrence result")),
            }?,
            disabled: if let Some(current_task_id) = value.recurrence_current_task_id {
                current_task_id != value.id
            } else {
                false
            },
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

#[derive(Debug)]
pub enum TaskPeriod {
    OnlyStart(Date),
    OnlyEnd(Date),
    StartAndEnd { start: Date, end: Date },
}

impl TaskPeriod {
    pub fn start(&self) -> Option<&Date> {
        match self {
            Self::OnlyStart(date) => Some(date),
            Self::OnlyEnd(_) => None,
            Self::StartAndEnd { start, .. } => Some(start),
        }
    }

    pub fn end(&self) -> Option<&Date> {
        match self {
            Self::OnlyStart(_) => None,
            Self::OnlyEnd(date) => Some(date),
            Self::StartAndEnd { end, .. } => Some(end),
        }
    }
}

impl TryFrom<(Option<Date>, Option<Date>)> for TaskPeriod {
    type Error = &'static str;

    fn try_from(value: (Option<Date>, Option<Date>)) -> std::result::Result<Self, Self::Error> {
        match value {
            (Some(start), None) => Ok(TaskPeriod::OnlyStart(start)),
            (None, Some(end)) => Ok(TaskPeriod::OnlyEnd(end)),
            (Some(start), Some(end)) => {
                if end.cmp(&start) == Ordering::Less {
                    Err("End before start")
                } else {
                    Ok(TaskPeriod::StartAndEnd { start, end })
                }
            }
            (None, None) => Err("Either start or end date required"),
        }
    }
}

#[derive(Debug)]
pub struct TaskResponsible {
    pub id: UserId,
    pub name: String,
    pub picture_url: Option<String>,
}

#[derive(Debug)]
pub struct TaskGroup {
    pub id: GroupId,
    pub title: String,
    pub uid: Uuid,
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

#[derive(Debug)]
pub struct TaskRecurrenceFrequency {
    pub days: i32,
    pub months: i32,
}

impl From<PgInterval> for TaskRecurrenceFrequency {
    fn from(value: PgInterval) -> Self {
        Self {
            months: value.months,
            days: value.days,
        }
    }
}

#[derive(Debug)]
pub enum TaskRecurrence {
    Every(TaskRecurrenceFrequency),
    WhenChecked(TaskRecurrenceFrequency),
}

pub struct CreateTaskParams {
    pub user_id: UserId,
    pub responsible_id: UserId,
    pub title: String,
    pub period: TaskPeriod,
    pub group_id: Option<GroupId>,
    pub estimate: Option<TaskEstimate>,
    pub recurrence: Option<TaskRecurrence>,
}

pub struct UpdateTaskParams {
    pub user_id: UserId,
    pub responsible_id: UserId,
    pub task_id: TaskId,
    pub title: String,
    pub period: TaskPeriod,
    pub group_id: Option<GroupId>,
    pub estimate: Option<TaskEstimate>,
    pub recurrence: Option<TaskRecurrence>,
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
                    g.uid as "group_uid: Option<Uuid>",
                    r.frequency as "recurrence_frequency: Option<PgInterval>",
                    r.is_every as "recurrence_is_every: Option<bool>",
                    r.current_task_id as "recurrence_current_task_id: Option<i32>"
                FROM
                    tasks t
                INNER JOIN
                    users u ON
                        u.id = t.responsible_user_id
                LEFT JOIN
                    groups g ON
                        g.id = t.group_id
                LEFT JOIN
                    recurrences r ON
                        r.id = t.recurrence_id
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
                    g.uid as "group_uid: Option<Uuid>",
                    r.frequency as "recurrence_frequency: Option<PgInterval>",
                    r.is_every as "recurrence_is_every: Option<bool>",
                    r.current_task_id as "recurrence_current_task_id: Option<i32>"
                FROM
                    tasks t
                INNER JOIN
                    users u ON
                        u.id = t.responsible_user_id
                LEFT JOIN
                    groups g ON
                        g.id = t.group_id
                LEFT JOIN
                    recurrences r ON
                        r.id = t.recurrence_id
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
        if params.recurrence.is_some() {
            return Err(Status::unimplemented(
                "Insert of recurrence not yet supported",
            ));
        }

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
            params.period.start(),
            params.period.end(),
            params.group_id.map(|id| id.0),
            params.estimate.map(PgInterval::from),
        )
        .fetch_one(&self.pool)
        .await
        .map_err(|_| Status::internal("Failed to create task"))?;

        self.get_task_unchecked(task_id).await
    }

    pub async fn update_task(&self, params: UpdateTaskParams) -> Result<TaskResult, Status> {
        if params.recurrence.is_some() {
            return Err(Status::unimplemented(
                "Update of recurrence not yet supported",
            ));
        }

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
            params.period.start(),
            params.period.end(),
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
