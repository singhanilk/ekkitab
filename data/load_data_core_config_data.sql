use `ekkitab_books`;
--
-- Dumping data for table `core_config_data`
--

Delete from `core_config_data` where path in ("catalog/category/root_id","design/theme/default","currency/options/base","currency/options/default","currency/options/allow","currency/options/trim_sign","design/theme/default","design/head/default_title","design/head/default_keywords","design/header/logo_src","design/header/logo_alt","design/header/welcome","design/footer/copyright");

INSERT INTO `core_config_data` (`scope`, `scope_id`, `path`, `value`) VALUES
('default', 0, 'catalog/category/root_id', '2'),
('default', 0, 'design/theme/default', 'ekkitab'),
('default', 0, 'currency/options/base', 'INR'),
('stores', 1, 'currency/options/default', 'INR'),
('stores', 1, 'currency/options/allow', 'EUR,INR,USD'),
('stores', 1, 'currency/options/trim_sign', '0'),
('stores', 1, 'design/theme/default', 'ekkitab'),
('stores', 1, 'design/head/default_title', 'Ekkitab Education Services Pvt Ltd'),
('stores', 1, 'design/head/default_keywords', 'Ekkitab, online bookstore'),
('stores', 1, 'design/header/logo_src', 'images/logo.png'),
('stores', 1, 'design/header/logo_alt', 'Ekkitab Education Services Pvt Ltd'),
('stores', 1, 'design/header/welcome', 'Welcome Guest!'),
('stores', 1, 'design/footer/copyright', '&copy; 2009 Ekkitab Educational Services Pvt Ltd. All Rights Reserved.');

