use ekkitab_books;

ALTER Table `ek_catalog_popular_categories`drop column url_path;

update  `core_website` set `name`='Ekkitab' where `website_id` =1;

update  `core_store_group` set `name`='Ekkitab' where `group_id` =1;

update  `core_store` set `name`='Ekkitab' where `store_id` =1;