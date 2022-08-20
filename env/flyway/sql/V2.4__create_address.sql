drop table if exists address;
create table address
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
    modified_date  date    not null
) ;

