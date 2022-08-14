drop table if exists `product`;
create table product
(
    `product_id`                int         not null primary key,
    `name`                      varchar(50) not null,
    `product_number`            varchar(25) not null,
    `color`                     varchar(15) null,
    `standard_cost`             double      not null,
    `list_price`                double      not null,
    `size`                      varchar(5) null,
    `weight`                    decimal(8, 2) null,
    `product_category_id`       int null,
    `product_model_id`          int null,
    `sell_start_date`           datetime null,
    `sell_end_date`             datetime null,
    `discontinued_date`         datetime null,
    `thumbnail_photo`           varbinary(8000) null,
    `thumbnail_photo_file_name` varchar(50) null,
    `row_guid`                  char(38)    not null,
    `modified_date`             datetime null
) ENGINE = InnoDB
  CHARACTER SET = utf8
  COLLATE = utf8_general_ci;;

