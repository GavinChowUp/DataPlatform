from datetime import datetime, timedelta
from airflow import DAG, macros
from airflow.providers.postgres.operators.postgres import PostgresOperator
from airflow.operators.trigger_dagrun import TriggerDagRunOperator

with DAG(
        'From_Ods_To_Dwd_DB',
        default_args={
            'owner': 'airflow',
            'depends_on_past': False,
            'email': ['rong.han@thoughtworks.com'],
            'email_on_failure': False,
            'email_on_retry': False,
            'retries': 1,
            'retry_delay': timedelta(minutes=1)
        },
        description='Copy data from ods',
        schedule_interval=timedelta(days=1),
        start_date=datetime(2022, 9, 12),
        tags=['data_warehouse']
) as dag:

    everyday_dwd_task = PostgresOperator(
        task_id='everyday_dwd',
        postgres_conn_id='olap_db',
        sql='dwd_table_init_everyday.sql',
        dag=dag,
    )
    ods_to_dwd_task = PostgresOperator(
        task_id='ods_to_dwd_db',
        postgres_conn_id='olap_db',
        sql='ods_to_dwd.sql',
        dag=dag,
    )

    trigger_dwd_to_dws = TriggerDagRunOperator(
        task_id='trigger_dwd_to_dws',
        trigger_dag_id='From_Dwd_To_Dws_DB',
        execution_date='{{ ds }}',
        reset_dag_run=True,
        wait_for_completion=True
    )

    everyday_dwd_task >> ods_to_dwd_task >> trigger_dwd_to_dws
