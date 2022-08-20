drop table if exists product;
create table product
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