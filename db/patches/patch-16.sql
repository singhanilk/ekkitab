-- Patch 16
-- Author: Anisha S.

alter table review add isbn varchar(20) NOT NULL;

alter table wishlist_item add isbn varchar(20) NOT NULL;

alter table wishlist add organization_id int(10) default '0';

alter table wishlist drop KEY FK_CUSTOMER;

alter table wishlist ADD UNIQUE KEY `FK_CUSTOMER` (`customer_id`,`organization_id`);

UPDATE `core_config_data`  set `value` =  '0' where `path` ='catalog/review/allow_guest';
