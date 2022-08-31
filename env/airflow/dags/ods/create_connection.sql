INSERT INTO public.connection (conn_id, conn_type, host, schema, login, password, port, extra, is_encrypted, is_extra_encrypted, description)
VALUES ('olap_db', 'postgres', 'postgres', 'olap_db', 'olap', 'olap', 5432, '', false, false, '');
INSERT INTO public.connection (conn_id, conn_type, host, schema, login, password, port, extra, is_encrypted, is_extra_encrypted, description)
VALUES ('oltp_db', 'postgres', 'postgres', 'oltp_db', 'oltp', 'oltp', 5432, '', false, false, '');
