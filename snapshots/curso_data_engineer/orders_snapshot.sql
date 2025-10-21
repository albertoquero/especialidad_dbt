{% snapshot orders_snapshot %}

{{
    config(
      unique_key='order_id',
      strategy='timestamp',
      updated_at='_fivetran_synced',
    )
}}

select * from {{ source('sql_server_dbo', 'orders') }}

{% endsnapshot %}