{{ config(
    materialized='incremental',
    unique_key = '_row'
    ) 
    }}


WITH stg_budget AS (
    SELECT * 
    FROM {{ ref('stg_google_sheets__budget') }}

    ),

renamed_casted AS (
    SELECT
          _row
        , month
        , quantity 
        , date_load
    FROM stg_budget
    )

SELECT * FROM renamed_casted

{% if is_incremental() %}

  where date_load > (select max(date_load) from {{ this }})

{% endif %}