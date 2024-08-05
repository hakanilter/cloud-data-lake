#!/bin/bash
cd -- "$(dirname "$0")"
cd ..

AIRFLOW_VERSION=2.9.3
IMAGE_NAME="datapyro/airflow:${AIRFLOW_VERSION}"

docker build -t ${IMAGE_NAME} --build-arg airflow_version=${AIRFLOW_VERSION} . || exit 1
docker tag ${IMAGE_NAME} datapyro/airflow:latest
