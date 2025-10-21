{{
  config(
    materialized='incremental',
    unique_key='_row',
    on_schema_change='append_new_columns'

  )
}}

WITH src_budget AS (
    SELECT * 
    FROM {{ source('google_sheets', 'budget') }}
    {% if is_incremental() %}

	  WHERE _fivetran_synced > (SELECT MAX(date_load) FROM {{ this }} )

{% endif %}
    ),

renamed_casted AS (
    SELECT
          _row
        , product_id
        , quantity
        , month
        , _fivetran_synced AS date_load
    FROM src_budget
    )

SELECT * FROM renamed_casted