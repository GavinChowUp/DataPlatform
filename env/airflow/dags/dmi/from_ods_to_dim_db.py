from datetime import datetime, timedelta
from airflow import DAG
from airflow.providers.postgres.operators.postgres import PostgresOperator

# this_dag_path = '/opt/airflow/dags/dmi/'

with DAG(
        'From_Ods_To_Dim_DB',
        default_args={
            'owner': 'airflow',
            'depends_on_past': False,
            'email': ['rong.han@thoughtworks.com'],
            'email_on_failure': False,
            'email_on_retry': False,
            'retries': 1,
            'retry_delay': timedelta(minutes=1)
        },
        # template_searchpath=[this_dag_path],
        description='Copy data from ods',
        schedule_interval=timedelta(days=1),
        start_date=datetime(2022, 8, 23),
        tags=['data_warehouse']
) as dag:
    init_dim_task = PostgresOperator(
        task_id='init_dim',
        postgres_conn_id='olap_db',
        sql='dmi_table_init.sql',
        dag=dag,
    )
    everyday_dmi_task = PostgresOperator(
        task_id='everyday_dmi',
        postgres_conn_id='olap_db',
        sql='dmi_table_init_everyday.sql',
        dag=dag,
    )
    ods_to_dmi_task = PostgresOperator(
        task_id='ods_to_dmi',
        postgres_conn_id='olap_db',
        sql='ods_to_dmi.sql',
        dag=dag,
    )
    init_dim_task >> everyday_dmi_task >> ods_to_dmi_task