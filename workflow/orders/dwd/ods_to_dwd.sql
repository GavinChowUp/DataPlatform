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
                      from ods.ods_sales_order_{{yesterday_ds_nodash}}),

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



with order_detail as (select sales_order_id,
                             revision_number,
                             order_date,
                             due_date,
                             ship_date,
                             status,
                             online_order_flag,
                             sales_order_number,
                             purchase_order_number,
                             account_number,
                             customer_id,
                             ship_to_address_id,
                             bill_to_address_id,
                             ship_method,
                             credit_card_approval_code,
                             sub_total,
                             tax_amt,
                             freight,
                             total_due,
                             product_id,
                             comment,
                             modified_date
                      from ods.ods_sales_order_{{yesterday_ds_nodash}}),
    product as (
select
    product_id,
    standard_cost,
    list_price
from ods.ods_product_{{yesterday_ds_nodash}})

insert
into dwd.dwd_sales_order_{{yesterday_ds_nodash}}
select order_detail.sales_order_id,
       order_detail.revision_number,
       order_detail.order_date,
       order_detail.due_date,
       ship_date,
       status,
       online_order_flag,
       sales_order_number,
       purchase_order_number,
       account_number,
       customer_id,
       ship_to_address_id,
       bill_to_address_id,
       ship_method,
       credit_card_approval_code varchar (15) null,
    sub_total double precision null,
    tax_amt double precision null,
    freight double precision null,
    total_due double precision null,
    total_profit double precision null,        -- 利润总和
    total_standard_cost double precision null,
    total_line_total double precision null,    -- 包含折扣产品价格小计
    comment varchar (8000) null,
    modified_date date null
from order_detail
    left join product
on order_detail.product_id = product.product_id
group by order_detail.sales_order_id



