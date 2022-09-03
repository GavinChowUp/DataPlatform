from datetime import datetime, timedelta
from airflow import DAG, macros
from airflow.providers.postgres.operators.postgres import PostgresOperator

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
        start_date=datetime(2022, 8, 23),
        tags=['data_warehouse']
) as dag:
    init_dws_task = PostgresOperator(
        task_id='init_dws',
        postgres_conn_id='olap_db',
        sql='create_dws_table.sql',
        dag=dag,
    )
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
    init_dws_task >> everyday_dws_task >> dwd_to_dws_task
