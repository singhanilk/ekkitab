-- create_ekkitab_db.sql
--
-- COPYRIGHT (C) 2009 Ekkitab Educational Services India Pvt. Ltd.  
-- All Rights Reserved. All material contained in this file (including, but not 
-- limited to, text, images, graphics, HTML, programming code and scripts) constitute 
-- proprietary and confidential information protected by copyright laws, trade secret 
-- and other laws. No part of this software may be copied, reproduced, modified 
-- or distributed in any form or by any means, or stored in a database or retrieval 
-- system without the prior written permission of Ekkitab Educational Servives.
--
-- @author Arun Kuppuswamy (arun@ekkitab.com)
-- @version 1.0     Nov 11, 2009
-- @version 1.1     Nov 11, 2009 (anisha@ekkitab.com)
-- @version 1.2     Dec 03, 2009 (arun@ekkitab.com)
-- @version 1.2     Dec 04, 2009 (arun@ekkitab.com)

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

DROP DATABASE IF EXISTS `ekkitab_books`;

-- Creating a DataBase

CREATE DATABASE `ekkitab_books` DEFAULT CHARACTER SET `utf8` COLLATE `utf8_general_ci`;
USE `ekkitab_books`;

--
-- Table structure for table `adminnotification_inbox`
--

CREATE TABLE IF NOT EXISTS `adminnotification_inbox` (
  `notification_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `severity` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `date_added` datetime NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text,
  `url` varchar(255) NOT NULL,
  `is_read` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `is_remove` tinyint(1) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`notification_id`),
  KEY `IDX_SEVERITY` (`severity`),
  KEY `IDX_IS_READ` (`is_read`),
  KEY `IDX_IS_REMOVE` (`is_remove`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=30 ;

--
-- Table structure for table `admin_assert`
--

CREATE TABLE IF NOT EXISTS `admin_assert` (
  `assert_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `assert_type` varchar(20) NOT NULL DEFAULT '',
  `assert_data` text,
  PRIMARY KEY (`assert_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='ACL Asserts' AUTO_INCREMENT=1 ;

--
-- Table structure for table `admin_role`
--

CREATE TABLE IF NOT EXISTS `admin_role` (
  `role_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `parent_id` int(10) unsigned NOT NULL DEFAULT '0',
  `tree_level` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `sort_order` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `role_type` char(1) NOT NULL DEFAULT '0',
  `user_id` int(11) unsigned NOT NULL DEFAULT '0',
  `role_name` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`role_id`),
  KEY `parent_id` (`parent_id`,`sort_order`),
  KEY `tree_level` (`tree_level`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='ACL Roles' AUTO_INCREMENT=5 ;

--
-- Dumping data for table `admin_role`
--

INSERT INTO `admin_role` (`role_id`, `parent_id`, `tree_level`, `sort_order`, `role_type`, `user_id`, `role_name`) VALUES
(1, 0, 1, 1, 'G', 0, 'Administrators'),
(3, 1, 2, 0, 'U', 2, 'Ekkitab'),
(4, 1, 2, 0, 'U', 3, 'Ekkitab');

--
-- Table structure for table `admin_rule`
--

CREATE TABLE IF NOT EXISTS `admin_rule` (
  `rule_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `role_id` int(10) unsigned NOT NULL DEFAULT '0',
  `resource_id` varchar(255) NOT NULL DEFAULT '',
  `privileges` varchar(20) NOT NULL DEFAULT '',
  `assert_id` int(10) unsigned NOT NULL DEFAULT '0',
  `role_type` char(1) DEFAULT NULL,
  `permission` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`rule_id`),
  KEY `resource` (`resource_id`,`role_id`),
  KEY `role_id` (`role_id`,`resource_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='ACL Rules' AUTO_INCREMENT=2 ;

--
-- Dumping data for table `admin_rule`
--

INSERT INTO `admin_rule` (`rule_id`, `role_id`, `resource_id`, `privileges`, `assert_id`, `role_type`, `permission`) VALUES
(1, 1, 'all', '', 0, 'G', 'allow');

--
-- Table structure for table `admin_user`
--

CREATE TABLE IF NOT EXISTS `admin_user` (
  `user_id` mediumint(9) unsigned NOT NULL AUTO_INCREMENT,
  `firstname` varchar(32) NOT NULL DEFAULT '',
  `lastname` varchar(32) NOT NULL DEFAULT '',
  `email` varchar(128) NOT NULL DEFAULT '',
  `username` varchar(40) NOT NULL DEFAULT '',
  `password` varchar(40) NOT NULL DEFAULT '',
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified` datetime DEFAULT NULL,
  `logdate` datetime DEFAULT NULL,
  `lognum` smallint(5) unsigned NOT NULL DEFAULT '0',
  `reload_acl_flag` tinyint(1) NOT NULL DEFAULT '0',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `extra` text,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Users' AUTO_INCREMENT=4 ;

--
-- Dumping data for table `admin_user`
--

INSERT INTO `admin_user` (`user_id`, `firstname`, `lastname`, `email`, `username`, `password`, `created`, `modified`, `logdate`, `lognum`, `reload_acl_flag`, `is_active`, `extra`) VALUES
(3, 'Ekkitab', 'E', 'admin@ekkitab.com', 'admin', '1f9cda191d7b227d2b90c0e043a55513:1p', '2009-10-16 07:13:09', '2009-10-16 11:06:25', '2009-10-16 11:17:50', 3, 0, 1, 'N;');

--
-- Table structure for table `amazonpayments_api_debug`
--

CREATE TABLE IF NOT EXISTS `amazonpayments_api_debug` (
  `debug_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `transaction_id` varchar(255) NOT NULL DEFAULT '',
  `debug_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `request_body` text,
  `response_body` text,
  PRIMARY KEY (`debug_id`),
  KEY `debug_at` (`debug_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `api_assert`
--

CREATE TABLE IF NOT EXISTS `api_assert` (
  `assert_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `assert_type` varchar(20) NOT NULL DEFAULT '',
  `assert_data` text,
  PRIMARY KEY (`assert_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Api ACL Asserts' AUTO_INCREMENT=1 ;

--
-- Table structure for table `api_role`
--

CREATE TABLE IF NOT EXISTS `api_role` (
  `role_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `parent_id` int(10) unsigned NOT NULL DEFAULT '0',
  `tree_level` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `sort_order` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `role_type` char(1) NOT NULL DEFAULT '0',
  `user_id` int(11) unsigned NOT NULL DEFAULT '0',
  `role_name` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`role_id`),
  KEY `parent_id` (`parent_id`,`sort_order`),
  KEY `tree_level` (`tree_level`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Api ACL Roles' AUTO_INCREMENT=1 ;

--
-- Table structure for table `api_rule`
--

CREATE TABLE IF NOT EXISTS `api_rule` (
  `rule_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `role_id` int(10) unsigned NOT NULL DEFAULT '0',
  `resource_id` varchar(255) NOT NULL DEFAULT '',
  `privileges` varchar(20) NOT NULL DEFAULT '',
  `assert_id` int(10) unsigned NOT NULL DEFAULT '0',
  `role_type` char(1) DEFAULT NULL,
  `permission` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`rule_id`),
  KEY `resource` (`resource_id`,`role_id`),
  KEY `role_id` (`role_id`,`resource_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Api ACL Rules' AUTO_INCREMENT=1 ;

--
-- Table structure for table `api_session`
--

CREATE TABLE IF NOT EXISTS `api_session` (
  `user_id` mediumint(9) unsigned NOT NULL,
  `logdate` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `sessid` varchar(40) NOT NULL DEFAULT '',
  KEY `API_SESSION_USER` (`user_id`),
  KEY `API_SESSION_SESSID` (`sessid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Api Sessions';

--
-- Table structure for table `api_user`
--

CREATE TABLE IF NOT EXISTS `api_user` (
  `user_id` mediumint(9) unsigned NOT NULL AUTO_INCREMENT,
  `firstname` varchar(32) NOT NULL DEFAULT '',
  `lastname` varchar(32) NOT NULL DEFAULT '',
  `email` varchar(128) NOT NULL DEFAULT '',
  `username` varchar(40) NOT NULL DEFAULT '',
  `api_key` varchar(40) NOT NULL DEFAULT '',
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified` datetime DEFAULT NULL,
  `lognum` smallint(5) unsigned NOT NULL DEFAULT '0',
  `reload_acl_flag` tinyint(1) NOT NULL DEFAULT '0',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Api Users' AUTO_INCREMENT=1 ;

--
-- Table structure for table `catalogindex_aggregation`
--

CREATE TABLE IF NOT EXISTS `catalogindex_aggregation` (
  `aggregation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `store_id` smallint(5) unsigned NOT NULL,
  `created_at` datetime NOT NULL,
  `key` varchar(255) DEFAULT NULL,
  `data` mediumtext,
  PRIMARY KEY (`aggregation_id`),
  UNIQUE KEY `IDX_STORE_KEY` (`store_id`,`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `catalogindex_aggregation_tag`
--

CREATE TABLE IF NOT EXISTS `catalogindex_aggregation_tag` (
  `tag_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `tag_code` varchar(255) NOT NULL,
  PRIMARY KEY (`tag_id`),
  UNIQUE KEY `IDX_CODE` (`tag_code`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=5 ;

--
-- Table structure for table `catalogindex_aggregation_to_tag`
--

CREATE TABLE IF NOT EXISTS `catalogindex_aggregation_to_tag` (
  `aggregation_id` int(10) unsigned NOT NULL,
  `tag_id` int(10) unsigned NOT NULL,
  UNIQUE KEY `IDX_AGGREGATION_TAG` (`aggregation_id`,`tag_id`),
  KEY `FK_CATALOGINDEX_AGGREGATION_TO_TAG_TAG` (`tag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `catalogindex_eav`
--

CREATE TABLE IF NOT EXISTS `catalogindex_eav` (
  `store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `entity_id` int(10) unsigned NOT NULL DEFAULT '0',
  `attribute_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `value` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`store_id`,`entity_id`,`attribute_id`,`value`),
  KEY `IDX_VALUE` (`value`),
  KEY `FK_CATALOGINDEX_EAV_ENTITY` (`entity_id`),
  KEY `FK_CATALOGINDEX_EAV_ATTRIBUTE` (`attribute_id`),
  KEY `FK_CATALOGINDEX_EAV_STORE` (`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `catalogindex_minimal_price`
--

CREATE TABLE IF NOT EXISTS `catalogindex_minimal_price` (
  `index_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `entity_id` int(10) unsigned NOT NULL DEFAULT '0',
  `customer_group_id` smallint(3) unsigned NOT NULL DEFAULT '0',
  `qty` decimal(12,4) unsigned NOT NULL DEFAULT '0.0000',
  `value` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `tax_class_id` smallint(6) NOT NULL DEFAULT '0',
  `website_id` smallint(5) unsigned DEFAULT NULL,
  PRIMARY KEY (`index_id`),
  KEY `IDX_VALUE` (`value`),
  KEY `IDX_QTY` (`qty`),
  KEY `FK_CATALOGINDEX_MINIMAL_PRICE_CUSTOMER_GROUP` (`customer_group_id`),
  KEY `FK_CI_MINIMAL_PRICE_WEBSITE_ID` (`website_id`),
  KEY `IDX_FULL` (`entity_id`,`qty`,`customer_group_id`,`value`,`website_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `catalogindex_price`
--

CREATE TABLE IF NOT EXISTS `catalogindex_price` (
  `entity_id` int(10) unsigned NOT NULL DEFAULT '0',
  `attribute_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `customer_group_id` smallint(3) unsigned NOT NULL DEFAULT '0',
  `qty` decimal(12,4) unsigned NOT NULL DEFAULT '0.0000',
  `value` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `tax_class_id` smallint(6) NOT NULL DEFAULT '0',
  `website_id` smallint(5) unsigned DEFAULT NULL,
  KEY `IDX_VALUE` (`value`),
  KEY `IDX_QTY` (`qty`),
  KEY `FK_CATALOGINDEX_PRICE_ENTITY` (`entity_id`),
  KEY `FK_CATALOGINDEX_PRICE_ATTRIBUTE` (`attribute_id`),
  KEY `FK_CATALOGINDEX_PRICE_CUSTOMER_GROUP` (`customer_group_id`),
  KEY `IDX_RANGE_VALUE` (`entity_id`,`attribute_id`,`customer_group_id`,`value`),
  KEY `FK_CI_PRICE_WEBSITE_ID` (`website_id`),
  KEY `IDX_FULL` (`entity_id`,`attribute_id`,`customer_group_id`,`value`,`website_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `cataloginventory_stock`
--

CREATE TABLE IF NOT EXISTS `cataloginventory_stock` (
  `stock_id` smallint(4) unsigned NOT NULL AUTO_INCREMENT,
  `stock_name` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`stock_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Catalog inventory Stocks list' AUTO_INCREMENT=2 ;

--
-- Dumping data for table `cataloginventory_stock`
--

INSERT INTO `cataloginventory_stock` (`stock_id`, `stock_name`) VALUES
(1, 'Default');

--
-- Table structure for table `cataloginventory_stock_item`
--

CREATE TABLE IF NOT EXISTS `cataloginventory_stock_item` (
  `item_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `product_id` int(10) unsigned NOT NULL DEFAULT '0',
  `stock_id` smallint(4) unsigned NOT NULL DEFAULT '0',
  `qty` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `min_qty` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `use_config_min_qty` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `is_qty_decimal` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `backorders` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `use_config_backorders` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `min_sale_qty` decimal(12,4) NOT NULL DEFAULT '1.0000',
  `use_config_min_sale_qty` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `max_sale_qty` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `use_config_max_sale_qty` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `is_in_stock` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `low_stock_date` datetime DEFAULT NULL,
  `notify_stock_qty` decimal(12,4) DEFAULT NULL,
  `use_config_notify_stock_qty` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `manage_stock` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `use_config_manage_stock` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `stock_status_changed_automatically` tinyint(1) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`item_id`),
  UNIQUE KEY `IDX_STOCK_PRODUCT` (`product_id`,`stock_id`),
  KEY `FK_CATALOGINVENTORY_STOCK_ITEM_PRODUCT` (`product_id`),
  KEY `FK_CATALOGINVENTORY_STOCK_ITEM_STOCK` (`stock_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Inventory Stock Item Data' AUTO_INCREMENT=2 ;

--
-- Table structure for table `cataloginventory_stock_status`
--

CREATE TABLE IF NOT EXISTS `cataloginventory_stock_status` (
  `product_id` int(10) unsigned NOT NULL,
  `website_id` smallint(5) unsigned NOT NULL,
  `stock_id` smallint(4) unsigned NOT NULL,
  `qty` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `stock_status` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`product_id`,`website_id`,`stock_id`),
  KEY `FK_CATALOGINVENTORY_STOCK_STATUS_STOCK` (`stock_id`),
  KEY `FK_CATALOGINVENTORY_STOCK_STATUS_WEBSITE` (`website_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `catalogrule`
--

CREATE TABLE IF NOT EXISTS `catalogrule` (
  `rule_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `description` text NOT NULL,
  `from_date` date DEFAULT NULL,
  `to_date` date DEFAULT NULL,
  `customer_group_ids` varchar(255) NOT NULL DEFAULT '',
  `is_active` tinyint(1) NOT NULL DEFAULT '0',
  `conditions_serialized` mediumtext NOT NULL,
  `actions_serialized` mediumtext NOT NULL,
  `stop_rules_processing` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int(10) unsigned NOT NULL DEFAULT '0',
  `simple_action` varchar(32) NOT NULL,
  `discount_amount` decimal(12,4) NOT NULL,
  `website_ids` text,
  PRIMARY KEY (`rule_id`),
  KEY `sort_order` (`is_active`,`sort_order`,`to_date`,`from_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `catalogrule_affected_product`
--

CREATE TABLE IF NOT EXISTS `catalogrule_affected_product` (
  `product_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `catalogrule_product`
--

CREATE TABLE IF NOT EXISTS `catalogrule_product` (
  `rule_product_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `rule_id` int(10) unsigned NOT NULL DEFAULT '0',
  `from_time` int(10) unsigned NOT NULL DEFAULT '0',
  `to_time` int(10) unsigned NOT NULL DEFAULT '0',
  `customer_group_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `product_id` int(10) unsigned NOT NULL DEFAULT '0',
  `action_operator` enum('to_fixed','to_percent','by_fixed','by_percent') NOT NULL DEFAULT 'to_fixed',
  `action_amount` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `action_stop` tinyint(1) NOT NULL DEFAULT '0',
  `sort_order` int(10) unsigned NOT NULL DEFAULT '0',
  `website_id` smallint(5) unsigned NOT NULL,
  PRIMARY KEY (`rule_product_id`),
  UNIQUE KEY `sort_order` (`rule_id`,`from_time`,`to_time`,`website_id`,`customer_group_id`,`product_id`,`sort_order`),
  KEY `FK_catalogrule_product_rule` (`rule_id`),
  KEY `FK_catalogrule_product_customergroup` (`customer_group_id`),
  KEY `FK_catalogrule_product_website` (`website_id`),
  KEY `FK_CATALOGRULE_PRODUCT_PRODUCT` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `catalogrule_product_price`
--

CREATE TABLE IF NOT EXISTS `catalogrule_product_price` (
  `rule_product_price_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `rule_date` date NOT NULL DEFAULT '0000-00-00',
  `customer_group_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `product_id` int(10) unsigned NOT NULL DEFAULT '0',
  `rule_price` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `website_id` smallint(5) unsigned NOT NULL,
  `latest_start_date` date DEFAULT NULL,
  `earliest_end_date` date DEFAULT NULL,
  PRIMARY KEY (`rule_product_price_id`),
  UNIQUE KEY `rule_date` (`rule_date`,`website_id`,`customer_group_id`,`product_id`),
  KEY `FK_catalogrule_product_price_customergroup` (`customer_group_id`),
  KEY `FK_catalogrule_product_price_website` (`website_id`),
  KEY `FK_CATALOGRULE_PRODUCT_PRICE_PRODUCT` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `catalogsearch_fulltext`
--

CREATE TABLE IF NOT EXISTS `catalogsearch_fulltext` (
  `product_id` int(10) unsigned NOT NULL,
  `store_id` smallint(5) unsigned NOT NULL,
  `data_index` longtext NOT NULL,
  PRIMARY KEY (`product_id`,`store_id`),
  FULLTEXT KEY `data_index` (`data_index`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `catalogsearch_query`
--

CREATE TABLE IF NOT EXISTS `catalogsearch_query` (
  `query_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `query_text` varchar(255) NOT NULL DEFAULT '',
  `num_results` int(10) unsigned NOT NULL DEFAULT '0',
  `popularity` int(10) unsigned NOT NULL DEFAULT '0',
  `redirect` varchar(255) NOT NULL DEFAULT '',
  `synonim_for` varchar(255) NOT NULL DEFAULT '',
  `store_id` smallint(5) unsigned NOT NULL,
  `display_in_terms` tinyint(1) NOT NULL DEFAULT '1',
  `is_active` tinyint(1) DEFAULT '1',
  `is_processed` tinyint(1) DEFAULT '0',
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`query_id`),
  KEY `FK_CATALOGSEARCH_QUERY_STORE` (`store_id`),
  KEY `IDX_SEARCH_QUERY` (`query_text`,`store_id`,`popularity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `catalogsearch_result`
--

CREATE TABLE IF NOT EXISTS `catalogsearch_result` (
  `query_id` int(10) unsigned NOT NULL,
  `product_id` int(10) unsigned NOT NULL,
  `relevance` decimal(6,4) NOT NULL DEFAULT '0.0000',
  PRIMARY KEY (`query_id`,`product_id`),
  KEY `IDX_QUERY` (`query_id`),
  KEY `IDX_PRODUCT` (`product_id`),
  KEY `IDX_RELEVANCE` (`query_id`,`relevance`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `catalog_category_entity`
--

CREATE TABLE IF NOT EXISTS `catalog_category_entity` (
  `entity_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `entity_type_id` smallint(8) unsigned NOT NULL DEFAULT '0',
  `attribute_set_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `parent_id` int(10) unsigned NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `path` varchar(255) NOT NULL,
  `position` int(11) NOT NULL,
  `level` int(11) NOT NULL,
  `children_count` int(11) NOT NULL,
  PRIMARY KEY (`entity_id`),
  KEY `IDX_LEVEL` (`level`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Category Entities' AUTO_INCREMENT=50 ;

--
-- Table structure for table `catalog_category_entity_datetime`
--

CREATE TABLE IF NOT EXISTS `catalog_category_entity_datetime` (
  `value_id` int(11) NOT NULL AUTO_INCREMENT,
  `entity_type_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `attribute_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `entity_id` int(10) unsigned NOT NULL DEFAULT '0',
  `value` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`value_id`),
  UNIQUE KEY `IDX_BASE` (`entity_type_id`,`entity_id`,`attribute_id`,`store_id`),
  KEY `FK_ATTRIBUTE_DATETIME_ENTITY` (`entity_id`),
  KEY `FK_CATALOG_CATEGORY_ENTITY_DATETIME_ATTRIBUTE` (`attribute_id`),
  KEY `FK_CATALOG_CATEGORY_ENTITY_DATETIME_STORE` (`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `catalog_category_entity_decimal`
--

CREATE TABLE IF NOT EXISTS `catalog_category_entity_decimal` (
  `value_id` int(11) NOT NULL AUTO_INCREMENT,
  `entity_type_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `attribute_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `entity_id` int(10) unsigned NOT NULL DEFAULT '0',
  `value` decimal(12,4) NOT NULL DEFAULT '0.0000',
  PRIMARY KEY (`value_id`),
  UNIQUE KEY `IDX_BASE` (`entity_type_id`,`entity_id`,`attribute_id`,`store_id`),
  KEY `FK_ATTRIBUTE_DECIMAL_ENTITY` (`entity_id`),
  KEY `FK_CATALOG_CATEGORY_ENTITY_DECIMAL_ATTRIBUTE` (`attribute_id`),
  KEY `FK_CATALOG_CATEGORY_ENTITY_DECIMAL_STORE` (`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `catalog_category_entity_int`
--

CREATE TABLE IF NOT EXISTS `catalog_category_entity_int` (
  `value_id` int(11) NOT NULL AUTO_INCREMENT,
  `entity_type_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `attribute_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `entity_id` int(10) unsigned NOT NULL DEFAULT '0',
  `value` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`value_id`),
  UNIQUE KEY `IDX_BASE` (`entity_type_id`,`entity_id`,`attribute_id`,`store_id`),
  KEY `FK_ATTRIBUTE_INT_ENTITY` (`entity_id`),
  KEY `FK_CATALOG_CATEGORY_EMTITY_INT_ATTRIBUTE` (`attribute_id`),
  KEY `FK_CATALOG_CATEGORY_EMTITY_INT_STORE` (`store_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=146 ;

--
-- Table structure for table `catalog_category_entity_text`
--

CREATE TABLE IF NOT EXISTS `catalog_category_entity_text` (
  `value_id` int(11) NOT NULL AUTO_INCREMENT,
  `entity_type_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `attribute_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `entity_id` int(10) unsigned NOT NULL DEFAULT '0',
  `value` text NOT NULL,
  PRIMARY KEY (`value_id`),
  UNIQUE KEY `IDX_BASE` (`entity_type_id`,`entity_id`,`attribute_id`,`store_id`),
  KEY `FK_ATTRIBUTE_TEXT_ENTITY` (`entity_id`),
  KEY `FK_CATALOG_CATEGORY_ENTITY_TEXT_ATTRIBUTE` (`attribute_id`),
  KEY `FK_CATALOG_CATEGORY_ENTITY_TEXT_STORE` (`store_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=241 ;

--
-- Table structure for table `catalog_category_entity_varchar`
--

CREATE TABLE IF NOT EXISTS `catalog_category_entity_varchar` (
  `value_id` int(11) NOT NULL AUTO_INCREMENT,
  `entity_type_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `attribute_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `entity_id` int(10) unsigned NOT NULL DEFAULT '0',
  `value` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`value_id`),
  UNIQUE KEY `IDX_BASE` (`entity_type_id`,`entity_id`,`attribute_id`,`store_id`) USING BTREE,
  KEY `FK_ATTRIBUTE_VARCHAR_ENTITY` (`entity_id`),
  KEY `FK_CATALOG_CATEGORY_ENTITY_VARCHAR_ATTRIBUTE` (`attribute_id`),
  KEY `FK_CATALOG_CATEGORY_ENTITY_VARCHAR_STORE` (`store_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=386 ;

--
-- Table structure for table `catalog_category_flat`
--

CREATE TABLE IF NOT EXISTS `catalog_category_flat` (
  `entity_id` int(10) unsigned NOT NULL,
  `store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `parent_id` int(10) unsigned NOT NULL DEFAULT '0',
  `path` varchar(255) NOT NULL DEFAULT '',
  `level` int(11) NOT NULL DEFAULT '0',
  `position` int(11) NOT NULL DEFAULT '0',
  `children_count` int(11) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  KEY `CATEGORY_FLAT_CATEGORY_ID` (`entity_id`),
  KEY `CATEGORY_FLAT_STORE_ID` (`store_id`),
  KEY `path` (`path`),
  KEY `IDX_LEVEL` (`level`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Flat Category';

--
-- Table structure for table `catalog_category_product`
--

CREATE TABLE IF NOT EXISTS `catalog_category_product` (
  `category_id` int(10) unsigned NOT NULL DEFAULT '0',
  `product_id` int(10) unsigned NOT NULL DEFAULT '0',
  `position` int(10) unsigned NOT NULL DEFAULT '0',
  UNIQUE KEY `UNQ_CATEGORY_PRODUCT` (`category_id`,`product_id`),
  KEY `CATALOG_CATEGORY_PRODUCT_CATEGORY` (`category_id`),
  KEY `CATALOG_CATEGORY_PRODUCT_PRODUCT` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `catalog_category_product_index`
--

CREATE TABLE IF NOT EXISTS `catalog_category_product_index` (
  `category_id` int(10) unsigned NOT NULL DEFAULT '0',
  `product_id` int(10) unsigned NOT NULL DEFAULT '0',
  `position` int(10) unsigned NOT NULL DEFAULT '0',
  `is_parent` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `visibility` tinyint(3) unsigned NOT NULL,
  UNIQUE KEY `UNQ_CATEGORY_PRODUCT` (`category_id`,`product_id`,`is_parent`,`store_id`),
  KEY `FK_CATALOG_CATEGORY_PRODUCT_INDEX_CATEGORY_ENTITY` (`category_id`),
  KEY `IDX_JOIN` (`product_id`,`store_id`,`category_id`,`visibility`),
  KEY `IDX_BASE` (`store_id`,`category_id`,`visibility`,`is_parent`,`position`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `catalog_compare_item`
--

CREATE TABLE IF NOT EXISTS `catalog_compare_item` (
  `catalog_compare_item_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `visitor_id` int(11) unsigned NOT NULL DEFAULT '0',
  `customer_id` int(11) unsigned DEFAULT NULL,
  `product_id` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`catalog_compare_item_id`),
  KEY `FK_CATALOG_COMPARE_ITEM_CUSTOMER` (`customer_id`),
  KEY `FK_CATALOG_COMPARE_ITEM_PRODUCT` (`product_id`),
  KEY `IDX_VISITOR_PRODUCTS` (`visitor_id`,`product_id`),
  KEY `IDX_CUSTOMER_PRODUCTS` (`customer_id`,`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `catalog_product_bundle_option`
--

CREATE TABLE IF NOT EXISTS `catalog_product_bundle_option` (
  `option_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `parent_id` int(10) unsigned NOT NULL,
  `required` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `position` int(10) unsigned NOT NULL DEFAULT '0',
  `type` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`option_id`),
  KEY `FK_CATALOG_PRODUCT_BUNDLE_OPTION_PARENT` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Bundle Options' AUTO_INCREMENT=1 ;

--
-- Table structure for table `catalog_product_bundle_option_value`
--

CREATE TABLE IF NOT EXISTS `catalog_product_bundle_option_value` (
  `value_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `option_id` int(10) unsigned NOT NULL,
  `store_id` smallint(5) unsigned NOT NULL,
  `title` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`value_id`),
  KEY `FK_CATALOG_PRODUCT_BUNDLE_OPTION_VALUE_OPTION` (`option_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Bundle Selections' AUTO_INCREMENT=1 ;

--
-- Table structure for table `catalog_product_bundle_price_index`
--

CREATE TABLE IF NOT EXISTS `catalog_product_bundle_price_index` (
  `entity_id` int(10) unsigned NOT NULL,
  `website_id` smallint(5) unsigned NOT NULL,
  `customer_group_id` smallint(3) unsigned NOT NULL,
  `min_price` decimal(12,4) NOT NULL,
  `max_price` decimal(12,4) NOT NULL,
  PRIMARY KEY (`entity_id`,`website_id`,`customer_group_id`),
  KEY `IDX_WEBSITE` (`website_id`),
  KEY `IDX_CUSTOMER_GROUP` (`customer_group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `catalog_product_bundle_selection`
--

CREATE TABLE IF NOT EXISTS `catalog_product_bundle_selection` (
  `selection_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `option_id` int(10) unsigned NOT NULL,
  `parent_product_id` int(10) unsigned NOT NULL,
  `product_id` int(10) unsigned NOT NULL,
  `position` int(10) unsigned NOT NULL DEFAULT '0',
  `is_default` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `selection_price_type` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `selection_price_value` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `selection_qty` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `selection_can_change_qty` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`selection_id`),
  KEY `FK_CATALOG_PRODUCT_BUNDLE_SELECTION_OPTION` (`option_id`),
  KEY `FK_CATALOG_PRODUCT_BUNDLE_SELECTION_PRODUCT` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Bundle Selections' AUTO_INCREMENT=1 ;

--
-- Table structure for table `catalog_product_enabled_index`
--

CREATE TABLE IF NOT EXISTS `catalog_product_enabled_index` (
  `product_id` int(10) unsigned NOT NULL DEFAULT '0',
  `store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `visibility` smallint(5) unsigned NOT NULL DEFAULT '0',
  UNIQUE KEY `UNQ_PRODUCT_STORE` (`product_id`,`store_id`),
  KEY `IDX_PRODUCT_VISIBILITY_IN_STORE` (`product_id`,`store_id`,`visibility`),
  KEY `FK_CATALOG_PRODUCT_ENABLED_INDEX_STORE` (`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `catalog_product_entity`
--

CREATE TABLE IF NOT EXISTS `catalog_product_entity` (
  `entity_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `entity_type_id` smallint(8) unsigned NOT NULL DEFAULT '0',
  `attribute_set_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `type_id` varchar(32) NOT NULL DEFAULT 'simple',
  `sku` varchar(64) DEFAULT NULL,
  `category_ids` text,
  `created_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `has_options` smallint(1) NOT NULL DEFAULT '0',
  `required_options` tinyint(1) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`entity_id`),
  KEY `FK_CATALOG_PRODUCT_ENTITY_ENTITY_TYPE` (`entity_type_id`),
  KEY `FK_CATALOG_PRODUCT_ENTITY_ATTRIBUTE_SET_ID` (`attribute_set_id`),
  KEY `sku` (`sku`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Product Entities' AUTO_INCREMENT=2 ;

--
-- Table structure for table `catalog_product_entity_datetime`
--

CREATE TABLE IF NOT EXISTS `catalog_product_entity_datetime` (
  `value_id` int(11) NOT NULL AUTO_INCREMENT,
  `entity_type_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `attribute_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `entity_id` int(10) unsigned NOT NULL DEFAULT '0',
  `value` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`value_id`),
  UNIQUE KEY `IDX_ATTRIBUTE_VALUE` (`entity_id`,`attribute_id`,`store_id`),
  KEY `FK_CATALOG_PRODUCT_ENTITY_DATETIME_ATTRIBUTE` (`attribute_id`),
  KEY `FK_CATALOG_PRODUCT_ENTITY_DATETIME_STORE` (`store_id`),
  KEY `FK_CATALOG_PRODUCT_ENTITY_DATETIME_PRODUCT_ENTITY` (`entity_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Table structure for table `catalog_product_entity_decimal`
--

CREATE TABLE IF NOT EXISTS `catalog_product_entity_decimal` (
  `value_id` int(11) NOT NULL AUTO_INCREMENT,
  `entity_type_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `attribute_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `entity_id` int(10) unsigned NOT NULL DEFAULT '0',
  `value` decimal(12,4) NOT NULL DEFAULT '0.0000',
  PRIMARY KEY (`value_id`),
  UNIQUE KEY `IDX_ATTRIBUTE_VALUE` (`entity_id`,`attribute_id`,`store_id`),
  KEY `FK_CATALOG_PRODUCT_ENTITY_DECIMAL_STORE` (`store_id`),
  KEY `FK_CATALOG_PRODUCT_ENTITY_DECIMAL_PRODUCT_ENTITY` (`entity_id`),
  KEY `FK_CATALOG_PRODUCT_ENTITY_DECIMAL_ATTRIBUTE` (`attribute_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;

--
-- Table structure for table `catalog_product_entity_gallery`
--

CREATE TABLE IF NOT EXISTS `catalog_product_entity_gallery` (
  `value_id` int(11) NOT NULL AUTO_INCREMENT,
  `entity_type_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `attribute_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `entity_id` int(10) unsigned NOT NULL DEFAULT '0',
  `position` int(11) NOT NULL DEFAULT '0',
  `value` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`value_id`),
  UNIQUE KEY `IDX_BASE` (`entity_type_id`,`entity_id`,`attribute_id`,`store_id`),
  KEY `FK_ATTRIBUTE_GALLERY_ENTITY` (`entity_id`),
  KEY `FK_CATALOG_CATEGORY_ENTITY_GALLERY_ATTRIBUTE` (`attribute_id`),
  KEY `FK_CATALOG_CATEGORY_ENTITY_GALLERY_STORE` (`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `catalog_product_entity_int`
--

CREATE TABLE IF NOT EXISTS `catalog_product_entity_int` (
  `value_id` int(11) NOT NULL AUTO_INCREMENT,
  `entity_type_id` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `attribute_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `entity_id` int(10) unsigned NOT NULL DEFAULT '0',
  `value` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`value_id`),
  UNIQUE KEY `IDX_ATTRIBUTE_VALUE` (`entity_id`,`attribute_id`,`store_id`),
  KEY `FK_CATALOG_PRODUCT_ENTITY_INT_ATTRIBUTE` (`attribute_id`),
  KEY `FK_CATALOG_PRODUCT_ENTITY_INT_STORE` (`store_id`),
  KEY `FK_CATALOG_PRODUCT_ENTITY_INT_PRODUCT_ENTITY` (`entity_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=6 ;

--
-- Table structure for table `catalog_product_entity_media_gallery`
--

CREATE TABLE IF NOT EXISTS `catalog_product_entity_media_gallery` (
  `value_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `attribute_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `entity_id` int(10) unsigned NOT NULL DEFAULT '0',
  `value` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`value_id`),
  KEY `FK_CATALOG_PRODUCT_MEDIA_GALLERY_ATTRIBUTE` (`attribute_id`),
  KEY `FK_CATALOG_PRODUCT_MEDIA_GALLERY_ENTITY` (`entity_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Catalog product media gallery' AUTO_INCREMENT=2 ;

--
-- Table structure for table `catalog_product_entity_media_gallery_value`
--

CREATE TABLE IF NOT EXISTS `catalog_product_entity_media_gallery_value` (
  `value_id` int(11) unsigned NOT NULL DEFAULT '0',
  `store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `label` varchar(255) DEFAULT NULL,
  `position` int(11) unsigned DEFAULT NULL,
  `disabled` tinyint(1) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`value_id`,`store_id`),
  KEY `FK_CATALOG_PRODUCT_MEDIA_GALLERY_VALUE_STORE` (`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Catalog product media gallery values';

--
-- Table structure for table `catalog_product_entity_text`
--

CREATE TABLE IF NOT EXISTS `catalog_product_entity_text` (
  `value_id` int(11) NOT NULL AUTO_INCREMENT,
  `entity_type_id` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `attribute_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `entity_id` int(10) unsigned NOT NULL DEFAULT '0',
  `value` text NOT NULL,
  PRIMARY KEY (`value_id`),
  UNIQUE KEY `IDX_ATTRIBUTE_VALUE` (`entity_id`,`attribute_id`,`store_id`),
  KEY `FK_CATALOG_PRODUCT_ENTITY_TEXT_ATTRIBUTE` (`attribute_id`),
  KEY `FK_CATALOG_PRODUCT_ENTITY_TEXT_STORE` (`store_id`),
  KEY `FK_CATALOG_PRODUCT_ENTITY_TEXT_PRODUCT_ENTITY` (`entity_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=6 ;

--
-- Table structure for table `catalog_product_entity_tier_price`
--

CREATE TABLE IF NOT EXISTS `catalog_product_entity_tier_price` (
  `value_id` int(11) NOT NULL AUTO_INCREMENT,
  `entity_id` int(10) unsigned NOT NULL DEFAULT '0',
  `all_groups` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `customer_group_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `qty` decimal(12,4) NOT NULL DEFAULT '1.0000',
  `value` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `website_id` smallint(5) unsigned NOT NULL,
  PRIMARY KEY (`value_id`),
  KEY `FK_CATALOG_PRODUCT_ENTITY_TIER_PRICE_PRODUCT_ENTITY` (`entity_id`),
  KEY `FK_CATALOG_PRODUCT_ENTITY_TIER_PRICE_GROUP` (`customer_group_id`),
  KEY `FK_CATALOG_PRODUCT_TIER_WEBSITE` (`website_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `catalog_product_entity_varchar`
--

CREATE TABLE IF NOT EXISTS `catalog_product_entity_varchar` (
  `value_id` int(11) NOT NULL AUTO_INCREMENT,
  `entity_type_id` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `attribute_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `entity_id` int(10) unsigned NOT NULL DEFAULT '0',
  `value` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`value_id`),
  UNIQUE KEY `IDX_ATTRIBUTE_VALUE` (`entity_id`,`attribute_id`,`store_id`),
  KEY `FK_CATALOG_PRODUCT_ENTITY_VARCHAR_ATTRIBUTE` (`attribute_id`),
  KEY `FK_CATALOG_PRODUCT_ENTITY_VARCHAR_STORE` (`store_id`),
  KEY `FK_CATALOG_PRODUCT_ENTITY_VARCHAR_PRODUCT_ENTITY` (`entity_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=26 ;

--
-- Table structure for table `catalog_product_link`
--

CREATE TABLE IF NOT EXISTS `catalog_product_link` (
  `link_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `product_id` int(10) unsigned NOT NULL DEFAULT '0',
  `linked_product_id` int(10) unsigned NOT NULL DEFAULT '0',
  `link_type_id` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`link_id`),
  KEY `FK_LINK_PRODUCT` (`product_id`),
  KEY `FK_LINKED_PRODUCT` (`linked_product_id`),
  KEY `FK_PRODUCT_LINK_TYPE` (`link_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Related products' AUTO_INCREMENT=1 ;

--
-- Table structure for table `catalog_product_link_attribute`
--

CREATE TABLE IF NOT EXISTS `catalog_product_link_attribute` (
  `product_link_attribute_id` smallint(6) unsigned NOT NULL AUTO_INCREMENT,
  `link_type_id` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `product_link_attribute_code` varchar(32) NOT NULL DEFAULT '',
  `data_type` varchar(32) NOT NULL DEFAULT '',
  PRIMARY KEY (`product_link_attribute_id`),
  KEY `FK_ATTRIBUTE_PRODUCT_LINK_TYPE` (`link_type_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Attributes for product link' AUTO_INCREMENT=9 ;

--
-- Dumping data for table `catalog_product_link_attribute`
--

INSERT INTO `catalog_product_link_attribute` (`product_link_attribute_id`, `link_type_id`, `product_link_attribute_code`, `data_type`) VALUES
(1, 2, 'qty', 'decimal'),
(2, 1, 'position', 'int'),
(3, 4, 'position', 'int'),
(4, 5, 'position', 'int'),
(6, 1, 'qty', 'decimal'),
(7, 3, 'position', 'int'),
(8, 3, 'qty', 'decimal');

--
-- Table structure for table `catalog_product_link_attribute_decimal`
--

CREATE TABLE IF NOT EXISTS `catalog_product_link_attribute_decimal` (
  `value_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `product_link_attribute_id` smallint(6) unsigned DEFAULT NULL,
  `link_id` int(11) unsigned DEFAULT NULL,
  `value` decimal(12,4) NOT NULL DEFAULT '0.0000',
  PRIMARY KEY (`value_id`),
  KEY `FK_DECIMAL_PRODUCT_LINK_ATTRIBUTE` (`product_link_attribute_id`),
  KEY `FK_DECIMAL_LINK` (`link_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Decimal attributes values' AUTO_INCREMENT=1 ;

--
-- Table structure for table `catalog_product_link_attribute_int`
--

CREATE TABLE IF NOT EXISTS `catalog_product_link_attribute_int` (
  `value_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `product_link_attribute_id` smallint(6) unsigned DEFAULT NULL,
  `link_id` int(11) unsigned DEFAULT NULL,
  `value` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`value_id`),
  KEY `FK_INT_PRODUCT_LINK_ATTRIBUTE` (`product_link_attribute_id`),
  KEY `FK_INT_PRODUCT_LINK` (`link_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `catalog_product_link_attribute_varchar`
--

CREATE TABLE IF NOT EXISTS `catalog_product_link_attribute_varchar` (
  `value_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `product_link_attribute_id` smallint(6) unsigned NOT NULL DEFAULT '0',
  `link_id` int(11) unsigned DEFAULT NULL,
  `value` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`value_id`),
  KEY `FK_VARCHAR_PRODUCT_LINK_ATTRIBUTE` (`product_link_attribute_id`),
  KEY `FK_VARCHAR_LINK` (`link_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Varchar attributes values' AUTO_INCREMENT=1 ;

--
-- Table structure for table `catalog_product_link_type`
--

CREATE TABLE IF NOT EXISTS `catalog_product_link_type` (
  `link_type_id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(32) NOT NULL DEFAULT '',
  PRIMARY KEY (`link_type_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Types of product link(Related, superproduct, bundles)' AUTO_INCREMENT=6 ;

--
-- Dumping data for table `catalog_product_link_type`
--

INSERT INTO `catalog_product_link_type` (`link_type_id`, `code`) VALUES
(1, 'relation'),
(2, 'bundle'),
(3, 'super'),
(4, 'up_sell'),
(5, 'cross_sell');

--
-- Table structure for table `catalog_product_option`
--

CREATE TABLE IF NOT EXISTS `catalog_product_option` (
  `option_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `product_id` int(10) unsigned NOT NULL DEFAULT '0',
  `type` varchar(50) NOT NULL DEFAULT '',
  `is_require` tinyint(1) NOT NULL DEFAULT '1',
  `sku` varchar(64) NOT NULL DEFAULT '',
  `max_characters` int(10) unsigned DEFAULT NULL,
  `file_extension` varchar(50) DEFAULT NULL,
  `image_size_x` smallint(5) unsigned NOT NULL,
  `image_size_y` smallint(5) unsigned NOT NULL,
  `sort_order` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`option_id`),
  KEY `CATALOG_PRODUCT_OPTION_PRODUCT` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `catalog_product_option_price`
--

CREATE TABLE IF NOT EXISTS `catalog_product_option_price` (
  `option_price_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `option_id` int(10) unsigned NOT NULL DEFAULT '0',
  `store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `price` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `price_type` enum('fixed','percent') NOT NULL DEFAULT 'fixed',
  PRIMARY KEY (`option_price_id`),
  KEY `CATALOG_PRODUCT_OPTION_PRICE_OPTION` (`option_id`),
  KEY `CATALOG_PRODUCT_OPTION_TITLE_STORE` (`store_id`),
  KEY `IDX_CATALOG_PRODUCT_OPTION_PRICE_SI_OI` (`store_id`,`option_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `catalog_product_option_title`
--

CREATE TABLE IF NOT EXISTS `catalog_product_option_title` (
  `option_title_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `option_id` int(10) unsigned NOT NULL DEFAULT '0',
  `store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `title` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`option_title_id`),
  KEY `CATALOG_PRODUCT_OPTION_TITLE_OPTION` (`option_id`),
  KEY `CATALOG_PRODUCT_OPTION_TITLE_STORE` (`store_id`),
  KEY `IDX_CATALOG_PRODUCT_OPTION_TITLE_SI_OI` (`store_id`,`option_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `catalog_product_option_type_price`
--

CREATE TABLE IF NOT EXISTS `catalog_product_option_type_price` (
  `option_type_price_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `option_type_id` int(10) unsigned NOT NULL DEFAULT '0',
  `store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `price` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `price_type` enum('fixed','percent') NOT NULL DEFAULT 'fixed',
  PRIMARY KEY (`option_type_price_id`),
  KEY `CATALOG_PRODUCT_OPTION_TYPE_PRICE_OPTION_TYPE` (`option_type_id`),
  KEY `CATALOG_PRODUCT_OPTION_TYPE_PRICE_STORE` (`store_id`),
  KEY `IDX_CATALOG_PRODUCT_OPTION_TYPE_PRICE_SI_OTI` (`store_id`,`option_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `catalog_product_option_type_title`
--

CREATE TABLE IF NOT EXISTS `catalog_product_option_type_title` (
  `option_type_title_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `option_type_id` int(10) unsigned NOT NULL DEFAULT '0',
  `store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `title` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`option_type_title_id`),
  KEY `CATALOG_PRODUCT_OPTION_TYPE_TITLE_OPTION` (`option_type_id`),
  KEY `CATALOG_PRODUCT_OPTION_TYPE_TITLE_STORE` (`store_id`),
  KEY `IDX_CATALOG_PRODUCT_OPTION_TYPE_TITLE_SI_OTI` (`store_id`,`option_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `catalog_product_option_type_value`
--

CREATE TABLE IF NOT EXISTS `catalog_product_option_type_value` (
  `option_type_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `option_id` int(10) unsigned NOT NULL DEFAULT '0',
  `sku` varchar(64) NOT NULL DEFAULT '',
  `sort_order` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`option_type_id`),
  KEY `CATALOG_PRODUCT_OPTION_TYPE_VALUE_OPTION` (`option_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `catalog_product_super_attribute`
--

CREATE TABLE IF NOT EXISTS `catalog_product_super_attribute` (
  `product_super_attribute_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `product_id` int(10) unsigned NOT NULL DEFAULT '0',
  `attribute_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `position` smallint(5) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`product_super_attribute_id`),
  KEY `FK_SUPER_PRODUCT_ATTRIBUTE_PRODUCT` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `catalog_product_super_attribute_label`
--

CREATE TABLE IF NOT EXISTS `catalog_product_super_attribute_label` (
  `value_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `product_super_attribute_id` int(10) unsigned NOT NULL DEFAULT '0',
  `store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `value` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`value_id`),
  KEY `FK_SUPER_PRODUCT_ATTRIBUTE_LABEL` (`product_super_attribute_id`),
  KEY `IDX_CATALOG_PRODUCT_SUPER_ATTRIBUTE_STORE_PSAI_SI` (`product_super_attribute_id`,`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC AUTO_INCREMENT=1 ;

--
-- Table structure for table `catalog_product_super_attribute_pricing`
--

CREATE TABLE IF NOT EXISTS `catalog_product_super_attribute_pricing` (
  `value_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `product_super_attribute_id` int(10) unsigned NOT NULL DEFAULT '0',
  `value_index` varchar(255) NOT NULL DEFAULT '',
  `is_percent` tinyint(1) unsigned DEFAULT '0',
  `pricing_value` decimal(10,4) DEFAULT NULL,
  `website_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`value_id`),
  KEY `FK_SUPER_PRODUCT_ATTRIBUTE_PRICING` (`product_super_attribute_id`),
  KEY `FK_CATALOG_PRODUCT_SUPER_PRICE_WEBSITE` (`website_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `catalog_product_super_link`
--

CREATE TABLE IF NOT EXISTS `catalog_product_super_link` (
  `link_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `product_id` int(10) unsigned NOT NULL DEFAULT '0',
  `parent_id` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`link_id`),
  KEY `FK_SUPER_PRODUCT_LINK_PARENT` (`parent_id`),
  KEY `FK_catalog_product_super_link` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `catalog_product_website`
--

CREATE TABLE IF NOT EXISTS `catalog_product_website` (
  `product_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `website_id` smallint(5) unsigned NOT NULL,
  PRIMARY KEY (`product_id`,`website_id`),
  KEY `FK_CATALOG_PRODUCT_WEBSITE_WEBSITE` (`website_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED AUTO_INCREMENT=2 ;

--
-- Table structure for table `checkout_agreement`
--

CREATE TABLE IF NOT EXISTS `checkout_agreement` (
  `agreement_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `content` text NOT NULL,
  `content_height` varchar(25) DEFAULT NULL,
  `checkbox_text` text NOT NULL,
  `is_active` tinyint(4) NOT NULL DEFAULT '0',
  `is_html` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`agreement_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `checkout_agreement_store`
--

CREATE TABLE IF NOT EXISTS `checkout_agreement_store` (
  `agreement_id` int(10) unsigned NOT NULL,
  `store_id` smallint(5) unsigned NOT NULL,
  UNIQUE KEY `agreement_id` (`agreement_id`,`store_id`),
  KEY `FK_CHECKOUT_AGREEMENT_STORE` (`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `cms_block`
--

CREATE TABLE IF NOT EXISTS `cms_block` (
  `block_id` smallint(6) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL DEFAULT '',
  `identifier` varchar(255) NOT NULL DEFAULT '',
  `content` text,
  `creation_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`block_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='CMS Blocks' AUTO_INCREMENT=6 ;

--
-- Dumping data for table `cms_block`
--

INSERT INTO `cms_block` (`block_id`, `title`, `identifier`, `content`, `creation_time`, `update_time`, `is_active`) VALUES
(5, 'Footer Links', 'footer_links', '<ul>\r\n<li><a href="{{store url=""}}about-magento-demo-store">About Us</a></li>\r\n<li class="last"><a href="{{store url=""}}customer-service">Customer Service</a></li>\r\n</ul>', '2009-10-15 15:05:20', '2009-10-15 15:05:20', 1);

--
-- Table structure for table `cms_block_store`
--

CREATE TABLE IF NOT EXISTS `cms_block_store` (
  `block_id` smallint(6) NOT NULL,
  `store_id` smallint(5) unsigned NOT NULL,
  PRIMARY KEY (`block_id`,`store_id`),
  KEY `FK_CMS_BLOCK_STORE_STORE` (`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='CMS Blocks to Stores';

--
-- Dumping data for table `cms_block_store`
--

INSERT INTO `cms_block_store` (`block_id`, `store_id`) VALUES
(5, 0);

--
-- Table structure for table `cms_page`
--

CREATE TABLE IF NOT EXISTS `cms_page` (
  `page_id` smallint(6) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL DEFAULT '',
  `root_template` varchar(255) NOT NULL DEFAULT '',
  `meta_keywords` text NOT NULL,
  `meta_description` text NOT NULL,
  `identifier` varchar(100) NOT NULL DEFAULT '',
  `content` text,
  `creation_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` tinyint(4) NOT NULL DEFAULT '0',
  `layout_update_xml` text,
  `custom_theme` varchar(100) DEFAULT NULL,
  `custom_theme_from` date DEFAULT NULL,
  `custom_theme_to` date DEFAULT NULL,
  PRIMARY KEY (`page_id`),
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='CMS pages' AUTO_INCREMENT=6 ;

--
-- Dumping data for table `cms_page`
--

INSERT INTO `cms_page` (`page_id`, `title`, `root_template`, `meta_keywords`, `meta_description`, `identifier`, `content`, `creation_time`, `update_time`, `is_active`, `sort_order`, `layout_update_xml`, `custom_theme`, `custom_theme_from`, `custom_theme_to`) VALUES
(1, '404 Not Found 1', 'two_columns_right', 'Page keywords', 'Page description', 'no-route', '<div class="page-head-alt"><h3>Whoops, our bad...</h3></div>\r\n<dl>\r\n<dt>The page you requested was not found, and we have a fine guess why.</dt>\r\n<dd>\r\n<ul class="disc">\r\n<li>If you typed the URL directly, please make sure the spelling is correct.</li>\r\n<li>If you clicked on a link to get here, the link is outdated.</li>\r\n</ul></dd>\r\n</dl>\r\n<br/>\r\n<dl>\r\n<dt>What can you do?</dt>\r\n<dd>Have no fear, help is near! There are many ways you can get back on track with Magento Demo Store.</dd>\r\n<dd>\r\n<ul class="disc">\r\n<li><a href="#" onclick="history.go(-1);">Go back</a> to the previous page.</li>\r\n<li>Use the search bar at the top of the page to search for your products.</li>\r\n<li>Follow these links to get you back on track!<br/><a href="{{store url=""}}">Store Home</a><br/><a href="{{store url="customer/account"}}">My Account</a></li></ul></dd></dl><br/>\r\n<p><img src="{{skin url=''images/media/404_callout1.jpg''}}" style="margin-right:15px;"/><img src="{{skin url=''images/media/404_callout2.jpg''}}" /></p>', '2007-06-20 18:38:32', '2007-08-26 19:11:13', 1, 0, NULL, NULL, NULL, NULL),
(2, 'Home page', 'one_column', '', '', 'home', '<h1>Home Page</h1>\r\n', '2007-08-23 10:03:25', '2009-11-13 11:22:01', 1, 0, '<!--<reference name="content">\r\n<block type="catalog/product_new" name="home.catalog.product.new" alias="product_new" template="catalog/product/new.phtml" after="cms_page"><action method="addPriceBlockType"><type>bundle</type><block>bundle/catalog_product_price</block><template>bundle/catalog/product/price.phtml</template></action></block>\r\n<block type="reports/product_viewed" name="home.reports.product.viewed" alias="product_viewed" template="reports/home_product_viewed.phtml" after="product_new"><action method="addPriceBlockType"><type>bundle</type><block>bundle/catalog_product_price</block><template>bundle/catalog/product/price.phtml</template></action></block>\r\n<block type="reports/product_compared" name="home.reports.product.compared" template="reports/home_product_compared.phtml" after="product_viewed"><action method="addPriceBlockType"><type>bundle</type><block>bundle/catalog_product_price</block><template>bundle/catalog/product/price.phtml</template></action></block>\r\n</reference><reference name="right">\r\n<action method="unsetChild"><alias>right.reports.product.viewed</alias></action>\r\n<action method="unsetChild"><alias>right.reports.product.compared</alias></action>\r\n</reference>-->', '', NULL, NULL),
(3, 'About  Us', 'one_column', '', '', 'about-magento-demo-store', '<div class="page-head">\r\n<h3>About Magento  Demo Store</h3>\r\n</div>\r\n<div class="col3-set">\r\n<div class="col-1"><p><img src="{{skin url=''images/media/about_us_img.jpg''}}" alt="Varien office pic"/></p><p style="line-height:1.2em;"><small>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Morbi luctus. Duis lobortis. Nulla nec velit. Mauris pulvinar erat non massa. Suspendisse tortor turpis, porta nec, tempus vitae, iaculis semper, pede.</small></p>\r\n<p style="color:#888; font:1.2em/1.4em georgia, serif;">Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Morbi luctus. Duis lobortis. Nulla nec velit. Mauris pulvinar erat non massa. Suspendisse tortor turpis, porta nec, tempus vitae, iaculis semper, pede. Cras vel libero id lectus rhoncus porta.</p></div>\r\n<div class="col-2">\r\n<p><strong style="color:#de036f;">Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Morbi luctus. Duis lobortis. Nulla nec velit.</strong></p>\r\n<p>Vivamus tortor nisl, lobortis in, faucibus et, tempus at, dui. Nunc risus. Proin scelerisque augue. Nam ullamcorper. Phasellus id massa. Pellentesque nisl. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nunc augue. Aenean sed justo non leo vehicula laoreet. Praesent ipsum libero, auctor ac, tempus nec, tempor nec, justo. </p>\r\n<p>Maecenas ullamcorper, odio vel tempus egestas, dui orci faucibus orci, sit amet aliquet lectus dolor et quam. Pellentesque consequat luctus purus. Nunc et risus. Etiam a nibh. Phasellus dignissim metus eget nisi. Vestibulum sapien dolor, aliquet nec, porta ac, malesuada a, libero. Praesent feugiat purus eget est. Nulla facilisi. Vestibulum tincidunt sapien eu velit. Mauris purus. Maecenas eget mauris eu orci accumsan feugiat. Pellentesque eget velit. Nunc tincidunt.</p></div>\r\n<div class="col-3">\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Morbi luctus. Duis lobortis. Nulla nec velit. Mauris pulvinar erat non massa. Suspendisse tortor turpis, porta nec, tempus vitae, iaculis semper, pede. Cras vel libero id lectus rhoncus porta. Suspendisse convallis felis ac enim. Vivamus tortor nisl, lobortis in, faucibus et, tempus at, dui. Nunc risus. Proin scelerisque augue. Nam ullamcorper </p>\r\n<p><strong style="color:#de036f;">Maecenas ullamcorper, odio vel tempus egestas, dui orci faucibus orci, sit amet aliquet lectus dolor et quam. Pellentesque consequat luctus purus.</strong></p>\r\n<p>Nunc et risus. Etiam a nibh. Phasellus dignissim metus eget nisi.</p>\r\n<div class="divider"></div>\r\n<p>To all of you, from all of us at Magento Demo Store - Thank you and Happy eCommerce!</p>\r\n<p style="line-height:1.2em;"><strong style="font:italic 2em Georgia, serif;">John Doe</strong><br/><small>Some important guy</small></p></div>\r\n</div>', '2007-08-30 14:01:18', '2007-08-30 14:01:18', 1, 0, NULL, NULL, NULL, NULL),
(4, 'Customer Service', 'three_columns', '', '', 'customer-service', '<div class="page-head">\r\n<h3>Customer Service</h3>\r\n</div>\r\n<ul class="disc" style="margin-bottom:15px;">\r\n<li><a href="#answer1">Shipping & Delivery</a></li>\r\n<li><a href="#answer2">Privacy & Security</a></li>\r\n<li><a href="#answer3">Returns & Replacements</a></li>\r\n<li><a href="#answer4">Ordering</a></li>\r\n<li><a href="#answer5">Payment, Pricing & Promotions</a></li>\r\n<li><a href="#answer6">Viewing Orders</a></li>\r\n<li><a href="#answer7">Updating Account Information</a></li>\r\n</ul>\r\n<dl>\r\n<dt id="answer1">Shipping & Delivery</dt>\r\n<dd style="margin-bottom:10px;">Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Morbi luctus. Duis lobortis. Nulla nec velit. Mauris pulvinar erat non massa. Suspendisse tortor turpis, porta nec, tempus vitae, iaculis semper, pede. Cras vel libero id lectus rhoncus porta. Suspendisse convallis felis ac enim. Vivamus tortor nisl, lobortis in, faucibus et, tempus at, dui. Nunc risus. Proin scelerisque augue. Nam ullamcorper. Phasellus id massa. Pellentesque nisl. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nunc augue. Aenean sed justo non leo vehicula laoreet. Praesent ipsum libero, auctor ac, tempus nec, tempor nec, justo.</dd>\r\n<dt id="answer2">Privacy & Security</dt>\r\n<dd style="margin-bottom:10px;">Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Morbi luctus. Duis lobortis. Nulla nec velit. Mauris pulvinar erat non massa. Suspendisse tortor turpis, porta nec, tempus vitae, iaculis semper, pede. Cras vel libero id lectus rhoncus porta. Suspendisse convallis felis ac enim. Vivamus tortor nisl, lobortis in, faucibus et, tempus at, dui. Nunc risus. Proin scelerisque augue. Nam ullamcorper. Phasellus id massa. Pellentesque nisl. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nunc augue. Aenean sed justo non leo vehicula laoreet. Praesent ipsum libero, auctor ac, tempus nec, tempor nec, justo.</dd>\r\n<dt id="answer3">Returns & Replacements</dt>\r\n<dd style="margin-bottom:10px;">Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Morbi luctus. Duis lobortis. Nulla nec velit. Mauris pulvinar erat non massa. Suspendisse tortor turpis, porta nec, tempus vitae, iaculis semper, pede. Cras vel libero id lectus rhoncus porta. Suspendisse convallis felis ac enim. Vivamus tortor nisl, lobortis in, faucibus et, tempus at, dui. Nunc risus. Proin scelerisque augue. Nam ullamcorper. Phasellus id massa. Pellentesque nisl. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nunc augue. Aenean sed justo non leo vehicula laoreet. Praesent ipsum libero, auctor ac, tempus nec, tempor nec, justo.</dd>\r\n<dt id="answer4">Ordering</dt>\r\n<dd style="margin-bottom:10px;">Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Morbi luctus. Duis lobortis. Nulla nec velit. Mauris pulvinar erat non massa. Suspendisse tortor turpis, porta nec, tempus vitae, iaculis semper, pede. Cras vel libero id lectus rhoncus porta. Suspendisse convallis felis ac enim. Vivamus tortor nisl, lobortis in, faucibus et, tempus at, dui. Nunc risus. Proin scelerisque augue. Nam ullamcorper. Phasellus id massa. Pellentesque nisl. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nunc augue. Aenean sed justo non leo vehicula laoreet. Praesent ipsum libero, auctor ac, tempus nec, tempor nec, justo.</dd>\r\n<dt id="answer5">Payment, Pricing & Promotions</dt>\r\n<dd style="margin-bottom:10px;">Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Morbi luctus. Duis lobortis. Nulla nec velit. Mauris pulvinar erat non massa. Suspendisse tortor turpis, porta nec, tempus vitae, iaculis semper, pede. Cras vel libero id lectus rhoncus porta. Suspendisse convallis felis ac enim. Vivamus tortor nisl, lobortis in, faucibus et, tempus at, dui. Nunc risus. Proin scelerisque augue. Nam ullamcorper. Phasellus id massa. Pellentesque nisl. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nunc augue. Aenean sed justo non leo vehicula laoreet. Praesent ipsum libero, auctor ac, tempus nec, tempor nec, justo.</dd>\r\n<dt id="answer6">Viewing Orders</dt>\r\n<dd style="margin-bottom:10px;">Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Morbi luctus. Duis lobortis. Nulla nec velit. Mauris pulvinar erat non massa. Suspendisse tortor turpis, porta nec, tempus vitae, iaculis semper, pede. Cras vel libero id lectus rhoncus porta. Suspendisse convallis felis ac enim. Vivamus tortor nisl, lobortis in, faucibus et, tempus at, dui. Nunc risus. Proin scelerisque augue. Nam ullamcorper. Phasellus id massa. Pellentesque nisl. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nunc augue. Aenean sed justo non leo vehicula laoreet. Praesent ipsum libero, auctor ac, tempus nec, tempor nec, justo.</dd>\r\n<dt id="answer7">Updating Account Information</dt>\r\n<dd style="margin-bottom:10px;">Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Morbi luctus. Duis lobortis. Nulla nec velit. Mauris pulvinar erat non massa. Suspendisse tortor turpis, porta nec, tempus vitae, iaculis semper, pede. Cras vel libero id lectus rhoncus porta. Suspendisse convallis felis ac enim. Vivamus tortor nisl, lobortis in, faucibus et, tempus at, dui. Nunc risus. Proin scelerisque augue. Nam ullamcorper. Phasellus id massa. Pellentesque nisl. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nunc augue. Aenean sed justo non leo vehicula laoreet. Praesent ipsum libero, auctor ac, tempus nec, tempor nec, justo.</dd>\r\n</dl>', '2007-08-30 14:02:20', '2007-08-30 14:03:37', 1, 0, NULL, NULL, NULL, NULL),
(5, 'Enable Cookies', 'one_column', '', '', 'enable-cookies', '<div class="std">\r\n    <ul class="messages">\r\n        <li class="notice-msg">\r\n            <ul>\r\n                <li>Please enable cookies in your web browser to continue.</li>\r\n            </ul>\r\n        </li>\r\n    </ul>\r\n    <div class="page-head">\r\n        <h3><a name="top"></a>What are Cookies?</h3>\r\n    </div>\r\n    <p>Cookies are short pieces of data that are sent to your computer when you visit a website. On later visits, this data is then returned to that website. Cookies allow us to recognize you automatically whenever you visit our site so that we can personalize your experience and provide you with better service. We also use cookies (and similar browser data, such as Flash cookies) for fraud prevention and other purposes. If your web browser is set to refuse cookies from our website, you will not be able to complete a purchase or take advantage of certain features of our website, such as storing items in your Shopping Cart or receiving personalized recommendations. As a result, we strongly encourage you to configure your web browser to accept cookies from our website.</p>\r\n    <h3>Enabling Cookies</h3>\r\n    <ul>\r\n        <li><a href="#ie7">Internet Explorer 7.x</a></li>\r\n        <li><a href="#ie6">Internet Explorer 6.x</a></li>\r\n        <li><a href="#firefox">Mozilla/Firefox</a></li>\r\n        <li><a href="#opera">Opera 7.x</a></li>\r\n    </ul>\r\n    <h4><a name="ie7"></a>Internet Explorer 7.x</h4>\r\n    <ol>\r\n        <li>\r\n            <p>Start Internet Explorer</p>\r\n        </li>\r\n        <li>\r\n            <p>Under the <strong>Tools</strong> menu, click <strong>Internet Options</strong></p>\r\n            <p><img src="{{skin url="images/cookies/ie7-1.gif"}}" alt="" /></p>\r\n        </li>\r\n        <li>\r\n            <p>Click the <strong>Privacy</strong> tab</p>\r\n            <p><img src="{{skin url="images/cookies/ie7-2.gif"}}" alt="" /></p>\r\n        </li>\r\n        <li>\r\n            <p>Click the <strong>Advanced</strong> button</p>\r\n            <p><img src="{{skin url="images/cookies/ie7-3.gif"}}" alt="" /></p>\r\n        </li>\r\n        <li>\r\n            <p>Put a check mark in the box for <strong>Override Automatic Cookie Handling</strong>, put another check mark in the <strong>Always accept session cookies </strong>box</p>\r\n            <p><img src="{{skin url="images/cookies/ie7-4.gif"}}" alt="" /></p>\r\n        </li>\r\n        <li>\r\n            <p>Click <strong>OK</strong></p>\r\n            <p><img src="{{skin url="images/cookies/ie7-5.gif"}}" alt="" /></p>\r\n        </li>\r\n        <li>\r\n            <p>Click <strong>OK</strong></p>\r\n            <p><img src="{{skin url="images/cookies/ie7-6.gif"}}" alt="" /></p>\r\n        </li>\r\n        <li>\r\n            <p>Restart Internet Explore</p>\r\n        </li>\r\n    </ol>\r\n    <p class="a-top"><a href="#top">Back to Top</a></p>\r\n    <h4><a name="ie6"></a>Internet Explorer 6.x</h4>\r\n    <ol>\r\n        <li>\r\n            <p>Select <strong>Internet Options</strong> from the Tools menu</p>\r\n            <p><img src="{{skin url="images/cookies/ie6-1.gif"}}" alt="" /></p>\r\n        </li>\r\n        <li>\r\n            <p>Click on the <strong>Privacy</strong> tab</p>\r\n        </li>\r\n        <li>\r\n            <p>Click the <strong>Default</strong> button (or manually slide the bar down to <strong>Medium</strong>) under <strong>Settings</strong>. Click <strong>OK</strong></p>\r\n            <p><img src="{{skin url="images/cookies/ie6-2.gif"}}" alt="" /></p>\r\n        </li>\r\n    </ol>\r\n    <p class="a-top"><a href="#top">Back to Top</a></p>\r\n    <h4><a name="firefox"></a>Mozilla/Firefox</h4>\r\n    <ol>\r\n        <li>\r\n            <p>Click on the <strong>Tools</strong>-menu in Mozilla</p>\r\n        </li>\r\n        <li>\r\n            <p>Click on the <strong>Options...</strong> item in the menu - a new window open</p>\r\n        </li>\r\n        <li>\r\n            <p>Click on the <strong>Privacy</strong> selection in the left part of the window. (See image below)</p>\r\n            <p><img src="{{skin url="images/cookies/firefox.png"}}" alt="" /></p>\r\n        </li>\r\n        <li>\r\n            <p>Expand the <strong>Cookies</strong> section</p>\r\n        </li>\r\n        <li>\r\n            <p>Check the <strong>Enable cookies</strong> and <strong>Accept cookies normally</strong> checkboxes</p>\r\n        </li>\r\n        <li>\r\n            <p>Save changes by clicking <strong>Ok</strong>.</p>\r\n        </li>\r\n    </ol>\r\n    <p class="a-top"><a href="#top">Back to Top</a></p>\r\n    <h4><a name="opera"></a>Opera 7.x</h4>\r\n    <ol>\r\n        <li>\r\n            <p>Click on the <strong>Tools</strong> menu in Opera</p>\r\n        </li>\r\n        <li>\r\n            <p>Click on the <strong>Preferences...</strong> item in the menu - a new window open</p>\r\n        </li>\r\n        <li>\r\n            <p>Click on the <strong>Privacy</strong> selection near the bottom left of the window. (See image below)</p>\r\n            <p><img src="{{skin url="images/cookies/opera.png"}}" alt="" /></p>\r\n        </li>\r\n        <li>\r\n            <p>The <strong>Enable cookies</strong> checkbox must be checked, and <strong>Accept all cookies</strong> should be selected in the &quot;<strong>Normal cookies</strong>&quot; drop-down</p>\r\n        </li>\r\n        <li>\r\n            <p>Save changes by clicking <strong>Ok</strong></p>\r\n        </li>\r\n    </ol>\r\n    <p class="a-top"><a href="#top">Back to Top</a></p>\r\n</div>\r\n', '2009-10-15 09:35:23', '2009-10-15 09:35:23', 1, 0, NULL, NULL, NULL, NULL);

--
-- Table structure for table `cms_page_store`
--

CREATE TABLE IF NOT EXISTS `cms_page_store` (
  `page_id` smallint(6) NOT NULL,
  `store_id` smallint(5) unsigned NOT NULL,
  PRIMARY KEY (`page_id`,`store_id`),
  KEY `FK_CMS_PAGE_STORE_STORE` (`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='CMS Pages to Stores';

--
-- Dumping data for table `cms_page_store`
--

INSERT INTO `cms_page_store` (`page_id`, `store_id`) VALUES
(1, 0),
(2, 0),
(3, 0),
(4, 0),
(5, 0);

--
-- Table structure for table `core_config_data`
--

CREATE TABLE IF NOT EXISTS `core_config_data` (
  `config_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `scope` enum('default','websites','stores','config') NOT NULL DEFAULT 'default',
  `scope_id` int(11) NOT NULL DEFAULT '0',
  `path` varchar(255) NOT NULL DEFAULT 'general',
  `value` text NOT NULL,
  PRIMARY KEY (`config_id`),
  UNIQUE KEY `config_scope` (`scope`,`scope_id`,`path`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `core_config_data`
--

INSERT INTO `core_config_data` (`config_id`, `scope`, `scope_id`, `path`, `value`) VALUES
(1, 'default', 0, 'catalog/category/root_id', '2'),
(2, 'default', 0, 'design/theme/default', 'ekkitab'),
(3, 'default', 0, 'currency/options/base', 'INR'),
(4, 'stores', 1, 'currency/options/default', 'INR'),
(5, 'stores', 1, 'currency/options/allow', 'EUR,INR,USD'),
(6, 'stores', 1, 'currency/options/trim_sign', '0'),
(7, 'stores', 1, 'design/theme/default', 'ekkitab'),
(8, 'stores', 1, 'design/head/default_title', 'Ekkitab Education Services Pvt Ltd'),
(9, 'stores', 1, 'design/head/default_keywords', 'Ekkitab, online bookstore'),
(10, 'stores', 1, 'design/header/logo_src', 'images/logo.png'),
(11, 'stores', 1, 'design/header/logo_alt', 'Ekkitab Education Services Pvt Ltd'),
(12, 'stores', 1, 'design/header/welcome', 'Welcome Guest!'),
(13, 'stores', 1, 'design/footer/copyright', '&copy; 2009 Ekkitab Educational Services Pvt Ltd. All Rights Reserved.');

--
-- Table structure for table `core_email_template`
--

CREATE TABLE IF NOT EXISTS `core_email_template` (
  `template_id` int(7) unsigned NOT NULL AUTO_INCREMENT,
  `template_code` varchar(150) DEFAULT NULL,
  `template_text` text,
  `template_type` int(3) unsigned DEFAULT NULL,
  `template_subject` varchar(200) DEFAULT NULL,
  `template_sender_name` varchar(200) DEFAULT NULL,
  `template_sender_email` varchar(200) CHARACTER SET latin1 COLLATE latin1_general_ci DEFAULT NULL,
  `added_at` datetime DEFAULT NULL,
  `modified_at` datetime DEFAULT NULL,
  PRIMARY KEY (`template_id`),
  UNIQUE KEY `template_code` (`template_code`),
  KEY `added_at` (`added_at`),
  KEY `modified_at` (`modified_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Email templates' AUTO_INCREMENT=1 ;

--
-- Table structure for table `core_flag`
--

CREATE TABLE IF NOT EXISTS `core_flag` (
  `flag_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `flag_code` varchar(255) NOT NULL,
  `state` smallint(5) unsigned NOT NULL DEFAULT '0',
  `flag_data` text,
  `last_update` datetime NOT NULL,
  PRIMARY KEY (`flag_id`),
  KEY `last_update` (`last_update`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `core_flag`
--

INSERT INTO `core_flag` (`flag_id`, `flag_code`, `state`, `flag_data`, `last_update`) VALUES
(1, 'catalog_product_flat', 0, 'a:1:{s:8:"is_built";b:0;}', '2009-10-15 09:34:05');

--
-- Table structure for table `core_layout_link`
--

CREATE TABLE IF NOT EXISTS `core_layout_link` (
  `layout_link_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `package` varchar(64) NOT NULL DEFAULT '',
  `theme` varchar(64) NOT NULL DEFAULT '',
  `layout_update_id` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`layout_link_id`),
  UNIQUE KEY `store_id` (`store_id`,`package`,`theme`,`layout_update_id`),
  KEY `FK_core_layout_link_update` (`layout_update_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `core_layout_update`
--

CREATE TABLE IF NOT EXISTS `core_layout_update` (
  `layout_update_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `handle` varchar(255) DEFAULT NULL,
  `xml` text,
  PRIMARY KEY (`layout_update_id`),
  KEY `handle` (`handle`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `core_resource`
--

CREATE TABLE IF NOT EXISTS `core_resource` (
  `code` varchar(50) NOT NULL DEFAULT '',
  `version` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Resource version registry';

--
-- Dumping data for table `core_resource`
--

INSERT INTO `core_resource` (`code`, `version`) VALUES
('adminnotification_setup', '1.0.0'),
('admin_setup', '0.7.1'),
('amazonpayments_setup', '0.1.2'),
('api_setup', '0.8.1'),
('backup_setup', '0.7.0'),
('bundle_setup', '0.1.7'),
('catalogindex_setup', '0.7.10'),
('cataloginventory_setup', '0.7.5'),
('catalogrule_setup', '0.7.7'),
('catalogsearch_setup', '0.7.6'),
('catalog_setup', '0.7.69'),
('checkout_setup', '0.9.3'),
('cms_setup', '0.7.8'),
('compiler_setup', '0.1.0'),
('contacts_setup', '0.8.0'),
('core_setup', '0.8.13'),
('cron_setup', '0.7.1'),
('customer_setup', '0.8.11'),
('dataflow_setup', '0.7.4'),
('directory_setup', '0.8.5'),
('downloadable_setup', '0.1.14'),
('eav_setup', '0.7.13'),
('giftmessage_setup', '0.7.2'),
('googlebase_setup', '0.1.1'),
('googlecheckout_setup', '0.7.3'),
('googleoptimizer_setup', '0.1.2'),
('log_setup', '0.7.6'),
('newsletter_setup', '0.8.0'),
('paygate_setup', '0.7.0'),
('payment_setup', '0.7.0'),
('paypaluk_setup', '0.7.0'),
('paypal_setup', '0.7.2'),
('poll_setup', '0.7.2'),
('productalert_setup', '0.7.2'),
('rating_setup', '0.7.2'),
('reports_setup', '0.7.7'),
('review_setup', '0.7.4'),
('salesrule_setup', '0.7.7'),
('sales_setup', '0.9.38'),
('sendfriend_setup', '0.7.2'),
('shipping_setup', '0.7.0'),
('sitemap_setup', '0.7.2'),
('tag_setup', '0.7.2'),
('tax_setup', '0.7.8'),
('usa_setup', '0.7.0'),
('weee_setup', '0.13'),
('wishlist_setup', '0.7.4');

--
-- Table structure for table `core_session`
--

CREATE TABLE IF NOT EXISTS `core_session` (
  `session_id` varchar(255) NOT NULL DEFAULT '',
  `website_id` smallint(5) unsigned DEFAULT NULL,
  `session_expires` int(10) unsigned NOT NULL DEFAULT '0',
  `session_data` mediumblob NOT NULL,
  PRIMARY KEY (`session_id`),
  KEY `FK_SESSION_WEBSITE` (`website_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Session data store';

--
-- Table structure for table `core_store`
--

CREATE TABLE IF NOT EXISTS `core_store` (
  `store_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(32) NOT NULL DEFAULT '',
  `website_id` smallint(5) unsigned DEFAULT '0',
  `group_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `name` varchar(255) NOT NULL,
  `sort_order` smallint(5) unsigned NOT NULL DEFAULT '0',
  `is_active` tinyint(1) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`store_id`),
  UNIQUE KEY `code` (`code`),
  KEY `FK_STORE_WEBSITE` (`website_id`),
  KEY `is_active` (`is_active`,`sort_order`),
  KEY `FK_STORE_GROUP` (`group_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Stores' AUTO_INCREMENT=2 ;

--
-- Dumping data for table `core_store`
--

INSERT INTO `core_store` (`store_id`, `code`, `website_id`, `group_id`, `name`, `sort_order`, `is_active`) VALUES
(0, 'admin', 0, 0, 'Admin', 0, 1),
(1, 'default', 1, 1, 'Default Store View', 0, 1);

--
-- Table structure for table `core_store_group`
--

CREATE TABLE IF NOT EXISTS `core_store_group` (
  `group_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `website_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `name` varchar(255) NOT NULL,
  `root_category_id` int(10) unsigned NOT NULL DEFAULT '0',
  `default_store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`group_id`),
  KEY `FK_STORE_GROUP_WEBSITE` (`website_id`),
  KEY `default_store_id` (`default_store_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `core_store_group`
--

INSERT INTO `core_store_group` (`group_id`, `website_id`, `name`, `root_category_id`, `default_store_id`) VALUES
(0, 0, 'Default', 0, 0),
(1, 1, 'Main Website Store', 2, 1);

--
-- Table structure for table `core_translate`
--

CREATE TABLE IF NOT EXISTS `core_translate` (
  `key_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `string` varchar(255) NOT NULL DEFAULT '',
  `store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `translate` varchar(255) NOT NULL DEFAULT '',
  `locale` varchar(20) NOT NULL DEFAULT 'en_US',
  PRIMARY KEY (`key_id`),
  UNIQUE KEY `IDX_CODE` (`store_id`,`locale`,`string`),
  KEY `FK_CORE_TRANSLATE_STORE` (`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Translation data' AUTO_INCREMENT=1 ;

--
-- Table structure for table `core_url_rewrite`
--

CREATE TABLE IF NOT EXISTS `core_url_rewrite` (
  `url_rewrite_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `category_id` int(10) unsigned DEFAULT NULL,
  `product_id` int(10) unsigned DEFAULT NULL,
  `id_path` varchar(255) NOT NULL DEFAULT '',
  `request_path` varchar(255) NOT NULL DEFAULT '',
  `target_path` varchar(255) NOT NULL DEFAULT '',
  `is_system` tinyint(1) unsigned DEFAULT '1',
  `options` varchar(255) NOT NULL DEFAULT '',
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`url_rewrite_id`),
  UNIQUE KEY `UNQ_REQUEST_PATH` (`store_id`,`request_path`),
  UNIQUE KEY `UNQ_PATH` (`store_id`,`id_path`,`is_system`),
  KEY `FK_CORE_URL_REWRITE_STORE` (`store_id`),
  KEY `IDX_TARGET_PATH` (`store_id`,`target_path`),
  KEY `IDX_ID_PATH` (`id_path`),
  KEY `FK_CORE_URL_REWRITE_PRODUCT` (`product_id`),
  KEY `IDX_CATEGORY_REWRITE` (`category_id`,`is_system`,`product_id`,`store_id`,`id_path`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;

--
-- Table structure for table `core_website`
--

CREATE TABLE IF NOT EXISTS `core_website` (
  `website_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(32) NOT NULL DEFAULT '',
  `name` varchar(64) NOT NULL DEFAULT '',
  `sort_order` smallint(5) unsigned NOT NULL DEFAULT '0',
  `default_group_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `is_default` tinyint(1) unsigned DEFAULT '0',
  PRIMARY KEY (`website_id`),
  UNIQUE KEY `code` (`code`),
  KEY `sort_order` (`sort_order`),
  KEY `default_group_id` (`default_group_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Websites' AUTO_INCREMENT=2 ;

--
-- Dumping data for table `core_website`
--

INSERT INTO `core_website` (`website_id`, `code`, `name`, `sort_order`, `default_group_id`, `is_default`) VALUES
(0, 'admin', 'Admin', 0, 0, 0),
(1, 'base', 'Main Website', 0, 1, 1);

--
-- Table structure for table `cron_schedule`
--

CREATE TABLE IF NOT EXISTS `cron_schedule` (
  `schedule_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `job_code` varchar(255) NOT NULL DEFAULT '0',
  `status` enum('pending','running','success','missed','error') NOT NULL DEFAULT 'pending',
  `messages` text,
  `created_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `scheduled_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `executed_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `finished_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`schedule_id`),
  KEY `task_name` (`job_code`),
  KEY `scheduled_at` (`scheduled_at`,`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `customer_address_entity`
--

CREATE TABLE IF NOT EXISTS `customer_address_entity` (
  `entity_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `entity_type_id` smallint(8) unsigned NOT NULL DEFAULT '0',
  `attribute_set_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `increment_id` varchar(50) NOT NULL DEFAULT '',
  `parent_id` int(10) unsigned DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `is_active` tinyint(1) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`entity_id`),
  KEY `FK_CUSTOMER_ADDRESS_CUSTOMER_ID` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='Customer Address Entities' AUTO_INCREMENT=1 ;

--
-- Table structure for table `customer_address_entity_datetime`
--

CREATE TABLE IF NOT EXISTS `customer_address_entity_datetime` (
  `value_id` int(11) NOT NULL AUTO_INCREMENT,
  `entity_type_id` smallint(8) unsigned NOT NULL DEFAULT '0',
  `attribute_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `entity_id` int(10) unsigned NOT NULL DEFAULT '0',
  `value` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`value_id`),
  UNIQUE KEY `IDX_ATTRIBUTE_VALUE` (`entity_id`,`attribute_id`),
  KEY `FK_CUSTOMER_ADDRESS_DATETIME_ENTITY_TYPE` (`entity_type_id`),
  KEY `FK_CUSTOMER_ADDRESS_DATETIME_ATTRIBUTE` (`attribute_id`),
  KEY `FK_CUSTOMER_ADDRESS_DATETIME_ENTITY` (`entity_id`),
  KEY `IDX_VALUE` (`entity_id`,`attribute_id`,`value`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `customer_address_entity_decimal`
--

CREATE TABLE IF NOT EXISTS `customer_address_entity_decimal` (
  `value_id` int(11) NOT NULL AUTO_INCREMENT,
  `entity_type_id` smallint(8) unsigned NOT NULL DEFAULT '0',
  `attribute_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `entity_id` int(10) unsigned NOT NULL DEFAULT '0',
  `value` decimal(12,4) NOT NULL DEFAULT '0.0000',
  PRIMARY KEY (`value_id`),
  UNIQUE KEY `IDX_ATTRIBUTE_VALUE` (`entity_id`,`attribute_id`),
  KEY `FK_CUSTOMER_ADDRESS_DECIMAL_ENTITY_TYPE` (`entity_type_id`),
  KEY `FK_CUSTOMER_ADDRESS_DECIMAL_ATTRIBUTE` (`attribute_id`),
  KEY `FK_CUSTOMER_ADDRESS_DECIMAL_ENTITY` (`entity_id`),
  KEY `IDX_VALUE` (`entity_id`,`attribute_id`,`value`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `customer_address_entity_int`
--

CREATE TABLE IF NOT EXISTS `customer_address_entity_int` (
  `value_id` int(11) NOT NULL AUTO_INCREMENT,
  `entity_type_id` smallint(8) unsigned NOT NULL DEFAULT '0',
  `attribute_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `entity_id` int(10) unsigned NOT NULL DEFAULT '0',
  `value` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`value_id`),
  UNIQUE KEY `IDX_ATTRIBUTE_VALUE` (`entity_id`,`attribute_id`),
  KEY `FK_CUSTOMER_ADDRESS_INT_ENTITY_TYPE` (`entity_type_id`),
  KEY `FK_CUSTOMER_ADDRESS_INT_ATTRIBUTE` (`attribute_id`),
  KEY `FK_CUSTOMER_ADDRESS_INT_ENTITY` (`entity_id`),
  KEY `IDX_VALUE` (`entity_id`,`attribute_id`,`value`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `customer_address_entity_text`
--

CREATE TABLE IF NOT EXISTS `customer_address_entity_text` (
  `value_id` int(11) NOT NULL AUTO_INCREMENT,
  `entity_type_id` smallint(8) unsigned NOT NULL DEFAULT '0',
  `attribute_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `entity_id` int(10) unsigned NOT NULL DEFAULT '0',
  `value` text NOT NULL,
  PRIMARY KEY (`value_id`),
  UNIQUE KEY `IDX_ATTRIBUTE_VALUE` (`entity_id`,`attribute_id`),
  KEY `FK_CUSTOMER_ADDRESS_TEXT_ENTITY_TYPE` (`entity_type_id`),
  KEY `FK_CUSTOMER_ADDRESS_TEXT_ATTRIBUTE` (`attribute_id`),
  KEY `FK_CUSTOMER_ADDRESS_TEXT_ENTITY` (`entity_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `customer_address_entity_varchar`
--

CREATE TABLE IF NOT EXISTS `customer_address_entity_varchar` (
  `value_id` int(11) NOT NULL AUTO_INCREMENT,
  `entity_type_id` smallint(8) unsigned NOT NULL DEFAULT '0',
  `attribute_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `entity_id` int(10) unsigned NOT NULL DEFAULT '0',
  `value` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`value_id`),
  UNIQUE KEY `IDX_ATTRIBUTE_VALUE` (`entity_id`,`attribute_id`),
  KEY `FK_CUSTOMER_ADDRESS_VARCHAR_ENTITY_TYPE` (`entity_type_id`),
  KEY `FK_CUSTOMER_ADDRESS_VARCHAR_ATTRIBUTE` (`attribute_id`),
  KEY `FK_CUSTOMER_ADDRESS_VARCHAR_ENTITY` (`entity_id`),
  KEY `IDX_VALUE` (`entity_id`,`attribute_id`,`value`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `customer_entity`
--

CREATE TABLE IF NOT EXISTS `customer_entity` (
  `entity_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `entity_type_id` smallint(8) unsigned NOT NULL DEFAULT '0',
  `attribute_set_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `website_id` smallint(5) unsigned DEFAULT NULL,
  `email` varchar(255) NOT NULL DEFAULT '',
  `group_id` smallint(3) unsigned NOT NULL DEFAULT '0',
  `increment_id` varchar(50) NOT NULL DEFAULT '',
  `store_id` smallint(5) unsigned DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `is_active` tinyint(1) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`entity_id`),
  KEY `FK_CUSTOMER_ENTITY_STORE` (`store_id`),
  KEY `IDX_ENTITY_TYPE` (`entity_type_id`),
  KEY `IDX_AUTH` (`email`,`website_id`),
  KEY `FK_CUSTOMER_WEBSITE` (`website_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='Customer Entityies' AUTO_INCREMENT=1 ;

--
-- Table structure for table `customer_entity_datetime`
--

CREATE TABLE IF NOT EXISTS `customer_entity_datetime` (
  `value_id` int(11) NOT NULL AUTO_INCREMENT,
  `entity_type_id` smallint(8) unsigned NOT NULL DEFAULT '0',
  `attribute_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `entity_id` int(10) unsigned NOT NULL DEFAULT '0',
  `value` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`value_id`),
  UNIQUE KEY `IDX_ATTRIBUTE_VALUE` (`entity_id`,`attribute_id`),
  KEY `FK_CUSTOMER_DATETIME_ENTITY_TYPE` (`entity_type_id`),
  KEY `FK_CUSTOMER_DATETIME_ATTRIBUTE` (`attribute_id`),
  KEY `FK_CUSTOMER_DATETIME_ENTITY` (`entity_id`),
  KEY `IDX_VALUE` (`entity_id`,`attribute_id`,`value`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `customer_entity_decimal`
--

CREATE TABLE IF NOT EXISTS `customer_entity_decimal` (
  `value_id` int(11) NOT NULL AUTO_INCREMENT,
  `entity_type_id` smallint(8) unsigned NOT NULL DEFAULT '0',
  `attribute_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `entity_id` int(10) unsigned NOT NULL DEFAULT '0',
  `value` decimal(12,4) NOT NULL DEFAULT '0.0000',
  PRIMARY KEY (`value_id`),
  UNIQUE KEY `IDX_ATTRIBUTE_VALUE` (`entity_id`,`attribute_id`),
  KEY `FK_CUSTOMER_DECIMAL_ENTITY_TYPE` (`entity_type_id`),
  KEY `FK_CUSTOMER_DECIMAL_ATTRIBUTE` (`attribute_id`),
  KEY `FK_CUSTOMER_DECIMAL_ENTITY` (`entity_id`),
  KEY `IDX_VALUE` (`entity_id`,`attribute_id`,`value`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `customer_entity_int`
--

CREATE TABLE IF NOT EXISTS `customer_entity_int` (
  `value_id` int(11) NOT NULL AUTO_INCREMENT,
  `entity_type_id` smallint(8) unsigned NOT NULL DEFAULT '0',
  `attribute_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `entity_id` int(10) unsigned NOT NULL DEFAULT '0',
  `value` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`value_id`),
  UNIQUE KEY `IDX_ATTRIBUTE_VALUE` (`entity_id`,`attribute_id`),
  KEY `FK_CUSTOMER_INT_ENTITY_TYPE` (`entity_type_id`),
  KEY `FK_CUSTOMER_INT_ATTRIBUTE` (`attribute_id`),
  KEY `FK_CUSTOMER_INT_ENTITY` (`entity_id`),
  KEY `IDX_VALUE` (`entity_id`,`attribute_id`,`value`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `customer_entity_text`
--

CREATE TABLE IF NOT EXISTS `customer_entity_text` (
  `value_id` int(11) NOT NULL AUTO_INCREMENT,
  `entity_type_id` smallint(8) unsigned NOT NULL DEFAULT '0',
  `attribute_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `entity_id` int(10) unsigned NOT NULL DEFAULT '0',
  `value` text NOT NULL,
  PRIMARY KEY (`value_id`),
  UNIQUE KEY `IDX_ATTRIBUTE_VALUE` (`entity_id`,`attribute_id`),
  KEY `FK_CUSTOMER_TEXT_ENTITY_TYPE` (`entity_type_id`),
  KEY `FK_CUSTOMER_TEXT_ATTRIBUTE` (`attribute_id`),
  KEY `FK_CUSTOMER_TEXT_ENTITY` (`entity_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `customer_entity_varchar`
--

CREATE TABLE IF NOT EXISTS `customer_entity_varchar` (
  `value_id` int(11) NOT NULL AUTO_INCREMENT,
  `entity_type_id` smallint(8) unsigned NOT NULL DEFAULT '0',
  `attribute_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `entity_id` int(10) unsigned NOT NULL DEFAULT '0',
  `value` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`value_id`),
  UNIQUE KEY `IDX_ATTRIBUTE_VALUE` (`entity_id`,`attribute_id`),
  KEY `FK_CUSTOMER_VARCHAR_ENTITY_TYPE` (`entity_type_id`),
  KEY `FK_CUSTOMER_VARCHAR_ATTRIBUTE` (`attribute_id`),
  KEY `FK_CUSTOMER_VARCHAR_ENTITY` (`entity_id`),
  KEY `IDX_VALUE` (`entity_id`,`attribute_id`,`value`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `customer_group`
--

CREATE TABLE IF NOT EXISTS `customer_group` (
  `customer_group_id` smallint(3) unsigned NOT NULL AUTO_INCREMENT,
  `customer_group_code` varchar(32) NOT NULL DEFAULT '',
  `tax_class_id` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`customer_group_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Customer groups' AUTO_INCREMENT=4 ;

--
-- Dumping data for table `customer_group`
--

INSERT INTO `customer_group` (`customer_group_id`, `customer_group_code`, `tax_class_id`) VALUES
(0, 'NOT LOGGED IN', 3),
(1, 'General', 3),
(2, 'Wholesale', 3),
(3, 'Retailer', 3);

--
-- Table structure for table `dataflow_batch`
--

CREATE TABLE IF NOT EXISTS `dataflow_batch` (
  `batch_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `profile_id` int(10) unsigned NOT NULL DEFAULT '0',
  `store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `adapter` varchar(128) DEFAULT NULL,
  `params` text,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`batch_id`),
  KEY `FK_DATAFLOW_BATCH_PROFILE` (`profile_id`),
  KEY `FK_DATAFLOW_BATCH_STORE` (`store_id`),
  KEY `IDX_CREATED_AT` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `dataflow_batch_export`
--

CREATE TABLE IF NOT EXISTS `dataflow_batch_export` (
  `batch_export_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `batch_id` int(10) unsigned NOT NULL DEFAULT '0',
  `batch_data` longtext,
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`batch_export_id`),
  KEY `FK_DATAFLOW_BATCH_EXPORT_BATCH` (`batch_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `dataflow_batch_import`
--

CREATE TABLE IF NOT EXISTS `dataflow_batch_import` (
  `batch_import_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `batch_id` int(10) unsigned NOT NULL DEFAULT '0',
  `batch_data` longtext,
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`batch_import_id`),
  KEY `FK_DATAFLOW_BATCH_IMPORT_BATCH` (`batch_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `dataflow_import_data`
--

CREATE TABLE IF NOT EXISTS `dataflow_import_data` (
  `import_id` int(11) NOT NULL AUTO_INCREMENT,
  `session_id` int(11) DEFAULT NULL,
  `serial_number` int(11) NOT NULL DEFAULT '0',
  `value` text,
  `status` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`import_id`),
  KEY `FK_dataflow_import_data` (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `dataflow_profile`
--

CREATE TABLE IF NOT EXISTS `dataflow_profile` (
  `profile_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `created_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `actions_xml` text,
  `gui_data` text,
  `direction` enum('import','export') DEFAULT NULL,
  `entity_type` varchar(64) NOT NULL DEFAULT '',
  `store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `data_transfer` enum('file','interactive') DEFAULT NULL,
  PRIMARY KEY (`profile_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=7 ;

--
-- Dumping data for table `dataflow_profile`
--

INSERT INTO `dataflow_profile` (`profile_id`, `name`, `created_at`, `updated_at`, `actions_xml`, `gui_data`, `direction`, `entity_type`, `store_id`, `data_transfer`) VALUES
(1, 'Export All Products', '2009-10-15 15:02:35', '2009-10-15 15:02:35', '<action type="catalog/convert_adapter_product" method="load">\r\n    <var name="store"><![CDATA[0]]></var>\r\n</action>\r\n\r\n<action type="catalog/convert_parser_product" method="unparse">\r\n    <var name="store"><![CDATA[0]]></var>\r\n</action>\r\n\r\n<action type="dataflow/convert_mapper_column" method="map">\r\n</action>\r\n\r\n<action type="dataflow/convert_parser_csv" method="unparse">\r\n    <var name="delimiter"><![CDATA[,]]></var>\r\n    <var name="enclose"><![CDATA["]]></var>\r\n    <var name="fieldnames">true</var>\r\n</action>\r\n\r\n<action type="dataflow/convert_adapter_io" method="save">\r\n    <var name="type">file</var>\r\n    <var name="path">var/export</var>\r\n    <var name="filename"><![CDATA[export_all_products.csv]]></var>\r\n</action>\r\n\r\n', 'a:5:{s:4:"file";a:7:{s:4:"type";s:4:"file";s:8:"filename";s:23:"export_all_products.csv";s:4:"path";s:10:"var/export";s:4:"host";s:0:"";s:4:"user";s:0:"";s:8:"password";s:0:"";s:7:"passive";s:0:"";}s:5:"parse";a:5:{s:4:"type";s:3:"csv";s:12:"single_sheet";s:0:"";s:9:"delimiter";s:1:",";s:7:"enclose";s:1:""";s:10:"fieldnames";s:4:"true";}s:3:"map";a:3:{s:14:"only_specified";s:0:"";s:7:"product";a:2:{s:2:"db";a:0:{}s:4:"file";a:0:{}}s:8:"customer";a:2:{s:2:"db";a:0:{}s:4:"file";a:0:{}}}s:7:"product";a:1:{s:6:"filter";a:8:{s:4:"name";s:0:"";s:3:"sku";s:0:"";s:4:"type";s:1:"0";s:13:"attribute_set";s:0:"";s:5:"price";a:2:{s:4:"from";s:0:"";s:2:"to";s:0:"";}s:3:"qty";a:2:{s:4:"from";s:0:"";s:2:"to";s:0:"";}s:10:"visibility";s:1:"0";s:6:"status";s:1:"0";}}s:8:"customer";a:1:{s:6:"filter";a:10:{s:9:"firstname";s:0:"";s:8:"lastname";s:0:"";s:5:"email";s:0:"";s:5:"group";s:1:"0";s:10:"adressType";s:15:"default_billing";s:9:"telephone";s:0:"";s:8:"postcode";s:0:"";s:7:"country";s:0:"";s:6:"region";s:0:"";s:10:"created_at";a:2:{s:4:"from";s:0:"";s:2:"to";s:0:"";}}}}', 'export', 'product', 0, 'file'),
(2, 'Export Product Stocks', '2009-10-15 15:02:35', '2009-10-15 15:02:35', '<action type="catalog/convert_adapter_product" method="load">\r\n    <var name="store"><![CDATA[0]]></var>\r\n</action>\r\n\r\n<action type="catalog/convert_parser_product" method="unparse">\r\n    <var name="store"><![CDATA[0]]></var>\r\n</action>\r\n\r\n<action type="dataflow/convert_mapper_column" method="map">\r\n    <var name="map">\r\n        <map name="store"><![CDATA[store]]></map>\r\n        <map name="sku"><![CDATA[sku]]></map>\r\n        <map name="qty"><![CDATA[qty]]></map>\r\n        <map name="is_in_stock"><![CDATA[is_in_stock]]></map>\r\n    </var>\r\n    <var name="_only_specified">true</var>\r\n</action>\r\n\r\n<action type="dataflow/convert_parser_csv" method="unparse">\r\n    <var name="delimiter"><![CDATA[,]]></var>\r\n    <var name="enclose"><![CDATA["]]></var>\r\n    <var name="fieldnames">true</var>\r\n</action>\r\n\r\n<action type="dataflow/convert_adapter_io" method="save">\r\n    <var name="type">file</var>\r\n    <var name="path">var/export</var>\r\n    <var name="filename"><![CDATA[export_product_stocks.csv]]></var>\r\n</action>\r\n\r\n', 'a:5:{s:4:"file";a:7:{s:4:"type";s:4:"file";s:8:"filename";s:25:"export_product_stocks.csv";s:4:"path";s:10:"var/export";s:4:"host";s:0:"";s:4:"user";s:0:"";s:8:"password";s:0:"";s:7:"passive";s:0:"";}s:5:"parse";a:5:{s:4:"type";s:3:"csv";s:12:"single_sheet";s:0:"";s:9:"delimiter";s:1:",";s:7:"enclose";s:1:""";s:10:"fieldnames";s:4:"true";}s:3:"map";a:3:{s:14:"only_specified";s:4:"true";s:7:"product";a:2:{s:2:"db";a:4:{i:1;s:5:"store";i:2;s:3:"sku";i:3;s:3:"qty";i:4;s:11:"is_in_stock";}s:4:"file";a:4:{i:1;s:5:"store";i:2;s:3:"sku";i:3;s:3:"qty";i:4;s:11:"is_in_stock";}}s:8:"customer";a:2:{s:2:"db";a:0:{}s:4:"file";a:0:{}}}s:7:"product";a:1:{s:6:"filter";a:8:{s:4:"name";s:0:"";s:3:"sku";s:0:"";s:4:"type";s:1:"0";s:13:"attribute_set";s:0:"";s:5:"price";a:2:{s:4:"from";s:0:"";s:2:"to";s:0:"";}s:3:"qty";a:2:{s:4:"from";s:0:"";s:2:"to";s:0:"";}s:10:"visibility";s:1:"0";s:6:"status";s:1:"0";}}s:8:"customer";a:1:{s:6:"filter";a:10:{s:9:"firstname";s:0:"";s:8:"lastname";s:0:"";s:5:"email";s:0:"";s:5:"group";s:1:"0";s:10:"adressType";s:15:"default_billing";s:9:"telephone";s:0:"";s:8:"postcode";s:0:"";s:7:"country";s:0:"";s:6:"region";s:0:"";s:10:"created_at";a:2:{s:4:"from";s:0:"";s:2:"to";s:0:"";}}}}', 'export', 'product', 0, 'file'),
(3, 'Import All Products', '2009-10-15 15:02:35', '2009-10-15 15:02:35', '<action type="dataflow/convert_parser_csv" method="parse">\r\n    <var name="delimiter"><![CDATA[,]]></var>\r\n    <var name="enclose"><![CDATA["]]></var>\r\n    <var name="fieldnames">true</var>\r\n    <var name="store"><![CDATA[0]]></var>\r\n    <var name="adapter">catalog/convert_adapter_product</var>\r\n    <var name="method">parse</var>\r\n</action>', 'a:5:{s:4:"file";a:7:{s:4:"type";s:4:"file";s:8:"filename";s:23:"export_all_products.csv";s:4:"path";s:10:"var/export";s:4:"host";s:0:"";s:4:"user";s:0:"";s:8:"password";s:0:"";s:7:"passive";s:0:"";}s:5:"parse";a:5:{s:4:"type";s:3:"csv";s:12:"single_sheet";s:0:"";s:9:"delimiter";s:1:",";s:7:"enclose";s:1:""";s:10:"fieldnames";s:4:"true";}s:3:"map";a:3:{s:14:"only_specified";s:0:"";s:7:"product";a:2:{s:2:"db";a:0:{}s:4:"file";a:0:{}}s:8:"customer";a:2:{s:2:"db";a:0:{}s:4:"file";a:0:{}}}s:7:"product";a:1:{s:6:"filter";a:8:{s:4:"name";s:0:"";s:3:"sku";s:0:"";s:4:"type";s:1:"0";s:13:"attribute_set";s:0:"";s:5:"price";a:2:{s:4:"from";s:0:"";s:2:"to";s:0:"";}s:3:"qty";a:2:{s:4:"from";s:0:"";s:2:"to";s:0:"";}s:10:"visibility";s:1:"0";s:6:"status";s:1:"0";}}s:8:"customer";a:1:{s:6:"filter";a:10:{s:9:"firstname";s:0:"";s:8:"lastname";s:0:"";s:5:"email";s:0:"";s:5:"group";s:1:"0";s:10:"adressType";s:15:"default_billing";s:9:"telephone";s:0:"";s:8:"postcode";s:0:"";s:7:"country";s:0:"";s:6:"region";s:0:"";s:10:"created_at";a:2:{s:4:"from";s:0:"";s:2:"to";s:0:"";}}}}', 'import', 'product', 0, 'interactive'),
(4, 'Import Product Stocks', '2009-10-15 15:02:35', '2009-10-15 15:02:35', '<action type="dataflow/convert_parser_csv" method="parse">\r\n    <var name="delimiter"><![CDATA[,]]></var>\r\n    <var name="enclose"><![CDATA["]]></var>\r\n    <var name="fieldnames">true</var>\r\n    <var name="store"><![CDATA[0]]></var>\r\n    <var name="adapter">catalog/convert_adapter_product</var>\r\n    <var name="method">parse</var>\r\n</action>', 'a:5:{s:4:"file";a:7:{s:4:"type";s:4:"file";s:8:"filename";s:18:"export_product.csv";s:4:"path";s:10:"var/export";s:4:"host";s:0:"";s:4:"user";s:0:"";s:8:"password";s:0:"";s:7:"passive";s:0:"";}s:5:"parse";a:5:{s:4:"type";s:3:"csv";s:12:"single_sheet";s:0:"";s:9:"delimiter";s:1:",";s:7:"enclose";s:1:""";s:10:"fieldnames";s:4:"true";}s:3:"map";a:3:{s:14:"only_specified";s:0:"";s:7:"product";a:2:{s:2:"db";a:0:{}s:4:"file";a:0:{}}s:8:"customer";a:2:{s:2:"db";a:0:{}s:4:"file";a:0:{}}}s:7:"product";a:1:{s:6:"filter";a:8:{s:4:"name";s:0:"";s:3:"sku";s:0:"";s:4:"type";s:1:"0";s:13:"attribute_set";s:0:"";s:5:"price";a:2:{s:4:"from";s:0:"";s:2:"to";s:0:"";}s:3:"qty";a:2:{s:4:"from";s:0:"";s:2:"to";s:0:"";}s:10:"visibility";s:1:"0";s:6:"status";s:1:"0";}}s:8:"customer";a:1:{s:6:"filter";a:10:{s:9:"firstname";s:0:"";s:8:"lastname";s:0:"";s:5:"email";s:0:"";s:5:"group";s:1:"0";s:10:"adressType";s:15:"default_billing";s:9:"telephone";s:0:"";s:8:"postcode";s:0:"";s:7:"country";s:0:"";s:6:"region";s:0:"";s:10:"created_at";a:2:{s:4:"from";s:0:"";s:2:"to";s:0:"";}}}}', 'import', 'product', 0, 'interactive'),
(5, 'Export Customers', '2009-10-15 15:02:35', '2009-10-15 15:02:35', '<action type="customer/convert_adapter_customer" method="load">\r\n    <var name="store"><![CDATA[0]]></var>\r\n    <var name="filter/adressType"><![CDATA[default_billing]]></var>\r\n</action>\r\n\r\n<action type="customer/convert_parser_customer" method="unparse">\r\n    <var name="store"><![CDATA[0]]></var>\r\n</action>\r\n\r\n<action type="dataflow/convert_mapper_column" method="map">\r\n</action>\r\n\r\n<action type="dataflow/convert_parser_csv" method="unparse">\r\n    <var name="delimiter"><![CDATA[,]]></var>\r\n    <var name="enclose"><![CDATA["]]></var>\r\n    <var name="fieldnames">true</var>\r\n</action>\r\n\r\n<action type="dataflow/convert_adapter_io" method="save">\r\n    <var name="type">file</var>\r\n    <var name="path">var/export</var>\r\n    <var name="filename"><![CDATA[export_customers.csv]]></var>\r\n</action>\r\n\r\n', 'a:5:{s:4:"file";a:7:{s:4:"type";s:4:"file";s:8:"filename";s:20:"export_customers.csv";s:4:"path";s:10:"var/export";s:4:"host";s:0:"";s:4:"user";s:0:"";s:8:"password";s:0:"";s:7:"passive";s:0:"";}s:5:"parse";a:5:{s:4:"type";s:3:"csv";s:12:"single_sheet";s:0:"";s:9:"delimiter";s:1:",";s:7:"enclose";s:1:""";s:10:"fieldnames";s:4:"true";}s:3:"map";a:3:{s:14:"only_specified";s:0:"";s:7:"product";a:2:{s:2:"db";a:0:{}s:4:"file";a:0:{}}s:8:"customer";a:2:{s:2:"db";a:0:{}s:4:"file";a:0:{}}}s:7:"product";a:1:{s:6:"filter";a:8:{s:4:"name";s:0:"";s:3:"sku";s:0:"";s:4:"type";s:1:"0";s:13:"attribute_set";s:0:"";s:5:"price";a:2:{s:4:"from";s:0:"";s:2:"to";s:0:"";}s:3:"qty";a:2:{s:4:"from";s:0:"";s:2:"to";s:0:"";}s:10:"visibility";s:1:"0";s:6:"status";s:1:"0";}}s:8:"customer";a:1:{s:6:"filter";a:10:{s:9:"firstname";s:0:"";s:8:"lastname";s:0:"";s:5:"email";s:0:"";s:5:"group";s:1:"0";s:10:"adressType";s:15:"default_billing";s:9:"telephone";s:0:"";s:8:"postcode";s:0:"";s:7:"country";s:0:"";s:6:"region";s:0:"";s:10:"created_at";a:2:{s:4:"from";s:0:"";s:2:"to";s:0:"";}}}}', 'export', 'customer', 0, 'file'),
(6, 'Import Customers', '2009-10-15 15:02:35', '2009-10-15 15:02:35', '<action type="dataflow/convert_parser_csv" method="parse">\r\n    <var name="delimiter"><![CDATA[,]]></var>\r\n    <var name="enclose"><![CDATA["]]></var>\r\n    <var name="fieldnames">true</var>\r\n    <var name="store"><![CDATA[0]]></var>\r\n    <var name="adapter">customer/convert_adapter_customer</var>\r\n    <var name="method">parse</var>\r\n</action>', 'a:5:{s:4:"file";a:7:{s:4:"type";s:4:"file";s:8:"filename";s:19:"export_customer.csv";s:4:"path";s:10:"var/export";s:4:"host";s:0:"";s:4:"user";s:0:"";s:8:"password";s:0:"";s:7:"passive";s:0:"";}s:5:"parse";a:5:{s:4:"type";s:3:"csv";s:12:"single_sheet";s:0:"";s:9:"delimiter";s:1:",";s:7:"enclose";s:1:""";s:10:"fieldnames";s:4:"true";}s:3:"map";a:3:{s:14:"only_specified";s:0:"";s:7:"product";a:2:{s:2:"db";a:0:{}s:4:"file";a:0:{}}s:8:"customer";a:2:{s:2:"db";a:0:{}s:4:"file";a:0:{}}}s:7:"product";a:1:{s:6:"filter";a:8:{s:4:"name";s:0:"";s:3:"sku";s:0:"";s:4:"type";s:1:"0";s:13:"attribute_set";s:0:"";s:5:"price";a:2:{s:4:"from";s:0:"";s:2:"to";s:0:"";}s:3:"qty";a:2:{s:4:"from";s:0:"";s:2:"to";s:0:"";}s:10:"visibility";s:1:"0";s:6:"status";s:1:"0";}}s:8:"customer";a:1:{s:6:"filter";a:10:{s:9:"firstname";s:0:"";s:8:"lastname";s:0:"";s:5:"email";s:0:"";s:5:"group";s:1:"0";s:10:"adressType";s:15:"default_billing";s:9:"telephone";s:0:"";s:8:"postcode";s:0:"";s:7:"country";s:0:"";s:6:"region";s:0:"";s:10:"created_at";a:2:{s:4:"from";s:0:"";s:2:"to";s:0:"";}}}}', 'import', 'customer', 0, 'interactive');

--
-- Table structure for table `dataflow_profile_history`
--

CREATE TABLE IF NOT EXISTS `dataflow_profile_history` (
  `history_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `profile_id` int(10) unsigned NOT NULL DEFAULT '0',
  `action_code` varchar(64) DEFAULT NULL,
  `user_id` int(10) unsigned NOT NULL DEFAULT '0',
  `performed_at` datetime DEFAULT NULL,
  PRIMARY KEY (`history_id`),
  KEY `FK_dataflow_profile_history` (`profile_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `dataflow_session`
--

CREATE TABLE IF NOT EXISTS `dataflow_session` (
  `session_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `created_date` datetime DEFAULT NULL,
  `file` varchar(255) DEFAULT NULL,
  `type` varchar(32) DEFAULT NULL,
  `direction` varchar(32) DEFAULT NULL,
  `comment` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `design_change`
--

CREATE TABLE IF NOT EXISTS `design_change` (
  `design_change_id` int(11) NOT NULL AUTO_INCREMENT,
  `store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `design` varchar(255) NOT NULL DEFAULT '',
  `date_from` date DEFAULT NULL,
  `date_to` date DEFAULT NULL,
  PRIMARY KEY (`design_change_id`),
  KEY `FK_DESIGN_CHANGE_STORE` (`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `directory_country`
--

CREATE TABLE IF NOT EXISTS `directory_country` (
  `country_id` varchar(2) NOT NULL DEFAULT '',
  `iso2_code` varchar(2) NOT NULL DEFAULT '',
  `iso3_code` varchar(3) NOT NULL DEFAULT '',
  PRIMARY KEY (`country_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Countries';

--
-- Dumping data for table `directory_country`
--

INSERT INTO `directory_country` (`country_id`, `iso2_code`, `iso3_code`) VALUES
('AD', 'AD', 'AND'),
('AE', 'AE', 'ARE'),
('AF', 'AF', 'AFG'),
('AG', 'AG', 'ATG'),
('AI', 'AI', 'AIA'),
('AL', 'AL', 'ALB'),
('AM', 'AM', 'ARM'),
('AN', 'AN', 'ANT'),
('AO', 'AO', 'AGO'),
('AQ', 'AQ', 'ATA'),
('AR', 'AR', 'ARG'),
('AS', 'AS', 'ASM'),
('AT', 'AT', 'AUT'),
('AU', 'AU', 'AUS'),
('AW', 'AW', 'ABW'),
('AX', 'AX', 'ALA'),
('AZ', 'AZ', 'AZE'),
('BA', 'BA', 'BIH'),
('BB', 'BB', 'BRB'),
('BD', 'BD', 'BGD'),
('BE', 'BE', 'BEL'),
('BF', 'BF', 'BFA'),
('BG', 'BG', 'BGR'),
('BH', 'BH', 'BHR'),
('BI', 'BI', 'BDI'),
('BJ', 'BJ', 'BEN'),
('BL', 'BL', 'BLM'),
('BM', 'BM', 'BMU'),
('BN', 'BN', 'BRN'),
('BO', 'BO', 'BOL'),
('BR', 'BR', 'BRA'),
('BS', 'BS', 'BHS'),
('BT', 'BT', 'BTN'),
('BV', 'BV', 'BVT'),
('BW', 'BW', 'BWA'),
('BY', 'BY', 'BLR'),
('BZ', 'BZ', 'BLZ'),
('CA', 'CA', 'CAN'),
('CC', 'CC', 'CCK'),
('CD', 'CD', 'COD'),
('CF', 'CF', 'CAF'),
('CG', 'CG', 'COG'),
('CH', 'CH', 'CHE'),
('CI', 'CI', 'CIV'),
('CK', 'CK', 'COK'),
('CL', 'CL', 'CHL'),
('CM', 'CM', 'CMR'),
('CN', 'CN', 'CHN'),
('CO', 'CO', 'COL'),
('CR', 'CR', 'CRI'),
('CS', 'CS', 'SCG'),
('CU', 'CU', 'CUB'),
('CV', 'CV', 'CPV'),
('CX', 'CX', 'CXR'),
('CY', 'CY', 'CYP'),
('CZ', 'CZ', 'CZE'),
('DE', 'DE', 'DEU'),
('DJ', 'DJ', 'DJI'),
('DK', 'DK', 'DNK'),
('DM', 'DM', 'DMA'),
('DO', 'DO', 'DOM'),
('DZ', 'DZ', 'DZA'),
('EC', 'EC', 'ECU'),
('EE', 'EE', 'EST'),
('EG', 'EG', 'EGY'),
('EH', 'EH', 'ESH'),
('ER', 'ER', 'ERI'),
('ES', 'ES', 'ESP'),
('ET', 'ET', 'ETH'),
('FI', 'FI', 'FIN'),
('FJ', 'FJ', 'FJI'),
('FK', 'FK', 'FLK'),
('FM', 'FM', 'FSM'),
('FO', 'FO', 'FRO'),
('FR', 'FR', 'FRA'),
('FX', 'FX', 'FXX'),
('GA', 'GA', 'GAB'),
('GB', 'GB', 'GBR'),
('GD', 'GD', 'GRD'),
('GE', 'GE', 'GEO'),
('GF', 'GF', 'GUF'),
('GG', 'GG', 'GGY'),
('GH', 'GH', 'GHA'),
('GI', 'GI', 'GIB'),
('GL', 'GL', 'GRL'),
('GM', 'GM', 'GMB'),
('GN', 'GN', 'GIN'),
('GP', 'GP', 'GLP'),
('GQ', 'GQ', 'GNQ'),
('GR', 'GR', 'GRC'),
('GS', 'GS', 'SGS'),
('GT', 'GT', 'GTM'),
('GU', 'GU', 'GUM'),
('GW', 'GW', 'GNB'),
('GY', 'GY', 'GUY'),
('HK', 'HK', 'HKG'),
('HM', 'HM', 'HMD'),
('HN', 'HN', 'HND'),
('HR', 'HR', 'HRV'),
('HT', 'HT', 'HTI'),
('HU', 'HU', 'HUN'),
('ID', 'ID', 'IDN'),
('IE', 'IE', 'IRL'),
('IL', 'IL', 'ISR'),
('IM', 'IM', 'IMN'),
('IN', 'IN', 'IND'),
('IO', 'IO', 'IOT'),
('IQ', 'IQ', 'IRQ'),
('IR', 'IR', 'IRN'),
('IS', 'IS', 'ISL'),
('IT', 'IT', 'ITA'),
('JE', 'JE', 'JEY'),
('JM', 'JM', 'JAM'),
('JO', 'JO', 'JOR'),
('JP', 'JP', 'JPN'),
('KE', 'KE', 'KEN'),
('KG', 'KG', 'KGZ'),
('KH', 'KH', 'KHM'),
('KI', 'KI', 'KIR'),
('KM', 'KM', 'COM'),
('KN', 'KN', 'KNA'),
('KP', 'KP', 'PRK'),
('KR', 'KR', 'KOR'),
('KW', 'KW', 'KWT'),
('KY', 'KY', 'CYM'),
('KZ', 'KZ', 'KAZ'),
('LA', 'LA', 'LAO'),
('LB', 'LB', 'LBN'),
('LC', 'LC', 'LCA'),
('LI', 'LI', 'LIE'),
('LK', 'LK', 'LKA'),
('LR', 'LR', 'LBR'),
('LS', 'LS', 'LSO'),
('LT', 'LT', 'LTU'),
('LU', 'LU', 'LUX'),
('LV', 'LV', 'LVA'),
('LY', 'LY', 'LBY'),
('MA', 'MA', 'MAR'),
('MC', 'MC', 'MCO'),
('MD', 'MD', 'MDA'),
('ME', 'ME', 'MNE'),
('MF', 'MF', 'MAF'),
('MG', 'MG', 'MDG'),
('MH', 'MH', 'MHL'),
('MK', 'MK', 'MKD'),
('ML', 'ML', 'MLI'),
('MM', 'MM', 'MMR'),
('MN', 'MN', 'MNG'),
('MO', 'MO', 'MAC'),
('MP', 'MP', 'MNP'),
('MQ', 'MQ', 'MTQ'),
('MR', 'MR', 'MRT'),
('MS', 'MS', 'MSR'),
('MT', 'MT', 'MLT'),
('MU', 'MU', 'MUS'),
('MV', 'MV', 'MDV'),
('MW', 'MW', 'MWI'),
('MX', 'MX', 'MEX'),
('MY', 'MY', 'MYS'),
('MZ', 'MZ', 'MOZ'),
('NA', 'NA', 'NAM'),
('NC', 'NC', 'NCL'),
('NE', 'NE', 'NER'),
('NF', 'NF', 'NFK'),
('NG', 'NG', 'NGA'),
('NI', 'NI', 'NIC'),
('NL', 'NL', 'NLD'),
('NO', 'NO', 'NOR'),
('NP', 'NP', 'NPL'),
('NR', 'NR', 'NRU'),
('NU', 'NU', 'NIU'),
('NZ', 'NZ', 'NZL'),
('OM', 'OM', 'OMN'),
('PA', 'PA', 'PAN'),
('PE', 'PE', 'PER'),
('PF', 'PF', 'PYF'),
('PG', 'PG', 'PNG'),
('PH', 'PH', 'PHL'),
('PK', 'PK', 'PAK'),
('PL', 'PL', 'POL'),
('PM', 'PM', 'SPM'),
('PN', 'PN', 'PCN'),
('PR', 'PR', 'PRI'),
('PS', 'PS', 'PSE'),
('PT', 'PT', 'PRT'),
('PW', 'PW', 'PLW'),
('PY', 'PY', 'PRY'),
('QA', 'QA', 'QAT'),
('RE', 'RE', 'REU'),
('RO', 'RO', 'ROM'),
('RS', 'RS', 'SRB'),
('RU', 'RU', 'RUS'),
('RW', 'RW', 'RWA'),
('SA', 'SA', 'SAU'),
('SB', 'SB', 'SLB'),
('SC', 'SC', 'SYC'),
('SD', 'SD', 'SDN'),
('SE', 'SE', 'SWE'),
('SG', 'SG', 'SGP'),
('SH', 'SH', 'SHN'),
('SI', 'SI', 'SVN'),
('SJ', 'SJ', 'SJM'),
('SK', 'SK', 'SVK'),
('SL', 'SL', 'SLE'),
('SM', 'SM', 'SMR'),
('SN', 'SN', 'SEN'),
('SO', 'SO', 'SOM'),
('SR', 'SR', 'SUR'),
('ST', 'ST', 'STP'),
('SV', 'SV', 'SLV'),
('SY', 'SY', 'SYR'),
('SZ', 'SZ', 'SWZ'),
('TC', 'TC', 'TCA'),
('TD', 'TD', 'TCD'),
('TF', 'TF', 'ATF'),
('TG', 'TG', 'TGO'),
('TH', 'TH', 'THA'),
('TJ', 'TJ', 'TJK'),
('TK', 'TK', 'TKL'),
('TL', 'TL', 'TLS'),
('TM', 'TM', 'TKM'),
('TN', 'TN', 'TUN'),
('TO', 'TO', 'TON'),
('TR', 'TR', 'TUR'),
('TT', 'TT', 'TTO'),
('TV', 'TV', 'TUV'),
('TW', 'TW', 'TWN'),
('TZ', 'TZ', 'TZA'),
('UA', 'UA', 'UKR'),
('UG', 'UG', 'UGA'),
('UM', 'UM', 'UMI'),
('US', 'US', 'USA'),
('UY', 'UY', 'URY'),
('UZ', 'UZ', 'UZB'),
('VA', 'VA', 'VAT'),
('VC', 'VC', 'VCT'),
('VE', 'VE', 'VEN'),
('VG', 'VG', 'VGB'),
('VI', 'VI', 'VIR'),
('VN', 'VN', 'VNM'),
('VU', 'VU', 'VUT'),
('WF', 'WF', 'WLF'),
('WS', 'WS', 'WSM'),
('YE', 'YE', 'YEM'),
('YT', 'YT', 'MYT'),
('ZA', 'ZA', 'ZAF'),
('ZM', 'ZM', 'ZMB'),
('ZW', 'ZW', 'ZWE');

--
-- Table structure for table `directory_country_format`
--

CREATE TABLE IF NOT EXISTS `directory_country_format` (
  `country_format_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `country_id` varchar(2) NOT NULL DEFAULT '',
  `type` varchar(30) NOT NULL DEFAULT '',
  `format` text NOT NULL,
  PRIMARY KEY (`country_format_id`),
  UNIQUE KEY `country_type` (`country_id`,`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Countries format' AUTO_INCREMENT=1 ;

--
-- Table structure for table `directory_country_region`
--

CREATE TABLE IF NOT EXISTS `directory_country_region` (
  `region_id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `country_id` varchar(4) NOT NULL DEFAULT '0',
  `code` varchar(32) NOT NULL DEFAULT '',
  `default_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`region_id`),
  KEY `FK_REGION_COUNTRY` (`country_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Country regions' AUTO_INCREMENT=278 ;

--
-- Dumping data for table `directory_country_region`
--

INSERT INTO `directory_country_region` (`region_id`, `country_id`, `code`, `default_name`) VALUES
(1, 'US', 'AL', 'Alabama'),
(2, 'US', 'AK', 'Alaska'),
(3, 'US', 'AS', 'American Samoa'),
(4, 'US', 'AZ', 'Arizona'),
(5, 'US', 'AR', 'Arkansas'),
(6, 'US', 'AF', 'Armed Forces Africa'),
(7, 'US', 'AA', 'Armed Forces Americas'),
(8, 'US', 'AC', 'Armed Forces Canada'),
(9, 'US', 'AE', 'Armed Forces Europe'),
(10, 'US', 'AM', 'Armed Forces Middle East'),
(11, 'US', 'AP', 'Armed Forces Pacific'),
(12, 'US', 'CA', 'California'),
(13, 'US', 'CO', 'Colorado'),
(14, 'US', 'CT', 'Connecticut'),
(15, 'US', 'DE', 'Delaware'),
(16, 'US', 'DC', 'District of Columbia'),
(17, 'US', 'FM', 'Federated States Of Micronesia'),
(18, 'US', 'FL', 'Florida'),
(19, 'US', 'GA', 'Georgia'),
(20, 'US', 'GU', 'Guam'),
(21, 'US', 'HI', 'Hawaii'),
(22, 'US', 'ID', 'Idaho'),
(23, 'US', 'IL', 'Illinois'),
(24, 'US', 'IN', 'Indiana'),
(25, 'US', 'IA', 'Iowa'),
(26, 'US', 'KS', 'Kansas'),
(27, 'US', 'KY', 'Kentucky'),
(28, 'US', 'LA', 'Louisiana'),
(29, 'US', 'ME', 'Maine'),
(30, 'US', 'MH', 'Marshall Islands'),
(31, 'US', 'MD', 'Maryland'),
(32, 'US', 'MA', 'Massachusetts'),
(33, 'US', 'MI', 'Michigan'),
(34, 'US', 'MN', 'Minnesota'),
(35, 'US', 'MS', 'Mississippi'),
(36, 'US', 'MO', 'Missouri'),
(37, 'US', 'MT', 'Montana'),
(38, 'US', 'NE', 'Nebraska'),
(39, 'US', 'NV', 'Nevada'),
(40, 'US', 'NH', 'New Hampshire'),
(41, 'US', 'NJ', 'New Jersey'),
(42, 'US', 'NM', 'New Mexico'),
(43, 'US', 'NY', 'New York'),
(44, 'US', 'NC', 'North Carolina'),
(45, 'US', 'ND', 'North Dakota'),
(46, 'US', 'MP', 'Northern Mariana Islands'),
(47, 'US', 'OH', 'Ohio'),
(48, 'US', 'OK', 'Oklahoma'),
(49, 'US', 'OR', 'Oregon'),
(50, 'US', 'PW', 'Palau'),
(51, 'US', 'PA', 'Pennsylvania'),
(52, 'US', 'PR', 'Puerto Rico'),
(53, 'US', 'RI', 'Rhode Island'),
(54, 'US', 'SC', 'South Carolina'),
(55, 'US', 'SD', 'South Dakota'),
(56, 'US', 'TN', 'Tennessee'),
(57, 'US', 'TX', 'Texas'),
(58, 'US', 'UT', 'Utah'),
(59, 'US', 'VT', 'Vermont'),
(60, 'US', 'VI', 'Virgin Islands'),
(61, 'US', 'VA', 'Virginia'),
(62, 'US', 'WA', 'Washington'),
(63, 'US', 'WV', 'West Virginia'),
(64, 'US', 'WI', 'Wisconsin'),
(65, 'US', 'WY', 'Wyoming'),
(66, 'CA', 'AB', 'Alberta'),
(67, 'CA', 'BC', 'British Columbia'),
(68, 'CA', 'MB', 'Manitoba'),
(69, 'CA', 'NF', 'Newfoundland'),
(70, 'CA', 'NB', 'New Brunswick'),
(71, 'CA', 'NS', 'Nova Scotia'),
(72, 'CA', 'NT', 'Northwest Territories'),
(73, 'CA', 'NU', 'Nunavut'),
(74, 'CA', 'ON', 'Ontario'),
(75, 'CA', 'PE', 'Prince Edward Island'),
(76, 'CA', 'QC', 'Quebec'),
(77, 'CA', 'SK', 'Saskatchewan'),
(78, 'CA', 'YT', 'Yukon Territory'),
(79, 'DE', 'NDS', 'Niedersachsen'),
(80, 'DE', 'BAW', 'Baden-Württemberg'),
(81, 'DE', 'BAY', 'Bayern'),
(82, 'DE', 'BER', 'Berlin'),
(83, 'DE', 'BRG', 'Brandenburg'),
(84, 'DE', 'BRE', 'Bremen'),
(85, 'DE', 'HAM', 'Hamburg'),
(86, 'DE', 'HES', 'Hessen'),
(87, 'DE', 'MEC', 'Mecklenburg-Vorpommern'),
(88, 'DE', 'NRW', 'Nordrhein-Westfalen'),
(89, 'DE', 'RHE', 'Rheinland-Pfalz'),
(90, 'DE', 'SAR', 'Saarland'),
(91, 'DE', 'SAS', 'Sachsen'),
(92, 'DE', 'SAC', 'Sachsen-Anhalt'),
(93, 'DE', 'SCN', 'Schleswig-Holstein'),
(94, 'DE', 'THE', 'Thüringen'),
(95, 'AT', 'WI', 'Wien'),
(96, 'AT', 'NO', 'Niederösterreich'),
(97, 'AT', 'OO', 'Oberösterreich'),
(98, 'AT', 'SB', 'Salzburg'),
(99, 'AT', 'KN', 'Kärnten'),
(100, 'AT', 'ST', 'Steiermark'),
(101, 'AT', 'TI', 'Tirol'),
(102, 'AT', 'BL', 'Burgenland'),
(103, 'AT', 'VB', 'Voralberg'),
(104, 'CH', 'AG', 'Aargau'),
(105, 'CH', 'AI', 'Appenzell Innerrhoden'),
(106, 'CH', 'AR', 'Appenzell Ausserrhoden'),
(107, 'CH', 'BE', 'Bern'),
(108, 'CH', 'BL', 'Basel-Landschaft'),
(109, 'CH', 'BS', 'Basel-Stadt'),
(110, 'CH', 'FR', 'Freiburg'),
(111, 'CH', 'GE', 'Genf'),
(112, 'CH', 'GL', 'Glarus'),
(113, 'CH', 'GR', 'Graubünden'),
(114, 'CH', 'JU', 'Jura'),
(115, 'CH', 'LU', 'Luzern'),
(116, 'CH', 'NE', 'Neuenburg'),
(117, 'CH', 'NW', 'Nidwalden'),
(118, 'CH', 'OW', 'Obwalden'),
(119, 'CH', 'SG', 'St. Gallen'),
(120, 'CH', 'SH', 'Schaffhausen'),
(121, 'CH', 'SO', 'Solothurn'),
(122, 'CH', 'SZ', 'Schwyz'),
(123, 'CH', 'TG', 'Thurgau'),
(124, 'CH', 'TI', 'Tessin'),
(125, 'CH', 'UR', 'Uri'),
(126, 'CH', 'VD', 'Waadt'),
(127, 'CH', 'VS', 'Wallis'),
(128, 'CH', 'ZG', 'Zug'),
(129, 'CH', 'ZH', 'Zürich'),
(130, 'ES', 'A Coru?a', 'A Coruña'),
(131, 'ES', 'Alava', 'Alava'),
(132, 'ES', 'Albacete', 'Albacete'),
(133, 'ES', 'Alicante', 'Alicante'),
(134, 'ES', 'Almeria', 'Almeria'),
(135, 'ES', 'Asturias', 'Asturias'),
(136, 'ES', 'Avila', 'Avila'),
(137, 'ES', 'Badajoz', 'Badajoz'),
(138, 'ES', 'Baleares', 'Baleares'),
(139, 'ES', 'Barcelona', 'Barcelona'),
(140, 'ES', 'Burgos', 'Burgos'),
(141, 'ES', 'Caceres', 'Caceres'),
(142, 'ES', 'Cadiz', 'Cadiz'),
(143, 'ES', 'Cantabria', 'Cantabria'),
(144, 'ES', 'Castellon', 'Castellon'),
(145, 'ES', 'Ceuta', 'Ceuta'),
(146, 'ES', 'Ciudad Real', 'Ciudad Real'),
(147, 'ES', 'Cordoba', 'Cordoba'),
(148, 'ES', 'Cuenca', 'Cuenca'),
(149, 'ES', 'Girona', 'Girona'),
(150, 'ES', 'Granada', 'Granada'),
(151, 'ES', 'Guadalajara', 'Guadalajara'),
(152, 'ES', 'Guipuzcoa', 'Guipuzcoa'),
(153, 'ES', 'Huelva', 'Huelva'),
(154, 'ES', 'Huesca', 'Huesca'),
(155, 'ES', 'Jaen', 'Jaen'),
(156, 'ES', 'La Rioja', 'La Rioja'),
(157, 'ES', 'Las Palmas', 'Las Palmas'),
(158, 'ES', 'Leon', 'Leon'),
(159, 'ES', 'Lleida', 'Lleida'),
(160, 'ES', 'Lugo', 'Lugo'),
(161, 'ES', 'Madrid', 'Madrid'),
(162, 'ES', 'Malaga', 'Malaga'),
(163, 'ES', 'Melilla', 'Melilla'),
(164, 'ES', 'Murcia', 'Murcia'),
(165, 'ES', 'Navarra', 'Navarra'),
(166, 'ES', 'Ourense', 'Ourense'),
(167, 'ES', 'Palencia', 'Palencia'),
(168, 'ES', 'Pontevedra', 'Pontevedra'),
(169, 'ES', 'Salamanca', 'Salamanca'),
(170, 'ES', 'Santa Cruz de Tenerife', 'Santa Cruz de Tenerife'),
(171, 'ES', 'Segovia', 'Segovia'),
(172, 'ES', 'Sevilla', 'Sevilla'),
(173, 'ES', 'Soria', 'Soria'),
(174, 'ES', 'Tarragona', 'Tarragona'),
(175, 'ES', 'Teruel', 'Teruel'),
(176, 'ES', 'Toledo', 'Toledo'),
(177, 'ES', 'Valencia', 'Valencia'),
(178, 'ES', 'Valladolid', 'Valladolid'),
(179, 'ES', 'Vizcaya', 'Vizcaya'),
(180, 'ES', 'Zamora', 'Zamora'),
(181, 'ES', 'Zaragoza', 'Zaragoza'),
(182, 'FR', '01', 'Ain'),
(183, 'FR', '02', 'Aisne'),
(184, 'FR', '03', 'Allier'),
(185, 'FR', '04', 'Alpes-de-Haute-Provence'),
(186, 'FR', '05', 'Hautes-Alpes'),
(187, 'FR', '06', 'Alpes-Maritimes'),
(188, 'FR', '07', 'Ardèche'),
(189, 'FR', '08', 'Ardennes'),
(190, 'FR', '09', 'Ariège'),
(191, 'FR', '10', 'Aube'),
(192, 'FR', '11', 'Aude'),
(193, 'FR', '12', 'Aveyron'),
(194, 'FR', '13', 'Bouches-du-Rhône'),
(195, 'FR', '14', 'Calvados'),
(196, 'FR', '15', 'Cantal'),
(197, 'FR', '16', 'Charente'),
(198, 'FR', '17', 'Charente-Maritime'),
(199, 'FR', '18', 'Cher'),
(200, 'FR', '19', 'Corrèze'),
(201, 'FR', '2A', 'Corse-du-Sud'),
(202, 'FR', '2B', 'Haute-Corse'),
(203, 'FR', '21', 'Côte-d''Or'),
(204, 'FR', '22', 'Côtes-d''Armor'),
(205, 'FR', '23', 'Creuse'),
(206, 'FR', '24', 'Dordogne'),
(207, 'FR', '25', 'Doubs'),
(208, 'FR', '26', 'Drôme'),
(209, 'FR', '27', 'Eure'),
(210, 'FR', '28', 'Eure-et-Loir'),
(211, 'FR', '29', 'Finistère'),
(212, 'FR', '30', 'Gard'),
(213, 'FR', '31', 'Haute-Garonne'),
(214, 'FR', '32', 'Gers'),
(215, 'FR', '33', 'Gironde'),
(216, 'FR', '34', 'Hérault'),
(217, 'FR', '35', 'Ille-et-Vilaine'),
(218, 'FR', '36', 'Indre'),
(219, 'FR', '37', 'Indre-et-Loire'),
(220, 'FR', '38', 'Isère'),
(221, 'FR', '39', 'Jura'),
(222, 'FR', '40', 'Landes'),
(223, 'FR', '41', 'Loir-et-Cher'),
(224, 'FR', '42', 'Loire'),
(225, 'FR', '43', 'Haute-Loire'),
(226, 'FR', '44', 'Loire-Atlantique'),
(227, 'FR', '45', 'Loiret'),
(228, 'FR', '46', 'Lot'),
(229, 'FR', '47', 'Lot-et-Garonne'),
(230, 'FR', '48', 'Lozère'),
(231, 'FR', '49', 'Maine-et-Loire'),
(232, 'FR', '50', 'Manche'),
(233, 'FR', '51', 'Marne'),
(234, 'FR', '52', 'Haute-Marne'),
(235, 'FR', '53', 'Mayenne'),
(236, 'FR', '54', 'Meurthe-et-Moselle'),
(237, 'FR', '55', 'Meuse'),
(238, 'FR', '56', 'Morbihan'),
(239, 'FR', '57', 'Moselle'),
(240, 'FR', '58', 'Nièvre'),
(241, 'FR', '59', 'Nord'),
(242, 'FR', '60', 'Oise'),
(243, 'FR', '61', 'Orne'),
(244, 'FR', '62', 'Pas-de-Calais'),
(245, 'FR', '63', 'Puy-de-Dôme'),
(246, 'FR', '64', 'Pyrénées-Atlantiques'),
(247, 'FR', '65', 'Hautes-Pyrénées'),
(248, 'FR', '66', 'Pyrénées-Orientales'),
(249, 'FR', '67', 'Bas-Rhin'),
(250, 'FR', '68', 'Haut-Rhin'),
(251, 'FR', '69', 'Rhône'),
(252, 'FR', '70', 'Haute-Saône'),
(253, 'FR', '71', 'Saône-et-Loire'),
(254, 'FR', '72', 'Sarthe'),
(255, 'FR', '73', 'Savoie'),
(256, 'FR', '74', 'Haute-Savoie'),
(257, 'FR', '75', 'Paris'),
(258, 'FR', '76', 'Seine-Maritime'),
(259, 'FR', '77', 'Seine-et-Marne'),
(260, 'FR', '78', 'Yvelines'),
(261, 'FR', '79', 'Deux-Sèvres'),
(262, 'FR', '80', 'Somme'),
(263, 'FR', '81', 'Tarn'),
(264, 'FR', '82', 'Tarn-et-Garonne'),
(265, 'FR', '83', 'Var'),
(266, 'FR', '84', 'Vaucluse'),
(267, 'FR', '85', 'Vendée'),
(268, 'FR', '86', 'Vienne'),
(269, 'FR', '87', 'Haute-Vienne'),
(270, 'FR', '88', 'Vosges'),
(271, 'FR', '89', 'Yonne'),
(272, 'FR', '90', 'Territoire-de-Belfort'),
(273, 'FR', '91', 'Essonne'),
(274, 'FR', '92', 'Hauts-de-Seine'),
(275, 'FR', '93', 'Seine-Saint-Denis'),
(276, 'FR', '94', 'Val-de-Marne'),
(277, 'FR', '95', 'Val-d''Oise');

--
-- Table structure for table `directory_country_region_name`
--

CREATE TABLE IF NOT EXISTS `directory_country_region_name` (
  `locale` varchar(8) NOT NULL DEFAULT '',
  `region_id` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `name` varchar(64) NOT NULL DEFAULT '',
  PRIMARY KEY (`locale`,`region_id`),
  KEY `FK_DIRECTORY_REGION_NAME_REGION` (`region_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Regions names';

--
-- Dumping data for table `directory_country_region_name`
--

INSERT INTO `directory_country_region_name` (`locale`, `region_id`, `name`) VALUES
('en_US', 1, 'Alabama'),
('en_US', 2, 'Alaska'),
('en_US', 3, 'American Samoa'),
('en_US', 4, 'Arizona'),
('en_US', 5, 'Arkansas'),
('en_US', 6, 'Armed Forces Africa'),
('en_US', 7, 'Armed Forces Americas'),
('en_US', 8, 'Armed Forces Canada'),
('en_US', 9, 'Armed Forces Europe'),
('en_US', 10, 'Armed Forces Middle East'),
('en_US', 11, 'Armed Forces Pacific'),
('en_US', 12, 'California'),
('en_US', 13, 'Colorado'),
('en_US', 14, 'Connecticut'),
('en_US', 15, 'Delaware'),
('en_US', 16, 'District of Columbia'),
('en_US', 17, 'Federated States Of Micronesia'),
('en_US', 18, 'Florida'),
('en_US', 19, 'Georgia'),
('en_US', 20, 'Guam'),
('en_US', 21, 'Hawaii'),
('en_US', 22, 'Idaho'),
('en_US', 23, 'Illinois'),
('en_US', 24, 'Indiana'),
('en_US', 25, 'Iowa'),
('en_US', 26, 'Kansas'),
('en_US', 27, 'Kentucky'),
('en_US', 28, 'Louisiana'),
('en_US', 29, 'Maine'),
('en_US', 30, 'Marshall Islands'),
('en_US', 31, 'Maryland'),
('en_US', 32, 'Massachusetts'),
('en_US', 33, 'Michigan'),
('en_US', 34, 'Minnesota'),
('en_US', 35, 'Mississippi'),
('en_US', 36, 'Missouri'),
('en_US', 37, 'Montana'),
('en_US', 38, 'Nebraska'),
('en_US', 39, 'Nevada'),
('en_US', 40, 'New Hampshire'),
('en_US', 41, 'New Jersey'),
('en_US', 42, 'New Mexico'),
('en_US', 43, 'New York'),
('en_US', 44, 'North Carolina'),
('en_US', 45, 'North Dakota'),
('en_US', 46, 'Northern Mariana Islands'),
('en_US', 47, 'Ohio'),
('en_US', 48, 'Oklahoma'),
('en_US', 49, 'Oregon'),
('en_US', 50, 'Palau'),
('en_US', 51, 'Pennsylvania'),
('en_US', 52, 'Puerto Rico'),
('en_US', 53, 'Rhode Island'),
('en_US', 54, 'South Carolina'),
('en_US', 55, 'South Dakota'),
('en_US', 56, 'Tennessee'),
('en_US', 57, 'Texas'),
('en_US', 58, 'Utah'),
('en_US', 59, 'Vermont'),
('en_US', 60, 'Virgin Islands'),
('en_US', 61, 'Virginia'),
('en_US', 62, 'Washington'),
('en_US', 63, 'West Virginia'),
('en_US', 64, 'Wisconsin'),
('en_US', 65, 'Wyoming'),
('en_US', 66, 'Alberta'),
('en_US', 67, 'British Columbia'),
('en_US', 68, 'Manitoba'),
('en_US', 69, 'Newfoundland'),
('en_US', 70, 'New Brunswick'),
('en_US', 71, 'Nova Scotia'),
('en_US', 72, 'Northwest Territories'),
('en_US', 73, 'Nunavut'),
('en_US', 74, 'Ontario'),
('en_US', 75, 'Prince Edward Island'),
('en_US', 76, 'Quebec'),
('en_US', 77, 'Saskatchewan'),
('en_US', 78, 'Yukon Territory'),
('en_US', 79, 'Niedersachsen'),
('en_US', 80, 'Baden-Württemberg'),
('en_US', 81, 'Bayern'),
('en_US', 82, 'Berlin'),
('en_US', 83, 'Brandenburg'),
('en_US', 84, 'Bremen'),
('en_US', 85, 'Hamburg'),
('en_US', 86, 'Hessen'),
('en_US', 87, 'Mecklenburg-Vorpommern'),
('en_US', 88, 'Nordrhein-Westfalen'),
('en_US', 89, 'Rheinland-Pfalz'),
('en_US', 90, 'Saarland'),
('en_US', 91, 'Sachsen'),
('en_US', 92, 'Sachsen-Anhalt'),
('en_US', 93, 'Schleswig-Holstein'),
('en_US', 94, 'Thüringen'),
('en_US', 95, 'Wien'),
('en_US', 96, 'Niederösterreich'),
('en_US', 97, 'Oberösterreich'),
('en_US', 98, 'Salzburg'),
('en_US', 99, 'Kärnten'),
('en_US', 100, 'Steiermark'),
('en_US', 101, 'Tirol'),
('en_US', 102, 'Burgenland'),
('en_US', 103, 'Voralberg'),
('en_US', 104, 'Aargau'),
('en_US', 105, 'Appenzell Innerrhoden'),
('en_US', 106, 'Appenzell Ausserrhoden'),
('en_US', 107, 'Bern'),
('en_US', 108, 'Basel-Landschaft'),
('en_US', 109, 'Basel-Stadt'),
('en_US', 110, 'Freiburg'),
('en_US', 111, 'Genf'),
('en_US', 112, 'Glarus'),
('en_US', 113, 'Graubünden'),
('en_US', 114, 'Jura'),
('en_US', 115, 'Luzern'),
('en_US', 116, 'Neuenburg'),
('en_US', 117, 'Nidwalden'),
('en_US', 118, 'Obwalden'),
('en_US', 119, 'St. Gallen'),
('en_US', 120, 'Schaffhausen'),
('en_US', 121, 'Solothurn'),
('en_US', 122, 'Schwyz'),
('en_US', 123, 'Thurgau'),
('en_US', 124, 'Tessin'),
('en_US', 125, 'Uri'),
('en_US', 126, 'Waadt'),
('en_US', 127, 'Wallis'),
('en_US', 128, 'Zug'),
('en_US', 129, 'Zürich'),
('en_US', 130, 'A Coruña'),
('en_US', 131, 'Alava'),
('en_US', 132, 'Albacete'),
('en_US', 133, 'Alicante'),
('en_US', 134, 'Almeria'),
('en_US', 135, 'Asturias'),
('en_US', 136, 'Avila'),
('en_US', 137, 'Badajoz'),
('en_US', 138, 'Baleares'),
('en_US', 139, 'Barcelona'),
('en_US', 140, 'Burgos'),
('en_US', 141, 'Caceres'),
('en_US', 142, 'Cadiz'),
('en_US', 143, 'Cantabria'),
('en_US', 144, 'Castellon'),
('en_US', 145, 'Ceuta'),
('en_US', 146, 'Ciudad Real'),
('en_US', 147, 'Cordoba'),
('en_US', 148, 'Cuenca'),
('en_US', 149, 'Girona'),
('en_US', 150, 'Granada'),
('en_US', 151, 'Guadalajara'),
('en_US', 152, 'Guipuzcoa'),
('en_US', 153, 'Huelva'),
('en_US', 154, 'Huesca'),
('en_US', 155, 'Jaen'),
('en_US', 156, 'La Rioja'),
('en_US', 157, 'Las Palmas'),
('en_US', 158, 'Leon'),
('en_US', 159, 'Lleida'),
('en_US', 160, 'Lugo'),
('en_US', 161, 'Madrid'),
('en_US', 162, 'Malaga'),
('en_US', 163, 'Melilla'),
('en_US', 164, 'Murcia'),
('en_US', 165, 'Navarra'),
('en_US', 166, 'Ourense'),
('en_US', 167, 'Palencia'),
('en_US', 168, 'Pontevedra'),
('en_US', 169, 'Salamanca'),
('en_US', 170, 'Santa Cruz de Tenerife'),
('en_US', 171, 'Segovia'),
('en_US', 172, 'Sevilla'),
('en_US', 173, 'Soria'),
('en_US', 174, 'Tarragona'),
('en_US', 175, 'Teruel'),
('en_US', 176, 'Toledo'),
('en_US', 177, 'Valencia'),
('en_US', 178, 'Valladolid'),
('en_US', 179, 'Vizcaya'),
('en_US', 180, 'Zamora'),
('en_US', 181, 'Zaragoza'),
('en_US', 182, 'Ain'),
('en_US', 183, 'Aisne'),
('en_US', 184, 'Allier'),
('en_US', 185, 'Alpes-de-Haute-Provence'),
('en_US', 186, 'Hautes-Alpes'),
('en_US', 187, 'Alpes-Maritimes'),
('en_US', 188, 'Ardèche'),
('en_US', 189, 'Ardennes'),
('en_US', 190, 'Ariège'),
('en_US', 191, 'Aube'),
('en_US', 192, 'Aude'),
('en_US', 193, 'Aveyron'),
('en_US', 194, 'Bouches-du-Rhône'),
('en_US', 195, 'Calvados'),
('en_US', 196, 'Cantal'),
('en_US', 197, 'Charente'),
('en_US', 198, 'Charente-Maritime'),
('en_US', 199, 'Cher'),
('en_US', 200, 'Corrèze'),
('en_US', 201, 'Corse-du-Sud'),
('en_US', 202, 'Haute-Corse'),
('en_US', 203, 'Côte-d''Or'),
('en_US', 204, 'Côtes-d''Armor'),
('en_US', 205, 'Creuse'),
('en_US', 206, 'Dordogne'),
('en_US', 207, 'Doubs'),
('en_US', 208, 'Drôme'),
('en_US', 209, 'Eure'),
('en_US', 210, 'Eure-et-Loir'),
('en_US', 211, 'Finistère'),
('en_US', 212, 'Gard'),
('en_US', 213, 'Haute-Garonne'),
('en_US', 214, 'Gers'),
('en_US', 215, 'Gironde'),
('en_US', 216, 'Hérault'),
('en_US', 217, 'Ille-et-Vilaine'),
('en_US', 218, 'Indre'),
('en_US', 219, 'Indre-et-Loire'),
('en_US', 220, 'Isère'),
('en_US', 221, 'Jura'),
('en_US', 222, 'Landes'),
('en_US', 223, 'Loir-et-Cher'),
('en_US', 224, 'Loire'),
('en_US', 225, 'Haute-Loire'),
('en_US', 226, 'Loire-Atlantique'),
('en_US', 227, 'Loiret'),
('en_US', 228, 'Lot'),
('en_US', 229, 'Lot-et-Garonne'),
('en_US', 230, 'Lozère'),
('en_US', 231, 'Maine-et-Loire'),
('en_US', 232, 'Manche'),
('en_US', 233, 'Marne'),
('en_US', 234, 'Haute-Marne'),
('en_US', 235, 'Mayenne'),
('en_US', 236, 'Meurthe-et-Moselle'),
('en_US', 237, 'Meuse'),
('en_US', 238, 'Morbihan'),
('en_US', 239, 'Moselle'),
('en_US', 240, 'Nièvre'),
('en_US', 241, 'Nord'),
('en_US', 242, 'Oise'),
('en_US', 243, 'Orne'),
('en_US', 244, 'Pas-de-Calais'),
('en_US', 245, 'Puy-de-Dôme'),
('en_US', 246, 'Pyrénées-Atlantiques'),
('en_US', 247, 'Hautes-Pyrénées'),
('en_US', 248, 'Pyrénées-Orientales'),
('en_US', 249, 'Bas-Rhin'),
('en_US', 250, 'Haut-Rhin'),
('en_US', 251, 'Rhône'),
('en_US', 252, 'Haute-Saône'),
('en_US', 253, 'Saône-et-Loire'),
('en_US', 254, 'Sarthe'),
('en_US', 255, 'Savoie'),
('en_US', 256, 'Haute-Savoie'),
('en_US', 257, 'Paris'),
('en_US', 258, 'Seine-Maritime'),
('en_US', 259, 'Seine-et-Marne'),
('en_US', 260, 'Yvelines'),
('en_US', 261, 'Deux-Sèvres'),
('en_US', 262, 'Somme'),
('en_US', 263, 'Tarn'),
('en_US', 264, 'Tarn-et-Garonne'),
('en_US', 265, 'Var'),
('en_US', 266, 'Vaucluse'),
('en_US', 267, 'Vendée'),
('en_US', 268, 'Vienne'),
('en_US', 269, 'Haute-Vienne'),
('en_US', 270, 'Vosges'),
('en_US', 271, 'Yonne'),
('en_US', 272, 'Territoire-de-Belfort'),
('en_US', 273, 'Essonne'),
('en_US', 274, 'Hauts-de-Seine'),
('en_US', 275, 'Seine-Saint-Denis'),
('en_US', 276, 'Val-de-Marne'),
('en_US', 277, 'Val-d''Oise');

--
-- Table structure for table `directory_currency_rate`
--

CREATE TABLE IF NOT EXISTS `directory_currency_rate` (
  `currency_from` char(3) NOT NULL DEFAULT '',
  `currency_to` char(3) NOT NULL DEFAULT '',
  `rate` decimal(24,12) NOT NULL DEFAULT '0.000000000000',
  PRIMARY KEY (`currency_from`,`currency_to`),
  KEY `FK_CURRENCY_RATE_TO` (`currency_to`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `directory_currency_rate`
--

INSERT INTO `directory_currency_rate` (`currency_from`, `currency_to`, `rate`) VALUES
('EUR', 'EUR', 1.000000000000),
('EUR', 'USD', 1.415000000000),
('USD', 'EUR', 0.706700000000),
('USD', 'USD', 1.000000000000),
('INR', 'EUR', 0.014710600000),
('INR', 'INR', 1.000000000000),
('INR', 'USD', 0.021418600000);

--
-- Table structure for table `downloadable_link`
--

CREATE TABLE IF NOT EXISTS `downloadable_link` (
  `link_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `product_id` int(10) unsigned NOT NULL DEFAULT '0',
  `sort_order` int(10) unsigned NOT NULL DEFAULT '0',
  `number_of_downloads` int(10) unsigned DEFAULT NULL,
  `is_shareable` smallint(1) unsigned NOT NULL DEFAULT '0',
  `link_url` varchar(255) NOT NULL DEFAULT '',
  `link_file` varchar(255) NOT NULL DEFAULT '',
  `link_type` varchar(20) NOT NULL DEFAULT '',
  `sample_url` varchar(255) NOT NULL DEFAULT '',
  `sample_file` varchar(255) NOT NULL DEFAULT '',
  `sample_type` varchar(20) NOT NULL DEFAULT '',
  PRIMARY KEY (`link_id`),
  KEY `DOWNLODABLE_LINK_PRODUCT` (`product_id`),
  KEY `DOWNLODABLE_LINK_PRODUCT_SORT_ORDER` (`product_id`,`sort_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `downloadable_link_price`
--

CREATE TABLE IF NOT EXISTS `downloadable_link_price` (
  `price_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `link_id` int(10) unsigned NOT NULL DEFAULT '0',
  `website_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `price` decimal(12,4) NOT NULL DEFAULT '0.0000',
  PRIMARY KEY (`price_id`),
  KEY `DOWNLOADABLE_LINK_PRICE_LINK` (`link_id`),
  KEY `DOWNLOADABLE_LINK_PRICE_WEBSITE` (`website_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `downloadable_link_purchased`
--

CREATE TABLE IF NOT EXISTS `downloadable_link_purchased` (
  `purchased_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `order_id` int(10) unsigned NOT NULL DEFAULT '0',
  `order_increment_id` varchar(50) NOT NULL DEFAULT '',
  `order_item_id` int(10) unsigned NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `customer_id` int(10) unsigned NOT NULL DEFAULT '0',
  `product_name` varchar(255) NOT NULL DEFAULT '',
  `product_sku` varchar(255) NOT NULL DEFAULT '',
  `link_section_title` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`purchased_id`),
  KEY `DOWNLOADABLE_ORDER_ID` (`order_id`),
  KEY `DOWNLOADABLE_CUSTOMER_ID` (`customer_id`),
  KEY `KEY_DOWNLOADABLE_ORDER_ITEM_ID` (`order_item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `downloadable_link_purchased_item`
--

CREATE TABLE IF NOT EXISTS `downloadable_link_purchased_item` (
  `item_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `purchased_id` int(10) unsigned NOT NULL DEFAULT '0',
  `order_item_id` int(10) unsigned NOT NULL DEFAULT '0',
  `product_id` int(10) unsigned DEFAULT '0',
  `link_hash` varchar(255) NOT NULL DEFAULT '',
  `number_of_downloads_bought` int(10) unsigned NOT NULL DEFAULT '0',
  `number_of_downloads_used` int(10) unsigned NOT NULL DEFAULT '0',
  `link_id` int(20) unsigned NOT NULL DEFAULT '0',
  `link_title` varchar(255) NOT NULL DEFAULT '',
  `is_shareable` smallint(1) unsigned NOT NULL DEFAULT '0',
  `link_url` varchar(255) NOT NULL DEFAULT '',
  `link_file` varchar(255) NOT NULL DEFAULT '',
  `link_type` varchar(255) NOT NULL DEFAULT '',
  `status` varchar(50) NOT NULL DEFAULT '',
  `created_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`item_id`),
  KEY `DOWNLOADABLE_LINK_PURCHASED_ID` (`purchased_id`),
  KEY `DOWNLOADABLE_ORDER_ITEM_ID` (`order_item_id`),
  KEY `DOWNLOADALBE_LINK_HASH` (`link_hash`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `downloadable_link_title`
--

CREATE TABLE IF NOT EXISTS `downloadable_link_title` (
  `title_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `link_id` int(10) unsigned NOT NULL DEFAULT '0',
  `store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `title` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`title_id`),
  KEY `DOWNLOADABLE_LINK_TITLE_LINK` (`link_id`),
  KEY `DOWNLOADABLE_LINK_TITLE_STORE` (`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `downloadable_sample`
--

CREATE TABLE IF NOT EXISTS `downloadable_sample` (
  `sample_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `product_id` int(10) unsigned NOT NULL DEFAULT '0',
  `sample_url` varchar(255) NOT NULL DEFAULT '',
  `sample_file` varchar(255) NOT NULL DEFAULT '',
  `sample_type` varchar(20) NOT NULL DEFAULT '',
  `sort_order` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`sample_id`),
  KEY `DOWNLODABLE_SAMPLE_PRODUCT` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `downloadable_sample_title`
--

CREATE TABLE IF NOT EXISTS `downloadable_sample_title` (
  `title_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `sample_id` int(10) unsigned NOT NULL DEFAULT '0',
  `store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `title` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`title_id`),
  KEY `DOWNLOADABLE_SAMPLE_TITLE_SAMPLE` (`sample_id`),
  KEY `DOWNLOADABLE_SAMPLE_TITLE_STORE` (`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `eav_attribute`
--

CREATE TABLE IF NOT EXISTS `eav_attribute` (
  `attribute_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `entity_type_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `attribute_code` varchar(255) NOT NULL DEFAULT '',
  `attribute_model` varchar(255) DEFAULT NULL,
  `backend_model` varchar(255) DEFAULT NULL,
  `backend_type` enum('static','datetime','decimal','int','text','varchar') NOT NULL DEFAULT 'static',
  `backend_table` varchar(255) DEFAULT NULL,
  `frontend_model` varchar(255) DEFAULT NULL,
  `frontend_input` varchar(50) DEFAULT NULL,
  `frontend_input_renderer` varchar(255) DEFAULT NULL,
  `frontend_label` varchar(255) DEFAULT NULL,
  `frontend_class` varchar(255) DEFAULT NULL,
  `source_model` varchar(255) DEFAULT NULL,
  `is_global` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `is_visible` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `is_required` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `is_user_defined` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `default_value` text,
  `is_searchable` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `is_filterable` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `is_comparable` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `is_visible_on_front` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `is_html_allowed_on_front` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `is_unique` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `is_used_for_price_rules` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `is_filterable_in_search` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `used_in_product_listing` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `used_for_sort_by` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `is_configurable` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `apply_to` varchar(255) NOT NULL,
  `position` int(11) NOT NULL,
  `note` varchar(255) NOT NULL,
  `is_visible_in_advanced_search` tinyint(1) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`attribute_id`),
  UNIQUE KEY `entity_type_id` (`entity_type_id`,`attribute_code`),
  KEY `IDX_USED_FOR_SORT_BY` (`entity_type_id`,`used_for_sort_by`),
  KEY `IDX_USED_IN_PRODUCT_LISTING` (`entity_type_id`,`used_in_product_listing`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=512 ;

--
-- Dumping data for table `eav_attribute`
--

INSERT INTO `eav_attribute` (`attribute_id`, `entity_type_id`, `attribute_code`, `attribute_model`, `backend_model`, `backend_type`, `backend_table`, `frontend_model`, `frontend_input`, `frontend_input_renderer`, `frontend_label`, `frontend_class`, `source_model`, `is_global`, `is_visible`, `is_required`, `is_user_defined`, `default_value`, `is_searchable`, `is_filterable`, `is_comparable`, `is_visible_on_front`, `is_html_allowed_on_front`, `is_unique`, `is_used_for_price_rules`, `is_filterable_in_search`, `used_in_product_listing`, `used_for_sort_by`, `is_configurable`, `apply_to`, `position`, `note`, `is_visible_in_advanced_search`) VALUES
(1, 1, 'website_id', NULL, 'customer/customer_attribute_backend_website', 'static', '', '', 'select', '', 'Associate to Website', '', 'customer/customer_attribute_source_website', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 1, '', 0),
(2, 1, 'store_id', NULL, 'customer/customer_attribute_backend_store', 'static', '', '', 'select', '', 'Create In', '', 'customer/customer_attribute_source_store', 1, 0, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 1, '', 0),
(3, 1, 'created_in', NULL, '', 'varchar', '', '', 'text', '', 'Created From', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 1, '', 0),
(4, 1, 'prefix', NULL, '', 'varchar', '', '', 'text', '', 'Prefix', '', '', 1, 1, 0, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 1, '', 0),
(5, 1, 'firstname', NULL, '', 'varchar', '', '', 'text', '', 'First Name', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 1, '', 0),
(6, 1, 'middlename', NULL, '', 'varchar', '', '', 'text', '', 'Middle Name/Initial', '', '', 1, 1, 0, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 1, '', 0),
(7, 1, 'lastname', NULL, '', 'varchar', '', '', 'text', '', 'Last Name', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 1, '', 0),
(8, 1, 'suffix', NULL, '', 'varchar', '', '', 'text', '', 'Suffix', '', '', 1, 1, 0, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 1, '', 0),
(9, 1, 'email', NULL, '', 'static', '', '', 'text', '', 'Email', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 1, '', 0),
(10, 1, 'group_id', NULL, '', 'static', '', '', 'select', '', 'Customer Group', '', 'customer/customer_attribute_source_group', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 1, '', 0),
(11, 1, 'dob', NULL, 'eav/entity_attribute_backend_datetime', 'datetime', '', '', 'date', '', 'Date Of Birth', '', '', 1, 1, 0, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 1, '', 0),
(12, 1, 'password_hash', NULL, 'customer/customer_attribute_backend_password', 'varchar', '', '', 'hidden', '', '', '', '', 1, 1, 0, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 1, '', 0),
(13, 1, 'default_billing', NULL, 'customer/customer_attribute_backend_billing', 'int', '', '', 'text', '', '', '', '', 1, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 1, '', 0),
(14, 1, 'default_shipping', NULL, 'customer/customer_attribute_backend_shipping', 'int', '', '', 'text', '', '', '', '', 1, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 1, '', 0),
(15, 1, 'taxvat', NULL, '', 'varchar', '', '', 'text', '', 'Tax/VAT number', '', '', 1, 1, 0, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 1, '', 0),
(16, 1, 'confirmation', NULL, '', 'varchar', '', '', 'text', '', 'Is confirmed', '', '', 1, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 1, '', 0),
(17, 2, 'prefix', NULL, '', 'varchar', '', '', 'text', '', 'Prefix', '', '', 1, 1, 0, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 1, '', 0),
(18, 2, 'firstname', NULL, '', 'varchar', '', '', 'text', '', 'First Name', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 1, '', 0),
(19, 2, 'middlename', NULL, '', 'varchar', '', '', 'text', '', 'Middle Name/Initial', '', '', 1, 1, 0, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 1, '', 0),
(20, 2, 'lastname', NULL, '', 'varchar', '', '', 'text', '', 'Last Name', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 1, '', 0),
(21, 2, 'suffix', NULL, '', 'varchar', '', '', 'text', '', 'Suffix', '', '', 1, 1, 0, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 1, '', 0),
(22, 2, 'company', NULL, '', 'varchar', '', '', 'text', '', 'Company', '', '', 1, 1, 0, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 1, '', 0),
(23, 2, 'street', NULL, 'customer_entity/address_attribute_backend_street', 'text', '', '', 'multiline', '', 'Street Address', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 1, '', 0),
(24, 2, 'city', NULL, '', 'varchar', '', '', 'text', '', 'City', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 1, '', 0),
(25, 2, 'country_id', NULL, '', 'varchar', '', '', 'select', '', 'Country', '', 'customer_entity/address_attribute_source_country', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 1, '', 0),
(26, 2, 'region', NULL, 'customer_entity/address_attribute_backend_region', 'varchar', '', '', 'text', '', 'State/Province', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 1, '', 0),
(27, 2, 'region_id', NULL, '', 'int', '', '', 'hidden', '', '', '', 'customer_entity/address_attribute_source_region', 1, 1, 0, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 1, '', 0),
(28, 2, 'postcode', NULL, '', 'varchar', '', '', 'text', '', 'Zip/Postal Code', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 1, '', 0),
(29, 2, 'telephone', NULL, '', 'varchar', '', '', 'text', '', 'Telephone', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 1, '', 0),
(30, 2, 'fax', NULL, '', 'varchar', '', '', 'text', '', 'Fax', '', '', 1, 1, 0, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 1, '', 0),
(31, 3, 'name', NULL, '', 'varchar', '', '', 'text', '', 'Name', '', '', 0, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 1, '', 0),
(32, 3, 'is_active', NULL, '', 'int', '', '', 'select', '', 'Is Active', '', 'eav/entity_attribute_source_boolean', 0, 1, 0, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 1, '', 0),
(33, 3, 'url_key', NULL, 'catalog/category_attribute_backend_urlkey', 'varchar', '', '', 'text', '', 'URL key', '', '', 1, 1, 0, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 1, '', 0),
(34, 3, 'description', NULL, '', 'text', '', '', 'textarea', '', 'Description', '', '', 0, 1, 0, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 1, '', 0),
(35, 3, 'image', NULL, 'catalog/category_attribute_backend_image', 'varchar', '', '', 'image', '', 'Image', '', '', 0, 1, 0, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 1, '', 0),
(36, 3, 'meta_title', NULL, '', 'varchar', '', '', 'text', '', 'Page Title', '', '', 0, 1, 0, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 1, '', 0),
(37, 3, 'meta_keywords', NULL, '', 'text', '', '', 'textarea', '', 'Meta Keywords', '', '', 0, 1, 0, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 1, '', 0),
(38, 3, 'meta_description', NULL, '', 'text', '', '', 'textarea', '', 'Meta Description', '', '', 0, 1, 0, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 1, '', 0),
(39, 3, 'display_mode', NULL, '', 'varchar', '', '', 'select', '', 'Display Mode', '', 'catalog/category_attribute_source_mode', 0, 1, 0, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 1, '', 0),
(40, 3, 'landing_page', NULL, '', 'int', '', '', 'select', '', 'CMS Block', '', 'catalog/category_attribute_source_page', 0, 1, 0, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 1, '', 0),
(41, 3, 'is_anchor', NULL, '', 'int', '', '', 'select', '', 'Is Anchor', '', 'eav/entity_attribute_source_boolean', 1, 1, 0, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 1, '', 0),
(42, 3, 'path', NULL, '', 'static', '', '', '', '', 'Path', '', '', 1, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 1, '', 0),
(43, 3, 'position', NULL, '', 'static', '', '', '', '', 'Position', '', '', 1, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 1, '', 0),
(44, 3, 'all_children', NULL, '', 'text', '', '', '', '', '', '', '', 1, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 1, '', 0),
(45, 3, 'path_in_store', NULL, '', 'text', '', '', '', '', '', '', '', 1, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 1, '', 0),
(46, 3, 'children', NULL, '', 'text', '', '', '', '', '', '', '', 1, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 1, '', 0),
(47, 3, 'url_path', NULL, '', 'varchar', '', '', '', '', '', '', '', 0, 0, 0, 0, '', 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, '', 1, '', 0),
(48, 3, 'custom_design', NULL, '', 'varchar', '', '', 'select', '', 'Custom Design', '', 'core/design_source_design', 0, 1, 0, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 1, '', 0),
(49, 3, 'custom_design_apply', NULL, '', 'int', '', '', 'select', '', 'Apply To', '', 'core/design_source_apply', 0, 1, 0, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 1, '', 0),
(50, 3, 'custom_design_from', NULL, 'eav/entity_attribute_backend_datetime', 'datetime', '', '', 'date', '', 'Active From', '', '', 0, 1, 0, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 1, '', 0),
(51, 3, 'custom_design_to', NULL, 'eav/entity_attribute_backend_datetime', 'datetime', '', '', 'date', '', 'Active To', '', '', 0, 1, 0, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 1, '', 0),
(52, 3, 'page_layout', NULL, '', 'varchar', '', '', 'select', '', 'Page Layout', '', 'catalog/category_attribute_source_layout', 0, 1, 0, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 1, '', 0),
(53, 3, 'custom_layout_update', NULL, '', 'text', '', '', 'textarea', '', 'Custom Layout Update', '', '', 0, 1, 0, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 1, '', 0),
(54, 3, 'level', NULL, '', 'static', '', '', '', '', 'Level', '', '', 1, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(55, 3, 'children_count', NULL, '', 'static', '', '', '', '', 'Children Count', '', '', 1, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 1, '', 0),
(56, 4, 'name', NULL, '', 'varchar', '', '', 'text', '', 'Name', '', '', 0, 1, 1, 0, '', 1, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, '', 1, '', 1),
(57, 4, 'description', NULL, '', 'text', '', '', 'textarea', '', 'Description', '', '', 0, 1, 0, 0, '', 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, '', 1, '', 1),
(58, 4, 'short_description', NULL, '', 'text', '', '', 'textarea', '', 'Short Description', '', '', 0, 1, 0, 0, '', 0, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, '', 1, '', 1),
(59, 4, 'sku', NULL, '', 'static', '', '', 'text', '', 'SKU', '', '', 1, 1, 1, 0, '', 0, 0, 1, 0, 0, 1, 1, 0, 0, 0, 1, '', 1, '', 1),
(60, 4, 'price', NULL, 'catalog/product_attribute_backend_price', 'decimal', '', '', 'price', '', 'Price', '', '', 2, 1, 1, 0, '', 0, 1, 0, 0, 0, 0, 1, 0, 1, 1, 1, 'simple,configurable,virtual,bundle,downloadable', 0, '', 1),
(61, 4, 'special_price', NULL, 'catalog/product_attribute_backend_price', 'decimal', '', '', 'price', '', 'Special Price', '', '', 2, 1, 0, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 'simple,configurable,virtual,bundle,downloadable', 1, '', 0),
(62, 4, 'special_from_date', NULL, 'catalog/product_attribute_backend_startdate', 'datetime', '', '', 'date', '', 'Special Price From Date', '', '', 2, 1, 0, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 'simple,configurable,virtual,bundle,downloadable', 1, '', 0),
(63, 4, 'special_to_date', NULL, 'eav/entity_attribute_backend_datetime', 'datetime', '', '', 'date', '', 'Special Price To Date', '', '', 2, 1, 0, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 'simple,configurable,virtual,bundle,downloadable', 1, '', 0),
(64, 4, 'cost', NULL, 'catalog/product_attribute_backend_price', 'decimal', '', '', 'price', '', 'Cost', '', '', 2, 1, 0, 1, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 'simple,configurable,virtual,bundle,downloadable', 1, '', 0),
(65, 4, 'weight', NULL, '', 'decimal', '', '', 'text', '', 'Weight', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 'simple,bundle', 1, '', 0),
(66, 4, 'manufacturer', NULL, '', 'int', '', '', 'select', '', 'Manufacturer', '', '', 1, 1, 0, 1, '', 0, 1, 1, 0, 0, 0, 1, 0, 0, 0, 1, 'simple', 1, '', 1),
(67, 4, 'meta_title', NULL, '', 'varchar', '', '', 'text', '', 'Meta Title', '', '', 0, 1, 0, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 1, '', 0),
(68, 4, 'meta_keyword', NULL, '', 'text', '', '', 'textarea', '', 'Meta Keywords', '', '', 0, 1, 0, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 1, '', 0),
(69, 4, 'meta_description', NULL, '', 'varchar', '', '', 'textarea', '', 'Meta Description', '', '', 0, 1, 0, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 1, 'Maximum 255 chars', 0),
(70, 4, 'image', NULL, '', 'varchar', '', 'catalog/product_attribute_frontend_image', 'media_image', '', 'Base Image', '', '', 0, 1, 0, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 1, '', 0),
(71, 4, 'small_image', NULL, '', 'varchar', '', 'catalog/product_attribute_frontend_image', 'media_image', '', 'Small Image', '', '', 0, 1, 0, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, '', 1, '', 0),
(72, 4, 'thumbnail', NULL, '', 'varchar', '', 'catalog/product_attribute_frontend_image', 'media_image', '', 'Thumbnail', '', '', 0, 1, 0, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, '', 1, '', 0),
(73, 4, 'media_gallery', NULL, 'catalog/product_attribute_backend_media', 'varchar', '', '', 'gallery', '', 'Media Gallery', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 1, '', 0),
(74, 4, 'old_id', NULL, '', 'int', '', '', '', '', '', '', '', 1, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 1, '', 0),
(75, 4, 'tier_price', NULL, 'catalog/product_attribute_backend_tierprice', 'decimal', '', '', 'text', '', 'Tier Price', '', '', 2, 1, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 'simple,configurable,virtual,bundle,downloadable', 1, '', 0),
(76, 4, 'color', NULL, '', 'int', '', '', 'select', '', 'Color', '', '', 1, 1, 0, 1, '', 0, 1, 1, 0, 0, 0, 1, 0, 0, 0, 1, 'simple', 1, '', 1),
(77, 4, 'news_from_date', NULL, 'eav/entity_attribute_backend_datetime', 'datetime', '', '', 'date', '', 'Set Product as New from Date', '', '', 2, 1, 0, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, '', 1, '', 0),
(78, 4, 'news_to_date', NULL, 'eav/entity_attribute_backend_datetime', 'datetime', '', '', 'date', '', 'Set Product as New to Date', '', '', 2, 1, 0, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, '', 1, '', 0),
(79, 4, 'gallery', NULL, '', 'varchar', '', '', 'gallery', '', 'Image Gallery', '', '', 1, 1, 0, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 1, '', 0),
(80, 4, 'status', NULL, '', 'int', '', '', 'select', '', 'Status', '', 'catalog/product_status', 2, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, '', 1, '', 0),
(81, 4, 'tax_class_id', NULL, '', 'int', '', '', 'select', '', 'Tax Class', '', 'tax/class_source_product', 2, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 'simple,configurable,virtual,bundle,downloadable', 1, '', 1),
(82, 4, 'url_key', NULL, 'catalog/product_attribute_backend_urlkey', 'varchar', '', '', 'text', '', 'URL key', '', '', 1, 1, 0, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, '', 1, '', 0),
(83, 4, 'url_path', NULL, '', 'varchar', '', '', '', '', '', '', '', 0, 0, 0, 0, '', 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, '', 1, '', 0),
(84, 4, 'minimal_price', NULL, '', 'decimal', '', '', 'price', '', 'Minimal Price', '', '', 0, 0, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 'simple,configurable,virtual,bundle,downloadable', 1, '', 0),
(85, 4, 'visibility', NULL, '', 'int', '', '', 'select', '', 'Visibility', '', 'catalog/product_visibility', 0, 1, 1, 0, '4', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 1, '', 0),
(86, 4, 'custom_design', NULL, '', 'varchar', '', '', 'select', '', 'Custom Design', '', 'core/design_source_design', 0, 1, 0, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 1, '', 0),
(87, 4, 'custom_design_from', NULL, 'eav/entity_attribute_backend_datetime', 'datetime', '', '', 'date', '', 'Active From', '', '', 0, 1, 0, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 1, '', 0),
(88, 4, 'custom_design_to', NULL, 'eav/entity_attribute_backend_datetime', 'datetime', '', '', 'date', '', 'Active To', '', '', 0, 1, 0, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 1, '', 0),
(89, 4, 'custom_layout_update', NULL, '', 'text', '', '', 'textarea', '', 'Custom Layout Update', '', '', 1, 1, 0, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 1, '', 0),
(90, 4, 'page_layout', NULL, '', 'varchar', '', '', 'select', '', 'Page Layout', '', 'catalog/product_attribute_source_layout', 0, 1, 0, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(91, 4, 'category_ids', NULL, '', 'static', '', '', '', '', '', '', '', 1, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 1, '', 0),
(92, 4, 'options_container', NULL, '', 'varchar', '', '', 'select', '', 'Display product options in', '', 'catalog/entity_product_attribute_design_options_container', 0, 1, 0, 0, 'container2', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(93, 4, 'required_options', NULL, '', 'static', '', '', 'text', '', '', '', '', 1, 0, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, '', 0, '', 0),
(94, 4, 'has_options', NULL, '', 'static', '', '', 'text', '', '', '', '', 1, 0, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(95, 4, 'image_label', NULL, '', 'varchar', '', '', 'text', '', 'Image Label', '', '', 0, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, '', 0, '', 0),
(96, 4, 'small_image_label', NULL, '', 'varchar', '', '', 'text', '', 'Small Image Label', '', '', 0, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, '', 0, '', 0),
(97, 4, 'thumbnail_label', NULL, '', 'varchar', '', '', 'text', '', 'Thumbnail Label', '', '', 0, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, '', 0, '', 0),
(98, 3, 'available_sort_by', NULL, 'catalog/category_attribute_backend_sortby', 'text', '', '', 'multiselect', 'adminhtml/catalog_category_helper_sortby_available', 'Available Product Listing Sort by', '', 'catalog/category_attribute_source_sortby', 0, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(99, 3, 'default_sort_by', NULL, 'catalog/category_attribute_backend_sortby', 'varchar', '', '', 'select', 'adminhtml/catalog_category_helper_sortby_default', 'Default Product Listing Sort by', '', 'catalog/category_attribute_source_sortby', 0, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(100, 4, 'created_at', NULL, 'eav/entity_attribute_backend_time_created', 'static', '', '', 'text', '', '', '', '', 1, 0, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(101, 4, 'updated_at', NULL, 'eav/entity_attribute_backend_time_updated', 'static', '', '', 'text', '', '', '', '', 1, 0, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(102, 11, 'entity_id', NULL, 'sales_entity/order_attribute_backend_parent', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(103, 11, 'store_id', NULL, '', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(104, 11, 'store_name', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(105, 11, 'remote_ip', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(106, 11, 'status', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(107, 11, 'state', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(108, 11, 'hold_before_status', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(109, 11, 'hold_before_state', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(110, 11, 'relation_parent_id', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(111, 11, 'relation_parent_real_id', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(112, 11, 'relation_child_id', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(113, 11, 'relation_child_real_id', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(114, 11, 'original_increment_id', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(115, 11, 'edit_increment', NULL, '', 'int', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(116, 11, 'ext_order_id', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(117, 11, 'ext_customer_id', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(118, 11, 'quote_id', NULL, '', 'int', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(119, 11, 'quote_address_id', NULL, '', 'int', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(120, 11, 'billing_address_id', NULL, 'sales_entity/order_attribute_backend_billing', 'int', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(121, 11, 'shipping_address_id', NULL, 'sales_entity/order_attribute_backend_shipping', 'int', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(122, 11, 'coupon_code', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(123, 11, 'applied_rule_ids', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(124, 11, 'giftcert_code', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(125, 11, 'global_currency_code', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(126, 11, 'base_currency_code', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(127, 11, 'store_currency_code', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(128, 11, 'order_currency_code', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(129, 11, 'store_to_base_rate', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(130, 11, 'store_to_order_rate', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(131, 11, 'base_to_global_rate', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(132, 11, 'base_to_order_rate', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(133, 11, 'is_virtual', NULL, '', 'int', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(134, 11, 'shipping_method', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(135, 11, 'shipping_description', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(136, 11, 'weight', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(137, 11, 'tax_amount', NULL, '', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(138, 11, 'shipping_amount', NULL, '', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(139, 11, 'shipping_tax_amount', NULL, '', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(140, 11, 'discount_amount', NULL, '', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(141, 11, 'giftcert_amount', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(142, 11, 'subtotal', NULL, '', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(143, 11, 'grand_total', NULL, '', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(144, 11, 'total_paid', NULL, '', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(145, 11, 'total_due', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(146, 11, 'total_refunded', NULL, '', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(147, 11, 'total_qty_ordered', NULL, '', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(148, 11, 'total_canceled', NULL, '', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(149, 11, 'total_invoiced', NULL, '', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(150, 11, 'total_online_refunded', NULL, '', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(151, 11, 'total_offline_refunded', NULL, '', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(152, 11, 'adjustment_positive', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(153, 11, 'adjustment_negative', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(154, 11, 'base_tax_amount', NULL, '', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(155, 11, 'base_shipping_amount', NULL, '', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(156, 11, 'base_shipping_tax_amount', NULL, '', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(157, 11, 'base_discount_amount', NULL, '', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(158, 11, 'base_giftcert_amount', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(159, 11, 'base_subtotal', NULL, '', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(160, 11, 'base_grand_total', NULL, '', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(161, 11, 'base_total_paid', NULL, '', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(162, 11, 'base_total_due', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(163, 11, 'base_total_refunded', NULL, '', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(164, 11, 'base_total_qty_ordered', NULL, '', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(165, 11, 'base_total_canceled', NULL, '', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(166, 11, 'base_total_invoiced', NULL, '', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(167, 11, 'base_total_online_refunded', NULL, '', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(168, 11, 'base_total_offline_refunded', NULL, '', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(169, 11, 'base_adjustment_positive', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(170, 11, 'base_adjustment_negative', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(171, 11, 'subtotal_refunded', NULL, '', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(172, 11, 'subtotal_canceled', NULL, '', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(173, 11, 'discount_refunded', NULL, '', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(174, 11, 'discount_canceled', NULL, '', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(175, 11, 'discount_invoiced', NULL, '', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(176, 11, 'subtotal_invoiced', NULL, '', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(177, 11, 'tax_refunded', NULL, '', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(178, 11, 'tax_canceled', NULL, '', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(179, 11, 'tax_invoiced', NULL, '', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(180, 11, 'shipping_refunded', NULL, '', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(181, 11, 'shipping_canceled', NULL, '', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(182, 11, 'shipping_invoiced', NULL, '', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(183, 11, 'base_subtotal_refunded', NULL, '', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(184, 11, 'base_subtotal_canceled', NULL, '', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(185, 11, 'base_discount_refunded', NULL, '', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(186, 11, 'base_discount_canceled', NULL, '', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(187, 11, 'base_discount_invoiced', NULL, '', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(188, 11, 'base_subtotal_invoiced', NULL, '', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(189, 11, 'base_tax_refunded', NULL, '', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(190, 11, 'base_tax_canceled', NULL, '', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(191, 11, 'base_tax_invoiced', NULL, '', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(192, 11, 'base_shipping_refunded', NULL, '', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(193, 11, 'base_shipping_canceled', NULL, '', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(194, 11, 'base_shipping_invoiced', NULL, '', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(195, 11, 'customer_id', NULL, '', 'static', '', '', 'text', '', '', '', '', 1, 0, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(196, 11, 'customer_group_id', NULL, '', 'int', '', '', 'text', '', '', '', '', 1, 0, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(197, 11, 'customer_email', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 0, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(198, 11, 'customer_prefix', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 0, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(199, 11, 'customer_firstname', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 0, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(200, 11, 'customer_middlename', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 0, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(201, 11, 'customer_lastname', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 0, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(202, 11, 'customer_suffix', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 0, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(203, 11, 'customer_note', NULL, '', 'text', '', '', 'text', '', '', '', '', 1, 0, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(204, 11, 'customer_note_notify', NULL, '', 'int', '', '', 'text', '', '', '', '', 1, 0, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(205, 11, 'customer_is_guest', NULL, '', 'int', '', '', 'text', '', '', '', '', 1, 0, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(206, 11, 'email_sent', NULL, '', 'int', '', '', 'text', '', '', '', '', 1, 0, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(207, 11, 'customer_taxvat', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 0, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(208, 11, 'customer_dob', NULL, 'eav/entity_attribute_backend_datetime', 'datetime', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(209, 12, 'parent_id', NULL, 'sales_entity/order_attribute_backend_child', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(210, 12, 'quote_address_id', NULL, '', 'int', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(211, 12, 'address_type', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(212, 12, 'customer_id', NULL, '', 'int', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(213, 12, 'customer_address_id', NULL, '', 'int', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(214, 12, 'email', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(215, 12, 'prefix', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(216, 12, 'firstname', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(217, 12, 'middlename', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(218, 12, 'lastname', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(219, 12, 'suffix', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(220, 12, 'company', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(221, 12, 'street', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(222, 12, 'city', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(223, 12, 'region', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(224, 12, 'region_id', NULL, '', 'int', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(225, 12, 'postcode', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(226, 12, 'country_id', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(227, 12, 'telephone', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(228, 12, 'fax', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(229, 13, 'parent_id', NULL, 'sales_entity/order_attribute_backend_child', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(230, 13, 'quote_item_id', NULL, '', 'int', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(231, 13, 'product_id', NULL, '', 'int', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(232, 13, 'super_product_id', NULL, '', 'int', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(233, 13, 'parent_product_id', NULL, '', 'int', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(234, 13, 'is_virtual', NULL, '', 'int', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(235, 13, 'sku', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(236, 13, 'name', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(237, 13, 'description', NULL, '', 'text', '', '', 'text', '', '', '', '', 1, 1, 0, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(238, 13, 'weight', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(239, 13, 'is_qty_decimal', NULL, '', 'int', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(240, 13, 'qty_ordered', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(241, 13, 'qty_backordered', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(242, 13, 'qty_invoiced', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(243, 13, 'qty_canceled', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(244, 13, 'qty_shipped', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(245, 13, 'qty_refunded', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(246, 13, 'original_price', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(247, 13, 'price', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(248, 13, 'cost', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(249, 13, 'discount_percent', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(250, 13, 'discount_amount', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(251, 13, 'discount_invoiced', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(252, 13, 'tax_percent', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(253, 13, 'tax_amount', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(254, 13, 'tax_invoiced', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(255, 13, 'row_total', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(256, 13, 'row_weight', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(257, 13, 'row_invoiced', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(258, 13, 'invoiced_total', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(259, 13, 'amount_refunded', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(260, 13, 'base_price', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(261, 13, 'base_original_price', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(262, 13, 'base_discount_amount', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(263, 13, 'base_discount_invoiced', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(264, 13, 'base_tax_amount', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(265, 13, 'base_tax_invoiced', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(266, 13, 'base_row_total', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(267, 13, 'base_row_invoiced', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(268, 13, 'base_invoiced_total', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(269, 13, 'base_amount_refunded', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(270, 13, 'applied_rule_ids', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(271, 13, 'additional_data', NULL, '', 'text', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(272, 14, 'parent_id', NULL, 'sales_entity/order_attribute_backend_child', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(273, 14, 'quote_payment_id', NULL, '', 'int', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(274, 14, 'method', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(275, 14, 'additional_data', NULL, '', 'text', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(276, 14, 'last_trans_id', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(277, 14, 'po_number', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(278, 14, 'cc_type', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(279, 14, 'cc_number_enc', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(280, 14, 'cc_last4', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(281, 14, 'cc_owner', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(282, 14, 'cc_exp_month', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(283, 14, 'cc_exp_year', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(284, 14, 'cc_ss_issue', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(285, 14, 'cc_ss_start_month', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(286, 14, 'cc_ss_start_year', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(287, 14, 'cc_status', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(288, 14, 'cc_status_description', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(289, 14, 'cc_trans_id', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(290, 14, 'cc_approval', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(291, 14, 'cc_avs_status', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(292, 14, 'cc_cid_status', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(293, 14, 'cc_debug_request_body', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(294, 14, 'cc_debug_response_body', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(295, 14, 'cc_debug_response_serialized', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(296, 14, 'anet_trans_method', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(297, 14, 'echeck_routing_number', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(298, 14, 'echeck_bank_name', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(299, 14, 'echeck_account_type', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(300, 14, 'echeck_account_name', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(301, 14, 'echeck_type', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(302, 14, 'amount_ordered', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(303, 14, 'amount_authorized', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(304, 14, 'amount_paid', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(305, 14, 'amount_canceled', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(306, 14, 'amount_refunded', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(307, 14, 'shipping_amount', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(308, 14, 'shipping_captured', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(309, 14, 'shipping_refunded', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(310, 14, 'base_amount_ordered', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(311, 14, 'base_amount_authorized', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(312, 14, 'base_amount_paid', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(313, 14, 'base_amount_canceled', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(314, 14, 'base_amount_refunded', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(315, 14, 'base_shipping_amount', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(316, 14, 'base_shipping_captured', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(317, 14, 'base_shipping_refunded', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(318, 15, 'parent_id', NULL, 'sales_entity/order_attribute_backend_child', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(319, 15, 'status', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(320, 15, 'comment', NULL, '', 'text', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(321, 15, 'is_customer_notified', NULL, '', 'int', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(322, 16, 'entity_id', NULL, 'sales_entity/order_invoice_attribute_backend_parent', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0);
INSERT INTO `eav_attribute` (`attribute_id`, `entity_type_id`, `attribute_code`, `attribute_model`, `backend_model`, `backend_type`, `backend_table`, `frontend_model`, `frontend_input`, `frontend_input_renderer`, `frontend_label`, `frontend_class`, `source_model`, `is_global`, `is_visible`, `is_required`, `is_user_defined`, `default_value`, `is_searchable`, `is_filterable`, `is_comparable`, `is_visible_on_front`, `is_html_allowed_on_front`, `is_unique`, `is_used_for_price_rules`, `is_filterable_in_search`, `used_in_product_listing`, `used_for_sort_by`, `is_configurable`, `apply_to`, `position`, `note`, `is_visible_in_advanced_search`) VALUES
(323, 16, 'state', NULL, '', 'int', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(324, 16, 'is_used_for_refund', NULL, '', 'int', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(325, 16, 'transaction_id', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(326, 16, 'order_id', NULL, 'sales_entity/order_invoice_attribute_backend_order', 'int', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(327, 16, 'billing_address_id', NULL, '', 'int', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(328, 16, 'shipping_address_id', NULL, '', 'int', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(329, 16, 'global_currency_code', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(330, 16, 'base_currency_code', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(331, 16, 'store_currency_code', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(332, 16, 'order_currency_code', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(333, 16, 'store_to_base_rate', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(334, 16, 'store_to_order_rate', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(335, 16, 'base_to_global_rate', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(336, 16, 'base_to_order_rate', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(337, 16, 'subtotal', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(338, 16, 'discount_amount', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(339, 16, 'tax_amount', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(340, 16, 'shipping_amount', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(341, 16, 'grand_total', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(342, 16, 'total_qty', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(343, 16, 'can_void_flag', NULL, '', 'int', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(344, 16, 'base_subtotal', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(345, 16, 'base_discount_amount', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(346, 16, 'base_tax_amount', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(347, 16, 'base_shipping_amount', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(348, 16, 'base_grand_total', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(349, 16, 'email_sent', NULL, '', 'int', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(350, 16, 'store_id', NULL, '', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(351, 17, 'parent_id', NULL, 'sales_entity/order_invoice_attribute_backend_child', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(352, 17, 'order_item_id', NULL, '', 'int', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(353, 17, 'product_id', NULL, '', 'int', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(354, 17, 'name', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(355, 17, 'description', NULL, '', 'text', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(356, 17, 'sku', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(357, 17, 'qty', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(358, 17, 'cost', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(359, 17, 'price', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(360, 17, 'discount_amount', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(361, 17, 'tax_amount', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(362, 17, 'row_total', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(363, 17, 'base_price', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(364, 17, 'base_discount_amount', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(365, 17, 'base_tax_amount', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(366, 17, 'base_row_total', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(367, 17, 'additional_data', NULL, '', 'text', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(368, 18, 'parent_id', NULL, 'sales_entity/order_invoice_attribute_backend_child', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(369, 18, 'comment', NULL, '', 'text', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(370, 18, 'is_customer_notified', NULL, '', 'int', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(371, 19, 'entity_id', NULL, 'sales_entity/order_shipment_attribute_backend_parent', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(372, 19, 'customer_id', NULL, '', 'int', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(373, 19, 'order_id', NULL, '', 'int', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(374, 19, 'shipment_status', NULL, '', 'int', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(375, 19, 'billing_address_id', NULL, '', 'int', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(376, 19, 'shipping_address_id', NULL, '', 'int', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(377, 19, 'total_qty', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(378, 19, 'total_weight', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(379, 19, 'email_sent', NULL, '', 'int', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(380, 19, 'store_id', NULL, '', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(381, 20, 'parent_id', NULL, 'sales_entity/order_shipment_attribute_backend_child', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(382, 20, 'order_item_id', NULL, '', 'int', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(383, 20, 'product_id', NULL, '', 'int', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(384, 20, 'name', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(385, 20, 'description', NULL, '', 'text', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(386, 20, 'sku', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(387, 20, 'qty', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(388, 20, 'price', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(389, 20, 'weight', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(390, 20, 'row_total', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(391, 20, 'additional_data', NULL, '', 'text', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(392, 21, 'parent_id', NULL, 'sales_entity/order_shipment_attribute_backend_child', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(393, 21, 'comment', NULL, '', 'text', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(394, 21, 'is_customer_notified', NULL, '', 'int', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(395, 22, 'parent_id', NULL, 'sales_entity/order_shipment_attribute_backend_child', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(396, 22, 'order_id', NULL, '', 'int', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(397, 22, 'number', NULL, '', 'text', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(398, 22, 'carrier_code', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(399, 22, 'title', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(400, 22, 'description', NULL, '', 'text', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(401, 22, 'qty', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(402, 22, 'weight', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(403, 23, 'entity_id', NULL, 'sales_entity/order_creditmemo_attribute_backend_parent', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(404, 23, 'state', NULL, '', 'int', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(405, 23, 'invoice_id', NULL, '', 'int', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(406, 23, 'transaction_id', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(407, 23, 'order_id', NULL, '', 'int', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(408, 23, 'creditmemo_status', NULL, '', 'int', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(409, 23, 'billing_address_id', NULL, '', 'int', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(410, 23, 'shipping_address_id', NULL, '', 'int', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(411, 23, 'global_currency_code', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(412, 23, 'base_currency_code', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(413, 23, 'store_currency_code', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(414, 23, 'order_currency_code', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(415, 23, 'store_to_base_rate', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(416, 23, 'store_to_order_rate', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(417, 23, 'base_to_global_rate', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(418, 23, 'base_to_order_rate', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(419, 23, 'subtotal', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(420, 23, 'discount_amount', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(421, 23, 'tax_amount', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(422, 23, 'shipping_amount', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(423, 23, 'adjustment', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(424, 23, 'adjustment_positive', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(425, 23, 'adjustment_negative', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(426, 23, 'grand_total', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(427, 23, 'base_subtotal', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(428, 23, 'base_discount_amount', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(429, 23, 'base_tax_amount', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(430, 23, 'base_shipping_amount', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(431, 23, 'base_adjustment', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(432, 23, 'base_adjustment_positive', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(433, 23, 'base_adjustment_negative', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(434, 23, 'base_grand_total', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(435, 23, 'email_sent', NULL, '', 'int', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(436, 23, 'store_id', NULL, '', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(437, 24, 'parent_id', NULL, 'sales_entity/order_creditmemo_attribute_backend_child', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(438, 24, 'order_item_id', NULL, '', 'int', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(439, 24, 'product_id', NULL, '', 'int', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(440, 24, 'name', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(441, 24, 'description', NULL, '', 'text', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(442, 24, 'sku', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(443, 24, 'qty', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(444, 24, 'cost', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(445, 24, 'price', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(446, 24, 'discount_amount', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(447, 24, 'tax_amount', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(448, 24, 'row_total', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(449, 24, 'base_price', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(450, 24, 'base_discount_amount', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(451, 24, 'base_tax_amount', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(452, 24, 'base_row_total', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(453, 24, 'additional_data', NULL, '', 'text', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(454, 25, 'parent_id', NULL, 'sales_entity/order_creditmemo_attribute_backend_child', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(455, 25, 'comment', NULL, '', 'text', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(456, 25, 'is_customer_notified', NULL, '', 'int', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(457, 13, 'product_type', NULL, '', 'varchar', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(458, 11, 'can_ship_partially', NULL, '', 'int', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(459, 11, 'can_ship_partially_item', NULL, '', 'int', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(460, 11, 'payment_authorization_amount', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(461, 11, 'payment_authorization_expiration', NULL, '', 'int', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(462, 11, 'shipping_tax_refunded', NULL, '', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(463, 11, 'base_shipping_tax_refunded', NULL, '', 'static', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(465, 11, 'forced_do_shipment_with_invoice', NULL, '', 'int', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '0', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(466, 11, 'paypal_ipn_customer_notified', NULL, '', 'int', '', '', 'text', '', '', '', '', 1, 0, 1, 0, '0', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(467, 4, 'enable_googlecheckout', NULL, '', 'int', '', '', 'select', '', 'Is product available for purchase with Google Checkout', '', 'eav/entity_attribute_source_boolean', 1, 1, 0, 0, '1', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, '', 0, '', 0),
(468, 11, 'gift_message_id', NULL, '', 'int', '', '', 'text', '', '', '', '', 1, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(469, 4, 'gift_message_available', NULL, 'giftmessage/entity_attribute_backend_boolean_config', 'varchar', '', '', 'select', '', 'Allow Gift Message', '', 'giftmessage/entity_attribute_source_boolean_config', 1, 1, 0, 0, '2', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, '', 0, '', 0),
(470, 4, 'price_type', NULL, '', 'int', '', '', '', '', '', '', '', 1, 0, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 'bundle', 0, '', 0),
(471, 4, 'sku_type', NULL, '', 'int', '', '', '', '', '', '', '', 1, 0, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 'bundle', 0, '', 0),
(472, 4, 'weight_type', NULL, '', 'int', '', '', '', '', '', '', '', 1, 0, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 'bundle', 0, '', 0),
(473, 4, 'price_view', NULL, '', 'int', '', '', 'select', '', 'Price View', '', 'bundle/product_attribute_source_price_view', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 'bundle', 0, '', 0),
(474, 4, 'shipment_type', NULL, '', 'int', '', '', '', '', 'Shipment', '', '', 1, 0, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 'bundle', 0, '', 0),
(475, 4, 'links_purchased_separately', NULL, '', 'int', '', '', '', '', 'Links can be purchased separately', '', '', 1, 0, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 'downloadable', 0, '', 0),
(476, 4, 'samples_title', NULL, '', 'varchar', '', '', '', '', 'Samples title', '', '', 0, 0, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 'downloadable', 0, '', 0),
(477, 4, 'links_title', NULL, '', 'varchar', '', '', '', '', 'Links title', '', '', 0, 0, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 'downloadable', 0, '', 0),
(478, 24, 'base_weee_tax_applied_amount', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(479, 24, 'base_weee_tax_applied_row_amount', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(480, 24, 'weee_tax_applied_amount', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(481, 24, 'weee_tax_applied_row_amount', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(482, 17, 'base_weee_tax_applied_amount', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(483, 17, 'base_weee_tax_applied_row_amount', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(484, 17, 'weee_tax_applied_amount', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(485, 17, 'weee_tax_applied_row_amount', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(486, 17, 'weee_tax_applied', NULL, '', 'text', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(487, 24, 'weee_tax_applied', NULL, '', 'text', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(488, 24, 'weee_tax_disposition', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(489, 24, 'weee_tax_row_disposition', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(490, 24, 'base_weee_tax_disposition', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(491, 24, 'base_weee_tax_row_disposition', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(492, 17, 'weee_tax_disposition', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(493, 17, 'weee_tax_row_disposition', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(494, 17, 'base_weee_tax_disposition', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(495, 17, 'base_weee_tax_row_disposition', NULL, '', 'decimal', '', '', 'text', '', '', '', '', 1, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, '', 0, '', 0),
(496, 4, 'bo_author', NULL, NULL, 'varchar', NULL, NULL, 'text', NULL, 'Author', '', NULL, 1, 1, 1, 1, '', 1, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0, '', 0, '', 1),
(497, 4, 'bo_ISBN', NULL, NULL, 'varchar', NULL, NULL, 'text', NULL, 'ISBN-13', '', NULL, 1, 1, 1, 1, NULL, 1, 0, 0, 1, 1, 1, 0, 0, 1, 0, 0, '', 0, '', 1),
(499, 4, 'bo_binding', NULL, NULL, 'varchar', NULL, NULL, 'text', NULL, 'Binding', '', NULL, 2, 1, 0, 1, '', 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, '', 0, '', 1),
(500, 4, 'bo_isbn10', NULL, NULL, 'varchar', NULL, NULL, 'text', NULL, 'ISBN-10', 'validate-digits', NULL, 1, 1, 0, 1, '', 0, 0, 0, 1, 1, 1, 0, 0, 1, 0, 0, '', 0, '', 1),
(501, 4, 'bo_pu_date', NULL, 'eav/entity_attribute_backend_datetime', 'datetime', NULL, 'eav/entity_attribute_frontend_datetime', 'date', NULL, 'Publishing Date', '', NULL, 0, 1, 0, 1, '', 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, '', 0, '', 1),
(502, 4, 'bo_publisher', NULL, NULL, 'text', NULL, NULL, 'textarea', NULL, 'Publisher', '', NULL, 1, 1, 1, 1, '', 0, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0, '', 0, '', 1),
(503, 4, 'bo_language', NULL, NULL, 'varchar', NULL, NULL, 'text', NULL, 'Language', '', NULL, 1, 1, 1, 1, '', 0, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0, '', 0, '', 0),
(504, 4, 'bo_no_pg', NULL, NULL, 'varchar', NULL, NULL, 'text', NULL, 'No of Pages', 'validate-digits', NULL, 0, 1, 0, 1, '', 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, '', 0, '', 0),
(505, 4, 'bo_dimension', NULL, NULL, 'varchar', NULL, NULL, 'text', NULL, 'Dimension', '', NULL, 0, 1, 0, 1, '', 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, '', 0, '', 0),
(506, 4, 'bo_illustrator', NULL, NULL, 'varchar', NULL, NULL, 'text', NULL, 'illustrator', '', NULL, 0, 1, 0, 1, '', 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, '', 0, '', 1),
(507, 4, 'bo_edition', NULL, NULL, 'varchar', NULL, NULL, 'text', NULL, 'Edition', '', NULL, 0, 1, 0, 1, '', 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, '', 0, '', 1),
(508, 4, 'bo_int_shipping', NULL, NULL, 'int', NULL, NULL, 'boolean', NULL, 'International Shipping', '', NULL, 0, 1, 0, 1, '0', 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '', 0, '', 1),
(509, 4, 'bo_rating', NULL, NULL, 'varchar', NULL, NULL, 'text', NULL, 'Rating', '', NULL, 0, 1, 0, 1, '', 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, '', 0, '', 0),
(511, 4, 'bo_shipping_region', NULL, NULL, 'varchar', NULL, NULL, 'text', NULL, 'Shipping Region', 'validate-digits', NULL, 0, 1, 1, 1, '', 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, '', 0, '', 0);

--
-- Table structure for table `eav_attribute_group`
--

CREATE TABLE IF NOT EXISTS `eav_attribute_group` (
  `attribute_group_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `attribute_set_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `attribute_group_name` varchar(255) NOT NULL DEFAULT '',
  `sort_order` smallint(6) NOT NULL DEFAULT '0',
  `default_id` smallint(5) unsigned DEFAULT '0',
  PRIMARY KEY (`attribute_group_id`),
  UNIQUE KEY `attribute_set_id` (`attribute_set_id`,`attribute_group_name`),
  KEY `attribute_set_id_2` (`attribute_set_id`,`sort_order`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=37 ;

--
-- Dumping data for table `eav_attribute_group`
--

INSERT INTO `eav_attribute_group` (`attribute_group_id`, `attribute_set_id`, `attribute_group_name`, `sort_order`, `default_id`) VALUES
(1, 1, 'General', 1, 1),
(2, 2, 'General', 1, 1),
(3, 3, 'General Information', 10, 1),
(4, 4, 'General', 1, 1),
(5, 4, 'Prices', 2, 0),
(6, 4, 'Meta Information', 3, 0),
(7, 4, 'Images', 4, 0),
(8, 4, 'Design', 6, 0),
(9, 3, 'Display Settings', 20, 0),
(10, 3, 'Custom Design', 30, 0),
(11, 5, 'General', 1, 1),
(12, 6, 'General', 1, 1),
(13, 7, 'General', 1, 1),
(14, 8, 'General', 1, 1),
(15, 9, 'General', 1, 1),
(16, 10, 'General', 1, 1),
(17, 11, 'General', 1, 1),
(18, 12, 'General', 1, 1),
(19, 13, 'General', 1, 1),
(20, 14, 'General', 1, 1),
(21, 15, 'General', 1, 1),
(22, 16, 'General', 1, 1),
(23, 17, 'General', 1, 1),
(24, 18, 'General', 1, 1),
(25, 19, 'General', 1, 1),
(26, 20, 'General', 1, 1),
(27, 21, 'General', 1, 1),
(28, 22, 'General', 1, 1),
(29, 23, 'General', 1, 1),
(30, 24, 'General', 1, 1),
(31, 25, 'General', 1, 1),
(32, 26, 'General', 1, 1),
(33, 26, 'Prices', 2, 0),
(34, 26, 'Meta Information', 3, 0),
(35, 26, 'Images', 4, 0),
(36, 26, 'Design', 5, 0);

--
-- Table structure for table `eav_attribute_option`
--

CREATE TABLE IF NOT EXISTS `eav_attribute_option` (
  `option_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `attribute_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `sort_order` smallint(5) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`option_id`),
  KEY `FK_ATTRIBUTE_OPTION_ATTRIBUTE` (`attribute_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Attributes option (for source model)' AUTO_INCREMENT=1 ;

--
-- Table structure for table `eav_attribute_option_value`
--

CREATE TABLE IF NOT EXISTS `eav_attribute_option_value` (
  `value_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `option_id` int(10) unsigned NOT NULL DEFAULT '0',
  `store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `value` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`value_id`),
  KEY `FK_ATTRIBUTE_OPTION_VALUE_OPTION` (`option_id`),
  KEY `FK_ATTRIBUTE_OPTION_VALUE_STORE` (`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Attribute option values per store' AUTO_INCREMENT=1 ;

--
-- Table structure for table `eav_attribute_set`
--

CREATE TABLE IF NOT EXISTS `eav_attribute_set` (
  `attribute_set_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `entity_type_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `attribute_set_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_swedish_ci NOT NULL DEFAULT '',
  `sort_order` smallint(6) NOT NULL DEFAULT '0',
  PRIMARY KEY (`attribute_set_id`),
  UNIQUE KEY `entity_type_id` (`entity_type_id`,`attribute_set_name`),
  KEY `entity_type_id_2` (`entity_type_id`,`sort_order`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=27 ;

--
-- Dumping data for table `eav_attribute_set`
--

INSERT INTO `eav_attribute_set` (`attribute_set_id`, `entity_type_id`, `attribute_set_name`, `sort_order`) VALUES
(1, 1, 'Default', 3),
(2, 2, 'Default', 3),
(3, 3, 'Default', 11),
(4, 4, 'Default', 11),
(5, 5, 'Default', 1),
(6, 6, 'Default', 1),
(7, 7, 'Default', 1),
(8, 8, 'Default', 1),
(9, 9, 'Default', 1),
(10, 10, 'Default', 1),
(11, 11, 'Default', 1),
(12, 12, 'Default', 1),
(13, 13, 'Default', 1),
(14, 14, 'Default', 1),
(15, 15, 'Default', 1),
(16, 16, 'Default', 1),
(17, 17, 'Default', 1),
(18, 18, 'Default', 1),
(19, 19, 'Default', 1),
(20, 20, 'Default', 1),
(21, 21, 'Default', 1),
(22, 22, 'Default', 1),
(23, 23, 'Default', 1),
(24, 24, 'Default', 1),
(25, 25, 'Default', 1),
(26, 4, 'book', 0);

--
-- Table structure for table `eav_entity`
--

CREATE TABLE IF NOT EXISTS `eav_entity` (
  `entity_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `entity_type_id` smallint(8) unsigned NOT NULL DEFAULT '0',
  `attribute_set_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `increment_id` varchar(50) NOT NULL DEFAULT '',
  `parent_id` int(11) unsigned NOT NULL DEFAULT '0',
  `store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `is_active` tinyint(1) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`entity_id`),
  KEY `FK_ENTITY_ENTITY_TYPE` (`entity_type_id`),
  KEY `FK_ENTITY_STORE` (`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Entityies' AUTO_INCREMENT=1 ;

--
-- Table structure for table `eav_entity_attribute`
--

CREATE TABLE IF NOT EXISTS `eav_entity_attribute` (
  `entity_attribute_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `entity_type_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `attribute_set_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `attribute_group_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `attribute_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `sort_order` smallint(6) NOT NULL DEFAULT '0',
  PRIMARY KEY (`entity_attribute_id`),
  UNIQUE KEY `attribute_set_id_2` (`attribute_set_id`,`attribute_id`),
  UNIQUE KEY `attribute_group_id` (`attribute_group_id`,`attribute_id`),
  KEY `attribute_set_id_3` (`attribute_set_id`,`sort_order`),
  KEY `FK_EAV_ENTITY_ATTRIVUTE_ATTRIBUTE` (`attribute_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=702 ;

--
-- Dumping data for table `eav_entity_attribute`
--

INSERT INTO `eav_entity_attribute` (`entity_attribute_id`, `entity_type_id`, `attribute_set_id`, `attribute_group_id`, `attribute_id`, `sort_order`) VALUES
(1, 1, 1, 1, 1, 10),
(2, 1, 1, 1, 2, 20),
(3, 1, 1, 1, 3, 30),
(4, 1, 1, 1, 4, 37),
(5, 1, 1, 1, 5, 40),
(6, 1, 1, 1, 6, 43),
(7, 1, 1, 1, 7, 50),
(8, 1, 1, 1, 8, 53),
(9, 1, 1, 1, 9, 60),
(10, 1, 1, 1, 10, 70),
(11, 1, 1, 1, 11, 80),
(12, 1, 1, 1, 12, 81),
(13, 1, 1, 1, 13, 82),
(14, 1, 1, 1, 14, 83),
(15, 1, 1, 1, 15, 84),
(16, 1, 1, 1, 16, 85),
(17, 2, 2, 2, 17, 7),
(18, 2, 2, 2, 18, 10),
(19, 2, 2, 2, 19, 13),
(20, 2, 2, 2, 20, 20),
(21, 2, 2, 2, 21, 23),
(22, 2, 2, 2, 22, 30),
(23, 2, 2, 2, 23, 40),
(24, 2, 2, 2, 24, 50),
(25, 2, 2, 2, 25, 60),
(26, 2, 2, 2, 26, 70),
(27, 2, 2, 2, 27, 80),
(28, 2, 2, 2, 28, 90),
(29, 2, 2, 2, 29, 100),
(30, 2, 2, 2, 30, 110),
(31, 3, 3, 3, 31, 1),
(32, 3, 3, 3, 32, 2),
(33, 3, 3, 3, 33, 3),
(34, 3, 3, 3, 34, 4),
(35, 3, 3, 3, 35, 5),
(36, 3, 3, 3, 36, 6),
(37, 3, 3, 3, 37, 7),
(38, 3, 3, 3, 38, 8),
(39, 3, 3, 9, 39, 10),
(40, 3, 3, 9, 40, 20),
(41, 3, 3, 9, 41, 30),
(42, 3, 3, 3, 42, 12),
(43, 3, 3, 3, 43, 13),
(44, 3, 3, 3, 44, 14),
(45, 3, 3, 3, 45, 15),
(46, 3, 3, 3, 46, 16),
(47, 3, 3, 3, 47, 17),
(48, 3, 3, 10, 48, 10),
(49, 3, 3, 10, 49, 20),
(50, 3, 3, 10, 50, 30),
(51, 3, 3, 10, 51, 40),
(52, 3, 3, 10, 52, 50),
(53, 3, 3, 10, 53, 60),
(54, 3, 3, 3, 54, 24),
(55, 3, 3, 3, 55, 25),
(56, 4, 4, 4, 56, 1),
(57, 4, 4, 4, 57, 2),
(58, 4, 4, 4, 58, 3),
(59, 4, 4, 4, 59, 4),
(60, 4, 4, 5, 60, 1),
(61, 4, 4, 5, 61, 2),
(62, 4, 4, 5, 62, 3),
(63, 4, 4, 5, 63, 4),
(64, 4, 4, 5, 64, 5),
(65, 4, 4, 4, 65, 5),
(66, 4, 4, 4, 66, 6),
(67, 4, 4, 6, 67, 1),
(68, 4, 4, 6, 68, 2),
(69, 4, 4, 6, 69, 3),
(70, 4, 4, 7, 70, 1),
(71, 4, 4, 7, 71, 2),
(72, 4, 4, 7, 72, 3),
(73, 4, 4, 7, 73, 4),
(74, 4, 4, 4, 74, 7),
(75, 4, 4, 5, 75, 10),
(76, 4, 4, 4, 76, 8),
(77, 4, 4, 4, 77, 9),
(78, 4, 4, 4, 78, 10),
(79, 4, 4, 7, 79, 5),
(80, 4, 4, 4, 80, 11),
(81, 4, 4, 5, 81, 7),
(82, 4, 4, 4, 82, 12),
(83, 4, 4, 4, 83, 13),
(84, 4, 4, 5, 84, 8),
(85, 4, 4, 4, 85, 14),
(86, 4, 4, 8, 86, 1),
(87, 4, 4, 8, 87, 2),
(88, 4, 4, 8, 88, 3),
(89, 4, 4, 8, 89, 4),
(90, 4, 4, 8, 90, 5),
(91, 4, 4, 4, 91, 15),
(92, 4, 4, 8, 92, 6),
(93, 4, 4, 4, 93, 16),
(94, 4, 4, 4, 94, 17),
(95, 4, 4, 4, 95, 18),
(96, 4, 4, 4, 96, 19),
(97, 4, 4, 4, 97, 20),
(98, 3, 3, 9, 98, 40),
(99, 3, 3, 9, 99, 50),
(100, 4, 4, 4, 100, 21),
(101, 4, 4, 4, 101, 22),
(102, 11, 11, 17, 102, 1),
(103, 11, 11, 17, 103, 2),
(104, 11, 11, 17, 104, 3),
(105, 11, 11, 17, 105, 4),
(106, 11, 11, 17, 106, 5),
(107, 11, 11, 17, 107, 6),
(108, 11, 11, 17, 108, 7),
(109, 11, 11, 17, 109, 8),
(110, 11, 11, 17, 110, 9),
(111, 11, 11, 17, 111, 10),
(112, 11, 11, 17, 112, 11),
(113, 11, 11, 17, 113, 12),
(114, 11, 11, 17, 114, 13),
(115, 11, 11, 17, 115, 14),
(116, 11, 11, 17, 116, 15),
(117, 11, 11, 17, 117, 16),
(118, 11, 11, 17, 118, 17),
(119, 11, 11, 17, 119, 18),
(120, 11, 11, 17, 120, 19),
(121, 11, 11, 17, 121, 20),
(122, 11, 11, 17, 122, 21),
(123, 11, 11, 17, 123, 22),
(124, 11, 11, 17, 124, 23),
(125, 11, 11, 17, 125, 24),
(126, 11, 11, 17, 126, 25),
(127, 11, 11, 17, 127, 26),
(128, 11, 11, 17, 128, 27),
(129, 11, 11, 17, 129, 28),
(130, 11, 11, 17, 130, 29),
(131, 11, 11, 17, 131, 30),
(132, 11, 11, 17, 132, 31),
(133, 11, 11, 17, 133, 32),
(134, 11, 11, 17, 134, 33),
(135, 11, 11, 17, 135, 34),
(136, 11, 11, 17, 136, 35),
(137, 11, 11, 17, 137, 36),
(138, 11, 11, 17, 138, 37),
(139, 11, 11, 17, 139, 38),
(140, 11, 11, 17, 140, 39),
(141, 11, 11, 17, 141, 40),
(142, 11, 11, 17, 142, 41),
(143, 11, 11, 17, 143, 42),
(144, 11, 11, 17, 144, 43),
(145, 11, 11, 17, 145, 44),
(146, 11, 11, 17, 146, 45),
(147, 11, 11, 17, 147, 46),
(148, 11, 11, 17, 148, 47),
(149, 11, 11, 17, 149, 48),
(150, 11, 11, 17, 150, 49),
(151, 11, 11, 17, 151, 50),
(152, 11, 11, 17, 152, 51),
(153, 11, 11, 17, 153, 52),
(154, 11, 11, 17, 154, 53),
(155, 11, 11, 17, 155, 54),
(156, 11, 11, 17, 156, 55),
(157, 11, 11, 17, 157, 56),
(158, 11, 11, 17, 158, 57),
(159, 11, 11, 17, 159, 58),
(160, 11, 11, 17, 160, 59),
(161, 11, 11, 17, 161, 60),
(162, 11, 11, 17, 162, 61),
(163, 11, 11, 17, 163, 62),
(164, 11, 11, 17, 164, 63),
(165, 11, 11, 17, 165, 64),
(166, 11, 11, 17, 166, 65),
(167, 11, 11, 17, 167, 66),
(168, 11, 11, 17, 168, 67),
(169, 11, 11, 17, 169, 68),
(170, 11, 11, 17, 170, 69),
(171, 11, 11, 17, 171, 70),
(172, 11, 11, 17, 172, 71),
(173, 11, 11, 17, 173, 72),
(174, 11, 11, 17, 174, 73),
(175, 11, 11, 17, 175, 74),
(176, 11, 11, 17, 176, 75),
(177, 11, 11, 17, 177, 76),
(178, 11, 11, 17, 178, 77),
(179, 11, 11, 17, 179, 78),
(180, 11, 11, 17, 180, 79),
(181, 11, 11, 17, 181, 80),
(182, 11, 11, 17, 182, 81),
(183, 11, 11, 17, 183, 82),
(184, 11, 11, 17, 184, 83),
(185, 11, 11, 17, 185, 84),
(186, 11, 11, 17, 186, 85),
(187, 11, 11, 17, 187, 86),
(188, 11, 11, 17, 188, 87),
(189, 11, 11, 17, 189, 88),
(190, 11, 11, 17, 190, 89),
(191, 11, 11, 17, 191, 90),
(192, 11, 11, 17, 192, 91),
(193, 11, 11, 17, 193, 92),
(194, 11, 11, 17, 194, 93),
(195, 11, 11, 17, 195, 94),
(196, 11, 11, 17, 196, 95),
(197, 11, 11, 17, 197, 96),
(198, 11, 11, 17, 198, 97),
(199, 11, 11, 17, 199, 98),
(200, 11, 11, 17, 200, 99),
(201, 11, 11, 17, 201, 100),
(202, 11, 11, 17, 202, 101),
(203, 11, 11, 17, 203, 102),
(204, 11, 11, 17, 204, 103),
(205, 11, 11, 17, 205, 104),
(206, 11, 11, 17, 206, 105),
(207, 11, 11, 17, 207, 106),
(208, 11, 11, 17, 208, 107),
(209, 12, 12, 18, 209, 1),
(210, 12, 12, 18, 210, 2),
(211, 12, 12, 18, 211, 3),
(212, 12, 12, 18, 212, 4),
(213, 12, 12, 18, 213, 5),
(214, 12, 12, 18, 214, 6),
(215, 12, 12, 18, 215, 7),
(216, 12, 12, 18, 216, 8),
(217, 12, 12, 18, 217, 9),
(218, 12, 12, 18, 218, 10),
(219, 12, 12, 18, 219, 11),
(220, 12, 12, 18, 220, 12),
(221, 12, 12, 18, 221, 13),
(222, 12, 12, 18, 222, 14),
(223, 12, 12, 18, 223, 15),
(224, 12, 12, 18, 224, 16),
(225, 12, 12, 18, 225, 17),
(226, 12, 12, 18, 226, 18),
(227, 12, 12, 18, 227, 19),
(228, 12, 12, 18, 228, 20),
(229, 13, 13, 19, 229, 1),
(230, 13, 13, 19, 230, 2),
(231, 13, 13, 19, 231, 3),
(232, 13, 13, 19, 232, 4),
(233, 13, 13, 19, 233, 5),
(234, 13, 13, 19, 234, 6),
(235, 13, 13, 19, 235, 7),
(236, 13, 13, 19, 236, 8),
(237, 13, 13, 19, 237, 9),
(238, 13, 13, 19, 238, 10),
(239, 13, 13, 19, 239, 11),
(240, 13, 13, 19, 240, 12),
(241, 13, 13, 19, 241, 13),
(242, 13, 13, 19, 242, 14),
(243, 13, 13, 19, 243, 15),
(244, 13, 13, 19, 244, 16),
(245, 13, 13, 19, 245, 17),
(246, 13, 13, 19, 246, 18),
(247, 13, 13, 19, 247, 19),
(248, 13, 13, 19, 248, 20),
(249, 13, 13, 19, 249, 21),
(250, 13, 13, 19, 250, 22),
(251, 13, 13, 19, 251, 23),
(252, 13, 13, 19, 252, 24),
(253, 13, 13, 19, 253, 25),
(254, 13, 13, 19, 254, 26),
(255, 13, 13, 19, 255, 27),
(256, 13, 13, 19, 256, 28),
(257, 13, 13, 19, 257, 29),
(258, 13, 13, 19, 258, 30),
(259, 13, 13, 19, 259, 31),
(260, 13, 13, 19, 260, 32),
(261, 13, 13, 19, 261, 33),
(262, 13, 13, 19, 262, 34),
(263, 13, 13, 19, 263, 35),
(264, 13, 13, 19, 264, 36),
(265, 13, 13, 19, 265, 37),
(266, 13, 13, 19, 266, 38),
(267, 13, 13, 19, 267, 39),
(268, 13, 13, 19, 268, 40),
(269, 13, 13, 19, 269, 41),
(270, 13, 13, 19, 270, 42),
(271, 13, 13, 19, 271, 43),
(272, 14, 14, 20, 272, 1),
(273, 14, 14, 20, 273, 2),
(274, 14, 14, 20, 274, 3),
(275, 14, 14, 20, 275, 4),
(276, 14, 14, 20, 276, 5),
(277, 14, 14, 20, 277, 6),
(278, 14, 14, 20, 278, 7),
(279, 14, 14, 20, 279, 8),
(280, 14, 14, 20, 280, 9),
(281, 14, 14, 20, 281, 10),
(282, 14, 14, 20, 282, 11),
(283, 14, 14, 20, 283, 12),
(284, 14, 14, 20, 284, 13),
(285, 14, 14, 20, 285, 14),
(286, 14, 14, 20, 286, 15),
(287, 14, 14, 20, 287, 16),
(288, 14, 14, 20, 288, 17),
(289, 14, 14, 20, 289, 18),
(290, 14, 14, 20, 290, 19),
(291, 14, 14, 20, 291, 20),
(292, 14, 14, 20, 292, 21),
(293, 14, 14, 20, 293, 22),
(294, 14, 14, 20, 294, 23),
(295, 14, 14, 20, 295, 24),
(296, 14, 14, 20, 296, 25),
(297, 14, 14, 20, 297, 26),
(298, 14, 14, 20, 298, 27),
(299, 14, 14, 20, 299, 28),
(300, 14, 14, 20, 300, 29),
(301, 14, 14, 20, 301, 30),
(302, 14, 14, 20, 302, 31),
(303, 14, 14, 20, 303, 32),
(304, 14, 14, 20, 304, 33),
(305, 14, 14, 20, 305, 34),
(306, 14, 14, 20, 306, 35),
(307, 14, 14, 20, 307, 36),
(308, 14, 14, 20, 308, 37),
(309, 14, 14, 20, 309, 38),
(310, 14, 14, 20, 310, 39),
(311, 14, 14, 20, 311, 40),
(312, 14, 14, 20, 312, 41),
(313, 14, 14, 20, 313, 42),
(314, 14, 14, 20, 314, 43),
(315, 14, 14, 20, 315, 44),
(316, 14, 14, 20, 316, 45),
(317, 14, 14, 20, 317, 46),
(318, 15, 15, 21, 318, 1),
(319, 15, 15, 21, 319, 2),
(320, 15, 15, 21, 320, 3),
(321, 15, 15, 21, 321, 4),
(322, 16, 16, 22, 322, 1),
(323, 16, 16, 22, 323, 2),
(324, 16, 16, 22, 324, 3),
(325, 16, 16, 22, 325, 4),
(326, 16, 16, 22, 326, 5),
(327, 16, 16, 22, 327, 6),
(328, 16, 16, 22, 328, 7),
(329, 16, 16, 22, 329, 8),
(330, 16, 16, 22, 330, 9),
(331, 16, 16, 22, 331, 10),
(332, 16, 16, 22, 332, 11),
(333, 16, 16, 22, 333, 12),
(334, 16, 16, 22, 334, 13),
(335, 16, 16, 22, 335, 14),
(336, 16, 16, 22, 336, 15),
(337, 16, 16, 22, 337, 16),
(338, 16, 16, 22, 338, 17),
(339, 16, 16, 22, 339, 18),
(340, 16, 16, 22, 340, 19),
(341, 16, 16, 22, 341, 20),
(342, 16, 16, 22, 342, 21),
(343, 16, 16, 22, 343, 22),
(344, 16, 16, 22, 344, 23),
(345, 16, 16, 22, 345, 24),
(346, 16, 16, 22, 346, 25),
(347, 16, 16, 22, 347, 26),
(348, 16, 16, 22, 348, 27),
(349, 16, 16, 22, 349, 28),
(350, 16, 16, 22, 350, 29),
(351, 17, 17, 23, 351, 1),
(352, 17, 17, 23, 352, 2),
(353, 17, 17, 23, 353, 3),
(354, 17, 17, 23, 354, 4),
(355, 17, 17, 23, 355, 5),
(356, 17, 17, 23, 356, 6),
(357, 17, 17, 23, 357, 7),
(358, 17, 17, 23, 358, 8),
(359, 17, 17, 23, 359, 9),
(360, 17, 17, 23, 360, 10),
(361, 17, 17, 23, 361, 11),
(362, 17, 17, 23, 362, 12),
(363, 17, 17, 23, 363, 13),
(364, 17, 17, 23, 364, 14),
(365, 17, 17, 23, 365, 15),
(366, 17, 17, 23, 366, 16),
(367, 17, 17, 23, 367, 17),
(368, 18, 18, 24, 368, 1),
(369, 18, 18, 24, 369, 2),
(370, 18, 18, 24, 370, 3),
(371, 19, 19, 25, 371, 1),
(372, 19, 19, 25, 372, 2),
(373, 19, 19, 25, 373, 3),
(374, 19, 19, 25, 374, 4),
(375, 19, 19, 25, 375, 5),
(376, 19, 19, 25, 376, 6),
(377, 19, 19, 25, 377, 7),
(378, 19, 19, 25, 378, 8),
(379, 19, 19, 25, 379, 9),
(380, 19, 19, 25, 380, 10),
(381, 20, 20, 26, 381, 1),
(382, 20, 20, 26, 382, 2),
(383, 20, 20, 26, 383, 3),
(384, 20, 20, 26, 384, 4),
(385, 20, 20, 26, 385, 5),
(386, 20, 20, 26, 386, 6),
(387, 20, 20, 26, 387, 7),
(388, 20, 20, 26, 388, 8),
(389, 20, 20, 26, 389, 9),
(390, 20, 20, 26, 390, 10),
(391, 20, 20, 26, 391, 11),
(392, 21, 21, 27, 392, 1),
(393, 21, 21, 27, 393, 2),
(394, 21, 21, 27, 394, 3),
(395, 22, 22, 28, 395, 1),
(396, 22, 22, 28, 396, 2),
(397, 22, 22, 28, 397, 3),
(398, 22, 22, 28, 398, 4),
(399, 22, 22, 28, 399, 5),
(400, 22, 22, 28, 400, 6),
(401, 22, 22, 28, 401, 7),
(402, 22, 22, 28, 402, 8),
(403, 23, 23, 29, 403, 1),
(404, 23, 23, 29, 404, 2),
(405, 23, 23, 29, 405, 3),
(406, 23, 23, 29, 406, 4),
(407, 23, 23, 29, 407, 5),
(408, 23, 23, 29, 408, 6),
(409, 23, 23, 29, 409, 7),
(410, 23, 23, 29, 410, 8),
(411, 23, 23, 29, 411, 9),
(412, 23, 23, 29, 412, 10),
(413, 23, 23, 29, 413, 11),
(414, 23, 23, 29, 414, 12),
(415, 23, 23, 29, 415, 13),
(416, 23, 23, 29, 416, 14),
(417, 23, 23, 29, 417, 15),
(418, 23, 23, 29, 418, 16),
(419, 23, 23, 29, 419, 17),
(420, 23, 23, 29, 420, 18),
(421, 23, 23, 29, 421, 19),
(422, 23, 23, 29, 422, 20),
(423, 23, 23, 29, 423, 21),
(424, 23, 23, 29, 424, 22),
(425, 23, 23, 29, 425, 23),
(426, 23, 23, 29, 426, 24),
(427, 23, 23, 29, 427, 25),
(428, 23, 23, 29, 428, 26),
(429, 23, 23, 29, 429, 27),
(430, 23, 23, 29, 430, 28),
(431, 23, 23, 29, 431, 29),
(432, 23, 23, 29, 432, 30),
(433, 23, 23, 29, 433, 31),
(434, 23, 23, 29, 434, 32),
(435, 23, 23, 29, 435, 33),
(436, 23, 23, 29, 436, 34),
(437, 24, 24, 30, 437, 1),
(438, 24, 24, 30, 438, 2),
(439, 24, 24, 30, 439, 3),
(440, 24, 24, 30, 440, 4),
(441, 24, 24, 30, 441, 5),
(442, 24, 24, 30, 442, 6),
(443, 24, 24, 30, 443, 7),
(444, 24, 24, 30, 444, 8),
(445, 24, 24, 30, 445, 9),
(446, 24, 24, 30, 446, 10),
(447, 24, 24, 30, 447, 11),
(448, 24, 24, 30, 448, 12),
(449, 24, 24, 30, 449, 13),
(450, 24, 24, 30, 450, 14),
(451, 24, 24, 30, 451, 15),
(452, 24, 24, 30, 452, 16),
(453, 24, 24, 30, 453, 17),
(454, 25, 25, 31, 454, 1),
(455, 25, 25, 31, 455, 2),
(456, 25, 25, 31, 456, 3),
(457, 13, 13, 19, 457, 44),
(458, 11, 11, 17, 458, 108),
(459, 11, 11, 17, 459, 109),
(460, 11, 11, 17, 460, 110),
(461, 11, 11, 17, 461, 111),
(462, 11, 11, 17, 462, 112),
(463, 11, 11, 17, 463, 113),
(464, 11, 11, 17, 464, 114),
(465, 11, 11, 17, 465, 115),
(466, 11, 11, 17, 466, 116),
(467, 4, 4, 5, 467, 23),
(468, 11, 11, 17, 468, 117),
(469, 4, 4, 4, 469, 23),
(470, 4, 4, 4, 470, 24),
(471, 4, 4, 4, 471, 25),
(472, 4, 4, 4, 472, 26),
(473, 4, 4, 5, 473, 24),
(474, 4, 4, 4, 474, 27),
(475, 4, 4, 4, 475, 28),
(476, 4, 4, 4, 476, 29),
(477, 4, 4, 4, 477, 30),
(478, 24, 24, 30, 478, 18),
(479, 24, 24, 30, 479, 19),
(480, 24, 24, 30, 480, 20),
(481, 24, 24, 30, 481, 21),
(482, 17, 17, 23, 482, 18),
(483, 17, 17, 23, 483, 19),
(484, 17, 17, 23, 484, 20),
(485, 17, 17, 23, 485, 21),
(486, 17, 17, 23, 486, 22),
(487, 24, 24, 30, 487, 22),
(488, 24, 24, 30, 488, 23),
(489, 24, 24, 30, 489, 24),
(490, 24, 24, 30, 490, 25),
(491, 24, 24, 30, 491, 26),
(492, 17, 17, 23, 492, 23),
(493, 17, 17, 23, 493, 24),
(494, 17, 17, 23, 494, 25),
(495, 17, 17, 23, 495, 26),
(509, 4, 26, 32, 74, 7),
(521, 4, 26, 32, 83, 13),
(525, 4, 26, 32, 91, 15),
(527, 4, 26, 32, 93, 16),
(529, 4, 26, 32, 94, 17),
(531, 4, 26, 32, 95, 18),
(533, 4, 26, 32, 96, 19),
(535, 4, 26, 32, 97, 20),
(537, 4, 26, 32, 100, 21),
(539, 4, 26, 32, 101, 22),
(543, 4, 26, 32, 470, 24),
(545, 4, 26, 32, 471, 25),
(547, 4, 26, 32, 472, 26),
(549, 4, 26, 32, 474, 27),
(551, 4, 26, 32, 475, 28),
(553, 4, 26, 32, 476, 29),
(555, 4, 26, 32, 477, 30),
(569, 4, 26, 33, 84, 8),
(755, 4, 26, 32, 510, 26),
(803, 4, 26, 32, 56, 1),
(805, 4, 26, 32, 57, 11),
(807, 4, 26, 32, 58, 12),
(809, 4, 26, 32, 59, 13),
(811, 4, 26, 32, 65, 14),
(813, 4, 26, 32, 66, 15),
(815, 4, 26, 32, 76, 16),
(817, 4, 26, 32, 77, 17),
(819, 4, 26, 32, 78, 18),
(821, 4, 26, 32, 80, 19),
(823, 4, 26, 32, 82, 20),
(825, 4, 26, 32, 85, 21),
(827, 4, 26, 32, 469, 22),
(829, 4, 26, 32, 496, 2),
(831, 4, 26, 32, 497, 3),
(833, 4, 26, 32, 499, 23),
(835, 4, 26, 32, 500, 4),
(837, 4, 26, 32, 501, 8),
(839, 4, 26, 32, 502, 6),
(841, 4, 26, 32, 503, 9),
(843, 4, 26, 32, 504, 10),
(845, 4, 26, 32, 505, 24),
(847, 4, 26, 32, 506, 5),
(849, 4, 26, 32, 507, 7),
(851, 4, 26, 32, 508, 27),
(853, 4, 26, 32, 509, 25),
(855, 4, 26, 32, 511, 26),
(857, 4, 26, 33, 60, 1),
(859, 4, 26, 33, 61, 2),
(861, 4, 26, 33, 62, 3),
(863, 4, 26, 33, 63, 4),
(865, 4, 26, 33, 64, 5),
(867, 4, 26, 33, 75, 7),
(869, 4, 26, 33, 81, 6),
(871, 4, 26, 33, 467, 8),
(873, 4, 26, 33, 473, 9),
(875, 4, 26, 34, 67, 1),
(877, 4, 26, 34, 68, 2),
(879, 4, 26, 34, 69, 3),
(881, 4, 26, 35, 70, 1),
(883, 4, 26, 35, 71, 2),
(885, 4, 26, 35, 72, 3),
(887, 4, 26, 35, 73, 4),
(889, 4, 26, 35, 79, 5),
(891, 4, 26, 36, 86, 1),
(893, 4, 26, 36, 87, 2),
(895, 4, 26, 36, 88, 3),
(897, 4, 26, 36, 89, 4),
(899, 4, 26, 36, 90, 5),
(901, 4, 26, 36, 92, 6);

--
-- Table structure for table `eav_entity_datetime`
--

CREATE TABLE IF NOT EXISTS `eav_entity_datetime` (
  `value_id` int(11) NOT NULL AUTO_INCREMENT,
  `entity_type_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `attribute_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `entity_id` int(10) unsigned NOT NULL DEFAULT '0',
  `value` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`value_id`),
  KEY `FK_ATTRIBUTE_DATETIME_ENTITY_TYPE` (`entity_type_id`),
  KEY `FK_ATTRIBUTE_DATETIME_ATTRIBUTE` (`attribute_id`),
  KEY `FK_ATTRIBUTE_DATETIME_STORE` (`store_id`),
  KEY `FK_ATTRIBUTE_DATETIME_ENTITY` (`entity_id`),
  KEY `value_by_attribute` (`attribute_id`,`value`),
  KEY `value_by_entity_type` (`entity_type_id`,`value`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Datetime values of attributes' AUTO_INCREMENT=1 ;

--
-- Table structure for table `eav_entity_decimal`
--

CREATE TABLE IF NOT EXISTS `eav_entity_decimal` (
  `value_id` int(11) NOT NULL AUTO_INCREMENT,
  `entity_type_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `attribute_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `entity_id` int(10) unsigned NOT NULL DEFAULT '0',
  `value` decimal(12,4) NOT NULL DEFAULT '0.0000',
  PRIMARY KEY (`value_id`),
  KEY `FK_ATTRIBUTE_DECIMAL_ENTITY_TYPE` (`entity_type_id`),
  KEY `FK_ATTRIBUTE_DECIMAL_ATTRIBUTE` (`attribute_id`),
  KEY `FK_ATTRIBUTE_DECIMAL_STORE` (`store_id`),
  KEY `FK_ATTRIBUTE_DECIMAL_ENTITY` (`entity_id`),
  KEY `value_by_attribute` (`attribute_id`,`value`),
  KEY `value_by_entity_type` (`entity_type_id`,`value`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Decimal values of attributes' AUTO_INCREMENT=1 ;

--
-- Table structure for table `eav_entity_int`
--

CREATE TABLE IF NOT EXISTS `eav_entity_int` (
  `value_id` int(11) NOT NULL AUTO_INCREMENT,
  `entity_type_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `attribute_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `entity_id` int(10) unsigned NOT NULL DEFAULT '0',
  `value` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`value_id`),
  KEY `FK_ATTRIBUTE_INT_ENTITY_TYPE` (`entity_type_id`),
  KEY `FK_ATTRIBUTE_INT_ATTRIBUTE` (`attribute_id`),
  KEY `FK_ATTRIBUTE_INT_STORE` (`store_id`),
  KEY `FK_ATTRIBUTE_INT_ENTITY` (`entity_id`),
  KEY `value_by_attribute` (`attribute_id`,`value`),
  KEY `value_by_entity_type` (`entity_type_id`,`value`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Integer values of attributes' AUTO_INCREMENT=1 ;

--
-- Table structure for table `eav_entity_store`
--

CREATE TABLE IF NOT EXISTS `eav_entity_store` (
  `entity_store_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `entity_type_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `increment_prefix` varchar(20) NOT NULL DEFAULT '',
  `increment_last_id` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`entity_store_id`),
  KEY `FK_eav_entity_store_entity_type` (`entity_type_id`),
  KEY `FK_eav_entity_store_store` (`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `eav_entity_text`
--

CREATE TABLE IF NOT EXISTS `eav_entity_text` (
  `value_id` int(11) NOT NULL AUTO_INCREMENT,
  `entity_type_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `attribute_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `entity_id` int(10) unsigned NOT NULL DEFAULT '0',
  `value` text NOT NULL,
  PRIMARY KEY (`value_id`),
  KEY `FK_ATTRIBUTE_TEXT_ENTITY_TYPE` (`entity_type_id`),
  KEY `FK_ATTRIBUTE_TEXT_ATTRIBUTE` (`attribute_id`),
  KEY `FK_ATTRIBUTE_TEXT_STORE` (`store_id`),
  KEY `FK_ATTRIBUTE_TEXT_ENTITY` (`entity_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Text values of attributes' AUTO_INCREMENT=1 ;

--
-- Table structure for table `eav_entity_type`
--

CREATE TABLE IF NOT EXISTS `eav_entity_type` (
  `entity_type_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `entity_type_code` varchar(50) NOT NULL DEFAULT '',
  `entity_model` varchar(255) NOT NULL,
  `attribute_model` varchar(255) NOT NULL,
  `entity_table` varchar(255) NOT NULL DEFAULT '',
  `value_table_prefix` varchar(255) NOT NULL DEFAULT '',
  `entity_id_field` varchar(255) NOT NULL DEFAULT '',
  `is_data_sharing` tinyint(4) unsigned NOT NULL DEFAULT '1',
  `data_sharing_key` varchar(100) DEFAULT 'default',
  `default_attribute_set_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `increment_model` varchar(255) NOT NULL DEFAULT '',
  `increment_per_store` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `increment_pad_length` tinyint(8) unsigned NOT NULL DEFAULT '8',
  `increment_pad_char` char(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`entity_type_id`),
  KEY `entity_name` (`entity_type_code`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=26 ;

--
-- Dumping data for table `eav_entity_type`
--

INSERT INTO `eav_entity_type` (`entity_type_id`, `entity_type_code`, `entity_model`, `attribute_model`, `entity_table`, `value_table_prefix`, `entity_id_field`, `is_data_sharing`, `data_sharing_key`, `default_attribute_set_id`, `increment_model`, `increment_per_store`, `increment_pad_length`, `increment_pad_char`) VALUES
(1, 'customer', 'customer/customer', '', 'customer/entity', '', '', 1, 'default', 1, 'eav/entity_increment_numeric', 0, 8, '0'),
(2, 'customer_address', 'customer/customer_address', '', 'customer/address_entity', '', '', 1, 'default', 2, '', 0, 8, '0'),
(3, 'catalog_category', 'catalog/category', 'catalog/resource_eav_attribute', 'catalog/category', '', '', 1, 'default', 3, '', 0, 8, '0'),
(4, 'catalog_product', 'catalog/product', 'catalog/resource_eav_attribute', 'catalog/product', '', '', 1, 'default', 4, '', 0, 8, '0'),
(5, 'quote', 'sales/quote', '', 'sales/quote', '', '', 1, 'default', 5, '', 0, 8, '0'),
(6, 'quote_item', 'sales/quote_item', '', 'sales/quote_item', '', '', 1, 'default', 6, '', 0, 8, '0'),
(7, 'quote_address', 'sales/quote_address', '', 'sales/quote_address', '', '', 1, 'default', 7, '', 0, 8, '0'),
(8, 'quote_address_item', 'sales/quote_address_item', '', 'sales/quote_entity', '', '', 1, 'default', 8, '', 0, 8, '0'),
(9, 'quote_address_rate', 'sales/quote_address_rate', '', 'sales/quote_entity', '', '', 1, 'default', 9, '', 0, 8, '0'),
(10, 'quote_payment', 'sales/quote_payment', '', 'sales/quote_entity', '', '', 1, 'default', 10, '', 0, 8, '0'),
(11, 'order', 'sales/order', '', 'sales/order', '', '', 1, 'default', 11, 'eav/entity_increment_numeric', 1, 8, '0'),
(12, 'order_address', 'sales/order_address', '', 'sales/order_entity', '', '', 1, 'default', 12, '', 0, 8, '0'),
(13, 'order_item', 'sales/order_item', '', 'sales/order_entity', '', '', 1, 'default', 13, '', 0, 8, '0'),
(14, 'order_payment', 'sales/order_payment', '', 'sales/order_entity', '', '', 1, 'default', 14, '', 0, 8, '0'),
(15, 'order_status_history', 'sales/order_status_history', '', 'sales/order_entity', '', '', 1, 'default', 15, '', 0, 8, '0'),
(16, 'invoice', 'sales/order_invoice', '', 'sales/order_entity', '', '', 1, 'default', 16, 'eav/entity_increment_numeric', 1, 8, '0'),
(17, 'invoice_item', 'sales/order_invoice_item', '', 'sales/order_entity', '', '', 1, 'default', 17, '', 0, 8, '0'),
(18, 'invoice_comment', 'sales/order_invoice_comment', '', 'sales/order_entity', '', '', 1, 'default', 18, '', 0, 8, '0'),
(19, 'shipment', 'sales/order_shipment', '', 'sales/order_entity', '', '', 1, 'default', 19, 'eav/entity_increment_numeric', 1, 8, '0'),
(20, 'shipment_item', 'sales/order_shipment_item', '', 'sales/order_entity', '', '', 1, 'default', 20, '', 0, 8, '0'),
(21, 'shipment_comment', 'sales/order_shipment_comment', '', 'sales/order_entity', '', '', 1, 'default', 21, '', 0, 8, '0'),
(22, 'shipment_track', 'sales/order_shipment_track', '', 'sales/order_entity', '', '', 1, 'default', 22, '', 0, 8, '0'),
(23, 'creditmemo', 'sales/order_creditmemo', '', 'sales/order_entity', '', '', 1, 'default', 23, 'eav/entity_increment_numeric', 1, 8, '0'),
(24, 'creditmemo_item', 'sales/order_creditmemo_item', '', 'sales/order_entity', '', '', 1, 'default', 24, '', 0, 8, '0'),
(25, 'creditmemo_comment', 'sales/order_creditmemo_comment', '', 'sales/order_entity', '', '', 1, 'default', 25, '', 0, 8, '0');

--
-- Table structure for table `eav_entity_varchar`
--

CREATE TABLE IF NOT EXISTS `eav_entity_varchar` (
  `value_id` int(11) NOT NULL AUTO_INCREMENT,
  `entity_type_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `attribute_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `entity_id` int(10) unsigned NOT NULL DEFAULT '0',
  `value` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`value_id`),
  KEY `FK_ATTRIBUTE_VARCHAR_ENTITY_TYPE` (`entity_type_id`),
  KEY `FK_ATTRIBUTE_VARCHAR_ATTRIBUTE` (`attribute_id`),
  KEY `FK_ATTRIBUTE_VARCHAR_STORE` (`store_id`),
  KEY `FK_ATTRIBUTE_VARCHAR_ENTITY` (`entity_id`),
  KEY `value_by_attribute` (`attribute_id`,`value`),
  KEY `value_by_entity_type` (`entity_type_id`,`value`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Varchar values of attributes' AUTO_INCREMENT=1 ;

--
-- Table structure for table `ek_catalog_popular_categories`
--

CREATE TABLE IF NOT EXISTS `ek_catalog_popular_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category` varchar(100) NOT NULL,
  `url_path` varchar(100) NOT NULL,
  `order_no` int(11) NOT NULL,
  `is_active` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `popularity` int(11) NOT NULL DEFAULT '9',
  `date` datetime DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ek_popular_category` (`category`,`is_active`),
  UNIQUE KEY `ek_popular_category_order` (`order_no`,`is_active`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `ek_catalog_top_authors`
--

CREATE TABLE IF NOT EXISTS `ek_catalog_top_authors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `author` varchar(100) NOT NULL,
  `order_no` int(11) DEFAULT NULL,
  `is_active` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `popularity` int(11) NOT NULL DEFAULT '9',
  `date` datetime DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ek_top_author` (`author`,`is_active`),
  UNIQUE KEY `ek_top_author_order` (`order_no`,`is_active`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;


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

--

-- Table structure for table `ek_shipping_region`
--

CREATE TABLE IF NOT EXISTS `ek_shipping_region` (
  `VALUE_ID` tinyint(4) NOT NULL AUTO_INCREMENT,
  `CODE` tinyint(4) NOT NULL,
  `REGION` varchar(255) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`VALUE_ID`),
  UNIQUE KEY `code` (`CODE`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `ek_shipping_region`
--

INSERT INTO `ek_shipping_region` (`VALUE_ID`, `CODE`, `REGION`) VALUES
(1, 1, 'India only'),
(2, 2, 'Indian Sub-continent only'),
(3, 3, 'International');

--
-- Table structure for table `gift_message`
--

CREATE TABLE IF NOT EXISTS `gift_message` (
  `gift_message_id` int(7) unsigned NOT NULL AUTO_INCREMENT,
  `customer_id` int(7) unsigned NOT NULL DEFAULT '0',
  `sender` varchar(255) NOT NULL DEFAULT '',
  `recipient` varchar(255) NOT NULL DEFAULT '',
  `message` text NOT NULL,
  PRIMARY KEY (`gift_message_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `googlebase_attributes`
--

CREATE TABLE IF NOT EXISTS `googlebase_attributes` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `attribute_id` smallint(5) unsigned NOT NULL,
  `gbase_attribute` varchar(255) NOT NULL,
  `type_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `GOOGLEBASE_ATTRIBUTES_ATTRIBUTE_ID` (`attribute_id`),
  KEY `GOOGLEBASE_ATTRIBUTES_TYPE_ID` (`type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Google Base Attributes link Product Attributes' AUTO_INCREMENT=1 ;

--
-- Table structure for table `googlebase_items`
--

CREATE TABLE IF NOT EXISTS `googlebase_items` (
  `item_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type_id` int(10) unsigned NOT NULL DEFAULT '0',
  `product_id` int(10) unsigned NOT NULL,
  `gbase_item_id` varchar(255) NOT NULL,
  `store_id` smallint(5) unsigned NOT NULL,
  `published` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `expires` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `impr` smallint(5) unsigned NOT NULL DEFAULT '0',
  `clicks` smallint(5) unsigned NOT NULL DEFAULT '0',
  `views` smallint(5) unsigned NOT NULL DEFAULT '0',
  `is_hidden` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`item_id`),
  KEY `GOOGLEBASE_ITEMS_PRODUCT_ID` (`product_id`),
  KEY `GOOGLEBASE_ITEMS_STORE_ID` (`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Google Base Items Products' AUTO_INCREMENT=1 ;

--
-- Table structure for table `googlebase_types`
--

CREATE TABLE IF NOT EXISTS `googlebase_types` (
  `type_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `attribute_set_id` smallint(5) unsigned NOT NULL,
  `gbase_itemtype` varchar(255) NOT NULL,
  `target_country` varchar(2) NOT NULL DEFAULT 'US',
  PRIMARY KEY (`type_id`),
  KEY `GOOGLEBASE_TYPES_ATTRIBUTE_SET_ID` (`attribute_set_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Google Base Item Types link Attribute Sets' AUTO_INCREMENT=1 ;

--
-- Table structure for table `googlecheckout_api_debug`
--

CREATE TABLE IF NOT EXISTS `googlecheckout_api_debug` (
  `debug_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `dir` enum('in','out') DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `request_body` text,
  `response_body` text,
  PRIMARY KEY (`debug_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `googleoptimizer_code`
--

CREATE TABLE IF NOT EXISTS `googleoptimizer_code` (
  `code_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `entity_id` int(10) unsigned NOT NULL,
  `entity_type` varchar(50) NOT NULL DEFAULT '',
  `store_id` smallint(5) unsigned NOT NULL,
  `control_script` text,
  `tracking_script` text,
  `conversion_script` text,
  `conversion_page` varchar(255) NOT NULL DEFAULT '',
  `additional_data` text,
  PRIMARY KEY (`code_id`),
  KEY `GOOGLEOPTIMIZER_CODE_STORE` (`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `log_customer`
--

CREATE TABLE IF NOT EXISTS `log_customer` (
  `log_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `visitor_id` bigint(20) unsigned DEFAULT NULL,
  `customer_id` int(11) NOT NULL DEFAULT '0',
  `login_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `logout_at` datetime DEFAULT NULL,
  `store_id` smallint(5) unsigned NOT NULL,
  PRIMARY KEY (`log_id`),
  KEY `IDX_VISITOR` (`visitor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Customers log information' AUTO_INCREMENT=1 ;

--
-- Table structure for table `log_quote`
--

CREATE TABLE IF NOT EXISTS `log_quote` (
  `quote_id` int(10) unsigned NOT NULL DEFAULT '0',
  `visitor_id` bigint(20) unsigned DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`quote_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Quote log data';

--
-- Table structure for table `log_summary`
--

CREATE TABLE IF NOT EXISTS `log_summary` (
  `summary_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `store_id` smallint(5) unsigned NOT NULL,
  `type_id` smallint(5) unsigned DEFAULT NULL,
  `visitor_count` int(11) NOT NULL DEFAULT '0',
  `customer_count` int(11) NOT NULL DEFAULT '0',
  `add_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`summary_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Summary log information' AUTO_INCREMENT=1 ;

--
-- Table structure for table `log_summary_type`
--

CREATE TABLE IF NOT EXISTS `log_summary_type` (
  `type_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `type_code` varchar(64) NOT NULL DEFAULT '',
  `period` smallint(5) unsigned NOT NULL DEFAULT '0',
  `period_type` enum('MINUTE','HOUR','DAY','WEEK','MONTH') NOT NULL DEFAULT 'MINUTE',
  PRIMARY KEY (`type_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Type of summary information' AUTO_INCREMENT=3 ;

--
-- Dumping data for table `log_summary_type`
--

INSERT INTO `log_summary_type` (`type_id`, `type_code`, `period`, `period_type`) VALUES
(1, 'hour', 1, 'HOUR'),
(2, 'day', 1, 'DAY');

--
-- Table structure for table `log_url`
--

CREATE TABLE IF NOT EXISTS `log_url` (
  `url_id` bigint(20) unsigned NOT NULL DEFAULT '0',
  `visitor_id` bigint(20) unsigned DEFAULT NULL,
  `visit_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`url_id`),
  KEY `IDX_VISITOR` (`visitor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='URL visiting history';

--
-- Table structure for table `log_url_info`
--

CREATE TABLE IF NOT EXISTS `log_url_info` (
  `url_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `url` varchar(255) NOT NULL DEFAULT '',
  `referer` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`url_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Detale information about url visit' AUTO_INCREMENT=10 ;

--
-- Table structure for table `log_visitor`
--

CREATE TABLE IF NOT EXISTS `log_visitor` (
  `visitor_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `session_id` char(64) NOT NULL DEFAULT '',
  `first_visit_at` datetime DEFAULT NULL,
  `last_visit_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `last_url_id` bigint(20) unsigned NOT NULL DEFAULT '0',
  `store_id` smallint(5) unsigned NOT NULL,
  PRIMARY KEY (`visitor_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='System visitors log' AUTO_INCREMENT=3 ;

--
-- Table structure for table `log_visitor_info`
--

CREATE TABLE IF NOT EXISTS `log_visitor_info` (
  `visitor_id` bigint(20) unsigned NOT NULL DEFAULT '0',
  `http_referer` varchar(255) DEFAULT NULL,
  `http_user_agent` varchar(255) DEFAULT NULL,
  `http_accept_charset` varchar(255) DEFAULT NULL,
  `http_accept_language` varchar(255) DEFAULT NULL,
  `server_addr` bigint(20) DEFAULT NULL,
  `remote_addr` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`visitor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Additional information by visitor';

--
-- Table structure for table `log_visitor_online`
--

CREATE TABLE IF NOT EXISTS `log_visitor_online` (
  `visitor_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `visitor_type` char(1) NOT NULL,
  `remote_addr` bigint(20) NOT NULL,
  `first_visit_at` datetime DEFAULT NULL,
  `last_visit_at` datetime DEFAULT NULL,
  `customer_id` int(10) unsigned DEFAULT NULL,
  `last_url` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`visitor_id`),
  KEY `IDX_VISITOR_TYPE` (`visitor_type`),
  KEY `IDX_VISIT_TIME` (`first_visit_at`,`last_visit_at`),
  KEY `IDX_CUSTOMER` (`customer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `newsletter_problem`
--

CREATE TABLE IF NOT EXISTS `newsletter_problem` (
  `problem_id` int(7) unsigned NOT NULL AUTO_INCREMENT,
  `subscriber_id` int(7) unsigned DEFAULT NULL,
  `queue_id` int(7) unsigned NOT NULL DEFAULT '0',
  `problem_error_code` int(3) unsigned DEFAULT '0',
  `problem_error_text` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`problem_id`),
  KEY `FK_PROBLEM_SUBSCRIBER` (`subscriber_id`),
  KEY `FK_PROBLEM_QUEUE` (`queue_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Newsletter problems' AUTO_INCREMENT=1 ;

--
-- Table structure for table `newsletter_queue`
--

CREATE TABLE IF NOT EXISTS `newsletter_queue` (
  `queue_id` int(7) unsigned NOT NULL AUTO_INCREMENT,
  `template_id` int(7) unsigned NOT NULL DEFAULT '0',
  `queue_status` int(3) unsigned NOT NULL DEFAULT '0',
  `queue_start_at` datetime DEFAULT NULL,
  `queue_finish_at` datetime DEFAULT NULL,
  PRIMARY KEY (`queue_id`),
  KEY `FK_QUEUE_TEMPLATE` (`template_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Newsletter queue' AUTO_INCREMENT=1 ;

--
-- Table structure for table `newsletter_queue_link`
--

CREATE TABLE IF NOT EXISTS `newsletter_queue_link` (
  `queue_link_id` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `queue_id` int(7) unsigned NOT NULL DEFAULT '0',
  `subscriber_id` int(7) unsigned NOT NULL DEFAULT '0',
  `letter_sent_at` datetime DEFAULT NULL,
  PRIMARY KEY (`queue_link_id`),
  KEY `FK_QUEUE_LINK_SUBSCRIBER` (`subscriber_id`),
  KEY `FK_QUEUE_LINK_QUEUE` (`queue_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Newsletter queue to subscriber link' AUTO_INCREMENT=1 ;

--
-- Table structure for table `newsletter_queue_store_link`
--

CREATE TABLE IF NOT EXISTS `newsletter_queue_store_link` (
  `queue_id` int(7) unsigned NOT NULL DEFAULT '0',
  `store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`queue_id`,`store_id`),
  KEY `FK_NEWSLETTER_QUEUE_STORE_LINK_STORE` (`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `newsletter_subscriber`
--

CREATE TABLE IF NOT EXISTS `newsletter_subscriber` (
  `subscriber_id` int(7) unsigned NOT NULL AUTO_INCREMENT,
  `store_id` smallint(5) unsigned DEFAULT '0',
  `change_status_at` datetime DEFAULT NULL,
  `customer_id` int(11) unsigned NOT NULL DEFAULT '0',
  `subscriber_email` varchar(150) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL DEFAULT '',
  `subscriber_status` int(3) NOT NULL DEFAULT '0',
  `subscriber_confirm_code` varchar(32) DEFAULT 'NULL',
  PRIMARY KEY (`subscriber_id`),
  KEY `FK_SUBSCRIBER_CUSTOMER` (`customer_id`),
  KEY `FK_NEWSLETTER_SUBSCRIBER_STORE` (`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Newsletter subscribers' AUTO_INCREMENT=1 ;

--
-- Table structure for table `newsletter_template`
--

CREATE TABLE IF NOT EXISTS `newsletter_template` (
  `template_id` int(7) unsigned NOT NULL AUTO_INCREMENT,
  `template_code` varchar(150) DEFAULT NULL,
  `template_text` text,
  `template_text_preprocessed` text,
  `template_type` int(3) unsigned DEFAULT NULL,
  `template_subject` varchar(200) DEFAULT NULL,
  `template_sender_name` varchar(200) DEFAULT NULL,
  `template_sender_email` varchar(200) CHARACTER SET latin1 COLLATE latin1_general_ci DEFAULT NULL,
  `template_actual` tinyint(1) unsigned DEFAULT '1',
  `added_at` datetime DEFAULT NULL,
  `modified_at` datetime DEFAULT NULL,
  PRIMARY KEY (`template_id`),
  KEY `template_actual` (`template_actual`),
  KEY `added_at` (`added_at`),
  KEY `modified_at` (`modified_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Newsletter templates' AUTO_INCREMENT=1 ;

--
-- Table structure for table `paygate_authorizenet_debug`
--

CREATE TABLE IF NOT EXISTS `paygate_authorizenet_debug` (
  `debug_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `request_body` text,
  `response_body` text,
  `request_serialized` text,
  `result_serialized` text,
  `request_dump` text,
  `result_dump` text,
  PRIMARY KEY (`debug_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `paypaluk_api_debug`
--

CREATE TABLE IF NOT EXISTS `paypaluk_api_debug` (
  `debug_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `debug_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `request_body` text,
  `response_body` text,
  PRIMARY KEY (`debug_id`),
  KEY `debug_at` (`debug_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `paypal_api_debug`
--

CREATE TABLE IF NOT EXISTS `paypal_api_debug` (
  `debug_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `debug_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `request_body` text,
  `response_body` text,
  PRIMARY KEY (`debug_id`),
  KEY `debug_at` (`debug_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `poll`
--

CREATE TABLE IF NOT EXISTS `poll` (
  `poll_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `poll_title` varchar(255) NOT NULL DEFAULT '',
  `votes_count` int(10) unsigned NOT NULL DEFAULT '0',
  `store_id` smallint(5) unsigned DEFAULT '0',
  `date_posted` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `date_closed` datetime DEFAULT NULL,
  `active` smallint(6) NOT NULL DEFAULT '1',
  `closed` tinyint(1) NOT NULL DEFAULT '0',
  `answers_display` smallint(6) DEFAULT NULL,
  PRIMARY KEY (`poll_id`),
  KEY `FK_POLL_STORE` (`store_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `poll`
--

INSERT INTO `poll` (`poll_id`, `poll_title`, `votes_count`, `store_id`, `date_posted`, `date_closed`, `active`, `closed`, `answers_display`) VALUES
(1, 'What is your favorite color', 5, 1, '2009-10-15 15:05:14', NULL, 1, 0, NULL);

--
-- Table structure for table `poll_answer`
--

CREATE TABLE IF NOT EXISTS `poll_answer` (
  `answer_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `poll_id` int(10) unsigned NOT NULL DEFAULT '0',
  `answer_title` varchar(255) NOT NULL DEFAULT '',
  `votes_count` int(10) unsigned NOT NULL DEFAULT '0',
  `answer_order` smallint(6) NOT NULL DEFAULT '0',
  PRIMARY KEY (`answer_id`),
  KEY `FK_POLL_PARENT` (`poll_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=5 ;

--
-- Dumping data for table `poll_answer`
--

INSERT INTO `poll_answer` (`answer_id`, `poll_id`, `answer_title`, `votes_count`, `answer_order`) VALUES
(1, 1, 'Green', 4, 0),
(2, 1, 'Red', 1, 0),
(3, 1, 'Black', 0, 0),
(4, 1, 'Magenta', 0, 0);

--
-- Table structure for table `poll_store`
--

CREATE TABLE IF NOT EXISTS `poll_store` (
  `poll_id` int(10) unsigned NOT NULL DEFAULT '0',
  `store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`poll_id`,`store_id`),
  KEY `FK_POLL_STORE_STORE` (`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `poll_store`
--

INSERT INTO `poll_store` (`poll_id`, `store_id`) VALUES
(1, 1);

--
-- Table structure for table `poll_vote`
--

CREATE TABLE IF NOT EXISTS `poll_vote` (
  `vote_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `poll_id` int(10) unsigned NOT NULL DEFAULT '0',
  `poll_answer_id` int(10) unsigned NOT NULL DEFAULT '0',
  `ip_address` bigint(20) DEFAULT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `vote_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`vote_id`),
  KEY `FK_POLL_ANSWER` (`poll_answer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `product_alert_price`
--

CREATE TABLE IF NOT EXISTS `product_alert_price` (
  `alert_price_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `customer_id` int(10) unsigned NOT NULL DEFAULT '0',
  `product_id` int(10) unsigned NOT NULL DEFAULT '0',
  `price` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `website_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `add_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `last_send_date` datetime DEFAULT NULL,
  `send_count` smallint(5) unsigned NOT NULL DEFAULT '0',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`alert_price_id`),
  KEY `FK_PRODUCT_ALERT_PRICE_CUSTOMER` (`customer_id`),
  KEY `FK_PRODUCT_ALERT_PRICE_PRODUCT` (`product_id`),
  KEY `FK_PRODUCT_ALERT_PRICE_WEBSITE` (`website_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `product_alert_stock`
--

CREATE TABLE IF NOT EXISTS `product_alert_stock` (
  `alert_stock_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `customer_id` int(10) unsigned NOT NULL DEFAULT '0',
  `product_id` int(10) unsigned NOT NULL DEFAULT '0',
  `website_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `add_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `send_date` datetime DEFAULT NULL,
  `send_count` smallint(5) unsigned NOT NULL DEFAULT '0',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`alert_stock_id`),
  KEY `FK_PRODUCT_ALERT_STOCK_CUSTOMER` (`customer_id`),
  KEY `FK_PRODUCT_ALERT_STOCK_PRODUCT` (`product_id`),
  KEY `FK_PRODUCT_ALERT_STOCK_WEBSITE` (`website_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `rating`
--

CREATE TABLE IF NOT EXISTS `rating` (
  `rating_id` smallint(6) unsigned NOT NULL AUTO_INCREMENT,
  `entity_id` smallint(6) unsigned NOT NULL DEFAULT '0',
  `rating_code` varchar(64) NOT NULL DEFAULT '',
  `position` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`rating_id`),
  UNIQUE KEY `IDX_CODE` (`rating_code`),
  KEY `FK_RATING_ENTITY` (`entity_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='ratings' AUTO_INCREMENT=4 ;

--
-- Dumping data for table `rating`
--

INSERT INTO `rating` (`rating_id`, `entity_id`, `rating_code`, `position`) VALUES
(1, 1, 'Quality', 0),
(2, 1, 'Value', 0),
(3, 1, 'Price', 0);

--
-- Table structure for table `rating_entity`
--

CREATE TABLE IF NOT EXISTS `rating_entity` (
  `entity_id` smallint(6) unsigned NOT NULL AUTO_INCREMENT,
  `entity_code` varchar(64) NOT NULL DEFAULT '',
  PRIMARY KEY (`entity_id`),
  UNIQUE KEY `IDX_CODE` (`entity_code`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Rating entities' AUTO_INCREMENT=4 ;

--
-- Dumping data for table `rating_entity`
--

INSERT INTO `rating_entity` (`entity_id`, `entity_code`) VALUES
(1, 'product'),
(2, 'product_review'),
(3, 'review');

--
-- Table structure for table `rating_option`
--

CREATE TABLE IF NOT EXISTS `rating_option` (
  `option_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `rating_id` smallint(6) unsigned NOT NULL DEFAULT '0',
  `code` varchar(32) NOT NULL DEFAULT '',
  `value` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `position` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`option_id`),
  KEY `FK_RATING_OPTION_RATING` (`rating_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Rating options' AUTO_INCREMENT=16 ;

--
-- Dumping data for table `rating_option`
--

INSERT INTO `rating_option` (`option_id`, `rating_id`, `code`, `value`, `position`) VALUES
(1, 1, '1', 1, 1),
(2, 1, '2', 2, 2),
(3, 1, '3', 3, 3),
(4, 1, '4', 4, 4),
(5, 1, '5', 5, 5),
(6, 2, '1', 1, 1),
(7, 2, '2', 2, 2),
(8, 2, '3', 3, 3),
(9, 2, '4', 4, 4),
(10, 2, '5', 5, 5),
(11, 3, '1', 1, 1),
(12, 3, '2', 2, 2),
(13, 3, '3', 3, 3),
(14, 3, '4', 4, 4),
(15, 3, '5', 5, 5);

--
-- Table structure for table `rating_option_vote`
--

CREATE TABLE IF NOT EXISTS `rating_option_vote` (
  `vote_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `option_id` int(10) unsigned NOT NULL DEFAULT '0',
  `remote_ip` varchar(16) NOT NULL DEFAULT '',
  `remote_ip_long` int(11) NOT NULL DEFAULT '0',
  `customer_id` int(11) unsigned DEFAULT '0',
  `entity_pk_value` bigint(20) unsigned NOT NULL DEFAULT '0',
  `rating_id` smallint(6) unsigned NOT NULL DEFAULT '0',
  `review_id` bigint(20) unsigned DEFAULT NULL,
  `percent` tinyint(3) NOT NULL DEFAULT '0',
  `value` tinyint(3) NOT NULL DEFAULT '0',
  PRIMARY KEY (`vote_id`),
  KEY `FK_RATING_OPTION_VALUE_OPTION` (`option_id`),
  KEY `FK_RATING_OPTION_REVIEW_ID` (`review_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Rating option values' AUTO_INCREMENT=1 ;

--
-- Table structure for table `rating_option_vote_aggregated`
--

CREATE TABLE IF NOT EXISTS `rating_option_vote_aggregated` (
  `primary_id` int(11) NOT NULL AUTO_INCREMENT,
  `rating_id` smallint(6) unsigned NOT NULL DEFAULT '0',
  `entity_pk_value` bigint(20) unsigned NOT NULL DEFAULT '0',
  `vote_count` int(10) unsigned NOT NULL DEFAULT '0',
  `vote_value_sum` int(10) unsigned NOT NULL DEFAULT '0',
  `percent` tinyint(3) NOT NULL DEFAULT '0',
  `percent_approved` tinyint(3) DEFAULT '0',
  `store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`primary_id`),
  KEY `FK_RATING_OPTION_VALUE_AGGREGATE` (`rating_id`),
  KEY `FK_RATING_OPTION_VOTE_AGGREGATED_STORE` (`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `rating_store`
--

CREATE TABLE IF NOT EXISTS `rating_store` (
  `rating_id` smallint(6) unsigned NOT NULL DEFAULT '0',
  `store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`rating_id`,`store_id`),
  KEY `FK_RATING_STORE_STORE` (`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `rating_title`
--

CREATE TABLE IF NOT EXISTS `rating_title` (
  `rating_id` smallint(6) unsigned NOT NULL DEFAULT '0',
  `store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `value` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`rating_id`,`store_id`),
  KEY `FK_RATING_TITLE_STORE` (`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `report_event`
--

CREATE TABLE IF NOT EXISTS `report_event` (
  `event_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `logged_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `event_type_id` smallint(6) unsigned NOT NULL DEFAULT '0',
  `object_id` int(10) unsigned NOT NULL DEFAULT '0',
  `subject_id` int(10) unsigned NOT NULL DEFAULT '0',
  `subtype` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `store_id` smallint(5) unsigned NOT NULL,
  PRIMARY KEY (`event_id`),
  KEY `IDX_EVENT_TYPE` (`event_type_id`),
  KEY `IDX_SUBJECT` (`subject_id`),
  KEY `IDX_OBJECT` (`object_id`),
  KEY `IDX_SUBTYPE` (`subtype`),
  KEY `FK_REPORT_EVENT_STORE` (`store_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Table structure for table `report_event_types`
--

CREATE TABLE IF NOT EXISTS `report_event_types` (
  `event_type_id` smallint(6) unsigned NOT NULL AUTO_INCREMENT,
  `event_name` varchar(64) NOT NULL,
  `customer_login` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`event_type_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=7 ;

--
-- Dumping data for table `report_event_types`
--

INSERT INTO `report_event_types` (`event_type_id`, `event_name`, `customer_login`) VALUES
(1, 'catalog_product_view', 1),
(2, 'sendfriend_product', 1),
(3, 'catalog_product_compare_add_product', 1),
(4, 'checkout_cart_add_product', 1),
(5, 'wishlist_add_product', 1),
(6, 'wishlist_share', 1);

--
-- Table structure for table `review`
--

CREATE TABLE IF NOT EXISTS `review` (
  `review_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `entity_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `entity_pk_value` int(10) unsigned NOT NULL DEFAULT '0',
  `status_id` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`review_id`),
  KEY `FK_REVIEW_ENTITY` (`entity_id`),
  KEY `FK_REVIEW_STATUS` (`status_id`),
  KEY `FK_REVIEW_PARENT_PRODUCT` (`entity_pk_value`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Review base information' AUTO_INCREMENT=1 ;

--
-- Table structure for table `review_detail`
--

CREATE TABLE IF NOT EXISTS `review_detail` (
  `detail_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `review_id` bigint(20) unsigned NOT NULL DEFAULT '0',
  `store_id` smallint(5) unsigned DEFAULT '0',
  `title` varchar(255) NOT NULL DEFAULT '',
  `detail` text NOT NULL,
  `nickname` varchar(128) NOT NULL DEFAULT '',
  `customer_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`detail_id`),
  KEY `FK_REVIEW_DETAIL_REVIEW` (`review_id`),
  KEY `FK_REVIEW_DETAIL_STORE` (`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Review detail information' AUTO_INCREMENT=1 ;

--
-- Table structure for table `review_entity`
--

CREATE TABLE IF NOT EXISTS `review_entity` (
  `entity_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `entity_code` varchar(32) NOT NULL DEFAULT '',
  PRIMARY KEY (`entity_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Review entities' AUTO_INCREMENT=4 ;

--
-- Dumping data for table `review_entity`
--

INSERT INTO `review_entity` (`entity_id`, `entity_code`) VALUES
(1, 'product'),
(2, 'customer'),
(3, 'category');

--
-- Table structure for table `review_entity_summary`
--

CREATE TABLE IF NOT EXISTS `review_entity_summary` (
  `primary_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `entity_pk_value` bigint(20) NOT NULL DEFAULT '0',
  `entity_type` tinyint(4) NOT NULL DEFAULT '0',
  `reviews_count` smallint(6) NOT NULL DEFAULT '0',
  `rating_summary` tinyint(4) NOT NULL DEFAULT '0',
  `store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`primary_id`),
  KEY `FK_REVIEW_ENTITY_SUMMARY_STORE` (`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `review_status`
--

CREATE TABLE IF NOT EXISTS `review_status` (
  `status_id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `status_code` varchar(32) NOT NULL DEFAULT '',
  PRIMARY KEY (`status_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Review statuses' AUTO_INCREMENT=4 ;

--
-- Dumping data for table `review_status`
--

INSERT INTO `review_status` (`status_id`, `status_code`) VALUES
(1, 'Approved'),
(2, 'Pending'),
(3, 'Not Approved');

--
-- Table structure for table `review_store`
--

CREATE TABLE IF NOT EXISTS `review_store` (
  `review_id` bigint(20) unsigned NOT NULL,
  `store_id` smallint(5) unsigned NOT NULL,
  PRIMARY KEY (`review_id`,`store_id`),
  KEY `FK_REVIEW_STORE_STORE` (`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `salesrule`
--

CREATE TABLE IF NOT EXISTS `salesrule` (
  `rule_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `description` text NOT NULL,
  `from_date` date DEFAULT '0000-00-00',
  `to_date` date DEFAULT '0000-00-00',
  `coupon_code` varchar(255) DEFAULT NULL,
  `uses_per_coupon` int(11) NOT NULL DEFAULT '0',
  `uses_per_customer` int(11) NOT NULL DEFAULT '0',
  `customer_group_ids` varchar(255) NOT NULL DEFAULT '',
  `is_active` tinyint(1) NOT NULL DEFAULT '0',
  `conditions_serialized` mediumtext NOT NULL,
  `actions_serialized` mediumtext NOT NULL,
  `stop_rules_processing` tinyint(1) NOT NULL DEFAULT '1',
  `is_advanced` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `product_ids` text,
  `sort_order` int(10) unsigned NOT NULL DEFAULT '0',
  `simple_action` varchar(32) NOT NULL DEFAULT '',
  `discount_amount` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `discount_qty` decimal(12,4) unsigned DEFAULT NULL,
  `discount_step` int(10) unsigned NOT NULL,
  `simple_free_shipping` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `times_used` int(11) unsigned NOT NULL DEFAULT '0',
  `is_rss` tinyint(4) NOT NULL DEFAULT '0',
  `website_ids` text,
  PRIMARY KEY (`rule_id`),
  KEY `sort_order` (`is_active`,`sort_order`,`to_date`,`from_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `salesrule_customer`
--

CREATE TABLE IF NOT EXISTS `salesrule_customer` (
  `rule_customer_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `rule_id` int(10) unsigned NOT NULL DEFAULT '0',
  `customer_id` int(10) unsigned NOT NULL DEFAULT '0',
  `times_used` smallint(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`rule_customer_id`),
  KEY `rule_id` (`rule_id`,`customer_id`),
  KEY `customer_id` (`customer_id`,`rule_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `sales_flat_order_item`
--

CREATE TABLE IF NOT EXISTS `sales_flat_order_item` (
  `item_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `order_id` int(10) unsigned NOT NULL DEFAULT '0',
  `parent_item_id` int(10) unsigned DEFAULT NULL,
  `quote_item_id` int(10) unsigned DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `product_id` int(10) unsigned DEFAULT NULL,
  `product_type` varchar(255) DEFAULT NULL,
  `product_options` text,
  `weight` decimal(12,4) DEFAULT '0.0000',
  `is_virtual` tinyint(1) unsigned DEFAULT NULL,
  `sku` varchar(255) NOT NULL DEFAULT '',
  `name` varchar(255) DEFAULT NULL,
  `description` text,
  `applied_rule_ids` text,
  `additional_data` text,
  `free_shipping` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `is_qty_decimal` tinyint(1) unsigned DEFAULT NULL,
  `no_discount` tinyint(1) unsigned DEFAULT '0',
  `qty_backordered` decimal(12,4) DEFAULT '0.0000',
  `qty_canceled` decimal(12,4) DEFAULT '0.0000',
  `qty_invoiced` decimal(12,4) DEFAULT '0.0000',
  `qty_ordered` decimal(12,4) DEFAULT '0.0000',
  `qty_refunded` decimal(12,4) DEFAULT '0.0000',
  `qty_shipped` decimal(12,4) DEFAULT '0.0000',
  `cost` decimal(12,4) DEFAULT '0.0000',
  `price` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `base_price` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `original_price` decimal(12,4) DEFAULT NULL,
  `base_original_price` decimal(12,4) DEFAULT NULL,
  `tax_percent` decimal(12,4) DEFAULT '0.0000',
  `tax_amount` decimal(12,4) DEFAULT '0.0000',
  `base_tax_amount` decimal(12,4) DEFAULT '0.0000',
  `tax_invoiced` decimal(12,4) DEFAULT '0.0000',
  `base_tax_invoiced` decimal(12,4) DEFAULT '0.0000',
  `discount_percent` decimal(12,4) DEFAULT '0.0000',
  `discount_amount` decimal(12,4) DEFAULT '0.0000',
  `base_discount_amount` decimal(12,4) DEFAULT '0.0000',
  `discount_invoiced` decimal(12,4) DEFAULT '0.0000',
  `base_discount_invoiced` decimal(12,4) DEFAULT '0.0000',
  `amount_refunded` decimal(12,4) DEFAULT '0.0000',
  `base_amount_refunded` decimal(12,4) DEFAULT '0.0000',
  `row_total` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `base_row_total` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `row_invoiced` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `base_row_invoiced` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `row_weight` decimal(12,4) DEFAULT '0.0000',
  `gift_message_id` int(10) DEFAULT NULL,
  `gift_message_available` int(10) DEFAULT NULL,
  `base_tax_before_discount` decimal(12,4) DEFAULT NULL,
  `tax_before_discount` decimal(12,4) DEFAULT NULL,
  `ext_order_item_id` varchar(255) DEFAULT NULL,
  `locked_do_invoice` int(10) unsigned DEFAULT NULL,
  `locked_do_ship` int(10) unsigned DEFAULT NULL,
  `weee_tax_applied` text,
  `weee_tax_applied_amount` decimal(12,4) DEFAULT NULL,
  `weee_tax_applied_row_amount` decimal(12,4) DEFAULT NULL,
  `base_weee_tax_applied_amount` decimal(12,4) DEFAULT NULL,
  `base_weee_tax_applied_row_amount` decimal(12,4) DEFAULT NULL,
  `weee_tax_disposition` decimal(12,4) DEFAULT NULL,
  `weee_tax_row_disposition` decimal(12,4) DEFAULT NULL,
  `base_weee_tax_disposition` decimal(12,4) DEFAULT NULL,
  `base_weee_tax_row_disposition` decimal(12,4) DEFAULT NULL,
  PRIMARY KEY (`item_id`),
  KEY `IDX_ORDER` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `sales_flat_quote`
--

CREATE TABLE IF NOT EXISTS `sales_flat_quote` (
  `entity_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `converted_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `is_active` tinyint(1) unsigned DEFAULT '1',
  `is_virtual` tinyint(1) unsigned DEFAULT '0',
  `is_multi_shipping` tinyint(1) unsigned DEFAULT '0',
  `items_count` int(10) unsigned DEFAULT '0',
  `items_qty` decimal(12,4) DEFAULT '0.0000',
  `orig_order_id` int(10) unsigned DEFAULT '0',
  `store_to_base_rate` decimal(12,4) DEFAULT '0.0000',
  `store_to_quote_rate` decimal(12,4) DEFAULT '0.0000',
  `base_currency_code` varchar(255) DEFAULT NULL,
  `store_currency_code` varchar(255) DEFAULT NULL,
  `quote_currency_code` varchar(255) DEFAULT NULL,
  `grand_total` decimal(12,4) DEFAULT '0.0000',
  `base_grand_total` decimal(12,4) DEFAULT '0.0000',
  `checkout_method` varchar(255) DEFAULT NULL,
  `customer_id` int(10) unsigned DEFAULT '0',
  `customer_tax_class_id` int(10) unsigned DEFAULT '0',
  `customer_group_id` int(10) unsigned DEFAULT '0',
  `customer_email` varchar(255) DEFAULT NULL,
  `customer_prefix` varchar(40) DEFAULT NULL,
  `customer_firstname` varchar(255) DEFAULT NULL,
  `customer_middlename` varchar(40) DEFAULT NULL,
  `customer_lastname` varchar(255) DEFAULT NULL,
  `customer_suffix` varchar(40) DEFAULT NULL,
  `customer_dob` datetime DEFAULT NULL,
  `customer_note` varchar(255) DEFAULT NULL,
  `customer_note_notify` tinyint(1) unsigned DEFAULT '1',
  `customer_is_guest` tinyint(1) unsigned DEFAULT '0',
  `remote_ip` varchar(32) DEFAULT NULL,
  `applied_rule_ids` varchar(255) DEFAULT NULL,
  `reserved_order_id` varchar(64) DEFAULT '',
  `password_hash` varchar(255) DEFAULT NULL,
  `coupon_code` varchar(255) DEFAULT NULL,
  `global_currency_code` varchar(255) DEFAULT NULL,
  `base_to_global_rate` decimal(12,4) DEFAULT NULL,
  `base_to_quote_rate` decimal(12,4) DEFAULT NULL,
  `customer_taxvat` varchar(255) DEFAULT NULL,
  `subtotal` decimal(12,4) DEFAULT NULL,
  `base_subtotal` decimal(12,4) DEFAULT NULL,
  `subtotal_with_discount` decimal(12,4) DEFAULT NULL,
  `base_subtotal_with_discount` decimal(12,4) DEFAULT NULL,
  `is_changed` int(10) unsigned DEFAULT NULL,
  `trigger_recollect` tinyint(1) NOT NULL DEFAULT '0',
  `ext_shipping_info` text,
  `gift_message_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`entity_id`),
  KEY `FK_SALES_QUOTE_STORE` (`store_id`),
  KEY `IDX_CUSTOMER` (`customer_id`,`store_id`,`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `sales_flat_quote_address`
--

CREATE TABLE IF NOT EXISTS `sales_flat_quote_address` (
  `address_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `quote_id` int(10) unsigned NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `customer_id` int(10) unsigned DEFAULT NULL,
  `save_in_address_book` tinyint(1) DEFAULT '0',
  `customer_address_id` int(10) unsigned DEFAULT NULL,
  `address_type` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `prefix` varchar(40) DEFAULT NULL,
  `firstname` varchar(255) DEFAULT NULL,
  `middlename` varchar(40) DEFAULT NULL,
  `lastname` varchar(255) DEFAULT NULL,
  `suffix` varchar(40) DEFAULT NULL,
  `company` varchar(255) DEFAULT NULL,
  `street` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `region` varchar(255) DEFAULT NULL,
  `region_id` int(10) unsigned DEFAULT NULL,
  `postcode` varchar(255) DEFAULT NULL,
  `country_id` varchar(255) DEFAULT NULL,
  `telephone` varchar(255) DEFAULT NULL,
  `fax` varchar(255) DEFAULT NULL,
  `same_as_billing` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `free_shipping` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `collect_shipping_rates` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `shipping_method` varchar(255) NOT NULL DEFAULT '',
  `shipping_description` varchar(255) NOT NULL DEFAULT '',
  `weight` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `subtotal` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `base_subtotal` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `subtotal_with_discount` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `base_subtotal_with_discount` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `tax_amount` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `base_tax_amount` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `shipping_amount` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `base_shipping_amount` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `shipping_tax_amount` decimal(12,4) DEFAULT NULL,
  `base_shipping_tax_amount` decimal(12,4) DEFAULT NULL,
  `discount_amount` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `base_discount_amount` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `grand_total` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `base_grand_total` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `customer_notes` text,
  `applied_taxes` text,
  `gift_message_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`address_id`),
  KEY `FK_SALES_QUOTE_ADDRESS_SALES_QUOTE` (`quote_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `sales_flat_quote_address_item`
--

CREATE TABLE IF NOT EXISTS `sales_flat_quote_address_item` (
  `address_item_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `parent_item_id` int(10) unsigned DEFAULT NULL,
  `quote_address_id` int(10) unsigned NOT NULL DEFAULT '0',
  `quote_item_id` int(10) unsigned NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `applied_rule_ids` text,
  `additional_data` text,
  `weight` decimal(12,4) DEFAULT '0.0000',
  `qty` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `discount_amount` decimal(12,4) DEFAULT '0.0000',
  `tax_amount` decimal(12,4) DEFAULT '0.0000',
  `row_total` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `base_row_total` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `row_total_with_discount` decimal(12,4) DEFAULT '0.0000',
  `base_discount_amount` decimal(12,4) DEFAULT '0.0000',
  `base_tax_amount` decimal(12,4) DEFAULT '0.0000',
  `row_weight` decimal(12,4) DEFAULT '0.0000',
  `product_id` int(10) unsigned DEFAULT NULL,
  `super_product_id` int(10) unsigned DEFAULT NULL,
  `parent_product_id` int(10) unsigned DEFAULT NULL,
  `sku` varchar(255) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `description` text,
  `free_shipping` int(10) unsigned DEFAULT NULL,
  `is_qty_decimal` int(10) unsigned DEFAULT NULL,
  `price` decimal(12,4) DEFAULT NULL,
  `discount_percent` decimal(12,4) DEFAULT NULL,
  `no_discount` int(10) unsigned DEFAULT NULL,
  `tax_percent` decimal(12,4) DEFAULT NULL,
  `base_price` decimal(12,4) DEFAULT NULL,
  `gift_message_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`address_item_id`),
  KEY `FK_QUOTE_ADDRESS_ITEM_QUOTE_ADDRESS` (`quote_address_id`),
  KEY `FK_SALES_QUOTE_ADDRESS_ITEM_QUOTE_ITEM` (`quote_item_id`),
  KEY `FK_SALES_FLAT_QUOTE_ADDRESS_ITEM_PARENT` (`parent_item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `sales_flat_quote_item`
--

CREATE TABLE IF NOT EXISTS `sales_flat_quote_item` (
  `item_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `quote_id` int(10) unsigned NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `product_id` int(10) unsigned DEFAULT NULL,
  `parent_item_id` int(10) unsigned DEFAULT NULL,
  `is_virtual` tinyint(1) unsigned DEFAULT NULL,
  `sku` varchar(255) NOT NULL DEFAULT '',
  `name` varchar(255) DEFAULT NULL,
  `description` text,
  `applied_rule_ids` text,
  `additional_data` text,
  `free_shipping` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `is_qty_decimal` tinyint(1) unsigned DEFAULT NULL,
  `no_discount` tinyint(1) unsigned DEFAULT '0',
  `weight` decimal(12,4) DEFAULT '0.0000',
  `qty` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `price` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `base_price` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `custom_price` decimal(12,4) DEFAULT NULL,
  `discount_percent` decimal(12,4) DEFAULT '0.0000',
  `discount_amount` decimal(12,4) DEFAULT '0.0000',
  `base_discount_amount` decimal(12,4) DEFAULT '0.0000',
  `tax_percent` decimal(12,4) DEFAULT '0.0000',
  `tax_amount` decimal(12,4) DEFAULT '0.0000',
  `base_tax_amount` decimal(12,4) DEFAULT '0.0000',
  `row_total` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `base_row_total` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `row_total_with_discount` decimal(12,4) DEFAULT '0.0000',
  `row_weight` decimal(12,4) DEFAULT '0.0000',
  `product_type` varchar(255) DEFAULT NULL,
  `base_tax_before_discount` decimal(12,4) DEFAULT NULL,
  `tax_before_discount` decimal(12,4) DEFAULT NULL,
  `original_custom_price` decimal(12,4) DEFAULT NULL,
  `gift_message_id` int(10) unsigned DEFAULT NULL,
  `weee_tax_applied` text,
  `weee_tax_applied_amount` decimal(12,4) DEFAULT NULL,
  `weee_tax_applied_row_amount` decimal(12,4) DEFAULT NULL,
  `base_weee_tax_applied_amount` decimal(12,4) DEFAULT NULL,
  `base_weee_tax_applied_row_amount` decimal(12,4) DEFAULT NULL,
  `weee_tax_disposition` decimal(12,4) DEFAULT NULL,
  `weee_tax_row_disposition` decimal(12,4) DEFAULT NULL,
  `base_weee_tax_disposition` decimal(12,4) DEFAULT NULL,
  `base_weee_tax_row_disposition` decimal(12,4) DEFAULT NULL,
  PRIMARY KEY (`item_id`),
  KEY `FK_SALES_QUOTE_ITEM_SALES_QUOTE` (`quote_id`),
  KEY `FK_SALES_FLAT_QUOTE_ITEM_PARENT_ITEM` (`parent_item_id`),
  KEY `FK_SALES_QUOTE_ITEM_CATALOG_PRODUCT_ENTITY` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `sales_flat_quote_item_option`
--

CREATE TABLE IF NOT EXISTS `sales_flat_quote_item_option` (
  `option_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `item_id` int(10) unsigned NOT NULL,
  `product_id` int(10) unsigned NOT NULL,
  `code` varchar(255) NOT NULL,
  `value` text NOT NULL,
  PRIMARY KEY (`option_id`),
  KEY `FK_SALES_QUOTE_ITEM_OPTION_ITEM_ID` (`item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Additional options for quote item' AUTO_INCREMENT=1 ;

--
-- Table structure for table `sales_flat_quote_payment`
--

CREATE TABLE IF NOT EXISTS `sales_flat_quote_payment` (
  `payment_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `quote_id` int(10) unsigned NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `method` varchar(255) DEFAULT '',
  `cc_type` varchar(255) DEFAULT '',
  `cc_number_enc` varchar(255) DEFAULT '',
  `cc_last4` varchar(255) DEFAULT '',
  `cc_cid_enc` varchar(255) DEFAULT '',
  `cc_owner` varchar(255) DEFAULT '',
  `cc_exp_month` tinyint(2) unsigned DEFAULT '0',
  `cc_exp_year` smallint(4) unsigned DEFAULT '0',
  `cc_ss_owner` varchar(255) DEFAULT '',
  `cc_ss_start_month` tinyint(2) unsigned DEFAULT '0',
  `cc_ss_start_year` smallint(4) unsigned DEFAULT '0',
  `cybersource_token` varchar(255) DEFAULT '',
  `paypal_correlation_id` varchar(255) DEFAULT '',
  `paypal_payer_id` varchar(255) DEFAULT '',
  `paypal_payer_status` varchar(255) DEFAULT '',
  `po_number` varchar(255) DEFAULT '',
  `additional_data` text,
  `cc_ss_issue` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`payment_id`),
  KEY `FK_SALES_QUOTE_PAYMENT_SALES_QUOTE` (`quote_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `sales_flat_quote_shipping_rate`
--

CREATE TABLE IF NOT EXISTS `sales_flat_quote_shipping_rate` (
  `rate_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `address_id` int(10) unsigned NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `carrier` varchar(255) DEFAULT NULL,
  `carrier_title` varchar(255) DEFAULT NULL,
  `code` varchar(255) DEFAULT NULL,
  `method` varchar(255) DEFAULT NULL,
  `method_description` text,
  `price` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `error_message` text,
  `method_title` text,
  PRIMARY KEY (`rate_id`),
  KEY `FK_SALES_QUOTE_SHIPPING_RATE_ADDRESS` (`address_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `sales_order`
--

CREATE TABLE IF NOT EXISTS `sales_order` (
  `entity_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `entity_type_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `attribute_set_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `increment_id` varchar(50) NOT NULL DEFAULT '',
  `parent_id` int(10) unsigned NOT NULL DEFAULT '0',
  `store_id` smallint(5) unsigned DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `is_active` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `customer_id` int(10) unsigned DEFAULT NULL,
  `tax_amount` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `shipping_amount` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `discount_amount` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `subtotal` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `grand_total` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `total_paid` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `total_refunded` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `total_qty_ordered` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `total_canceled` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `total_invoiced` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `total_online_refunded` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `total_offline_refunded` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `base_tax_amount` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `base_shipping_amount` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `base_discount_amount` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `base_subtotal` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `base_grand_total` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `base_total_paid` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `base_total_refunded` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `base_total_qty_ordered` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `base_total_canceled` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `base_total_invoiced` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `base_total_online_refunded` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `base_total_offline_refunded` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `subtotal_refunded` decimal(12,4) DEFAULT NULL,
  `subtotal_canceled` decimal(12,4) DEFAULT NULL,
  `discount_refunded` decimal(12,4) DEFAULT NULL,
  `discount_canceled` decimal(12,4) DEFAULT NULL,
  `discount_invoiced` decimal(12,4) DEFAULT NULL,
  `tax_refunded` decimal(12,4) DEFAULT NULL,
  `tax_canceled` decimal(12,4) DEFAULT NULL,
  `shipping_refunded` decimal(12,4) DEFAULT NULL,
  `shipping_canceled` decimal(12,4) DEFAULT NULL,
  `base_subtotal_refunded` decimal(12,4) DEFAULT NULL,
  `base_subtotal_canceled` decimal(12,4) DEFAULT NULL,
  `base_discount_refunded` decimal(12,4) DEFAULT NULL,
  `base_discount_canceled` decimal(12,4) DEFAULT NULL,
  `base_discount_invoiced` decimal(12,4) DEFAULT NULL,
  `base_tax_refunded` decimal(12,4) DEFAULT NULL,
  `base_tax_canceled` decimal(12,4) DEFAULT NULL,
  `base_shipping_refunded` decimal(12,4) DEFAULT NULL,
  `base_shipping_canceled` decimal(12,4) DEFAULT NULL,
  `subtotal_invoiced` decimal(12,4) DEFAULT NULL,
  `tax_invoiced` decimal(12,4) DEFAULT NULL,
  `shipping_invoiced` decimal(12,4) DEFAULT NULL,
  `base_subtotal_invoiced` decimal(12,4) DEFAULT NULL,
  `base_tax_invoiced` decimal(12,4) DEFAULT NULL,
  `base_shipping_invoiced` decimal(12,4) DEFAULT NULL,
  `shipping_tax_amount` decimal(12,4) DEFAULT NULL,
  `base_shipping_tax_amount` decimal(12,4) DEFAULT NULL,
  `shipping_tax_refunded` decimal(12,4) DEFAULT NULL,
  `base_shipping_tax_refunded` decimal(12,4) DEFAULT NULL,
  PRIMARY KEY (`entity_id`),
  KEY `FK_SALES_ORDER_TYPE` (`entity_type_id`),
  KEY `FK_SALES_ORDER_STORE` (`store_id`),
  KEY `IDX_CUSTOMER` (`customer_id`),
  KEY `IDX_INCREMENT_ID` (`increment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC AUTO_INCREMENT=1 ;

--
-- Table structure for table `sales_order_datetime`
--

CREATE TABLE IF NOT EXISTS `sales_order_datetime` (
  `value_id` int(11) NOT NULL AUTO_INCREMENT,
  `entity_type_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `attribute_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `entity_id` int(10) unsigned NOT NULL DEFAULT '0',
  `value` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`value_id`),
  UNIQUE KEY `UNQ_ENTITY_ATTRIBUTE_TYPE` (`entity_id`,`attribute_id`,`entity_type_id`),
  KEY `FK_SALES_ORDER_DATETIME_ENTITY_TYPE` (`entity_type_id`),
  KEY `FK_SALES_ORDER_DATETIME_ATTRIBUTE` (`attribute_id`),
  KEY `FK_SALES_ORDER_DATETIME` (`entity_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `sales_order_decimal`
--

CREATE TABLE IF NOT EXISTS `sales_order_decimal` (
  `value_id` int(11) NOT NULL AUTO_INCREMENT,
  `entity_type_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `attribute_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `entity_id` int(10) unsigned NOT NULL DEFAULT '0',
  `value` decimal(12,4) NOT NULL DEFAULT '0.0000',
  PRIMARY KEY (`value_id`),
  UNIQUE KEY `UNQ_ENTITY_ATTRIBUTE_TYPE` (`entity_id`,`attribute_id`,`entity_type_id`),
  KEY `FK_SALES_ORDER_DECIMAL_ENTITY_TYPE` (`entity_type_id`),
  KEY `FK_SALES_ORDER_DECIMAL_ATTRIBUTE` (`attribute_id`),
  KEY `FK_SALES_ORDER_DECIMAL` (`entity_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `sales_order_entity`
--

CREATE TABLE IF NOT EXISTS `sales_order_entity` (
  `entity_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `entity_type_id` smallint(8) unsigned NOT NULL DEFAULT '0',
  `attribute_set_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `increment_id` varchar(50) NOT NULL DEFAULT '',
  `parent_id` int(10) unsigned NOT NULL DEFAULT '0',
  `store_id` smallint(5) unsigned DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `is_active` tinyint(1) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`entity_id`),
  KEY `FK_SALES_ORDER_ENTITY_TYPE` (`entity_type_id`),
  KEY `FK_SALES_ORDER_ENTITY_STORE` (`store_id`),
  KEY `IDX_SALES_ORDER_ENTITY_PARENT` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC AUTO_INCREMENT=1 ;

--
-- Table structure for table `sales_order_entity_datetime`
--

CREATE TABLE IF NOT EXISTS `sales_order_entity_datetime` (
  `value_id` int(11) NOT NULL AUTO_INCREMENT,
  `entity_type_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `attribute_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `entity_id` int(10) unsigned NOT NULL DEFAULT '0',
  `value` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`value_id`),
  UNIQUE KEY `UNQ_ENTITY_ATTRIBUTE_TYPE` (`entity_id`,`attribute_id`,`entity_type_id`),
  KEY `FK_SALES_ORDER_ENTITY_DATETIME_ENTITY_TYPE` (`entity_type_id`),
  KEY `FK_SALES_ORDER_ENTITY_DATETIME_ATTRIBUTE` (`attribute_id`),
  KEY `FK_SALES_ORDER_ENTITY_DATETIME` (`entity_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `sales_order_entity_decimal`
--

CREATE TABLE IF NOT EXISTS `sales_order_entity_decimal` (
  `value_id` int(11) NOT NULL AUTO_INCREMENT,
  `entity_type_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `attribute_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `entity_id` int(10) unsigned NOT NULL DEFAULT '0',
  `value` decimal(12,4) NOT NULL DEFAULT '0.0000',
  PRIMARY KEY (`value_id`),
  UNIQUE KEY `UNQ_ENTITY_ATTRIBUTE_TYPE` (`entity_id`,`attribute_id`,`entity_type_id`),
  KEY `FK_SALES_ORDER_ENTITY_DECIMAL_ENTITY_TYPE` (`entity_type_id`),
  KEY `FK_SALES_ORDER_ENTITY_DECIMAL_ATTRIBUTE` (`attribute_id`),
  KEY `FK_SALES_ORDER_ENTITY_DECIMAL` (`entity_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `sales_order_entity_int`
--

CREATE TABLE IF NOT EXISTS `sales_order_entity_int` (
  `value_id` int(11) NOT NULL AUTO_INCREMENT,
  `entity_type_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `attribute_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `entity_id` int(10) unsigned NOT NULL DEFAULT '0',
  `value` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`value_id`),
  UNIQUE KEY `UNQ_ENTITY_ATTRIBUTE_TYPE` (`entity_id`,`attribute_id`,`entity_type_id`),
  KEY `FK_SALES_ORDER_ENTITY_INT_ENTITY_TYPE` (`entity_type_id`),
  KEY `FK_SALES_ORDER_ENTITY_INT_ATTRIBUTE` (`attribute_id`),
  KEY `FK_SALES_ORDER_ENTITY_INT` (`entity_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `sales_order_entity_text`
--

CREATE TABLE IF NOT EXISTS `sales_order_entity_text` (
  `value_id` int(11) NOT NULL AUTO_INCREMENT,
  `entity_type_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `attribute_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `entity_id` int(10) unsigned NOT NULL DEFAULT '0',
  `value` text NOT NULL,
  PRIMARY KEY (`value_id`),
  UNIQUE KEY `UNQ_ENTITY_ATTRIBUTE_TYPE` (`entity_id`,`attribute_id`,`entity_type_id`),
  KEY `FK_SALES_ORDER_ENTITY_TEXT_ENTITY_TYPE` (`entity_type_id`),
  KEY `FK_SALES_ORDER_ENTITY_TEXT_ATTRIBUTE` (`attribute_id`),
  KEY `FK_SALES_ORDER_ENTITY_TEXT` (`entity_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `sales_order_entity_varchar`
--

CREATE TABLE IF NOT EXISTS `sales_order_entity_varchar` (
  `value_id` int(11) NOT NULL AUTO_INCREMENT,
  `entity_type_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `attribute_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `entity_id` int(10) unsigned NOT NULL DEFAULT '0',
  `value` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`value_id`),
  UNIQUE KEY `UNQ_ENTITY_ATTRIBUTE_TYPE` (`entity_id`,`attribute_id`,`entity_type_id`),
  KEY `FK_SALES_ORDER_ENTITY_VARCHAR_ENTITY_TYPE` (`entity_type_id`),
  KEY `FK_SALES_ORDER_ENTITY_VARCHAR_ATTRIBUTE` (`attribute_id`),
  KEY `FK_SALES_ORDER_ENTITY_VARCHAR` (`entity_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `sales_order_int`
--

CREATE TABLE IF NOT EXISTS `sales_order_int` (
  `value_id` int(11) NOT NULL AUTO_INCREMENT,
  `entity_type_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `attribute_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `entity_id` int(10) unsigned NOT NULL DEFAULT '0',
  `value` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`value_id`),
  UNIQUE KEY `UNQ_ENTITY_ATTRIBUTE_TYPE` (`entity_id`,`attribute_id`,`entity_type_id`),
  KEY `FK_SALES_ORDER_INT_ENTITY_TYPE` (`entity_type_id`),
  KEY `FK_SALES_ORDER_INT_ATTRIBUTE` (`attribute_id`),
  KEY `FK_SALES_ORDER_INT` (`entity_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `sales_order_tax`
--

CREATE TABLE IF NOT EXISTS `sales_order_tax` (
  `tax_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `order_id` int(10) unsigned NOT NULL,
  `code` varchar(255) NOT NULL,
  `title` varchar(255) NOT NULL,
  `percent` decimal(12,4) NOT NULL,
  `amount` decimal(12,4) NOT NULL,
  `priority` int(11) NOT NULL,
  `position` int(11) NOT NULL,
  `base_amount` decimal(12,4) NOT NULL,
  `process` smallint(6) NOT NULL,
  `base_real_amount` decimal(12,4) NOT NULL,
  `hidden` smallint(5) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`tax_id`),
  KEY `IDX_ORDER_TAX` (`order_id`,`priority`,`position`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `sales_order_text`
--

CREATE TABLE IF NOT EXISTS `sales_order_text` (
  `value_id` int(11) NOT NULL AUTO_INCREMENT,
  `entity_type_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `attribute_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `entity_id` int(10) unsigned NOT NULL DEFAULT '0',
  `value` text NOT NULL,
  PRIMARY KEY (`value_id`),
  UNIQUE KEY `UNQ_ENTITY_ATTRIBUTE_TYPE` (`entity_id`,`attribute_id`,`entity_type_id`),
  KEY `FK_SALES_ORDER_TEXT_ENTITY_TYPE` (`entity_type_id`),
  KEY `FK_SALES_ORDER_TEXT_ATTRIBUTE` (`attribute_id`),
  KEY `FK_SALES_ORDER_TEXT` (`entity_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `sales_order_varchar`
--

CREATE TABLE IF NOT EXISTS `sales_order_varchar` (
  `value_id` int(11) NOT NULL AUTO_INCREMENT,
  `entity_type_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `attribute_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `entity_id` int(10) unsigned NOT NULL DEFAULT '0',
  `value` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`value_id`),
  UNIQUE KEY `UNQ_ENTITY_ATTRIBUTE_TYPE` (`entity_id`,`attribute_id`,`entity_type_id`),
  KEY `FK_SALES_ORDER_VARCHAR_ENTITY_TYPE` (`entity_type_id`),
  KEY `FK_SALES_ORDER_VARCHAR_ATTRIBUTE` (`attribute_id`),
  KEY `FK_SALES_ORDER_VARCHAR` (`entity_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `sendfriend_log`
--

CREATE TABLE IF NOT EXISTS `sendfriend_log` (
  `log_id` int(11) NOT NULL AUTO_INCREMENT,
  `ip` int(11) unsigned NOT NULL DEFAULT '0',
  `time` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`log_id`),
  KEY `ip` (`ip`),
  KEY `time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Send to friend function log storage table' AUTO_INCREMENT=1 ;

--
-- Table structure for table `shipping_tablerate`
--

CREATE TABLE IF NOT EXISTS `shipping_tablerate` (
  `pk` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `website_id` int(11) NOT NULL DEFAULT '0',
  `dest_country_id` varchar(4) NOT NULL DEFAULT '0',
  `dest_region_id` int(10) NOT NULL DEFAULT '0',
  `dest_zip` varchar(10) NOT NULL DEFAULT '',
  `condition_name` varchar(20) NOT NULL DEFAULT '',
  `condition_value` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `price` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `cost` decimal(12,4) NOT NULL DEFAULT '0.0000',
  PRIMARY KEY (`pk`),
  UNIQUE KEY `dest_country` (`website_id`,`dest_country_id`,`dest_region_id`,`dest_zip`,`condition_name`,`condition_value`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `sitemap`
--

CREATE TABLE IF NOT EXISTS `sitemap` (
  `sitemap_id` int(11) NOT NULL AUTO_INCREMENT,
  `sitemap_type` varchar(32) DEFAULT NULL,
  `sitemap_filename` varchar(32) DEFAULT NULL,
  `sitemap_path` tinytext,
  `sitemap_time` timestamp NULL DEFAULT NULL,
  `store_id` smallint(5) unsigned NOT NULL,
  PRIMARY KEY (`sitemap_id`),
  KEY `FK_SITEMAP_STORE` (`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `tag`
--

CREATE TABLE IF NOT EXISTS `tag` (
  `tag_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `status` smallint(6) NOT NULL DEFAULT '0',
  PRIMARY KEY (`tag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `tag_relation`
--

CREATE TABLE IF NOT EXISTS `tag_relation` (
  `tag_relation_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `tag_id` int(11) unsigned NOT NULL DEFAULT '0',
  `customer_id` int(10) unsigned NOT NULL DEFAULT '0',
  `product_id` int(11) unsigned NOT NULL DEFAULT '0',
  `store_id` smallint(6) unsigned NOT NULL DEFAULT '1',
  `active` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`tag_relation_id`),
  KEY `IDX_PRODUCT` (`product_id`),
  KEY `IDX_TAG` (`tag_id`),
  KEY `IDX_CUSTOMER` (`customer_id`),
  KEY `IDX_STORE` (`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `tag_summary`
--

CREATE TABLE IF NOT EXISTS `tag_summary` (
  `tag_id` int(11) unsigned NOT NULL DEFAULT '0',
  `store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `customers` int(11) unsigned NOT NULL DEFAULT '0',
  `products` int(11) unsigned NOT NULL DEFAULT '0',
  `uses` int(11) unsigned NOT NULL DEFAULT '0',
  `historical_uses` int(11) unsigned NOT NULL DEFAULT '0',
  `popularity` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`tag_id`,`store_id`),
  KEY `FK_TAG_SUMMARY_STORE` (`store_id`),
  KEY `IDX_TAG` (`tag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `tax_calculation`
--

CREATE TABLE IF NOT EXISTS `tax_calculation` (
  `tax_calculation_rate_id` int(11) NOT NULL,
  `tax_calculation_rule_id` int(11) NOT NULL,
  `customer_tax_class_id` smallint(6) NOT NULL,
  `product_tax_class_id` smallint(6) NOT NULL,
  KEY `FK_TAX_CALCULATION_RULE` (`tax_calculation_rule_id`),
  KEY `FK_TAX_CALCULATION_RATE` (`tax_calculation_rate_id`),
  KEY `FK_TAX_CALCULATION_CTC` (`customer_tax_class_id`),
  KEY `FK_TAX_CALCULATION_PTC` (`product_tax_class_id`),
  KEY `IDX_TAX_CALCULATION` (`tax_calculation_rate_id`,`customer_tax_class_id`,`product_tax_class_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tax_calculation`
--

INSERT INTO `tax_calculation` (`tax_calculation_rate_id`, `tax_calculation_rule_id`, `customer_tax_class_id`, `product_tax_class_id`) VALUES
(1, 1, 3, 2),
(2, 1, 3, 2);

--
-- Table structure for table `tax_calculation_rate`
--

CREATE TABLE IF NOT EXISTS `tax_calculation_rate` (
  `tax_calculation_rate_id` int(11) NOT NULL AUTO_INCREMENT,
  `tax_country_id` char(2) NOT NULL,
  `tax_region_id` mediumint(9) NOT NULL,
  `tax_postcode` varchar(12) NOT NULL,
  `code` varchar(255) NOT NULL,
  `rate` decimal(12,4) NOT NULL,
  PRIMARY KEY (`tax_calculation_rate_id`),
  KEY `IDX_TAX_CALCULATION_RATE` (`tax_country_id`,`tax_region_id`,`tax_postcode`),
  KEY `IDX_TAX_CALCULATION_RATE_CODE` (`code`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `tax_calculation_rate`
--

INSERT INTO `tax_calculation_rate` (`tax_calculation_rate_id`, `tax_country_id`, `tax_region_id`, `tax_postcode`, `code`, `rate`) VALUES
(1, 'US', 12, '*', 'US-CA-*-Rate 1', 8.2500),
(2, 'US', 43, '*', 'US-NY-*-Rate 1', 8.3750);

--
-- Table structure for table `tax_calculation_rate_title`
--

CREATE TABLE IF NOT EXISTS `tax_calculation_rate_title` (
  `tax_calculation_rate_title_id` int(11) NOT NULL AUTO_INCREMENT,
  `tax_calculation_rate_id` int(11) NOT NULL,
  `store_id` smallint(5) unsigned NOT NULL,
  `value` varchar(255) NOT NULL,
  PRIMARY KEY (`tax_calculation_rate_title_id`),
  KEY `IDX_TAX_CALCULATION_RATE_TITLE` (`tax_calculation_rate_id`,`store_id`),
  KEY `FK_TAX_CALCULATION_RATE_TITLE_RATE` (`tax_calculation_rate_id`),
  KEY `FK_TAX_CALCULATION_RATE_TITLE_STORE` (`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `tax_calculation_rule`
--

CREATE TABLE IF NOT EXISTS `tax_calculation_rule` (
  `tax_calculation_rule_id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(255) NOT NULL,
  `priority` mediumint(9) NOT NULL,
  `position` mediumint(9) NOT NULL,
  PRIMARY KEY (`tax_calculation_rule_id`),
  KEY `IDX_TAX_CALCULATION_RULE` (`priority`,`position`,`tax_calculation_rule_id`),
  KEY `IDX_TAX_CALCULATION_RULE_CODE` (`code`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `tax_calculation_rule`
--

INSERT INTO `tax_calculation_rule` (`tax_calculation_rule_id`, `code`, `priority`, `position`) VALUES
(1, 'Retail Customer-Taxable Goods-Rate 1', 1, 1);

--
-- Table structure for table `tax_class`
--

CREATE TABLE IF NOT EXISTS `tax_class` (
  `class_id` smallint(6) NOT NULL AUTO_INCREMENT,
  `class_name` varchar(255) NOT NULL DEFAULT '',
  `class_type` enum('CUSTOMER','PRODUCT') NOT NULL DEFAULT 'CUSTOMER',
  PRIMARY KEY (`class_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=5 ;

--
-- Dumping data for table `tax_class`
--

INSERT INTO `tax_class` (`class_id`, `class_name`, `class_type`) VALUES
(2, 'Taxable Goods', 'PRODUCT'),
(3, 'Retail Customer', 'CUSTOMER'),
(4, 'Shipping', 'PRODUCT');

--
-- Table structure for table `weee_discount`
--

CREATE TABLE IF NOT EXISTS `weee_discount` (
  `entity_id` int(10) unsigned NOT NULL DEFAULT '0',
  `website_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `customer_group_id` smallint(5) unsigned NOT NULL,
  `value` decimal(12,4) NOT NULL DEFAULT '0.0000',
  KEY `FK_CATALOG_PRODUCT_ENTITY_WEEE_DISCOUNT_WEBSITE` (`website_id`),
  KEY `FK_CATALOG_PRODUCT_ENTITY_WEEE_DISCOUNT_PRODUCT_ENTITY` (`entity_id`),
  KEY `FK_CATALOG_PRODUCT_ENTITY_WEEE_DISCOUNT_GROUP` (`customer_group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `weee_tax`
--

CREATE TABLE IF NOT EXISTS `weee_tax` (
  `value_id` int(11) NOT NULL AUTO_INCREMENT,
  `website_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `entity_id` int(10) unsigned NOT NULL DEFAULT '0',
  `country` varchar(2) NOT NULL DEFAULT '',
  `value` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `state` varchar(255) NOT NULL DEFAULT '*',
  `attribute_id` smallint(5) unsigned NOT NULL,
  `entity_type_id` smallint(5) unsigned NOT NULL,
  PRIMARY KEY (`value_id`),
  KEY `FK_CATALOG_PRODUCT_ENTITY_WEEE_TAX_WEBSITE` (`website_id`),
  KEY `FK_CATALOG_PRODUCT_ENTITY_WEEE_TAX_PRODUCT_ENTITY` (`entity_id`),
  KEY `FK_CATALOG_PRODUCT_ENTITY_WEEE_TAX_COUNTRY` (`country`),
  KEY `FK_WEEE_TAX_ATTRIBUTE_ID` (`attribute_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Table structure for table `wishlist`
--

CREATE TABLE IF NOT EXISTS `wishlist` (
  `wishlist_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `customer_id` int(10) unsigned NOT NULL DEFAULT '0',
  `shared` tinyint(1) unsigned DEFAULT '0',
  `sharing_code` varchar(32) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`wishlist_id`),
  UNIQUE KEY `FK_CUSTOMER` (`customer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='Wishlist main' AUTO_INCREMENT=1 ;

--
-- Table structure for table `wishlist_item`
--

CREATE TABLE IF NOT EXISTS `wishlist_item` (
  `wishlist_item_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `wishlist_id` int(10) unsigned NOT NULL DEFAULT '0',
  `product_id` int(10) unsigned NOT NULL DEFAULT '0',
  `store_id` smallint(5) unsigned NOT NULL,
  `added_at` datetime DEFAULT NULL,
  `description` text,
  PRIMARY KEY (`wishlist_item_id`),
  KEY `FK_ITEM_WISHLIST` (`wishlist_id`),
  KEY `FK_WISHLIST_PRODUCT` (`product_id`),
  KEY `FK_WISHLIST_STORE` (`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Wishlist items' AUTO_INCREMENT=1 ;

--
-- Constraints for table `admin_rule`
--
ALTER TABLE `admin_rule`
  ADD CONSTRAINT `FK_admin_rule` FOREIGN KEY (`role_id`) REFERENCES `admin_role` (`role_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `api_rule`
--
ALTER TABLE `api_rule`
  ADD CONSTRAINT `FK_api_rule` FOREIGN KEY (`role_id`) REFERENCES `api_role` (`role_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `api_session`
--
ALTER TABLE `api_session`
  ADD CONSTRAINT `FK_API_SESSION_USER` FOREIGN KEY (`user_id`) REFERENCES `api_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `catalogindex_aggregation`
--
ALTER TABLE `catalogindex_aggregation`
  ADD CONSTRAINT `FK_CATALOGINDEX_AGGREGATION_STORE` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `catalogindex_aggregation_to_tag`
--
ALTER TABLE `catalogindex_aggregation_to_tag`
  ADD CONSTRAINT `FK_CATALOGINDEX_AGGREGATION_TO_TAG_AGGREGATION` FOREIGN KEY (`aggregation_id`) REFERENCES `catalogindex_aggregation` (`aggregation_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CATALOGINDEX_AGGREGATION_TO_TAG_TAG` FOREIGN KEY (`tag_id`) REFERENCES `catalogindex_aggregation_tag` (`tag_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `catalogindex_eav`
--
ALTER TABLE `catalogindex_eav`
  ADD CONSTRAINT `FK_CATALOGINDEX_EAV_ATTRIBUTE` FOREIGN KEY (`attribute_id`) REFERENCES `eav_attribute` (`attribute_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CATALOGINDEX_EAV_ENTITY` FOREIGN KEY (`entity_id`) REFERENCES `catalog_product_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CATALOGINDEX_EAV_STORE` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `catalogindex_minimal_price`
--
ALTER TABLE `catalogindex_minimal_price`
  ADD CONSTRAINT `FK_CATALOGINDEX_MINIMAL_PRICE_CUSTOMER_GROUP` FOREIGN KEY (`customer_group_id`) REFERENCES `customer_group` (`customer_group_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CATALOGINDEX_MINIMAL_PRICE_ENTITY` FOREIGN KEY (`entity_id`) REFERENCES `catalog_product_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CI_MINIMAL_PRICE_WEBSITE_ID` FOREIGN KEY (`website_id`) REFERENCES `core_website` (`website_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `catalogindex_price`
--
ALTER TABLE `catalogindex_price`
  ADD CONSTRAINT `FK_CATALOGINDEX_PRICE_ATTRIBUTE` FOREIGN KEY (`attribute_id`) REFERENCES `eav_attribute` (`attribute_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CATALOGINDEX_PRICE_ENTITY` FOREIGN KEY (`entity_id`) REFERENCES `catalog_product_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CI_PRICE_WEBSITE_ID` FOREIGN KEY (`website_id`) REFERENCES `core_website` (`website_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `cataloginventory_stock_item`
--
ALTER TABLE `cataloginventory_stock_item`
  ADD CONSTRAINT `FK_CATALOGINVENTORY_STOCK_ITEM_PRODUCT` FOREIGN KEY (`product_id`) REFERENCES `catalog_product_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CATALOGINVENTORY_STOCK_ITEM_STOCK` FOREIGN KEY (`stock_id`) REFERENCES `cataloginventory_stock` (`stock_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `cataloginventory_stock_status`
--
ALTER TABLE `cataloginventory_stock_status`
  ADD CONSTRAINT `FK_CATALOGINVENTORY_STOCK_STATUS_STOCK` FOREIGN KEY (`stock_id`) REFERENCES `cataloginventory_stock` (`stock_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CATALOGINVENTORY_STOCK_STATUS_PRODUCT` FOREIGN KEY (`product_id`) REFERENCES `catalog_product_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CATALOGINVENTORY_STOCK_STATUS_WEBSITE` FOREIGN KEY (`website_id`) REFERENCES `core_website` (`website_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `catalogrule_product`
--
ALTER TABLE `catalogrule_product`
  ADD CONSTRAINT `FK_CATALOGRULE_PRODUCT_PRODUCT` FOREIGN KEY (`product_id`) REFERENCES `catalog_product_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_catalogrule_product_customergroup` FOREIGN KEY (`customer_group_id`) REFERENCES `customer_group` (`customer_group_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_catalogrule_product_rule` FOREIGN KEY (`rule_id`) REFERENCES `catalogrule` (`rule_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_catalogrule_product_website` FOREIGN KEY (`website_id`) REFERENCES `core_website` (`website_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `catalogrule_product_price`
--
ALTER TABLE `catalogrule_product_price`
  ADD CONSTRAINT `FK_CATALOGRULE_PRODUCT_PRICE_PRODUCT` FOREIGN KEY (`product_id`) REFERENCES `catalog_product_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_catalogrule_product_price_customergroup` FOREIGN KEY (`customer_group_id`) REFERENCES `customer_group` (`customer_group_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_catalogrule_product_price_website` FOREIGN KEY (`website_id`) REFERENCES `core_website` (`website_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `catalogsearch_query`
--
ALTER TABLE `catalogsearch_query`
  ADD CONSTRAINT `FK_CATALOGSEARCH_QUERY_STORE` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `catalogsearch_result`
--
ALTER TABLE `catalogsearch_result`
  ADD CONSTRAINT `FK_CATALOGSEARCH_RESULT_QUERY` FOREIGN KEY (`query_id`) REFERENCES `catalogsearch_query` (`query_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CATALOGSEARCH_RESULT_CATALOG_PRODUCT` FOREIGN KEY (`product_id`) REFERENCES `catalog_product_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `catalog_category_entity_datetime`
--
ALTER TABLE `catalog_category_entity_datetime`
  ADD CONSTRAINT `FK_CATALOG_CATEGORY_ENTITY_DATETIME_ATTRIBUTE` FOREIGN KEY (`attribute_id`) REFERENCES `eav_attribute` (`attribute_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CATALOG_CATEGORY_ENTITY_DATETIME_ENTITY` FOREIGN KEY (`entity_id`) REFERENCES `catalog_category_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CATALOG_CATEGORY_ENTITY_DATETIME_STORE` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `catalog_category_entity_decimal`
--
ALTER TABLE `catalog_category_entity_decimal`
  ADD CONSTRAINT `FK_CATALOG_CATEGORY_ENTITY_DECIMAL_ATTRIBUTE` FOREIGN KEY (`attribute_id`) REFERENCES `eav_attribute` (`attribute_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CATALOG_CATEGORY_ENTITY_DECIMAL_ENTITY` FOREIGN KEY (`entity_id`) REFERENCES `catalog_category_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CATALOG_CATEGORY_ENTITY_DECIMAL_STORE` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `catalog_category_entity_int`
--
ALTER TABLE `catalog_category_entity_int`
  ADD CONSTRAINT `FK_CATALOG_CATEGORY_EMTITY_INT_ATTRIBUTE` FOREIGN KEY (`attribute_id`) REFERENCES `eav_attribute` (`attribute_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CATALOG_CATEGORY_EMTITY_INT_ENTITY` FOREIGN KEY (`entity_id`) REFERENCES `catalog_category_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CATALOG_CATEGORY_EMTITY_INT_STORE` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `catalog_category_entity_text`
--
ALTER TABLE `catalog_category_entity_text`
  ADD CONSTRAINT `FK_CATALOG_CATEGORY_ENTITY_TEXT_ATTRIBUTE` FOREIGN KEY (`attribute_id`) REFERENCES `eav_attribute` (`attribute_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CATALOG_CATEGORY_ENTITY_TEXT_ENTITY` FOREIGN KEY (`entity_id`) REFERENCES `catalog_category_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CATALOG_CATEGORY_ENTITY_TEXT_STORE` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `catalog_category_entity_varchar`
--
ALTER TABLE `catalog_category_entity_varchar`
  ADD CONSTRAINT `FK_CATALOG_CATEGORY_ENTITY_VARCHAR_ATTRIBUTE` FOREIGN KEY (`attribute_id`) REFERENCES `eav_attribute` (`attribute_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CATALOG_CATEGORY_ENTITY_VARCHAR_ENTITY` FOREIGN KEY (`entity_id`) REFERENCES `catalog_category_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CATALOG_CATEGORY_ENTITY_VARCHAR_STORE` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `catalog_category_flat`
--
ALTER TABLE `catalog_category_flat`
  ADD CONSTRAINT `FK_CATEGORY_FLAT_CATEGORY_ID` FOREIGN KEY (`entity_id`) REFERENCES `catalog_category_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CATEGORY_FLAT_STORE_ID` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `catalog_category_product`
--
ALTER TABLE `catalog_category_product`
  ADD CONSTRAINT `CATALOG_CATEGORY_PRODUCT_CATEGORY` FOREIGN KEY (`category_id`) REFERENCES `catalog_category_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `CATALOG_CATEGORY_PRODUCT_PRODUCT` FOREIGN KEY (`product_id`) REFERENCES `catalog_product_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `catalog_category_product_index`
--
ALTER TABLE `catalog_category_product_index`
  ADD CONSTRAINT `FK_CATALOG_CATEGORY_PRODUCT_INDEX_CATEGORY_ENTITY` FOREIGN KEY (`category_id`) REFERENCES `catalog_category_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CATALOG_CATEGORY_PRODUCT_INDEX_PRODUCT_ENTITY` FOREIGN KEY (`product_id`) REFERENCES `catalog_product_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CATEGORY_PRODUCT_INDEX_STORE` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `catalog_compare_item`
--
ALTER TABLE `catalog_compare_item`
  ADD CONSTRAINT `FK_CATALOG_COMPARE_ITEM_CUSTOMER` FOREIGN KEY (`customer_id`) REFERENCES `customer_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CATALOG_COMPARE_ITEM_PRODUCT` FOREIGN KEY (`product_id`) REFERENCES `catalog_product_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `catalog_product_bundle_option`
--
ALTER TABLE `catalog_product_bundle_option`
  ADD CONSTRAINT `FK_CATALOG_PRODUCT_BUNDLE_OPTION_PARENT` FOREIGN KEY (`parent_id`) REFERENCES `catalog_product_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `catalog_product_bundle_option_value`
--
ALTER TABLE `catalog_product_bundle_option_value`
  ADD CONSTRAINT `FK_CATALOG_PRODUCT_BUNDLE_OPTION_VALUE_OPTION` FOREIGN KEY (`option_id`) REFERENCES `catalog_product_bundle_option` (`option_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `catalog_product_bundle_price_index`
--
ALTER TABLE `catalog_product_bundle_price_index`
  ADD CONSTRAINT `CATALOG_PRODUCT_BUNDLE_PRICE_INDEX_CUSTOMER_GROUP` FOREIGN KEY (`customer_group_id`) REFERENCES `customer_group` (`customer_group_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `CATALOG_PRODUCT_BUNDLE_PRICE_INDEX_PRODUCT_ENTITY` FOREIGN KEY (`entity_id`) REFERENCES `catalog_product_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `CATALOG_PRODUCT_BUNDLE_PRICE_INDEX_WEBSITE` FOREIGN KEY (`website_id`) REFERENCES `core_website` (`website_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `catalog_product_bundle_selection`
--
ALTER TABLE `catalog_product_bundle_selection`
  ADD CONSTRAINT `FK_CATALOG_PRODUCT_BUNDLE_SELECTION_OPTION` FOREIGN KEY (`option_id`) REFERENCES `catalog_product_bundle_option` (`option_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CATALOG_PRODUCT_BUNDLE_SELECTION_PRODUCT` FOREIGN KEY (`product_id`) REFERENCES `catalog_product_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `catalog_product_enabled_index`
--
ALTER TABLE `catalog_product_enabled_index`
  ADD CONSTRAINT `FK_CATALOG_PRODUCT_ENABLED_INDEX_PRODUCT_ENTITY` FOREIGN KEY (`product_id`) REFERENCES `catalog_product_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CATALOG_PRODUCT_ENABLED_INDEX_STORE` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `catalog_product_entity`
--
ALTER TABLE `catalog_product_entity`
  ADD CONSTRAINT `FK_CATALOG_PRODUCT_ENTITY_ATTRIBUTE_SET_ID` FOREIGN KEY (`attribute_set_id`) REFERENCES `eav_attribute_set` (`attribute_set_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CATALOG_PRODUCT_ENTITY_ENTITY_TYPE` FOREIGN KEY (`entity_type_id`) REFERENCES `eav_entity_type` (`entity_type_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `catalog_product_entity_datetime`
--
ALTER TABLE `catalog_product_entity_datetime`
  ADD CONSTRAINT `FK_CATALOG_PRODUCT_ENTITY_DATETIME_ATTRIBUTE` FOREIGN KEY (`attribute_id`) REFERENCES `eav_attribute` (`attribute_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CATALOG_PRODUCT_ENTITY_DATETIME_PRODUCT_ENTITY` FOREIGN KEY (`entity_id`) REFERENCES `catalog_product_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CATALOG_PRODUCT_ENTITY_DATETIME_STORE` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `catalog_product_entity_decimal`
--
ALTER TABLE `catalog_product_entity_decimal`
  ADD CONSTRAINT `FK_CATALOG_PRODUCT_ENTITY_DECIMAL_ATTRIBUTE` FOREIGN KEY (`attribute_id`) REFERENCES `eav_attribute` (`attribute_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CATALOG_PRODUCT_ENTITY_DECIMAL_PRODUCT_ENTITY` FOREIGN KEY (`entity_id`) REFERENCES `catalog_product_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CATALOG_PRODUCT_ENTITY_DECIMAL_STORE` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `catalog_product_entity_gallery`
--
ALTER TABLE `catalog_product_entity_gallery`
  ADD CONSTRAINT `FK_CATALOG_PRODUCT_ENTITY_GALLERY_ATTRIBUTE` FOREIGN KEY (`attribute_id`) REFERENCES `eav_attribute` (`attribute_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CATALOG_PRODUCT_ENTITY_GALLERY_ENTITY` FOREIGN KEY (`entity_id`) REFERENCES `catalog_product_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CATALOG_PRODUCT_ENTITY_GALLERY_STORE` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `catalog_product_entity_int`
--
ALTER TABLE `catalog_product_entity_int`
  ADD CONSTRAINT `FK_CATALOG_PRODUCT_ENTITY_INT_ATTRIBUTE` FOREIGN KEY (`attribute_id`) REFERENCES `eav_attribute` (`attribute_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CATALOG_PRODUCT_ENTITY_INT_PRODUCT_ENTITY` FOREIGN KEY (`entity_id`) REFERENCES `catalog_product_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CATALOG_PRODUCT_ENTITY_INT_STORE` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `catalog_product_entity_media_gallery`
--
ALTER TABLE `catalog_product_entity_media_gallery`
  ADD CONSTRAINT `FK_CATALOG_PRODUCT_MEDIA_GALLERY_ATTRIBUTE` FOREIGN KEY (`attribute_id`) REFERENCES `eav_attribute` (`attribute_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `FK_CATALOG_PRODUCT_MEDIA_GALLERY_ENTITY` FOREIGN KEY (`entity_id`) REFERENCES `catalog_product_entity` (`entity_id`) ON DELETE CASCADE;

--
-- Constraints for table `catalog_product_entity_media_gallery_value`
--
ALTER TABLE `catalog_product_entity_media_gallery_value`
  ADD CONSTRAINT `FK_CATALOG_PRODUCT_MEDIA_GALLERY_VALUE_GALLERY` FOREIGN KEY (`value_id`) REFERENCES `catalog_product_entity_media_gallery` (`value_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `FK_CATALOG_PRODUCT_MEDIA_GALLERY_VALUE_STORE` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE CASCADE;

--
-- Constraints for table `catalog_product_entity_text`
--
ALTER TABLE `catalog_product_entity_text`
  ADD CONSTRAINT `FK_CATALOG_PRODUCT_ENTITY_TEXT_ATTRIBUTE` FOREIGN KEY (`attribute_id`) REFERENCES `eav_attribute` (`attribute_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CATALOG_PRODUCT_ENTITY_TEXT_PRODUCT_ENTITY` FOREIGN KEY (`entity_id`) REFERENCES `catalog_product_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CATALOG_PRODUCT_ENTITY_TEXT_STORE` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `catalog_product_entity_tier_price`
--
ALTER TABLE `catalog_product_entity_tier_price`
  ADD CONSTRAINT `FK_CATALOG_PRODUCT_TIER_WEBSITE` FOREIGN KEY (`website_id`) REFERENCES `core_website` (`website_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CATALOG_PRODUCT_ENTITY_TIER_PRICE_GROUP` FOREIGN KEY (`customer_group_id`) REFERENCES `customer_group` (`customer_group_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CATALOG_PRODUCT_ENTITY_TIER_PRICE_PRODUCT_ENTITY` FOREIGN KEY (`entity_id`) REFERENCES `catalog_product_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `catalog_product_entity_varchar`
--
ALTER TABLE `catalog_product_entity_varchar`
  ADD CONSTRAINT `FK_CATALOG_PRODUCT_ENTITY_VARCHAR_ATTRIBUTE` FOREIGN KEY (`attribute_id`) REFERENCES `eav_attribute` (`attribute_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CATALOG_PRODUCT_ENTITY_VARCHAR_PRODUCT_ENTITY` FOREIGN KEY (`entity_id`) REFERENCES `catalog_product_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CATALOG_PRODUCT_ENTITY_VARCHAR_STORE` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `catalog_product_link`
--
ALTER TABLE `catalog_product_link`
  ADD CONSTRAINT `FK_PRODUCT_LINK_LINKED_PRODUCT` FOREIGN KEY (`linked_product_id`) REFERENCES `catalog_product_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_PRODUCT_LINK_PRODUCT` FOREIGN KEY (`product_id`) REFERENCES `catalog_product_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_PRODUCT_LINK_TYPE` FOREIGN KEY (`link_type_id`) REFERENCES `catalog_product_link_type` (`link_type_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `catalog_product_link_attribute`
--
ALTER TABLE `catalog_product_link_attribute`
  ADD CONSTRAINT `FK_ATTRIBUTE_PRODUCT_LINK_TYPE` FOREIGN KEY (`link_type_id`) REFERENCES `catalog_product_link_type` (`link_type_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `catalog_product_link_attribute_decimal`
--
ALTER TABLE `catalog_product_link_attribute_decimal`
  ADD CONSTRAINT `FK_DECIMAL_LINK` FOREIGN KEY (`link_id`) REFERENCES `catalog_product_link` (`link_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_DECIMAL_PRODUCT_LINK_ATTRIBUTE` FOREIGN KEY (`product_link_attribute_id`) REFERENCES `catalog_product_link_attribute` (`product_link_attribute_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `catalog_product_link_attribute_int`
--
ALTER TABLE `catalog_product_link_attribute_int`
  ADD CONSTRAINT `FK_INT_PRODUCT_LINK` FOREIGN KEY (`link_id`) REFERENCES `catalog_product_link` (`link_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `FK_INT_PRODUCT_LINK_ATTRIBUTE` FOREIGN KEY (`product_link_attribute_id`) REFERENCES `catalog_product_link_attribute` (`product_link_attribute_id`) ON DELETE CASCADE;

--
-- Constraints for table `catalog_product_link_attribute_varchar`
--
ALTER TABLE `catalog_product_link_attribute_varchar`
  ADD CONSTRAINT `FK_VARCHAR_LINK` FOREIGN KEY (`link_id`) REFERENCES `catalog_product_link` (`link_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_VARCHAR_PRODUCT_LINK_ATTRIBUTE` FOREIGN KEY (`product_link_attribute_id`) REFERENCES `catalog_product_link_attribute` (`product_link_attribute_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `catalog_product_option`
--
ALTER TABLE `catalog_product_option`
  ADD CONSTRAINT `FK_CATALOG_PRODUCT_OPTION_PRODUCT` FOREIGN KEY (`product_id`) REFERENCES `catalog_product_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `catalog_product_option_price`
--
ALTER TABLE `catalog_product_option_price`
  ADD CONSTRAINT `FK_CATALOG_PRODUCT_OPTION_PRICE_OPTION` FOREIGN KEY (`option_id`) REFERENCES `catalog_product_option` (`option_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CATALOG_PRODUCT_OPTION_PRICE_STORE` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `catalog_product_option_title`
--
ALTER TABLE `catalog_product_option_title`
  ADD CONSTRAINT `FK_CATALOG_PRODUCT_OPTION_TITLE_OPTION` FOREIGN KEY (`option_id`) REFERENCES `catalog_product_option` (`option_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CATALOG_PRODUCT_OPTION_TITLE_STORE` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `catalog_product_option_type_price`
--
ALTER TABLE `catalog_product_option_type_price`
  ADD CONSTRAINT `FK_CATALOG_PRODUCT_OPTION_TYPE_PRICE_OPTION` FOREIGN KEY (`option_type_id`) REFERENCES `catalog_product_option_type_value` (`option_type_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CATALOG_PRODUCT_OPTION_TYPE_PRICE_STORE` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `catalog_product_option_type_title`
--
ALTER TABLE `catalog_product_option_type_title`
  ADD CONSTRAINT `FK_CATALOG_PRODUCT_OPTION_TYPE_TITLE_OPTION` FOREIGN KEY (`option_type_id`) REFERENCES `catalog_product_option_type_value` (`option_type_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CATALOG_PRODUCT_OPTION_TYPE_TITLE_STORE` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `catalog_product_option_type_value`
--
ALTER TABLE `catalog_product_option_type_value`
  ADD CONSTRAINT `FK_CATALOG_PRODUCT_OPTION_TYPE_VALUE_OPTION` FOREIGN KEY (`option_id`) REFERENCES `catalog_product_option` (`option_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `catalog_product_super_attribute`
--
ALTER TABLE `catalog_product_super_attribute`
  ADD CONSTRAINT `FK_SUPER_PRODUCT_ATTRIBUTE_PRODUCT` FOREIGN KEY (`product_id`) REFERENCES `catalog_product_entity` (`entity_id`) ON DELETE CASCADE;

--
-- Constraints for table `catalog_product_super_attribute_label`
--
ALTER TABLE `catalog_product_super_attribute_label`
  ADD CONSTRAINT `FK_SUPER_PRODUCT_ATTRIBUTE_LABEL` FOREIGN KEY (`product_super_attribute_id`) REFERENCES `catalog_product_super_attribute` (`product_super_attribute_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `catalog_product_super_attribute_pricing`
--
ALTER TABLE `catalog_product_super_attribute_pricing`
  ADD CONSTRAINT `FK_SUPER_PRODUCT_ATTRIBUTE_PRICING` FOREIGN KEY (`product_super_attribute_id`) REFERENCES `catalog_product_super_attribute` (`product_super_attribute_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CATALOG_PRODUCT_SUPER_PRICE_WEBSITE` FOREIGN KEY (`website_id`) REFERENCES `core_website` (`website_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `catalog_product_super_link`
--
ALTER TABLE `catalog_product_super_link`
  ADD CONSTRAINT `FK_SUPER_PRODUCT_LINK_PARENT` FOREIGN KEY (`parent_id`) REFERENCES `catalog_product_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_SUPER_PRODUCT_LINK_ENTITY` FOREIGN KEY (`product_id`) REFERENCES `catalog_product_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `catalog_product_website`
--
ALTER TABLE `catalog_product_website`
  ADD CONSTRAINT `FK_CATALOG_WEBSITE_PRODUCT_PRODUCT` FOREIGN KEY (`product_id`) REFERENCES `catalog_product_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CATALOG_PRODUCT_WEBSITE_WEBSITE` FOREIGN KEY (`website_id`) REFERENCES `core_website` (`website_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `checkout_agreement_store`
--
ALTER TABLE `checkout_agreement_store`
  ADD CONSTRAINT `FK_CHECKOUT_AGREEMENT` FOREIGN KEY (`agreement_id`) REFERENCES `checkout_agreement` (`agreement_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CHECKOUT_AGREEMENT_STORE` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `cms_block_store`
--
ALTER TABLE `cms_block_store`
  ADD CONSTRAINT `FK_CMS_BLOCK_STORE_BLOCK` FOREIGN KEY (`block_id`) REFERENCES `cms_block` (`block_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CMS_BLOCK_STORE_STORE` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `cms_page_store`
--
ALTER TABLE `cms_page_store`
  ADD CONSTRAINT `FK_CMS_PAGE_STORE_PAGE` FOREIGN KEY (`page_id`) REFERENCES `cms_page` (`page_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CMS_PAGE_STORE_STORE` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `core_layout_link`
--
ALTER TABLE `core_layout_link`
  ADD CONSTRAINT `FK_CORE_LAYOUT_LINK_STORE` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CORE_LAYOUT_LINK_UPDATE` FOREIGN KEY (`layout_update_id`) REFERENCES `core_layout_update` (`layout_update_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `core_session`
--
ALTER TABLE `core_session`
  ADD CONSTRAINT `FK_SESSION_WEBSITE` FOREIGN KEY (`website_id`) REFERENCES `core_website` (`website_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `core_store`
--
ALTER TABLE `core_store`
  ADD CONSTRAINT `FK_STORE_GROUP_STORE` FOREIGN KEY (`group_id`) REFERENCES `core_store_group` (`group_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_STORE_WEBSITE` FOREIGN KEY (`website_id`) REFERENCES `core_website` (`website_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `core_store_group`
--
ALTER TABLE `core_store_group`
  ADD CONSTRAINT `FK_STORE_GROUP_WEBSITE` FOREIGN KEY (`website_id`) REFERENCES `core_website` (`website_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `core_translate`
--
ALTER TABLE `core_translate`
  ADD CONSTRAINT `FK_CORE_TRANSLATE_STORE` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `core_url_rewrite`
--
ALTER TABLE `core_url_rewrite`
  ADD CONSTRAINT `FK_CORE_URL_REWRITE_CATEGORY` FOREIGN KEY (`category_id`) REFERENCES `catalog_category_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CORE_URL_REWRITE_PRODUCT` FOREIGN KEY (`product_id`) REFERENCES `catalog_product_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CORE_URL_REWRITE_STORE` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `customer_address_entity`
--
ALTER TABLE `customer_address_entity`
  ADD CONSTRAINT `FK_CUSTOMER_ADDRESS_CUSTOMER_ID` FOREIGN KEY (`parent_id`) REFERENCES `customer_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `customer_address_entity_datetime`
--
ALTER TABLE `customer_address_entity_datetime`
  ADD CONSTRAINT `FK_CUSTOMER_ADDRESS_DATETIME_ATTRIBUTE` FOREIGN KEY (`attribute_id`) REFERENCES `eav_attribute` (`attribute_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CUSTOMER_ADDRESS_DATETIME_ENTITY` FOREIGN KEY (`entity_id`) REFERENCES `customer_address_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CUSTOMER_ADDRESS_DATETIME_ENTITY_TYPE` FOREIGN KEY (`entity_type_id`) REFERENCES `eav_entity_type` (`entity_type_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `customer_address_entity_decimal`
--
ALTER TABLE `customer_address_entity_decimal`
  ADD CONSTRAINT `FK_CUSTOMER_ADDRESS_DECIMAL_ATTRIBUTE` FOREIGN KEY (`attribute_id`) REFERENCES `eav_attribute` (`attribute_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CUSTOMER_ADDRESS_DECIMAL_ENTITY` FOREIGN KEY (`entity_id`) REFERENCES `customer_address_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CUSTOMER_ADDRESS_DECIMAL_ENTITY_TYPE` FOREIGN KEY (`entity_type_id`) REFERENCES `eav_entity_type` (`entity_type_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `customer_address_entity_int`
--
ALTER TABLE `customer_address_entity_int`
  ADD CONSTRAINT `FK_CUSTOMER_ADDRESS_INT_ATTRIBUTE` FOREIGN KEY (`attribute_id`) REFERENCES `eav_attribute` (`attribute_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CUSTOMER_ADDRESS_INT_ENTITY` FOREIGN KEY (`entity_id`) REFERENCES `customer_address_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CUSTOMER_ADDRESS_INT_ENTITY_TYPE` FOREIGN KEY (`entity_type_id`) REFERENCES `eav_entity_type` (`entity_type_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `customer_address_entity_text`
--
ALTER TABLE `customer_address_entity_text`
  ADD CONSTRAINT `FK_CUSTOMER_ADDRESS_TEXT_ATTRIBUTE` FOREIGN KEY (`attribute_id`) REFERENCES `eav_attribute` (`attribute_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CUSTOMER_ADDRESS_TEXT_ENTITY` FOREIGN KEY (`entity_id`) REFERENCES `customer_address_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CUSTOMER_ADDRESS_TEXT_ENTITY_TYPE` FOREIGN KEY (`entity_type_id`) REFERENCES `eav_entity_type` (`entity_type_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `customer_address_entity_varchar`
--
ALTER TABLE `customer_address_entity_varchar`
  ADD CONSTRAINT `FK_CUSTOMER_ADDRESS_VARCHAR_ATTRIBUTE` FOREIGN KEY (`attribute_id`) REFERENCES `eav_attribute` (`attribute_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CUSTOMER_ADDRESS_VARCHAR_ENTITY` FOREIGN KEY (`entity_id`) REFERENCES `customer_address_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CUSTOMER_ADDRESS_VARCHAR_ENTITY_TYPE` FOREIGN KEY (`entity_type_id`) REFERENCES `eav_entity_type` (`entity_type_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `customer_entity`
--
ALTER TABLE `customer_entity`
  ADD CONSTRAINT `FK_CUSTOMER_ENTITY_STORE` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CUSTOMER_WEBSITE` FOREIGN KEY (`website_id`) REFERENCES `core_website` (`website_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `customer_entity_datetime`
--
ALTER TABLE `customer_entity_datetime`
  ADD CONSTRAINT `FK_CUSTOMER_DATETIME_ATTRIBUTE` FOREIGN KEY (`attribute_id`) REFERENCES `eav_attribute` (`attribute_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CUSTOMER_DATETIME_ENTITY` FOREIGN KEY (`entity_id`) REFERENCES `customer_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CUSTOMER_DATETIME_ENTITY_TYPE` FOREIGN KEY (`entity_type_id`) REFERENCES `eav_entity_type` (`entity_type_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `customer_entity_decimal`
--
ALTER TABLE `customer_entity_decimal`
  ADD CONSTRAINT `FK_CUSTOMER_DECIMAL_ATTRIBUTE` FOREIGN KEY (`attribute_id`) REFERENCES `eav_attribute` (`attribute_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CUSTOMER_DECIMAL_ENTITY` FOREIGN KEY (`entity_id`) REFERENCES `customer_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CUSTOMER_DECIMAL_ENTITY_TYPE` FOREIGN KEY (`entity_type_id`) REFERENCES `eav_entity_type` (`entity_type_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `customer_entity_int`
--
ALTER TABLE `customer_entity_int`
  ADD CONSTRAINT `FK_CUSTOMER_INT_ATTRIBUTE` FOREIGN KEY (`attribute_id`) REFERENCES `eav_attribute` (`attribute_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CUSTOMER_INT_ENTITY` FOREIGN KEY (`entity_id`) REFERENCES `customer_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CUSTOMER_INT_ENTITY_TYPE` FOREIGN KEY (`entity_type_id`) REFERENCES `eav_entity_type` (`entity_type_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `customer_entity_text`
--
ALTER TABLE `customer_entity_text`
  ADD CONSTRAINT `FK_CUSTOMER_TEXT_ATTRIBUTE` FOREIGN KEY (`attribute_id`) REFERENCES `eav_attribute` (`attribute_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CUSTOMER_TEXT_ENTITY` FOREIGN KEY (`entity_id`) REFERENCES `customer_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CUSTOMER_TEXT_ENTITY_TYPE` FOREIGN KEY (`entity_type_id`) REFERENCES `eav_entity_type` (`entity_type_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `customer_entity_varchar`
--
ALTER TABLE `customer_entity_varchar`
  ADD CONSTRAINT `FK_CUSTOMER_VARCHAR_ATTRIBUTE` FOREIGN KEY (`attribute_id`) REFERENCES `eav_attribute` (`attribute_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CUSTOMER_VARCHAR_ENTITY` FOREIGN KEY (`entity_id`) REFERENCES `customer_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CUSTOMER_VARCHAR_ENTITY_TYPE` FOREIGN KEY (`entity_type_id`) REFERENCES `eav_entity_type` (`entity_type_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `dataflow_batch`
--
ALTER TABLE `dataflow_batch`
  ADD CONSTRAINT `FK_DATAFLOW_BATCH_PROFILE` FOREIGN KEY (`profile_id`) REFERENCES `dataflow_profile` (`profile_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `FK_DATAFLOW_BATCH_STORE` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE CASCADE;

--
-- Constraints for table `dataflow_batch_export`
--
ALTER TABLE `dataflow_batch_export`
  ADD CONSTRAINT `FK_DATAFLOW_BATCH_EXPORT_BATCH` FOREIGN KEY (`batch_id`) REFERENCES `dataflow_batch` (`batch_id`) ON DELETE CASCADE;

--
-- Constraints for table `dataflow_batch_import`
--
ALTER TABLE `dataflow_batch_import`
  ADD CONSTRAINT `FK_DATAFLOW_BATCH_IMPORT_BATCH` FOREIGN KEY (`batch_id`) REFERENCES `dataflow_batch` (`batch_id`) ON DELETE CASCADE;

--
-- Constraints for table `dataflow_import_data`
--
ALTER TABLE `dataflow_import_data`
  ADD CONSTRAINT `FK_dataflow_import_data` FOREIGN KEY (`session_id`) REFERENCES `dataflow_session` (`session_id`);

--
-- Constraints for table `dataflow_profile_history`
--
ALTER TABLE `dataflow_profile_history`
  ADD CONSTRAINT `FK_dataflow_profile_history` FOREIGN KEY (`profile_id`) REFERENCES `dataflow_profile` (`profile_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `design_change`
--
ALTER TABLE `design_change`
  ADD CONSTRAINT `FK_DESIGN_CHANGE_STORE` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `directory_country_region_name`
--
ALTER TABLE `directory_country_region_name`
  ADD CONSTRAINT `FK_DIRECTORY_REGION_NAME_REGION` FOREIGN KEY (`region_id`) REFERENCES `directory_country_region` (`region_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `downloadable_link`
--
ALTER TABLE `downloadable_link`
  ADD CONSTRAINT `FK_DOWNLODABLE_LINK_PRODUCT` FOREIGN KEY (`product_id`) REFERENCES `catalog_product_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `downloadable_link_price`
--
ALTER TABLE `downloadable_link_price`
  ADD CONSTRAINT `FK_DOWNLOADABLE_LINK_PRICE_WEBSITE` FOREIGN KEY (`website_id`) REFERENCES `core_website` (`website_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_DOWNLOADABLE_LINK_PRICE_LINK` FOREIGN KEY (`link_id`) REFERENCES `downloadable_link` (`link_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `downloadable_link_purchased`
--
ALTER TABLE `downloadable_link_purchased`
  ADD CONSTRAINT `FK_DOWNLOADABLE_PURCHASED_ORDER_ITEM_ID` FOREIGN KEY (`order_item_id`) REFERENCES `sales_flat_order_item` (`item_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_DOWNLOADABLE_ORDER_ID` FOREIGN KEY (`order_id`) REFERENCES `sales_order` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `downloadable_link_purchased_item`
--
ALTER TABLE `downloadable_link_purchased_item`
  ADD CONSTRAINT `FK_DOWNLOADABLE_LINK_PURCHASED_ID` FOREIGN KEY (`purchased_id`) REFERENCES `downloadable_link_purchased` (`purchased_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_DOWNLOADABLE_ORDER_ITEM_ID` FOREIGN KEY (`order_item_id`) REFERENCES `sales_flat_order_item` (`item_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `downloadable_link_title`
--
ALTER TABLE `downloadable_link_title`
  ADD CONSTRAINT `FK_DOWNLOADABLE_LINK_TITLE_STORE` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_DOWNLOADABLE_LINK_TITLE_LINK` FOREIGN KEY (`link_id`) REFERENCES `downloadable_link` (`link_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `downloadable_sample`
--
ALTER TABLE `downloadable_sample`
  ADD CONSTRAINT `FK_DOWNLODABLE_SAMPLE_PRODUCT` FOREIGN KEY (`product_id`) REFERENCES `catalog_product_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `downloadable_sample_title`
--
ALTER TABLE `downloadable_sample_title`
  ADD CONSTRAINT `FK_DOWNLOADABLE_SAMPLE_TITLE_STORE` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_DOWNLOADABLE_SAMPLE_TITLE_SAMPLE` FOREIGN KEY (`sample_id`) REFERENCES `downloadable_sample` (`sample_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `eav_attribute`
--
ALTER TABLE `eav_attribute`
  ADD CONSTRAINT `FK_eav_attribute` FOREIGN KEY (`entity_type_id`) REFERENCES `eav_entity_type` (`entity_type_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `eav_attribute_group`
--
ALTER TABLE `eav_attribute_group`
  ADD CONSTRAINT `FK_eav_attribute_group` FOREIGN KEY (`attribute_set_id`) REFERENCES `eav_attribute_set` (`attribute_set_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `eav_attribute_option`
--
ALTER TABLE `eav_attribute_option`
  ADD CONSTRAINT `FK_ATTRIBUTE_OPTION_ATTRIBUTE` FOREIGN KEY (`attribute_id`) REFERENCES `eav_attribute` (`attribute_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `eav_attribute_option_value`
--
ALTER TABLE `eav_attribute_option_value`
  ADD CONSTRAINT `FK_ATTRIBUTE_OPTION_VALUE_OPTION` FOREIGN KEY (`option_id`) REFERENCES `eav_attribute_option` (`option_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_ATTRIBUTE_OPTION_VALUE_STORE` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `eav_attribute_set`
--
ALTER TABLE `eav_attribute_set`
  ADD CONSTRAINT `FK_eav_attribute_set` FOREIGN KEY (`entity_type_id`) REFERENCES `eav_entity_type` (`entity_type_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `eav_entity`
--
ALTER TABLE `eav_entity`
  ADD CONSTRAINT `FK_eav_entity` FOREIGN KEY (`entity_type_id`) REFERENCES `eav_entity_type` (`entity_type_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_eav_entity_store` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE;


SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ANSI';

USE `mysql` ;

DROP PROCEDURE IF EXISTS `mysql`.`drop_user_if_exists` ;
DELIMITER $$
CREATE PROCEDURE `mysql`.`drop_user_if_exists`()
BEGIN
  DECLARE foo BIGINT DEFAULT 0 ;
  SELECT COUNT(*)
  INTO foo
    FROM `mysql`.`user`
      WHERE `User` = 'ekkitabweb' ;
  
  IF foo > 0 THEN 
         DROP USER 'ekkitabweb'@'localhost' ;
  END IF;
END ;$$
DELIMITER ;

CALL `mysql`.`drop_user_if_exists`() ;

DROP PROCEDURE IF EXISTS `test`.`drop_users_if_exists` ;

/* Creating a new user */

CREATE USER 'ekkitabweb'@'localhost' IDENTIFIED BY 'eki22AbSt0re';

GRANT ALL PRIVILEGES ON *.* TO 'ekkitabweb'@'localhost' IDENTIFIED BY 'eki22AbSt0re' WITH GRANT OPTION MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 MAX_USER_CONNECTIONS 0;

SET SQL_MODE=@OLD_SQL_MODE ;
