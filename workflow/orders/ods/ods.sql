-- ODS 层，按照月进行分区
drop table if exists `ods_sales_order`;
create table ods_sales_order
(
    sales_order_id            int            null,
    sales_order_detail_id     int            null,
    revision_number           tinyint        not null,
    order_date                datetime       not null,
    due_date                  datetime       not null,
    ship_date                 datetime       null,
    `status`                  tinyint        not null,
    online_order_flag         bit(8)         null,
    sales_order_number        varchar(30)    null,
    purchase_order_number     varchar(25)    null,
    account_number            varchar(15)    null,
    customer_id               int            null,
    ship_to_address_id        int            null,
    bill_to_address_id        int            null,
    ship_method               varchar(50)    null,
    credit_card_approval_code varchar(15)    null,
    sub_total                 double         null,
    tax_amt                   double         null,
    freight                   double         null,
    total_due                 double         null,
    `comment`                 varchar(8000)  null,
    order_qty                 smallint       null,
    product_id                int            null,
    unit_price                double         null,
    unit_price_discount       double         null,
    line_total                decimal(38, 6) null,
    row_guid                  char(38)       null,
    modified_date             datetime       null
) ENGINE = InnoDB
  CHARACTER SET = utf8
  COLLATE = utf8_general_ci
    PARTITION BY RANGE (to_days(order_date)) (

        PARTITION p200806 VALUES LESS THAN (to_days('2008-06-01')),

        PARTITION p200807 VALUES LESS THAN (to_days('2008-07-01')),

        PARTITION p200808 VALUES LESS THAN (to_days('2008-08-01')),

        PARTITION p200809 VALUES LESS THAN (to_days('2008-09-01')),

        PARTITION p200810 VALUES LESS THAN (to_days('2008-10-01')),

        PARTITION p200811 VALUES LESS THAN (to_days('2008-11-01')),

        PARTITION p200812 VALUES LESS THAN (to_days('2008-12-01')),

        PARTITION p200901 VALUES LESS THAN (to_days('2009-01-01')),

        PARTITION p2009 VALUES LESS THAN (MAXVALUE) )
;
