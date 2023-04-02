DELETE FROM tasks;

ALTER TABLE tasks
DROP COLUMN responsible_user_id,
ADD COLUMN responsible_user_id int NOT NULL REFERENCES users (id) ON DELETE RESTRICT;