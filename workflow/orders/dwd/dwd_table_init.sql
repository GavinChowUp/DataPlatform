-- dwd 层：明细层，暂时没有考虑数据的去除空值，脱敏等
drop schema if exists dwd cascade;
CREATE SCHEMA dwd;

create table if not exists dwd.dwd_order_detail
(
    sales_order_id        int              null,
    sales_order_detail_id int              null,
    order_date            date             not null,
    status                int              not null,
    customer_id           int              null,
    order_qty             smallint         null,
    product_id            int              null,
    unit_price            double precision null,
    unit_price_discount   double precision null,
    line_total            decimal(38, 6)   null,
    total_profit          double precision null -- 利润
);


create table if not exists dwd.dwd_sales_order
(
    sales_order_id            int              null,
    revision_number           int              not null,
    order_date                date             not null,
    due_date                  date             not null,
    ship_date                 date             null,
    status                    int              not null,
    sales_order_number        varchar(30)      null,
    purchase_order_number     varchar(25)      null,
    account_number            varchar(15)      null,
    customer_id               int              null,
    city_id                   int              null,
    city                      varchar(30)      not null,
    state_province            varchar(50)      not null,
    country_region            varchar(50)      not null,
    ship_to_address_id        int              null,
    bill_to_address_id        int              null,
    ship_method               varchar(50)      null,
    credit_card_approval_code varchar(15)      null,
    sub_total                 double precision null, -- 本单销售之和
    tax_amt                   double precision null, -- 本单交税
    freight                   double precision null, -- 运费
    total_due                 double precision null, -- 客户总付款
    total_profit              double precision null, -- 利润总和
    total_standard_cost       double precision null, -- 产品成本总和
    total_line_total          double precision null, -- 包含折扣产品价格小计
    comment                   varchar(8000)    null,
    modified_date             date             null
);
