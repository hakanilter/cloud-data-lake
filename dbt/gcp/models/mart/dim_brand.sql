SELECT
    {{ dbt_utils.generate_surrogate_key(['brand']) }} AS _sk_brand_id,
    brand,
    COUNT(DISTINCT asin) num_products,

    -- Metadata
    CURRENT_DATETIME() AS _model_update_time
FROM
    {{ ref('product') }}
GROUP BY
    brand
