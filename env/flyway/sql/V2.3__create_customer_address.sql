drop table if exists customer_address;
create table customer_address
(
    customer_id   int         not null,
    address_id    int         not null,
    address_type  varchar(50) not null,
    row_guid      char(38)    not null,
    modified_date date    not null,
    constraint customer_address_customer_id_address_id_uindex
        unique (customer_id, address_id)
) ;

