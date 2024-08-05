{{ config(materialized='view') }}

SELECT
    -- SK
    {{ dbt_utils.generate_surrogate_key(['asin']) }} AS _sk_product_id,

    -- Columns
    REGEXP_EXTRACT_ALL(TO_JSON_STRING(feature), r'"([^"]+)":"[^"]*"') AS feature_name,
    REGEXP_EXTRACT_ALL(TO_JSON_STRING(feature), r'"[^"]+":"([^"]*)"') AS feature_value
FROM
    {{ source('raw_data', 'amazon_product') }}
CROSS JOIN
    UNNEST(JSON_QUERY_ARRAY(features)) AS feature
