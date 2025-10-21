WITH stg_budget AS (
    SELECT * 
    FROM {{ ref('stg_google_sheets__budget') }}
    ),

renamed_casted AS (
    SELECT
        product_id
        , month
       -- , quantity
        , date_load
    FROM stg_budget
    )

SELECT * FROM renamed_casted