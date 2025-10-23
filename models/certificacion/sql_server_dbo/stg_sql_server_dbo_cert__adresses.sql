with 

source as (

    select * from {{ source('sql_server_dbo_cert', 'adresses') }}

),

renamed as (

    select

    from source

)

select * from renamed