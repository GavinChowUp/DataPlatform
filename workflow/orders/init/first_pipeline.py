from airflow import DAG
from airflow.hooks.postgres_hook import PostgresHook
from airflow.operators.python import PythonOperator
from airflow.providers.postgres.operators.postgres import PostgresOperator
from datetime import datetime, timedelta

your_settings = {
    "yesterday_ds_nodash": "{{ yesterday_ds_nodash }}",
    "some_params": "some_value",
}


def init_oltp_to_ods(**context):
    src = PostgresHook(postgres_conn_id='oltp_db')
    dest = PostgresHook(postgres_conn_id='olap_db')
    src_conn = src.get_conn()
    cursor = src_conn.cursor()
    dest_conn = dest.get_conn()
    dest_cursor = dest_conn.cursor()

    print(f"context:{context}")
    schema_name = "ods"
    print(f"schema_name:{schema_name}")

    cursor.execute("SELECT * FROM oltp.address ;")
    dest.insert_rows(table=schema_name + ".ods_address" , rows=cursor)

    cursor.execute("SELECT * FROM oltp.customer ;")
    dest.insert_rows(table=schema_name + ".ods_customer" , rows=cursor)

    cursor.execute("SELECT * FROM oltp.customer_address ;")
    dest.insert_rows(table=schema_name + ".ods_customer_address" , rows=cursor)

    cursor.execute("SELECT * FROM oltp.product ;")
    dest.insert_rows(table=schema_name + ".ods_product" , rows=cursor)

    cursor.execute("SELECT * FROM oltp.product_category ;")
    dest.insert_rows(table=schema_name + ".ods_product_category" , rows=cursor)

    cursor.execute("SELECT * FROM oltp.product_description ;")
    dest.insert_rows(table=schema_name + ".ods_product_description" , rows=cursor)

    cursor.execute("SELECT * FROM oltp.product_model ;")
    dest.insert_rows(table=schema_name + ".ods_product_model" , rows=cursor)

    cursor.execute("SELECT * FROM oltp.product_model_product_desc ;")
    dest.insert_rows(table=schema_name + ".ods_product_model_product_desc" , rows=cursor)

    cursor.execute("SELECT * FROM oltp.sales_order;")
    dest.insert_rows(table=schema_name + ".ods_sales_order" , rows=cursor)

with DAG(
        'OLAP_init',
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
        schedule_interval=None,
        start_date=datetime(2022, 9, 12),
        tags=['data_warehouse']
) as dag:
    init_ods_task = PostgresOperator(
        task_id='init_ods_db',
        postgres_conn_id='olap_db',
        sql='ods_db_init.sql',
        dag=dag,
    )
    init_oltp_to_ods = PythonOperator(
        task_id='init_oltp_to_ods',
        python_callable=init_oltp_to_ods,
        provide_context=True,
        templates_dict=your_settings
    )

    init_dim_task = PostgresOperator(
        task_id='init_dim',
        postgres_conn_id='olap_db',
        sql='dim_db_init.sql',
        dag=dag,
    )
    init_ods_to_dim = PostgresOperator(
        task_id='init_ods_to_dim',
        postgres_conn_id='olap_db',
        sql='init_ods_to_dim.sql',
        dag=dag,
    )

    init_dwd_task = PostgresOperator(
        task_id='init_dwd',
        postgres_conn_id='olap_db',
        sql='dwd_db_init.sql',
        dag=dag,
    )

    init_ods_to_dwd = PostgresOperator(
        task_id='ods_to_dwd_db',
        postgres_conn_id='olap_db',
        sql='init_ods_to_dwd.sql',
        dag=dag,
    )

    init_dws_task = PostgresOperator(
        task_id='init_dws',
        postgres_conn_id='olap_db',
        sql='dws_db_init.sql',
        dag=dag,
    )

    init_dwd_to_dws = PostgresOperator(
        task_id='init_dwd_to_dws',
        postgres_conn_id='olap_db',
        sql='init_dwd_to_dws.sql',
        dag=dag,
    )

    init_ads_task = PostgresOperator(
        task_id='init_ads',
        postgres_conn_id='olap_db',
        sql='ads_db_init.sql',
        dag=dag,
    )

    init_dws_to_ads = PostgresOperator(
        task_id='init_dws_to_ads',
        postgres_conn_id='olap_db',
        sql='init_dws_to_ads.sql',
        dag=dag,
    )

init_ods_task >> init_oltp_to_ods >> init_dim_task >> init_ods_to_dim >> init_dwd_task >> init_ods_to_dwd >> init_dws_task >> init_dwd_to_dws >> init_ads_task >> init_dws_to_ads
