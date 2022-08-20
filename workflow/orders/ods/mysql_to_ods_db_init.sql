-- ODS 层，按照月进行分区
create table ods_sales_order if not exists
(
    sales_order_id            int            null,
    sales_order_detail_id     int            null,
    revision_number           int        not null,
    order_date                date       not null,
    due_date                  date       not null,
    ship_date                 date       null,
    `status`                  int        not null,
    online_order_flag         bit(8)         null,
    sales_order_number        varchar(30)    null,
    purchase_order_number     varchar(25)    null,
    account_number            varchar(15)    null,
    customer_id               int            null,
    ship_to_address_id        int            null,
    bill_to_address_id        int            null,
    ship_method               varchar(50)    null,
    credit_card_approval_code varchar(15)    null,
    sub_total                 double precision         null,
    tax_amt                   double precision         null,
    freight                   double precision         null,
    total_due                 double precision         null,
    `comment`                 varchar(8000)  null,
    order_qty                 smallint       null,
    product_id                int            null,
    unit_price                double precision         null,
    unit_price_discount       double precision         null,
    line_total                decimal(38, 6) null,
    row_guid                  char(38)       null,
    modified_date             date       null
)
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
