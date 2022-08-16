#!/bin/sh
mysql -uroot -pde2022 -e "CREATE DATABASE IF NOT EXISTS ods_db DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;"
mysql -uroot -pde2022 -e "create user 'ods'@'%' identified by 'ods';"
mysql -uroot -pde2022 -e "grant all privileges on ods.* to 'ods'@'%' with grant option;"
mysql -uroot -pde2022 -e  "flush privileges;"
mysql -uroot -pde2022 -e "use mysql;select host,user from user;"



