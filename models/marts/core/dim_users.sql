with users as (

    select * from {{ ref('stg_sql_server_dbo__users') }}

),
    
validate_users_email as (

    select
        user_id,
        first_name,
        coalesce (regexp_like(first_name, '^[A-Z][a-z]*$')= true,false)  as is_valid_first_name,
        last_name,
        correo as email,
        coalesce (regexp_like(correo, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')= true,false) as is_valid_email_address
        , phone_number
        , coalesce (regexp_like (phone_number, '^\\d{3}-\\d{3}-\\d{4}$')= true,false) as is_valid_phone_number
        , created_at_utc
        , updated_at_utc
        , address_id
        , date_load
    from users

)

select * from validate_users_email