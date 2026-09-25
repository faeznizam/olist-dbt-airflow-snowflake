-- This test should return zero rows to pass
-- If it returns any rows, those are the offending records

SELECT
    order_id,
    order_item_id,
    price,
    freight_value
FROM {{ ref('stg_order_items') }}
WHERE price < 0 OR freight_value < 0

