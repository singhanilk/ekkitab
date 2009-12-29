use `ekkitab_books`;
--
-- Dumping data for table `ek_catalog_top_authors`
--

Delete from  `ek_catalog_top_authors`;

INSERT INTO `ek_catalog_top_authors` (`id`, `author`, `order_no`, `is_active`, `popularity`, `date`, `timestamp`) VALUES
(1, 'Agatha Christie', 1, 1, 14,'2009-11-12 16:19:28', '2009-11-12 16:19:46'),
(2, 'Megan McDonald', 2, 1, 10, '2009-11-12 16:20:31', '2009-11-12 16:20:56'),
(3, 'Edith Wharton', 3, 1, 13, '2009-11-12 16:20:53', '2009-11-12 16:20:56'),
(4, 'Jillian Powell', 4, 1, 10, NULL, '2009-11-17 14:18:57'),
(5, 'Patricia Cornwell', 5, 1, 14, NULL, '2009-11-17 14:18:57'),
(6, 'Colin Harrison', 6, 1, 11, NULL, '2009-11-17 14:18:57'),
(7, 'Arthur Edward Waite', 7, 1, 15, NULL, '2009-11-17 14:18:57');
