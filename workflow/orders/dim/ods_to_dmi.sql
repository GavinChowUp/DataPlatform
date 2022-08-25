with product_base as (select product_id,
                             name,
                             product_number,
                             color,
                             standard_cost,
                             list_price,
                             size,
                             weight,
                             sell_start_date,
                             sell_end_date,
                             discontinued_date,
                             modified_date,
                             product_category_id,
                             product_model_id
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
                    json_agg(json_build_array(pmpd.culture, opd.description)) as product_model_product_desc_culture
             from ods.ods_product_model_product_desc_{{yesterday_ds_nodash}} pmpd
                      left join ods.ods_product_description opd
                                on pmpd.product_description_iid = opd.product_description_id
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
       product_base.product_category_id,
       product_base.product_model_id,
       category1.product_category1_id,
       category1.product_category1_name,
       category2.product_category2_id,
       category2.product_category2_name,
       product_module.product_model_name,
       product_module.product_model_catalog_description,
       product_module_product_desc.product_model_product_desc_culture
from ods.ods_product_{{yesterday_ds_nodash}}
         left join category2 on product_base.product_category_id = category1.product_category_id
         left join category1 on category2.parent_product_category_id = category1.product_category_id
         left join product_module on product_base.product_model_id = product_module.product_model_id
         left join product_module_product_desc
                   on product_module_product_desc.product_model_id = product_base.product_model_id;
