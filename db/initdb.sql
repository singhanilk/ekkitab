-- Initdb.sql
--
-- COPYRIGHT (C) 2009 Ekkitab Educational Services India Pvt. Ltd.  
-- All Rights Reserved. All material contained in this file (including, but not 
-- limited to, text, images, graphics, HTML, programming code and scripts) constitute 
-- proprietary and confidential information protected by copyright laws, trade secret 
-- and other laws. No part of this software may be copied, reproduced, modified 
-- or distributed in any form or by any means, or stored in a database or retrieval 
-- system without the prior written permission of Ekkitab Educational Servives.
--
-- @author Arun Kuppuswamy       (arun@ekkitab.com)
-- @version 1.0     Jan 28, 2010




use `ekkitab_books`;

--
-- Dumping data for table `ek_catalog_product_bestsellers`
--

Delete from `ek_catalog_product_bestsellers`;

INSERT INTO `ek_catalog_product_bestsellers` (`product_id`,  `is_active`, `order_no`, `date`, `timestamp`) VALUES
(7, 1, 1,'2009-11-19 16:20:53', '2009-11-19 16:20:56'),
(19,1, 2,'2009-11-19 14:18:57', '2009-11-19 14:18:57'),
(13,1, 3,'2009-11-19 16:19:28', '2009-11-19 16:19:46'),
(6, 1, 4,'2009-11-19 16:20:31', '2009-11-19 16:20:56');

-- -------------------------------------------------------------



--
-- Dumping data for table `ek_catalog_product_newreleases`
--

Delete from `ek_catalog_product_newreleases`;

INSERT INTO `ek_catalog_product_newreleases` (`product_id`, `is_active`, `order_no`, `date`, `timestamp`) VALUES
(36, 1, 1,'2009-11-19 16:20:53', '2009-11-19 16:20:56'),
(37, 1, 2,'2009-11-19 14:18:57', '2009-11-19 14:18:57'),
(38, 1, 3,'2009-11-19 16:19:28', '2009-11-19 16:19:46'),
(77, 1, 4,'2009-11-19 16:20:31', '2009-11-19 16:20:56');

-- -------------------------------------------------------------



--
-- Dumping data for table `ek_catalog_product_best_boxedsets`
--

Delete from `ek_catalog_product_best_boxedsets`;

INSERT INTO `ek_catalog_product_best_boxedsets` (`product_id`,`is_active`, `order_no`, `date`, `timestamp`) VALUES
(56, 1, 1,'2009-11-19 16:20:53', '2009-11-19 16:20:56'),
(55, 1, 2,'2009-11-19 14:18:57', '2009-11-19 14:18:57'),
(96, 1, 3,'2009-11-19 16:19:28', '2009-11-19 16:19:46'),
(41, 1, 4,'2009-11-19 16:20:31', '2009-11-19 16:20:56');

-- -------------------------------------------------------------

--
-- Update the `cms_page` table with about-ekkitab & coustomer service
--


UPDATE `cms_page` set `identifier` = 'about-ekkitab' where page_id = '3';
UPDATE `cms_block` set `content`   = '<ul>\r\n<li><a href="{{store url=""}}about-ekkitab">About Us</a></li>\r\n<li class="last"><a href="{{store url=""}}customer-service">Customer Service</a></li>\r\n</ul>' where block_id = '5';

UPDATE `cms_page` set `content` = '<br class="clear"/><div class="col3-set"><div class="col-1"><p><img src="{{skin url=''images/logo_aboutus.png''}}" alt="Ekkitab Logo"/></p><p style="line-height:1.2em;"><small>Ekkitab Educational Services Pvt. Ltd. was founded in 2009 and is headquartered in Bangalore, India. </small></p><p style="color:#888; font:1.2em/1.4em georgia, serif;">Ekkitab is founded on the desire to promote reading.  It is based on the belief that every child and adult in India should have access to good books irrespective of where they live and their level in society.</p><p><strong>To achieve this objective, Ekkitab is putting up a globally accessible book store that carries English and all Indian language books.  The immediate goal is to make this on-line bookstore very successful by virtue of good design, easy access and comprehensive stocking.</strong></p></div><div class="col-2"><p>Ekkitab will actively promote organizations that are centers of learning, like school, college, city, town and village libraries, by inviting its visitors to donate to these organizations. The company wishes to encourage readership by making good books available easily and by making community reading centers like city and town libraries active and popular by virtue of having good content.</p><p>Ekkitab wants to create the largest donor network in books in the country and thereby realize its vision of providing every Indian with access to good books. This donor network will be driven by goodwill, community and a sense of commitment to the cause that Ekkitab is working towards. We hope to solve the difficulties that exist today for people to share good books and promote reading.</p><p>In the process of achieving its vision, Ekkitab hopes to become the best known and best loved brand in bookshops, on-line or otherwise.  We hope to be able to take the bookstore and the concept of on-line buying to smaller towns and villages across the country.  Eventually, we hope to increase readership and the sheer size of the book business in India. We hope to be able to work with publishers and distributors in the country to help increase access to every book that is in print. This will help the publishing industry by extending their reach across the country and will help readers by decreasing the cost of books.</p></div><div class="col-3"><p><strong>We hope to become an important channel for publishers to reach their customers and are willing to work with them to build new digital models of commerce that can provide conveniences that are not possible today. In making the business a success we hope to stimulate the donor network to give liberally to the cause of reading in India and to reduce the digital divide between the rich and the poor.</strong></p><p>We also hope that by doing so, we can remove the bane of piracy from the industry and ensure that the benefits of each sale reaches its rightful owners.  In the longer term, Ekkitab wants to promote good writers and provide a platform for publishers to promote new authors and their works.  In everything, we want to support and nourish the book eco-system in the country by scaling it manifold across the Indian population.</p><div class="divider"></div><p>Thank you for your interest. </p><p>We hope that you have a pleasant experience at ekkitab.com and we count on your support of the cause. <br/><br/>You can reach us at: ccare@ekkitab.com. <br/><br/>We are located at: #82/83, Borewell Road, Whitefield Main, Bangalore - 560066.</p><p style="line-height:1.0em;"><br/><small>Team Ekkitab</small></p></div></div>' where page_id = '3';
UPDATE `cms_page` set `content` = '<div class="page-head">\r\n<h3>Customer Service</h3>\r\n</div>\r\n<ul class="disc" style="margin-bottom:15px;">\r\n<li><a href="#answer1">Shipping & Delivery</a></li>\r\n<li><a href="#answer2">Privacy & Security</a></li>\r\n<li><a href="#answer3">Returns & Replacements</a></li>\r\n<li><a href="#answer4">Ordering</a></li>\r\n<li><a href="#answer5">Payment, Pricing & Promotions</a></li>\r\n<li><a href="#answer6">Viewing Orders</a></li>\r\n<li><a href="#answer7">Updating Account Information</a></li>\r\n</ul>\r\n<dl>\r\n<dt id="answer1">Shipping & Delivery</dt>\r\n<dd style="margin-bottom:10px;">To be updated.</dd>\r\n<dt id="answer2">Privacy & Security</dt>\r\n<dd style="margin-bottom:10px;"></dd>\r\n<dt id="answer3">Returns & Replacements</dt>\r\n<dd style="margin-bottom:10px;">To be updated</dd>\r\n<dt id="answer4">Ordering</dt>\r\n<dd style="margin-bottom:10px;">To be updated</dd>\r\n<dt id="answer5">Payment, Pricing & Promotions</dt>\r\n<dd style="margin-bottom:10px;">To be updated</dd>\r\n<dt id="answer6">Viewing Orders</dt>\r\n<dd style="margin-bottom:10px;">To be updated</dd>\r\n<dt id="answer7">Updating Account Information</dt>\r\n<dd style="margin-bottom:10px;">To be updated</dd>\r\n</dl>' where page_id='4';
UPDATE `cms_page` set `content` = '<div class="page-head-alt"><h3>Our apologies... </h3></div>\r\n<dl>\r\n<dt>The page you requested was not found.</dt>\r\n<dd>\r\n<ul class="disc">\r\n<li>If you typed the URL directly, please make sure the spelling is correct.</li>\r\n<li>If you clicked on a link to get here, the link is outdated.</li>\r\n</ul></dd>\r\n</dl>\r\n<br/>\r\n<dl>\r\n<dt>What can you do?</dt>\r\n<dd>Please contact Customer Care at ccare@ekkitab.com and let us know of this problem. We appreciate your help in ensuring that the service is always available and runs error free.</dd>\r\n<dd>\r\n<ul class="disc">\r\n<li><a href="#" onclick="history.go(-1);">Go back</a> to the previous page.</li>\r\n<li>Use the search bar at the top of the page to search the site.</li>\r\n<li>Follow these links to get you back on track!<br/><a href="{{store url=""}}">Store Home</a><br/><a href="{{store url="customer/account"}}">My Account</a></li></ul></dd></dl><br/>' where page_id='1';
UPDATE `cms_page` set content = '<div class="topRow">\r\n		<div class="textArea">\r\n			<div class="mainHdr">Enabling a billion readers</div>\r\n			Some text explaining the "Donate a book" concept will come here. How to find whether your institution / school / college / club whatever is listed. The various "donations" one can do - books, discount amounts, Gift Certificates etc. You''ve come to the right place! The various "donations" one can do - books, discount amounts, Gift Certificates etc.\r\n			<div class="readMore"><a href="#">Read more &raquo;</a></div><!-- raedMore -->\r\n		</div><!-- textArea -->\r\n      </div><!-- topRow -->\r\n\r\n       {{block type="ekkitab_catalog/product_bestsellers" name="bestsellers"  template="catalog/product/bestsellers.phtml" }}\r\n        {{block type="ekkitab_catalog/product_newreleases" name="newreleases"  template="catalog/product/newreleases.phtml" }}\r\n        {{block type="ekkitab_catalog/product_bestboxedsets" name="best.boxed.sets"  template="catalog/product/bestboxedsets.phtml" }}\r\n\r\n	<div class="hmMainRows">\r\n		<div class="mainLeftHdr">The ekkitab exclusive collections</div>\r\n		<img src="{{skin url=''images/hm_collections.jpg''}}" width="215" height="120" id="collImage" />\r\n		<div class="collText">For the past 10 years, NYRB Classics has resurrected lost classics, cult favorites, and canonical masters with an impeccable and eclectic eye for great literature. Now, for the first time, we are offering an exclusive, complete set of 250 NYRB Classics, the NYRB 10th Anniversary Complete Classics Collection, the perfect gift for the reader in your life who is hungry for a shelf full of literary discoveries. <div class="collLink"><a href="#">Read more about ekkitab Collections</a></div>\r\n		</div>\r\n		<div class="clear"></div>\r\n	</div><!-- hmMainRows -->\r\n\r\n	<div class="hmMainRows">\r\n		<div class="mainLeftHdr">Gift Ideas for Book Lovers</div>\r\n		<img src="{{skin url=''images/hm_sm_bks.jpg''}}" width="75" height="75" id="giftImage" />\r\n		<div class="giftText">Find the best deals on this season''s newest releases, blockbusters, cookbooks, festive reads, and more terrific book gifts in dozens of categories. Find the best deals on this season''s newest releases, blockbusters, cookbooks, festive reads, and more terrific book gifts in dozens of categories. <div class="collLink"><a href="#">See more Gift Ideas</a></div>\r\n		</div>\r\n		<div class="clear"></div>\r\n	</div><!-- hmMainRows -->\r\n      \r\n\r\n              <div class="hmMainRows">\r\n		<div class="mainLeftHdr">Specials for the Holiday Season</div>\r\n		Catch up on the complicated paranormal love triangle of Bella, Edward, and Jacob in New Moon, the second book in Stephenie Meyer''s bestselling Twilight saga, and the inspiration behind the big-screen adaptation. Sink your teeth "or claws" into these new Twilight titles:\r\n		<div class="vColumns">\r\n			<img src="{{skin url=''images/hmbk1.jpg''}}" width="89" height="135" />\r\n			<div class="titleEtc">\r\n				<div class="bkTitle"><a href="#">Superfreakonomics</a></div><!-- bkTitle -->\r\n				<div class="authorEtc">Steven D. Levitt</div>\r\n				<div class="authorEtc">Our Price: Rs. 340</div>\r\n				<div class="youSave">Save 19% off</div>\r\n			</div><!-- titleEtc -->\r\n		</div>\r\n		<div class="vMidColumn">\r\n			<img src="{{skin url=''images/hmbk2.jpg''}}" width="91" height="135" />\r\n			<div class="titleEtc">\r\n			<div class="bkTitle"><a href="#">Superfreakonomics</a></div><!-- bkTitle -->\r\n			<div class="authorEtc">Steven D. Levitt</div>\r\n			<div class="authorEtc">Our Price: Rs. 340</div>\r\n			<div class="youSave">Save 19% off</div>\r\n			</div><!-- titleEtc -->\r\n		</div>\r\n		<div class="vColumns">\r\n			<img src="{{skin url=''images/hmbk3.jpg''}}" width="89" height="135" />\r\n			<div class="titleEtc">\r\n			<div class="bkTitle"><a href="#">Superfreakonomics</a></div><!-- bkTitle -->\r\n			<div class="authorEtc">Steven D. Levitt</div>\r\n			<div class="authorEtc">Our Price: Rs. 340</div>\r\n			<div class="youSave">Save 19% off</div>\r\n			</div><!-- titleEtc -->\r\n		</div>\r\n		<div class="clear"></div>\r\n	</div><!-- hmMainRows -->\r\n\r\n', root_template='three_columns' where page_id =2;
UPDATE `cms_page` set `content` = '<br class="clear"/><div class="col3-set"><div class="col-1"><p><img src="{{skin url=''images/logo_aboutus.png''}}" alt="Ekkitab Logo"/></p><p style="line-height:1.2em;"><small>Ekkitab Educational Services Pvt. Ltd. was founded in 2009 and is headquartered in Bangalore, India. </small></p><p style="color:#888; font:1.2em/1.4em georgia, serif;">Ekkitab is founded on the desire to promote reading.  It is based on the belief that every child and adult in India should have access to good books irrespective of where they live and their level in society.</p><p><strong>To achieve this objective, Ekkitab is putting up a globally accessible book store that carries English and all Indian language books.  The immediate goal is to make this on-line bookstore very successful by virtue of good design, easy access and comprehensive stocking.</strong></p></div><div class="col-2"><p>Ekkitab will actively promote organizations that are centers of learning, like school, college, city, town and village libraries, by inviting its visitors to donate to these organizations. The company wishes to encourage readership by making good books available easily and by making community reading centers like city and town libraries active and popular by virtue of having good content.</p><p>Ekkitab wants to create the largest donor network in books in the country and thereby realize its vision of providing every Indian with access to good books. This donor network will be driven by goodwill, community and a sense of commitment to the cause that Ekkitab is working towards. We hope to solve the difficulties that exist today for people to share good books and promote reading.</p><p>In the process of achieving its vision, Ekkitab hopes to become the best known and best loved brand in bookshops, on-line or otherwise.  We hope to be able to take the bookstore and the concept of on-line buying to smaller towns and villages across the country.  Eventually, we hope to increase readership and the sheer size of the book business in India. We hope to be able to work with publishers and distributors in the country to help increase access to every book that is in print. This will help the publishing industry by extending their reach across the country and will help readers by decreasing the cost of books.</p></div><div class="col-3"><p><strong>We hope to become an important channel for publishers to reach their customers and are willing to work with them to build new digital models of commerce that can provide conveniences that are not possible today. In making the business a success we hope to stimulate the donor network to give liberally to the cause of reading in India and to reduce the digital divide between the rich and the poor.</strong></p><p>We also hope that by doing so, we can remove the bane of piracy from the industry and ensure that the benefits of each sale reaches its rightful owners.  In the longer term, Ekkitab wants to promote good writers and provide a platform for publishers to promote new authors and their works.  In everything, we want to support and nourish the book eco-system in the country by scaling it manifold across the Indian population.</p><div class="divider"></div><p>Thank you for your interest. </p><p>We hope that you have a pleasant experience at ekkitab.com and we count on your support of the cause. <br/><br/>You can reach us at: ccare@ekkitab.com. <br/><br/>We are located at: #82/83, Borewell Road, Whitefield Main, Bangalore - 560066.</p><p style="line-height:1.0em;"><br/><small>Team Ekkitab</small></p></div></div>' where page_id = '3';
UPDATE `cms_page` set `content` = '<div class="page-head">\r\n<h3>Customer Service</h3>\r\n</div>\r\n<ul class="disc" style="margin-bottom:15px;">\r\n<li><a href="#answer1">Shipping & Delivery</a></li>\r\n<li><a href="#answer2">Privacy & Security</a></li>\r\n<li><a href="#answer3">Returns & Replacements</a></li>\r\n<li><a href="#answer4">Ordering</a></li>\r\n<li><a href="#answer5">Payment, Pricing & Promotions</a></li>\r\n<li><a href="#answer6">Viewing Orders</a></li>\r\n<li><a href="#answer7">Updating Account Information</a></li>\r\n</ul>\r\n<dl>\r\n<dt id="answer1">Shipping & Delivery</dt>\r\n<dd style="margin-bottom:10px;">To be updated.</dd>\r\n<dt id="answer2">Privacy & Security</dt>\r\n<dd style="margin-bottom:10px;"></dd>\r\n<dt id="answer3">Returns & Replacements</dt>\r\n<dd style="margin-bottom:10px;">To be updated</dd>\r\n<dt id="answer4">Ordering</dt>\r\n<dd style="margin-bottom:10px;">To be updated</dd>\r\n<dt id="answer5">Payment, Pricing & Promotions</dt>\r\n<dd style="margin-bottom:10px;">To be updated</dd>\r\n<dt id="answer6">Viewing Orders</dt>\r\n<dd style="margin-bottom:10px;">To be updated</dd>\r\n<dt id="answer7">Updating Account Information</dt>\r\n<dd style="margin-bottom:10px;">To be updated</dd>\r\n</dl>' where page_id='4';


-- -------------------------------------------------------------

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

-- -------------------------------------------------------------

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

-- -------------------------------------------------------------


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

-- -------------------------------------------------------------


use reference;

--
-- Dumping data for table `ek_currency_conversion`
--

insert into ek_currency_conversion (`currency`, `conversion`) values ('USD', 50.0);

-- -------------------------------------------------------------------------------------

--
-- Dumping data for table `ek_discount_setting`
--

insert into ek_discount_setting (`info_source`, `discount_percent`) values ('Ingrams', 20);

-- -------------------------------------------------------------------------------------