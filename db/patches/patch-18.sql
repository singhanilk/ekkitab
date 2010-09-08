-- Patch 18
-- Author: Anisha S.

INSERT INTO `core_config_data` (`scope`, `scope_id`, `path`, `value`) VALUES
('default', 0, 'catalog/placeholder/minithumb_placeholder','stores/1/minithumb.png');

Update `core_config_data`  set value='stores/1/thumbnail.png' where path='catalog/placeholder/thumbnail_placeholder';

Update `cms_page`  set content='{{block type="ekkitab_catalog/globalsection" name="globalsection_home" template="catalog/globalsection/home_page.phtml" }}' where page_id=2;


