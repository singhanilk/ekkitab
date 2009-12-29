use `ekkitab_books`;
--
-- Dumping data for table `core_config_data`
--

Delete from `core_config_data` where path in ("catalog/category/root_id","design/theme/default","currency/options/base","currency/options/default","currency/options/allow","currency/options/trim_sign","design/theme/default","design/head/default_title","design/head/default_keywords","design/header/logo_src","design/header/logo_alt","design/header/welcome","design/footer/copyright");

INSERT INTO `core_config_data` (`config_id`, `scope`, `scope_id`, `path`, `value`) VALUES
(1, 'default', 0, 'catalog/category/root_id', '2'),
(2, 'default', 0, 'design/theme/default', 'ekkitab'),
(3, 'default', 0, 'currency/options/base', 'INR'),
(4, 'stores', 1, 'currency/options/default', 'INR'),
(5, 'stores', 1, 'currency/options/allow', 'EUR,INR,USD'),
(6, 'stores', 1, 'currency/options/trim_sign', '0'),
(7, 'stores', 1, 'design/theme/default', 'ekkitab'),
(8, 'stores', 1, 'design/head/default_title', 'Ekkitab Education Services Pvt Ltd'),
(9, 'stores', 1, 'design/head/default_keywords', 'Ekkitab, online bookstore'),
(10, 'stores', 1, 'design/header/logo_src', 'images/logo.png'),
(11, 'stores', 1, 'design/header/logo_alt', 'Ekkitab Education Services Pvt Ltd'),
(12, 'stores', 1, 'design/header/welcome', 'Welcome Guest!'),
(13, 'stores', 1, 'design/footer/copyright', '&copy; 2009 Ekkitab Educational Services Pvt Ltd. All Rights Reserved.');

