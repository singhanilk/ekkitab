-- create_books_in_ekkitab.sql
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
-- @version 1.0     Feb 18, 2010

--
-- Database: `ekkitab_books`
--

USE `ekkitab_books`;

--
-- Table structure for table `books`
--

CREATE TABLE `books` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` varchar(255),
  `author` varchar(120),
  `isbn` varchar(20),
  `isbn10` varchar(20),
  `binding` varchar(20),
  `description` varchar(2048) DEFAULT NULL,
  `short_description` varchar(2048) DEFAULT NULL,
  `publishing_date` date,
  `publisher` varchar(100),
  `pages` INT NOT NULL default '0',
  `language` varchar(20),
  `list_price` decimal(8,2),
  `discount_price` decimal(8,2),
  `suppliers_price` decimal(8,2),
  `suppliers_discount` decimal(4,2),
  `currency` varchar(20),
  `bisac1` varchar(255) NOT NULL,
  `delivery_period` TINYINT UNSIGNED,
  `image` varchar(80),
  `in_stock` tinyint(1) default 0,
  `qty` INT UNSIGNED,
  `weight` decimal(6,2),
  `dimension` varchar(80),
  `illustrator` varchar(120),
  `edition` varchar(80),
  `shipping_region` TINYINT UNSIGNED default '0',
  `int_shipping` TINYINT UNSIGNED default '0',
  `info_source` varchar(40) NOT NULL,
  `sourced_from` varchar(16) NOT NULL default 'India',
  `updated_date` date NOT NULL,
  `product_status` TINYINT UNSIGNED NOT NULL default '1',
  `bisac_codes` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ISBN` (`isbn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;
