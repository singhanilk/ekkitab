use `ekkitab_books`;
--
-- Dumping data for table `ek_catalog_popular_categories`
--

Delete from `ek_catalog_popular_categories`;

INSERT INTO `ek_catalog_popular_categories` (`id`, `category`, `url_path`,  `order_no`, `is_active`,  `popularity`, `date`, `timestamp`) VALUES
(1, 'Fiction','fiction.html', 1, 1, 15,'2009-11-19 16:20:53', '2009-11-19 16:20:56'),
(2, 'Comics & Graphic Novels', 'comics-graphic-novels.html', 2, 1, 11,'2009-11-19 14:18:57', '2009-11-19 14:18:57'),
(3, 'Religion', 'religion.html', 3, 1, 13,'2009-11-19 16:19:28', '2009-11-19 16:19:46'),
(4, 'Juvenile Nonfiction', 'juvenile-nonfiction.html', 4, 1, 15,'2009-11-19 16:20:31', '2009-11-19 16:20:56'),
(5, 'Business & Economics', 'business-economics.html', 5, 1, 10,'2009-11-19 16:20:31', '2009-11-19 16:20:56'),
(6, 'Travel', 'travel.html', 6, 1, 14,'2009-11-19 16:20:31', '2009-11-19 16:20:56'),
(7, 'Cooking', 'cooking.html', 7, 1, 11,'2009-11-19 16:20:31', '2009-11-19 16:20:56');
