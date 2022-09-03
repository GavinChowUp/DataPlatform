-- dwt 数据主题层：累积汇总
CREATE SCHEMA if not exists dwt;

create table if not exists dwt.dwt_order_detail
(
    sales_order_id            int              null,
    sales_order_detail_id     int              null,
    order_date                date             not null,
    status                    int              not null,
    customer_id               int              null,
    order_qty                 smallint         null,
    product_id                int              null,
    unit_price                double precision null,
    unit_price_discount       double precision null,
    line_total                decimal(38, 6)   null
    );

