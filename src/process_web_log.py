from airflow import DAG
from airflow.operators.bash_operator import BashOperator

from datetime import datetime, timedelta

default_args = {
    'owner':'Pedrosa',
    'start_date': datetime(2023,4,13),
    'email': ['pedrosa@email.com']
}

dag = DAG(
    dag_id="process_web_log",
    default_args=default_args,
    description="ETL to process web server log",
    schedule_interval=timedelta(days=1)
)

extract_data = BashOperator(
    task_id="extract_data",
    bash_command="cut -d\" \" -f1 capstone/accesslog.txt > capstone/extracted_data.txt",
    dag=dag
)

transform_data = BashOperator(
    task_id="transform_data",
    bash_command="grep 198.46.149.143 capstone/extracted_data.txt > capstone/transformed_data.txt",
    dag=dag
)

load_data = BashOperator(
    task_id="load_data",
    bash_command="tar -czvf weblog.tar capstone/transformed_data.txt",
    dag=dag
)

extract_data >> transform_data >> load_data


