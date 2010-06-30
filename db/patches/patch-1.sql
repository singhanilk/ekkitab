-- Patch 1
-- Author: Anisha S.

INSERT INTO `cms_page` (`page_id`, `title`, `root_template`, `meta_keywords`, `meta_description`, `identifier`, `content`, `creation_time`, `update_time`, `is_active`, `sort_order`, `layout_update_xml`, `custom_theme`, `custom_theme_from`, `custom_theme_to`) VALUES
(8, 'Ekkitab Donation Home', 'two_columns_left', '', '', 'ekkitab-donation-home', '{{block type="page/html" name="ekkitab_donation_home"  template="page/html/donate_home.phtml" }}', '2009-10-15 09:35:23', '2009-10-15 09:35:23', 1, 0, NULL, NULL, NULL, NULL);

INSERT INTO `cms_page_store` (`page_id`, `store_id`) VALUES (8, 0);

