with 

source as (

    select * from {{ source('sql_server_dbo', 'events') }}

),

renamed as (

    select
        event_id
        , session_id
        , user_id
        , page_url
        , created_at AS created_at_utc
        , event_type
        , order_id
        , product_id
        , _fivetran_synced AS date_load

    from source

)

select * from renamed