WITH src_promos AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'promos') }}
    ),

renamed_casted AS (
    SELECT
    promo_id
     ,promo_id AS name_promo
    , discount AS total_discount_usd
    , status AS status_promo
    , _fivetran_synced AS date_load
    FROM src_promos
    )

SELECT * FROM renamed_casted