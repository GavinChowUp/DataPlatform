drop table if exists customer;
create table customer
(
    customer_id   int          not null primary key,
    name_style    boolean          not null,
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
    modified_date date     not null
) ;

