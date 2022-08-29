--城市维度表，如果有全量数据的话，只需要导入一次
drop table if exists dim.dim_city_{{yesterday_ds_nodash}};
create table dim.dim_city_{{yesterday_ds_nodash}}
(
) inherits (dim.dim_city);

-- 全量
drop table if exists dim.dim_product_{{yesterday_ds_nodash}};
create table dim.dim_product_{{yesterday_ds_nodash}}
(
) inherits (dim.dim_product);


-- 用户，当日过期的用户数据
drop table if exists dim.dim_customer_{{macros.ds_format(macros.ds_add(yesterday_ds,-1),'%Y-%m-%d','%Y%m%d')}};
create table dim.dim_customer_{{macros.ds_format(macros.ds_add(yesterday_ds,-1),'%Y-%m-%d','%Y%m%d')}}
(
) inherits (dim.dim_customer);