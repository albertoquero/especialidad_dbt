WITH stg_products AS (
    SELECT * 
    FROM {{ ref ('stg_sql_server_dbo__products') }}
    ),

renamed_casted AS (
    SELECT
        product_id 
        , product_name
        , unit_price_usd
        , inventory
        , date_load
    FROM stg_products
    )

SELECT * FROM renamed_casted