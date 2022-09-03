drop table if exists dws.dws_product_action_daycount_{{yesterday_ds_nodash}} ;
create table dws.dws_product_action_daycount_{{yesterday_ds_nodash}}
(
) inherits (dws.dws_product_action_daycount);

drop table if exists dws.dws_city_action_daycount_{{yesterday_ds_nodash}} ;
create table dws.dws_city_action_daycount_{{yesterday_ds_nodash}}
(
) inherits (dws.dws_city_action_daycount);


drop table if exists dws.dws_order_action_daycount_{{yesterday_ds_nodash}} ;
create table dws.dws_order_action_daycount_{{yesterday_ds_nodash}}
(
) inherits (dws.dws_order_action_daycount);