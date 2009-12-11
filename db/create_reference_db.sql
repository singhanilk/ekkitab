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

CREATE TABLE IF NOT EXISTS `books` (
  `VALUE_ID` int(11) NOT NULL AUTO_INCREMENT,
  `TITLE` varchar(255) NOT NULL,
  `AUTHOR` varchar(255) NOT NULL,
  `ISBN` varchar(255) NOT NULL,
  `ISBN10` varchar(255) NOT NULL,
  `BINDING` varchar(255) NOT NULL,
  `DESCRIPTION` text NOT NULL,
  `PUBLISHING_DATE` date NOT NULL,
  `PUBLISHER` varchar(255) NOT NULL,
  `NUMBER_OF_PAGES` int(11) NOT NULL,
  `LANGUAGE` varchar(255) NOT NULL,
  `LIST_PRICE` decimal(10,2) NOT NULL,
  `DISCOUNT` decimal(10,2) NOT NULL,
  `SUPPLIERS_PRICE` decimal(10,2) NOT NULL,
  `SUPPLIERS_DISCOUNT` decimal(10,2) NOT NULL,
  `CURRENCY` varchar(255) NOT NULL,
  `BISAC1` varchar(255) NOT NULL,
  `BISAC2` varchar(255) DEFAULT NULL,
  `BISAC3` varchar(255) DEFAULT NULL,
  `DELIVERY_PERIOD` int(11) NOT NULL,
  `COVER_THUMB` varchar(255) NOT NULL,
  `IMAGE` varchar(255) NOT NULL,
  `IN_STOCK` int(11) NOT NULL,
  `QTY` int(11) NOT NULL,
  `WEIGHT` decimal(10,2) NOT NULL,
  `DIMENSION` varchar(255) NOT NULL,
  `ILLUSTRATOR` varchar(255) NOT NULL,
  `EDITORIAL_REVIEW` text NOT NULL,
  `EDITION` varchar(255) NOT NULL,
  `SHIPPING_REGION` tinyint(4) NOT NULL,
  `INT_SHIPPING` tinyint(4) NOT NULL,
  `RATING` int(11) NOT NULL,
  `INFO_SOURCE` varchar(255) NOT NULL,
  `UPDATED_DATE` date NOT NULL,
  `NEW` tinyint(4) NOT NULL,
  `PRODUCT_STATUS` int(11) NOT NULL,
  PRIMARY KEY (`VALUE_ID`),
  UNIQUE KEY `ISBN` (`ISBN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;


-- --------------------------------------------------------

--
-- Table structure for table `ek_category_list`
--

CREATE TABLE IF NOT EXISTS `ek_category_list` (
  `VALUE_ID` int(11) NOT NULL AUTO_INCREMENT,
  `CATEGORY_NAME` varchar(255) NOT NULL,
  `EK_CATEGORY_ID` int(11) NOT NULL,
  PRIMARY KEY (`VALUE_ID`),
  UNIQUE KEY `EK_CATEGORY_ID` (`EK_CATEGORY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;



-- --------------------------------------------------------

--
-- Table structure for table `ek_category_map`
--

CREATE TABLE IF NOT EXISTS `ek_category_map` (
  `VALUE_ID` int(11) NOT NULL AUTO_INCREMENT,
  `BISAC` varchar(255) NOT NULL,
  `EK_CATEGORY_ID` int(11) NOT NULL,
  PRIMARY KEY (`VALUE_ID`),
  KEY `FK_CATEGORY_ID` (`EK_CATEGORY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8  AUTO_INCREMENT=1 ;



-- --------------------------------------------------------


--
-- Constraints for tables
--

--
-- Constraints for table `ek_category_map`
--
ALTER TABLE `ek_category_map`
  ADD CONSTRAINT `FK_CATEGORY_ID` FOREIGN KEY (`EK_CATEGORY_ID`) REFERENCES `ek_category_list` (`EK_CATEGORY_ID`) ON DELETE CASCADE ON UPDATE CASCADE;



-- --------------------------------------------------------

