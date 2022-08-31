-- dwd 层：明细层
CREATE SCHEMA if not exists dwd;

create table if not exists dwd.dwd_order_detail
(
    sales_order_id            int              null,
    sales_order_detail_id     int              null,
    revision_number           int              not null,
    order_date                date             not null,
    status                    int              not null,
    online_order_flag         bit(8)           null,
    customer_id               int              null,
    ship_to_address_id        int              null,
    bill_to_address_id        int              null,
    ship_method               varchar(50)      null,
    sub_total                 double precision null,
    tax_amt                   double precision null,
    freight                   double precision null,
    total_due                 double precision null,
    comment                   varchar(8000)    null,
    order_qty                 smallint         null,
    product_id                int              null,
    unit_price                double precision null,
    unit_price_discount       double precision null,
    line_total                decimal(38, 6)   null,
    row_guid                  char(38)         null,
    modified_date             date             null
    );

CREATE EXTERNAL TABLE dwd_order_detail (
    `id` STRING COMMENT '订单编号',
    `order_id` STRING COMMENT '订单号',
    `user_id` STRING COMMENT '用户id',
    `sku_id` STRING COMMENT 'sku商品id',
    `province_id` STRING COMMENT '省份ID',
    `activity_id` STRING COMMENT '活动ID',
    `activity_rule_id` STRING COMMENT '活动规则ID',
    `coupon_id` STRING COMMENT '优惠券ID',
    `create_time` STRING COMMENT '创建时间',
    `source_type` STRING COMMENT '来源类型',
    `source_id` STRING COMMENT '来源编号',
    `sku_num` BIGINT COMMENT '商品数量',
    `original_amount` DECIMAL(16,2) COMMENT '原始价格',
    `split_activity_amount` DECIMAL(16,2) COMMENT '活动优惠分摊',
    `split_coupon_amount` DECIMAL(16,2) COMMENT '优惠券优惠分摊',
    `split_final_amount` DECIMAL(16,2) COMMENT '最终价格分摊'
) COMMENT '订单明细事实表表'
PARTITIONED BY (`dt` STRING)
STORED AS PARQUET
LOCATION '/warehouse/gmall/dwd/dwd_order_detail/'
TBLPROPERTIES ("parquet.compression"="lzo");


create table if not exists dwd.dwd_sales_order
(
    sales_order_id            int              null,
    sales_order_detail_id     int              null,
    revision_number           int              not null,
    order_date                date             not null,
    due_date                  date             not null,
    ship_date                 date             null,
    status                    int              not null,
    online_order_flag         bit(8)           null,
    sales_order_number        varchar(30)      null,
    purchase_order_number     varchar(25)      null,
    account_number            varchar(15)      null,
    customer_id               int              null,
    ship_to_address_id        int              null,
    bill_to_address_id        int              null,
    ship_method               varchar(50)      null,
    credit_card_approval_code varchar(15)      null,
    sub_total                 double precision null,
    tax_amt                   double precision null,
    freight                   double precision null,
    total_due                 double precision null,
    comment                   varchar(8000)    null,
    order_qty                 smallint         null,
    product_id                int              null,
    unit_price                double precision null,
    unit_price_discount       double precision null,
    line_total                decimal(38, 6)   null,
    row_guid                  char(38)         null,
    modified_date             date             null
);
