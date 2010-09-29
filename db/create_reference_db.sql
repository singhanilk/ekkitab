-- create_reference_db.sql
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
-- @version 1.0     Dec 01, 2009
-- @version 1.1     Dec 02, 2009
-- @version 1.2     Dec 09, 2009
-- @version 2.0     Jan 28, 2010 (Vijay@ekkitab.com)
-- @version 2.1     Sep 29, 2010 (prasad@ekkitab.com)
-- The drop database has been moved to a separate script called create_reference_database.sql



SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";


--
-- Database: `reference`
--

-- Droping the Database if it exists
-- DROP DATABASE IF EXISTS `reference`;

-- Creating a DataBase
-- CREATE DATABASE `reference` DEFAULT CHARACTER SET `utf8` COLLATE `utf8_general_ci`;

USE `reference`;

-- --------------------------------------------------------

--
-- Table structure for table `books`
--

CREATE TABLE IF NOT EXISTS `books` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` varchar(255),
  `author` varchar(120),
  `isbn` varchar(20),
  `isbn10` varchar(20),
  `binding` varchar(20),
  `description` varchar(2048) DEFAULT NULL,
  `short_description` varchar(2048) DEFAULT NULL,
  `publishing_date` varchar(128) DEFAULT '',
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
  `update_time` timestamp default current_timestamp,
  `product_status` TINYINT UNSIGNED NOT NULL default '1',
  `bisac_codes` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ISBN` (`isbn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;


--
-- Table structure for table `ek_category_map`
--

CREATE TABLE IF NOT EXISTS `ek_bisac_category_map` (
  `value_id` int(11) NOT NULL AUTO_INCREMENT,
  `bisac_code` varchar(36) NOT NULL,
  `level1` varchar(80) NOT NULL,
  `level2` varchar(80) NOT NULL,
  `level3` varchar(80) NOT NULL,
  `level4` varchar(80) NOT NULL,
  `level5` varchar(80) NOT NULL,
  `level6` varchar(80) NOT NULL,
  `level7` varchar(80) NOT NULL,
  `category_id` varchar(255) NOT NULL,
  `rewrite_url` varchar(255) NOT NULL,
  PRIMARY KEY (`value_id`),
  UNIQUE KEY `BISAC_CODE` (`bisac_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8  AUTO_INCREMENT=1 ;

--
-- Table structure for `ek_currency_conversion`
--

CREATE TABLE IF NOT EXISTS `ek_currency_conversion` (
  `id` int NOT NULL AUTO_INCREMENT,
  `currency` varchar(16) NOT NULL,
  `conversion` decimal (4,2) NOT NULL default 1.0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQUE_CURRENCY` (`currency`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8  AUTO_INCREMENT=1 ;


--
-- Table structure for `ek_discount_setting`
--

CREATE TABLE IF NOT EXISTS `ek_discount_setting` (
  `id` int NOT NULL AUTO_INCREMENT,
  `info_source` varchar(40) NOT NULL,
  `discount_percent` smallint NOT NULL default 100,
  PRIMARY KEY (`id`),
  UNIQUE KEY (`info_source`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8  AUTO_INCREMENT=1 ;

--
-- Table structure for `ek_supplier_params`
--

CREATE TABLE IF NOT EXISTS `ek_supplier_params` (
  `id` int NOT NULL AUTO_INCREMENT,
  `info_source` varchar(40) NOT NULL,
  `publisher` varchar(80) NOT NULL,
  `supplier_discount` smallint NOT NULL default 20,
  `delivery_period` smallint NOT NULL default 5,
  PRIMARY KEY (`id`),
  UNIQUE KEY (`info_source`, `publisher`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8  AUTO_INCREMENT=1 ;

--
-- Table structure for `book_availability`
--

CREATE TABLE IF NOT EXISTS `book_availability` (
  `id` int NOT NULL AUTO_INCREMENT,
  `isbn` varchar(20) NOT NULL,
  `distributor` varchar(80) NOT NULL,
  `in_stock` tinyint(1) default 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY (`isbn`, `distributor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8  AUTO_INCREMENT=1 ;

--
-- Table Structure for table books_promo
--

CREATE TABLE IF NOT EXISTS `books_promo`(
`id` int(12) UNSIGNED NOT NULL AUTO_INCREMENT,
`isbn` VARCHAR(20) NOT NULL,
`promo_desc` TEXT,
PRIMARY KEY (`id`),
KEY `isbn_key`(`isbn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT = 1;

--
-- Table Structure for table missing_isbns
--
CREATE TABLE IF NOT EXISTS `missing_isbns` (
  `id` int(12) UNSIGNED NOT NULL AUTO_INCREMENT,
  `supplier` VARCHAR(50) NOT NULL,
  `isbn` VARCHAR(20) NOT NULL,
  `title` VARCHAR(255) default NULL,
  `author` VARCHAR(120) default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `ISBN` (`isbn`, `supplier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;

--
-- Table Structure for table isbns to be ignored
--
CREATE TABLE IF NOT EXISTS `ignore_isbns` (
  `id` int(12) UNSIGNED NOT NULL AUTO_INCREMENT,
  `isbn` VARCHAR(20) NOT NULL,
  `title` VARCHAR(255) default NULL,
  `author` VARCHAR(120) default NULL,
  `supplier` VARCHAR(50) default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `ISBN` (`isbn`, `supplier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;

--
-- Table Structure for table bisac details not present
--
CREATE TABLE IF NOT EXISTS `missing_bisac_codes` (
  `id` int(12) UNSIGNED NOT NULL AUTO_INCREMENT,
  `isbn` VARCHAR(20) NOT NULL,
  `subject` VARCHAR(255) NOT NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `ISBN` (`isbn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;
