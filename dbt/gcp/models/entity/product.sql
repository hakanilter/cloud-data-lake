{{ config(
    materialized='incremental',
    unique_key='_sk_product_id'
)}}

SELECT
    _sk_product_id,
    asin,
    title,
    brand,
    bread_crumb,
    price,
    product_details,
    url,

    -- Metadata
    'amazon' AS _source,
    _ingestion_date,
    CURRENT_DATETIME() AS _model_update_time
FROM
    {{ ref('stg_amazon_product') }}

{% if is_incremental() %}

    WHERE _ingestion_date >= (SELECT COALESCE(MAX(_ingestion_date), '1900-01-01') from {{ this }})

{% endif %}
