drop table if exists product_model;
create table product_model
(
    product_model_id    int          not null
        primary key,
    name              varchar(50)  not null,
    catalog_description varchar(200) null,
    row_guid            char(38)     not null,
    modified_date       date     not null
) ;

