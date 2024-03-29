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
-- Update the `cms_page` table with about-ekkitab & coustomer service
--


UPDATE `cms_page` set `identifier` = 'about-ekkitab' where page_id = '3';

UPDATE `cms_page` set `content` = '<div class="aboutUsArea"><div class="pageHeader">About ekkitab</div><div class="abtTextArea"><p>Ekkitab Educational Services Pvt. Ltd. was founded in 2009 and is headquartered in Bangalore, India.</p><p><em>Ekkitab is founded on the desire to promote reading. It is based on the belief that every child and adult in India should have access to good books irrespective of where they live and their level in society.</em></p><p>To achieve this objective, Ekkitab is putting up a globally accessible book store that carries English and all Indian language books. The immediate goal is to make this on-line bookstore very successful by virtue of good design, easy access and comprehensive stocking.</p><p>Ekkitab will<span class="boldFont"> actively promote organizations</span> that are centers of learning, like schools, colleges, city, town and village libraries, by inviting its visitors to donate to these organizations. The company wishes to encourage readership by making good books available easily and by making community reading centers like city and town libraries active and popular by virtue of having good content.</p><p>Ekkitab wants to<span class="boldFont"> create the largest donor network of books</span> in the country and thereby realize its vision of providing every Indian with access to good books. This donor network will be driven by goodwill, community and a sense of commitment to the cause that Ekkitab is working towards. We hope to solve the difficulties that exist today for people to share good books and promote reading.</p><p>In the process of achieving its vision, Ekkitab hopes to become the best known and best loved brand in bookshops, on-line or otherwise. We hope to be able to take the bookstore and the concept of on-line buying to smaller towns and villages across the country. Eventually, we hope to increase readership and the sheer size of the book business in India. We hope to be able to work with publishers and distributors in the country to help increase access to every book that is in print. This will help the publishing industry by extending their reach across the country and will help readers by decreasing the cost of books.</p><p>We hope to become an important channel for publishers to reach their customers and are willing to work with them to build new digital models of commerce that can provide conveniences that are not possible today. In making the business a success we hope to stimulate the donor network to give liberally to the cause of reading in India and to reduce the digital divide between the rich and the poor.</p><p>We also hope that by doing so, we can remove the bane of piracy from the industry and ensure that the benefits of each sale reaches its rightful owners. In the longer term, Ekkitab wants to promote good writers and provide a platform for publishers to promote new authors and their works. In everything, we want to support and nourish the book eco-system in the country by scaling it manifold across the Indian population.</p><p>Thank you for your interest.</p><div class="boldFont">Team Ekkitab</div></div><div class="excerptArea"><div class="boldFont">We hope that you have a pleasant experience at www.ekkitab.com and we count on your support of the cause.</div><p>You can reach us at: <a href="mailto:support@ekkitab.com">support@ekkitab.com</a></p><p>We are located at:<br />#82/83, Borewell Road,<br />Whitefield Main, <br />Bangalore - 560066.</p></div><div class="clear"></div></div><!-- aboutUsArea -->' where page_id = '3';

UPDATE `cms_page` set `content` = '<div class="page-head">\r\n<h3>Customer Service</h3>\r\n</div>\r\n<ul class="disc" style="margin-bottom:15px;">\r\n<li><a href="#answer1">Shipping & Delivery</a></li>\r\n<li><a href="#answer2">Privacy & Security</a></li>\r\n<li><a href="#answer3">Returns & Replacements</a></li>\r\n<li><a href="#answer4">Ordering</a></li>\r\n<li><a href="#answer5">Payment, Pricing & Promotions</a></li>\r\n<li><a href="#answer6">Viewing Orders</a></li>\r\n<li><a href="#answer7">Updating Account Information</a></li>\r\n</ul>\r\n<dl>\r\n<dt id="answer1">Shipping & Delivery</dt>\r\n<dd style="margin-bottom:10px;">To be updated.</dd>\r\n<dt id="answer2">Privacy & Security</dt>\r\n<dd style="margin-bottom:10px;"></dd>\r\n<dt id="answer3">Returns & Replacements</dt>\r\n<dd style="margin-bottom:10px;">To be updated</dd>\r\n<dt id="answer4">Ordering</dt>\r\n<dd style="margin-bottom:10px;">To be updated</dd>\r\n<dt id="answer5">Payment, Pricing & Promotions</dt>\r\n<dd style="margin-bottom:10px;">To be updated</dd>\r\n<dt id="answer6">Viewing Orders</dt>\r\n<dd style="margin-bottom:10px;">To be updated</dd>\r\n<dt id="answer7">Updating Account Information</dt>\r\n<dd style="margin-bottom:10px;">To be updated</dd>\r\n</dl>' where page_id='4';

UPDATE `cms_page` set `content` = '<div class="pageHeader">Our apologies...</div><p> <div class="boldFont">The page you requested was not found.</div><ul><li>If you typed the URL directly, please make sure that the spelling is correct.</li><li>If you clicked on a link to get here, the link might be outdated</li></ul></p>	<p><div class="boldFont">What can you do?</div>	Please contact Customer Care at <a href="mailto:support@ekkitab.com">support@ekkitab.com</a> and let us know of this problem. We appreciate your help in ensuring that the service is available and runs error free.<ul><li>Go <a href="javascript:history.back();">back to the previous page</a></li><li>Use the Search Facility at the top of the page to search the ekkitab web site</li><li>Click on any of the links below to get you back on track.<ul><li><a href="{{store url="home"}}">ekkitab Home Page</a></li><li><a href="{{store url="customer/account"}}">My Account</a> (You will have to Sign in or Register, if it's your first time)</li></ul></li></ul></p><div class="clear"></div></div><!-- notFoundArea -->' where page_id='1';

UPDATE `cms_page` set content = ' {{block type="page/html" name="donate_book_blurb_home"  template="page/html/donate_blurb_home.phtml" }}
{{block type="ekkitab_catalog/globalsection" name="homesection"  template="catalog/globalsection/home_page.phtml" }}', root_template='three_columns' where page_id =2;

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
('stores', 1, 'design/footer/copyright', '&copy; 2009 Ekkitab Educational Services Pvt Ltd. All Rights Reserved.'),
('default', 0, 'carriers/flatrate/free_shipping_subtotal', '250');
-- -------------------------------------------------------------

--
-- Dumping data for table `ek_catalog_popular_categories`
--

Delete from `ek_catalog_popular_categories`;

ALTER Table `ek_catalog_popular_categories`drop column url_path;

INSERT INTO `ek_catalog_popular_categories` (`id`, `category`, `order_no`, `is_active`,  `popularity`, `date`, `timestamp`) VALUES
(1, 'Fiction',1, 1, 15,'2009-11-19 16:20:53', '2009-11-19 16:20:56'),
(2, 'Comics & Graphic Novels', 2, 1, 11,'2009-11-19 14:18:57', '2009-11-19 14:18:57'),
(3, 'Religion', 3, 1, 13,'2009-11-19 16:19:28', '2009-11-19 16:19:46'),
(4, 'Juvenile Nonfiction', 4, 1, 15,'2009-11-19 16:20:31', '2009-11-19 16:20:56'),
(5, 'Business & Economics', 5, 1, 10,'2009-11-19 16:20:31', '2009-11-19 16:20:56'),
(6, 'Travel', 6, 1, 14,'2009-11-19 16:20:31', '2009-11-19 16:20:56'),
(7, 'Cooking', 7, 1, 11,'2009-11-19 16:20:31', '2009-11-19 16:20:56');

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
insert into ek_currency_conversion (`currency`, `conversion`) values ('INR', 1.0);

-- -------------------------------------------------------------------------------------

--
-- Dumping data for table `ek_discount_setting`
--

insert into ek_discount_setting (`info_source`, `discount_percent`) values ('Ingrams', 20);
insert into ek_discount_setting (`info_source`, `discount_percent`) values ('1ktestdata', 30);

use ekkitab_books;
--
-- Dumping data for table `core_config_data`
--	

INSERT INTO `core_config_data` (`config_id`, `scope`, `scope_id`, `path`, `value`) VALUES
(43, 'default', 0, 'general/country/default', 'IN'),
(44, 'default', 0, 'general/country/allow', 'AF,AL,DZ,AS,AD,AO,AI,AQ,AG,AR,AM,AW,AU,AT,AZ,BS,BH,BD,BB,BY,BE,BZ,BJ,BM,BT,BO,BA,BW,BV,BR,IO,VG,BN,BG,BF,BI,KH,CM,CA,CV,KY,CF,TD,CL,CN,CX,CC,CO,KM,CG,CK,CR,HR,CU,CY,CZ,DK,DJ,DM,DO,EC,EG,SV,GQ,ER,EE,ET,FK,FO,FJ,FI,FR,GF,PF,TF,GA,GM,GE,DE,GH,GI,GR,GL,GD,GP,GU,GT,GN,GW,GY,HT,HM,HN,HK,HU,IS,IN,ID,IR,IQ,IE,IL,IT,CI,JM,JP,JO,KZ,KE,KI,KW,KG,LA,LV,LB,LS,LR,LY,LI,LT,LU,MO,MK,MG,MW,MY,MV,ML,MT,MH,MQ,MR,MU,YT,FX,MX,FM,MD,MC,MN,MS,MA,MZ,MM,NA,NR,NP,NL,AN,NC,NZ,NI,NE,NG,NU,NF,KP,MP,NO,OM,PK,PW,PA,PG,PY,PE,PH,PN,PL,PT,PR,QA,RE,RO,RU,RW,SH,KN,LC,PM,VC,WS,SM,ST,SA,SN,SC,SL,SG,SK,SI,SB,SO,ZA,GS,KR,ES,LK,SD,SR,SJ,SZ,SE,CH,SY,TW,TJ,TZ,TH,TG,TK,TO,TT,TN,TR,TM,TC,TV,VI,UG,UA,AE,GB,US,UM,UY,UZ,VU,VA,VE,VN,WF,EH,YE,ZM,ZW'),
(45, 'default', 0, 'general/locale/timezone', 'Asia/Calcutta'),
(46, 'default', 0, 'general/locale/code', 'en_US'),
(47, 'default', 0, 'general/locale/firstday', '0'),
(48, 'default', 0, 'general/locale/weekend', '0,6'),
(49, 'default', 0, 'currency/options/default', 'INR'),
(50, 'default', 0, 'currency/options/allow', 'EUR,INR,USD'),
(51, 'default', 0, 'currency/options/trim_sign', '0'),
(53, 'default', 0, 'currency/import/enabled', '0'),
(61, 'default', 0, 'trans_email/ident_general/name', 'Admin'),
(62, 'default', 0, 'trans_email/ident_general/email', 'admin@ekkitab.com'),
(63, 'default', 0, 'trans_email/ident_sales/name', 'Sales'),
(64, 'default', 0, 'trans_email/ident_sales/email', 'sales@ekkitab.com'),
(65, 'default', 0, 'trans_email/ident_support/name', 'CustomerSupport'),
(66, 'default', 0, 'trans_email/ident_support/email', 'support@ekkitab.com'),
(67, 'default', 0, 'trans_email/ident_custom1/name', 'Custom 1'),
(68, 'default', 0, 'trans_email/ident_custom1/email', 'custom1@ekkitab.com'),
(69, 'default', 0, 'trans_email/ident_custom2/name', 'Custom 2'),
(70, 'default', 0, 'trans_email/ident_custom2/email', 'custom2@ekkitab.com'),
(71, 'default', 0, 'contacts/contacts/enabled', '1'),
(72, 'default', 0, 'contacts/email/recipient_email', 'support@ekkitab.com'),
(73, 'default', 0, 'contacts/email/sender_email_identity', 'support'),
(74, 'default', 0, 'contacts/email/email_template', 'contacts_email_email_template'),
(75, 'stores', 1, 'sitemap/category/changefreq', 'never'),
(76, 'stores', 1, 'sitemap/product/changefreq', 'never'),
(77, 'stores', 1, 'sitemap/page/changefreq', 'never'),
(78, 'default', 0, 'tax/classes/shipping_tax_class', '0'),
(79, 'default', 0, 'tax/calculation/based_on', 'shipping'),
(80, 'default', 0, 'tax/calculation/price_includes_tax', '0'),
(81, 'default', 0, 'tax/calculation/shipping_includes_tax', '0'),
(82, 'default', 0, 'tax/calculation/apply_after_discount', '0'),
(83, 'default', 0, 'tax/calculation/discount_tax', '0'),
(84, 'default', 0, 'tax/calculation/apply_tax_on', '0'),
(85, 'default', 0, 'tax/defaults/country', 'IN'),
(86, 'default', 0, 'tax/defaults/region', '0'),
(87, 'default', 0, 'tax/defaults/postcode', '*'),
(88, 'default', 0, 'tax/display/column_in_summary', '1'),
(89, 'default', 0, 'tax/display/full_summary', '0'),
(90, 'default', 0, 'tax/display/shipping', '1'),
(91, 'default', 0, 'tax/display/type', '1'),
(92, 'default', 0, 'tax/display/zero_tax', '0'),
(93, 'default', 0, 'tax/weee/enable', '0'),
(112, 'default', 0, 'carriers/tablerate/active', '0'),
(122, 'default', 0, 'carriers/freeshipping/active', '1'),
(123, 'default', 0, 'carriers/freeshipping/title', 'Free Shipping'),
(124, 'default', 0, 'carriers/freeshipping/name', 'Free'),
(125, 'default', 0, 'carriers/freeshipping/free_shipping_subtotal', ''),
(126, 'default', 0, 'carriers/freeshipping/specificerrmsg', 'This shipping method is currently unavailable. If you would like to ship using this shipping method, please contact us.'),
(127, 'default', 0, 'carriers/freeshipping/sallowspecific', '0'),
(128, 'default', 0, 'carriers/freeshipping/showmethod', '0'),
(129, 'default', 0, 'carriers/freeshipping/sort_order', ''),
(196, 'default', 0, 'carriers/dhl/active', '0'),
(231, 'default', 0, 'payment/ccsave/active', '0'),
(240, 'default', 0, 'payment/free/title', 'No Payment Information Required'),
(241, 'default', 0, 'payment/free/active', '0'),
(246, 'default', 0, 'payment/checkmo/active', '1'),
(247, 'default', 0, 'payment/checkmo/title', 'Check / Money order'),
(248, 'default', 0, 'payment/checkmo/order_status', 'pending'),
(249, 'default', 0, 'payment/checkmo/allowspecific', '1'),
(250, 'default', 0, 'payment/checkmo/payable_to', 'Ekkitab Eductional Services Pvt Ltd'),
(251, 'default', 0, 'payment/checkmo/mailing_address', '#82/83, Borewell Road, Whitefield Main, Bangalore - 560066'),
(254, 'default', 0, 'payment/checkmo/sort_order', ''),
(255, 'default', 0, 'payment/purchaseorder/active', '0'),
(262, 'default', 0, 'payment/authorizenet/active', '0'),
(279, 'default', 0, 'payment/verisign/active', '0'),
(301, 'default', 0, 'payment/paypal_express/active', '0'),
(307, 'default', 0, 'payment/paypal_direct/active', '0'),
(314, 'default', 0, 'payment/billdesk/active', '0'),
(326, 'default', 0, 'payment/paypaluk_direct/active', '0'),
(350, 'default', 0, 'payment/amazonpayments_cba/active', '0'),
(365, 'default', 0, 'payment/checkmo/specificcountry', 'IN'),
(366, 'default', 0, 'advancedsmtp/settings/enabled', '1'),
(367, 'default', 0, 'advancedsmtp/settings/auth', 'login'),
(368, 'default', 0, 'advancedsmtp/settings/username', 'arun@ekkitab.com'),
(369, 'default', 0, 'advancedsmtp/settings/password', 'bookstore'),
(370, 'default', 0, 'advancedsmtp/settings/host', 'smtpout.secureserver.net'),
(371, 'default', 0, 'advancedsmtp/settings/port', '25'),
(372, 'default', 0, 'advancedsmtp/settings/ssl', '0'),
(373, 'default', 0, 'cataloginventory/options/can_back_in_stock', '0'),
(374, 'default', 0, 'cataloginventory/options/can_subtract', '0'),
(375, 'default', 0, 'cataloginventory/item_options/manage_stock', '0'),
(376, 'default', 0, 'cataloginventory/item_options/backorders', '0'),
(377, 'default', 0, 'cataloginventory/item_options/max_sale_qty', '10000'),
(378, 'default', 0, 'cataloginventory/item_options/min_qty', '0'),
(379, 'default', 0, 'cataloginventory/item_options/min_sale_qty', '1'),
(380, 'default', 0, 'cataloginventory/item_options/notify_stock_qty', '1'),
(381, 'default', 0, 'sitemap/category/changefreq', 'never'),
(383, 'default', 0, 'sitemap/product/changefreq', 'never'),
(385, 'default', 0, 'sitemap/page/changefreq', 'never'),
(387, 'default', 0, 'sitemap/generate/enabled', '0'),
(389, 'default', 0, 'sitemap/generate/frequency', 'D'),
(390, 'default', 0, 'crontab/jobs/sitemap_generate/schedule/cron_expr', '0 0 * * *'),
(391, 'default', 0, 'crontab/jobs/sitemap_generate/run/model', 'sitemap/observer::scheduledGenerateSitemaps'),
(395, 'default', 0, 'sales_email/order/enabled', '1'),
(396, 'default', 0, 'sales_email/order/identity', 'sales'),
(397, 'default', 0, 'sales_email/order/template', 'sales_email_order_template'),
(398, 'default', 0, 'sales_email/order/guest_template', 'sales_email_order_guest_template'),
(399, 'default', 0, 'sales_email/order/copy_to', 'saran@ekkitab.com'),
(400, 'default', 0, 'sales_email/order/copy_method', 'bcc'),
(401, 'default', 0, 'sales_email/order_comment/enabled', '1'),
(402, 'default', 0, 'sales_email/order_comment/identity', 'sales'),
(403, 'default', 0, 'sales_email/order_comment/template', 'sales_email_order_comment_template'),
(404, 'default', 0, 'sales_email/order_comment/guest_template', 'sales_email_order_comment_guest_template'),
(405, 'default', 0, 'sales_email/order_comment/copy_to', ''),
(406, 'default', 0, 'sales_email/order_comment/copy_method', 'bcc'),
(407, 'default', 0, 'sales_email/invoice/enabled', '1'),
(408, 'default', 0, 'sales_email/invoice/identity', 'sales'),
(409, 'default', 0, 'sales_email/invoice/template', 'sales_email_invoice_template'),
(410, 'default', 0, 'sales_email/invoice/guest_template', 'sales_email_invoice_guest_template'),
(411, 'default', 0, 'sales_email/invoice/copy_to', 'saran@ekkitab.com'),
(412, 'default', 0, 'sales_email/invoice/copy_method', 'bcc'),
(413, 'default', 0, 'sales_email/invoice_comment/enabled', '1'),
(414, 'default', 0, 'sales_email/invoice_comment/identity', 'sales'),
(415, 'default', 0, 'sales_email/invoice_comment/template', 'sales_email_invoice_comment_template'),
(416, 'default', 0, 'sales_email/invoice_comment/guest_template', 'sales_email_invoice_comment_guest_template'),
(417, 'default', 0, 'sales_email/invoice_comment/copy_to', ''),
(418, 'default', 0, 'sales_email/invoice_comment/copy_method', 'bcc'),
(419, 'default', 0, 'sales_email/shipment/enabled', '1'),
(420, 'default', 0, 'sales_email/shipment/identity', 'sales'),
(421, 'default', 0, 'sales_email/shipment/template', 'sales_email_shipment_template'),
(422, 'default', 0, 'sales_email/shipment/guest_template', 'sales_email_shipment_guest_template'),
(423, 'default', 0, 'sales_email/shipment/copy_to', 'saran@ekkitab.com'),
(424, 'default', 0, 'sales_email/shipment/copy_method', 'bcc'),
(425, 'default', 0, 'sales_email/shipment_comment/enabled', '1'),
(426, 'default', 0, 'sales_email/shipment_comment/identity', 'sales'),
(427, 'default', 0, 'sales_email/shipment_comment/template', 'sales_email_shipment_comment_template'),
(428, 'default', 0, 'sales_email/shipment_comment/guest_template', 'sales_email_shipment_comment_guest_template'),
(429, 'default', 0, 'sales_email/shipment_comment/copy_to', ''),
(430, 'default', 0, 'sales_email/shipment_comment/copy_method', 'bcc'),
(431, 'default', 0, 'sales_email/creditmemo/enabled', '1'),
(432, 'default', 0, 'sales_email/creditmemo/identity', 'sales'),
(433, 'default', 0, 'sales_email/creditmemo/template', 'sales_email_creditmemo_template'),
(434, 'default', 0, 'sales_email/creditmemo/guest_template', 'sales_email_creditmemo_guest_template'),
(435, 'default', 0, 'sales_email/creditmemo/copy_to', 'saran@ekkitab.com'),
(436, 'default', 0, 'sales_email/creditmemo/copy_method', 'bcc'),
(437, 'default', 0, 'sales_email/creditmemo_comment/enabled', '1'),
(438, 'default', 0, 'sales_email/creditmemo_comment/identity', 'sales'),
(439, 'default', 0, 'sales_email/creditmemo_comment/template', 'sales_email_creditmemo_comment_template'),
(440, 'default', 0, 'sales_email/creditmemo_comment/guest_template', 'sales_email_creditmemo_comment_guest_template'),
(441, 'default', 0, 'sales_email/creditmemo_comment/copy_to', ''),
(442, 'default', 0, 'sales_email/creditmemo_comment/copy_method', 'bcc'),
(443, 'default', 0, 'shipping/origin/country_id', 'IN'),
(444, 'default', 0, 'shipping/origin/region_id', 'Karnataka'),
(445, 'default', 0, 'shipping/origin/postcode', ''),
(446, 'default', 0, 'shipping/origin/city', 'Bangalore'),
(447, 'default', 0, 'shipping/option/checkout_multiple', '1'),
(448, 'default', 0, 'shipping/option/checkout_multiple_maximum_qty', '100'),
(449, 'default', 0, 'carriers/flatrate/active', '0'),
(469, 'default', 0, 'carriers/ups/active', '0'),
(516, 'default', 0, 'carriers/fedex/active', '0'),
(615, 'default', 0, 'carriers/usps/active', '0'),
(686, 'default', 0, 'payment/ccav/active', '1'),
(687, 'default', 0, 'payment/ccav/title', 'Master / Visa Card'),
(688, 'default', 0, 'payment/ccav/payment_action', 'AUTHORIZATION'),
(689, 'default', 0, 'payment/ccav/order_status', 'processing'),
(690, 'default', 0, 'payment/ccav/transaction_type', 'O'),
(691, 'default', 0, 'payment/ccav/sort_order', ''),
(740, 'default', 0, 'ccav/wps/checksum_key', 'kvppt13q4lwbo4g90y'),
(741, 'default', 0, 'ccav/wps/merchant_url', 'https://www.ccavenue.com/shopzone/cc_details.jsp'),
(742, 'default', 0, 'ccav/wps/return_url', 'http://localhost/scm/magento/ccav/standard/ccavresponse'),
(743, 'default', 0, 'ccav/wps/merchant_id', 'M_singhak_11811'),
(744, 'default', 0, 'ccav/wps/logo_url', ''),
(745, 'default', 0, 'ccav/wps/sandbox_flag', '0'),
(746, 'default', 0, 'ccav/wps/debug_flag', '0'),
(823, 'default', 0, 'payment/billdesk/title', 'Master / Visa Billdesk'),
(824, 'default', 0, 'payment/billdesk/payment_action', 'AUTHORIZATION'),
(825, 'default', 0, 'payment/billdesk/order_status', 'processing'),
(826, 'default', 0, 'payment/billdesk/transaction_type', 'O'),
(827, 'default', 0, 'payment/billdesk/sort_order', ''),
(888, 'default', 0, 'billdesk/wps/checksum_key', 'pWUb4i1oTLCs'),
(889, 'default', 0, 'billdesk/wps/merchant_url', 'https://www.billdesk.com/pgidsk/pgmerc/EKKITABPay.jsp'),
(890, 'default', 0, 'billdesk/wps/return_url', 'http://ekkitab.co.in/scm/magento/billdesk/standard/ccavresponse'),
(891, 'default', 0, 'billdesk/wps/merchant_id', ''),
(892, 'default', 0, 'billdesk/wps/logo_url', ''),
(893, 'default', 0, 'billdesk/wps/sandbox_flag', '0'),
(894, 'default', 0, 'billdesk/wps/debug_flag', '0'),
(482, 'default', 0, 'sales/reorder/allow', '0');


--
-- Dumping data for table `core_config_data`
-- Note that the following inserts differ in syntax....


INSERT INTO `core_config_data` (`scope`, `scope_id`, `path`, `value`) VALUES
( 'stores', 1, 'catalog/placeholder/image_placeholder', 'stores/1/image.png'),
( 'stores', 1, 'catalog/placeholder/small_image_placeholder', 'stores/1/small_image.png');

--
-- Dumping data for table `ek_catalog_global_sections`

Delete from `ek_catalog_global_sections`;

INSERT INTO `ek_catalog_global_sections` (  `section_id` ,`display_name`, `description` , `active_from_date`,  `active_to_date`,`template_path`,`is_homepage_display`) VALUES
( 1, 'Best Sellers', '','2010-03-01','2011-03-31','','0'),
( 2, 'New Releases', '','2010-03-01','2011-03-31','','0'),
( 3, 'Great Bargains', '','2010-03-01','2011-03-31','','1'),
( 4, 'Best Boxed Sets', '','2010-03-01','2011-03-31','','0'),
( 5, 'Top Children''s Books', '','2010-03-01','2011-03-31','','0'),
( 6, 'Top Books of the Month', '','2010-03-01','2011-03-31','','0');

--
-- Dumping data for table `ek_catalog_global_section_products`

Delete from `ek_catalog_global_section_products`;

INSERT INTO `ek_catalog_global_section_products` (`section_id`, `product_id`) VALUES
(1, 1),
(1,23),
(1,4),
(1,56),
(1,90),
(1,79),
(1,58);

INSERT INTO `ek_catalog_global_section_products` (`section_id`, `product_id`) VALUES
(2, 125),
(2,47),
(2,35),
(2,26),
(2,54),
(2,9),
(2,4);

INSERT INTO `ek_catalog_global_section_products` (`section_id`, `product_id`) VALUES
(3, 451),
(3,243),
(3,46),
(3,576),
(3,940),
(3,769),
(3,598);

INSERT INTO `ek_catalog_global_section_products` (`section_id`, `product_id`) VALUES
(4,25),
(4,427),
(4,355),
(4,2096),
(4,554),
(4,934),
(4,4545);

INSERT INTO `ek_catalog_global_section_products` (`section_id`, `product_id`) VALUES
(5,6561),
(5,2653),
(5,4755),
(5,5675),
(5,9034),
(5,7349),
(5,528);

INSERT INTO `ek_catalog_global_section_products` (`section_id`, `product_id`) VALUES
(6,6725),
(6,4734),
(6,3523),
(6,265),
(6,5453),
(6,923),
(6,443);


UPDATE `cms_page` set content = ' {{block type="page/html" name="donate_book_blurb_home"  template="page/html/donate_blurb_home.phtml" }}
{{block type="ekkitab_catalog/globalsection" name="homesection"  template="catalog/globalsection/home_page.phtml" }}'  where page_id =2;
