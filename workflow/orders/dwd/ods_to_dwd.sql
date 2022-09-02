-- dwd_order_detail 每日装载表
with order_detail as (select sales_order_id,
                             sales_order_detail_id,
                             order_date,
                             status,
                             customer_id,
                             order_qty,
                             product_id,
                             unit_price,
                             unit_price_discount,
                             line_total
                      from ods.ods_sales_order_{{yesterday_ds_nodash}})
insert
into dwd.dwd_order_detail_{{yesterday_ds_nodash}}
select order_detail.sales_order_id,
       order_detail.sales_order_detail_id,
       order_detail.order_date,
       order_detail.status,
       order_detail.customer_id,
       order_detail.order_qty,
       order_detail.product_id,
       order_detail.unit_price,
       order_detail.unit_price_discount,
       order_detail.line_total
from order_detail;


-- dwd_sales_order 每日装载表
insert into dwd.dwd_sales_order_{{yesterday_ds_nodash}}
select order_detail.sales_order_id                 as sales_order_id,
       max(order_detail.revision_number)           as revision_number,
       MAX(order_detail.order_date)                as order_date,
       MAX(order_detail.due_date)                  as due_date,
       MAX(order_detail.ship_date)                 as ship_date,
       MAX(order_detail.status)                    as status,
       MAX(order_detail.sales_order_number)        as sales_order_number,
       max(order_detail.purchase_order_number)     as purchase_order_number,
       max(order_detail.account_number)            as account_number,
       max(order_detail.customer_id)               as customer_id,
       max(order_detail.ship_to_address_id)        as ship_to_address_id,
       max(order_detail.bill_to_address_id)        as bill_to_address_id,
       max(order_detail.ship_method)               as ship_method,
       max(order_detail.credit_card_approval_code) as credit_card_approval_code,
       max(order_detail.sub_total)                 as sub_total,
       max(order_detail.tax_amt)                   as tax_amt,
       max(order_detail.freight)                   as freight,
       max(order_detail.total_due)                 as total_due,           -- 客户应付总额
       sum(order_detail.unit_price * order_detail.order_qty -
           product.standard_cost)                  as total_profit,        -- 利润总和
       sum(product.standard_cost)                  as total_standard_cost, -- 成本总和
       sum(order_detail.line_total)                as total_line_total,    -- 包含折扣产品价格小计
       max(order_detail.comment)                   as comment,
       max(order_detail.modified_date)             as modified_date
from ods.ods_sales_order_{{yesterday_ds_nodash}} order_detail
         left join ods.ods_product_{{yesterday_ds_nodash}} product
on order_detail.product_id = product.product_id
group by order_detail.sales_order_id;