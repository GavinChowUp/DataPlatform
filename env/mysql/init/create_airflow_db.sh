#!/bin/sh
mysql -uroot -pde2022 -e "CREATE DATABASE IF NOT EXISTS airflow DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;"
mysql -uroot -pde2022 -e "create user 'airflow'@'%' identified by 'airflow';"
mysql -uroot -pde2022 -e "grant all privileges on airflow.* to 'airflow'@'%' with grant option;"
mysql -uroot -pde2022 -e  "flush privileges;"
mysql -uroot -pde2022 -e "use mysql;select host,user from user;"



