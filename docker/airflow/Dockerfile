FROM python:3.11-slim

ARG airflow_version

COPY conf/requirements.txt /root/airflow/requirements.txt

RUN pip install --upgrade pip && \
    pip install apache-airflow[postgres,amazon]==${airflow_version} && \
    pip install -r /root/airflow/requirements.txt

COPY conf/variables.json /root/airflow/variables.json
COPY conf/webserver_config_local.py /root/airflow/webserver_config.py
COPY conf/airflow.cfg /root/airflow/airflow.cfg

ENTRYPOINT ["airflow", "standalone"]
