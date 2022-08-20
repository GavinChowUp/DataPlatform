drop table if exists sales_order;
create table sales_order
(
    sales_order_id            int            null,
    sales_order_detail_id     int            null,
    revision_number           int        not null,
    order_date                date           not null,
    due_date                  date           not null,
    ship_date                 date           null,
    status                    int        not null,
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
    comment                   varchar(8000)  null,
    order_qty                 smallint       null,
    product_id                int            null,
    unit_price                double precision         null,
    unit_price_discount       double precision         null,
    line_total                decimal(38, 6) null,
    row_guid                  char(38)       null,
    modified_date             date           null
);

create index sales_order_id_index
    on sales_order (sales_order_id, sales_order_detail_id);

