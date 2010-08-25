-- Patch 15
-- Author: Anisha S.

UPDATE `cms_page` set `title`='Online Bookstore India | Buy books online | Donate Books | Online Book Shopping India' where `page_id`=2;


UPDATE `core_config_data`  set `value` =  'Online Bookstore India | Buy books online | Donate Books | Online Book Shopping' where `path` ='design/head/default_title';
UPDATE `core_config_data`  set `value` =  'Ekkitab.com: Online Bookstore India, Buy Books online, Online Books Shopping,Donate Books to schools,colleges, library or any organization online.' where path='design/head/default_keywords';
UPDATE `core_config_data`  set `value` =  'Buy books online in India. Best Online Bookstore with Quick Delivery and Free Shipping* within India. Great Discounts on all Indian and International Books. Donate Books to your school,college, library or any organization online. Gift books to your close ones - friends and relatives. Purchase books online in India. Convenient and Hassle Free.' where path='design/head/default_description';