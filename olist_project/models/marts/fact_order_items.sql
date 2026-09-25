SELECT
    oi.order_id,
    oi.order_item_id,
    o.customer_id,
    oi.product_id,
    oi.seller_id,
    CAST(o.order_purchase_timestamp AS DATE) AS order_purchase_date,
    o.order_status,
    oi.price,
    oi.freight_value,
    (oi.price + oi.freight_value) AS total_item_value,
    o.order_purchase_timestamp,
    o.order_approved_at,
    o.order_delivered_carrier_date,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date, 
    DATEDIFF('day', o.order_purchase_timestamp, o.order_delivered_customer_date) AS delivery_days,
FROM {{ ref('stg_order_items') }} AS oi
LEFT JOIN {{ ref('stg_orders') }} AS o
ON o.order_id = oi.order_id

