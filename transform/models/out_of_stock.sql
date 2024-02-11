-- part_out_of_stock_days.sql

WITH stock_intervals AS (
    SELECT
        part_id,
        movement_date AS start_date,
        LEAD(movement_date) OVER (PARTITION BY part_id ORDER BY movement_date) AS end_date,
        SUM(quantity_changed) OVER (PARTITION BY part_id ORDER BY movement_date) AS running_quantity
    FROM
        {{ source('mydata', 'movements') }}
),
out_of_stock_intervals AS (
    SELECT
        part_id,
        start_date AS out_of_stock_date,
        end_date AS restocked_date
    FROM
        stock_intervals
    WHERE
        running_quantity <= 0
)
SELECT
    i.part_id,
    i.part_name,
    SUM(DATEDIFF('day', os.out_of_stock_date, COALESCE(os.restocked_date, CURRENT_DATE()))) AS total_days_out_of_stock
FROM
    {{ source('mydata', 'inventory') }} i
LEFT JOIN
    out_of_stock_intervals os ON i.part_id = os.part_id
GROUP BY
    i.part_id,
    i.part_name
