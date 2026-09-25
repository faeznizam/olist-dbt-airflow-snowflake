-- Delivery date should never be earlier than the purchase date
-- This test should return zero rows to pass

SELECT
    order_id,
    order_purchase_timestamp,
    order_delivered_customer_date
FROM {{ ref('fact_order_items') }}
WHERE order_delivered_customer_date < order_purchase_timestamp