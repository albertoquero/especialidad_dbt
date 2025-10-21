WITH stg_events AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo__events') }}
    ),

renamed_casted AS (
    SELECT
	       user_id
        ,sum(case when event_type = 'checkout' then 1 end) as checkout_amount
        ,sum(case when event_type = 'package_shipped' then 1 end) as package_shipped_amount
        ,sum(case when event_type = 'add_to_cart' then 1 end) as add_to_cart_amount
        ,sum(case when event_type = 'page_view' then 1 end) as page_view_amount
    FROM stg_events
    GROUP BY 1
    )

SELECT * FROM renamed_casted