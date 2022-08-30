-- dwd 层，sales表暂时未按照月分区，后续可以优化
CREATE SCHEMA if not exists dwd;

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

create table if not exists dwd.dwd_product
(
    product_id                int              not null primary key,
    name                      varchar(50)      not null,
    product_number            varchar(25)      not null,
    color                     varchar(15)      null,
    standard_cost             double precision not null,
    list_price                double precision not null,
    size                      varchar(5)       null,
    weight                    decimal(8, 2)    null,
    product_category_id       int              null,
    product_model_id          int              null,
    sell_start_date           date             null,
    sell_end_date             date             null,
    discontinued_date         date             null,
    thumbnail_photo           text             null,
    thumbnail_photo_file_name varchar(50)      null,
    row_guid                  char(38)         not null,
    modified_date             date             null
);

create table if not exists dwd.dwd_customer
(
    customer_id   int          not null primary key,
    name_style    boolean      not null,
    title         varchar(8)   null,
    first_name    varchar(50)  not null,
    middle_name   varchar(50)  null,
    last_name     varchar(50)  not null,
    suffix        varchar(10)  null,
    company_name  varchar(128) null,
    sales_person  varchar(256) null,
    email_address varchar(50)  null,
    phone         varchar(25)  null,
    password_hash varchar(128) not null,
    password_salt varchar(10)  not null,
    row_guid      char(38)     not null,
    modified_date date         not null
);

create table if not exists dwd.dwd_customer_address
(
    customer_id   int         not null,
    address_id    int         not null,
    address_type  varchar(50) not null,
    row_guid      char(38)    not null,
    modified_date date        not null,
    constraint customer_address_customer_id_address_id_uindex
        unique (customer_id, address_id)
);

create table if not exists dwd.dwd_address
(
    address_id     int         not null
        primary key,
    address_line1  varchar(60) not null,
    address_line2  varchar(60) null,
    city           varchar(30) not null,
    state_province varchar(50) not null,
    country_region varchar(50) not null,
    postal_code    varchar(15) not null,
    row_guid       char(38)    not null,
    modified_date  date        not null
);


create table if not exists dwd.dwd_product_category
(
    product_category_id        int         not null
        primary key,
    parent_product_category_id int         null,
    name                       varchar(50) not null,
    row_guid                   char(38)    not null,
    modified_date              date        not null
);

create table if not exists dwd.dwd_product_description
(
    product_description_id int          not null
        primary key,
    description            varchar(400) not null,
    row_guid               char(38)     not null,
    modified_date          date         not null
);


create table if not exists dwd.dwd_product_model
(
    product_model_id    int          not null
        primary key,
    name                varchar(50)  not null,
    catalog_description varchar(200) null,
    row_guid            char(38)     not null,
    modified_date       date         not null
);

create table if not exists dwd.dwd_product_model_product_desc
(
    product_model_id        int      null,
    product_description_id int      null,
    culture                 char(6)  null,
    row_guid                char(38) null,
    modified_date           date     null
);
