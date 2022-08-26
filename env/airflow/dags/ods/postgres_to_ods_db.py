from datetime import datetime, timedelta
from airflow import DAG
from airflow.providers.postgres.operators.postgres import PostgresOperator
from airflow.hooks.postgres_hook import PostgresHook

from airflow.operators.python import PythonOperator
from airflow.utils.dates import days_ago
from airflow.models import Variable

your_settings = {
    "yesterday_ds_nodash": "{{ yesterday_ds_nodash }}",
    "some_params": "some_value",
}


def oltp_to_ods(**context):
    src = PostgresHook(postgres_conn_id='oltp_db')
    dest = PostgresHook(postgres_conn_id='olap_db')
    src_conn = src.get_conn()
    cursor = src_conn.cursor()
    dest_conn = dest.get_conn()
    dest_cursor = dest_conn.cursor()

    print(f"context:{context}")
    schema_name = "ods"
    print(f"schema_name:{schema_name}")
    table_suffix = "_" + context["yesterday_ds_nodash"]

    cursor.execute("SELECT * FROM oltp.address ;")
    dest.insert_rows(table=schema_name + ".ods_address" + table_suffix, rows=cursor)

    cursor.execute("SELECT * FROM oltp.customer ;")
    dest.insert_rows(table=schema_name + ".ods_customer" + table_suffix, rows=cursor)

    cursor.execute("SELECT * FROM oltp.customer_address ;")
    dest.insert_rows(table=schema_name + ".ods_customer_address" + table_suffix, rows=cursor)

    cursor.execute("SELECT * FROM oltp.product ;")
    dest.insert_rows(table=schema_name + ".ods_product" + table_suffix, rows=cursor)

    cursor.execute("SELECT * FROM oltp.product_category ;")
    dest.insert_rows(table=schema_name + ".ods_product_category" + table_suffix, rows=cursor)

    cursor.execute("SELECT * FROM oltp.product_description ;")
    dest.insert_rows(table=schema_name + ".ods_product_description" + table_suffix, rows=cursor)

    cursor.execute("SELECT * FROM oltp.product_model ;")
    dest.insert_rows(table=schema_name + ".ods_product_model" + table_suffix, rows=cursor)

    cursor.execute("SELECT * FROM oltp.product_model_product_desc ;")
    dest.insert_rows(table=schema_name + ".ods_product_model_product_desc" + table_suffix, rows=cursor)

    cursor.execute("SELECT * FROM oltp.sales_order;")
    dest.insert_rows(table=schema_name + ".ods_sales_order" + table_suffix, rows=cursor)


    # dest_cursor.execute("SELECT MAX(product_id) FROM ods.ods_product;")
    # product_id = dest_cursor.fetchone()[0]
    # if product_id is None:
    #     product_id = 0
    # cursor.execute("SELECT * FROM oltp.product WHERE product_id > %s", [product_id])
    # dest.insert_rows(table="ods.ods_product", rows=cursor)

    # dest_cursor.execute("SELECT MAX(order_id) FROM orders;")
    # order_id = dest_cursor.fetchone()[0]
    # if order_id is None:
    #     order_id = 0
    # cursor.execute("SELECT * FROM orders WHERE order_id > %s", [order_id])
    # dest.insert_rows(table="orders", rows=cursor)


with DAG(
        'Oltp_To_Ods_DB',
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
    init_ods_task = PostgresOperator(
        task_id='init_ods_db',
        postgres_conn_id='olap_db',
        sql='ods_db_init.sql',
        dag=dag,
    )
    everyday_ods_task = PostgresOperator(
        task_id='everyday_ods_db',
        postgres_conn_id='olap_db',
        sql='ods_db_init_everyday.sql',
        dag=dag,
    )
    db_migrate_task = PythonOperator(
        task_id='oltp_to_ods',
        python_callable=oltp_to_ods,
        provide_context=True,
        templates_dict=your_settings
    )

init_ods_task >> everyday_ods_task >> db_migrate_task

