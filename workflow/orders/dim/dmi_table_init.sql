-- dmi
CREATE SCHEMA if not exists dmi;

-- 时间维度表,只录入一次
drop table if exists dmi.dmi_date;
create table dmi.dmi_date
(
    id         bigint not null primary key,
    date_id    varchar(30),
    week_id    varchar(30),
    week_day   varchar(30),
    day        varchar(30),
    month      varchar(30),
    quarter    varchar(30),
    year       varchar(30),
    is_workday varchar(30),
    holiday_id varchar(30)
);
comment on column dmi.dmi_date.date_id is '日';
comment on column dmi.dmi_date.week_id is '周Id';
comment on column dmi.dmi_date.week_day is '周几';
comment on column dmi.dmi_date.day is '每月的第几天';
comment on column dmi.dmi_date.month is '第几月';
comment on column dmi.dmi_date.quarter is '第几个季度';
comment on column dmi.dmi_date.year is '年';
comment on column dmi.dmi_date.is_workday is '是否是工作日';
comment on column dmi.dmi_date.holiday_id is '节假日';
comment on table dmi.dmi_date is '时间维度表';

-- 状态表，只录入一次
drop table if exists dmi.dmi_status;
create table dmi.dmi_status
(
    id     bigint not null primary key,
    status int    null,
    name   varchar(20)
);

--城市维度表，如果有全量数据的话，只需要导入一次
drop table if exists dmi.dmi_city;
create table dmi.dmi_city
(
    id             bigint      not null primary key,
    city           varchar(30) not null,
    state_province varchar(50) not null,
    country_region varchar(50) not null,
    postal_code    varchar(15) not null
);

-- 全量
drop table if exists dmi.dmi_product;
create table dmi.dmi_product
(
    product_id                         int              not null,
    name                               varchar(50)      not null,
    product_number                     varchar(25)      not null,
    color                              varchar(15)      null,
    standard_cost                      double precision not null,
    list_price                         double precision not null,
    size                               varchar(5)       null,
    weight                             decimal(8, 2)    null,
    sell_start_date                    date             null,
    sell_end_date                      date             null,
    discontinued_date                  date             null,
    modified_date                      date             null,
    -- product_category
    product_category1_id               int              not null,
    product_category1_name             varchar(50)      not null,
    product_category2_id               int              not null,
    product_category2_name             varchar(50)      not null,
    -- product_model_id
    product_model_name                 varchar(50)      not null,
    product_model_catalog_description  varchar(200)     null,
    product_model_product_culture_description   text[][]   null
);


-- 用户,待补充
drop table if exists dmi.dmi_customer;
create table dmi.dmi_customer
(

);