-- dws 服务层，按天轻度汇总，站在不同维度去看事实
drop schema if exists dws cascade;
CREATE SCHEMA if not exists dws;

-- 产品维度
create table if not exists dws.dws_product_action_daycount
(
    product_id       int            not null primary key,
    order_count      int            not null, -- 被下单次数
    total_order_qty  int            not null, -- 被下单件数
    total_line_total decimal(38, 6) null,     -- 被下单总价
    total_profit     double precision         -- 总利润
);

-- 城市维度
create table if not exists dws.dws_city_action_daycount
(
    city_id             int              not null primary key,
    customer_count      int              not null,
    order_count         int              not null, -- 下单次数
    sub_total           double precision null,     -- 销售之和
    tax_amt             double precision null,     -- 本单交税
    freight             double precision null,     -- 运费
    total_due           double precision null,     -- 总付款
    total_profit        double precision null,     -- 利润总和
    total_standard_cost double precision null,     -- 产品成本总和
    total_line_total    double precision null      -- 包含折扣产品价格小计
);

-- 订单维度,订单Id 可以看成退化的维度
create table if not exists dws.dws_order_action_daycount
(
    sales_order_id              int              not null,
    sub_total                   double precision null, -- 本单销售之和
    tax_amt                     double precision null, -- 本单交税
    freight                     double precision null, -- 运费
    total_due                   double precision null, -- 客户总付款
    total_profit                double precision null, -- 利润总和
    total_standard_cost         double precision null, -- 产品成本总和
    total_line_total            double precision null, -- 包含折扣产品价格小计
    modified_date               date             null,
    order_to_ship_time_long     int              null, -- 从创建订单到发货时长
    order_to_approved_time_long int              null  -- 从创建订单到发货时长
)