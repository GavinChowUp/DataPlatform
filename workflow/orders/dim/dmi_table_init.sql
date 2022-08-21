-- dmi
CREATE SCHEMA if not exists dmi_{{yesterday_ds_nodash}};
-- 时间维度表
drop table if exists dmi_{{yesterday_ds_nodash}}.dmi_date;
create table dmi_{{yesterday_ds_nodash}}.dmi_date
(
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
comment on column dmi_{{yesterday_ds_nodash}}.dmi_date.date_id is '日';
comment on column dmi_{{yesterday_ds_nodash}}.dmi_date.week_id is '周Id';
comment on column dmi_{{yesterday_ds_nodash}}.dmi_date.week_day is '周几';
comment on column dmi_{{yesterday_ds_nodash}}.dmi_date.day is '每月的第几天';
comment on column dmi_{{yesterday_ds_nodash}}.dmi_date.month is '第几月';
comment on column dmi_{{yesterday_ds_nodash}}.dmi_date.quarter is '第几个季度';
comment on column dmi_{{yesterday_ds_nodash}}.dmi_date.year is '年';
comment on column dmi_{{yesterday_ds_nodash}}.dmi_date.is_workday is '是否是工作日';
comment on column dmi_{{yesterday_ds_nodash}}.dmi_date.holiday_id is '节假日';
comment on table dmi_{{yesterday_ds_nodash}}.dmi_date is '时间维度表';

-- 用户
drop table if exists dmi_{{yesterday_ds_nodash}}.dmi_customer;
create table dmi_{{yesterday_ds_nodash}}.dmi_customer
(
    sales_order_id            int              null,
    sales_order_detail_id     int              null,
    );

--
drop table if exists dmi_{{yesterday_ds_nodash}}.dmi_city;
create table dmi_{{yesterday_ds_nodash}}.dmi_city
(
    sales_order_id            int              null,
    sales_order_detail_id     int              null,
);

--
drop table if exists dmi_{{yesterday_ds_nodash}}.dmi_product;
create table dmi_{{yesterday_ds_nodash}}.dmi_product
(
    sales_order_id            int              null,
    sales_order_detail_id     int              null,
);

-- 用户
drop table if exists dmi_{{yesterday_ds_nodash}}.dmi_status;
create table dmi_{{yesterday_ds_nodash}}.dmi_status
(
    sales_order_id            int              null,
    sales_order_detail_id     int              null,
);