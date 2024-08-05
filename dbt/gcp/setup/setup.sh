#!/bin/sh
PROJECT_ID="datapyro"
REGION="europe-west2"
BUCKET_NAME="${PROJECT_ID}-cloud-data-lake"

# Login and setup
gcloud auth login || exit 1
gcloud config set project ${PROJECT_ID} || exit 1

# Create bucket
gcloud storage buckets create gs://${BUCKET_NAME} --location ${REGION} --public-access-prevention || exit 1

# Upload sample data
gsutil -m cp -R ../../../data/amazon gs://${BUCKET_NAME}/

# Create BigQuery dataset
bq mk --dataset --location ${REGION} ${PROJECT_ID}:raw_data || exit 1

# Prepare source table
TEMP_FILE=/tmp/amazon_product.sql
cp ../ddl/amazon_product.sql ${TEMP_FILE}
sed -i -e "s/<YOUR-BUCKET>/${BUCKET_NAME}/g" ${TEMP_FILE}
bq query --use_legacy_sql=false < ${TEMP_FILE}
