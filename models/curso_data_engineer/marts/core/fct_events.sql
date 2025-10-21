WITH stg_events AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo__events') }}
    ),

renamed_casted AS (
    SELECT
        event_id
        , session_id
        , user_id
        , page_url
        , created_at_utc
        , event_type
        , order_id
        , product_id
        , date_load
    FROM stg_events
    )

SELECT * FROM renamed_casted