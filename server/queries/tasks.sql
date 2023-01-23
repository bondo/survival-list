--! get_tasks : (title?, start_date?, end_date?)
SELECT
    id,
    title,
    start_date,
    end_date
FROM
    tasks;