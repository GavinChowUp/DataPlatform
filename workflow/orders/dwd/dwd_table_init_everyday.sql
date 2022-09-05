drop table if exists dwd.dwd_order_detail_{{yesterday_ds_nodash}} ;
create table dwd.dwd_order_detail_{{yesterday_ds_nodash}}
(
) inherits (dwd.dwd_order_detail);

drop table if exists dwd.dwd_sales_order_{{yesterday_ds_nodash}};
create table dwd.dwd_sales_order_{{yesterday_ds_nodash}}
(
) inherits (dwd.dwd_sales_order);


