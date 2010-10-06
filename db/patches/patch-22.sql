-- Patch 22
-- Author: Anisha S.

UPDATE `cms_page` set `title`='Buy books online' where `page_id`=2;

UPDATE `core_config_data`  set `value` =  '- Ekkitab.com - India''s online bookstore' where `path` ='design/head/title_suffix';
UPDATE `core_config_data`  set `value` =  'Buy and Donate books Online in India' where `path` ='design/head/default_title';