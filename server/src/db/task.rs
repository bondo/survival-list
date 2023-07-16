use anyhow::Context;
use futures_core::stream::Stream;
use futures_util::stream::StreamExt;
use sqlx::{
    self,
    postgres::types::PgInterval,
    types::{
        time::{Date, PrimitiveDateTime},
        Uuid,
    },
};
use std::{cmp::Ordering, fmt::Display};

use super::{CategoryId, Database, GroupId, SubcategoryId, Transaction, UserId};
use crate::{Error, Result};

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

struct RecurrenceId(i32);

#[derive(Debug)]
struct TaskRawResult {
    pub id: i32,
    pub title: String,
    pub is_old: Option<bool>,
    pub is_responsible: Option<bool>,
    pub is_in_group: Option<bool>,
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
    pub recurrence_id: Option<i32>,
    pub recurrence_frequency: Option<PgInterval>,
    pub recurrence_is_every: Option<bool>,
    pub recurrence_current_task_id: Option<i32>,
    pub recurrence_previous_task_id: Option<i32>,
    pub recurrence_num_ready_to_start: Option<i32>,
    pub recurrence_num_reached_deadline: Option<i32>,
    pub category_id: Option<i32>,
    pub category_raw_title: Option<String>,
    pub category_color: Option<String>,
    pub category_is_enabled: Option<bool>,
    pub subcategory_id: Option<i32>,
    pub subcategory_title: Option<String>,
    pub subcategory_color: Option<String>,
}

impl TaskRawResult {
    fn is_friend_task(&self) -> Result<bool> {
        let Some(is_responsible) = self.is_responsible else {
            return Err(Error::InternalState("Unexpected null value"));
        };
        let Some(is_in_group) = self.is_in_group else {
            return Err(Error::InternalState("Unexpected null value"));
        };
        Ok(!is_responsible && !is_in_group)
    }

    // Allow update
    // - if not recurrence
    // - if this is the current task
    fn can_update(&self) -> Result<bool> {
        if self.is_friend_task()? {
            Ok(false)
        } else {
            Ok(self
                .recurrence_current_task_id
                .map_or(true, |v| v == self.id))
        }
    }

    // Allow toggle
    // - if not recurrence
    // - if this is the first recurrence
    // - if this is the current task
    // - if this is the previous task
    fn can_toggle(&self) -> Result<bool> {
        if self.is_friend_task()? {
            return Ok(false);
        }
        match (
            self.recurrence_previous_task_id,
            self.recurrence_current_task_id,
        ) {
            (None, None) | (None, Some(_)) => Ok(true),
            (Some(_), None) => Err(Error::InternalState("Unexpected recurrence stats")),
            (Some(previous_task_id), Some(current_task_id)) => {
                Ok(self.id == previous_task_id || self.id == current_task_id)
            }
        }
    }

    fn can_delete(&self) -> Result<bool> {
        self.can_update()
    }

    fn is_visible(&self) -> bool {
        !self.is_old.unwrap_or(false)
    }
}

#[derive(Debug)]
pub struct TaskResult {
    pub id: TaskId,
    pub title: String,
    pub completed_at: Option<PrimitiveDateTime>,
    pub period: TaskPeriod,
    pub estimate: Option<TaskEstimate>,
    pub responsible: TaskResponsible,
    pub group: Option<TaskGroup>,
    pub recurrence: Option<TaskRecurrenceOutput>,
    pub can_update: bool,
    pub can_toggle: bool,
    pub can_delete: bool,
    pub is_friend_task: bool,
    pub category: Option<TaskCategory>,
    pub subcategory: Option<TaskSubcategory>,
}

static RECURRENCE_MAX: i32 = 5;

impl TryFrom<TaskRawResult> for TaskResult {
    type Error = Error;

    fn try_from(value: TaskRawResult) -> Result<Self> {
        let can_update = value.can_update()?;
        let can_toggle = value.can_toggle()?;
        let can_delete = value.can_delete()?;
        let is_friend_task = value.is_friend_task()?;
        Ok(Self {
            id: TaskId(value.id),
            title: value.title,
            completed_at: value.completed_at,
            period: (value.start_date, value.end_date).try_into()?,
            estimate: value.estimate.map(TryInto::try_into).transpose()?,
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
                _ => Err(Error::InternalState("Unexpected group result")),
            }?,
            recurrence: match (value.recurrence_frequency, value.recurrence_is_every) {
                (None, None) => Ok(None),
                (Some(frequency), Some(true)) => {
                    Ok(Some(TaskRecurrenceOutput::Every(TaskRecurrenceEvery {
                        frequency: frequency.into(),
                        pending: TaskRecurrencePending {
                            num_ready_to_start: value
                                .recurrence_num_ready_to_start
                                .unwrap_or_default(),
                            num_ready_to_start_is_lower_bound: value
                                .recurrence_num_ready_to_start
                                .map_or(false, |v| v >= RECURRENCE_MAX),
                            num_reached_deadline: value
                                .recurrence_num_reached_deadline
                                .unwrap_or_default(),
                            num_reached_deadline_is_lower_bound: value
                                .recurrence_num_reached_deadline
                                .map_or(false, |v| v >= RECURRENCE_MAX),
                        },
                    })))
                }
                (Some(frequency), Some(false)) => {
                    Ok(Some(TaskRecurrenceOutput::Checked(frequency.into())))
                }
                _ => Err(Error::InternalState("Unexpected recurrence result")),
            }?,
            can_update,
            can_toggle,
            can_delete,
            is_friend_task,
            category: match (value.category_id, value.category_raw_title) {
                (None, None) => Ok(None),
                (Some(id), Some(raw_title)) => Ok(Some(TaskCategory {
                    id: CategoryId(id),
                    raw_title,
                    color: value.category_color,
                    is_enabled: value.category_is_enabled.unwrap_or(true),
                })),
                _ => Err(Error::InternalState("Unexpected category result")),
            }?,
            subcategory: match (value.subcategory_id, value.subcategory_title) {
                (None, None) => Ok(None),
                (Some(id), Some(title)) => Ok(Some(TaskSubcategory {
                    id: SubcategoryId(id),
                    title,
                    color: value.subcategory_color,
                })),
                _ => Err(Error::InternalState("Unexpected subcategory result")),
            }?,
        })
    }
}

#[derive(Debug)]
pub struct ToggleResult {
    pub id: TaskId,
    pub can_update: bool,
    pub can_toggle: bool,
    pub can_delete: bool,
    pub completed_at: Option<PrimitiveDateTime>,
    pub task_created: Option<TaskResult>,
    pub task_deleted: Option<TaskId>,
    pub task_updated: Option<TaskResult>,
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
    type Error = Error;

    fn try_from(value: (Option<Date>, Option<Date>)) -> Result<Self> {
        match value {
            (Some(start), None) => Ok(TaskPeriod::OnlyStart(start)),
            (None, Some(end)) => Ok(TaskPeriod::OnlyEnd(end)),
            (Some(start), Some(end)) => {
                if end.cmp(&start) == Ordering::Less {
                    Err(Error::InvalidArgument("End before start"))
                } else {
                    Ok(TaskPeriod::StartAndEnd { start, end })
                }
            }
            (None, None) => Err(Error::InvalidArgument("Either start or end date required")),
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

#[derive(Debug)]
pub struct TaskCategory {
    pub id: CategoryId,
    pub raw_title: String,
    pub color: Option<String>,
    pub is_enabled: bool,
}

#[derive(Debug)]
pub struct TaskSubcategory {
    pub id: SubcategoryId,
    pub title: String,
    pub color: Option<String>,
}

impl TryFrom<PgInterval> for TaskEstimate {
    type Error = Error;

    fn try_from(value: PgInterval) -> Result<Self> {
        if value.months != 0 {
            return Err(Error::InternalState("Unexpected month value in estimate"));
        }
        let total_minutes = value.microseconds / (60_000_000);
        let hours: i32 = (total_minutes / 60)
            .try_into()
            .map_err(|_| Error::InternalState("Failed to parse estimate hours"))?;
        let minutes: i32 = (total_minutes % 60)
            .try_into()
            .map_err(|_| Error::InternalState("Failed to parse estimate minutes"))?;
        Ok(Self {
            days: value.days,
            hours,
            minutes,
        })
    }
}

impl From<&TaskEstimate> for PgInterval {
    fn from(value: &TaskEstimate) -> Self {
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

#[derive(Debug)]
pub struct TaskRecurrencePending {
    pub num_ready_to_start: i32,
    pub num_ready_to_start_is_lower_bound: bool,
    pub num_reached_deadline: i32,
    pub num_reached_deadline_is_lower_bound: bool,
}

impl From<PgInterval> for TaskRecurrenceFrequency {
    fn from(value: PgInterval) -> Self {
        Self {
            months: value.months,
            days: value.days,
        }
    }
}

impl From<TaskRecurrenceFrequency> for PgInterval {
    fn from(value: TaskRecurrenceFrequency) -> Self {
        Self {
            months: value.months,
            days: value.days,
            microseconds: 0,
        }
    }
}

#[derive(Debug)]
pub struct TaskRecurrenceEvery {
    pub frequency: TaskRecurrenceFrequency,
    pub pending: TaskRecurrencePending,
}

#[derive(Debug)]
pub enum TaskRecurrenceInput {
    Every(TaskRecurrenceFrequency),
    Checked(TaskRecurrenceFrequency),
}

#[derive(Debug)]
pub enum TaskRecurrenceOutput {
    Every(TaskRecurrenceEvery),
    Checked(TaskRecurrenceFrequency),
}

pub struct CreateTaskParams {
    pub user_id: UserId,
    pub responsible_id: UserId,
    pub title: String,
    pub period: TaskPeriod,
    pub group_id: Option<GroupId>,
    pub estimate: Option<TaskEstimate>,
    pub recurrence: Option<TaskRecurrenceInput>,
    pub category_id: Option<CategoryId>,
    pub subcategory_id: Option<SubcategoryId>,
}

pub struct UpdateTaskParams {
    pub user_id: UserId,
    pub responsible_id: UserId,
    pub task_id: TaskId,
    pub title: String,
    pub period: TaskPeriod,
    pub group_id: Option<GroupId>,
    pub estimate: Option<TaskEstimate>,
    pub recurrence: Option<TaskRecurrenceInput>,
    pub category_id: Option<CategoryId>,
    pub subcategory_id: Option<SubcategoryId>,
}

impl Database {
    pub fn get_tasks(&self, user_id: UserId) -> impl Stream<Item = Result<TaskResult>> + '_ {
        sqlx::query_as!(
            TaskRawResult,
            r#"
                WITH RECURSIVE
                    base_tasks AS (
                        SELECT
                            t.id,
                            t.created_at,
                            t.title,
                            t.completed_at,
                            t.start_date,
                            t.end_date,
                            t.estimate,
                            t.category_id,
                            ts.subcategory_id,
                            t.responsible_user_id,
                            t.group_id,
                            r.id as recurrence_id,
                            r.frequency as recurrence_frequency,
                            r.is_every as recurrence_is_every,
                            r.current_task_id as recurrence_current_task_id,
                            c.previous_task_id as recurrence_previous_task_id
                        FROM
                            tasks t
                        LEFT JOIN
                            recurrences r ON
                                r.id = t.recurrence_id
                        LEFT JOIN
                            tasks c ON
                                c.id = r.current_task_id
                        LEFT JOIN
                            tasks_subcategories ts ON
                                ts.task_id = t.id AND
                                ts.user_id = $1
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
                                ) OR
                                -- Is friend responsible
                                EXISTS (
                                    SELECT
                                    FROM
                                        users_groups viewer_group
                                    INNER JOIN
                                        users_groups friend_group ON
                                            friend_group.group_id = viewer_group.group_id
                                    WHERE
                                        viewer_group.user_id = $1 AND
                                        friend_group.user_id = t.responsible_user_id
                                )
                            )
                    ),
                    every_tasks AS (
                        SELECT
                            bt.*,
                            0 depth
                        FROM
                            base_tasks bt
                        WHERE
                            bt.recurrence_is_every
                        UNION ALL
                        SELECT
                            et.id,
                            et.created_at,
                            et.title,
                            et.completed_at,
                            (et.start_date + et.recurrence_frequency)::date,
                            (et.end_date + et.recurrence_frequency)::date,
                            et.estimate,
                            et.category_id,
                            et.subcategory_id,
                            et.responsible_user_id,
                            et.group_id,
                            et.recurrence_id,
                            et.recurrence_frequency,
                            et.recurrence_is_every,
                            et.recurrence_current_task_id,
                            et.recurrence_previous_task_id,
                            et.depth + 1
                        FROM
                            every_tasks et
                        WHERE
                            et.depth < $2 AND
                            COALESCE(et.start_date, et.end_date) + et.recurrence_frequency < CURRENT_TIMESTAMP
                    )
                SELECT
                    bt.id,
                    bt.title,
                    (
                        bt.responsible_user_id = $1
                    ) is_responsible,
                    EXISTS (
                        SELECT
                        FROM
                            users_groups ug
                        WHERE
                            ug.group_id = bt.group_id AND
                            ug.user_id = $1
                    ) is_in_group,
                    bt.completed_at,
                    false is_old,
                    bt.start_date,
                    bt.end_date,
                    bt.estimate,
                    c.id as "category_id: Option<i32>",
                    c.raw_title as "category_raw_title: Option<String>",
                    co.color category_color,
                    co.is_enabled as "category_is_enabled: Option<bool>",
                    sc.id as "subcategory_id: Option<i32>",
                    sc.title as "subcategory_title: Option<String>",
                    sc.color subcategory_color,
                    u.id responsible_id,
                    u.name responsible_name,
                    u.picture_url responsible_picture_url,
                    g.id as "group_id: Option<i32>",
                    g.title as "group_title: Option<String>",
                    g.uid as "group_uid: Option<Uuid>",
                    bt.recurrence_id as "recurrence_id: Option<i32>",
                    bt.recurrence_frequency as "recurrence_frequency: Option<PgInterval>",
                    bt.recurrence_is_every as "recurrence_is_every: Option<bool>",
                    bt.recurrence_current_task_id as "recurrence_current_task_id: Option<i32>",
                    bt.recurrence_previous_task_id,
                    (SELECT COUNT(*) FROM every_tasks et WHERE et.id = bt.id AND et.start_date < CURRENT_TIMESTAMP)::int as recurrence_num_ready_to_start,
                    (SELECT COUNT(*) FROM every_tasks et WHERE et.id = bt.id AND et.end_date < CURRENT_TIMESTAMP)::int as recurrence_num_reached_deadline
                FROM
                    base_tasks bt
                INNER JOIN
                    users u ON
                        u.id = bt.responsible_user_id
                LEFT JOIN
                    groups g ON
                        g.id = bt.group_id
                LEFT JOIN
                    categories c ON
                        c.id = bt.category_id
                LEFT JOIN
                    categories_override co ON
                        co.category_id = c.id AND
                        co.user_id = $1
                LEFT JOIN
                    subcategories sc ON
                        sc.id = bt.subcategory_id
                ORDER BY
                    bt.created_at
            "#,
            user_id.0,
            RECURRENCE_MAX
        )
        .fetch(self)
        .map(|v| v.context("Error loading tasks")?.try_into())
    }

    pub async fn create_task(&self, params: CreateTaskParams) -> Result<TaskResult> {
        self.in_transaction(|tx| {
            Box::pin(async {
                tx.validate_responsible_and_group(
                    params.user_id,
                    params.responsible_id,
                    params.group_id,
                )
                .await?;

                tx.validate_category_and_subcategory(
                    params.user_id,
                    params.category_id,
                    params.subcategory_id,
                )
                .await?;

                let task_id = tx.create_task_internal(&params).await?;

                match params.recurrence {
                    None => (),
                    Some(TaskRecurrenceInput::Every(frequency)) => {
                        tx.create_recurrence_internal(task_id, frequency, true)
                            .await?;
                    }
                    Some(TaskRecurrenceInput::Checked(frequency)) => {
                        tx.create_recurrence_internal(task_id, frequency, false)
                            .await?;
                    }
                }

                if let Some(subcategory_id) = params.subcategory_id {
                    tx.set_task_subcategory_internal(params.user_id, task_id, subcategory_id)
                        .await?;
                }

                tx.get_task_unchecked(params.user_id, task_id)
                    .await
                    .context("Failed to load task after create")?
                    .try_into()
            })
        })
        .await
    }

    pub async fn update_task(&self, params: UpdateTaskParams) -> Result<TaskResult> {
        self.in_transaction(|tx| {
            Box::pin(async {
                tx.validate_responsible_and_group(
                    params.user_id,
                    params.responsible_id,
                    params.group_id,
                )
                .await?;

                tx.validate_category_and_subcategory(
                    params.user_id,
                    params.category_id,
                    params.subcategory_id,
                )
                .await?;

                let task = tx
                    .get_task_unchecked(params.user_id, params.task_id)
                    .await
                    .map_err(|_| Error::NotFound("Task not found"))?;

                if !task.can_update()? {
                    return Err(Error::PermissionDenied(
                        "You are not allowed to update this item",
                    ));
                }

                let task_id = tx.update_task_internal(&params).await?;

                match params.recurrence {
                    None => {
                        if let Some(recurrence_id) = task.recurrence_id {
                            tx.unset_recurrence_internal(RecurrenceId(recurrence_id))
                                .await?;

                            tx.delete_recurrence_internal(RecurrenceId(recurrence_id))
                                .await?;
                        }
                    }
                    Some(TaskRecurrenceInput::Every(frequency)) => {
                        if let Some(recurrence_id) = task.recurrence_id {
                            tx.update_recurrence_internal(
                                RecurrenceId(recurrence_id),
                                frequency,
                                true,
                            )
                            .await?;
                        } else {
                            tx.create_recurrence_internal(task_id, frequency, true)
                                .await?;
                        }
                    }
                    Some(TaskRecurrenceInput::Checked(frequency)) => {
                        if let Some(recurrence_id) = task.recurrence_id {
                            tx.update_recurrence_internal(
                                RecurrenceId(recurrence_id),
                                frequency,
                                false,
                            )
                            .await?;
                        } else {
                            tx.create_recurrence_internal(task_id, frequency, false)
                                .await?;
                        }
                    }
                }

                if let Some(subcategory_id) = params.subcategory_id {
                    tx.set_task_subcategory_internal(params.user_id, task_id, subcategory_id)
                        .await?;
                } else {
                    tx.unset_task_subcategory_internal(params.user_id, task_id)
                        .await?;
                }

                tx.get_task_unchecked(params.user_id, task_id)
                    .await
                    .context("Failed to load task after update")?
                    .try_into()
            })
        })
        .await
    }

    pub async fn toggle_task_completed(
        &self,
        user_id: UserId,
        task_id: TaskId,
        is_completed: bool,
    ) -> Result<ToggleResult> {
        self.in_transaction(|tx| {
            Box::pin(async {
                let task = tx
                    .get_task_unchecked(user_id, task_id)
                    .await
                    .map_err(|_| Error::NotFound("Task not found"))?;

                if task.completed_at.is_some() == is_completed {
                    return Ok(ToggleResult {
                        id: task_id,
                        can_update: task.can_update()?,
                        can_toggle: task.can_toggle()?,
                        can_delete: task.can_delete()?,
                        completed_at: task.completed_at,
                        task_created: None,
                        task_deleted: None,
                        task_updated: None,
                    });
                }

                if !task.can_toggle()? {
                    return Err(Error::PermissionDenied(
                        "You are not allowed to toggle this item",
                    ));
                }

                let completed_at = tx
                    .toggle_task_completed_internal(user_id, task_id, is_completed)
                    .await?;

                match (
                    task.recurrence_previous_task_id,
                    task.recurrence_current_task_id,
                ) {
                    // Non-recurring task - just set completed
                    (None, None) => {
                        let task = tx
                            .get_task_unchecked(user_id, TaskId(task.id))
                            .await
                            .context("Failed to load task after toggle")?;

                        Ok(ToggleResult {
                            id: task_id,
                            can_update: task.can_update()?,
                            can_toggle: task.can_toggle()?,
                            can_delete: task.can_delete()?,
                            completed_at,
                            task_created: None,
                            task_deleted: None,
                            task_updated: None,
                        })
                    }

                    // Set current task completed and create new task
                    (_, Some(current_task_id)) if task.id == current_task_id && is_completed => {
                        let next_task_id = tx
                            .create_next_recurrence_internal(TaskId(current_task_id))
                            .await?;

                        let next_task = tx
                            .get_task_unchecked(user_id, next_task_id)
                            .await
                            .context("Failed to load task after create")?;

                        let previous_task = {
                            if let Some(previous_task_id) = task.recurrence_previous_task_id {
                                tx.get_task_unchecked(user_id, TaskId(previous_task_id))
                                    .await
                                    .map(Some)
                                    .context("Failed to load previous task")?
                            } else {
                                None
                            }
                        };

                        let task = tx
                            .get_task_unchecked(user_id, TaskId(task.id))
                            .await
                            .context("Failed to load task after toggle")?;

                        Ok(ToggleResult {
                            id: task_id,
                            can_update: task.can_update()?,
                            can_toggle: task.can_toggle()?,
                            can_delete: task.can_delete()?,
                            completed_at,
                            task_created: Some(next_task.try_into()?),
                            task_deleted: None,
                            task_updated: previous_task
                                .filter(|t| t.is_visible())
                                .map(TryInto::try_into)
                                .transpose()?,
                        })
                    }

                    // Set previous task not completed and delete current task
                    (Some(previous_task_id), Some(current_task_id))
                        if task.id == previous_task_id && !is_completed =>
                    {
                        tx.revert_recurrence_internal(
                            TaskId(previous_task_id),
                            TaskId(current_task_id),
                        )
                        .await?;

                        tx.delete_task_internal(user_id, TaskId(current_task_id))
                            .await?;

                        let task = tx
                            .get_task_unchecked(user_id, TaskId(task.id))
                            .await
                            .context("Failed to load task after toggle")?;

                        let new_current_previous_task = {
                            if let Some(previous_task_id) = task.recurrence_previous_task_id {
                                tx.get_task_unchecked(user_id, TaskId(previous_task_id))
                                    .await
                                    .map(Some)
                                    .context("Failed to load previous task")?
                            } else {
                                None
                            }
                        };

                        Ok(ToggleResult {
                            id: task_id,
                            can_update: task.can_update()?,
                            can_toggle: task.can_toggle()?,
                            can_delete: task.can_delete()?,
                            completed_at,
                            task_created: None,
                            task_deleted: Some(TaskId(current_task_id)),
                            task_updated: new_current_previous_task
                                .filter(|t| t.is_visible())
                                .map(TryInto::try_into)
                                .transpose()?,
                        })
                    }

                    _ => Err(Error::InternalState("Unexpected task state")),
                }
            })
        })
        .await
    }

    pub async fn delete_task(&self, user_id: UserId, task_id: TaskId) -> Result<TaskId> {
        self.in_transaction(|tx| {
            Box::pin(async {
                let task = tx
                    .get_task_unchecked(user_id, task_id)
                    .await
                    .map_err(|_| Error::NotFound("Task not found"))?;

                if !task.can_delete()? {
                    return Err(Error::PermissionDenied(
                        "You are not allowed to delete this item",
                    ));
                }

                if let Some(recurrence_id) = task.recurrence_id {
                    tx.unset_recurrence_internal(RecurrenceId(recurrence_id))
                        .await?;

                    tx.delete_recurrence_internal(RecurrenceId(recurrence_id))
                        .await?;
                }

                tx.delete_task_internal(user_id, task_id).await
            })
        })
        .await
    }
}

impl<'c> Transaction<'c> {
    async fn get_task_unchecked(
        &mut self,
        user_id: UserId,
        task_id: TaskId,
    ) -> sqlx::Result<TaskRawResult> {
        sqlx::query_as!(
            TaskRawResult,
            r#"
                WITH RECURSIVE
                    base_task AS (
                        SELECT
                            t.id,
                            t.title,
                            (
                                t.responsible_user_id = $1
                            ) is_responsible,
                            EXISTS (
                                SELECT
                                FROM
                                    users_groups ug
                                WHERE
                                    ug.group_id = t.group_id AND
                                    ug.user_id = $1
                            ) is_in_group,
                            t.completed_at,
                            t.start_date,
                            t.end_date,
                            t.estimate,
                            c.id category_id,
                            c.raw_title category_raw_title,
                            co.color category_color,
                            co.is_enabled category_is_enabled,
                            sc.id subcategory_id,
                            sc.title subcategory_title,
                            sc.color subcategory_color,
                            u.id as responsible_id,
                            u.name as responsible_name,
                            u.picture_url as responsible_picture_url,
                            g.id as group_id,
                            g.title as group_title,
                            g.uid as group_uid,
                            r.id as recurrence_id,
                            r.frequency as recurrence_frequency,
                            r.is_every as recurrence_is_every,
                            r.current_task_id as recurrence_current_task_id,
                            cur.previous_task_id as recurrence_previous_task_id
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
                        LEFT JOIN
                            tasks cur ON
                                cur.id = r.current_task_id
                        LEFT JOIN
                            categories c ON
                                c.id = t.category_id
                        LEFT JOIN
                            categories_override co ON
                                co.category_id = c.id AND
                                co.user_id = $1
                        LEFT JOIN
                            tasks_subcategories ts ON
                                ts.task_id = t.id AND
                                ts.user_id = $1
                        LEFT JOIN
                            subcategories sc ON
                                sc.id = ts.subcategory_id
                        WHERE
                            t.id = $2
                    ),
                    every_task AS (
                        SELECT
                            bt.*,
                            0 depth
                        FROM
                            base_task bt
                        WHERE
                            bt.recurrence_is_every
                        UNION ALL
                        SELECT
                            et.id,
                            et.title,
                            et.is_responsible,
                            et.is_in_group,
                            et.completed_at,
                            (et.start_date + et.recurrence_frequency)::date,
                            (et.end_date + et.recurrence_frequency)::date,
                            et.estimate,
                            et.category_id,
                            et.category_raw_title,
                            et.category_color,
                            et.category_is_enabled,
                            et.subcategory_id,
                            et.subcategory_title,
                            et.subcategory_color,
                            et.responsible_id,
                            et.responsible_name,
                            et.responsible_picture_url,
                            et.group_id,
                            et.group_title,
                            et.group_uid,
                            et.recurrence_id,
                            et.recurrence_frequency,
                            et.recurrence_is_every,
                            et.recurrence_current_task_id,
                            et.recurrence_previous_task_id,
                            et.depth + 1
                        FROM
                            every_task et
                        WHERE
                            et.depth < $3 AND
                            COALESCE(et.start_date, et.end_date) + et.recurrence_frequency < CURRENT_TIMESTAMP
                    )
                SELECT
                    bt.id,
                    bt.title,
                    bt.is_responsible,
                    bt.is_in_group,
                    bt.completed_at,
                    bt.completed_at < CURRENT_TIMESTAMP - INTERVAL '1 day' as is_old,
                    bt.start_date,
                    bt.end_date,
                    bt.estimate,
                    bt.category_id as "category_id: Option<i32>",
                    bt.category_raw_title as "category_raw_title: Option<String>",
                    bt.category_color,
                    bt.category_is_enabled as "category_is_enabled: Option<bool>",
                    bt.subcategory_id as "subcategory_id: Option<i32>",
                    bt.subcategory_title as "subcategory_title: Option<String>",
                    bt.subcategory_color,
                    bt.responsible_id,
                    bt.responsible_name,
                    bt.responsible_picture_url,
                    bt.group_id as "group_id: Option<i32>",
                    bt.group_title as "group_title: Option<String>",
                    bt.group_uid as "group_uid: Option<Uuid>",
                    bt.recurrence_id as "recurrence_id: Option<i32>",
                    bt.recurrence_frequency as "recurrence_frequency: Option<PgInterval>",
                    bt.recurrence_is_every as "recurrence_is_every: Option<bool>",
                    bt.recurrence_current_task_id as "recurrence_current_task_id: Option<i32>",
                    bt.recurrence_previous_task_id,
                    (SELECT COUNT(*) FROM every_task et WHERE et.id = bt.id AND et.start_date < CURRENT_TIMESTAMP)::int as recurrence_num_ready_to_start,
                    (SELECT COUNT(*) FROM every_task et WHERE et.id = bt.id AND et.end_date < CURRENT_TIMESTAMP)::int as recurrence_num_reached_deadline
                FROM
                    base_task bt
            "#,
            user_id.0,
            task_id.0,
            RECURRENCE_MAX
        )
        .fetch_one(self)
        .await
    }

    async fn validate_responsible_and_group(
        &mut self,
        user_id: UserId,
        responsible_id: UserId,
        group_id: Option<GroupId>,
    ) -> Result<()> {
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
            .fetch_one(self)
            .await
            .context("Failed to validate responsible and group")?;

            if let Some(is_valid) = is_valid {
                if !is_valid {
                    return Err(Error::InvalidArgument("Invalid responsible and/or group"));
                }
            } else {
                return Err(Error::InternalState(
                    "Failed to fetch responsible and group validation",
                ));
            }
        } else if user_id != responsible_id {
            return Err(Error::InvalidArgument(
                "Responsible must be self when no group",
            ));
        }
        Ok(())
    }

    async fn validate_category_and_subcategory(
        &mut self,
        user_id: UserId,
        category_id: Option<CategoryId>,
        subcategory_id: Option<SubcategoryId>,
    ) -> Result<()> {
        match (category_id, subcategory_id) {
            (_, None) => Ok(()),
            (None, Some(_)) => Err(Error::InvalidArgument(
                "Category must be set when subcategory is set",
            )),
            (Some(category_id), Some(subcategory_id)) => {
                let parent_id = sqlx::query_scalar!(
                    r#"
                        SELECT
                            category_id as "category_id: CategoryId"
                        FROM
                            subcategories
                        WHERE
                            user_id = $1 AND
                            id = $2
                    "#,
                    user_id.0,
                    subcategory_id.0
                )
                .fetch_optional(self)
                .await
                .context("Failed to fetch parent of subcategory")?;

                if let Some(parent_id) = parent_id {
                    if parent_id.0 == category_id.0 {
                        Ok(())
                    } else {
                        Err(Error::InvalidArgument(
                            "Subcategory must be child of category",
                        ))
                    }
                } else {
                    Err(Error::NotFound("Subcategory not found"))
                }
            }
        }
    }

    async fn create_task_internal(&mut self, params: &CreateTaskParams) -> Result<TaskId> {
        sqlx::query_scalar!(
            r#"
                INSERT INTO tasks (
                    responsible_user_id,
                    title,
                    start_date,
                    end_date,
                    group_id,
                    estimate,
                    category_id
                )
                VALUES (
                    $1,
                    $2,
                    $3,
                    $4,
                    $5,
                    $6,
                    $7
                )
                RETURNING
                    id as "id: TaskId"
            "#,
            params.responsible_id.0,
            params.title,
            params.period.start(),
            params.period.end(),
            params.group_id.map(|id| id.0),
            params.estimate.as_ref().map(PgInterval::from),
            params.category_id.map(|id| id.0)
        )
        .fetch_one(self)
        .await
        .context("Failed to create task")
        .map_err(Into::into)
    }

    async fn update_task_internal(&mut self, params: &UpdateTaskParams) -> Result<TaskId> {
        sqlx::query_scalar!(
            r#"
                UPDATE
                    tasks t
                SET
                    title = $3,
                    start_date = $4,
                    end_date = $5,
                    responsible_user_id = $6,
                    group_id = $7,
                    estimate = $8,
                    category_id = $9
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
            params.estimate.as_ref().map(PgInterval::from),
            params.category_id.map(|id| id.0)
        )
        .fetch_one(self)
        .await
        .map_err(|_| Error::PermissionDenied("You are not allowed to update this item"))
    }

    async fn set_task_subcategory_internal(
        &mut self,
        user_id: UserId,
        task_id: TaskId,
        subcategory_id: SubcategoryId,
    ) -> Result<()> {
        sqlx::query!(
            r#"
                INSERT INTO tasks_subcategories (
                    user_id,
                    task_id,
                    subcategory_id
                ) VALUES (
                    $1,
                    $2,
                    $3
                ) ON CONFLICT (
                    user_id,
                    task_id
                ) DO UPDATE SET
                    subcategory_id = EXCLUDED.subcategory_id
            "#,
            user_id.0,
            task_id.0,
            subcategory_id.0
        )
        .execute(self)
        .await
        .context("Failed to set task subcategory")?;

        Ok(())
    }

    async fn unset_task_subcategory_internal(
        &mut self,
        user_id: UserId,
        task_id: TaskId,
    ) -> Result<()> {
        sqlx::query!(
            r#"
                DELETE FROM
                    tasks_subcategories
                WHERE
                    user_id = $1 AND
                    task_id = $2
            "#,
            user_id.0,
            task_id.0
        )
        .execute(self)
        .await
        .context("Failed to unset task subcategory")?;

        Ok(())
    }

    async fn toggle_task_completed_internal(
        &mut self,
        user_id: UserId,
        task_id: TaskId,
        is_completed: bool,
    ) -> Result<Option<PrimitiveDateTime>> {
        sqlx::query_scalar!(
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
                    completed_at
            "#,
            user_id.0,
            task_id.0,
            is_completed,
        )
        .fetch_one(self)
        .await
        .map_err(|_| Error::PermissionDenied("You are not allowed to toggle this item"))
    }

    async fn create_recurrence_internal(
        &mut self,
        task_id: TaskId,
        frequency: TaskRecurrenceFrequency,
        is_every: bool,
    ) -> Result<()> {
        sqlx::query!(
            r#"
                WITH
                    rec AS (
                        INSERT INTO recurrences (
                            frequency,
                            is_every,
                            current_task_id
                        )
                        VALUES (
                            $1,
                            $2,
                            $3
                        )
                        RETURNING
                            id
                    )
                UPDATE
                    tasks t
                SET
                    recurrence_id = r.id
                FROM
                    rec r
                WHERE
                    t.id = $3
            "#,
            Some(PgInterval::from(frequency)),
            is_every,
            task_id.0
        )
        .execute(self)
        .await
        .context("Failed to insert recurrence")?;
        Ok(())
    }

    async fn update_recurrence_internal(
        &mut self,
        recurrence_id: RecurrenceId,
        frequency: TaskRecurrenceFrequency,
        is_every: bool,
    ) -> Result<()> {
        sqlx::query!(
            r#"
                UPDATE
                    recurrences r
                SET
                    frequency = $1,
                    is_every = $2
                WHERE
                    r.id = $3
            "#,
            Some(PgInterval::from(frequency)),
            is_every,
            recurrence_id.0
        )
        .execute(self)
        .await
        .context("Failed to update recurrence")?;
        Ok(())
    }

    async fn unset_recurrence_internal(&mut self, recurrence_id: RecurrenceId) -> Result<()> {
        sqlx::query!(
            r#"
                UPDATE
                    tasks t
                SET
                    previous_task_id = NULL,
                    recurrence_id = NULL
                WHERE
                    t.recurrence_id = $1
            "#,
            recurrence_id.0
        )
        .execute(self)
        .await
        .context("Failed to unset recurrence")?;
        Ok(())
    }

    async fn delete_recurrence_internal(&mut self, recurrence_id: RecurrenceId) -> Result<()> {
        sqlx::query!(
            r#"
                DELETE FROM
                    recurrences r
                WHERE
                    r.id = $1
            "#,
            recurrence_id.0
        )
        .execute(self)
        .await
        .context("Failed to delete recurrence")?;
        Ok(())
    }

    async fn create_next_recurrence_internal(&mut self, task_id: TaskId) -> Result<TaskId> {
        // is_every: add frequency to start and end
        // !is_every: add frequency to start and end + (today - coalesce(start, end))
        sqlx::query_scalar!(
            r#"
                WITH
                    new_task AS (
                        INSERT INTO tasks (
                            responsible_user_id,
                            title,
                            start_date,
                            end_date,
                            group_id,
                            estimate,
                            previous_task_id,
                            recurrence_id
                        )
                        SELECT
                            t.responsible_user_id,
                            t.title,
                            t.start_date + CASE
                                WHEN r.is_every THEN
                                    r.frequency
                                ELSE
                                    r.frequency +
                                    (
                                        CURRENT_DATE -
                                        COALESCE(t.start_date, t.end_date)
                                    ) * INTERVAL '1 day'
                            END,
                            t.end_date + CASE
                                WHEN r.is_every THEN
                                    r.frequency
                                ELSE
                                    r.frequency +
                                    (
                                        CURRENT_DATE -
                                        COALESCE(t.start_date, t.end_date)
                                    ) * INTERVAL '1 day'
                            END,
                            t.group_id,
                            t.estimate,
                            t.id,
                            r.id
                        FROM
                            tasks t
                        INNER JOIN
                            recurrences r ON
                                r.id = t.recurrence_id
                        WHERE
                            t.id = $1
                        RETURNING
                            id,
                            recurrence_id
                    )
                UPDATE
                    recurrences r
                SET
                    current_task_id = t.id
                FROM
                    new_task t
                WHERE
                    t.recurrence_id = r.id
                RETURNING
                    t.id as "id: TaskId"
            "#,
            task_id.0
        )
        .fetch_one(self)
        .await
        .context("Failed to create task")
        .map_err(Into::into)
    }

    async fn revert_recurrence_internal(
        &mut self,
        previous_task_id: TaskId,
        current_task_id: TaskId,
    ) -> Result<()> {
        sqlx::query!(
            r#"
                UPDATE
                    recurrences r
                SET
                    current_task_id = $1
                WHERE
                    r.current_task_id = $2
            "#,
            previous_task_id.0,
            current_task_id.0
        )
        .execute(self)
        .await
        .context("Failed to update recurrence")?;
        Ok(())
    }

    async fn delete_task_internal(&mut self, user_id: UserId, task_id: TaskId) -> Result<TaskId> {
        sqlx::query_scalar!(
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
        .fetch_one(self)
        .await
        .map_err(|_| Error::PermissionDenied("You are not allowed to delete this item"))
    }
}
