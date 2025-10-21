WITH stg_promos AS (
    SELECT * 
    FROM {{ ref ('stg_sql_server_dbo__promos') }}
    ),

renamed_casted AS (
    SELECT
        promo_id
        , name_promo
        , total_discount_usd
        , status_promo
        , date_load
    FROM stg_promos
    )

SELECT * FROM renamed_casted