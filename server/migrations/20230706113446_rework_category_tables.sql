ALTER TABLE tasks
	DROP COLUMN category_id,
	DROP COLUMN subcategory_id;

DROP TABLE subcategories;

DROP TABLE categories;

CREATE TABLE categories(
	id serial PRIMARY KEY,
	raw_title text NOT NULL,
	created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE categories_override(
	category_id int NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
	user_id int NOT NULL REFERENCES users(id) ON DELETE CASCADE,
	color text,
	is_enabled boolean NOT NULL DEFAULT TRUE,
	created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (category_id, user_id)
);

ALTER TABLE tasks
	ADD COLUMN category_id int REFERENCES categories(id) ON DELETE SET NULL;

CREATE TABLE subcategories(
	id serial PRIMARY KEY,
	title text NOT NULL,
	category_id int NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
	user_id int NOT NULL REFERENCES users(id) ON DELETE CASCADE,
	color text,
	created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE tasks_subcategories(
	task_id int NOT NULL REFERENCES tasks(id) ON DELETE CASCADE,
	user_id int NOT NULL REFERENCES users(id) ON DELETE CASCADE,
	subcategory_id int NOT NULL REFERENCES subcategories(id) ON DELETE CASCADE,
	created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (task_id, user_id)
);

