-- ADS 数据应用层
drop schema if exists ads cascade;
CREATE SCHEMA if not exists ads;

-- 每月不同城市客户的销售额，利润额，销售增长率
-- 每月 -> orderdate
-- 不同城市客户 -> customer - customer_address - address
-- 销售额 -> total_due
-- 利润额 -> 根据订单表中的 unitprice * orderqty - 产品表中的 StandardCost
-- 销售增长率 -> total_due对比上一个月的增长率
create table if not exists ads.ads_city_customer_month_statistics
(
    month_name          varchar(300)      not null, -- 月份数，例如202201：22年1月份的统计数据，202202：22年2月份的统计数据，
    dt                  varchar(300)      null,     -- 统计日期
    city_id             int              not null, -- 城市Id
    city_name           varchar(300)      null,     -- 城市名称
    total_due           double precision null,     -- 销售额
    total_profit        double precision null,     -- 利润额
    sales_growth_rate   double precision null      -- 月销售增长率
    );

-- 每周卖出产品利润最高的top 10
-- 卖出产品名称 -> product
-- 利润 -> 根据订单表中的 unitprice * orderqty - 产品表中的 StandardCost 最高的top 10
create table if not exists ads.ads_product_week_top10_statistics
(
    week_of_year     char(10)       not null, -- 每年的周数：2004-W53：2004年的第53周
    top_num          int            not null, -- top几： 1：当日top1
    dt               varchar(300)    not null, -- 统计日期
    product_id       int            not null, -- 产品Id
    product_name     varchar(300)    not null, -- 产品名称
    total_profit     double precision         -- 总利润
    );


-- 当前所有订单从创建到发货时间跨度长的top 10
create table if not exists ads.ads_orders_ship_long_top10_statistics
(
    dt                          varchar(300)      not null, -- 统计日期
    sales_order_id              int              not null, -- 订单Id
    order_to_ship_time_long     int              null     -- 从创建订单到发货时长
    );
