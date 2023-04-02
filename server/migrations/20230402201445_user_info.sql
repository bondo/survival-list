ALTER TABLE users
ADD COLUMN uid text NOT NULL,
ADD COLUMN picture_url text;

CREATE UNIQUE INDEX uid_unique_idx ON users (uid);