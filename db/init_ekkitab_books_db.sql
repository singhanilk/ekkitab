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
-- @author Anisha (anisha@ekkitab.com)
-- @version 1.0     Jan 28, 2010
-- @version 2.0     Apr 5, 2010




use `ekkitab_books`;

--
-- Dumping data for table `cms_page`
--

Delete from `cms_page`;

INSERT INTO `cms_page` (`page_id`, `title`, `root_template`, `meta_keywords`, `meta_description`, `identifier`, `content`, `creation_time`, `update_time`, `is_active`, `sort_order`, `layout_update_xml`, `custom_theme`, `custom_theme_from`, `custom_theme_to`) VALUES
(1, '404 Page Not Found', 'one_column', '', '', 'no-route', '<!-- notFoundArea -->{{block type="page/html" name="page_not_found"  template="page/html/404.phtml" }}', '2007-06-20 18:38:32', '2007-08-26 19:11:13', 1, 0, NULL, NULL, NULL, NULL),

(2, 'Home page', 'three_columns', '', '', 'home', '{{block type="page/html" name="donate_book_blurb_home"  template="page/html/donate_blurb_home.phtml" }}
{{block type="ekkitab_catalog/globalsection" name="globalsection_home" template="catalog/globalsection/home_page.phtml" }}', '', '', 1, 0, NULL, NULL,NULL,NULL),

(3, 'About  Us', 'one_column', '', '', 'about-ekkitab', '<!-- aboutUsArea -->{{block type="page/html" name="about_us"  template="page/html/about_us.phtml" }}', '2007-08-30 14:01:18', '2007-08-30 14:01:18', 1, 0, NULL, NULL, NULL, NULL),

(4, 'Help', 'one_column', '', '', 'help', '{{block type="page/html" name="help"  template="page/html/help.phtml" }}', '2007-08-30 14:02:20', '2007-08-30 14:03:37', 1, 0, NULL, NULL, NULL, NULL),

(5, 'Enable Cookies', 'one_column', '', '', 'enable-cookies', '<div class="std">\r\n    <ul class="messages">\r\n        <li class="notice-msg">\r\n            <ul>\r\n                <li>Please enable cookies in your web browser to continue.</li>\r\n            </ul>\r\n        </li>\r\n    </ul>\r\n    <div class="page-head">\r\n        <h3><a name="top"></a>What are Cookies?</h3>\r\n    </div>\r\n    <p>Cookies are short pieces of data that are sent to your computer when you visit a website. On later visits, this data is then returned to that website. Cookies allow us to recognize you automatically whenever you visit our site so that we can personalize your experience and provide you with better service. We also use cookies (and similar browser data, such as Flash cookies) for fraud prevention and other purposes. If your web browser is set to refuse cookies from our website, you will not be able to complete a purchase or take advantage of certain features of our website, such as storing items in your Shopping Cart or receiving personalized recommendations. As a result, we strongly encourage you to configure your web browser to accept cookies from our website.</p>\r\n    <h3>Enabling Cookies</h3>\r\n    <ul>\r\n        <li><a href="#ie7">Internet Explorer 7.x</a></li>\r\n        <li><a href="#ie6">Internet Explorer 6.x</a></li>\r\n        <li><a href="#firefox">Mozilla/Firefox</a></li>\r\n        <li><a href="#opera">Opera 7.x</a></li>\r\n    </ul>\r\n    <h4><a name="ie7"></a>Internet Explorer 7.x</h4>\r\n    <ol>\r\n        <li>\r\n            <p>Start Internet Explorer</p>\r\n        </li>\r\n        <li>\r\n            <p>Under the <strong>Tools</strong> menu, click <strong>Internet Options</strong></p>\r\n            <p><img src="{{skin url="images/cookies/ie7-1.gif"}}" alt="" /></p>\r\n        </li>\r\n        <li>\r\n            <p>Click the <strong>Privacy</strong> tab</p>\r\n            <p><img src="{{skin url="images/cookies/ie7-2.gif"}}" alt="" /></p>\r\n        </li>\r\n        <li>\r\n            <p>Click the <strong>Advanced</strong> button</p>\r\n            <p><img src="{{skin url="images/cookies/ie7-3.gif"}}" alt="" /></p>\r\n        </li>\r\n        <li>\r\n            <p>Put a check mark in the box for <strong>Override Automatic Cookie Handling</strong>, put another check mark in the <strong>Always accept session cookies </strong>box</p>\r\n            <p><img src="{{skin url="images/cookies/ie7-4.gif"}}" alt="" /></p>\r\n        </li>\r\n        <li>\r\n            <p>Click <strong>OK</strong></p>\r\n            <p><img src="{{skin url="images/cookies/ie7-5.gif"}}" alt="" /></p>\r\n        </li>\r\n        <li>\r\n            <p>Click <strong>OK</strong></p>\r\n            <p><img src="{{skin url="images/cookies/ie7-6.gif"}}" alt="" /></p>\r\n        </li>\r\n        <li>\r\n            <p>Restart Internet Explore</p>\r\n        </li>\r\n    </ol>\r\n    <p class="a-top"><a href="#top">Back to Top</a></p>\r\n    <h4><a name="ie6"></a>Internet Explorer 6.x</h4>\r\n    <ol>\r\n        <li>\r\n            <p>Select <strong>Internet Options</strong> from the Tools menu</p>\r\n            <p><img src="{{skin url="images/cookies/ie6-1.gif"}}" alt="" /></p>\r\n        </li>\r\n        <li>\r\n            <p>Click on the <strong>Privacy</strong> tab</p>\r\n        </li>\r\n        <li>\r\n            <p>Click the <strong>Default</strong> button (or manually slide the bar down to <strong>Medium</strong>) under <strong>Settings</strong>. Click <strong>OK</strong></p>\r\n            <p><img src="{{skin url="images/cookies/ie6-2.gif"}}" alt="" /></p>\r\n        </li>\r\n    </ol>\r\n    <p class="a-top"><a href="#top">Back to Top</a></p>\r\n    <h4><a name="firefox"></a>Mozilla/Firefox</h4>\r\n    <ol>\r\n        <li>\r\n            <p>Click on the <strong>Tools</strong>-menu in Mozilla</p>\r\n        </li>\r\n        <li>\r\n            <p>Click on the <strong>Options...</strong> item in the menu - a new window open</p>\r\n        </li>\r\n        <li>\r\n            <p>Click on the <strong>Privacy</strong> selection in the left part of the window. (See image below)</p>\r\n            <p><img src="{{skin url="images/cookies/firefox.png"}}" alt="" /></p>\r\n        </li>\r\n        <li>\r\n            <p>Expand the <strong>Cookies</strong> section</p>\r\n        </li>\r\n        <li>\r\n            <p>Check the <strong>Enable cookies</strong> and <strong>Accept cookies normally</strong> checkboxes</p>\r\n        </li>\r\n        <li>\r\n            <p>Save changes by clicking <strong>Ok</strong>.</p>\r\n        </li>\r\n    </ol>\r\n    <p class="a-top"><a href="#top">Back to Top</a></p>\r\n    <h4><a name="opera"></a>Opera 7.x</h4>\r\n    <ol>\r\n        <li>\r\n            <p>Click on the <strong>Tools</strong> menu in Opera</p>\r\n        </li>\r\n        <li>\r\n            <p>Click on the <strong>Preferences...</strong> item in the menu - a new window open</p>\r\n        </li>\r\n        <li>\r\n            <p>Click on the <strong>Privacy</strong> selection near the bottom left of the window. (See image below)</p>\r\n            <p><img src="{{skin url="images/cookies/opera.png"}}" alt="" /></p>\r\n        </li>\r\n        <li>\r\n            <p>The <strong>Enable cookies</strong> checkbox must be checked, and <strong>Accept all cookies</strong> should be selected in the &quot;<strong>Normal cookies</strong>&quot; drop-down</p>\r\n        </li>\r\n        <li>\r\n            <p>Save changes by clicking <strong>Ok</strong></p>\r\n        </li>\r\n    </ol>\r\n    <p class="a-top"><a href="#top">Back to Top</a></p>\r\n</div>\r\n', '2009-10-15 09:35:23', '2009-10-15 09:35:23', 1, 0, NULL, NULL, NULL, NULL),

(6, 'Privacy Policy', 'one_column', '', '', 'privacy-policy', '{{block type="page/html" name="privacy"  template="page/html/help.phtml" }}', '2009-10-15 09:35:23', '2009-10-15 09:35:23', 1, 0, NULL, NULL, NULL, NULL),

(7, 'Terms and Conditions', 'one_column', '', '', 'terms', '{{block type="page/html" name="terms"  template="page/html/help.phtml" }}', '2009-10-15 09:35:23', '2009-10-15 09:35:23', 1, 0, NULL, NULL, NULL, NULL);

--
-- Update the `cms_page` table with about-ekkitab & coustomer service
--
--
-- Dumping data for table `cms_page_store`
--

Delete from `cms_page_store`;

INSERT INTO `cms_page_store` (`page_id`, `store_id`) VALUES
(1, 0),
(2, 0),
(3, 0),
(4, 0),
(5, 0),
(6, 0),
(7, 0);


-- -------------------------------------------------------------

--
-- Dumping data for table `ek_catalog_popular_categories`
--

Delete from `ek_catalog_popular_categories`;

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

--
-- Dumping data for table `core_config_data`
--

INSERT INTO `core_config_data` (`scope`, `scope_id`, `path`, `value`) VALUES
( 'default', 0, 'catalog/category/root_id', '2'),
('default', 0, 'design/theme/default', 'ekkitab'),
('default', 0, 'design/head/default_title', 'Ekkitab Education Services Pvt Ltd'),
('default', 0, 'design/head/default_keywords', 'Ekkitab, online bookstore'),
('default', 0, 'design/header/logo_src', 'images/logo.png'),
('default', 0, 'design/header/logo_alt', 'Ekkitab Education Services Pvt Ltd'),
('default', 0, 'design/header/welcome', ''),
('default', 0, 'design/footer/copyright', '&copy; 2009 Ekkitab Educational Services Pvt Ltd. All Rights Reserved.'),
('default', 0, 'dev/log/active', '1'),
('default', 0, 'dev/log/file', 'system.log'),
('default', 0, 'dev/log/exception_file', 'exception.log'),
('default', 0, 'dev/js/merge_files', 0),
('default', 0, 'currency/options/base', 'INR'),
('default', 0, 'currency/options/default', 'INR'),
('default', 0, 'currency/options/allow', 'EUR,INR,USD'),
('default', 0, 'currency/options/trim_sign', '0'),
('default', 0, 'currency/import/enabled', '0'),
('default', 0, 'general/country/default', 'IN'),
('default', 0, 'general/country/allow', 'AF,AL,DZ,AS,AD,AO,AI,AQ,AG,AR,AM,AW,AU,AT,AZ,BS,BH,BD,BB,BY,BE,BZ,BJ,BM,BT,BO,BA,BW,BV,BR,IO,VG,BN,BG,BF,BI,KH,CM,CA,CV,KY,CF,TD,CL,CN,CX,CC,CO,KM,CG,CK,CR,HR,CU,CY,CZ,DK,DJ,DM,DO,EC,EG,SV,GQ,ER,EE,ET,FK,FO,FJ,FI,FR,GF,PF,TF,GA,GM,GE,DE,GH,GI,GR,GL,GD,GP,GU,GT,GN,GW,GY,HT,HM,HN,HK,HU,IS,IN,ID,IR,IQ,IE,IL,IT,CI,JM,JP,JO,KZ,KE,KI,KW,KG,LA,LV,LB,LS,LR,LY,LI,LT,LU,MO,MK,MG,MW,MY,MV,ML,MT,MH,MQ,MR,MU,YT,FX,MX,FM,MD,MC,MN,MS,MA,MZ,MM,NA,NR,NP,NL,AN,NC,NZ,NI,NE,NG,NU,NF,KP,MP,NO,OM,PK,PW,PA,PG,PY,PE,PH,PN,PL,PT,PR,QA,RE,RO,RU,RW,SH,KN,LC,PM,VC,WS,SM,ST,SA,SN,SC,SL,SG,SK,SI,SB,SO,ZA,GS,KR,ES,LK,SD,SR,SJ,SZ,SE,CH,SY,TW,TJ,TZ,TH,TG,TK,TO,TT,TN,TR,TM,TC,TV,VI,UG,UA,AE,GB,US,UM,UY,UZ,VU,VA,VE,VN,WF,EH,YE,ZM,ZW'),
('default', 0, 'general/locale/timezone', 'Asia/Calcutta'),
('default', 0, 'general/locale/code', 'en_US'),
('default', 0, 'general/locale/firstday', '0'),
('default', 0, 'general/locale/weekend', '0,6'),
('default', 0, 'trans_email/ident_general/name', 'Ekkitab Admin'),
('default', 0, 'trans_email/ident_general/email', 'donotreply@ekkitab.com'),
('default', 0, 'trans_email/ident_sales/name', 'Ekkitab Sales'),
('default', 0, 'trans_email/ident_sales/email', 'donotreply@ekkitab.com'),
('default', 0, 'trans_email/ident_support/name', 'Ekkitab Customer Support'),
('default', 0, 'trans_email/ident_support/email', 'support@ekkitab.com'),
('default', 0, 'trans_email/ident_custom1/name', 'Custom 1'),
('default', 0, 'trans_email/ident_custom1/email', 'custom1@ekkitab.com'),
('default', 0, 'trans_email/ident_custom2/name', 'Custom 2'),
('default', 0, 'trans_email/ident_custom2/email', 'custom2@ekkitab.com'),
('default', 0, 'contacts/contacts/enabled', '1'),
('default', 0, 'contacts/email/recipient_email', 'support@ekkitab.com'),
('default', 0, 'contacts/email/sender_email_identity', 'support'),
('default', 0, 'contacts/email/email_template', 'contacts_email_email_template'),
('stores', 1, 'sitemap/category/changefreq', 'never'),
('stores', 1, 'sitemap/product/changefreq', 'never'),
('stores', 1, 'sitemap/page/changefreq', 'never'),
('default', 0, 'tax/classes/shipping_tax_class', '0'),
('default', 0, 'tax/calculation/based_on', 'shipping'),
('default', 0, 'tax/calculation/price_includes_tax', '0'),
('default', 0, 'tax/calculation/shipping_includes_tax', '0'),
('default', 0, 'tax/calculation/apply_after_discount', '0'),
('default', 0, 'tax/calculation/discount_tax', '0'),
('default', 0, 'tax/calculation/apply_tax_on', '0'),
('default', 0, 'tax/defaults/country', 'IN'),
('default', 0, 'tax/defaults/region', '0'),
('default', 0, 'tax/defaults/postcode', '*'),
('default', 0, 'tax/display/column_in_summary', '1'),
('default', 0, 'tax/display/full_summary', '0'),
('default', 0, 'tax/display/shipping', '1'),
('default', 0, 'tax/display/type', '1'),
('default', 0, 'tax/display/zero_tax', '0'),
('default', 0, 'tax/weee/enable', '0'),
('default',0, 'carriers/tablerate/active', '0'),
('default',0, 'carriers/freeshipping/active', '1'),
('default',0, 'carriers/freeshipping/title', 'Free Shipping'),
('default',0, 'carriers/freeshipping/name', 'Free'),
('default',0, 'carriers/freeshipping/free_shipping_subtotal', '100'),
('default',0, 'carriers/freeshipping/specificerrmsg', 'This shipping method is currently unavailable. If you would like to ship using this shipping method, please contact us.'),
('default',0, 'carriers/freeshipping/sallowspecific', '0'),
('default',0, 'carriers/freeshipping/showmethod', '0'),
('default',0, 'carriers/freeshipping/sort_order', ''),
('default',0, 'carriers/flatrate/active', '1'),
('default',0, 'carriers/flatrate/title', 'Flat Rate'),
('default',0, 'carriers/flatrate/name', 'Fixed'),
('default',0, 'carriers/flatrate/type', 'O'),
('default',0, 'carriers/flatrate/price', '30'),
('default',0, 'carriers/flatrate/handling_type', 'F'),
('default',0, 'carriers/flatrate/handling_fee', ''),
('default',0, 'carriers/flatrate/specificerrmsg', 'This shipping method is currently unavailable. If you would like to ship using this shipping method, please contact us.'),
('default',0, 'carriers/flatrate/sallowspecific', '1'),
('default',0, 'carriers/flatrate/showmethod', '0'),
('default',0, 'carriers/flatrate/sort_order', ''),
('default',0, 'carriers/flatrate/specificcountry', 'IN'),
('default',0, 'carriers/flatrate/free_shipping_subtotal', '100'),
('default', 0, 'carriers/dhl/active', '0'),
('default', 0, 'payment/ccsave/active', '0'),
('default', 0, 'payment/free/title', 'No Payment Information Required'),
('default', 0, 'payment/free/active', '0'),
('default', 0, 'payment/checkmo/active', '1'),
('default', 0, 'payment/checkmo/title', 'Check / DD / Money order'),
('default', 0, 'payment/checkmo/order_status', 'pending'),
('default', 0, 'payment/checkmo/allowspecific', '1'),
('default', 0, 'payment/checkmo/payable_to', 'Ekkitab Educational Services India Pvt Ltd'),
('default', 0, 'payment/checkmo/mailing_address', '#1134, 4th Floor, 100ft Road, HAL 2nd Stage<br>Indiranagar, Bangalore - 560008, India'),
('default', 0, 'payment/checkmo/sort_order', ''),
('default', 0, 'payment/purchaseorder/active', '0'),
('default', 0, 'payment/authorizenet/active', '0'),
('default', 0, 'payment/verisign/active', '0'),
('default', 0, 'payment/paypal_express/active', '0'),
('default', 0, 'payment/paypal_direct/active', '0'),
('default', 0, 'payment/billdesk/active', '0'),
('default', 0, 'payment/paypaluk_direct/active', '0'),
('default', 0, 'payment/amazonpayments_cba/active', '0'),
('default', 0, 'payment/checkmo/specificcountry', 'IN'),
('default', 0, 'advancedsmtp/settings/enabled', '1'),
('default', 0, 'advancedsmtp/settings/auth', 'login'),
('default', 0, 'advancedsmtp/settings/username', 'support@ekkitab.com'),
('default', 0, 'advancedsmtp/settings/password', 'eki22Ab'),
('default', 0, 'advancedsmtp/settings/host', 'smtpout.secureserver.net'),
('default', 0, 'advancedsmtp/settings/port', '25'),
('default', 0, 'advancedsmtp/settings/ssl', '0'),
('default', 0, 'cataloginventory/options/can_back_in_stock', '0'),
('default', 0, 'cataloginventory/options/can_subtract', '0'),
('default',0, 'cataloginventory/item_options/manage_stock', '0'),
('default',0, 'cataloginventory/item_options/backorders', '0'),
('default',0, 'cataloginventory/item_options/max_sale_qty', '10000'),
('default',0, 'cataloginventory/item_options/min_qty', '0'),
('default',0, 'cataloginventory/item_options/min_sale_qty', '1'),
('default',0, 'cataloginventory/item_options/notify_stock_qty', '1'),
('default',0, 'sitemap/category/changefreq', 'never'),
('default',0, 'sitemap/product/changefreq', 'never'),
('default',0, 'sitemap/page/changefreq', 'never'),
('default',0, 'sitemap/generate/enabled', '0'),
('default',0, 'sitemap/generate/frequency', 'D'),
('default',0, 'crontab/jobs/sitemap_generate/schedule/cron_expr', '0 0 * * *'),
('default',0, 'crontab/jobs/sitemap_generate/run/model', 'sitemap/observer::scheduledGenerateSitemaps'),
('default',0, 'sales_email/order/enabled', '1'),
('default',0, 'sales_email/order/identity', 'sales'),
('default',0, 'sales_email/order/template', 'sales_email_order_template'),
('default',0, 'sales_email/order/guest_template', 'sales_email_order_guest_template'),
('default',0, 'sales_email/order/copy_to', 'eksales@ekkitab.com'),
('default',0, 'sales_email/order/copy_method', 'bcc'),
('default',0, 'sales_email/order_comment/enabled', '1'),
('default',0, 'sales_email/order_comment/identity', 'sales'),
('default',0, 'sales_email/order_comment/template', 'sales_email_order_comment_template'),
('default',0, 'sales_email/order_comment/guest_template', 'sales_email_order_comment_guest_template'),
('default',0, 'sales_email/order_comment/copy_to', ''),
('default',0, 'sales_email/order_comment/copy_method', 'bcc'),
('default',0, 'sales_email/invoice/enabled', '1'),
('default',0, 'sales_email/invoice/identity', 'sales'),
('default',0, 'sales_email/invoice/template', 'sales_email_invoice_template'),
('default',0, 'sales_email/invoice/guest_template', 'sales_email_invoice_guest_template'),
('default',0, 'sales_email/invoice/copy_to', 'eksales@ekkitab.com'),
('default',0, 'sales_email/invoice/copy_method', 'bcc'),
('default',0, 'sales_email/invoice_comment/enabled', '1'),
('default',0, 'sales_email/invoice_comment/identity', 'sales'),
('default',0, 'sales_email/invoice_comment/template', 'sales_email_invoice_comment_template'),
('default',0, 'sales_email/invoice_comment/guest_template', 'sales_email_invoice_comment_guest_template'),
('default',0, 'sales_email/invoice_comment/copy_to', ''),
('default',0, 'sales_email/invoice_comment/copy_method', 'bcc'),
('default',0, 'sales_email/shipment/enabled', '1'),
('default',0, 'sales_email/shipment/identity', 'sales'),
('default',0, 'sales_email/shipment/template', 'sales_email_shipment_template'),
('default',0, 'sales_email/shipment/guest_template', 'sales_email_shipment_guest_template'),
('default',0, 'sales_email/shipment/copy_to', 'eksales@ekkitab.com'),
('default',0, 'sales_email/shipment/copy_method', 'bcc'),
('default',0, 'sales_email/shipment_comment/enabled', '1'),
('default',0, 'sales_email/shipment_comment/identity', 'sales'),
('default',0, 'sales_email/shipment_comment/template', 'sales_email_shipment_comment_template'),
('default',0, 'sales_email/shipment_comment/guest_template', 'sales_email_shipment_comment_guest_template'),
('default',0, 'sales_email/shipment_comment/copy_to', ''),
('default',0, 'sales_email/shipment_comment/copy_method', 'bcc'),
('default',0, 'sales_email/creditmemo/enabled', '1'),
('default',0, 'sales_email/creditmemo/identity', 'sales'),
('default',0, 'sales_email/creditmemo/template', 'sales_email_creditmemo_template'),
('default',0, 'sales_email/creditmemo/guest_template', 'sales_email_creditmemo_guest_template'),
('default',0, 'sales_email/creditmemo/copy_to', 'eksales@ekkitab.com'),
('default',0, 'sales_email/creditmemo/copy_method', 'bcc'),
('default',0, 'sales_email/creditmemo_comment/enabled', '1'),
('default',0, 'sales_email/creditmemo_comment/identity', 'sales'),
('default',0, 'sales_email/creditmemo_comment/template', 'sales_email_creditmemo_comment_template'),
('default',0, 'sales_email/creditmemo_comment/guest_template', 'sales_email_creditmemo_comment_guest_template'),
('default',0, 'sales_email/creditmemo_comment/copy_to', ''),
('default',0, 'sales_email/creditmemo_comment/copy_method', 'bcc'),
('default',0, 'shipping/origin/country_id', 'IN'),
('default',0, 'shipping/origin/region_id', 'Karnataka'),
('default',0, 'shipping/origin/postcode', ''),
('default',0, 'shipping/origin/city', 'Bangalore'),
('default',0, 'shipping/option/checkout_multiple', '1'),
('default',0, 'shipping/option/checkout_multiple_maximum_qty', '5'),
('default',0, 'carriers/ups/active', '0'),
('default',0, 'carriers/fedex/active', '0'),
('default',0, 'carriers/usps/active', '0'),
( 'default', 0, 'payment/paypal_standard/active', '1'),
( 'default', 0, 'payment/paypal_standard/title', 'Paypal'),
( 'default', 0, 'payment/paypal_standard/payment_action', 'AUTHORIZATION'),
( 'default', 0, 'payment/paypal_standard/types', 'IPN'),
( 'default', 0, 'payment/paypal_standard/order_status', 'processing'),
( 'default', 0, 'payment/paypal_standard/transaction_type', 'O'),
( 'default', 0, 'payment/paypal_standard/allowspecific', '0'),
( 'default', 0, 'payment/paypal_standard/sort_order', ''),
( 'default', 0, 'paypal/wps/business_name', 'Ekkitab Educational Services Pvt Ltd'),
( 'default', 0, 'paypal/wps/business_account', '7e9VHzspuv67ICjIYt1RxA=='),
( 'default', 0, 'paypal/wps/logo_url', 'http://www.ekkitab.co.in/scm/magento/skin/frontend/default/ekkitab/images/logo_266_60.gif'),
( 'default', 0, 'paypal/wps/sandbox_flag', '0'),
( 'default', 0, 'paypal/wps/debug_flag', '1'),
('default',0, 'payment/ccav/active', '1'),
('default',0, 'payment/ccav/title', 'Master / Visa / NetBanking/ Paymate / ITZ'),
('default',0, 'payment/ccav/payment_action', 'AUTHORIZATION'),
('default',0, 'payment/ccav/order_status', 'processing'),
('default',0, 'payment/ccav/transaction_type', 'O'),
('default',0, 'payment/ccav/sort_order', ''),
('default',0, 'ccav/wps/checksum_key', 'kvppt13q4lwbo4g90y'),
('default',0, 'ccav/wps/merchant_url', 'https://www.ccavenue.com/shopzone/cc_details.jsp'),
('default',0, 'ccav/wps/return_url', 'http://ekkitab.co.in/scm/magento/ccav/standard/ccavresponse'),
('default',0, 'ccav/wps/merchant_id', 'M_singhak_11811'),
('default',0, 'ccav/wps/logo_url', ''),
('default',0, 'ccav/wps/sandbox_flag', '0'),
('default',0, 'ccav/wps/debug_flag', '0'),
('default',0, 'payment/billdesk/title', 'American Express / Diners Card'),
('default',0, 'payment/billdesk/payment_action', 'AUTHORIZATION'),
('default',0, 'payment/billdesk/order_status', 'processing'),
('default',0, 'payment/billdesk/transaction_type', 'O'),
('default',0, 'payment/billdesk/sort_order', ''),
('default',0, 'billdesk/wps/checksum_key', 'pWUb4i1oTLCs'),
('default',0, 'billdesk/wps/merchant_url', 'https://www.billdesk.com/pgidsk/pgmerc/EKKITABPaymentoption.jsp'),
('default',0, 'billdesk/wps/return_url', 'http://ekkitab.co.in/scm/magento/billdesk/standard/response'),
('default',0, 'billdesk/wps/merchant_id', ''),
('default',0, 'billdesk/wps/logo_url', ''),
('default',0, 'billdesk/wps/sandbox_flag', '0'),
('default',0, 'billdesk/wps/debug_flag', '0'),
('default',0, 'sales/reorder/allow', '0'),
('default',0, 'sales/identity/address', 'Ekkitab Educational Services India Pvt Ltd, #1134, 4th Floor, 100ft Road, HAL 2nd Stage, Indiranagar, Bangalore - 560008, India. Tel No: 080 - 25210604'),
('default',0, 'sales/identity/logo', 'default/logo_email.png'),
('default',0, 'sales/identity/logo_html', 'default/logo_email.png'),
('default', 0, 'catalog/placeholder/image_placeholder', 'stores/1/image.png'),
('default', 0, 'catalog/placeholder/small_image_placeholder', 'stores/1/small_image.png'),
('default', 0, 'catalog/placeholder/thumbnail_placeholder','default/thumbnail.png'),
('default', 0, 'google/analytics/active', '1'),
('default',	0, 'web/browser_capabilities/cookies','1'),
('default',	0, 'web/browser_capabilities/javascript','1'),
('default', 0, 'web/cookie/cookie_lifetime', '7200');



--
-- Dumping data for table `ek_catalog_global_sections`

Delete from `ek_catalog_global_sections`;

INSERT INTO `ek_catalog_global_sections` (  `section_id` ,`display_name`, `description` , `active_from_date`,  `active_to_date`,`template_path`, `is_homepage_display`, `homepage_template_path`) VALUES
( 1, 'Indian Classics', '','2010-03-01','2011-03-31','catalog/globalsection/indian_classics.phtml','0',''),
( 2, 'All Time Great Fiction', '','2010-03-01','2011-03-31','catalog/globalsection/great_fiction.phtml','0',''),
( 3, 'Top Children''s Books', '','2010-03-01','2011-03-31','catalog/globalsection/top_childrens_books.phtml','0',''),
( 4, 'Summer Reading', '','2010-03-01','2011-03-31','catalog/globalsection/summer_reading.phtml','1','catalog/globalsection/summer_reading_home.phtml');


INSERT INTO `customer_entity` VALUES (1,1,0,1,'install@ekkitab.com',1,'000000004',1,'2010-04-10 06:42:03','2010-04-10 06:42:04',1);
INSERT INTO `customer_entity_varchar` VALUES (1,1,5,1,'Installation'),(2,1,7,1,'Account'),(4,1,3,1,'Ekkitab'),(5,1,12,1,'78e356fc19336772aceb39e57d122dcc:lr');

	