SELECT
    seller_id, 
    seller_zip_code_prefix AS seller_zipcode_prefix,
    seller_city, 
    seller_state 
FROM {{ ref('stg_sellers') }}