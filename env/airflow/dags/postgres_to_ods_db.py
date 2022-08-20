from datetime import datetime, timedelta
from airflow import DAG
from airflow.providers.mysql.operators.mysql import MySqlOperator

with DAG(
        'Mysql_To_Ods_DB',
        default_args={
            'owner': 'airflow',
            'depends_on_past': False,
            'email': ['rong.han@thoughtworks.com'],
            'email_on_failure': False,
            'email_on_retry': False,
            'retries': 1,
            'retry_delay': timedelta(minutes=5),
        },
        description='Copy data from mysql',
        schedule_interval=timedelta(days=1),
        start_date=datetime(2008, 5, 1),
        tags=['mysql'],
) as dag:
    init_ods_task = MySqlOperator(
        task_id='init_ods_db',
        mysql_conn_id='ods_db',
        sql='postgres_to_ods_db_init.sql',
        dag=dag,
    )
    query_task = MySqlOperator(
        task_id='query_from_oltp_db',
        mysql_conn_id='oltp_db',
        sql='../../../workflow/orders/ods/mysql_to_ods_db.sh',
        dag=dag,
    )
    save_to_mysql_task = MySqlOperator(
        task_id='save_to_ods_db',
        mysql_conn_id='ods_db',
        sql='../../../workflow/orders/ods/mysql_to_ods_db.sh',
        dag=dag,
    )
    init_ods_task >> query_task >> save_to_mysql_task
