drop table if exists product_description;
create table product_description
(
    product_description_id int          not null
        primary key,
    description          varchar(400) not null,
    row_guid               char(38)     not null,
    modified_date          date     not null
) ;

