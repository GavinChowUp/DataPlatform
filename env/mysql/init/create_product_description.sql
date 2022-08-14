drop table if exists `product_description`;
create table product_description
(
    product_description_id int          not null
        primary key,
    `description`          varchar(400) not null,
    row_guid               char(38)     not null,
    modified_date          datetime     not null
) ENGINE = InnoDB
  CHARACTER SET = utf8
  COLLATE = utf8_general_ci;;

