ALTER TABLE tasks
	DROP COLUMN schedule_id;

DROP TABLE schedules;

CREATE TABLE recurrences(
	id serial PRIMARY KEY,
	frequency interval NOT NULL,
	is_every boolean NOT NULL,
	current_task_id int NOT NULL REFERENCES tasks(id) ON DELETE CASCADE
);

ALTER TABLE tasks
	ADD COLUMN previous_task_id int REFERENCES tasks(id) ON DELETE RESTRICT,
	ADD COLUMN recurrence_id int REFERENCES recurrences(id) ON DELETE SET NULL;

