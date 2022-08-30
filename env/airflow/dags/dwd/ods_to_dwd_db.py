from datetime import datetime, timedelta
from airflow import DAG
from airflow.providers.postgres.operators.postgres import PostgresOperator
from airflow.hooks.postgres_hook import PostgresHook

from airflow.operators.python import PythonOperator


your_settings = {
    "yesterday_ds_nodash": "{{ yesterday_ds_nodash }}",
    "some_params": "some_value",
}

def ods_to_dwd(**context):
    src = PostgresHook(postgres_conn_id='olap_db')
    dest = PostgresHook(postgres_conn_id='olap_db')
    src_conn = src.get_conn()
    cursor = src_conn.cursor()
    dest_conn = dest.get_conn()
    dest_cursor = dest_conn.cursor()

    print(f"context:{context}")
    schema_name = "dwd"
    print(f"schema_name:{schema_name}")
    table_suffix = "_" + context["yesterday_ds_nodash"]

    cursor.execute("SELECT * FROM ods.ods_address ;")
    dest.insert_rows(table=schema_name + ".dwd_address" + table_suffix, rows=cursor)

    cursor.execute("SELECT * FROM ods.ods_customer ;")
    dest.insert_rows(table=schema_name + ".dwd_customer" + table_suffix, rows=cursor)

    cursor.execute("SELECT * FROM ods.ods_customer_address ;")
    dest.insert_rows(table=schema_name + ".dwd_customer_address" + table_suffix, rows=cursor)

    cursor.execute("select * from ods.ods_product where size != 'NULL' or weight IS NOT NULL;;")
    dest.insert_rows(table=schema_name + ".dwd_product" + table_suffix, rows=cursor)

    cursor.execute("SELECT * FROM ods.ods_product_category ;")
    dest.insert_rows(table=schema_name + ".dwd_product_category" + table_suffix, rows=cursor)

    cursor.execute("SELECT * FROM ods.ods_product_description ;")
    dest.insert_rows(table=schema_name + ".dwd_product_description" + table_suffix, rows=cursor)

    cursor.execute("SELECT * FROM ods.ods_product_model ;")
    dest.insert_rows(table=schema_name + ".dwd_product_model" + table_suffix, rows=cursor)

    cursor.execute("SELECT * FROM ods.ods_product_model_product_desc ;")
    dest.insert_rows(table=schema_name + ".dwd_product_model_product_desc" + table_suffix, rows=cursor)

    cursor.execute("SELECT * FROM ods.ods_sales_order;")
    dest.insert_rows(table=schema_name + ".dwd_sales_order" + table_suffix, rows=cursor)

with DAG(
        'Ods_To_Dwd_DB',
        default_args={
            'owner': 'airflow',
            'depends_on_past': False,
            'email': ['rong.han@thoughtworks.com'],
            'email_on_failure': False,
            'email_on_retry': False,
            'retries': 1,
            'retry_delay': timedelta(minutes=1)
        },
        description='Copy data from postgres',
        schedule_interval=timedelta(days=1),
        start_date=datetime(2022, 8, 21),
        tags=['data_warehouse']
) as dag:
    init_dwd_task = PostgresOperator(
        task_id='init_dwd_db',
        postgres_conn_id='olap_db',
        sql='dwd_db_init.sql',
        dag=dag,
    )
    everyday_dwd_task = PostgresOperator(
        task_id='everyday_dwd_db',
        postgres_conn_id='olap_db',
        sql='dwd_db_init_everyday.sql',
        dag=dag,
    )
    db_migrate_task = PythonOperator(
        task_id='ods_to_dwd',
        python_callable=ods_to_dwd,
        provide_context=True,
        templates_dict=your_settings
    )

init_dwd_task >> everyday_dwd_task >> db_migrate_task

