CREATE TABLE categories (
    id serial PRIMARY KEY,
    title text NOT NULL
);

CREATE TABLE subcategories (
    id serial PRIMARY KEY,
    category_id int NOT NULL REFERENCES categories (id) ON DELETE CASCADE,
    title text NOT NULL
);

CREATE TABLE users (
    id serial PRIMARY KEY,
    name text NOT NULL
);

CREATE TABLE schedules (
    id serial PRIMARY KEY,
    title text NOT NULL,
    category_id int REFERENCES categories (id) ON DELETE SET NULL,
    subcategory_id int REFERENCES subcategories (id) ON DELETE SET NULL,
    responsible_user_id int REFERENCES users (id) ON DELETE SET NULL,
    base_date date NOT NULL,
    relative_start_date interval,
    relative_end_date interval,
    max_pending_tasks smallint
);

CREATE TABLE tasks (
    id serial PRIMARY KEY,
    title text,
    category_id int REFERENCES categories (id) ON DELETE SET NULL,
    subcategory_id int REFERENCES subcategories (id) ON DELETE SET NULL,
    schedule_id int REFERENCES schedules (id) ON DELETE CASCADE,
    responsible_user_id int REFERENCES users (id) ON DELETE SET NULL,
    completed_at timestamp,
    start_date date,
    end_date date
);

CREATE TABLE log (
    id bigserial PRIMARY KEY,
    entity_type text NOT NULL,
    entity_title text NOT NULL,
    entity_id int NOT NULL,
    operation_type text NOT NULL,
    operation_info text,
    created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actor_id int NOT NULL,
    actor_name text NOT NULL
);