use `ekkitab_books`;

--
-- Table structure for table `ek_catalog_product_bestsellers`
--

CREATE TABLE IF NOT EXISTS `ek_catalog_product_bestsellers` (
  `product_id`  int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `author` varchar(250) NOT NULL,
  `image_url` varchar(250) NOT NULL,
  `price` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `is_active` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `order_no`  int(11) NOT NULL,
  `date` datetime DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`product_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ;

--
-- Table structure for table `ek_catalog_product_newreleases`
--

CREATE TABLE IF NOT EXISTS `ek_catalog_product_newreleases` (
  `product_id`  int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `author` varchar(250) NOT NULL,
  `image_url` varchar(250) NOT NULL,
  `price` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `is_active` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `order_no`  int(11) NOT NULL,
  `date` datetime DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`product_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ;


--
-- Table structure for table `ek_catalog_product_best_boxedsets`
--

CREATE TABLE IF NOT EXISTS `ek_catalog_product_best_boxedsets` (
  `product_id`  int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `author` varchar(250) NOT NULL,
  `image_url` varchar(250) NOT NULL,
  `price` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `is_active` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `order_no`  int(11) NOT NULL,
  `date` datetime DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`product_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ;
UPDATE `cms_page` set `identifier` = 'about-ekkitab' where page_id = '3';
UPDATE `cms_block` set `content` = '<ul>\r\n<li><a href="{{store url=""}}about-ekkitab">About Us</a></li>\r\n<li class="last"><a href="{{store url=""}}customer-service">Customer Service</a></li>\r\n</ul>' where block_id = '5';
UPDATE `cms_page` set `content` = '<br class="clear"/><div class="col3-set"><div class="col-1"><p><img src="{{skin url=''images/logo_aboutus.png''}}" alt="Ekkitab Logo"/></p><p style="line-height:1.2em;"><small>Ekkitab Educational Services Pvt. Ltd. was founded in 2009 and is headquartered in Bangalore, India. </small></p><p style="color:#888; font:1.2em/1.4em georgia, serif;">Ekkitab is founded on the desire to promote reading.  It is based on the belief that every child and adult in India should have access to good books irrespective of where they live and their level in society.</p><p><strong>To achieve this objective, Ekkitab is putting up a globally accessible book store that carries English and all Indian language books.  The immediate goal is to make this on-line bookstore very successful by virtue of good design, easy access and comprehensive stocking.</strong></p></div><div class="col-2"><p>Ekkitab will actively promote organizations that are centers of learning, like school, college, city, town and village libraries, by inviting its visitors to donate to these organizations. The company wishes to encourage readership by making good books available easily and by making community reading centers like city and town libraries active and popular by virtue of having good content.</p><p>Ekkitab wants to create the largest donor network in books in the country and thereby realize its vision of providing every Indian with access to good books. This donor network will be driven by goodwill, community and a sense of commitment to the cause that Ekkitab is working towards. We hope to solve the difficulties that exist today for people to share good books and promote reading.</p><p>In the process of achieving its vision, Ekkitab hopes to become the best known and best loved brand in bookshops, on-line or otherwise.  We hope to be able to take the bookstore and the concept of on-line buying to smaller towns and villages across the country.  Eventually, we hope to increase readership and the sheer size of the book business in India. We hope to be able to work with publishers and distributors in the country to help increase access to every book that is in print. This will help the publishing industry by extending their reach across the country and will help readers by decreasing the cost of books.</p></div><div class="col-3"><p><strong>We hope to become an important channel for publishers to reach their customers and are willing to work with them to build new digital models of commerce that can provide conveniences that are not possible today. In making the business a success we hope to stimulate the donor network to give liberally to the cause of reading in India and to reduce the digital divide between the rich and the poor.</strong></p><p>We also hope that by doing so, we can remove the bane of piracy from the industry and ensure that the benefits of each sale reaches its rightful owners.  In the longer term, Ekkitab wants to promote good writers and provide a platform for publishers to promote new authors and their works.  In everything, we want to support and nourish the book eco-system in the country by scaling it manifold across the Indian population.</p><div class="divider"></div><p>Thank you for your interest. </p><p>We hope that you have a pleasant experience at ekkitab.com and we count on your support of the cause. <br/><br/>You can reach us at: ccare@ekkitab.com. <br/><br/>We are located at: #82/83, Borewell Road, Whitefield Main, Bangalore - 560066.</p><p style="line-height:1.0em;"><br/><small>Team Ekkitab</small></p></div></div>' where page_id = '3';
UPDATE `cms_page` set `content` = '<div class="page-head">\r\n<h3>Customer Service</h3>\r\n</div>\r\n<ul class="disc" style="margin-bottom:15px;">\r\n<li><a href="#answer1">Shipping & Delivery</a></li>\r\n<li><a href="#answer2">Privacy & Security</a></li>\r\n<li><a href="#answer3">Returns & Replacements</a></li>\r\n<li><a href="#answer4">Ordering</a></li>\r\n<li><a href="#answer5">Payment, Pricing & Promotions</a></li>\r\n<li><a href="#answer6">Viewing Orders</a></li>\r\n<li><a href="#answer7">Updating Account Information</a></li>\r\n</ul>\r\n<dl>\r\n<dt id="answer1">Shipping & Delivery</dt>\r\n<dd style="margin-bottom:10px;">To be updated.</dd>\r\n<dt id="answer2">Privacy & Security</dt>\r\n<dd style="margin-bottom:10px;"></dd>\r\n<dt id="answer3">Returns & Replacements</dt>\r\n<dd style="margin-bottom:10px;">To be updated</dd>\r\n<dt id="answer4">Ordering</dt>\r\n<dd style="margin-bottom:10px;">To be updated</dd>\r\n<dt id="answer5">Payment, Pricing & Promotions</dt>\r\n<dd style="margin-bottom:10px;">To be updated</dd>\r\n<dt id="answer6">Viewing Orders</dt>\r\n<dd style="margin-bottom:10px;">To be updated</dd>\r\n<dt id="answer7">Updating Account Information</dt>\r\n<dd style="margin-bottom:10px;">To be updated</dd>\r\n</dl>' where page_id='4';
UPDATE `cms_page` set content = '<div class="page-head-alt"><h3>Our apologies... </h3></div>\r\n<dl>\r\n<dt>The page you requested was not found.</dt>\r\n<dd>\r\n<ul class="disc">\r\n<li>If you typed the URL directly, please make sure the spelling is correct.</li>\r\n<li>If you clicked on a link to get here, the link is outdated.</li>\r\n</ul></dd>\r\n</dl>\r\n<br/>\r\n<dl>\r\n<dt>What can you do?</dt>\r\n<dd>Please contact Customer Care at ccare@ekkitab.com and let us know of this problem. We appreciate your help in ensuring that the service is always available and runs error free.</dd>\r\n<dd>\r\n<ul class="disc">\r\n<li><a href="#" onclick="history.go(-1);">Go back</a> to the previous page.</li>\r\n<li>Use the search bar at the top of the page to search the site.</li>\r\n<li>Follow these links to get you back on track!<br/><a href="{{store url=""}}">Store Home</a><br/><a href="{{store url="customer/account"}}">My Account</a></li></ul></dd></dl><br/>' where page_id='1';
