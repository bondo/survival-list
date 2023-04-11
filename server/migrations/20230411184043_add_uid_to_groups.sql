ALTER TABLE groups
ADD COLUMN uid uuid NOT NULL DEFAULT gen_random_uuid();

CREATE UNIQUE INDEX group_uid_unique_idx ON groups (uid);
