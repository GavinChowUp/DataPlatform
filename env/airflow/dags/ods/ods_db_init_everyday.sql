drop table if exists ods.ods_sales_order_{{yesterday_ds_nodash}} ;
create table ods.ods_sales_order_{{yesterday_ds_nodash}}
(
) inherits (ods.ods_sales_order);

drop table if exists ods.ods_product_{{yesterday_ds_nodash}};
create table ods.ods_product_{{yesterday_ds_nodash}}
(
) inherits (ods.ods_product);

drop table if exists ods.ods_customer_{{yesterday_ds_nodash}};
create table ods.ods_customer_{{yesterday_ds_nodash}}
(
) inherits (ods.ods_customer);

drop table if exists ods.ods_customer_address_{{yesterday_ds_nodash}};
create table ods.ods_customer_address_{{yesterday_ds_nodash}}
(
) inherits (ods.ods_customer_address);

drop table if exists ods.ods_address_{{yesterday_ds_nodash}};
create table ods.ods_address_{{yesterday_ds_nodash}}
(
) inherits (ods.ods_address);

drop table if exists ods.ods_product_category_{{yesterday_ds_nodash}};
create table ods.ods_product_category_{{yesterday_ds_nodash}}
(
) inherits (ods.ods_product_category);

drop table if exists ods.ods_product_description_{{yesterday_ds_nodash}};
create table ods.ods_product_description_{{yesterday_ds_nodash}}
(
) inherits (ods.ods_product_description);

drop table if exists ods.ods_product_model_{{yesterday_ds_nodash}};
create table ods.ods_product_model_{{yesterday_ds_nodash}}
(
) inherits (ods.ods_product_model);

drop table if exists ods.ods_product_model_product_desc_{{yesterday_ds_nodash}};
create table ods.ods_product_model_product_desc_{{yesterday_ds_nodash}}
(
) inherits (ods.ods_product_model_product_desc);

