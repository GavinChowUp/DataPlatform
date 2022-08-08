# grant all privileges on dbname.tablename to 'platform'@'%';
grant all privileges on data_platform.* to 'platform'@'%';
# 刷新权限
flush privileges;

