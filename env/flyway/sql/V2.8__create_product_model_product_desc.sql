drop table if exists product_model_product_desc;
create table product_model_product_desc
(
    product_model_id        int null,
    product_description_Iid int null,
    culture                 char(6)  null,
    row_guid                char(38) null,
    modified_date           date null
);

create index product_model_product_desc_index
    on product_model_product_desc (product_model_id, product_description_Iid, culture);

