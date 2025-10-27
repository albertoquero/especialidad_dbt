/*ESTE TEST VALIDA QUE EL CAMPO QUANTITY SEA SIEMPRE VALORES POSITIVOS. */


{{ config(
    tags=['test_singular_sql'],
    schema='SINGULAR_TEST_SQL',
    database= env_var('DBT_DB_USER') ~'_CERT_'~ env_var('DBT_ENVIRONMENTS_LAYER') ~'_BRONZE_DB',   
    store_failures = true,
    severity = 'error',
    warn_if = "<2",
    error_if = ">=2"
    
) }}

select
    _row,
    quantity as cantidad
from {{ source('google_sheets_cert','source_budget') }}
where quantity < 0


