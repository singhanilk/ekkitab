--
-- Dumping data for table `ek_catalog_top_authors`
--

INSERT INTO `ek_catalog_top_authors` (`id`, `author`, `order_no`, `is_active`, `date`, `timestamp`) VALUES
(1, 'J K Rowling', 3, 1, '2009-11-12 16:19:28', '2009-11-12 16:19:46'),
(2, 'Chetan Bhagat', 1, 1, '2009-11-12 16:20:31', '2009-11-12 16:20:56'),
(3, 'Dr A P J Abdul Kalam', 2, 1, '2009-11-12 16:20:53', '2009-11-12 16:20:56'),
(4, 'Rudyard Kipling', 4, 1, NULL, '2009-11-17 14:18:57');


--
-- Dumping data for table `ek_catalog_popular_categories`
--

INSERT INTO `ek_catalog_popular_categories` (`id`, `category`, `url_path`,  `order_no`, `is_active`, `date`, `timestamp`) VALUES
(1, 'Biographies & Memoirs', 'biographies-memoirs.html', 3, 1, '2009-11-19 16:19:28', '2009-11-19 16:19:46'),
(2, 'Literature & Fiction', 'literature-fiction.html', 1, 1, '2009-11-19 16:20:31', '2009-11-19 16:20:56'),
(3, 'Science Fiction & Fantasy','science-fiction-fantasy.html', 2, 1, '2009-11-19 16:20:53', '2009-11-19 16:20:56'),
(4, 'Religion & Spirituality', 'religion-spirituality.html', 4, 1, '2009-11-19 14:18:57', '2009-11-19 14:18:57');
