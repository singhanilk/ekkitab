use `ekkitab_books`;
--
-- Dumping data for table `ek_catalog_product_bestsellers`
--

Delete from `ek_catalog_product_newreleases`;

INSERT INTO `ek_catalog_product_newreleases` (`product_id`, `title`,  `author`, `image_url`,  `price`, `is_active`, `order_no`, `date`, `timestamp`) VALUES
(36, "Irredeemable Ant-Man Volume 2 Digest","Charles","9/7/9780785119630.jpg",3.25, 1,1,'2009-11-19 16:20:53', '2009-11-19 16:20:56'),
(37, "Essential Daredevil: Volume 4","David","9/7/9780785127628.jpg",6.25, 1, 2,'2009-11-19 14:18:57', '2009-11-19 14:18:57'),
(38, "Essential X-Men Volume 8 Tpb", "Femer","9/7/9780785127635.jpg",8.25,1, 3,'2009-11-19 16:19:28', '2009-11-19 16:19:46'),
(77, "We Are Paper Sisters Detective Company","Donald","9/7/9781421508627.jpg",1.25,1, 4,'2009-11-19 16:20:31', '2009-11-19 16:20:56');