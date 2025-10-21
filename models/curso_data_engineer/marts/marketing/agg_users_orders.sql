WITH users AS (
    SELECT * 
    FROM {{ ref('dim_users') }}
    ),

addresses AS (
    SELECT * 
    FROM {{ ref('dim_addresses') }}
    ),
promos AS (
    SELECT * 
    FROM {{ ref('dim_promos') }}
    ),
orders AS (
    SELECT * 
    FROM {{ ref('fct_orders') }}
    ),
orders_products AS (
    SELECT * 
    FROM {{ ref('fct_orders_products') }}
    ),
orders_products_join AS (
    SELECT
        O.order_id 
        , O.user_id 
        , O.promo_id
        , O.address_id
        , OI.product_id
        , O.created_at_utc
        , OI.quantity
        , O.status_order
        , O.date_load
    FROM orders O
    LEFT JOIN orders_products OI
      ON O.order_id = OI.order_id
    ),
users_orders_agg AS (
    SELECT 
        user_id
        ,COUNT(o.order_id) AS total_number_orders
        ,SUM(o.total_order_cost_usd ) AS total_order_cost_usd
        ,SUM(o.shipping_cost_usd ) AS total_shipping_cost_usd
        ,SUM(p.total_discount_usd ) AS total_discount_usd
    FROM orders O
    LEFT JOIN promos P
    ON o.promo_id = p.promo_id
    GROUP BY 1
    ),
users_orders_products_agg AS (
    SELECT
        user_id
        , SUM (quantity) AS total_quantity_product
        , COUNT(DISTINCT product_id ) AS total_different_product_purchased
    FROM orders_products_join
    GROUP BY 1
    ),    
agg_users_orders AS (
    SELECT 
        u.user_id
        ,u.first_name
        ,u.last_name
        ,u.email
        ,u.phone_number
        ,u.created_at_utc
        ,u.updated_at_utc
        ,a.address
        ,a.zipcode
        ,a.state
        ,a.country
        ,COALESCE(oa.total_number_orders,0) AS total_number_orders
        ,COALESCE(oa.total_order_cost_usd,0) AS total_order_cost_usd
        ,COALESCE(oa.total_shipping_cost_usd,0) AS total_shipping_cost_usd
        ,COALESCE(oa.total_discount_usd,0) AS total_discount_usd
        ,COALESCE(pa.total_quantity_product,0) AS total_quantity_product
        ,COALESCE(pa.total_different_product_purchased,0) AS total_different_product_purchased
    FROM users U
    LEFT JOIN addresses A
        ON u.address_id = a.address_id
    LEFT JOIN users_orders_agg OA
        ON U.user_id = OA.user_id
    LEFT JOIN users_orders_products_agg PA
        ON U.user_id = PA.user_id
    )

SELECT * FROM agg_users_orders