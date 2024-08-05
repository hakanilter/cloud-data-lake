DROP TABLE IF EXISTS raw_data.amazon_product;
--
CREATE EXTERNAL TABLE raw_data.amazon_product
(
    asin STRING,
    title STRING,
    brand STRING,
    breadcrumbs STRING,
    price STRING,
    product_details STRING,
    url STRING,
    features JSON
)
WITH PARTITION COLUMNS (
    ingestion_date STRING
)
OPTIONS (
    uris = ['gs://<YOUR-BUCKET>/amazon/raw_product/*'],
    format = 'JSON',
    hive_partition_uri_prefix = 'gs://<YOUR-BUCKET>/amazon/raw_product/',
    require_hive_partition_filter = false
);
