DELETE FROM
    tasks
WHERE
    start_date IS NULL AND
    end_date IS NULL;

ALTER TABLE
    tasks
ADD CONSTRAINT
    period_not_empty CHECK (
        start_date IS NOT NULL OR
        end_date IS NOT NULL
    );
