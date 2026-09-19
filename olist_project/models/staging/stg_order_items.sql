SELECT 
    order_id, 
    order_item_id, 
    product_id, 
    seller_id, 
    shipping_limit_date, 
    price, 
    freight_value 
FROM {{ source('olist_raw', 'raw_order_item') }} 
WHERE order_id IS NOT NULL AND order_item_id IS NOT NULL