-- dwt 数据主题层：从开始那天到统计日的累积行为汇总,一般会有最近7日和最近1月/30day等
drop schema if exists dwt cascade;
CREATE SCHEMA if not exists dwt;

-- 产品维度
create table if not exists dws.dws_product_action_daycount
(
    product_id       int            not null primary key,
    order_count_7d      int            not null, -- 最近7日被下单次数
    order_count_30d      int            not null, -- 最近一个月/30天被下单次数
    total_order_qty_7d  int            not null, -- 被下单件数
    total_order_qty_30d  int            not null, -- 被下单件数
    total_line_total_7d  decimal(38, 6) null,     -- 被下单总价
    total_line_total_30d  decimal(38, 6) null,     -- 被下单总价
    total_profit_7d     double precision         -- 总利润
    total_profit_30d     double precision         -- 总利润
    );


-- 城市维度
create table if not exists dws.dws_city_action_daycount
(
    city_id             int              not null primary key,
    -- 参考dws 增加7d 和 30d
);

-- 订单维度
create table if not exists dws.dws_order_action_daycount
(
    sales_order_id              int              not null,
   -- 参考dws 增加7d 和 30d
)
