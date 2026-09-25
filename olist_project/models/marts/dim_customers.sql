SELECT
    customer_id, 
    customer_unique_id, 
    customer_zip_code_prefix as customer_zipcode, 
    customer_city, 
    customer_state 
FROM {{ ref('stg_customers')}}