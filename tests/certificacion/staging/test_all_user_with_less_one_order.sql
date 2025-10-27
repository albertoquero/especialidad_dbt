--TEST SINGULAR
select O.*
from {{ ref("stg_sql_server_dbo_cert__orders") }} O
RIGHT JOIN {{ ref("stg_sql_server_dbo_cert__users") }} U
    ON O.user_id = U.USER_ID
WHERE O.USER_ID IS NULL