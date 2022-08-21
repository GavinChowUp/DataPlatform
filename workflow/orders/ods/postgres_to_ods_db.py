from datetime import datetime, timedelta
from airflow import DAG
from airflow.providers.postgres.operators.postgres import PostgresOperator
from airflow.hooks.postgres_hook import PostgresHook

from airflow.operators.python import PythonOperator
from airflow.utils.dates import days_ago
from airflow.models import Variable


def oltp_to_ods():
    src = PostgresHook(postgres_conn_id='oltp_db')
    dest = PostgresHook(postgres_conn_id='olap_db')
    src_conn = src.get_conn()
    cursor = src_conn.cursor()
    dest_conn = dest.get_conn()
    dest_cursor = dest_conn.cursor()

    cursor.execute("SELECT * FROM oltp.address ;")
    dest.insert_rows(table="ods.ods_address", rows=cursor)

    cursor.execute("SELECT * FROM oltp.customer ;")
    dest.insert_rows(table="ods.ods_customer", rows=cursor)

    cursor.execute("SELECT * FROM oltp.customer_address ;")
    dest.insert_rows(table="ods.ods_customer_address", rows=cursor)

    cursor.execute("SELECT * FROM oltp.product ;")
    dest.insert_rows(table="ods.ods_product", rows=cursor)

    cursor.execute("SELECT * FROM oltp.product_category ;")
    dest.insert_rows(table="ods.ods_product_category", rows=cursor)

    cursor.execute("SELECT * FROM oltp.product_description ;")
    dest.insert_rows(table="ods.ods_product_description", rows=cursor)

    cursor.execute("SELECT * FROM oltp.product_model ;")
    dest.insert_rows(table="ods.ods_product_model", rows=cursor)

    cursor.execute("SELECT * FROM oltp.product_model_product_desc ;")
    dest.insert_rows(table="ods.ods_product_model_product_desc", rows=cursor)

    cursor.execute("SELECT * FROM oltp.sales_order;")
    dest.insert_rows(table="ods.ods_sales_order", rows=cursor)

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
            'retry_delay': timedelta(minutes=5),
        },
        description='Copy data from mysql',
        schedule_interval=timedelta(days=1),
        start_date=datetime(2008, 5, 1),
        tags=['data_warehouse'],
) as dag:
    init_ods_task = PostgresOperator(
        task_id='init_ods_db',
        postgres_conn_id='olap_db',
        sql='ods_db_init.sql',
        dag=dag,
    )
    db_migrate_task = PythonOperator(
        task_id='oltp_to_ods',
        python_callable=oltp_to_ods,
    )
    init_ods_task >> db_migrate_task
