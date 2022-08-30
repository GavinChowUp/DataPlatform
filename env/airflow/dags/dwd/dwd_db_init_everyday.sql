drop table if exists dwd.dwd_sales_order_{{yesterday_ds_nodash}} ;
create table dwd.dwd_sales_order_{{yesterday_ds_nodash}}
(
) inherits (dwd.dwd_sales_order);

drop table if exists dwd.dwd_product_{{yesterday_ds_nodash}};
create table dwd.dwd_product_{{yesterday_ds_nodash}}
(
) inherits (dwd.dwd_product);

drop table if exists dwd.dwd_customer_{{yesterday_ds_nodash}};
create table dwd.dwd_customer_{{yesterday_ds_nodash}}
(
) inherits (dwd.dwd_customer);

drop table if exists dwd.dwd_customer_address_{{yesterday_ds_nodash}};
create table dwd.dwd_customer_address_{{yesterday_ds_nodash}}
(
) inherits (dwd.dwd_customer_address);

drop table if exists dwd.dwd_address_{{yesterday_ds_nodash}};
create table dwd.dwd_address_{{yesterday_ds_nodash}}
(
) inherits (dwd.dwd_address);

drop table if exists dwd.dwd_product_category_{{yesterday_ds_nodash}};
create table dwd.dwd_product_category_{{yesterday_ds_nodash}}
(
) inherits (dwd.dwd_product_category);

drop table if exists dwd.dwd_product_description_{{yesterday_ds_nodash}};
create table dwd.dwd_product_description_{{yesterday_ds_nodash}}
(
) inherits (dwd.dwd_product_description);

drop table if exists dwd.dwd_product_model_{{yesterday_ds_nodash}};
create table dwd.dwd_product_model_{{yesterday_ds_nodash}}
(
) inherits (dwd.dwd_product_model);

drop table if exists dwd.dwd_product_model_product_desc_{{yesterday_ds_nodash}};
create table dwd.dwd_product_model_product_desc_{{yesterday_ds_nodash}}
(
) inherits (dwd.dwd_product_model_product_desc);
