from datetime import datetime, timedelta
from airflow import DAG, macros
from airflow.providers.postgres.operators.postgres import PostgresOperator

# this_dag_path = '/opt/airflow/dags/dmi/'


with DAG(
        'From_Dws_To_Ads_DB',
        default_args={
            'owner': 'airflow',
            'depends_on_past': False,
            'email': ['rong.han@thoughtworks.com'],
            'email_on_failure': False,
            'email_on_retry': False,
            'retries': 1,
            'retry_delay': timedelta(minutes=1)
        },
        description='Copy data from dws',
        schedule_interval=timedelta(days=1),
        start_date=datetime(2022, 9, 12),
        tags=['data_warehouse']
) as dag:
    dws_to_dws_task = PostgresOperator(
        task_id='dws_to_ads_db',
        postgres_conn_id='olap_db',
        sql='dws_to_ads.sql',
        dag=dag,
    )
    dws_to_dws_task
