-- dmi
CREATE SCHEMA if not exists dmi;

-- 时间维度表,只录入一次
drop table if exists dmi.dmi_date;
create table dmi.dmi_date
(
    id                     INT        NOT NULL,
    date_actual            DATE       NOT NULL,
    epoch                  BIGINT     NOT NULL,
    day_suffix             VARCHAR(4) NOT NULL,
    day_name               VARCHAR(9) NOT NULL,
    day_of_week            INT        NOT NULL,
    day_of_month           INT        NOT NULL,
    day_of_quarter         INT        NOT NULL,
    day_of_year            INT        NOT NULL,
    week_of_month          INT        NOT NULL,
    week_of_year           INT        NOT NULL,
    week_of_year_iso       CHAR(10)   NOT NULL,
    month_actual           INT        NOT NULL,
    month_name             VARCHAR(9) NOT NULL,
    month_name_abbreviated CHAR(3)    NOT NULL,
    quarter_actual         INT        NOT NULL,
    quarter_name           VARCHAR(9) NOT NULL,
    year_actual            INT        NOT NULL,
    first_day_of_week      DATE       NOT NULL,
    last_day_of_week       DATE       NOT NULL,
    first_day_of_month     DATE       NOT NULL,
    last_day_of_month      DATE       NOT NULL,
    first_day_of_quarter   DATE       NOT NULL,
    last_day_of_quarter    DATE       NOT NULL,
    first_day_of_year      DATE       NOT NULL,
    last_day_of_year       DATE       NOT NULL,
    mmyyyy                 CHAR(6)    NOT NULL,
    mmddyyyy               CHAR(10)   NOT NULL,
    weekend_indr           BOOLEAN    NOT NULL

);
ALTER TABLE dmi.dmi_date
    ADD CONSTRAINT d_date_date_dim_id_pk PRIMARY KEY (id);

CREATE INDEX d_date_date_actual_idx
    ON dmi.dmi_date (date_actual);

INSERT INTO dmi.dmi_date
SELECT TO_CHAR(datum, 'yyyymmdd')::INT                                                        AS date_dim_id,
       datum                                                                                  AS date_actual,
       EXTRACT(EPOCH FROM datum)                                                              AS epoch,
       TO_CHAR(datum, 'fmDDth')                                                               AS day_suffix,
       TO_CHAR(datum, 'TMDay')                                                                AS day_name,
       EXTRACT(ISODOW FROM datum)                                                             AS day_of_week,
       EXTRACT(DAY FROM datum)                                                                AS day_of_month,
       datum - DATE_TRUNC('quarter', datum)::DATE + 1                                         AS day_of_quarter,
       EXTRACT(DOY FROM datum)                                                                AS day_of_year,
       TO_CHAR(datum, 'W')::INT                                                               AS week_of_month,
       EXTRACT(WEEK FROM datum)                                                               AS week_of_year,
       EXTRACT(ISOYEAR FROM datum) || TO_CHAR(datum, '"-W"IW-') || EXTRACT(ISODOW FROM datum) AS week_of_year_iso,
       EXTRACT(MONTH FROM datum)                                                              AS month_actual,
       TO_CHAR(datum, 'TMMonth')                                                              AS month_name,
       TO_CHAR(datum, 'Mon')                                                                  AS month_name_abbreviated,
       EXTRACT(QUARTER FROM datum)                                                            AS quarter_actual,
       CASE
           WHEN EXTRACT(QUARTER FROM datum) = 1 THEN 'First'
           WHEN EXTRACT(QUARTER FROM datum) = 2 THEN 'Second'
           WHEN EXTRACT(QUARTER FROM datum) = 3 THEN 'Third'
           WHEN EXTRACT(QUARTER FROM datum) = 4 THEN 'Fourth'
           END                                                                                AS quarter_name,
       EXTRACT(YEAR FROM datum)                                                               AS year_actual,
       datum + (1 - EXTRACT(ISODOW FROM datum))::INT                                          AS first_day_of_week,
       datum + (7 - EXTRACT(ISODOW FROM datum))::INT                                          AS last_day_of_week,
       datum + (1 - EXTRACT(DAY FROM datum))::INT                                             AS first_day_of_month,
       (DATE_TRUNC('MONTH', datum) + INTERVAL '1 MONTH - 1 day')::DATE                        AS last_day_of_month,
       DATE_TRUNC('quarter', datum)::DATE                                                     AS first_day_of_quarter,
       (DATE_TRUNC('quarter', datum) + INTERVAL '3 MONTH - 1 day')::DATE                      AS last_day_of_quarter,
       TO_DATE(EXTRACT(YEAR FROM datum) || '-01-01', 'YYYY-MM-DD')                            AS first_day_of_year,
       TO_DATE(EXTRACT(YEAR FROM datum) || '-12-31', 'YYYY-MM-DD')                            AS last_day_of_year,
       TO_CHAR(datum, 'mmyyyy')                                                               AS mmyyyy,
       TO_CHAR(datum, 'mmddyyyy')                                                             AS mmddyyyy,
       CASE
           WHEN EXTRACT(ISODOW FROM datum) IN (6, 7) THEN TRUE
           ELSE FALSE
           END                                                                                AS weekend_indr
FROM (SELECT '2008-01-01'::DATE + SEQUENCE.DAY AS datum
      FROM GENERATE_SERIES(0, 29219) AS SEQUENCE (DAY)
      GROUP BY SEQUENCE.DAY) DQ
ORDER BY 1;
COMMIT;

-- 状态表，只录入一次
drop table if exists dmi.dmi_status;
create table dmi.dmi_status
(
    id     bigint not null primary key,
    status int    null,
    name   varchar(20)
);
INSERT INTO dmi.dmi_status (id, status, name)
VALUES (1::bigint, 1::integer, 'create order'::varchar(20));
INSERT INTO dmi.dmi_status (id, status, name)
VALUES (2::bigint, 5::integer, 'ship order'::varchar(20));

--城市维度表，如果有全量数据的话，只需要导入一次
-- drop table if exists dmi.dmi_city;
create table if not exists dmi.dmi_city
(
    id             bigserial
        constraint dmi_city_pk
            primary key,
    city           varchar(30) not null,
    state_province varchar(50) not null,
    country_region varchar(50) not null
);

-- 全量
-- drop table if exists dmi.dmi_product;
create table if not exists dmi.dmi_product
(
    product_id                                int              not null,
    name                                      varchar(50)      not null,
    product_number                            varchar(25)      not null,
    color                                     varchar(15)      null,
    standard_cost                             double precision not null,
    list_price                                double precision not null,
    size                                      varchar(5)       null,
    weight                                    decimal(8, 2)    null,
    sell_start_date                           date             null,
    sell_end_date                             date             null,
    discontinued_date                         date             null,
    modified_date                             date             null,
    -- product_category
    product_category1_id                      int              not null,
    product_category1_name                    varchar(50)      not null,
    product_category2_id                      int              not null,
    product_category2_name                    varchar(50)      not null,
    -- product_model_id
    product_model_name                        varchar(50)      not null,
    product_model_catalog_description         varchar(200)     null,
    product_model_product_culture_description json             null
);


-- 用户维度，拉链表
-- drop table if exists dmi.dmi_customer;
create table if not exists dmi.dmi_customer
(
    customer_id   int          not null,
    name_style    boolean      not null,
    title         varchar(8)   null,
    first_name    varchar(50)  not null,
    middle_name   varchar(50)  null,
    last_name     varchar(50)  not null,
    suffix        varchar(10)  null,
    company_name  varchar(128) null,
    sales_person  varchar(256) null,
    email_address varchar(50)  null,
    phone         varchar(25)  null,
    password_hash varchar(128) not null,
    password_salt varchar(10)  not null,
    modified_date date         not null,
    create_time   varchar(50)  not null,
    end_date      varchar(50)  not null
);

-- 全量最新的用户数据
drop table if exists dmi.dmi_customer_99999999;
create table dmi.dmi_customer_99999999
(
) inherits (dmi.dmi_customer);
-- dmi_customer首次装载数据sql
insert into dmi.dmi_customer_99999999
select customer_id,
       name_style,
       title,
       first_name,
       middle_name,
       last_name,
       suffix,
       company_name,
       sales_person,
       email_address,
       phone,
       password_hash,
       password_salt,
       modified_date,
       '{{yesterday_ds}}',
       '9999-99-99'
from ods.ods_customer_{{yesterday_ds_nodash}}