-- dmi_product 维度装载数据sql
with product_base as (select product_id
                           , name
                           , product_number
                           , color
                           , standard_cost
                           , list_price
                           , size
                           , weight
                           , sell_start_date
                           , sell_end_date
                           , discontinued_date
                           , modified_date
                           , product_category_id
                           , product_model_id
                      from ods.ods_product_{{yesterday_ds_nodash}}),
     category1 as (select product_category_id as product_category1_id,
                          name                   product_category1_name,
                          product_category_id
                   from ods.ods_product_category_{{yesterday_ds_nodash}}),
     category2 as (select product_category_id as product_category2_id,
                          name                as product_category2_name,
                          parent_product_category_id
                   from ods.ods_product_category_{{yesterday_ds_nodash}}),
     product_module as (select name                as product_model_name,
                               catalog_description as product_model_catalog_description,
                               product_model_id
                        from ods.ods_product_model_{{yesterday_ds_nodash}}),
     product_module_product_desc
         as (select pmpd.product_model_id,
                    json_agg(json_build_array(trim(pmpd.culture), opd.description)) as product_model_product_desc_culture
             from ods.ods_product_model_product_desc_{{yesterday_ds_nodash}} pmpd
    left join ods.ods_product_description_{{yesterday_ds_nodash}} opd
             on pmpd.product_description_id = opd.product_description_id
             group by pmpd.product_model_id)
insert
into dmi.dmi_product_{{yesterday_ds_nodash}}
select product_base.product_id,
       product_base.name,
       product_base.product_number,
       product_base.color,
       product_base.standard_cost,
       product_base.list_price,
       product_base.size,
       product_base.weight,
       product_base.sell_start_date,
       product_base.sell_end_date,
       product_base.discontinued_date,
       product_base.modified_date,
       category1.product_category1_id,
       category1.product_category1_name,
       category2.product_category2_id,
       category2.product_category2_name,
       product_module.product_model_name,
       product_module.product_model_catalog_description,
       product_module_product_desc.product_model_product_desc_culture
from product_base
         left join category2 on category2.product_category2_id = product_base.product_category_id
         left join category1 on category1.product_category_id = category2.parent_product_category_id
         left join product_module on product_module.product_model_id = product_base.product_model_id
         left join product_module_product_desc
                   on product_module_product_desc.product_model_id = product_base.product_model_id;

-- dmi_customer 每日装载数据sql
-- dmi.dmi_customer_{{macros.ds_format(macros.ds_add(yesterday_ds,-1),'%Y-%m-%d','%Y%m%d')}}
-- 有效数据入库
with tmp as (select new.customer_id   as new_customer_id,
                    new.name_style    as new_name_style,
                    new.title         as new_title,
                    new.first_name    as new_first_name,
                    new.middle_name   as new_middle_name,
                    new.last_name     as new_last_name,
                    new.suffix        as new_suffix,
                    new.company_name  as new_company_name,
                    new.sales_person  as new_sales_person,
                    new.email_address as new_email_address,
                    new.phone         as new_phone,
                    new.password_hash as new_password_hash,
                    new.password_salt as new_password_salt,
                    new.modified_date as new_modified_date,
                    new.create_time   as new_create_time,
                    new.end_date      as new_end_date,
                    old.customer_id   as old_customer_id,
                    old.name_style    as old_name_style,
                    old.title         as old_title,
                    old.first_name    as old_first_name,
                    old.middle_name   as old_middle_name,
                    old.last_name     as old_last_name,
                    old.suffix        as old_suffix,
                    old.company_name  as old_company_name,
                    old.sales_person  as old_sales_person,
                    old.email_address as old_email_address,
                    old.phone         as old_phone,
                    old.password_hash as old_password_hash,
                    old.password_salt as old_password_salt,
                    old.modified_date as old_modified_date,
                    old.create_time   as old_create_time,
                    old.end_date      as old_end_date

             from (select customer_id,
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
                          create_time,
                          end_date
                   from dmi.dmi_customer_99999999) old
                      full outer join
                  (select customer_id,
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
                          '{{yesterday_ds}}' as create_time,
                          '9999-99-99'       as end_date
                   from ods.ods_customer_{{yesterday_ds_nodash}}
                   where modified_date >=to_date('{{yesterday_ds}}', 'yyyy-MM-dd')) new
                  on old.customer_id = new.customer_id)
insert
into dmi.dmi_customer_99999999
select COALESCE(new_customer_id, old_customer_id),
       COALESCE(new_name_style, old_name_style),
       COALESCE(new_title, old_title),
       COALESCE(new_first_name, old_first_name),
       COALESCE(new_middle_name, old_middle_name),
       COALESCE(new_last_name, old_last_name),
       COALESCE(new_suffix, old_suffix),
       COALESCE(new_company_name, old_company_name),
       COALESCE(new_sales_person, old_sales_person),
       COALESCE(new_email_address, old_email_address),
       COALESCE(new_phone, old_phone),
       COALESCE(new_password_hash, old_password_hash),
       COALESCE(new_password_salt, old_password_salt),
       COALESCE(new_modified_date, old_modified_date),
       COALESCE(new_create_time, old_create_time),
       COALESCE(new_end_date, old_end_date)
from tmp;

-- 过期数据入库
with tmp as (select new.customer_id   as new_customer_id,
                    new.name_style    as new_name_style,
                    new.title         as new_title,
                    new.first_name    as new_first_name,
                    new.middle_name   as new_middle_name,
                    new.last_name     as new_last_name,
                    new.suffix        as new_suffix,
                    new.company_name  as new_company_name,
                    new.sales_person  as new_sales_person,
                    new.email_address as new_email_address,
                    new.phone         as new_phone,
                    new.password_hash as new_password_hash,
                    new.password_salt as new_password_salt,
                    new.modified_date as new_modified_date,
                    new.create_time   as new_create_time,
                    new.end_date      as new_end_date,
                    old.customer_id   as old_customer_id,
                    old.name_style    as old_name_style,
                    old.title         as old_title,
                    old.first_name    as old_first_name,
                    old.middle_name   as old_middle_name,
                    old.last_name     as old_last_name,
                    old.suffix        as old_suffix,
                    old.company_name  as old_company_name,
                    old.sales_person  as old_sales_person,
                    old.email_address as old_email_address,
                    old.phone         as old_phone,
                    old.password_hash as old_password_hash,
                    old.password_salt as old_password_salt,
                    old.modified_date as old_modified_date,
                    old.create_time   as old_create_time,
                    old.end_date      as old_end_date

             from (select customer_id,
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
                          create_time,
                          end_date
                   from dmi.dmi_customer_99999999) old
                      full outer join
                  (select customer_id,
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
                          '{{yesterday_ds}}' as create_time,
                          '9999-99-99'       as end_date
                   from ods.ods_customer_{{yesterday_ds_nodash}}
                   where modified_date >=to_date('{{yesterday_ds}}', 'yyyy-MM-dd')) new
                  on old.customer_id = new.customer_id)
insert
into dmi.dmi_customer_{{macros.ds_format(macros.ds_add(yesterday_ds, -1),'%Y-%m-%d','%Y%m%d')}}
select old_customer_id,
       old_name_style,
       old_title,
       old_first_name,
       old_middle_name,
       old_last_name,
       old_suffix,
       old_company_name,
       old_sales_person,
       old_email_address,
       old_phone,
       old_password_hash,
       old_password_salt,
       old_modified_date,
       old_create_time,
       '{{macros.ds_add(yesterday_ds,-1)}}'
from tmp
where old_customer_id is not null
  and new_customer_id is not null;

insert into olap_db.dmi.dmi_city (city, state_province, country_region)
select distinct city, state_province, country_region
from olap_db.ods.ods_address_{{yesterday_ds_nodash}} new
where not exists(select city from olap_db.dmi.dmi_city old where old.city = new.city and old.state_province = new.state_province)

