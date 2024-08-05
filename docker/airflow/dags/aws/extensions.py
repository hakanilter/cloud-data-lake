import os
from datetime import timedelta

from airflow.providers.amazon.aws.operators.ecs import EcsRunTaskOperator


def get_server_environment():
    return os.environ["ENV"]


def get_default_args():
    admins = os.environ.get("ADMIN_EMAILS", "").split(",")
    return {
        "depends_on_past": False,
        "email": admins,
        "email_on_failure": True,
        "email_on_retry": False,
        "retries": 1,
        "retry_delay": timedelta(minutes=5),
    }


def ecs_task(task_id, command, instance_type=None):
    env = get_server_environment()
    region = os.environ.get("AWS_DEFAULT_REGION", "eu-central-1")
    cluster = os.environ["AWS_ECS_CLUSTER"]    
    private_subnets = os.environ["AWS_NETWORK_CONFIG_SUBNETS"].split(",")
    security_groups = os.environ["AWS_NETWORK_CONFIG_SECURITY_GROUPS"].split(",")
    task_definition = f"python-job-{env}-{instance_type}"

    command = f"./run.sh python ./src/main/scripts/{command}"

    return EcsRunTaskOperator(
        task_id=task_id,
        cluster=cluster,
        task_definition=task_definition,
        launch_type="FARGATE",
        overrides={
            "containerOverrides": [
                {
                    "name": "jobs",
                    "command": command.split(" "),
                    "environment": [
                        {"name": "ENV", "value": env},
                    ]
                },
            ],
        },
        network_configuration={
            "awsvpcConfiguration": {
                "subnets": private_subnets,
                "securityGroups": security_groups,
                "assignPublicIp": "DISABLED",
            },
        },
        awslogs_group=f"/ecs/python-job-{env}",
        awslogs_region=region,
        awslogs_stream_prefix="ecs/jobs"
    )
