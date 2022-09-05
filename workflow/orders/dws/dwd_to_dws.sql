-- 当日下单的各产品的汇总
insert into dws.dws_product_action_daycount_{{yesterday_ds_nodash}}
select order_detail.product_id,
       count(distinct order_detail.sales_order_id) as order_count,
       sum(order_detail.order_qty)                 as total_order_qty,
       sum(order_detail.line_total)                as total_line_total,
       sum(order_detail.total_profit)              as total_profit
from dwd.dwd_order_detail_{{yesterday_ds_nodash}} order_detail
where order_detail.order_date >= to_date('{{ts}}'
    , 'yyyy-MM-dd')
  and order_detail.order_date
    < to_date('{{execution_date}}'
    , 'yyyy-MM-dd')
group by order_detail.product_id;

--当日新下单，城市维度汇总
insert into dws.dws_city_action_daycount_{{yesterday_ds_nodash}}
select sales_order.city_id,
       count(distinct sales_order.customer_id) as customer_count,
       count(1)                                as order_count,         -- 下单次数
       sum(sales_order.sub_total)              as sub_total,           -- 销售之和
       sum(sales_order.tax_amt)                as tax_amt,             -- 本单交税
       sum(sales_order.freight)                as freight,             -- 运费
       sum(sales_order.total_due)              as total_due,           -- 总付款
       sum(sales_order.total_profit)           as total_profit,        -- 利润总和
       sum(sales_order.total_standard_cost)    as total_standard_cost, -- 产品成本总和
       sum(sales_order.total_line_total)       as total_line_total     -- 包含折扣产品价格小计
from dwd.dwd_sales_order_{{yesterday_ds_nodash}} sales_order
where sales_order.order_date >= to_date('{{ts}}'
    , 'yyyy-MM-dd')
  and sales_order.order_date
    < to_date('{{execution_date}}'
    , 'yyyy-MM-dd')
group by sales_order.city_id;


insert into dws.dws_order_action_daycount
    (select sales_order.sales_order_id      as sales_order_id,
            sales_order.sub_total           as sub_total,
            sales_order.tax_amt             as tax_amt,
            sales_order.freight             as freight,
            sales_order.total_due           as total_due,
            sales_order.total_profit        as total_profit,
            sales_order.total_standard_cost as total_standard_cost,
            sales_order.total_line_total    as total_line_total,
            sales_order.modified_date       as modified_date,
            (case when ds.id = 5 then date_cmp(sales_order.ship_date, sales_order.order_date) else 0 end)
                                            as order_to_ship_time_long,
            (case when ds.id = 2 then date_cmp(sales_order.modified_date, sales_order.order_date) else 0 end)
                                            as order_to_approved_time_long
     from dwd.dwd_sales_order_{{yesterday_ds_nodash}} sales_order
         left join dim.dim_status ds
     on ds.status = sales_order.status)
;

with old_new as (select doad.sales_order_id                      as old_sales_order_id,
                        doad.sub_total                           as old_sub_total,
                        doad.tax_amt                             as old_tax_amt,
                        doad.freight                             as old_freight,
                        doad.total_due                           as old_total_due,
                        doad.total_profit                        as old_total_profit,
                        doad.total_standard_cost                 as old_total_standard_cost,
                        doad.total_line_total                    as old_total_line_total,
                        doad.modified_date                       as old_modified_date,
                        doad.order_to_ship_time_long             as old_order_to_ship_time_long,
                        doad.order_to_approved_time_long         as order_to_approved_time_long,
                        order_action.sales_order_id              as new_sales_order_id,
                        order_action.sub_total                   as new_sub_total,
                        order_action.tax_amt                     as new_tax_amt,
                        order_action.freight                     as new_freight,
                        order_action.total_due                   as new_total_due,
                        order_action.total_profit                as new_total_profit,
                        order_action.total_standard_cost         as new_total_standard_c,
                        order_action.total_line_total            as new_total_line_total,
                        order_action.modified_date               as new_modified_date,
                        order_action.order_to_ship_time_long     as new_order_to_ship_time_long,
                        order_action.order_to_approved_time_long as new_order_to_approved_time_long
                 from dws.dws_order_action_daycount doad
                          full join
                      (select sales_order.sales_order_id      as sales_order_id,
                              sales_order.sub_total           as sub_total,
                              sales_order.tax_amt             as tax_amt,
                              sales_order.freight             as freight,
                              sales_order.total_due           as total_due,
                              sales_order.total_profit        as total_profit,
                              sales_order.total_standard_cost as total_standard_cost,
                              sales_order.total_line_total    as total_line_total,
                              sales_order.modified_date       as modified_date,
                              (case
                                   when ds.id = 5
                                       then date_cmp(sales_order.ship_date, sales_order.order_date)
                                   else 0 end)
                                                              as order_to_ship_time_long,
                              (case
                                   when ds.id = 2
                                       then date_cmp(sales_order.modified_date, sales_order.order_date)
                                   else 0 end)
                                                              as order_to_approved_time_long
                       from dwd.dwd_sales_order_{{yesterday_ds_nodash}} sales_order
                                left join dim.dim_status ds
                       on ds.status = sales_order.status) order_action
                      on doad.sales_order_id = order_action.sales_order_id)

insert
into dws.dws_order_action_daycount (sales_order_id,
                                    sub_total,
                                    tax_amt,
                                    freight,
                                    total_due,
                                    total_profit,
                                    total_standard_cost,
                                    total_line_total,
                                    modified_date,
                                    order_to_ship_time_long,
                                    order_to_approved_time_long)
    (select new_sales_order_id          as sales_order_id,
            new_sub_total               as sub_total,
            new_tax_amt                 as tax_amt,
            new_freight                 as freight,
            new_total_due               as total_due,
            new_total_profit            as total_profit,
            new_total_standard_c        as total_standard_cost,
            new_total_line_total        as total_line_total,
            new_modified_date           as modified_date,
            new_order_to_ship_time_long as order_to_ship_time_long,
            new_order_to_approved_time_long   as order_to_approved_time_long
     from old_new
     where old_sales_order_id is null);

with old_new as (select doad.sales_order_id                      as old_sales_order_id,
                        doad.sub_total                           as old_sub_total,
                        doad.tax_amt                             as old_tax_amt,
                        doad.freight                             as old_freight,
                        doad.total_due                           as old_total_due,
                        doad.total_profit                        as old_total_profit,
                        doad.total_standard_cost                 as old_total_standard_cost,
                        doad.total_line_total                    as old_total_line_total,
                        doad.modified_date                       as old_modified_date,
                        doad.order_to_ship_time_long             as old_order_to_ship_time_long,
                        doad.order_to_approved_time_long         as order_to_approved_time_long,
                        order_action.sales_order_id              as new_sales_order_id,
                        order_action.sub_total                   as new_sub_total,
                        order_action.tax_amt                     as new_tax_amt,
                        order_action.freight                     as new_freight,
                        order_action.total_due                   as new_total_due,
                        order_action.total_profit                as new_total_profit,
                        order_action.total_standard_cost         as new_total_standard_c,
                        order_action.total_line_total            as new_total_line_total,
                        order_action.modified_date               as new_modified_date,
                        order_action.order_to_ship_time_long     as new_order_to_ship_time_long,
                        order_action.order_to_approved_time_long as new_order_to_approved_time_long
                 from dws.dws_order_action_daycount doad
                          full join
                      (select sales_order.sales_order_id      as sales_order_id,
                              sales_order.sub_total           as sub_total,
                              sales_order.tax_amt             as tax_amt,
                              sales_order.freight             as freight,
                              sales_order.total_due           as total_due,
                              sales_order.total_profit        as total_profit,
                              sales_order.total_standard_cost as total_standard_cost,
                              sales_order.total_line_total    as total_line_total,
                              sales_order.modified_date       as modified_date,
                              (case
                                   when ds.id = 5
                                       then date_cmp(sales_order.ship_date, sales_order.order_date)
                                   else 0 end)
                                                              as order_to_ship_time_long,
                              (case
                                   when ds.id = 2
                                       then date_cmp(sales_order.modified_date, sales_order.order_date)
                                   else 0 end)
                                                              as order_to_approved_time_long
                       from dwd.dwd_sales_order_{{yesterday_ds_nodash}} sales_order
                                left join dim.dim_status ds
                       on ds.status = sales_order.status) order_action
                      on doad.sales_order_id = order_action.sales_order_id)

update
    dws.dws_order_action_daycount
set sales_order_id              = need_update.sales_order_id,
    sub_total                   = need_update.sub_total,
    tax_amt                     = need_update.tax_amt,
    freight                     = need_update.freight,
    total_due                   = need_update.total_due,
    total_profit                = need_update.total_profit,
    total_standard_cost         = need_update.total_standard_cost,
    total_line_total            = need_update.total_line_total,
    modified_date               = need_update.modified_date,
    order_to_ship_time_long     = need_update.order_to_ship_time_long,
    order_to_approved_time_long = need_update.order_to_approved_time_long from (select new_sales_order_id          as sales_order_id,
             new_sub_total               as sub_total,
             new_tax_amt                 as tax_amt,
             new_freight                 as freight,
             new_total_due               as total_due,
             new_total_profit            as total_profit,
             new_total_standard_c        as total_standard_cost,
             new_total_line_total        as total_line_total,
             new_modified_date           as modified_date,
             new_order_to_ship_time_long as order_to_ship_time_long,
             new_order_to_approved_time_long   as order_to_approved_time_long
      from old_new
      where old_sales_order_id is not null) need_update
where dws.dws_order_action_daycount.sales_order_id = need_update.sales_order_id;