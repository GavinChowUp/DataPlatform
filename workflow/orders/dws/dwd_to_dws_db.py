from datetime import datetime, timedelta
from airflow import DAG, macros
from airflow.providers.postgres.operators.postgres import PostgresOperator
from airflow.operators.trigger_dagrun import TriggerDagRunOperator

# this_dag_path = '/opt/airflow/dags/dmi/'


with DAG(
        'From_Dwd_To_Dws_DB',
        default_args={
            'owner': 'airflow',
            'depends_on_past': False,
            'email': ['rong.han@thoughtworks.com'],
            'email_on_failure': False,
            'email_on_retry': False,
            'retries': 1,
            'retry_delay': timedelta(minutes=1)
        },
        description='Copy data from dwd',
        schedule_interval=timedelta(days=1),
        start_date=datetime(2022, 9, 12),
        tags=['data_warehouse']
) as dag:

    everyday_dws_task = PostgresOperator(
        task_id='everyday_dws',
        postgres_conn_id='olap_db',
        sql='create_everyday_dws_table.sql',
        dag=dag,
    )
    dwd_to_dws_task = PostgresOperator(
        task_id='dwd_to_dws_db',
        postgres_conn_id='olap_db',
        sql='dwd_to_dws.sql',
        dag=dag,
    )

    trigger_dws_to_ads = TriggerDagRunOperator(
        task_id='trigger_dws_to_ads',
        trigger_dag_id='From_Dws_To_Ads_DB',
        execution_date='{{ ds }}',
        reset_dag_run=True,
        wait_for_completion=True
    )

    everyday_dws_task >> dwd_to_dws_task >> trigger_dws_to_ads
