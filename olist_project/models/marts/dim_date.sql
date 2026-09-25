WITH date_spine AS (
    SELECT
        DATEADD(DAY, seq4(), '2016-01-01') AS date_day
    FROM TABLE(GENERATOR(ROWCOUNT => 2000)) -- Generate 10 years of dates
)

SELECT
    date_day,
    YEAR(date_day) AS year,
    MONTH(date_day) AS month,
    DAY(date_day) AS day,
    DAYNAME(date_day) AS day_name,
    MONTHNAME(date_day) AS month_name,
    QUARTER(date_day) AS quarter,
    DAYOFWEEK(date_day) AS day_of_week,
    CASE
        WHEN DAYOFWEEK(date_day) IN (0, 6) THEN TRUE
        ELSE FALSE
    END AS is_weekend

FROM date_spine
WHERE date_day <= '2021-12-31'