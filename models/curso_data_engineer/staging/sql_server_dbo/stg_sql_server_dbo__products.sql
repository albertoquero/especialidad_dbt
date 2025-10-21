with 

source as (

    select * from {{ source('sql_server_dbo', 'products') }}

),

renamed as (

    select
        product_id AS product_id
        , name AS product_name
        , price AS unit_price_usd
        , inventory AS inventory
        , _fivetran_synced AS date_load

    from source

)

select * from renamed