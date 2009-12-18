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
  `DESCRIPTION` varchar(80),
  `PUBLISHING_DATE` date,
  `PUBLISHER` varchar(100),
  `PAGES` INT NOT NULL default '0',
  `LANGUAGE` varchar(20),
  `LIST_PRICE` decimal(6,2),
  `DISCOUNT` decimal(4,2),
  `SUPPLIERS_PRICE` decimal(6,2),
  `SUPPLIERS_DISCOUNT` decimal(4,2),
  `CURRENCY` varchar(20),
  `BISAC1` varchar(255) NOT NULL,
  `BISAC2` SMALLINT UNSIGNED DEFAULT NULL,
  `BISAC3` SMALLINT UNSIGNED DEFAULT NULL,
  `DELIVERY_PERIOD` TINYINT UNSIGNED,
  `COVER_THUMB` varchar(80),
  `IMAGE` varchar(80),
  `IN_STOCK` BIT,
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
  `UPDATED_DATE` date NOT NULL,
  `NEW` TINYINT UNSIGNED NOT NULL default '0',
  `PRODUCT_STATUS` TINYINT UNSIGNED NOT NULL default '1',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ISBN` (`ISBN`)
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
  `CATEGORY_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`VALUE_ID`),
  UNIQUE KEY `BISAC_CODE` (`BISAC_CODE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8  AUTO_INCREMENT=1 ;



