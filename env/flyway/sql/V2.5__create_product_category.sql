drop table if exists product_category;
create table product_category
(
    product_category_id        int         not null
        primary key,
    parent_product_category_id int         null,
    name                     varchar(50) not null,
    row_guid                   char(38)    not null,
    modified_date              date    not null
) ;;

