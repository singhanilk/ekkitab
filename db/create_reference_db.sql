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



SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";


--
-- Database: `reference`
--

-- Droping the Database if it exists
DROP DATABASE IF EXISTS `reference`;

-- Creating a DataBase

CREATE DATABASE `reference` DEFAULT CHARACTER SET `utf8` COLLATE `utf8_general_ci`;

USE `reference`;

-- --------------------------------------------------------

--
-- Table structure for table `books`
--

CREATE TABLE `books` (
  `ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `TITLE` varchar(255),
  `AUTHOR` varchar(120),
  `ISBN` varchar(20),
  `ISBN10` varchar(20),
  `BINDING` varchar(20),
  `DESCRIPTION` varchar(2048) DEFAULT NULL,
  `SHORT_DESCRIPTION` varchar(2048) DEFAULT NULL,
  `PUBLISHING_DATE` date,
  `PUBLISHER` varchar(100),
  `PAGES` INT NOT NULL default '0',
  `LANGUAGE` varchar(20),
  `LIST_PRICE` decimal(8,2),
  `DISCOUNT_PRICE` decimal(8,2),
  `SUPPLIERS_PRICE` decimal(8,2),
  `SUPPLIERS_DISCOUNT` decimal(4,2),
  `CURRENCY` varchar(20),
  `BISAC1` varchar(255) NOT NULL,
  `BISAC2` SMALLINT UNSIGNED DEFAULT NULL,
  `BISAC3` SMALLINT UNSIGNED DEFAULT NULL,
  `DELIVERY_PERIOD` TINYINT UNSIGNED,
  `COVER_THUMB` varchar(80),
  `IMAGE` varchar(80),
  `IN_STOCK` tinyint(1) default 0,
  `STOCK_UPDATED` tinyint(1) default 0,
  `PRICE_UPDATED` tinyint(1) default 0,
  `QTY` INT UNSIGNED,
  `WEIGHT` decimal(6,2),
  `DIMENSION` varchar(80),
  `ILLUSTRATOR` varchar(120),
  `EDITORIAL_REVIEW` varchar(80),
  `EDITION` varchar(80),
  `SHIPPING_REGION` TINYINT UNSIGNED default '0',
  `INT_SHIPPING` TINYINT UNSIGNED default '0',
  `RATING` TINYINT UNSIGNED,
  `INFO_SOURCE` varchar(40) NOT NULL,
  `SOURCED_FROM` varchar(16) NOT NULL default 'India',
  `UPDATED_DATE` date NOT NULL,
  `NEW` TINYINT UNSIGNED NOT NULL default '0',
  `PRODUCT_STATUS` TINYINT UNSIGNED NOT NULL default '1',
  `REWRITE_URL` varchar(255) NOT NULL,
  `BISAC_CODES` varchar(255) NOT NULL,
  `PRODUCT_ID` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ISBN` (`ISBN`),
  KEY `PRODUCT_ID` (`PRODUCT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;


--
-- Table structure for table `ek_category_map`
--

CREATE TABLE IF NOT EXISTS `ek_bisac_category_map` (
  `VALUE_ID` int(11) NOT NULL AUTO_INCREMENT,
  `BISAC_CODE` varchar(36) NOT NULL,
  `LEVEL1` varchar(80) NOT NULL,
  `LEVEL2` varchar(80) NOT NULL,
  `LEVEL3` varchar(80) NOT NULL,
  `LEVEL4` varchar(80) NOT NULL,
  `LEVEL5` varchar(80) NOT NULL,
  `LEVEL6` varchar(80) NOT NULL,
  `LEVEL7` varchar(80) NOT NULL,
  `CATEGORY_ID` varchar(255) NOT NULL,
  `REWRITE_URL` varchar(255) NOT NULL,
  PRIMARY KEY (`VALUE_ID`),
  UNIQUE KEY `BISAC_CODE` (`BISAC_CODE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8  AUTO_INCREMENT=1 ;

--
-- Table structure for `ek_currency_conversion`
--

CREATE TABLE IF NOT EXISTS `ek_currency_conversion` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `CURRENCY` varchar(16) NOT NULL,
  `CONVERSION` decimal (4,2) NOT NULL default 1.0,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `UNIQUE_CURRENCY` (`CURRENCY`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8  AUTO_INCREMENT=1 ;


--
-- Table structure for `ek_discount_setting`
--

CREATE TABLE IF NOT EXISTS `ek_discount_setting` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `INFO_SOURCE` varchar(40) NOT NULL,
  `DISCOUNT_PERCENT` smallint NOT NULL default 100,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `UNIQUE_INFO_SOURCE` (`INFO_SOURCE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8  AUTO_INCREMENT=1 ;

--
-- Table structure for `book_description.`
-- This is a temp table to hold data from text files.
--

CREATE TABLE if not exists `book_description` (
  `ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `ISBN` varchar(20) NOT NULL,
  `DESCRIPTION` varchar(2048) DEFAULT NULL,
  `SHORT_DESCRIPTION` varchar(2048) DEFAULT NULL,
  `UPDATED` tinyint(1) default 0,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ISBN` (`ISBN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for `book_stock_and_prices.`
-- This is a temp table to hold data from text files.
--

CREATE TABLE if not exists `book_stock_and_prices` (
  `ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `ISBN` varchar(20) NOT NULL,
  `IN_STOCK` tinyint(1) default 0,
  `LIST_PRICE` decimal(8,2),
  `DISCOUNT_PRICE` decimal(8,2),
  `SUPPLIERS_PRICE` decimal(8,2),
  `SUPPLIERS_DISCOUNT` decimal(4,2),
  `CURRENCY` varchar(20),
  `PUBLISHING_DATE` date,
  `UPDATED` tinyint(1) default 0,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ISBN` (`ISBN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;
