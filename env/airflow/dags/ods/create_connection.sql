INSERT INTO public.connection (conn_id, conn_type, host, schema, login, password, port, extra, is_encrypted, is_extra_encrypted, description)
VALUES ('olap_db', 'postgres', 'postgres', 'olap_db', 'olap', 'olap', 5432, '', false, false, '');
INSERT INTO public.connection (conn_id, conn_type, host, schema, login, password, port, extra, is_encrypted, is_extra_encrypted, description)
VALUES ('oltp_db', 'postgres', 'postgres', 'oltp_db', 'oltp', 'oltp', 5432, '', false, false, '');


ALTER DATABASE olap_db SET session_preload_libraries = 'anon';
ALTER DATABASE postgres SET session_preload_libraries = 'anon';

CREATE EXTENSION IF NOT EXISTS anon CASCADE;
SELECT anon.init();
SELECT anon.start_dynamic_masking();

CREATE ROLE dy_masking LOGIN PASSWORD 'dy_masking';
GRANT SELECT ON table dwd.dwd_sales_order TO dy_masking;
GRANT USAGE ON schema dwd TO dy_masking;

select anon.anonymize_database();

SECURITY LABEL FOR anon ON ROLE dy_masking IS 'MASKED';

security label for anon on column dwd.dwd_sales_order.account_number
    IS 'MASKED WITH FUNCTION anon.partial(account_number,2,$$******$$,2)';

SECURITY LABEL FOR anon ON COLUMN dwd.dwd_sales_order.purchase_order_number
    IS 'MASKED WITH FUNCTION anon.partial(purchase_order_number,2,$$******$$,2)';

