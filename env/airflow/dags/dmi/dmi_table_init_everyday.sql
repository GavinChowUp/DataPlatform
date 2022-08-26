--城市维度表，如果有全量数据的话，只需要导入一次
drop table if exists dmi.dmi_city_{{yesterday_ds_nodash}};
create table dmi.dmi_city_{{yesterday_ds_nodash}}
(
) inherits (dmi.dmi_city);

-- 全量
drop table if exists dmi.dmi_product_{{yesterday_ds_nodash}};
create table dmi.dmi_product_{{yesterday_ds_nodash}}
(
) inherits (dmi.dmi_product);


-- 用户，当日过期的用户数据
drop table if exists dmi.dmi_customer_{{macros.ds_format(macros.ds_add(yesterday_ds,-1),'%Y-%m-%d','%Y%m%d')}};
create table dmi.dmi_customer_{{macros.ds_format(macros.ds_add(yesterday_ds,-1),'%Y-%m-%d','%Y%m%d')}}
(
) inherits (dmi.dmi_customer);