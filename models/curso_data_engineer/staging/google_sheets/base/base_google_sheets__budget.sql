{{
  config(
    materialized='view'
  )
}}

WITH src_budget AS (
    SELECT * 
    FROM {{ source('google_sheets', 'budget') }}
    ),

renamed_casted AS (
    SELECT
          _row
        , product_id
        , quantity
        , month
        , {{ dbt_utils.generate_surrogate_key(['_row','product_id','quantity','month']) }} as subrogate_key
        , _fivetran_synced AS date_load
    FROM src_budget
    )

SELECT * FROM renamed_casted