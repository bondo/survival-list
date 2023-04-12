DROP TABLE tasks_groups;

ALTER TABLE tasks
ADD COLUMN group_id int REFERENCES groups (id) ON DELETE SET NULL;
