-- Patch 14
-- Author: Anisha S.

UPDATE `cms_page` set `title`='Online Bookstore India | Buy books online | Donate Books to your school | Online Book Shopping India' where `page_id`=2;
UPDATE `cms_page` set `title`='Page Not Found' where `page_id`=1;
UPDATE `cms_page` set `title`='Site Policies' where `page_id`=4;
UPDATE `cms_page` set `title`='Vision' where `page_id`=8;
UPDATE `cms_page` set `title`='All Books | Books Directory | Complete list of Books | Complete Catalog' where `page_id`=9;


UPDATE `core_config_data`  set `value` =  '- Ekkitab.com' where `path` ='design/head/title_suffix';
UPDATE `core_config_data`  set `value` =  'Ekkitab.com | Ekkitab Educational Services Pvt Ltd' where `path` ='design/header/logo_alt';
UPDATE `core_config_data`  set `value` =  'Online Bookstore India | Buy books online | Donate Books to your school | Online Book Shopping' where `path` ='design/head/default_title';
UPDATE `core_config_data`  set `value` =  'Ekkitab.com: Online Bookstore India, Buy Books online, Online Books Shopping,Donate Books,Donate book to your school' where path='design/head/default_keywords';
UPDATE `core_config_data`  set `value` =  'Buy books online in India. Best Online Bookstore with Quick Delivery and Free Shipping* within India. Great Discounts on all Indian and International Books. Donate Books to your school online. Gift books to your close ones. Purchase books online in India. Convenient and Hassle Free.' where path='design/head/default_description';