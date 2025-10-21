WITH stg_addresses AS (
    SELECT * 
    FROM {{ ref ('stg_sql_server_dbo__addresses') }}
    ),

renamed_casted AS (
    SELECT
        address_id
        , address
        , zipcode
        , state
        , country
        , date_load
    FROM stg_addresses
    )

SELECT * FROM renamed_casted