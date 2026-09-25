SELECT 
    order_id, 
    payment_sequential, 
    payment_type, 
    payment_installments, 
    payment_value 
FROM {{ source('olist_raw', 'raw_order_payment') }} 
WHERE order_id IS NOT NULL