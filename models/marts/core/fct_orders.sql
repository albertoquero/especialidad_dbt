{{
    config(
        materialized='incremental'
    )
}}

WITH base_orders AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo__orders') }}
),


renamed_casted AS (
    SELECT
        order_id 
        , user_id 
        , promo_id
        , address_id
        , created_at_utc
        , item_order_cost_usd
        , shipping_cost_usd
        , total_order_cost_usd
        , tracking_id
        , shipping_service
        , estimated_delivery_at_utc
        , delivered_at_utc
        , status_order
        , date_load
    FROM base_orders
    )

SELECT * FROM renamed_casted

{% if is_incremental() %}

  -- this filter will only be applied on an incremental run
  where date_load > (select max(date_load) from {{ this }})

{% endif %}