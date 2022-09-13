-- 目标： 每月，不同城市， 销售额，利润额，销售额环比
insert into ads.ads_city_customer_month_statistics
select to_char(ca.order_date, 'YYYY-MM') as month_name,
       CURRENT_DATE                      as dt,
       ca.city_id                        as city_id,
       dc.city                           as city_name,
       sum(sub_total)                    as total_due,
       sum(total_profit)                 as total_profit
from dws.dws_city_action_daycount ca
         left join dim.dim_city dc
                   on ca.city_id = dc.id
group by month_name, ca.city_id, dc.city;

-- 目标： 每周,产品，周利润，top10
insert into ads.ads_product_week_top10_statistics
select week_of_year, top_num, dt, product_id, product_name, total_profit
from (select week_of_year
           , row_number() over (partition by order_date order by total_profit DESC) as top_num
           , dt
           , product_id
           , product_name
           , total_profit
      from (select to_char(pa.order_date, 'YYYY-WW') as week_of_year,
                   CURRENT_DATE                      as dt,
                   pa.product_id                     as product_id,
                   pa.order_date                     as order_date,
                   dp.name                           as product_name,
                   sum(pa.total_profit)              as total_profit
            from dws.dws_product_action_daycount pa
                     left join dim.dim_product dp on pa.product_id = dp.product_id

            group by week_of_year, pa.product_id, dp.name) as pd) as new
where top_num <= 10;


insert into ads.ads_orders_ship_long_top10_statistics
select dt, order_date, sales_order_id, order_to_ship_time_long, top_num
from (select *, row_number() over (partition by order_date order by order_to_ship_time_long DESC) as top_num
      from (select CURRENT_DATE               as dt,
                   oa.order_date              as order_date,
                   oa.sales_order_id          as sales_order_id,
                   oa.order_to_ship_time_long as order_to_ship_time_long
            from dws.dws_order_action_daycount oa) as o) as top
where top_num <= 10;