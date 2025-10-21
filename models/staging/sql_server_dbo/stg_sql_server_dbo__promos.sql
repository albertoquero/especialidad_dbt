with 

src_promos  as (

    select * from {{ ref('base_sql_server_dbo__promos') }}

),

renamed as (
SELECT
    promo_id
    , name_promo
    , total_discount_usd
    , status_promo
    , date_load
    FROM src_promos

)

select * from renamed