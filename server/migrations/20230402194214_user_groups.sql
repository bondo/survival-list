CREATE TABLE groups (
    id serial PRIMARY KEY,
    title text NOT NULL
);

CREATE TABLE users_groups (
    user_id int NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    group_id int NOT NULL REFERENCES groups (id) ON DELETE CASCADE,
    PRIMARY KEY (user_id, group_id)
);

CREATE INDEX group_user_idx ON users_groups (group_id, user_id);

CREATE TABLE tasks_groups (
    task_id int NOT NULL REFERENCES tasks (id) ON DELETE CASCADE,
    group_id int NOT NULL REFERENCES groups (id) ON DELETE CASCADE,
    PRIMARY KEY (task_id, group_id)
);

CREATE INDEX group_task_idx ON tasks_groups (group_id, task_id);