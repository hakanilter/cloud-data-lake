{{ config(materialized='view') }}

SELECT
    -- SK
    {{ dbt_utils.generate_surrogate_key(['asin']) }} AS _sk_product_id,

    -- Columns
    asin,
    title,
    brand,
    breadcrumbs AS bread_crumb,
    price,
    product_details,
    url,

    -- Metadata
    ingestion_date AS _ingestion_date
FROM
    {{ source('raw_data', 'amazon_product') }}
