-- Patch 19
-- Author: Anisha S.

INSERT INTO `cms_page` (`page_id`, `title`, `root_template`, `meta_keywords`, `meta_description`, `identifier`, `content`, `creation_time`, `update_time`, `is_active`, `sort_order`, `layout_update_xml`, `custom_theme`, `custom_theme_from`, `custom_theme_to`) VALUES
(11,'Meet Sonia Shah', 'one_column', '', '', 'meet-sonia-shah', '{{block type="page/html" name="sonia_shah"  template="page/html/sonia_shah.phtml" }}', '', '', 1, 0, NULL, NULL,NULL,NULL);

INSERT INTO `cms_page_store` (`page_id`, `store_id`) VALUES
(11, 0);
