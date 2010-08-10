-- Patch 11
-- Author: Anisha S.

INSERT INTO `cms_page` (`page_id`, `title`, `root_template`, `meta_keywords`, `meta_description`, `identifier`, `content`, `creation_time`, `update_time`, `is_active`, `sort_order`, `layout_update_xml`, `custom_theme`, `custom_theme_from`, `custom_theme_to`) VALUES
(9, 'All Books', 'one_column', '', '', 'all-books', '{{block type="ekkitab_catalog/category_allBooks" name="complete_catalog" template="catalog/category/pages.phtml" }}', '', '', 1, 0, NULL, NULL,NULL,NULL);

