-- MySQL dump 10.13  Distrib 5.1.33, for Win32 (ia32)
--
-- Host: localhost    Database: ekkitab_books
-- ------------------------------------------------------
-- Server version	5.1.33-community

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `admin_assert`
--

DROP TABLE IF EXISTS `admin_assert`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `admin_assert` (
  `assert_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `assert_type` varchar(20) NOT NULL DEFAULT '',
  `assert_data` text,
  PRIMARY KEY (`assert_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='ACL Asserts';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin_assert`
--

LOCK TABLES `admin_assert` WRITE;
/*!40000 ALTER TABLE `admin_assert` DISABLE KEYS */;
/*!40000 ALTER TABLE `admin_assert` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `admin_role`
--

DROP TABLE IF EXISTS `admin_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `admin_role` (
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COMMENT='ACL Roles';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin_role`
--

LOCK TABLES `admin_role` WRITE;
/*!40000 ALTER TABLE `admin_role` DISABLE KEYS */;
INSERT INTO `admin_role` VALUES (1,0,1,1,'G',0,'Administrators'),(3,1,2,0,'U',2,'Ekkitab'),(4,1,2,0,'U',3,'Ekkitab');
/*!40000 ALTER TABLE `admin_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `admin_rule`
--

DROP TABLE IF EXISTS `admin_rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `admin_rule` (
  `rule_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `role_id` int(10) unsigned NOT NULL DEFAULT '0',
  `resource_id` varchar(255) NOT NULL DEFAULT '',
  `privileges` varchar(20) NOT NULL DEFAULT '',
  `assert_id` int(10) unsigned NOT NULL DEFAULT '0',
  `role_type` char(1) DEFAULT NULL,
  `permission` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`rule_id`),
  KEY `resource` (`resource_id`,`role_id`),
  KEY `role_id` (`role_id`,`resource_id`),
  CONSTRAINT `FK_admin_rule` FOREIGN KEY (`role_id`) REFERENCES `admin_role` (`role_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='ACL Rules';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin_rule`
--

LOCK TABLES `admin_rule` WRITE;
/*!40000 ALTER TABLE `admin_rule` DISABLE KEYS */;
INSERT INTO `admin_rule` VALUES (1,1,'all','',0,'G','allow');
/*!40000 ALTER TABLE `admin_rule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `admin_user`
--

DROP TABLE IF EXISTS `admin_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `admin_user` (
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='Users';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin_user`
--

LOCK TABLES `admin_user` WRITE;
/*!40000 ALTER TABLE `admin_user` DISABLE KEYS */;
INSERT INTO `admin_user` VALUES (3,'Ekkitab','E','admin@ekkitab.com','admin','1f9cda191d7b227d2b90c0e043a55513:1p','2009-10-16 07:13:09','2009-10-16 11:06:25','2009-10-16 11:17:50',3,0,1,'N;');
/*!40000 ALTER TABLE `admin_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `adminnotification_inbox`
--

DROP TABLE IF EXISTS `adminnotification_inbox`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `adminnotification_inbox` (
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
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `adminnotification_inbox`
--

LOCK TABLES `adminnotification_inbox` WRITE;
/*!40000 ALTER TABLE `adminnotification_inbox` DISABLE KEYS */;
/*!40000 ALTER TABLE `adminnotification_inbox` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `amazonpayments_api_debug`
--

DROP TABLE IF EXISTS `amazonpayments_api_debug`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `amazonpayments_api_debug` (
  `debug_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `transaction_id` varchar(255) NOT NULL DEFAULT '',
  `debug_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `request_body` text,
  `response_body` text,
  PRIMARY KEY (`debug_id`),
  KEY `debug_at` (`debug_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `amazonpayments_api_debug`
--

LOCK TABLES `amazonpayments_api_debug` WRITE;
/*!40000 ALTER TABLE `amazonpayments_api_debug` DISABLE KEYS */;
/*!40000 ALTER TABLE `amazonpayments_api_debug` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `api_assert`
--

DROP TABLE IF EXISTS `api_assert`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `api_assert` (
  `assert_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `assert_type` varchar(20) NOT NULL DEFAULT '',
  `assert_data` text,
  PRIMARY KEY (`assert_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Api ACL Asserts';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `api_assert`
--

LOCK TABLES `api_assert` WRITE;
/*!40000 ALTER TABLE `api_assert` DISABLE KEYS */;
/*!40000 ALTER TABLE `api_assert` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `api_role`
--

DROP TABLE IF EXISTS `api_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `api_role` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Api ACL Roles';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `api_role`
--

LOCK TABLES `api_role` WRITE;
/*!40000 ALTER TABLE `api_role` DISABLE KEYS */;
/*!40000 ALTER TABLE `api_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `api_rule`
--

DROP TABLE IF EXISTS `api_rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `api_rule` (
  `rule_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `role_id` int(10) unsigned NOT NULL DEFAULT '0',
  `resource_id` varchar(255) NOT NULL DEFAULT '',
  `privileges` varchar(20) NOT NULL DEFAULT '',
  `assert_id` int(10) unsigned NOT NULL DEFAULT '0',
  `role_type` char(1) DEFAULT NULL,
  `permission` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`rule_id`),
  KEY `resource` (`resource_id`,`role_id`),
  KEY `role_id` (`role_id`,`resource_id`),
  CONSTRAINT `FK_api_rule` FOREIGN KEY (`role_id`) REFERENCES `api_role` (`role_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Api ACL Rules';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `api_rule`
--

LOCK TABLES `api_rule` WRITE;
/*!40000 ALTER TABLE `api_rule` DISABLE KEYS */;
/*!40000 ALTER TABLE `api_rule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `api_session`
--

DROP TABLE IF EXISTS `api_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `api_session` (
  `user_id` mediumint(9) unsigned NOT NULL,
  `logdate` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `sessid` varchar(40) NOT NULL DEFAULT '',
  KEY `API_SESSION_USER` (`user_id`),
  KEY `API_SESSION_SESSID` (`sessid`),
  CONSTRAINT `FK_API_SESSION_USER` FOREIGN KEY (`user_id`) REFERENCES `api_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Api Sessions';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `api_session`
--

LOCK TABLES `api_session` WRITE;
/*!40000 ALTER TABLE `api_session` DISABLE KEYS */;
/*!40000 ALTER TABLE `api_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `api_user`
--

DROP TABLE IF EXISTS `api_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `api_user` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Api Users';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `api_user`
--

LOCK TABLES `api_user` WRITE;
/*!40000 ALTER TABLE `api_user` DISABLE KEYS */;
/*!40000 ALTER TABLE `api_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalog_category_entity`
--

DROP TABLE IF EXISTS `catalog_category_entity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalog_category_entity` (
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
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8 COMMENT='Category Entities';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalog_category_entity`
--

LOCK TABLES `catalog_category_entity` WRITE;
/*!40000 ALTER TABLE `catalog_category_entity` DISABLE KEYS */;
/*!40000 ALTER TABLE `catalog_category_entity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalog_category_entity_datetime`
--

DROP TABLE IF EXISTS `catalog_category_entity_datetime`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalog_category_entity_datetime` (
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
  KEY `FK_CATALOG_CATEGORY_ENTITY_DATETIME_STORE` (`store_id`),
  CONSTRAINT `FK_CATALOG_CATEGORY_ENTITY_DATETIME_ATTRIBUTE` FOREIGN KEY (`attribute_id`) REFERENCES `eav_attribute` (`attribute_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CATALOG_CATEGORY_ENTITY_DATETIME_ENTITY` FOREIGN KEY (`entity_id`) REFERENCES `catalog_category_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CATALOG_CATEGORY_ENTITY_DATETIME_STORE` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalog_category_entity_datetime`
--

LOCK TABLES `catalog_category_entity_datetime` WRITE;
/*!40000 ALTER TABLE `catalog_category_entity_datetime` DISABLE KEYS */;
/*!40000 ALTER TABLE `catalog_category_entity_datetime` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalog_category_entity_decimal`
--

DROP TABLE IF EXISTS `catalog_category_entity_decimal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalog_category_entity_decimal` (
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
  KEY `FK_CATALOG_CATEGORY_ENTITY_DECIMAL_STORE` (`store_id`),
  CONSTRAINT `FK_CATALOG_CATEGORY_ENTITY_DECIMAL_ATTRIBUTE` FOREIGN KEY (`attribute_id`) REFERENCES `eav_attribute` (`attribute_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CATALOG_CATEGORY_ENTITY_DECIMAL_ENTITY` FOREIGN KEY (`entity_id`) REFERENCES `catalog_category_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CATALOG_CATEGORY_ENTITY_DECIMAL_STORE` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalog_category_entity_decimal`
--

LOCK TABLES `catalog_category_entity_decimal` WRITE;
/*!40000 ALTER TABLE `catalog_category_entity_decimal` DISABLE KEYS */;
/*!40000 ALTER TABLE `catalog_category_entity_decimal` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalog_category_entity_int`
--

DROP TABLE IF EXISTS `catalog_category_entity_int`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalog_category_entity_int` (
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
  KEY `FK_CATALOG_CATEGORY_EMTITY_INT_STORE` (`store_id`),
  CONSTRAINT `FK_CATALOG_CATEGORY_EMTITY_INT_ATTRIBUTE` FOREIGN KEY (`attribute_id`) REFERENCES `eav_attribute` (`attribute_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CATALOG_CATEGORY_EMTITY_INT_ENTITY` FOREIGN KEY (`entity_id`) REFERENCES `catalog_category_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CATALOG_CATEGORY_EMTITY_INT_STORE` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=146 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalog_category_entity_int`
--

LOCK TABLES `catalog_category_entity_int` WRITE;
/*!40000 ALTER TABLE `catalog_category_entity_int` DISABLE KEYS */;
/*!40000 ALTER TABLE `catalog_category_entity_int` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalog_category_entity_text`
--

DROP TABLE IF EXISTS `catalog_category_entity_text`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalog_category_entity_text` (
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
  KEY `FK_CATALOG_CATEGORY_ENTITY_TEXT_STORE` (`store_id`),
  CONSTRAINT `FK_CATALOG_CATEGORY_ENTITY_TEXT_ATTRIBUTE` FOREIGN KEY (`attribute_id`) REFERENCES `eav_attribute` (`attribute_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CATALOG_CATEGORY_ENTITY_TEXT_ENTITY` FOREIGN KEY (`entity_id`) REFERENCES `catalog_category_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CATALOG_CATEGORY_ENTITY_TEXT_STORE` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=241 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalog_category_entity_text`
--

LOCK TABLES `catalog_category_entity_text` WRITE;
/*!40000 ALTER TABLE `catalog_category_entity_text` DISABLE KEYS */;
/*!40000 ALTER TABLE `catalog_category_entity_text` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalog_category_entity_varchar`
--

DROP TABLE IF EXISTS `catalog_category_entity_varchar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalog_category_entity_varchar` (
  `value_id` int(11) NOT NULL AUTO_INCREMENT,
  `entity_type_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `attribute_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `entity_id` int(10) unsigned NOT NULL DEFAULT '0',
  `value` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`value_id`),
  UNIQUE KEY `IDX_BASE` (`entity_type_id`,`entity_id`,`attribute_id`,`store_id`),
  KEY `FK_ATTRIBUTE_VARCHAR_ENTITY` (`entity_id`),
  KEY `FK_CATALOG_CATEGORY_ENTITY_VARCHAR_ATTRIBUTE` (`attribute_id`),
  KEY `FK_CATALOG_CATEGORY_ENTITY_VARCHAR_STORE` (`store_id`),
  CONSTRAINT `FK_CATALOG_CATEGORY_ENTITY_VARCHAR_ATTRIBUTE` FOREIGN KEY (`attribute_id`) REFERENCES `eav_attribute` (`attribute_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CATALOG_CATEGORY_ENTITY_VARCHAR_ENTITY` FOREIGN KEY (`entity_id`) REFERENCES `catalog_category_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CATALOG_CATEGORY_ENTITY_VARCHAR_STORE` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=386 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalog_category_entity_varchar`
--

LOCK TABLES `catalog_category_entity_varchar` WRITE;
/*!40000 ALTER TABLE `catalog_category_entity_varchar` DISABLE KEYS */;
/*!40000 ALTER TABLE `catalog_category_entity_varchar` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalog_category_flat`
--

DROP TABLE IF EXISTS `catalog_category_flat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalog_category_flat` (
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
  KEY `IDX_LEVEL` (`level`),
  CONSTRAINT `FK_CATEGORY_FLAT_CATEGORY_ID` FOREIGN KEY (`entity_id`) REFERENCES `catalog_category_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CATEGORY_FLAT_STORE_ID` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Flat Category';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalog_category_flat`
--

LOCK TABLES `catalog_category_flat` WRITE;
/*!40000 ALTER TABLE `catalog_category_flat` DISABLE KEYS */;
/*!40000 ALTER TABLE `catalog_category_flat` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalog_category_product`
--

DROP TABLE IF EXISTS `catalog_category_product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalog_category_product` (
  `category_id` int(10) unsigned NOT NULL DEFAULT '0',
  `product_id` int(10) unsigned NOT NULL DEFAULT '0',
  `position` int(10) unsigned NOT NULL DEFAULT '0',
  UNIQUE KEY `UNQ_CATEGORY_PRODUCT` (`category_id`,`product_id`),
  KEY `CATALOG_CATEGORY_PRODUCT_CATEGORY` (`category_id`),
  KEY `CATALOG_CATEGORY_PRODUCT_PRODUCT` (`product_id`),
  CONSTRAINT `CATALOG_CATEGORY_PRODUCT_CATEGORY` FOREIGN KEY (`category_id`) REFERENCES `catalog_category_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `CATALOG_CATEGORY_PRODUCT_PRODUCT` FOREIGN KEY (`product_id`) REFERENCES `catalog_product_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalog_category_product`
--

LOCK TABLES `catalog_category_product` WRITE;
/*!40000 ALTER TABLE `catalog_category_product` DISABLE KEYS */;
INSERT INTO `catalog_category_product` VALUES (452,60,0),(471,60,0),(597,83,0),(618,83,0),(1125,57,0),(1196,57,0),(1214,57,0),(1510,53,0),(1510,54,0),(1510,56,0),(1510,93,0),(1511,56,0),(1512,53,0),(1540,54,0),(1568,53,0),(1613,93,0),(1615,93,0),(1698,64,0),(1701,64,0),(1880,63,0),(1923,63,0),(1930,63,0),(1941,63,0),(1985,63,0),(1991,63,0),(2106,1,0),(2106,4,0),(2106,5,0),(2106,55,0),(2106,58,0),(2106,65,0),(2106,66,0),(2106,67,0),(2106,68,0),(2106,69,0),(2106,70,0),(2106,71,0),(2106,72,0),(2106,73,0),(2106,74,0),(2106,75,0),(2106,77,0),(2106,78,0),(2106,79,0),(2106,80,0),(2106,81,0),(2106,82,0),(2106,85,0),(2106,86,0),(2106,87,0),(2106,88,0),(2106,89,0),(2106,90,0),(2106,91,0),(2106,92,0),(2106,94,0),(2106,95,0),(2106,96,0),(2106,97,0),(2106,98,0),(2106,99,0),(2106,100,0),(2107,1,0),(2107,4,0),(2107,5,0),(2108,66,0),(2109,66,0),(2113,55,0),(2124,55,0),(2153,94,0),(2153,95,0),(2153,96,0),(2153,97,0),(2153,98,0),(2153,99,0),(2153,100,0),(2154,94,0),(2154,95,0),(2154,96,0),(2154,97,0),(2154,98,0),(2154,99,0),(2154,100,0),(2162,58,0),(2186,65,0),(2188,65,0),(2213,68,0),(2213,69,0),(2213,70,0),(2213,75,0),(2213,78,0),(2213,79,0),(2213,80,0),(2213,81,0),(2213,82,0),(2213,85,0),(2213,86,0),(2213,87,0),(2213,88,0),(2213,89,0),(2213,90,0),(2213,91,0),(2365,71,0),(2365,72,0),(2365,73,0),(2365,74,0),(2365,77,0),(2366,67,0),(2367,92,0),(2384,92,0),(2446,51,0),(2446,52,0),(2446,62,0),(2532,51,0),(2533,51,0),(2739,62,0),(2741,62,0),(2742,62,0),(2777,51,0),(2778,51,0),(2843,52,0),(2851,52,0),(3384,2,0),(3384,6,0),(3384,7,0),(3384,8,0),(3384,9,0),(3384,10,0),(3384,11,0),(3384,12,0),(3384,13,0),(3384,14,0),(3384,15,0),(3384,16,0),(3384,17,0),(3384,18,0),(3384,19,0),(3384,20,0),(3384,21,0),(3384,22,0),(3384,23,0),(3384,24,0),(3384,25,0),(3384,26,0),(3384,27,0),(3384,28,0),(3384,29,0),(3384,30,0),(3384,31,0),(3384,32,0),(3384,33,0),(3384,34,0),(3384,35,0),(3384,36,0),(3384,37,0),(3384,38,0),(3384,39,0),(3384,40,0),(3384,41,0),(3384,42,0),(3384,43,0),(3384,44,0),(3384,45,0),(3384,46,0),(3384,47,0),(3384,48,0),(3384,49,0),(3384,50,0),(3418,50,0),(3419,50,0),(3452,2,0),(3452,6,0),(3452,7,0),(3452,8,0),(3452,9,0),(3452,10,0),(3452,11,0),(3452,12,0),(3452,13,0),(3452,14,0),(3452,15,0),(3452,16,0),(3452,17,0),(3452,18,0),(3452,19,0),(3452,20,0),(3452,21,0),(3452,22,0),(3452,23,0),(3452,24,0),(3452,25,0),(3452,26,0),(3452,27,0),(3452,28,0),(3452,29,0),(3452,30,0),(3452,31,0),(3452,32,0),(3452,33,0),(3452,34,0),(3452,35,0),(3452,36,0),(3452,37,0),(3452,38,0),(3452,39,0),(3452,40,0),(3452,41,0),(3452,42,0),(3452,43,0),(3452,44,0),(3452,45,0),(3452,46,0),(3452,47,0),(3452,48,0),(3452,49,0),(3453,2,0),(3454,6,0),(3454,7,0),(3454,9,0),(3454,10,0),(3454,12,0),(3454,17,0),(3454,18,0),(3454,19,0),(3454,20,0),(3454,22,0),(3454,23,0),(3454,24,0),(3454,26,0),(3454,28,0),(3454,29,0),(3454,32,0),(3454,35,0),(3454,36,0),(3454,37,0),(3454,39,0),(3454,44,0),(3454,46,0),(3454,49,0),(3455,8,0),(3455,11,0),(3455,12,0),(3455,13,0),(3455,14,0),(3455,15,0),(3455,16,0),(3455,21,0),(3455,24,0),(3455,27,0),(3455,29,0),(3455,30,0),(3455,31,0),(3455,32,0),(3455,34,0),(3455,41,0),(3455,46,0),(3456,25,0),(3456,42,0),(3456,43,0),(3457,23,0),(3457,28,0),(3457,33,0),(3457,35,0),(3457,36,0),(3457,38,0),(3457,40,0),(3457,45,0),(3457,47,0),(3457,48,0),(3479,76,0),(3479,83,0),(3480,76,0),(3480,83,0),(3944,3,0),(3944,6,0),(3944,7,0),(3944,8,0),(3944,9,0),(3944,10,0),(3944,11,0),(3944,12,0),(3944,13,0),(3944,14,0),(3944,15,0),(3944,16,0),(3944,17,0),(3944,18,0),(3944,19,0),(3944,20,0),(3944,21,0),(3944,22,0),(3944,23,0),(3944,24,0),(3944,25,0),(3944,26,0),(3944,27,0),(3944,28,0),(3944,29,0),(3944,30,0),(3944,31,0),(3944,32,0),(3944,33,0),(3944,34,0),(3944,35,0),(3944,36,0),(3944,37,0),(3944,38,0),(3944,39,0),(3944,40,0),(3944,41,0),(3944,42,0),(3944,43,0),(3944,44,0),(3944,45,0),(3944,46,0),(3944,47,0),(3944,48,0),(3944,61,0),(3963,61,0),(3964,61,0),(4015,3,0),(4015,6,0),(4015,7,0),(4015,8,0),(4015,9,0),(4015,10,0),(4015,11,0),(4015,12,0),(4015,13,0),(4015,14,0),(4015,15,0),(4015,16,0),(4015,17,0),(4015,18,0),(4015,19,0),(4015,20,0),(4015,21,0),(4015,22,0),(4015,23,0),(4015,24,0),(4015,25,0),(4015,26,0),(4015,27,0),(4015,28,0),(4015,29,0),(4015,30,0),(4015,31,0),(4015,32,0),(4015,33,0),(4015,34,0),(4015,35,0),(4015,36,0),(4015,37,0),(4015,38,0),(4015,39,0),(4015,40,0),(4015,41,0),(4015,42,0),(4015,43,0),(4015,44,0),(4015,45,0),(4015,46,0),(4015,47,0),(4015,48,0),(4016,6,0),(4016,7,0),(4016,8,0),(4016,9,0),(4016,10,0),(4016,11,0),(4016,12,0),(4016,13,0),(4016,14,0),(4016,15,0),(4016,16,0),(4016,17,0),(4016,18,0),(4016,19,0),(4016,20,0),(4016,21,0),(4016,22,0),(4016,23,0),(4016,24,0),(4016,25,0),(4016,26,0),(4016,27,0),(4016,28,0),(4016,29,0),(4016,30,0),(4016,31,0),(4016,32,0),(4016,33,0),(4016,34,0),(4016,35,0),(4016,36,0),(4016,37,0),(4016,38,0),(4016,39,0),(4016,40,0),(4016,41,0),(4016,42,0),(4016,43,0),(4016,44,0),(4016,45,0),(4016,46,0),(4016,47,0),(4016,48,0),(4036,3,0),(4240,84,0),(4280,84,0),(4299,84,0),(4300,84,0),(4301,84,0),(4396,59,0),(4396,84,0),(4400,84,0),(4403,84,0),(4407,59,0);
/*!40000 ALTER TABLE `catalog_category_product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalog_category_product_index`
--

DROP TABLE IF EXISTS `catalog_category_product_index`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalog_category_product_index` (
  `category_id` int(10) unsigned NOT NULL DEFAULT '0',
  `product_id` int(10) unsigned NOT NULL DEFAULT '0',
  `position` int(10) unsigned NOT NULL DEFAULT '0',
  `is_parent` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `visibility` tinyint(3) unsigned NOT NULL,
  UNIQUE KEY `UNQ_CATEGORY_PRODUCT` (`category_id`,`product_id`,`is_parent`,`store_id`),
  KEY `FK_CATALOG_CATEGORY_PRODUCT_INDEX_CATEGORY_ENTITY` (`category_id`),
  KEY `IDX_JOIN` (`product_id`,`store_id`,`category_id`,`visibility`),
  KEY `IDX_BASE` (`store_id`,`category_id`,`visibility`,`is_parent`,`position`),
  CONSTRAINT `FK_CATALOG_CATEGORY_PRODUCT_INDEX_CATEGORY_ENTITY` FOREIGN KEY (`category_id`) REFERENCES `catalog_category_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CATALOG_CATEGORY_PRODUCT_INDEX_PRODUCT_ENTITY` FOREIGN KEY (`product_id`) REFERENCES `catalog_product_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CATEGORY_PRODUCT_INDEX_STORE` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalog_category_product_index`
--

LOCK TABLES `catalog_category_product_index` WRITE;
/*!40000 ALTER TABLE `catalog_category_product_index` DISABLE KEYS */;
INSERT INTO `catalog_category_product_index` VALUES (2,1,0,0,1,4),(2,2,0,0,1,4),(2,3,0,0,1,4),(2,4,0,0,1,4),(2,5,0,0,1,4),(2,6,0,0,1,4),(2,7,0,0,1,4),(2,8,0,0,1,4),(2,9,0,0,1,4),(2,10,0,0,1,4),(2,11,0,0,1,4),(2,12,0,0,1,4),(2,13,0,0,1,4),(2,14,0,0,1,4),(2,15,0,0,1,4),(2,16,0,0,1,4),(2,17,0,0,1,4),(2,18,0,0,1,4),(2,19,0,0,1,4),(2,20,0,0,1,4),(2,21,0,0,1,4),(2,22,0,0,1,4),(2,23,0,0,1,4),(2,24,0,0,1,4),(2,25,0,0,1,4),(2,26,0,0,1,4),(2,27,0,0,1,4),(2,28,0,0,1,4),(2,29,0,0,1,4),(2,30,0,0,1,4),(2,31,0,0,1,4),(2,32,0,0,1,4),(2,33,0,0,1,4),(2,34,0,0,1,4),(2,35,0,0,1,4),(2,36,0,0,1,4),(2,37,0,0,1,4),(2,38,0,0,1,4),(2,39,0,0,1,4),(2,40,0,0,1,4),(2,41,0,0,1,4),(2,42,0,0,1,4),(2,43,0,0,1,4),(2,44,0,0,1,4),(2,45,0,0,1,4),(2,46,0,0,1,4),(2,47,0,0,1,4),(2,48,0,0,1,4),(2,49,0,0,1,4),(2,50,0,0,1,4),(2,51,0,0,1,4),(2,52,0,0,1,4),(2,53,0,0,1,4),(2,54,0,0,1,4),(2,55,0,0,1,4),(2,56,0,0,1,4),(2,57,0,0,1,4),(2,58,0,0,1,4),(2,59,0,0,1,4),(2,60,0,0,1,4),(2,61,0,0,1,4),(2,62,0,0,1,4),(2,63,0,0,1,4),(2,64,0,0,1,4),(2,65,0,0,1,4),(2,66,0,0,1,4),(2,67,0,0,1,4),(2,68,0,0,1,4),(2,69,0,0,1,4),(2,70,0,0,1,4),(2,71,0,0,1,4),(2,72,0,0,1,4),(2,73,0,0,1,4),(2,74,0,0,1,4),(2,75,0,0,1,4),(2,76,0,0,1,4),(2,77,0,0,1,4),(2,78,0,0,1,4),(2,79,0,0,1,4),(2,80,0,0,1,4),(2,81,0,0,1,4),(2,82,0,0,1,4),(2,83,0,0,1,4),(2,84,0,0,1,4),(2,85,0,0,1,4),(2,86,0,0,1,4),(2,87,0,0,1,4),(2,88,0,0,1,4),(2,89,0,0,1,4),(2,90,0,0,1,4),(2,91,0,0,1,4),(2,92,0,0,1,4),(2,93,0,0,1,4),(2,94,0,0,1,4),(2,95,0,0,1,4),(2,96,0,0,1,4),(2,97,0,0,1,4),(2,98,0,0,1,4),(2,99,0,0,1,4),(2,100,0,0,1,4),(452,60,0,1,1,4),(471,60,0,1,1,4),(597,83,0,1,1,4),(618,83,0,1,1,4),(1125,57,0,1,1,4),(1196,57,0,1,1,4),(1214,57,0,1,1,4),(1510,53,0,1,1,4),(1510,54,0,1,1,4),(1510,56,0,1,1,4),(1510,93,0,1,1,4),(1511,56,0,1,1,4),(1512,53,0,1,1,4),(1540,54,0,1,1,4),(1568,53,0,1,1,4),(1613,93,0,1,1,4),(1615,93,0,1,1,4),(1698,64,0,1,1,4),(1701,64,0,1,1,4),(1880,63,0,1,1,4),(1923,63,0,1,1,4),(1930,63,0,1,1,4),(1941,63,0,1,1,4),(1985,63,0,1,1,4),(1991,63,0,1,1,4),(2106,1,0,1,1,4),(2106,4,0,1,1,4),(2106,5,0,1,1,4),(2106,55,0,1,1,4),(2106,58,0,1,1,4),(2106,65,0,1,1,4),(2106,66,0,1,1,4),(2106,67,0,1,1,4),(2106,68,0,1,1,4),(2106,69,0,1,1,4),(2106,70,0,1,1,4),(2106,71,0,1,1,4),(2106,72,0,1,1,4),(2106,73,0,1,1,4),(2106,74,0,1,1,4),(2106,75,0,1,1,4),(2106,77,0,1,1,4),(2106,78,0,1,1,4),(2106,79,0,1,1,4),(2106,80,0,1,1,4),(2106,81,0,1,1,4),(2106,82,0,1,1,4),(2106,85,0,1,1,4),(2106,86,0,1,1,4),(2106,87,0,1,1,4),(2106,88,0,1,1,4),(2106,89,0,1,1,4),(2106,90,0,1,1,4),(2106,91,0,1,1,4),(2106,92,0,1,1,4),(2106,94,0,1,1,4),(2106,95,0,1,1,4),(2106,96,0,1,1,4),(2106,97,0,1,1,4),(2106,98,0,1,1,4),(2106,99,0,1,1,4),(2106,100,0,1,1,4),(2107,1,0,1,1,4),(2107,4,0,1,1,4),(2107,5,0,1,1,4),(2108,66,0,1,1,4),(2109,66,0,1,1,4),(2113,55,0,1,1,4),(2124,55,0,1,1,4),(2153,94,0,1,1,4),(2153,95,0,1,1,4),(2153,96,0,1,1,4),(2153,97,0,1,1,4),(2153,98,0,1,1,4),(2153,99,0,1,1,4),(2153,100,0,1,1,4),(2154,94,0,1,1,4),(2154,95,0,1,1,4),(2154,96,0,1,1,4),(2154,97,0,1,1,4),(2154,98,0,1,1,4),(2154,99,0,1,1,4),(2154,100,0,1,1,4),(2162,58,0,1,1,4),(2186,65,0,1,1,4),(2188,65,0,1,1,4),(2213,68,0,1,1,4),(2213,69,0,1,1,4),(2213,70,0,1,1,4),(2213,75,0,1,1,4),(2213,78,0,1,1,4),(2213,79,0,1,1,4),(2213,80,0,1,1,4),(2213,81,0,1,1,4),(2213,82,0,1,1,4),(2213,85,0,1,1,4),(2213,86,0,1,1,4),(2213,87,0,1,1,4),(2213,88,0,1,1,4),(2213,89,0,1,1,4),(2213,90,0,1,1,4),(2213,91,0,1,1,4),(2365,71,0,1,1,4),(2365,72,0,1,1,4),(2365,73,0,1,1,4),(2365,74,0,1,1,4),(2365,77,0,1,1,4),(2366,67,0,1,1,4),(2367,92,0,1,1,4),(2384,92,0,1,1,4),(2446,51,0,1,1,4),(2446,52,0,1,1,4),(2446,62,0,1,1,4),(2532,51,0,1,1,4),(2533,51,0,1,1,4),(2739,62,0,1,1,4),(2741,62,0,1,1,4),(2742,62,0,1,1,4),(2777,51,0,1,1,4),(2778,51,0,1,1,4),(2843,52,0,1,1,4),(2851,52,0,1,1,4),(3384,2,0,1,1,4),(3384,6,0,1,1,4),(3384,7,0,1,1,4),(3384,8,0,1,1,4),(3384,9,0,1,1,4),(3384,10,0,1,1,4),(3384,11,0,1,1,4),(3384,12,0,1,1,4),(3384,13,0,1,1,4),(3384,14,0,1,1,4),(3384,15,0,1,1,4),(3384,16,0,1,1,4),(3384,17,0,1,1,4),(3384,18,0,1,1,4),(3384,19,0,1,1,4),(3384,20,0,1,1,4),(3384,21,0,1,1,4),(3384,22,0,1,1,4),(3384,23,0,1,1,4),(3384,24,0,1,1,4),(3384,25,0,1,1,4),(3384,26,0,1,1,4),(3384,27,0,1,1,4),(3384,28,0,1,1,4),(3384,29,0,1,1,4),(3384,30,0,1,1,4),(3384,31,0,1,1,4),(3384,32,0,1,1,4),(3384,33,0,1,1,4),(3384,34,0,1,1,4),(3384,35,0,1,1,4),(3384,36,0,1,1,4),(3384,37,0,1,1,4),(3384,38,0,1,1,4),(3384,39,0,1,1,4),(3384,40,0,1,1,4),(3384,41,0,1,1,4),(3384,42,0,1,1,4),(3384,43,0,1,1,4),(3384,44,0,1,1,4),(3384,45,0,1,1,4),(3384,46,0,1,1,4),(3384,47,0,1,1,4),(3384,48,0,1,1,4),(3384,49,0,1,1,4),(3384,50,0,1,1,4),(3418,50,0,1,1,4),(3419,50,0,1,1,4),(3452,2,0,1,1,4),(3452,6,0,1,1,4),(3452,7,0,1,1,4),(3452,8,0,1,1,4),(3452,9,0,1,1,4),(3452,10,0,1,1,4),(3452,11,0,1,1,4),(3452,12,0,1,1,4),(3452,13,0,1,1,4),(3452,14,0,1,1,4),(3452,15,0,1,1,4),(3452,16,0,1,1,4),(3452,17,0,1,1,4),(3452,18,0,1,1,4),(3452,19,0,1,1,4),(3452,20,0,1,1,4),(3452,21,0,1,1,4),(3452,22,0,1,1,4),(3452,23,0,1,1,4),(3452,24,0,1,1,4),(3452,25,0,1,1,4),(3452,26,0,1,1,4),(3452,27,0,1,1,4),(3452,28,0,1,1,4),(3452,29,0,1,1,4),(3452,30,0,1,1,4),(3452,31,0,1,1,4),(3452,32,0,1,1,4),(3452,33,0,1,1,4),(3452,34,0,1,1,4),(3452,35,0,1,1,4),(3452,36,0,1,1,4),(3452,37,0,1,1,4),(3452,38,0,1,1,4),(3452,39,0,1,1,4),(3452,40,0,1,1,4),(3452,41,0,1,1,4),(3452,42,0,1,1,4),(3452,43,0,1,1,4),(3452,44,0,1,1,4),(3452,45,0,1,1,4),(3452,46,0,1,1,4),(3452,47,0,1,1,4),(3452,48,0,1,1,4),(3452,49,0,1,1,4),(3453,2,0,1,1,4),(3454,6,0,1,1,4),(3454,7,0,1,1,4),(3454,9,0,1,1,4),(3454,10,0,1,1,4),(3454,12,0,1,1,4),(3454,17,0,1,1,4),(3454,18,0,1,1,4),(3454,19,0,1,1,4),(3454,20,0,1,1,4),(3454,22,0,1,1,4),(3454,23,0,1,1,4),(3454,24,0,1,1,4),(3454,26,0,1,1,4),(3454,28,0,1,1,4),(3454,29,0,1,1,4),(3454,32,0,1,1,4),(3454,35,0,1,1,4),(3454,36,0,1,1,4),(3454,37,0,1,1,4),(3454,39,0,1,1,4),(3454,44,0,1,1,4),(3454,46,0,1,1,4),(3454,49,0,1,1,4),(3455,8,0,1,1,4),(3455,11,0,1,1,4),(3455,12,0,1,1,4),(3455,13,0,1,1,4),(3455,14,0,1,1,4),(3455,15,0,1,1,4),(3455,16,0,1,1,4),(3455,21,0,1,1,4),(3455,24,0,1,1,4),(3455,27,0,1,1,4),(3455,29,0,1,1,4),(3455,30,0,1,1,4),(3455,31,0,1,1,4),(3455,32,0,1,1,4),(3455,34,0,1,1,4),(3455,41,0,1,1,4),(3455,46,0,1,1,4),(3456,25,0,1,1,4),(3456,42,0,1,1,4),(3456,43,0,1,1,4),(3457,23,0,1,1,4),(3457,28,0,1,1,4),(3457,33,0,1,1,4),(3457,35,0,1,1,4),(3457,36,0,1,1,4),(3457,38,0,1,1,4),(3457,40,0,1,1,4),(3457,45,0,1,1,4),(3457,47,0,1,1,4),(3457,48,0,1,1,4),(3479,76,0,1,1,4),(3479,83,0,1,1,4),(3480,76,0,1,1,4),(3480,83,0,1,1,4),(3944,3,0,1,1,4),(3944,6,0,1,1,4),(3944,7,0,1,1,4),(3944,8,0,1,1,4),(3944,9,0,1,1,4),(3944,10,0,1,1,4),(3944,11,0,1,1,4),(3944,12,0,1,1,4),(3944,13,0,1,1,4),(3944,14,0,1,1,4),(3944,15,0,1,1,4),(3944,16,0,1,1,4),(3944,17,0,1,1,4),(3944,18,0,1,1,4),(3944,19,0,1,1,4),(3944,20,0,1,1,4),(3944,21,0,1,1,4),(3944,22,0,1,1,4),(3944,23,0,1,1,4),(3944,24,0,1,1,4),(3944,25,0,1,1,4),(3944,26,0,1,1,4),(3944,27,0,1,1,4),(3944,28,0,1,1,4),(3944,29,0,1,1,4),(3944,30,0,1,1,4),(3944,31,0,1,1,4),(3944,32,0,1,1,4),(3944,33,0,1,1,4),(3944,34,0,1,1,4),(3944,35,0,1,1,4),(3944,36,0,1,1,4),(3944,37,0,1,1,4),(3944,38,0,1,1,4),(3944,39,0,1,1,4),(3944,40,0,1,1,4),(3944,41,0,1,1,4),(3944,42,0,1,1,4),(3944,43,0,1,1,4),(3944,44,0,1,1,4),(3944,45,0,1,1,4),(3944,46,0,1,1,4),(3944,47,0,1,1,4),(3944,48,0,1,1,4),(3944,61,0,1,1,4),(3963,61,0,1,1,4),(3964,61,0,1,1,4),(4015,3,0,1,1,4),(4015,6,0,1,1,4),(4015,7,0,1,1,4),(4015,8,0,1,1,4),(4015,9,0,1,1,4),(4015,10,0,1,1,4),(4015,11,0,1,1,4),(4015,12,0,1,1,4),(4015,13,0,1,1,4),(4015,14,0,1,1,4),(4015,15,0,1,1,4),(4015,16,0,1,1,4),(4015,17,0,1,1,4),(4015,18,0,1,1,4),(4015,19,0,1,1,4),(4015,20,0,1,1,4),(4015,21,0,1,1,4),(4015,22,0,1,1,4),(4015,23,0,1,1,4),(4015,24,0,1,1,4),(4015,25,0,1,1,4),(4015,26,0,1,1,4),(4015,27,0,1,1,4),(4015,28,0,1,1,4),(4015,29,0,1,1,4),(4015,30,0,1,1,4),(4015,31,0,1,1,4),(4015,32,0,1,1,4),(4015,33,0,1,1,4),(4015,34,0,1,1,4),(4015,35,0,1,1,4),(4015,36,0,1,1,4),(4015,37,0,1,1,4),(4015,38,0,1,1,4),(4015,39,0,1,1,4),(4015,40,0,1,1,4),(4015,41,0,1,1,4),(4015,42,0,1,1,4),(4015,43,0,1,1,4),(4015,44,0,1,1,4),(4015,45,0,1,1,4),(4015,46,0,1,1,4),(4015,47,0,1,1,4),(4015,48,0,1,1,4),(4016,6,0,1,1,4),(4016,7,0,1,1,4),(4016,8,0,1,1,4),(4016,9,0,1,1,4),(4016,10,0,1,1,4),(4016,11,0,1,1,4),(4016,12,0,1,1,4),(4016,13,0,1,1,4),(4016,14,0,1,1,4),(4016,15,0,1,1,4),(4016,16,0,1,1,4),(4016,17,0,1,1,4),(4016,18,0,1,1,4),(4016,19,0,1,1,4),(4016,20,0,1,1,4),(4016,21,0,1,1,4),(4016,22,0,1,1,4),(4016,23,0,1,1,4),(4016,24,0,1,1,4),(4016,25,0,1,1,4),(4016,26,0,1,1,4),(4016,27,0,1,1,4),(4016,28,0,1,1,4),(4016,29,0,1,1,4),(4016,30,0,1,1,4),(4016,31,0,1,1,4),(4016,32,0,1,1,4),(4016,33,0,1,1,4),(4016,34,0,1,1,4),(4016,35,0,1,1,4),(4016,36,0,1,1,4),(4016,37,0,1,1,4),(4016,38,0,1,1,4),(4016,39,0,1,1,4),(4016,40,0,1,1,4),(4016,41,0,1,1,4),(4016,42,0,1,1,4),(4016,43,0,1,1,4),(4016,44,0,1,1,4),(4016,45,0,1,1,4),(4016,46,0,1,1,4),(4016,47,0,1,1,4),(4016,48,0,1,1,4),(4036,3,0,1,1,4),(4240,84,0,1,1,4),(4280,84,0,1,1,4),(4299,84,0,1,1,4),(4300,84,0,1,1,4),(4301,84,0,1,1,4),(4396,59,0,1,1,4),(4396,84,0,1,1,4),(4400,84,0,1,1,4),(4403,84,0,1,1,4),(4407,59,0,1,1,4);
/*!40000 ALTER TABLE `catalog_category_product_index` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalog_compare_item`
--

DROP TABLE IF EXISTS `catalog_compare_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalog_compare_item` (
  `catalog_compare_item_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `visitor_id` int(11) unsigned NOT NULL DEFAULT '0',
  `customer_id` int(11) unsigned DEFAULT NULL,
  `product_id` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`catalog_compare_item_id`),
  KEY `FK_CATALOG_COMPARE_ITEM_CUSTOMER` (`customer_id`),
  KEY `FK_CATALOG_COMPARE_ITEM_PRODUCT` (`product_id`),
  KEY `IDX_VISITOR_PRODUCTS` (`visitor_id`,`product_id`),
  KEY `IDX_CUSTOMER_PRODUCTS` (`customer_id`,`product_id`),
  CONSTRAINT `FK_CATALOG_COMPARE_ITEM_CUSTOMER` FOREIGN KEY (`customer_id`) REFERENCES `customer_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CATALOG_COMPARE_ITEM_PRODUCT` FOREIGN KEY (`product_id`) REFERENCES `catalog_product_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalog_compare_item`
--

LOCK TABLES `catalog_compare_item` WRITE;
/*!40000 ALTER TABLE `catalog_compare_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `catalog_compare_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalog_product_bundle_option`
--

DROP TABLE IF EXISTS `catalog_product_bundle_option`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalog_product_bundle_option` (
  `option_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `parent_id` int(10) unsigned NOT NULL,
  `required` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `position` int(10) unsigned NOT NULL DEFAULT '0',
  `type` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`option_id`),
  KEY `FK_CATALOG_PRODUCT_BUNDLE_OPTION_PARENT` (`parent_id`),
  CONSTRAINT `FK_CATALOG_PRODUCT_BUNDLE_OPTION_PARENT` FOREIGN KEY (`parent_id`) REFERENCES `catalog_product_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Bundle Options';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalog_product_bundle_option`
--

LOCK TABLES `catalog_product_bundle_option` WRITE;
/*!40000 ALTER TABLE `catalog_product_bundle_option` DISABLE KEYS */;
/*!40000 ALTER TABLE `catalog_product_bundle_option` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalog_product_bundle_option_value`
--

DROP TABLE IF EXISTS `catalog_product_bundle_option_value`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalog_product_bundle_option_value` (
  `value_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `option_id` int(10) unsigned NOT NULL,
  `store_id` smallint(5) unsigned NOT NULL,
  `title` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`value_id`),
  KEY `FK_CATALOG_PRODUCT_BUNDLE_OPTION_VALUE_OPTION` (`option_id`),
  CONSTRAINT `FK_CATALOG_PRODUCT_BUNDLE_OPTION_VALUE_OPTION` FOREIGN KEY (`option_id`) REFERENCES `catalog_product_bundle_option` (`option_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Bundle Selections';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalog_product_bundle_option_value`
--

LOCK TABLES `catalog_product_bundle_option_value` WRITE;
/*!40000 ALTER TABLE `catalog_product_bundle_option_value` DISABLE KEYS */;
/*!40000 ALTER TABLE `catalog_product_bundle_option_value` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalog_product_bundle_price_index`
--

DROP TABLE IF EXISTS `catalog_product_bundle_price_index`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalog_product_bundle_price_index` (
  `entity_id` int(10) unsigned NOT NULL,
  `website_id` smallint(5) unsigned NOT NULL,
  `customer_group_id` smallint(3) unsigned NOT NULL,
  `min_price` decimal(12,4) NOT NULL,
  `max_price` decimal(12,4) NOT NULL,
  PRIMARY KEY (`entity_id`,`website_id`,`customer_group_id`),
  KEY `IDX_WEBSITE` (`website_id`),
  KEY `IDX_CUSTOMER_GROUP` (`customer_group_id`),
  CONSTRAINT `CATALOG_PRODUCT_BUNDLE_PRICE_INDEX_CUSTOMER_GROUP` FOREIGN KEY (`customer_group_id`) REFERENCES `customer_group` (`customer_group_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `CATALOG_PRODUCT_BUNDLE_PRICE_INDEX_PRODUCT_ENTITY` FOREIGN KEY (`entity_id`) REFERENCES `catalog_product_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `CATALOG_PRODUCT_BUNDLE_PRICE_INDEX_WEBSITE` FOREIGN KEY (`website_id`) REFERENCES `core_website` (`website_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalog_product_bundle_price_index`
--

LOCK TABLES `catalog_product_bundle_price_index` WRITE;
/*!40000 ALTER TABLE `catalog_product_bundle_price_index` DISABLE KEYS */;
/*!40000 ALTER TABLE `catalog_product_bundle_price_index` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalog_product_bundle_selection`
--

DROP TABLE IF EXISTS `catalog_product_bundle_selection`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalog_product_bundle_selection` (
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
  KEY `FK_CATALOG_PRODUCT_BUNDLE_SELECTION_PRODUCT` (`product_id`),
  CONSTRAINT `FK_CATALOG_PRODUCT_BUNDLE_SELECTION_OPTION` FOREIGN KEY (`option_id`) REFERENCES `catalog_product_bundle_option` (`option_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CATALOG_PRODUCT_BUNDLE_SELECTION_PRODUCT` FOREIGN KEY (`product_id`) REFERENCES `catalog_product_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Bundle Selections';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalog_product_bundle_selection`
--

LOCK TABLES `catalog_product_bundle_selection` WRITE;
/*!40000 ALTER TABLE `catalog_product_bundle_selection` DISABLE KEYS */;
/*!40000 ALTER TABLE `catalog_product_bundle_selection` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalog_product_enabled_index`
--

DROP TABLE IF EXISTS `catalog_product_enabled_index`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalog_product_enabled_index` (
  `product_id` int(10) unsigned NOT NULL DEFAULT '0',
  `store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `visibility` smallint(5) unsigned NOT NULL DEFAULT '0',
  UNIQUE KEY `UNQ_PRODUCT_STORE` (`product_id`,`store_id`),
  KEY `IDX_PRODUCT_VISIBILITY_IN_STORE` (`product_id`,`store_id`,`visibility`),
  KEY `FK_CATALOG_PRODUCT_ENABLED_INDEX_STORE` (`store_id`),
  CONSTRAINT `FK_CATALOG_PRODUCT_ENABLED_INDEX_PRODUCT_ENTITY` FOREIGN KEY (`product_id`) REFERENCES `catalog_product_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CATALOG_PRODUCT_ENABLED_INDEX_STORE` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalog_product_enabled_index`
--

LOCK TABLES `catalog_product_enabled_index` WRITE;
/*!40000 ALTER TABLE `catalog_product_enabled_index` DISABLE KEYS */;
INSERT INTO `catalog_product_enabled_index` VALUES (1,1,4),(2,1,4),(3,1,4),(4,1,4),(5,1,4),(6,1,4),(7,1,4),(8,1,4),(9,1,4),(10,1,4),(11,1,4),(12,1,4),(13,1,4),(14,1,4),(15,1,4),(16,1,4),(17,1,4),(18,1,4),(19,1,4),(20,1,4),(21,1,4),(22,1,4),(23,1,4),(24,1,4),(25,1,4),(26,1,4),(27,1,4),(28,1,4),(29,1,4),(30,1,4),(31,1,4),(32,1,4),(33,1,4),(34,1,4),(35,1,4),(36,1,4),(37,1,4),(38,1,4),(39,1,4),(40,1,4),(41,1,4),(42,1,4),(43,1,4),(44,1,4),(45,1,4),(46,1,4),(47,1,4),(48,1,4),(49,1,4),(50,1,4),(51,1,4),(52,1,4),(53,1,4),(54,1,4),(55,1,4),(56,1,4),(57,1,4),(58,1,4),(59,1,4),(60,1,4),(61,1,4),(62,1,4),(63,1,4),(64,1,4),(65,1,4),(66,1,4),(67,1,4),(68,1,4),(69,1,4),(70,1,4),(71,1,4),(72,1,4),(73,1,4),(74,1,4),(75,1,4),(76,1,4),(77,1,4),(78,1,4),(79,1,4),(80,1,4),(81,1,4),(82,1,4),(83,1,4),(84,1,4),(85,1,4),(86,1,4),(87,1,4),(88,1,4),(89,1,4),(90,1,4),(91,1,4),(92,1,4),(93,1,4),(94,1,4),(95,1,4),(96,1,4),(97,1,4),(98,1,4),(99,1,4),(100,1,4);
/*!40000 ALTER TABLE `catalog_product_enabled_index` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalog_product_entity`
--

DROP TABLE IF EXISTS `catalog_product_entity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalog_product_entity` (
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
  KEY `sku` (`sku`),
  CONSTRAINT `FK_CATALOG_PRODUCT_ENTITY_ATTRIBUTE_SET_ID` FOREIGN KEY (`attribute_set_id`) REFERENCES `eav_attribute_set` (`attribute_set_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CATALOG_PRODUCT_ENTITY_ENTITY_TYPE` FOREIGN KEY (`entity_type_id`) REFERENCES `eav_entity_type` (`entity_type_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8 COMMENT='Product Entities';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalog_product_entity`
--

LOCK TABLES `catalog_product_entity` WRITE;
/*!40000 ALTER TABLE `catalog_product_entity` DISABLE KEYS */;
INSERT INTO `catalog_product_entity` VALUES (1,4,26,'simple','0030099690202','2106,2107','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(2,4,26,'simple','0073999668766','3384,3452,3453','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(3,4,26,'simple','0634337008486','3944,4015,4036','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(4,4,26,'simple','0690249442220','2106,2107','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(5,4,26,'simple','0690249442244','2106,2107','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(6,4,26,'simple','0765762013001','3944,4015,4016,3384,3452,3454','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(7,4,26,'simple','0765762060401','3944,4015,4016,3384,3452,3454','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(8,4,26,'simple','0765762072008','3944,4015,4016,3384,3452,3455','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(9,4,26,'simple','0765762092501','3944,4015,4016,3384,3452,3454','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(10,4,26,'simple','0765762101609','3944,4015,4016,3384,3452,3454','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(11,4,26,'simple','0765762106000','3944,4015,4016,3384,3452,3455','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(12,4,26,'simple','0765762108004','3944,4015,4016,3384,3452,3455,3454','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(13,4,26,'simple','0765762112506','3944,4015,4016,3384,3452,3455','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(14,4,26,'simple','0765762114906','3944,4015,4016,3384,3452,3455','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(15,4,26,'simple','0765762119406','3944,4015,4016,3384,3452,3455','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(16,4,26,'simple','0765762119901','3944,4015,4016,3384,3452,3455','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(17,4,26,'simple','0765762127807','3944,4015,4016,3384,3452,3454','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(18,4,26,'simple','0765762132702','3944,4015,4016,3384,3452,3454','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(19,4,26,'simple','0765762132801','3944,4015,4016,3384,3452,3454','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(20,4,26,'simple','0765762132900','3944,4015,4016,3384,3452,3454','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(21,4,26,'simple','0765762133303','3944,4015,4016,3384,3452,3455','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(22,4,26,'simple','0765762133600','3944,4015,4016,3384,3452,3454','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(23,4,26,'simple','0765762133808','3944,4015,4016,3384,3452,3457,3454','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(24,4,26,'simple','0765762134201','3944,4015,4016,3384,3452,3455,3454','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(25,4,26,'simple','0765762134409','3944,4015,4016,3384,3452,3456','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(26,4,26,'simple','0765762134508','3944,4015,4016,3384,3452,3454','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(27,4,26,'simple','0765762134607','3944,4015,4016,3384,3452,3455','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(28,4,26,'simple','0765762134706','3944,4015,4016,3384,3452,3457,3454','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(29,4,26,'simple','0765762134805','3944,4015,4016,3384,3452,3455,3454','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(30,4,26,'simple','0765762134904','3944,4015,4016,3384,3452,3455','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(31,4,26,'simple','0765762135000','3944,4015,4016,3384,3452,3455','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(32,4,26,'simple','0765762135109','3944,4015,4016,3384,3452,3455,3454','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(33,4,26,'simple','0765762135208','3944,4015,4016,3384,3452,3457','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(34,4,26,'simple','0765762135307','3944,4015,4016,3384,3452,3455','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(35,4,26,'simple','0765762135406','3944,4015,4016,3384,3452,3457,3454','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(36,4,26,'simple','0765762135505','3944,4015,4016,3384,3452,3457,3454','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(37,4,26,'simple','0765762135703','3944,4015,4016,3384,3452,3454','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(38,4,26,'simple','0765762136007','3944,4015,4016,3384,3452,3457','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(39,4,26,'simple','0765762136403','3944,4015,4016,3384,3452,3454','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(40,4,26,'simple','0765762136502','3944,4015,4016,3384,3452,3457','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(41,4,26,'simple','0765762136809','3944,4015,4016,3384,3452,3455','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(42,4,26,'simple','0765762137004','3944,4015,4016,3384,3452,3456','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(43,4,26,'simple','0765762137103','3944,4015,4016,3384,3452,3456','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(44,4,26,'simple','0765762137202','3944,4015,4016,3384,3452,3454','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(45,4,26,'simple','0765762137301','3944,4015,4016,3384,3452,3457','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(46,4,26,'simple','0765762139800','3944,4015,4016,3384,3452,3455,3454','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(47,4,26,'simple','0765762140103','3944,4015,4016,3384,3452,3457','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(48,4,26,'simple','0765762140400','3944,4015,4016,3384,3452,3457','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(49,4,26,'simple','0765762155008','3384,3452,3454','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(50,4,26,'simple','0796279109260','3384,3418,3419','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(51,4,26,'simple','0978082568186','2446,2532,2533,2777,2778','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(52,4,26,'simple','0978089125351','2446,2843,2851','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(53,4,26,'simple','0978144380572','1510,1512,1568','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(54,4,26,'simple','1116090014687','1510,1540','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(55,4,26,'simple','1200600710005','2106,2113,2124','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(56,4,26,'simple','2010000001189','1510,1511','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(57,4,26,'simple','4711213292675','1125,1196,1214','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(58,4,26,'simple','4713482004256','2106,2162','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(59,4,26,'simple','4717702066765','4396,4407','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(60,4,26,'simple','4717702228606','452,471','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(61,4,26,'simple','6006937084346','3944,3963,3964','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(62,4,26,'simple','6006937084377','2446,2739,2741,2742','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(63,4,26,'simple','7835150933921','1880,1941,1923,1930,1985,1991','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(64,4,26,'simple','8033772895149','1698,1701','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(65,4,26,'simple','8932000113713','2106,2186,2188','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(66,4,26,'simple','8934661181209','2106,2108,2109','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(67,4,26,'simple','8934974008972','2106,2366','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(68,4,26,'simple','8934974048480','2106,2213','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(69,4,26,'simple','8934974048794','2106,2213','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(70,4,26,'simple','8934974055143','2106,2213','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(71,4,26,'simple','8934974061670','2106,2365','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(72,4,26,'simple','8934974063308','2106,2365','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(73,4,26,'simple','8934974068976','2106,2365','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(74,4,26,'simple','8934974072720','2106,2365','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(75,4,26,'simple','8934974072805','2106,2213','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(76,4,26,'simple','8934974073109','3479,3480','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(77,4,26,'simple','8934974075912','2106,2365','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(78,4,26,'simple','8934974076278','2106,2213','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(79,4,26,'simple','8934974076797','2106,2213','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(80,4,26,'simple','8934974076803','2106,2213','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(81,4,26,'simple','8934974076933','2106,2213','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(82,4,26,'simple','8934974076995','2106,2213','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(83,4,26,'simple','8934974077657','3479,3480,597,618','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(84,4,26,'simple','8934974077671','4396,4400,4403,4240,4280,4301,4299,4300','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(85,4,26,'simple','8934974078258','2106,2213','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(86,4,26,'simple','8934974079446','2106,2213','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(87,4,26,'simple','8934974080336','2106,2213','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(88,4,26,'simple','8934974081067','2106,2213','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(89,4,26,'simple','8934974082910','2106,2213','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(90,4,26,'simple','8934974082927','2106,2213','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(91,4,26,'simple','8934974085911','2106,2213','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(92,4,26,'simple','8934974086246','2106,2367,2384','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(93,4,26,'simple','8934974089780','1510,1613,1615','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(94,4,26,'simple','8935036602206','2106,2153,2154','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(95,4,26,'simple','8935036602213','2106,2153,2154','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(96,4,26,'simple','8935036602220','2106,2153,2154','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(97,4,26,'simple','8935036602244','2106,2153,2154','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(98,4,26,'simple','8935036602251','2106,2153,2154','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(99,4,26,'simple','8935036602268','2106,2153,2154','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0),(100,4,26,'simple','8935036602275','2106,2153,2154','2010-02-04 00:00:00','2010-02-04 00:00:00',0,0);
/*!40000 ALTER TABLE `catalog_product_entity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalog_product_entity_datetime`
--

DROP TABLE IF EXISTS `catalog_product_entity_datetime`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalog_product_entity_datetime` (
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
  KEY `FK_CATALOG_PRODUCT_ENTITY_DATETIME_PRODUCT_ENTITY` (`entity_id`),
  CONSTRAINT `FK_CATALOG_PRODUCT_ENTITY_DATETIME_ATTRIBUTE` FOREIGN KEY (`attribute_id`) REFERENCES `eav_attribute` (`attribute_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CATALOG_PRODUCT_ENTITY_DATETIME_PRODUCT_ENTITY` FOREIGN KEY (`entity_id`) REFERENCES `catalog_product_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CATALOG_PRODUCT_ENTITY_DATETIME_STORE` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=102 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalog_product_entity_datetime`
--

LOCK TABLES `catalog_product_entity_datetime` WRITE;
/*!40000 ALTER TABLE `catalog_product_entity_datetime` DISABLE KEYS */;
INSERT INTO `catalog_product_entity_datetime` VALUES (2,4,501,0,1,'0000-00-00 00:00:00'),(3,4,501,0,2,'0000-00-00 00:00:00'),(4,4,501,0,3,'0000-00-00 00:00:00'),(5,4,501,0,4,'0000-00-00 00:00:00'),(6,4,501,0,5,'0000-00-00 00:00:00'),(7,4,501,0,6,'0000-00-00 00:00:00'),(8,4,501,0,7,'0000-00-00 00:00:00'),(9,4,501,0,8,'0000-00-00 00:00:00'),(10,4,501,0,9,'0000-00-00 00:00:00'),(11,4,501,0,10,'0000-00-00 00:00:00'),(12,4,501,0,11,'0000-00-00 00:00:00'),(13,4,501,0,12,'0000-00-00 00:00:00'),(14,4,501,0,13,'0000-00-00 00:00:00'),(15,4,501,0,14,'0000-00-00 00:00:00'),(16,4,501,0,15,'0000-00-00 00:00:00'),(17,4,501,0,16,'0000-00-00 00:00:00'),(18,4,501,0,17,'0000-00-00 00:00:00'),(19,4,501,0,18,'0000-00-00 00:00:00'),(20,4,501,0,19,'0000-00-00 00:00:00'),(21,4,501,0,20,'0000-00-00 00:00:00'),(22,4,501,0,21,'0000-00-00 00:00:00'),(23,4,501,0,22,'0000-00-00 00:00:00'),(24,4,501,0,23,'0000-00-00 00:00:00'),(25,4,501,0,24,'0000-00-00 00:00:00'),(26,4,501,0,25,'0000-00-00 00:00:00'),(27,4,501,0,26,'0000-00-00 00:00:00'),(28,4,501,0,27,'0000-00-00 00:00:00'),(29,4,501,0,28,'0000-00-00 00:00:00'),(30,4,501,0,29,'0000-00-00 00:00:00'),(31,4,501,0,30,'0000-00-00 00:00:00'),(32,4,501,0,31,'0000-00-00 00:00:00'),(33,4,501,0,32,'0000-00-00 00:00:00'),(34,4,501,0,33,'0000-00-00 00:00:00'),(35,4,501,0,34,'0000-00-00 00:00:00'),(36,4,501,0,35,'0000-00-00 00:00:00'),(37,4,501,0,36,'0000-00-00 00:00:00'),(38,4,501,0,37,'0000-00-00 00:00:00'),(39,4,501,0,38,'0000-00-00 00:00:00'),(40,4,501,0,39,'0000-00-00 00:00:00'),(41,4,501,0,40,'0000-00-00 00:00:00'),(42,4,501,0,41,'0000-00-00 00:00:00'),(43,4,501,0,42,'0000-00-00 00:00:00'),(44,4,501,0,43,'0000-00-00 00:00:00'),(45,4,501,0,44,'0000-00-00 00:00:00'),(46,4,501,0,45,'0000-00-00 00:00:00'),(47,4,501,0,46,'0000-00-00 00:00:00'),(48,4,501,0,47,'0000-00-00 00:00:00'),(49,4,501,0,48,'0000-00-00 00:00:00'),(50,4,501,0,49,'0000-00-00 00:00:00'),(51,4,501,0,50,'0000-00-00 00:00:00'),(52,4,501,0,51,'0000-00-00 00:00:00'),(53,4,501,0,52,'0000-00-00 00:00:00'),(54,4,501,0,53,'0000-00-00 00:00:00'),(55,4,501,0,54,'0000-00-00 00:00:00'),(56,4,501,0,55,'0000-00-00 00:00:00'),(57,4,501,0,56,'0000-00-00 00:00:00'),(58,4,501,0,57,'0000-00-00 00:00:00'),(59,4,501,0,58,'0000-00-00 00:00:00'),(60,4,501,0,59,'0000-00-00 00:00:00'),(61,4,501,0,60,'0000-00-00 00:00:00'),(62,4,501,0,61,'0000-00-00 00:00:00'),(63,4,501,0,62,'0000-00-00 00:00:00'),(64,4,501,0,63,'0000-00-00 00:00:00'),(65,4,501,0,64,'0000-00-00 00:00:00'),(66,4,501,0,65,'0000-00-00 00:00:00'),(67,4,501,0,66,'0000-00-00 00:00:00'),(68,4,501,0,67,'0000-00-00 00:00:00'),(69,4,501,0,68,'0000-00-00 00:00:00'),(70,4,501,0,69,'0000-00-00 00:00:00'),(71,4,501,0,70,'0000-00-00 00:00:00'),(72,4,501,0,71,'0000-00-00 00:00:00'),(73,4,501,0,72,'0000-00-00 00:00:00'),(74,4,501,0,73,'0000-00-00 00:00:00'),(75,4,501,0,74,'0000-00-00 00:00:00'),(76,4,501,0,75,'0000-00-00 00:00:00'),(77,4,501,0,76,'0000-00-00 00:00:00'),(78,4,501,0,77,'0000-00-00 00:00:00'),(79,4,501,0,78,'0000-00-00 00:00:00'),(80,4,501,0,79,'0000-00-00 00:00:00'),(81,4,501,0,80,'0000-00-00 00:00:00'),(82,4,501,0,81,'0000-00-00 00:00:00'),(83,4,501,0,82,'0000-00-00 00:00:00'),(84,4,501,0,83,'0000-00-00 00:00:00'),(85,4,501,0,84,'0000-00-00 00:00:00'),(86,4,501,0,85,'0000-00-00 00:00:00'),(87,4,501,0,86,'0000-00-00 00:00:00'),(88,4,501,0,87,'0000-00-00 00:00:00'),(89,4,501,0,88,'0000-00-00 00:00:00'),(90,4,501,0,89,'0000-00-00 00:00:00'),(91,4,501,0,90,'0000-00-00 00:00:00'),(92,4,501,0,91,'0000-00-00 00:00:00'),(93,4,501,0,92,'0000-00-00 00:00:00'),(94,4,501,0,93,'0000-00-00 00:00:00'),(95,4,501,0,94,'0000-00-00 00:00:00'),(96,4,501,0,95,'0000-00-00 00:00:00'),(97,4,501,0,96,'0000-00-00 00:00:00'),(98,4,501,0,97,'0000-00-00 00:00:00'),(99,4,501,0,98,'0000-00-00 00:00:00'),(100,4,501,0,99,'0000-00-00 00:00:00'),(101,4,501,0,100,'0000-00-00 00:00:00');
/*!40000 ALTER TABLE `catalog_product_entity_datetime` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalog_product_entity_decimal`
--

DROP TABLE IF EXISTS `catalog_product_entity_decimal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalog_product_entity_decimal` (
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
  KEY `FK_CATALOG_PRODUCT_ENTITY_DECIMAL_ATTRIBUTE` (`attribute_id`),
  CONSTRAINT `FK_CATALOG_PRODUCT_ENTITY_DECIMAL_ATTRIBUTE` FOREIGN KEY (`attribute_id`) REFERENCES `eav_attribute` (`attribute_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CATALOG_PRODUCT_ENTITY_DECIMAL_PRODUCT_ENTITY` FOREIGN KEY (`entity_id`) REFERENCES `catalog_product_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CATALOG_PRODUCT_ENTITY_DECIMAL_STORE` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=303 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalog_product_entity_decimal`
--

LOCK TABLES `catalog_product_entity_decimal` WRITE;
/*!40000 ALTER TABLE `catalog_product_entity_decimal` DISABLE KEYS */;
INSERT INTO `catalog_product_entity_decimal` VALUES (3,4,60,0,1,'99.5000'),(4,4,61,0,1,'92.0000'),(5,4,65,0,1,'12.5000'),(6,4,60,0,2,'600.0000'),(7,4,61,0,2,'552.0000'),(8,4,65,0,2,'20.6300'),(9,4,60,0,3,'10425.0000'),(10,4,61,0,3,'9591.0000'),(11,4,65,0,3,'0.0000'),(12,4,60,0,4,'749.5000'),(13,4,61,0,4,'690.0000'),(14,4,65,0,4,'28.7500'),(15,4,60,0,5,'599.5000'),(16,4,61,0,5,'552.0000'),(17,4,65,0,5,'21.2500'),(18,4,60,0,6,'1000.0000'),(19,4,61,0,6,'920.0000'),(20,4,65,0,6,'0.0000'),(21,4,60,0,7,'3499.5000'),(22,4,61,0,7,'3220.0000'),(23,4,65,0,7,'198.1300'),(24,4,60,0,8,'3749.5000'),(25,4,61,0,8,'3450.0000'),(26,4,65,0,8,'0.0000'),(27,4,60,0,9,'19750.0000'),(28,4,61,0,9,'18170.0000'),(29,4,65,0,9,'0.0000'),(30,4,60,0,10,'3749.5000'),(31,4,61,0,10,'3450.0000'),(32,4,65,0,10,'40.6300'),(33,4,60,0,11,'3749.5000'),(34,4,61,0,11,'3450.0000'),(35,4,65,0,11,'0.0000'),(36,4,60,0,12,'3749.5000'),(37,4,61,0,12,'3450.0000'),(38,4,65,0,12,'40.6300'),(39,4,60,0,13,'3749.5000'),(40,4,61,0,13,'3450.0000'),(41,4,65,0,13,'0.0000'),(42,4,60,0,14,'3749.5000'),(43,4,61,0,14,'3450.0000'),(44,4,65,0,14,'0.0000'),(45,4,60,0,15,'3749.5000'),(46,4,61,0,15,'3450.0000'),(47,4,65,0,15,'46.8800'),(48,4,60,0,16,'3749.5000'),(49,4,61,0,16,'3450.0000'),(50,4,65,0,16,'0.0000'),(51,4,60,0,17,'3749.5000'),(52,4,61,0,17,'3450.0000'),(53,4,65,0,17,'0.0000'),(54,4,60,0,18,'3749.5000'),(55,4,61,0,18,'3450.0000'),(56,4,65,0,18,'0.0000'),(57,4,60,0,19,'3749.5000'),(58,4,61,0,19,'3450.0000'),(59,4,65,0,19,'0.0000'),(60,4,60,0,20,'3749.5000'),(61,4,61,0,20,'3450.0000'),(62,4,65,0,20,'0.0000'),(63,4,60,0,21,'3749.5000'),(64,4,61,0,21,'3450.0000'),(65,4,65,0,21,'0.0000'),(66,4,60,0,22,'3749.5000'),(67,4,61,0,22,'3450.0000'),(68,4,65,0,22,'0.0000'),(69,4,60,0,23,'3749.5000'),(70,4,61,0,23,'3450.0000'),(71,4,65,0,23,'9999.9900'),(72,4,60,0,24,'3749.5000'),(73,4,61,0,24,'3450.0000'),(74,4,65,0,24,'62.5000'),(75,4,60,0,25,'3749.5000'),(76,4,61,0,25,'3450.0000'),(77,4,65,0,25,'0.0000'),(78,4,60,0,26,'3749.5000'),(79,4,61,0,26,'3450.0000'),(80,4,65,0,26,'0.0000'),(81,4,60,0,27,'3749.5000'),(82,4,61,0,27,'3450.0000'),(83,4,65,0,27,'0.0000'),(84,4,60,0,28,'3749.5000'),(85,4,61,0,28,'3450.0000'),(86,4,65,0,28,'71.8800'),(87,4,60,0,29,'3749.5000'),(88,4,61,0,29,'3450.0000'),(89,4,65,0,29,'9999.9900'),(90,4,60,0,30,'3749.5000'),(91,4,61,0,30,'3450.0000'),(92,4,65,0,30,'0.0000'),(93,4,60,0,31,'3749.5000'),(94,4,61,0,31,'3450.0000'),(95,4,65,0,31,'0.0000'),(96,4,60,0,32,'3749.5000'),(97,4,61,0,32,'3450.0000'),(98,4,65,0,32,'46.8800'),(99,4,60,0,33,'3749.5000'),(100,4,61,0,33,'3450.0000'),(101,4,65,0,33,'0.0000'),(102,4,60,0,34,'3749.5000'),(103,4,61,0,34,'3450.0000'),(104,4,65,0,34,'0.0000'),(105,4,60,0,35,'3749.5000'),(106,4,61,0,35,'3450.0000'),(107,4,65,0,35,'50.0000'),(108,4,60,0,36,'3749.5000'),(109,4,61,0,36,'3450.0000'),(110,4,65,0,36,'59.3800'),(111,4,60,0,37,'3749.5000'),(112,4,61,0,37,'3450.0000'),(113,4,65,0,37,'0.0000'),(114,4,60,0,38,'3749.5000'),(115,4,61,0,38,'3450.0000'),(116,4,65,0,38,'0.0000'),(117,4,60,0,39,'3749.5000'),(118,4,61,0,39,'3450.0000'),(119,4,65,0,39,'0.0000'),(120,4,60,0,40,'3749.5000'),(121,4,61,0,40,'3450.0000'),(122,4,65,0,40,'0.0000'),(123,4,60,0,41,'3749.5000'),(124,4,61,0,41,'3450.0000'),(125,4,65,0,41,'0.0000'),(126,4,60,0,42,'3749.5000'),(127,4,61,0,42,'3450.0000'),(128,4,65,0,42,'0.0000'),(129,4,60,0,43,'3749.5000'),(130,4,61,0,43,'3450.0000'),(131,4,65,0,43,'0.0000'),(132,4,60,0,44,'3749.5000'),(133,4,61,0,44,'3450.0000'),(134,4,65,0,44,'0.0000'),(135,4,60,0,45,'3749.5000'),(136,4,61,0,45,'3450.0000'),(137,4,65,0,45,'0.0000'),(138,4,60,0,46,'3749.5000'),(139,4,61,0,46,'3450.0000'),(140,4,65,0,46,'71.8800'),(141,4,60,0,47,'3749.5000'),(142,4,61,0,47,'3450.0000'),(143,4,65,0,47,'0.0000'),(144,4,60,0,48,'3749.5000'),(145,4,61,0,48,'3450.0000'),(146,4,65,0,48,'0.0000'),(147,4,60,0,49,'1000.0000'),(148,4,61,0,49,'920.0000'),(149,4,65,0,49,'88.1300'),(150,4,60,0,50,'1247.5000'),(151,4,61,0,50,'1148.0000'),(152,4,65,0,50,'12.5000'),(153,4,60,0,51,'297.5000'),(154,4,61,0,51,'274.0000'),(155,4,65,0,51,'0.0000'),(156,4,60,0,52,'497.5000'),(157,4,61,0,52,'458.0000'),(158,4,65,0,52,'0.0000'),(159,4,60,0,53,'1249.5000'),(160,4,61,0,53,'1150.0000'),(161,4,65,0,53,'0.0000'),(162,4,60,0,54,'1100.0000'),(163,4,61,0,54,'1012.0000'),(164,4,65,0,54,'0.0000'),(165,4,60,0,55,'575.0000'),(166,4,61,0,55,'529.0000'),(167,4,65,0,55,'0.0000'),(168,4,60,0,56,'1670.0000'),(169,4,61,0,56,'1536.0000'),(170,4,65,0,56,'0.0000'),(171,4,60,0,57,'630.0000'),(172,4,61,0,57,'580.0000'),(173,4,65,0,57,'0.0000'),(174,4,60,0,58,'4500.0000'),(175,4,61,0,58,'4140.0000'),(176,4,65,0,58,'0.0000'),(177,4,60,0,59,'1425.0000'),(178,4,61,0,59,'1311.0000'),(179,4,65,0,59,'0.0000'),(180,4,60,0,60,'2065.0000'),(181,4,61,0,60,'1900.0000'),(182,4,65,0,60,'0.0000'),(183,4,60,0,61,'499.5000'),(184,4,61,0,61,'460.0000'),(185,4,65,0,61,'45.0000'),(186,4,60,0,62,'649.5000'),(187,4,61,0,62,'598.0000'),(188,4,65,0,62,'0.0000'),(189,4,60,0,63,'5200.0000'),(190,4,61,0,63,'4784.0000'),(191,4,65,0,63,'0.0000'),(192,4,60,0,64,'497.5000'),(193,4,61,0,64,'458.0000'),(194,4,65,0,64,'0.0000'),(195,4,60,0,65,'575.0000'),(196,4,61,0,65,'529.0000'),(197,4,65,0,65,'0.0000'),(198,4,60,0,66,'3150.0000'),(199,4,61,0,66,'2898.0000'),(200,4,65,0,66,'143.7500'),(201,4,60,0,67,'605.0000'),(202,4,61,0,67,'557.0000'),(203,4,65,0,67,'12.5000'),(204,4,60,0,68,'1810.0000'),(205,4,61,0,68,'1665.0000'),(206,4,65,0,68,'60.6300'),(207,4,60,0,69,'1670.0000'),(208,4,61,0,69,'1536.0000'),(209,4,65,0,69,'82.5000'),(210,4,60,0,70,'1900.0000'),(211,4,61,0,70,'1748.0000'),(212,4,65,0,70,'94.3800'),(213,4,60,0,71,'1210.0000'),(214,4,61,0,71,'1113.0000'),(215,4,65,0,71,'59.3800'),(216,4,60,0,72,'1280.0000'),(217,4,61,0,72,'1178.0000'),(218,4,65,0,72,'59.3800'),(219,4,60,0,73,'1260.0000'),(220,4,61,0,73,'1159.0000'),(221,4,65,0,73,'56.2500'),(222,4,60,0,74,'1430.0000'),(223,4,61,0,74,'1316.0000'),(224,4,65,0,74,'62.5000'),(225,4,60,0,75,'1340.0000'),(226,4,61,0,75,'1233.0000'),(227,4,65,0,75,'60.6300'),(228,4,60,0,76,'1425.0000'),(229,4,61,0,76,'1311.0000'),(230,4,65,0,76,'68.7500'),(231,4,60,0,77,'1725.0000'),(232,4,61,0,77,'1587.0000'),(233,4,65,0,77,'65.6300'),(234,4,60,0,78,'2300.0000'),(235,4,61,0,78,'2116.0000'),(236,4,65,0,78,'0.0000'),(237,4,60,0,79,'2155.0000'),(238,4,61,0,79,'1983.0000'),(239,4,65,0,79,'101.8800'),(240,4,60,0,80,'1620.0000'),(241,4,61,0,80,'1490.0000'),(242,4,65,0,80,'41.2500'),(243,4,60,0,81,'805.0000'),(244,4,61,0,81,'741.0000'),(245,4,65,0,81,'37.5000'),(246,4,60,0,82,'1840.0000'),(247,4,61,0,82,'1693.0000'),(248,4,65,0,82,'0.0000'),(249,4,60,0,83,'1650.0000'),(250,4,61,0,83,'1518.0000'),(251,4,65,0,83,'71.8800'),(252,4,60,0,84,'1100.0000'),(253,4,61,0,84,'1012.0000'),(254,4,65,0,84,'50.0000'),(255,4,60,0,85,'1620.0000'),(256,4,61,0,85,'1490.0000'),(257,4,65,0,85,'49.3800'),(258,4,60,0,86,'690.0000'),(259,4,61,0,86,'635.0000'),(260,4,65,0,86,'34.3800'),(261,4,60,0,87,'1750.0000'),(262,4,61,0,87,'1610.0000'),(263,4,65,0,87,'71.8800'),(264,4,60,0,88,'2125.0000'),(265,4,61,0,88,'1955.0000'),(266,4,65,0,88,'81.2500'),(267,4,60,0,89,'1250.0000'),(268,4,61,0,89,'1150.0000'),(269,4,65,0,89,'59.3800'),(270,4,60,0,90,'550.0000'),(271,4,61,0,90,'506.0000'),(272,4,65,0,90,'16.2500'),(273,4,60,0,91,'2500.0000'),(274,4,61,0,91,'2300.0000'),(275,4,65,0,91,'98.7500'),(276,4,60,0,92,'800.0000'),(277,4,61,0,92,'736.0000'),(278,4,65,0,92,'0.0000'),(279,4,60,0,93,'1400.0000'),(280,4,61,0,93,'1288.0000'),(281,4,65,0,93,'0.0000'),(282,4,60,0,94,'550.0000'),(283,4,61,0,94,'506.0000'),(284,4,65,0,94,'0.0000'),(285,4,60,0,95,'550.0000'),(286,4,61,0,95,'506.0000'),(287,4,65,0,95,'0.0000'),(288,4,60,0,96,'550.0000'),(289,4,61,0,96,'506.0000'),(290,4,65,0,96,'0.0000'),(291,4,60,0,97,'550.0000'),(292,4,61,0,97,'506.0000'),(293,4,65,0,97,'0.0000'),(294,4,60,0,98,'550.0000'),(295,4,61,0,98,'506.0000'),(296,4,65,0,98,'0.0000'),(297,4,60,0,99,'550.0000'),(298,4,61,0,99,'506.0000'),(299,4,65,0,99,'0.0000'),(300,4,60,0,100,'550.0000'),(301,4,61,0,100,'506.0000'),(302,4,65,0,100,'0.0000');
/*!40000 ALTER TABLE `catalog_product_entity_decimal` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalog_product_entity_gallery`
--

DROP TABLE IF EXISTS `catalog_product_entity_gallery`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalog_product_entity_gallery` (
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
  KEY `FK_CATALOG_CATEGORY_ENTITY_GALLERY_STORE` (`store_id`),
  CONSTRAINT `FK_CATALOG_PRODUCT_ENTITY_GALLERY_ATTRIBUTE` FOREIGN KEY (`attribute_id`) REFERENCES `eav_attribute` (`attribute_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CATALOG_PRODUCT_ENTITY_GALLERY_ENTITY` FOREIGN KEY (`entity_id`) REFERENCES `catalog_product_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CATALOG_PRODUCT_ENTITY_GALLERY_STORE` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalog_product_entity_gallery`
--

LOCK TABLES `catalog_product_entity_gallery` WRITE;
/*!40000 ALTER TABLE `catalog_product_entity_gallery` DISABLE KEYS */;
/*!40000 ALTER TABLE `catalog_product_entity_gallery` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalog_product_entity_int`
--

DROP TABLE IF EXISTS `catalog_product_entity_int`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalog_product_entity_int` (
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
  KEY `FK_CATALOG_PRODUCT_ENTITY_INT_PRODUCT_ENTITY` (`entity_id`),
  CONSTRAINT `FK_CATALOG_PRODUCT_ENTITY_INT_ATTRIBUTE` FOREIGN KEY (`attribute_id`) REFERENCES `eav_attribute` (`attribute_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CATALOG_PRODUCT_ENTITY_INT_PRODUCT_ENTITY` FOREIGN KEY (`entity_id`) REFERENCES `catalog_product_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CATALOG_PRODUCT_ENTITY_INT_STORE` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=506 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalog_product_entity_int`
--

LOCK TABLES `catalog_product_entity_int` WRITE;
/*!40000 ALTER TABLE `catalog_product_entity_int` DISABLE KEYS */;
INSERT INTO `catalog_product_entity_int` VALUES (6,4,80,0,1,1),(7,4,81,0,1,0),(8,4,85,0,1,4),(9,4,467,0,1,1),(10,4,508,0,1,0),(11,4,80,0,2,1),(12,4,81,0,2,0),(13,4,85,0,2,4),(14,4,467,0,2,1),(15,4,508,0,2,0),(16,4,80,0,3,1),(17,4,81,0,3,0),(18,4,85,0,3,4),(19,4,467,0,3,1),(20,4,508,0,3,0),(21,4,80,0,4,1),(22,4,81,0,4,0),(23,4,85,0,4,4),(24,4,467,0,4,1),(25,4,508,0,4,0),(26,4,80,0,5,1),(27,4,81,0,5,0),(28,4,85,0,5,4),(29,4,467,0,5,1),(30,4,508,0,5,0),(31,4,80,0,6,1),(32,4,81,0,6,0),(33,4,85,0,6,4),(34,4,467,0,6,1),(35,4,508,0,6,0),(36,4,80,0,7,1),(37,4,81,0,7,0),(38,4,85,0,7,4),(39,4,467,0,7,1),(40,4,508,0,7,0),(41,4,80,0,8,1),(42,4,81,0,8,0),(43,4,85,0,8,4),(44,4,467,0,8,1),(45,4,508,0,8,0),(46,4,80,0,9,1),(47,4,81,0,9,0),(48,4,85,0,9,4),(49,4,467,0,9,1),(50,4,508,0,9,0),(51,4,80,0,10,1),(52,4,81,0,10,0),(53,4,85,0,10,4),(54,4,467,0,10,1),(55,4,508,0,10,0),(56,4,80,0,11,1),(57,4,81,0,11,0),(58,4,85,0,11,4),(59,4,467,0,11,1),(60,4,508,0,11,0),(61,4,80,0,12,1),(62,4,81,0,12,0),(63,4,85,0,12,4),(64,4,467,0,12,1),(65,4,508,0,12,0),(66,4,80,0,13,1),(67,4,81,0,13,0),(68,4,85,0,13,4),(69,4,467,0,13,1),(70,4,508,0,13,0),(71,4,80,0,14,1),(72,4,81,0,14,0),(73,4,85,0,14,4),(74,4,467,0,14,1),(75,4,508,0,14,0),(76,4,80,0,15,1),(77,4,81,0,15,0),(78,4,85,0,15,4),(79,4,467,0,15,1),(80,4,508,0,15,0),(81,4,80,0,16,1),(82,4,81,0,16,0),(83,4,85,0,16,4),(84,4,467,0,16,1),(85,4,508,0,16,0),(86,4,80,0,17,1),(87,4,81,0,17,0),(88,4,85,0,17,4),(89,4,467,0,17,1),(90,4,508,0,17,0),(91,4,80,0,18,1),(92,4,81,0,18,0),(93,4,85,0,18,4),(94,4,467,0,18,1),(95,4,508,0,18,0),(96,4,80,0,19,1),(97,4,81,0,19,0),(98,4,85,0,19,4),(99,4,467,0,19,1),(100,4,508,0,19,0),(101,4,80,0,20,1),(102,4,81,0,20,0),(103,4,85,0,20,4),(104,4,467,0,20,1),(105,4,508,0,20,0),(106,4,80,0,21,1),(107,4,81,0,21,0),(108,4,85,0,21,4),(109,4,467,0,21,1),(110,4,508,0,21,0),(111,4,80,0,22,1),(112,4,81,0,22,0),(113,4,85,0,22,4),(114,4,467,0,22,1),(115,4,508,0,22,0),(116,4,80,0,23,1),(117,4,81,0,23,0),(118,4,85,0,23,4),(119,4,467,0,23,1),(120,4,508,0,23,0),(121,4,80,0,24,1),(122,4,81,0,24,0),(123,4,85,0,24,4),(124,4,467,0,24,1),(125,4,508,0,24,0),(126,4,80,0,25,1),(127,4,81,0,25,0),(128,4,85,0,25,4),(129,4,467,0,25,1),(130,4,508,0,25,0),(131,4,80,0,26,1),(132,4,81,0,26,0),(133,4,85,0,26,4),(134,4,467,0,26,1),(135,4,508,0,26,0),(136,4,80,0,27,1),(137,4,81,0,27,0),(138,4,85,0,27,4),(139,4,467,0,27,1),(140,4,508,0,27,0),(141,4,80,0,28,1),(142,4,81,0,28,0),(143,4,85,0,28,4),(144,4,467,0,28,1),(145,4,508,0,28,0),(146,4,80,0,29,1),(147,4,81,0,29,0),(148,4,85,0,29,4),(149,4,467,0,29,1),(150,4,508,0,29,0),(151,4,80,0,30,1),(152,4,81,0,30,0),(153,4,85,0,30,4),(154,4,467,0,30,1),(155,4,508,0,30,0),(156,4,80,0,31,1),(157,4,81,0,31,0),(158,4,85,0,31,4),(159,4,467,0,31,1),(160,4,508,0,31,0),(161,4,80,0,32,1),(162,4,81,0,32,0),(163,4,85,0,32,4),(164,4,467,0,32,1),(165,4,508,0,32,0),(166,4,80,0,33,1),(167,4,81,0,33,0),(168,4,85,0,33,4),(169,4,467,0,33,1),(170,4,508,0,33,0),(171,4,80,0,34,1),(172,4,81,0,34,0),(173,4,85,0,34,4),(174,4,467,0,34,1),(175,4,508,0,34,0),(176,4,80,0,35,1),(177,4,81,0,35,0),(178,4,85,0,35,4),(179,4,467,0,35,1),(180,4,508,0,35,0),(181,4,80,0,36,1),(182,4,81,0,36,0),(183,4,85,0,36,4),(184,4,467,0,36,1),(185,4,508,0,36,0),(186,4,80,0,37,1),(187,4,81,0,37,0),(188,4,85,0,37,4),(189,4,467,0,37,1),(190,4,508,0,37,0),(191,4,80,0,38,1),(192,4,81,0,38,0),(193,4,85,0,38,4),(194,4,467,0,38,1),(195,4,508,0,38,0),(196,4,80,0,39,1),(197,4,81,0,39,0),(198,4,85,0,39,4),(199,4,467,0,39,1),(200,4,508,0,39,0),(201,4,80,0,40,1),(202,4,81,0,40,0),(203,4,85,0,40,4),(204,4,467,0,40,1),(205,4,508,0,40,0),(206,4,80,0,41,1),(207,4,81,0,41,0),(208,4,85,0,41,4),(209,4,467,0,41,1),(210,4,508,0,41,0),(211,4,80,0,42,1),(212,4,81,0,42,0),(213,4,85,0,42,4),(214,4,467,0,42,1),(215,4,508,0,42,0),(216,4,80,0,43,1),(217,4,81,0,43,0),(218,4,85,0,43,4),(219,4,467,0,43,1),(220,4,508,0,43,0),(221,4,80,0,44,1),(222,4,81,0,44,0),(223,4,85,0,44,4),(224,4,467,0,44,1),(225,4,508,0,44,0),(226,4,80,0,45,1),(227,4,81,0,45,0),(228,4,85,0,45,4),(229,4,467,0,45,1),(230,4,508,0,45,0),(231,4,80,0,46,1),(232,4,81,0,46,0),(233,4,85,0,46,4),(234,4,467,0,46,1),(235,4,508,0,46,0),(236,4,80,0,47,1),(237,4,81,0,47,0),(238,4,85,0,47,4),(239,4,467,0,47,1),(240,4,508,0,47,0),(241,4,80,0,48,1),(242,4,81,0,48,0),(243,4,85,0,48,4),(244,4,467,0,48,1),(245,4,508,0,48,0),(246,4,80,0,49,1),(247,4,81,0,49,0),(248,4,85,0,49,4),(249,4,467,0,49,1),(250,4,508,0,49,0),(251,4,80,0,50,1),(252,4,81,0,50,0),(253,4,85,0,50,4),(254,4,467,0,50,1),(255,4,508,0,50,0),(256,4,80,0,51,1),(257,4,81,0,51,0),(258,4,85,0,51,4),(259,4,467,0,51,1),(260,4,508,0,51,0),(261,4,80,0,52,1),(262,4,81,0,52,0),(263,4,85,0,52,4),(264,4,467,0,52,1),(265,4,508,0,52,0),(266,4,80,0,53,1),(267,4,81,0,53,0),(268,4,85,0,53,4),(269,4,467,0,53,1),(270,4,508,0,53,0),(271,4,80,0,54,1),(272,4,81,0,54,0),(273,4,85,0,54,4),(274,4,467,0,54,1),(275,4,508,0,54,0),(276,4,80,0,55,1),(277,4,81,0,55,0),(278,4,85,0,55,4),(279,4,467,0,55,1),(280,4,508,0,55,0),(281,4,80,0,56,1),(282,4,81,0,56,0),(283,4,85,0,56,4),(284,4,467,0,56,1),(285,4,508,0,56,0),(286,4,80,0,57,1),(287,4,81,0,57,0),(288,4,85,0,57,4),(289,4,467,0,57,1),(290,4,508,0,57,0),(291,4,80,0,58,1),(292,4,81,0,58,0),(293,4,85,0,58,4),(294,4,467,0,58,1),(295,4,508,0,58,0),(296,4,80,0,59,1),(297,4,81,0,59,0),(298,4,85,0,59,4),(299,4,467,0,59,1),(300,4,508,0,59,0),(301,4,80,0,60,1),(302,4,81,0,60,0),(303,4,85,0,60,4),(304,4,467,0,60,1),(305,4,508,0,60,0),(306,4,80,0,61,1),(307,4,81,0,61,0),(308,4,85,0,61,4),(309,4,467,0,61,1),(310,4,508,0,61,0),(311,4,80,0,62,1),(312,4,81,0,62,0),(313,4,85,0,62,4),(314,4,467,0,62,1),(315,4,508,0,62,0),(316,4,80,0,63,1),(317,4,81,0,63,0),(318,4,85,0,63,4),(319,4,467,0,63,1),(320,4,508,0,63,0),(321,4,80,0,64,1),(322,4,81,0,64,0),(323,4,85,0,64,4),(324,4,467,0,64,1),(325,4,508,0,64,0),(326,4,80,0,65,1),(327,4,81,0,65,0),(328,4,85,0,65,4),(329,4,467,0,65,1),(330,4,508,0,65,0),(331,4,80,0,66,1),(332,4,81,0,66,0),(333,4,85,0,66,4),(334,4,467,0,66,1),(335,4,508,0,66,0),(336,4,80,0,67,1),(337,4,81,0,67,0),(338,4,85,0,67,4),(339,4,467,0,67,1),(340,4,508,0,67,0),(341,4,80,0,68,1),(342,4,81,0,68,0),(343,4,85,0,68,4),(344,4,467,0,68,1),(345,4,508,0,68,0),(346,4,80,0,69,1),(347,4,81,0,69,0),(348,4,85,0,69,4),(349,4,467,0,69,1),(350,4,508,0,69,0),(351,4,80,0,70,1),(352,4,81,0,70,0),(353,4,85,0,70,4),(354,4,467,0,70,1),(355,4,508,0,70,0),(356,4,80,0,71,1),(357,4,81,0,71,0),(358,4,85,0,71,4),(359,4,467,0,71,1),(360,4,508,0,71,0),(361,4,80,0,72,1),(362,4,81,0,72,0),(363,4,85,0,72,4),(364,4,467,0,72,1),(365,4,508,0,72,0),(366,4,80,0,73,1),(367,4,81,0,73,0),(368,4,85,0,73,4),(369,4,467,0,73,1),(370,4,508,0,73,0),(371,4,80,0,74,1),(372,4,81,0,74,0),(373,4,85,0,74,4),(374,4,467,0,74,1),(375,4,508,0,74,0),(376,4,80,0,75,1),(377,4,81,0,75,0),(378,4,85,0,75,4),(379,4,467,0,75,1),(380,4,508,0,75,0),(381,4,80,0,76,1),(382,4,81,0,76,0),(383,4,85,0,76,4),(384,4,467,0,76,1),(385,4,508,0,76,0),(386,4,80,0,77,1),(387,4,81,0,77,0),(388,4,85,0,77,4),(389,4,467,0,77,1),(390,4,508,0,77,0),(391,4,80,0,78,1),(392,4,81,0,78,0),(393,4,85,0,78,4),(394,4,467,0,78,1),(395,4,508,0,78,0),(396,4,80,0,79,1),(397,4,81,0,79,0),(398,4,85,0,79,4),(399,4,467,0,79,1),(400,4,508,0,79,0),(401,4,80,0,80,1),(402,4,81,0,80,0),(403,4,85,0,80,4),(404,4,467,0,80,1),(405,4,508,0,80,0),(406,4,80,0,81,1),(407,4,81,0,81,0),(408,4,85,0,81,4),(409,4,467,0,81,1),(410,4,508,0,81,0),(411,4,80,0,82,1),(412,4,81,0,82,0),(413,4,85,0,82,4),(414,4,467,0,82,1),(415,4,508,0,82,0),(416,4,80,0,83,1),(417,4,81,0,83,0),(418,4,85,0,83,4),(419,4,467,0,83,1),(420,4,508,0,83,0),(421,4,80,0,84,1),(422,4,81,0,84,0),(423,4,85,0,84,4),(424,4,467,0,84,1),(425,4,508,0,84,0),(426,4,80,0,85,1),(427,4,81,0,85,0),(428,4,85,0,85,4),(429,4,467,0,85,1),(430,4,508,0,85,0),(431,4,80,0,86,1),(432,4,81,0,86,0),(433,4,85,0,86,4),(434,4,467,0,86,1),(435,4,508,0,86,0),(436,4,80,0,87,1),(437,4,81,0,87,0),(438,4,85,0,87,4),(439,4,467,0,87,1),(440,4,508,0,87,0),(441,4,80,0,88,1),(442,4,81,0,88,0),(443,4,85,0,88,4),(444,4,467,0,88,1),(445,4,508,0,88,0),(446,4,80,0,89,1),(447,4,81,0,89,0),(448,4,85,0,89,4),(449,4,467,0,89,1),(450,4,508,0,89,0),(451,4,80,0,90,1),(452,4,81,0,90,0),(453,4,85,0,90,4),(454,4,467,0,90,1),(455,4,508,0,90,0),(456,4,80,0,91,1),(457,4,81,0,91,0),(458,4,85,0,91,4),(459,4,467,0,91,1),(460,4,508,0,91,0),(461,4,80,0,92,1),(462,4,81,0,92,0),(463,4,85,0,92,4),(464,4,467,0,92,1),(465,4,508,0,92,0),(466,4,80,0,93,1),(467,4,81,0,93,0),(468,4,85,0,93,4),(469,4,467,0,93,1),(470,4,508,0,93,0),(471,4,80,0,94,1),(472,4,81,0,94,0),(473,4,85,0,94,4),(474,4,467,0,94,1),(475,4,508,0,94,0),(476,4,80,0,95,1),(477,4,81,0,95,0),(478,4,85,0,95,4),(479,4,467,0,95,1),(480,4,508,0,95,0),(481,4,80,0,96,1),(482,4,81,0,96,0),(483,4,85,0,96,4),(484,4,467,0,96,1),(485,4,508,0,96,0),(486,4,80,0,97,1),(487,4,81,0,97,0),(488,4,85,0,97,4),(489,4,467,0,97,1),(490,4,508,0,97,0),(491,4,80,0,98,1),(492,4,81,0,98,0),(493,4,85,0,98,4),(494,4,467,0,98,1),(495,4,508,0,98,0),(496,4,80,0,99,1),(497,4,81,0,99,0),(498,4,85,0,99,4),(499,4,467,0,99,1),(500,4,508,0,99,0),(501,4,80,0,100,1),(502,4,81,0,100,0),(503,4,85,0,100,4),(504,4,467,0,100,1),(505,4,508,0,100,0);
/*!40000 ALTER TABLE `catalog_product_entity_int` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalog_product_entity_media_gallery`
--

DROP TABLE IF EXISTS `catalog_product_entity_media_gallery`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalog_product_entity_media_gallery` (
  `value_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `attribute_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `entity_id` int(10) unsigned NOT NULL DEFAULT '0',
  `value` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`value_id`),
  KEY `FK_CATALOG_PRODUCT_MEDIA_GALLERY_ATTRIBUTE` (`attribute_id`),
  KEY `FK_CATALOG_PRODUCT_MEDIA_GALLERY_ENTITY` (`entity_id`),
  CONSTRAINT `FK_CATALOG_PRODUCT_MEDIA_GALLERY_ATTRIBUTE` FOREIGN KEY (`attribute_id`) REFERENCES `eav_attribute` (`attribute_id`) ON DELETE CASCADE,
  CONSTRAINT `FK_CATALOG_PRODUCT_MEDIA_GALLERY_ENTITY` FOREIGN KEY (`entity_id`) REFERENCES `catalog_product_entity` (`entity_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=102 DEFAULT CHARSET=utf8 COMMENT='Catalog product media gallery';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalog_product_entity_media_gallery`
--

LOCK TABLES `catalog_product_entity_media_gallery` WRITE;
/*!40000 ALTER TABLE `catalog_product_entity_media_gallery` DISABLE KEYS */;
INSERT INTO `catalog_product_entity_media_gallery` VALUES (2,73,1,'/P/2/P20030099690202.jpg'),(3,73,2,'/C/6/C60073999668766.jpg'),(4,73,3,'/D/6/D60634337008486.jpg'),(5,73,4,'/U/0/U00690249442220.jpg'),(6,73,5,'/M/4/M40690249442244.jpg'),(7,73,6,'/N/1/N10765762013001.jpg'),(8,73,7,'/O/1/O10765762060401.jpg'),(9,73,8,'/O/8/O80765762072008.jpg'),(10,73,9,'/M/1/M10765762092501.jpg'),(11,73,10,'/G/9/G90765762101609.jpg'),(12,73,11,'/J/0/J00765762106000.jpg'),(13,73,12,'/X/4/X40765762108004.jpg'),(14,73,13,'/D/6/D60765762112506.jpg'),(15,73,14,'/R/6/R60765762114906.jpg'),(16,73,15,'/M/6/M60765762119406.jpg'),(17,73,16,'/M/1/M10765762119901.jpg'),(18,73,17,'/C/7/C70765762127807.jpg'),(19,73,18,'/B/2/B20765762132702.jpg'),(20,73,19,'/B/1/B10765762132801.jpg'),(21,73,20,'/B/0/B00765762132900.jpg'),(22,73,21,'/M/3/M30765762133303.jpg'),(23,73,22,'/M/0/M00765762133600.jpg'),(24,73,23,'/E/8/E80765762133808.jpg'),(25,73,24,'/X/1/X10765762134201.jpg'),(26,73,25,'/P/9/P90765762134409.jpg'),(27,73,26,'/P/8/P80765762134508.jpg'),(28,73,27,'/P/7/P70765762134607.jpg'),(29,73,28,'/P/6/P60765762134706.jpg'),(30,73,29,'/P/5/P50765762134805.jpg'),(31,73,30,'/P/4/P40765762134904.jpg'),(32,73,31,'/I/0/I00765762135000.jpg'),(33,73,32,'/A/9/A90765762135109.jpg'),(34,73,33,'/A/8/A80765762135208.jpg'),(35,73,34,'/A/7/A70765762135307.jpg'),(36,73,35,'/A/6/A60765762135406.jpg'),(37,73,36,'/A/5/A50765762135505.jpg'),(38,73,37,'/A/3/A30765762135703.jpg'),(39,73,38,'/L/7/L70765762136007.jpg'),(40,73,39,'/L/3/L30765762136403.jpg'),(41,73,40,'/L/2/L20765762136502.jpg'),(42,73,41,'/D/9/D90765762136809.jpg'),(43,73,42,'/W/4/W40765762137004.jpg'),(44,73,43,'/W/3/W30765762137103.jpg'),(45,73,44,'/W/2/W20765762137202.jpg'),(46,73,45,'/W/1/W10765762137301.jpg'),(47,73,46,'/K/0/K00765762139800.jpg'),(48,73,47,'/Z/3/Z30765762140103.jpg'),(49,73,48,'/Z/0/Z00765762140400.jpg'),(50,73,49,'/Y/8/Y80765762155008.jpg'),(51,73,50,'/S/0/S00796279109260.jpg'),(52,73,51,'/W/6/W60978082568186.jpg'),(53,73,52,'/E/1/E10978089125351.jpg'),(54,73,53,'/L/2/L20978144380572.jpg'),(55,73,54,'/A/7/A71116090014687.jpg'),(56,73,55,'/Z/5/Z51200600710005.jpg'),(57,73,56,'/J/9/J92010000001189.jpg'),(58,73,57,'/E/5/E54711213292675.jpg'),(59,73,58,'/Z/6/Z64713482004256.jpg'),(60,73,59,'/C/5/C54717702066765.jpg'),(61,73,60,'/C/6/C64717702228606.jpg'),(62,73,61,'/N/6/N66006937084346.jpg'),(63,73,62,'/S/7/S76006937084377.jpg'),(64,73,63,'/I/1/I17835150933921.jpg'),(65,73,64,'/Z/9/Z98033772895149.jpg'),(66,73,65,'/S/3/S38932000113713.jpg'),(67,73,66,'/B/9/B98934661181209.jpg'),(68,73,67,'/L/2/L28934974008972.jpg'),(69,73,68,'/U/0/U08934974048480.jpg'),(70,73,69,'/Z/4/Z48934974048794.jpg'),(71,73,70,'/P/3/P38934974055143.jpg'),(72,73,71,'/W/0/W08934974061670.jpg'),(73,73,72,'/N/8/N88934974063308.jpg'),(74,73,73,'/X/6/X68934974068976.jpg'),(75,73,74,'/O/0/O08934974072720.jpg'),(76,73,75,'/O/5/O58934974072805.jpg'),(77,73,76,'/Z/9/Z98934974073109.jpg'),(78,73,77,'/A/2/A28934974075912.jpg'),(79,73,78,'/V/8/V88934974076278.jpg'),(80,73,79,'/N/7/N78934974076797.jpg'),(81,73,80,'/Y/3/Y38934974076803.jpg'),(82,73,81,'/D/3/D38934974076933.jpg'),(83,73,82,'/N/5/N58934974076995.jpg'),(84,73,83,'/G/7/G78934974077657.jpg'),(85,73,84,'/G/1/G18934974077671.jpg'),(86,73,85,'/R/8/R88934974078258.jpg'),(87,73,86,'/P/6/P68934974079446.jpg'),(88,73,87,'/R/6/R68934974080336.jpg'),(89,73,88,'/H/7/H78934974081067.jpg'),(90,73,89,'/N/0/N08934974082910.jpg'),(91,73,90,'/S/7/S78934974082927.jpg'),(92,73,91,'/M/1/M18934974085911.jpg'),(93,73,92,'/C/6/C68934974086246.jpg'),(94,73,93,'/T/0/T08934974089780.jpg'),(95,73,94,'/L/6/L68935036602206.jpg'),(96,73,95,'/Y/3/Y38935036602213.jpg'),(97,73,96,'/L/0/L08935036602220.jpg'),(98,73,97,'/D/4/D48935036602244.jpg'),(99,73,98,'/Q/1/Q18935036602251.jpg'),(100,73,99,'/V/8/V88935036602268.jpg'),(101,73,100,'/I/5/I58935036602275.jpg');
/*!40000 ALTER TABLE `catalog_product_entity_media_gallery` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalog_product_entity_media_gallery_value`
--

DROP TABLE IF EXISTS `catalog_product_entity_media_gallery_value`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalog_product_entity_media_gallery_value` (
  `value_id` int(11) unsigned NOT NULL DEFAULT '0',
  `store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `label` varchar(255) DEFAULT NULL,
  `position` int(11) unsigned DEFAULT NULL,
  `disabled` tinyint(1) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`value_id`,`store_id`),
  KEY `FK_CATALOG_PRODUCT_MEDIA_GALLERY_VALUE_STORE` (`store_id`),
  CONSTRAINT `FK_CATALOG_PRODUCT_MEDIA_GALLERY_VALUE_GALLERY` FOREIGN KEY (`value_id`) REFERENCES `catalog_product_entity_media_gallery` (`value_id`) ON DELETE CASCADE,
  CONSTRAINT `FK_CATALOG_PRODUCT_MEDIA_GALLERY_VALUE_STORE` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Catalog product media gallery values';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalog_product_entity_media_gallery_value`
--

LOCK TABLES `catalog_product_entity_media_gallery_value` WRITE;
/*!40000 ALTER TABLE `catalog_product_entity_media_gallery_value` DISABLE KEYS */;
INSERT INTO `catalog_product_entity_media_gallery_value` VALUES (1,0,NULL,1,0),(2,0,NULL,1,0),(3,0,NULL,1,0),(4,0,NULL,1,0),(5,0,NULL,1,0),(6,0,NULL,1,0),(7,0,NULL,1,0),(8,0,NULL,1,0),(9,0,NULL,1,0),(10,0,NULL,1,0),(11,0,NULL,1,0),(12,0,NULL,1,0),(13,0,NULL,1,0),(14,0,NULL,1,0),(15,0,NULL,1,0),(16,0,NULL,1,0),(17,0,NULL,1,0),(18,0,NULL,1,0),(19,0,NULL,1,0),(20,0,NULL,1,0),(21,0,NULL,1,0),(22,0,NULL,1,0),(23,0,NULL,1,0),(24,0,NULL,1,0),(25,0,NULL,1,0),(26,0,NULL,1,0),(27,0,NULL,1,0),(28,0,NULL,1,0),(29,0,NULL,1,0),(30,0,NULL,1,0),(31,0,NULL,1,0),(32,0,NULL,1,0),(33,0,NULL,1,0),(34,0,NULL,1,0),(35,0,NULL,1,0),(36,0,NULL,1,0),(37,0,NULL,1,0),(38,0,NULL,1,0),(39,0,NULL,1,0),(40,0,NULL,1,0),(41,0,NULL,1,0),(42,0,NULL,1,0),(43,0,NULL,1,0),(44,0,NULL,1,0),(45,0,NULL,1,0),(46,0,NULL,1,0),(47,0,NULL,1,0),(48,0,NULL,1,0),(49,0,NULL,1,0),(50,0,NULL,1,0),(51,0,NULL,1,0),(52,0,NULL,1,0),(53,0,NULL,1,0),(54,0,NULL,1,0),(55,0,NULL,1,0),(56,0,NULL,1,0),(57,0,NULL,1,0),(58,0,NULL,1,0),(59,0,NULL,1,0),(60,0,NULL,1,0),(61,0,NULL,1,0),(62,0,NULL,1,0),(63,0,NULL,1,0),(64,0,NULL,1,0),(65,0,NULL,1,0),(66,0,NULL,1,0),(67,0,NULL,1,0),(68,0,NULL,1,0),(69,0,NULL,1,0),(70,0,NULL,1,0),(71,0,NULL,1,0),(72,0,NULL,1,0),(73,0,NULL,1,0),(74,0,NULL,1,0),(75,0,NULL,1,0),(76,0,NULL,1,0),(77,0,NULL,1,0),(78,0,NULL,1,0),(79,0,NULL,1,0),(80,0,NULL,1,0),(81,0,NULL,1,0),(82,0,NULL,1,0),(83,0,NULL,1,0),(84,0,NULL,1,0),(85,0,NULL,1,0),(86,0,NULL,1,0),(87,0,NULL,1,0),(88,0,NULL,1,0),(89,0,NULL,1,0),(90,0,NULL,1,0),(91,0,NULL,1,0),(92,0,NULL,1,0),(93,0,NULL,1,0),(94,0,NULL,1,0),(95,0,NULL,1,0),(96,0,NULL,1,0),(97,0,NULL,1,0),(98,0,NULL,1,0),(99,0,NULL,1,0),(100,0,NULL,1,0);
/*!40000 ALTER TABLE `catalog_product_entity_media_gallery_value` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalog_product_entity_text`
--

DROP TABLE IF EXISTS `catalog_product_entity_text`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalog_product_entity_text` (
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
  KEY `FK_CATALOG_PRODUCT_ENTITY_TEXT_PRODUCT_ENTITY` (`entity_id`),
  CONSTRAINT `FK_CATALOG_PRODUCT_ENTITY_TEXT_ATTRIBUTE` FOREIGN KEY (`attribute_id`) REFERENCES `eav_attribute` (`attribute_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CATALOG_PRODUCT_ENTITY_TEXT_PRODUCT_ENTITY` FOREIGN KEY (`entity_id`) REFERENCES `catalog_product_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CATALOG_PRODUCT_ENTITY_TEXT_STORE` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=506 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalog_product_entity_text`
--

LOCK TABLES `catalog_product_entity_text` WRITE;
/*!40000 ALTER TABLE `catalog_product_entity_text` DISABLE KEYS */;
INSERT INTO `catalog_product_entity_text` VALUES (6,4,502,0,1,'Modern Publishing'),(7,4,57,0,1,'Disneys Camp Rock Mini Sticker Book with Stickers and activity pages\r\n'),(8,4,58,0,1,'Disneys Camp Rock Mini Sticker Book with Stickers and activity pages\r\n'),(9,4,68,0,1,''),(10,4,89,0,1,''),(11,4,502,0,2,'UAHC Press'),(12,4,57,0,2,'Tamar Bronstein Tamar Bronstein, for many years the Music Coordinator at North Shore Congregation Israel in Glencoe, Illinois, is the Founder-Director of the intergenerational Dor Vador Orchestra made up of talented young people and adults from the Chicago community. Over the years Tamar Bronstein has also utilized instrumental soloists and ensembles to teach and present programs for many organizations. In 1998-99, Tamar produced four television programs for Contempo TV selecting music and readings for the High Holidays, Chanukah, Passover, and Israel. She wrote \"Echoes, a cantata for the community observance of Kristallnacht and collaborated with her husband, Rabbi Herbert Bronstein, in a Hallel cantata \"We Shall Not Die But Live\" for confirmation. In addition to her compositions, Tamar as produced recordings as well as several educational programs. All express her desire to share the richness of the great Jewish legacy found in music.\r\n'),(13,4,58,0,2,'Tamar Bronstein Tamar Bronstein, for many years the Music Coordinator at North Shore Congregation Israel in Glencoe, Illinois, is the Founder-Director of the intergenerational Dor Vador Orchestra made up of talented young people and adults from the Chicago community. Over the years Tamar Bronstein has also utilized instrumental soloists and ensembles to teach and present programs for many organizations. In 1998-99, Tamar produced four television programs for Contempo TV selecting music and readings for the High Holidays, Chanukah, Passover, and Israel. She wrote \"Echoes, a cantata for the community observance of Kristallnacht and collaborated with her husband, Rabbi Herbert Bronstein, in a Hallel cantata \"We Shall Not Die But Live\" for confirmation. In addition to her compositions, Tamar as produced recordings as well as several educational programs. All express her desire to share the richness of the great Jewish legacy found in music.\r\n'),(14,4,68,0,2,''),(15,4,89,0,2,''),(16,4,502,0,3,'Lifeway Christian Resources'),(17,4,57,0,3,'Features: 6 sessions, approx. 1015 minutes each,2 DVDs, Uses the four-point Bible study method: Pour & Paraphrase; Pull Out; Pose; Plan & Pin, Member with leader helps\r\n'),(18,4,58,0,3,'Features: 6 sessions, approx. 1015 minutes each,2 DVDs, Uses the four-point Bible study method: Pour & Paraphrase; Pull Out; Pose; Plan & Pin, Member with leader helps\r\n'),(19,4,68,0,3,''),(20,4,89,0,3,''),(21,4,502,0,4,'Faith Factory'),(22,4,57,0,4,'Buck, Chainsaw, and Hootie go in search of stolen goods at Moosehead Falls where critters mysteriously vanish. An exciting adventure! The value of the Scriptures and honesty are underscored.\r\n'),(23,4,58,0,4,'Buck, Chainsaw, and Hootie go in search of stolen goods at Moosehead Falls where critters mysteriously vanish. An exciting adventure! The value of the Scriptures and honesty are underscored.\r\n'),(24,4,68,0,4,''),(25,4,89,0,4,''),(26,4,502,0,5,'Faith Factory'),(27,4,57,0,5,'Buck, Chainsaw, and Hootie go in search of stolen goods at Moosehead Falls where critters mysteriously vanish. An exciting adventure! The value of the Scriptures and honesty are underscored.\r\n'),(28,4,58,0,5,'Buck, Chainsaw, and Hootie go in search of stolen goods at Moosehead Falls where critters mysteriously vanish. An exciting adventure! The value of the Scriptures and honesty are underscored.\r\n'),(29,4,68,0,5,''),(30,4,89,0,5,''),(31,4,502,0,6,'Allegis Publications'),(32,4,57,0,6,'IN ADORATION OF THE KING OF KINGS, BLLTN BLNK\r\n'),(33,4,58,0,6,'IN ADORATION OF THE KING OF KINGS, BLLTN BLNK\r\n'),(34,4,68,0,6,''),(35,4,89,0,6,''),(36,4,502,0,7,'Allegis Publications'),(37,4,57,0,7,'ALL ON A CHRISTMAS DAY: PROD. GUIDE W/VIDEO\r\n'),(38,4,58,0,7,'ALL ON A CHRISTMAS DAY: PROD. GUIDE W/VIDEO\r\n'),(39,4,68,0,7,''),(40,4,89,0,7,''),(41,4,502,0,8,'Allegis Publications'),(42,4,57,0,8,'MORE THAN WORTHY WITH OFFERING, ORCHESTRATION\r\n'),(43,4,58,0,8,'MORE THAN WORTHY WITH OFFERING, ORCHESTRATION\r\n'),(44,4,68,0,8,''),(45,4,89,0,8,''),(46,4,502,0,9,'Allegis Publications'),(47,4,57,0,9,'ALL THE BEST FOR CHRISTMAS, ORCHESTRATION\r\n'),(48,4,58,0,9,'ALL THE BEST FOR CHRISTMAS, ORCHESTRATION\r\n'),(49,4,68,0,9,''),(50,4,89,0,9,''),(51,4,502,0,10,'Allegis Publications'),(52,4,57,0,10,'CHRIST IS BORN, SING ALLELUIA, ORCHESTRATION\r\n'),(53,4,58,0,10,'CHRIST IS BORN, SING ALLELUIA, ORCHESTRATION\r\n'),(54,4,68,0,10,''),(55,4,89,0,10,''),(56,4,502,0,11,'Allegis Publications'),(57,4,57,0,11,'GREAT IS THE LORD ALMIGHTY, ORCHESTRATION\r\n'),(58,4,58,0,11,'GREAT IS THE LORD ALMIGHTY, ORCHESTRATION\r\n'),(59,4,68,0,11,''),(60,4,89,0,11,''),(61,4,502,0,12,'Allegis Publications'),(62,4,57,0,12,'HERE I AM TO WORSHIP, ANTHEM, ORCHESTRATION\r\n'),(63,4,58,0,12,'HERE I AM TO WORSHIP, ANTHEM, ORCHESTRATION\r\n'),(64,4,68,0,12,''),(65,4,89,0,12,''),(66,4,502,0,13,'Allegis Publications'),(67,4,57,0,13,'JESUS, DRAW ME EVER NEARER, ORCHESTRATION\r\n'),(68,4,58,0,13,'JESUS, DRAW ME EVER NEARER, ORCHESTRATION\r\n'),(69,4,68,0,13,''),(70,4,89,0,13,''),(71,4,502,0,14,'Allegis Publications'),(72,4,57,0,14,'LORD IS THE STRENGTH OF MY LIFE, THE, ORCH\r\n'),(73,4,58,0,14,'LORD IS THE STRENGTH OF MY LIFE, THE, ORCH\r\n'),(74,4,68,0,14,''),(75,4,89,0,14,''),(76,4,502,0,15,'Allegis Publications'),(77,4,57,0,15,'SALVATION BELONGS TO OUR GOD, ORCHESTRATION\r\n'),(78,4,58,0,15,'SALVATION BELONGS TO OUR GOD, ORCHESTRATION\r\n'),(79,4,68,0,15,''),(80,4,89,0,15,''),(81,4,502,0,16,'Allegis Publications'),(82,4,57,0,16,'SHOUT TO THE NORTH W/ O ZION, HASTE, ORCH\r\n'),(83,4,58,0,16,'SHOUT TO THE NORTH W/ O ZION, HASTE, ORCH\r\n'),(84,4,68,0,16,''),(85,4,89,0,16,''),(86,4,502,0,17,'Allegis Publications'),(87,4,57,0,17,'YOUR GRACE STILL AMAZES ME, ORCHESTRATION\r\n'),(88,4,58,0,17,'YOUR GRACE STILL AMAZES ME, ORCHESTRATION\r\n'),(89,4,68,0,17,''),(90,4,89,0,17,''),(91,4,502,0,18,'Allegis Publications'),(92,4,57,0,18,'A sparkling, yet very accessible transcription of the classic Mozart work. Allow your congregation to experience music that has triumphed through time.\r\n'),(93,4,58,0,18,'A sparkling, yet very accessible transcription of the classic Mozart work. Allow your congregation to experience music that has triumphed through time.\r\n'),(94,4,68,0,18,''),(95,4,89,0,18,''),(96,4,502,0,19,'Allegis Publications'),(97,4,57,0,19,'A majestic, symphonic setting of the classic song by Frances Allitsen. Gold Series.\r\n'),(98,4,58,0,19,'A majestic, symphonic setting of the classic song by Frances Allitsen. Gold Series.\r\n'),(99,4,68,0,19,''),(100,4,89,0,19,''),(101,4,502,0,20,'Allegis Publications'),(102,4,57,0,20,'Medley of tunes from Handels Messiah, including And the Glory of the Lord, Glory to God, and Hallelujah chorus. Gold Series.\r\n'),(103,4,58,0,20,'Medley of tunes from Handels Messiah, including And the Glory of the Lord, Glory to God, and Hallelujah chorus. Gold Series.\r\n'),(104,4,68,0,20,''),(105,4,89,0,20,''),(106,4,502,0,21,'Allegis Publications'),(107,4,57,0,21,'Big, majestic, highly colorful setting of contemporary Easter favorite.\r\n'),(108,4,58,0,21,'Big, majestic, highly colorful setting of contemporary Easter favorite.\r\n'),(109,4,68,0,21,''),(110,4,89,0,21,''),(111,4,502,0,22,'Allegis Publications'),(112,4,57,0,22,'A beautiful and majestic setting of the Twila Paris song.\r\n'),(113,4,58,0,22,'A beautiful and majestic setting of the Twila Paris song.\r\n'),(114,4,68,0,22,''),(115,4,89,0,22,''),(116,4,502,0,23,'Allegis Publications'),(117,4,57,0,23,'Setting of traditional plainsong carol with a brief quote from Bob McGees contemporary worship song Emmanuel. Begins mysteriously, ends gloriously!\r\n'),(118,4,58,0,23,'Setting of traditional plainsong carol with a brief quote from Bob McGees contemporary worship song Emmanuel. Begins mysteriously, ends gloriously!\r\n'),(119,4,68,0,23,''),(120,4,89,0,23,''),(121,4,502,0,24,'Allegis Publications'),(122,4,57,0,24,'An energetic, slightly military flair brings this arrangement to life. A brief quote from the hymn, Immortal, Invisible offers solid contrast.\r\n'),(123,4,58,0,24,'An energetic, slightly military flair brings this arrangement to life. A brief quote from the hymn, Immortal, Invisible offers solid contrast.\r\n'),(124,4,68,0,24,''),(125,4,89,0,24,''),(126,4,502,0,25,'Allegis Publications'),(127,4,57,0,25,'Up-tempo, pure Gospel fun! Includes lots of interplay between brass and woodwinds.\r\n'),(128,4,58,0,25,'Up-tempo, pure Gospel fun! Includes lots of interplay between brass and woodwinds.\r\n'),(129,4,68,0,25,''),(130,4,89,0,25,''),(131,4,502,0,26,'Allegis Publications'),(132,4,57,0,26,'This original Marty Parks composition captures the spirit of America with its driving rhythms and energetic melody - a great opener for patriotic concerts.\r\n'),(133,4,58,0,26,'This original Marty Parks composition captures the spirit of America with its driving rhythms and energetic melody - a great opener for patriotic concerts.\r\n'),(134,4,68,0,26,''),(135,4,89,0,26,''),(136,4,502,0,27,'Allegis Publications'),(137,4,57,0,27,'The popular praise & worship song is combined with All Hail the Power of Jesus Name and features a concert band feel in the middle section.\r\n'),(138,4,58,0,27,'The popular praise & worship song is combined with All Hail the Power of Jesus Name and features a concert band feel in the middle section.\r\n'),(139,4,68,0,27,''),(140,4,89,0,27,''),(141,4,502,0,28,'Allegis Publications'),(142,4,57,0,28,'In overture style, the fanfare opening leads to an energetic development of the classic carol.\r\n'),(143,4,58,0,28,'In overture style, the fanfare opening leads to an energetic development of the classic carol.\r\n'),(144,4,68,0,28,''),(145,4,89,0,28,''),(146,4,502,0,29,'Allegis Publications'),(147,4,57,0,29,'Jeff Cranfill masterfully combines Come Thou Fount of Every Blessing with contemporary favorite The Heart of Worship.\r\n'),(148,4,58,0,29,'Jeff Cranfill masterfully combines Come Thou Fount of Every Blessing with contemporary favorite The Heart of Worship.\r\n'),(149,4,68,0,29,''),(150,4,89,0,29,''),(151,4,502,0,30,'Allegis Publications'),(152,4,57,0,30,'A beautiful expression of pure adoration to our Exalted King. A dramatic and worshipful setting of the timeless song by Pete Sanchez, Jr.\r\n'),(153,4,58,0,30,'A beautiful expression of pure adoration to our Exalted King. A dramatic and worshipful setting of the timeless song by Pete Sanchez, Jr.\r\n'),(154,4,68,0,30,''),(155,4,89,0,30,''),(156,4,502,0,31,'Allegis Publications'),(157,4,57,0,31,'This driving arrangement of the popular chorus is certain to enliven your worship service. Celebrative and Energetic!\r\n'),(158,4,58,0,31,'This driving arrangement of the popular chorus is certain to enliven your worship service. Celebrative and Energetic!\r\n'),(159,4,68,0,31,''),(160,4,89,0,31,''),(161,4,502,0,32,'Allegis Publications'),(162,4,57,0,32,'A vibrant, energetic presentation of the popular Martin Smith song!\r\n'),(163,4,58,0,32,'A vibrant, energetic presentation of the popular Martin Smith song!\r\n'),(164,4,68,0,32,''),(165,4,89,0,32,''),(166,4,502,0,33,'Allegis Publications'),(167,4,57,0,33,'Need a high energy opener for your Christmas pageant? Look no further than this contemporary, driving 6/8 version of the classic Christmas song.\r\n'),(168,4,58,0,33,'Need a high energy opener for your Christmas pageant? Look no further than this contemporary, driving 6/8 version of the classic Christmas song.\r\n'),(169,4,68,0,33,''),(170,4,89,0,33,''),(171,4,502,0,34,'Allegis Publications'),(172,4,57,0,34,'The classic chorus comes to life with a vibrant island feel in this high energy setting by Mike Lawrence.\r\n'),(173,4,58,0,34,'The classic chorus comes to life with a vibrant island feel in this high energy setting by Mike Lawrence.\r\n'),(174,4,68,0,34,''),(175,4,89,0,34,''),(176,4,502,0,35,'Allegis Publications'),(177,4,57,0,35,'Jeff Cranfill gives a seafaring, symphonic treatment of a familiar melody.\r\n'),(178,4,58,0,35,'Jeff Cranfill gives a seafaring, symphonic treatment of a familiar melody.\r\n'),(179,4,68,0,35,''),(180,4,89,0,35,''),(181,4,502,0,36,'Allegis Publications'),(182,4,57,0,36,'A thrilling setting of this well-known hymn. Platinum Series.\r\n'),(183,4,58,0,36,'A thrilling setting of this well-known hymn. Platinum Series.\r\n'),(184,4,68,0,36,''),(185,4,89,0,36,''),(186,4,502,0,37,'Allegis Publications'),(187,4,57,0,37,'This creative overture is perfect for the holiday season. It has just the spark of joy to bring an instant response from your congregation.\r\n'),(188,4,58,0,37,'This creative overture is perfect for the holiday season. It has just the spark of joy to bring an instant response from your congregation.\r\n'),(189,4,68,0,37,''),(190,4,89,0,37,''),(191,4,502,0,38,'Allegis Publications'),(192,4,57,0,38,'A majestic fanfare surrounds the coupling of Praise to the Lord, the Almighty and We Bring the Sacrifice of Praise.\r\n'),(193,4,58,0,38,'A majestic fanfare surrounds the coupling of Praise to the Lord, the Almighty and We Bring the Sacrifice of Praise.\r\n'),(194,4,68,0,38,''),(195,4,89,0,38,''),(196,4,502,0,39,'Allegis Publications'),(197,4,57,0,39,'Brilliant colors and sparkling timbres create an arrangement thats challenging, but accessible and satisfying.\r\n'),(198,4,58,0,39,'Brilliant colors and sparkling timbres create an arrangement thats challenging, but accessible and satisfying.\r\n'),(199,4,68,0,39,''),(200,4,89,0,39,''),(201,4,502,0,40,'Allegis Publications'),(202,4,57,0,40,'In the style of Count Basie, a swinging arrangement of a favorite spiritual. An energetic romp for the more advanced church orchestra.\r\n'),(203,4,58,0,40,'In the style of Count Basie, a swinging arrangement of a favorite spiritual. An energetic romp for the more advanced church orchestra.\r\n'),(204,4,68,0,40,''),(205,4,89,0,40,''),(206,4,502,0,41,'Allegis Publications'),(207,4,57,0,41,'A great text brought to life with a rhapsodic interpretation of the powerful Stuart Townend song.\r\n'),(208,4,58,0,41,'A great text brought to life with a rhapsodic interpretation of the powerful Stuart Townend song.\r\n'),(209,4,68,0,41,''),(210,4,89,0,41,''),(211,4,502,0,42,'Allegis Publications'),(212,4,57,0,42,'Nice arrangements with a smooth, big band sound. Features warm, melodic solo by lead trumpet.\r\n'),(213,4,58,0,42,'Nice arrangements with a smooth, big band sound. Features warm, melodic solo by lead trumpet.\r\n'),(214,4,68,0,42,''),(215,4,89,0,42,''),(216,4,502,0,43,'Allegis Publications'),(217,4,57,0,43,'Gospel...with a flair! Alto sax solo line sets the pace for this dynamic arrangement. Gospel Band Series.\r\n'),(218,4,58,0,43,'Gospel...with a flair! Alto sax solo line sets the pace for this dynamic arrangement. Gospel Band Series.\r\n'),(219,4,68,0,43,''),(220,4,89,0,43,''),(221,4,502,0,44,'Allegis Publications'),(222,4,57,0,44,'An engaging big-band version of a classic Andra Crouch song.\r\n'),(223,4,58,0,44,'An engaging big-band version of a classic Andra Crouch song.\r\n'),(224,4,68,0,44,''),(225,4,89,0,44,''),(226,4,502,0,45,'Allegis Publications'),(227,4,57,0,45,'A wonderful (and swinging) combination of two great Gospel songs.\r\n'),(228,4,58,0,45,'A wonderful (and swinging) combination of two great Gospel songs.\r\n'),(229,4,68,0,45,''),(230,4,89,0,45,''),(231,4,502,0,46,'Allegis Publications'),(232,4,57,0,46,'This high-energy treatment of the popular Matt and Beth Redman worship song will make a great service opener for your orchestra.\r\n'),(233,4,58,0,46,'This high-energy treatment of the popular Matt and Beth Redman worship song will make a great service opener for your orchestra.\r\n'),(234,4,68,0,46,''),(235,4,89,0,46,''),(236,4,502,0,47,'Allegis Publications'),(237,4,57,0,47,'A perfect opener for your Christmas program. Celebrate the mystery of Christs Advent!\r\n'),(238,4,58,0,47,'A perfect opener for your Christmas program. Celebrate the mystery of Christs Advent!\r\n'),(239,4,68,0,47,''),(240,4,89,0,47,''),(241,4,502,0,48,'Allegis Publications'),(242,4,57,0,48,'A dramatic statement of praise for your instrumentalists!\r\n'),(243,4,58,0,48,'A dramatic statement of praise for your instrumentalists!\r\n'),(244,4,68,0,48,''),(245,4,89,0,48,''),(246,4,502,0,49,'Easy 2 Excel'),(247,4,57,0,49,'Cherished hymns, popular worship songs, and several new and significant compositions combine in arrangements that are both moving and impactful, while retaining a level of difficulty that even the smallest choir can master.\r\n'),(248,4,58,0,49,'Cherished hymns, popular worship songs, and several new and significant compositions combine in arrangements that are both moving and impactful, while retaining a level of difficulty that even the smallest choir can master.\r\n'),(249,4,68,0,49,''),(250,4,89,0,49,''),(251,4,502,0,50,'Mel Bay Publications'),(252,4,57,0,50,'Learn to play Rumba and Soukous style African bass guitar in this step by step DVD with Kibisi Douglas - bass player of Baka Beyond and Kanda Bongo Man. 28 exercises to develop your tone, phrasing and technique for African styles. Suitable for beginners and upwards.\r\n'),(253,4,58,0,50,'Learn to play Rumba and Soukous style African bass guitar in this step by step DVD with Kibisi Douglas - bass player of Baka Beyond and Kanda Bongo Man. 28 exercises to develop your tone, phrasing and technique for African styles. Suitable for beginners and upwards.\r\n'),(254,4,68,0,50,''),(255,4,89,0,50,''),(256,4,502,0,51,'Lerner Classroom'),(257,4,57,0,51,'What Is a Gas? offers emergent readers a simple explanation of matter, a discription of gases, and examples of how gases can change into different states of matter.\r\n'),(258,4,58,0,51,'What Is a Gas? offers emergent readers a simple explanation of matter, a discription of gases, and examples of how gases can change into different states of matter.\r\n'),(259,4,68,0,51,''),(260,4,89,0,51,''),(261,4,502,0,52,'Saunders Book Co'),(262,4,57,0,52,'This new sports series from Creative Paperbacks capture the history, stars, and excitement of the National Football League like never before. No matter which franchise readers root for--be it the popular Dallas Cowboys, champion Pittsburgh Steelers, or storied Chicago Bears--the brilliant photos, informative player profiles, and energetic text will turn reading time into game time as young fans turn the pages of these six action-packed titles.\r\n'),(263,4,58,0,52,'This new sports series from Creative Paperbacks capture the history, stars, and excitement of the National Football League like never before. No matter which franchise readers root for--be it the popular Dallas Cowboys, champion Pittsburgh Steelers, or storied Chicago Bears--the brilliant photos, informative player profiles, and energetic text will turn reading time into game time as young fans turn the pages of these six action-packed titles.\r\n'),(264,4,68,0,52,''),(265,4,89,0,52,''),(266,4,502,0,53,'Cambridge Scholars Publishing'),(267,4,57,0,53,'James Fenimore Cooper was a 19th century writer known for his historical romances and stories of the sea. His Leatherstocking tales including the novel The Last of the Mohicans are his best-known works. First published in 1844 Afloat and Ashore is first a tale of the sea. Miles Wallingford runs away to the sea. He has decided to become a merchant sailor. He experiences the hazards of life at sea, the perils of shore life, financial intrigue, and of course romance. The sequel \"Miles Wallingford\" answers many of the questions left hanging at the end of the book.\r\n'),(268,4,58,0,53,'James Fenimore Cooper was a 19th century writer known for his historical romances and stories of the sea. His Leatherstocking tales including the novel The Last of the Mohicans are his best-known works. First published in 1844 Afloat and Ashore is first a tale of the sea. Miles Wallingford runs away to the sea. He has decided to become a merchant sailor. He experiences the hazards of life at sea, the perils of shore life, financial intrigue, and of course romance. The sequel \"Miles Wallingford\" answers many of the questions left hanging at the end of the book.\r\n'),(269,4,68,0,53,''),(270,4,89,0,53,''),(271,4,502,0,54,'Hoi Nha Van'),(272,4,57,0,54,'Elizabeth Bennet is the spirited second daughter of Mr. and Mrs. Bennet, who must be married off before their other daughters can be married. But Elizabeth, who is in love with Mr. Darcy, must overcome her prejudice against Mr. Darcy who has an equally strong pride preventing him from admitting his love for her... Vietnamese translation by Diep Minh Tam. In Vietnamese. Distributed by Tsai Fong Books, Inc.\r\n'),(273,4,58,0,54,'Elizabeth Bennet is the spirited second daughter of Mr. and Mrs. Bennet, who must be married off before their other daughters can be married. But Elizabeth, who is in love with Mr. Darcy, must overcome her prejudice against Mr. Darcy who has an equally strong pride preventing him from admitting his love for her... Vietnamese translation by Diep Minh Tam. In Vietnamese. Distributed by Tsai Fong Books, Inc.\r\n'),(274,4,68,0,54,''),(275,4,89,0,54,''),(276,4,502,0,55,'Kim Dong'),(277,4,57,0,55,'Little Doggie Cun and Friends: A Pretty Bow: Board books in the series Little Doggie Cun and Friends. Illustration by Phuong Hoa, words by Ngoc Thu. Distributed by Tsai Fong Books, Inc.\r\n'),(278,4,58,0,55,'Little Doggie Cun and Friends: A Pretty Bow: Board books in the series Little Doggie Cun and Friends. Illustration by Phuong Hoa, words by Ngoc Thu. Distributed by Tsai Fong Books, Inc.\r\n'),(279,4,68,0,55,''),(280,4,89,0,55,''),(281,4,502,0,56,'Van Hoc'),(282,4,57,0,56,'Vietnamese edition of Peyton Place. A contemporary classic that had created a wave of publicity in the 50s, especially with the film version starring Lana Turner, and Hope Lange, among others... The deep dark secret of a little New England town became the back bone of a long running TV series... Vietnamese translation by Ta Thu Ha. Distributed by Tsai Fong Books, Inc.\r\n'),(283,4,58,0,56,'Vietnamese edition of Peyton Place. A contemporary classic that had created a wave of publicity in the 50s, especially with the film version starring Lana Turner, and Hope Lange, among others... The deep dark secret of a little New England town became the back bone of a long running TV series... Vietnamese translation by Ta Thu Ha. Distributed by Tsai Fong Books, Inc.\r\n'),(284,4,68,0,56,''),(285,4,89,0,56,''),(286,4,502,0,57,'Yang Tao Wen Hua'),(287,4,57,0,57,'88 recipes of Taiwanese cuisine ranges from appetizers that can help you stem off hunger before main courses are served, and flavorful dishes to enhance appetite. These are easy to make, easy to keep, salads, stir fried, steamed, and even boiled. Best of all, these are all inexpensive.\r\n'),(288,4,58,0,57,'88 recipes of Taiwanese cuisine ranges from appetizers that can help you stem off hunger before main courses are served, and flavorful dishes to enhance appetite. These are easy to make, easy to keep, salads, stir fried, steamed, and even boiled. Best of all, these are all inexpensive.\r\n'),(289,4,68,0,57,''),(290,4,89,0,57,''),(291,4,502,0,58,'Shang Yi Publishing Co'),(292,4,57,0,58,'Have fun learn English with the magical Spot series Chinese edition: Wheres Spot, Spot Goes to the Farm, and Spots First Walk. This 3-volume flip book box set also comes with a Chinese English VCD and a parents manual. Distributed by Tsai Fong Books, Inc.\r\n'),(293,4,58,0,58,'Have fun learn English with the magical Spot series Chinese edition: Wheres Spot, Spot Goes to the Farm, and Spots First Walk. This 3-volume flip book box set also comes with a Chinese English VCD and a parents manual. Distributed by Tsai Fong Books, Inc.\r\n'),(294,4,68,0,58,''),(295,4,89,0,58,''),(296,4,502,0,59,'Shang Zhou Chu Ban'),(297,4,57,0,59,'Chinese edition of Henry Lees Crime Scene Handbook. CSI detectives maybe glamorous and their investigation maybe dramatic, but this book by the famed forensic expert Dr. Henry Lee gets down to the nitty-gritty of how real life detectives approach crime scene investigations - systematic and logical. In Traditional Chinese. Distributed by Tsai Fong Books, Inc.\r\n'),(298,4,58,0,59,'Chinese edition of Henry Lees Crime Scene Handbook. CSI detectives maybe glamorous and their investigation maybe dramatic, but this book by the famed forensic expert Dr. Henry Lee gets down to the nitty-gritty of how real life detectives approach crime scene investigations - systematic and logical. In Traditional Chinese. Distributed by Tsai Fong Books, Inc.\r\n'),(299,4,68,0,59,''),(300,4,89,0,59,''),(301,4,502,0,60,'Jian Duan'),(302,4,57,0,60,'Chinese edition of Michael Jackson: Life of a Legend 1958-2009. The King of Pop Michael Jacksons biography. In Traditional Chinese. Distributed by Tsai Fong Books, Inc.\r\n'),(303,4,58,0,60,'Chinese edition of Michael Jackson: Life of a Legend 1958-2009. The King of Pop Michael Jacksons biography. In Traditional Chinese. Distributed by Tsai Fong Books, Inc.\r\n'),(304,4,68,0,60,''),(305,4,89,0,60,''),(306,4,502,0,61,'Christian Art Gifts Inc'),(307,4,57,0,61,'Read and Play Cards introducing numbers with a biblical focus\r\n'),(308,4,58,0,61,'Read and Play Cards introducing numbers with a biblical focus\r\n'),(309,4,68,0,61,''),(310,4,89,0,61,''),(311,4,502,0,62,'Christian Art Gifts Inc'),(312,4,57,0,62,'Jumbo floor puzzle of Daniel in the Lions Den\r\n'),(313,4,58,0,62,'Jumbo floor puzzle of Daniel in the Lions Den\r\n'),(314,4,68,0,62,''),(315,4,89,0,62,''),(316,4,502,0,63,'Franz Steiner Verlag Wiesbaden GmbH'),(317,4,57,0,63,'This volume studies the variant development of rural settlements in Mecklenburg, Germany, in the post-socialist era. German text.\r\n'),(318,4,58,0,63,'This volume studies the variant development of rural settlements in Mecklenburg, Germany, in the post-socialist era. German text.\r\n'),(319,4,68,0,63,''),(320,4,89,0,63,''),(321,4,502,0,64,'Fantasy Flight Games'),(322,4,57,0,64,'The second Wings of War game set in World War II, Fire From The Sky introduces new rules and planes to the game of aerial combat. Dive-bomb targets in a Stuka, a Dauntless, or a Val, or dogfight in a Warhawk, Hien, Yak 1, Airacobra, or Falco II - all is included in this set. Each Wings of War box is a complete game that can be combined with other World War II Wings of War sets.\r\n'),(323,4,58,0,64,'The second Wings of War game set in World War II, Fire From The Sky introduces new rules and planes to the game of aerial combat. Dive-bomb targets in a Stuka, a Dauntless, or a Val, or dogfight in a Warhawk, Hien, Yak 1, Airacobra, or Falco II - all is included in this set. Each Wings of War box is a complete game that can be combined with other World War II Wings of War sets.\r\n'),(324,4,68,0,64,''),(325,4,89,0,64,''),(326,4,502,0,65,'Hoi Nha Van'),(327,4,57,0,65,'A grand-father recorded the stories he had told to his grandchildren, which he adapted from many sources and gave the stories a Vietnamese flavor. Distributed by Tsai Fong Books, Inc.\r\n'),(328,4,58,0,65,'A grand-father recorded the stories he had told to his grandchildren, which he adapted from many sources and gave the stories a Vietnamese flavor. Distributed by Tsai Fong Books, Inc.\r\n'),(329,4,68,0,65,''),(330,4,89,0,65,''),(331,4,502,0,66,'Van Hoc'),(332,4,57,0,66,'Vietnamese edition of The Adventures of Batman Vol 1 & 2. A collection of 33 short stories detailing the adventures of Batman, written by various authors and compiled by Martin H. Greenberg. Vietnamese translation by Duong Tat Thang and Nguyen Thanh Tung. Distributed by Tsai Fong Books, Inc.\r\n'),(333,4,58,0,66,'Vietnamese edition of The Adventures of Batman Vol 1 & 2. A collection of 33 short stories detailing the adventures of Batman, written by various authors and compiled by Martin H. Greenberg. Vietnamese translation by Duong Tat Thang and Nguyen Thanh Tung. Distributed by Tsai Fong Books, Inc.\r\n'),(334,4,68,0,66,''),(335,4,89,0,66,''),(336,4,502,0,67,'Tre'),(337,4,57,0,67,'A collection of 12 short stories a bout a variety of topics in a student life... One in an enormously popular youth fiction series. 14th printing. Distributed by Tsai Fong Books, Inc.\r\n'),(338,4,58,0,67,'A collection of 12 short stories a bout a variety of topics in a student life... One in an enormously popular youth fiction series. 14th printing. Distributed by Tsai Fong Books, Inc.\r\n'),(339,4,68,0,67,''),(340,4,89,0,67,''),(341,4,502,0,68,'Tre'),(342,4,57,0,68,'Vietnamese translation of \"Harry Potter and the Prisoner of Azkaban\" (3)\r\n'),(343,4,58,0,68,'Vietnamese translation of \"Harry Potter and the Prisoner of Azkaban\" (3)\r\n'),(344,4,68,0,68,''),(345,4,89,0,68,''),(346,4,502,0,69,'Tre'),(347,4,57,0,69,'Harry Potter and the Half-Blood Prince: The sixth in J. K. Rowlings series of the adventures of the young wizard Harry Potter. Vietnamese version translated by Ly Lan and Huong Lan. 679p.\r\n'),(348,4,58,0,69,'Harry Potter and the Half-Blood Prince: The sixth in J. K. Rowlings series of the adventures of the young wizard Harry Potter. Vietnamese version translated by Ly Lan and Huong Lan. 679p.\r\n'),(349,4,68,0,69,''),(350,4,89,0,69,''),(351,4,502,0,70,'Tre'),(352,4,57,0,70,'Eldest (Part I and II)-The continuation of the enormously popular book, Eragon, written by the young talented Paolini. Translated into Vietnamese by Dang Phi Bang. Vol. 1, 506p; Vol. 2, 390p.\r\n'),(353,4,58,0,70,'Eldest (Part I and II)-The continuation of the enormously popular book, Eragon, written by the young talented Paolini. Translated into Vietnamese by Dang Phi Bang. Vol. 1, 506p; Vol. 2, 390p.\r\n'),(354,4,68,0,70,''),(355,4,89,0,70,''),(356,4,502,0,71,'Tre'),(357,4,57,0,71,'Vietnamese edition of Pendragon: The Merchant of Death. First book in a series of a wildly popular science fiction featuring Bobby Pendragon, a teenage basket ball star from Stony Brook High School who many think to have surpassed Harry Potter in popularity. Vietnamese translation by Dang Phi Bang. Distributed by Tsai Fong Books, Inc.\r\n'),(358,4,58,0,71,'Vietnamese edition of Pendragon: The Merchant of Death. First book in a series of a wildly popular science fiction featuring Bobby Pendragon, a teenage basket ball star from Stony Brook High School who many think to have surpassed Harry Potter in popularity. Vietnamese translation by Dang Phi Bang. Distributed by Tsai Fong Books, Inc.\r\n'),(359,4,68,0,71,''),(360,4,89,0,71,''),(361,4,502,0,72,'Tre'),(362,4,57,0,72,'Vietnamese edition of Pendragon: The Lost City of Faar. Second book in a series of a wildly popular science fiction featuring Bobby Pendragon, a teenage basket ball star from Stony Brook High School who many think to have surpassed Harry Potter in popularity. Vietnamese translation by Dang Phi Bang. Distributed by Tsai Fong Books, Inc.\r\n'),(363,4,58,0,72,'Vietnamese edition of Pendragon: The Lost City of Faar. Second book in a series of a wildly popular science fiction featuring Bobby Pendragon, a teenage basket ball star from Stony Brook High School who many think to have surpassed Harry Potter in popularity. Vietnamese translation by Dang Phi Bang. Distributed by Tsai Fong Books, Inc.\r\n'),(364,4,68,0,72,''),(365,4,89,0,72,''),(366,4,502,0,73,'Tre'),(367,4,57,0,73,'Vietnamese edition of Pendragon: The Never War. Third book in a series of a wildly popular science fiction featuring Bobby Pendragon, a teenage basket ball star from Stony Brook High School who many think to have surpassed Harry Potter in popularity. Vietnamese translation by Dang Phi Bang. Distributed by Tsai Fong Books, Inc.\r\n'),(368,4,58,0,73,'Vietnamese edition of Pendragon: The Never War. Third book in a series of a wildly popular science fiction featuring Bobby Pendragon, a teenage basket ball star from Stony Brook High School who many think to have surpassed Harry Potter in popularity. Vietnamese translation by Dang Phi Bang. Distributed by Tsai Fong Books, Inc.\r\n'),(369,4,68,0,73,''),(370,4,89,0,73,''),(371,4,502,0,74,'Tre'),(372,4,57,0,74,'Vietnamese edition of Pendragon: The Reality Bug. Fourth book in a series of a wildly popular science fiction featuring Bobby Pendragon, a teenage basket ball star from Stony Brook High School who many think to have surpassed Harry Potter in popularity. Vietnamese translation by Dang Phi Bang. Distributed by Tsai Fong Books, Inc.\r\n'),(373,4,58,0,74,'Vietnamese edition of Pendragon: The Reality Bug. Fourth book in a series of a wildly popular science fiction featuring Bobby Pendragon, a teenage basket ball star from Stony Brook High School who many think to have surpassed Harry Potter in popularity. Vietnamese translation by Dang Phi Bang. Distributed by Tsai Fong Books, Inc.\r\n'),(374,4,68,0,74,''),(375,4,89,0,74,''),(376,4,502,0,75,'Tre'),(377,4,57,0,75,'Book 2 in the Simon Heap series. Simon Heap is recruited by the necromancer Dom Daniel to get rid of Jenna, rightful heir to the throne... Tales of magic and power fights and flights... to delight young readers. Vietnamese translation by Huong Lan.\r\n'),(378,4,58,0,75,'Book 2 in the Simon Heap series. Simon Heap is recruited by the necromancer Dom Daniel to get rid of Jenna, rightful heir to the throne... Tales of magic and power fights and flights... to delight young readers. Vietnamese translation by Huong Lan.\r\n'),(379,4,68,0,75,''),(380,4,89,0,75,''),(381,4,502,0,76,'Tre'),(382,4,57,0,76,'This is book 1 of a book about Light and Shadow, written in French by a Vietnamese-American physicist, which earned the French Academy of Sciences Moron award in 2007 for the author. Vietnamese translation by Pham Van Thieu and Ngo Vu. Distributed by Tsai Fong Books, Inc.\r\n'),(383,4,58,0,76,'This is book 1 of a book about Light and Shadow, written in French by a Vietnamese-American physicist, which earned the French Academy of Sciences Moron award in 2007 for the author. Vietnamese translation by Pham Van Thieu and Ngo Vu. Distributed by Tsai Fong Books, Inc.\r\n'),(384,4,68,0,76,''),(385,4,89,0,76,''),(386,4,502,0,77,'Tre'),(387,4,57,0,77,'Vietnamese edition of Pendragon: Black Water. Fifth book in a series of a wildly popular science fiction featuring Bobby Pendragon, a teenage basket ball star from Stony Brook High School who many think to have surpassed Harry Potter in popularity. Vietnamese translation by Dang Phi Bang. Distributed by Tsai Fong Books, Inc.\r\n'),(388,4,58,0,77,'Vietnamese edition of Pendragon: Black Water. Fifth book in a series of a wildly popular science fiction featuring Bobby Pendragon, a teenage basket ball star from Stony Brook High School who many think to have surpassed Harry Potter in popularity. Vietnamese translation by Dang Phi Bang. Distributed by Tsai Fong Books, Inc.\r\n'),(389,4,68,0,77,''),(390,4,89,0,77,''),(391,4,502,0,78,'Tre'),(392,4,57,0,78,'Vietnamese translation of Harry Potter and the Order of the Phoenix.\r\n'),(393,4,58,0,78,'Vietnamese translation of Harry Potter and the Order of the Phoenix.\r\n'),(394,4,68,0,78,''),(395,4,89,0,78,''),(396,4,502,0,79,'Tre'),(397,4,57,0,79,'Vietnamese translation of \"Harry Potter and the Goblet of Fire\" (4)\r\n'),(398,4,58,0,79,'Vietnamese translation of \"Harry Potter and the Goblet of Fire\" (4)\r\n'),(399,4,68,0,79,''),(400,4,89,0,79,''),(401,4,502,0,80,'Tre'),(402,4,57,0,80,'Vietnamese translation of Harry Potter and the Philosophers Stone (1)\r\n'),(403,4,58,0,80,'Vietnamese translation of Harry Potter and the Philosophers Stone (1)\r\n'),(404,4,68,0,80,''),(405,4,89,0,80,''),(406,4,502,0,81,'Tre'),(407,4,57,0,81,'Eragon, the boy who rides the dragon ( Part 1 of 2): Vietnamese translation by Dang Phi Bang, of Paolinis extraordinary adventure, Eragon, Has been said to be comparable with the Harry Potter series. A delight for young and old readers alike. Vol.1 368p\r\n'),(408,4,58,0,81,'Eragon, the boy who rides the dragon ( Part 1 of 2): Vietnamese translation by Dang Phi Bang, of Paolinis extraordinary adventure, Eragon, Has been said to be comparable with the Harry Potter series. A delight for young and old readers alike. Vol.1 368p\r\n'),(409,4,68,0,81,''),(410,4,89,0,81,''),(411,4,502,0,82,'Tre'),(412,4,57,0,82,'Vietnamese edition of Harry Potter and the Deathly Hallows.\r\n'),(413,4,58,0,82,'Vietnamese edition of Harry Potter and the Deathly Hallows.\r\n'),(414,4,68,0,82,''),(415,4,89,0,82,''),(416,4,502,0,83,'Tre'),(417,4,57,0,83,'Vietnamese edition of The Code Book. Saturday morning October 15, 1586, Mary Queen of Scotland came into the courtroom to face her accusers of treason against Englan. Her life hang on the hope that her letters to the accomplices were written in codes and would not be decoded... A fascinating account of the history of the science of cryptography. Vietnamese translation by Pham Van thieu and Pham Thu Hang. Distributed by Tsai Fong Books, Inc.\r\n'),(418,4,58,0,83,'Vietnamese edition of The Code Book. Saturday morning October 15, 1586, Mary Queen of Scotland came into the courtroom to face her accusers of treason against Englan. Her life hang on the hope that her letters to the accomplices were written in codes and would not be decoded... A fascinating account of the history of the science of cryptography. Vietnamese translation by Pham Van thieu and Pham Thu Hang. Distributed by Tsai Fong Books, Inc.\r\n'),(419,4,68,0,83,''),(420,4,89,0,83,''),(421,4,502,0,84,'Tre'),(422,4,57,0,84,'Vietnamese edition of The Seven Daughters of Eve. In 1994, Bryan Sykes, an evolutionist, and ADN specialist was invited to study the naturally frozen corpse o a man in Northen Italia. What was more incredible than the discovery that this frozen man lived more than 500 thousands years ago, was the discovery of his descendant: a woman currently living in England... Sykes conclusiion that almost everyone in Europe and North America can trace teir ancestry to 7 woemn... originated from seven. Vietnamese translation by Ngo Toan and Mai Hien. Distributed by Tsai Fong Books, Inc.\r\n'),(423,4,58,0,84,'Vietnamese edition of The Seven Daughters of Eve. In 1994, Bryan Sykes, an evolutionist, and ADN specialist was invited to study the naturally frozen corpse o a man in Northen Italia. What was more incredible than the discovery that this frozen man lived more than 500 thousands years ago, was the discovery of his descendant: a woman currently living in England... Sykes conclusiion that almost everyone in Europe and North America can trace teir ancestry to 7 woemn... originated from seven. Vietnamese translation by Ngo Toan and Mai Hien. Distributed by Tsai Fong Books, Inc.\r\n'),(424,4,68,0,84,''),(425,4,89,0,84,''),(426,4,502,0,85,'Tre'),(427,4,57,0,85,'Vietnamese translation of Harry Potter and the Chamber of Secrets (2)\r\n'),(428,4,58,0,85,'Vietnamese translation of Harry Potter and the Chamber of Secrets (2)\r\n'),(429,4,68,0,85,''),(430,4,89,0,85,''),(431,4,502,0,86,'Tre'),(432,4,57,0,86,'Eragon, the boy who rides the dragon ( Part 2 of 2): Vietnamese translation by Dang Phi Bang, of Paolinis extraordinary adventure, Eragon, Has been said to be comparable with the Harry Potter series. A delight for young and old readers alike. Vol.2 315p.\r\n'),(433,4,58,0,86,'Eragon, the boy who rides the dragon ( Part 2 of 2): Vietnamese translation by Dang Phi Bang, of Paolinis extraordinary adventure, Eragon, Has been said to be comparable with the Harry Potter series. A delight for young and old readers alike. Vol.2 315p.\r\n'),(434,4,68,0,86,''),(435,4,89,0,86,''),(436,4,502,0,87,'Tre'),(437,4,57,0,87,'Vietnamese edition of Twilight. A 17 year old girl moved to a small town in the state of Washington, and she would have hated it if not for the presence of Edward Cullen whom she fell terribly attracted to, before discovering that he is a vampire... Best seller youth fiction, translated into Vietnamese by Tinh Thuy.\r\n'),(438,4,58,0,87,'Vietnamese edition of Twilight. A 17 year old girl moved to a small town in the state of Washington, and she would have hated it if not for the presence of Edward Cullen whom she fell terribly attracted to, before discovering that he is a vampire... Best seller youth fiction, translated into Vietnamese by Tinh Thuy.\r\n'),(439,4,68,0,87,''),(440,4,89,0,87,''),(441,4,502,0,88,'Tre'),(442,4,57,0,88,'Vietnamese edition of Twilight: New Moon. Book 2 in the enormously popular young adult Twilight Saga, that remains in the NY Times best seller lists for many \"moons,\" about a young girl who was in love with a vampire... Bellas relationship with Edward is heating up, until Bella injures herself. The sight and smell of her blood prove too much for Edwards family and they see no option for her safety but to leave. She spirals into reckless behavior, and meets a dare-devil, Jacob. Their adventures are wild and teeter on the brink of romance, but memories of Edward pervade Bellas emotions. Vietnamese translation by Tinh Thuy. Distributed by Tsai Fong Books, Inc.\r\n'),(443,4,58,0,88,'Vietnamese edition of Twilight: New Moon. Book 2 in the enormously popular young adult Twilight Saga, that remains in the NY Times best seller lists for many \"moons,\" about a young girl who was in love with a vampire... Bellas relationship with Edward is heating up, until Bella injures herself. The sight and smell of her blood prove too much for Edwards family and they see no option for her safety but to leave. She spirals into reckless behavior, and meets a dare-devil, Jacob. Their adventures are wild and teeter on the brink of romance, but memories of Edward pervade Bellas emotions. Vietnamese translation by Tinh Thuy. Distributed by Tsai Fong Books, Inc.\r\n'),(444,4,68,0,88,''),(445,4,89,0,88,''),(446,4,502,0,89,'Tre'),(447,4,57,0,89,'Vietnamese edition of Brisingr. First volume in the sequel to Eldest. Or the third in the series Inheritance Cycle. Paolinis Brisingr is already considered a successor to Harry Potter... Vietnamese translation by Dang Phi Bang. Distributed by Tsai Fong Books, Inc.\r\n'),(448,4,58,0,89,'Vietnamese edition of Brisingr. First volume in the sequel to Eldest. Or the third in the series Inheritance Cycle. Paolinis Brisingr is already considered a successor to Harry Potter... Vietnamese translation by Dang Phi Bang. Distributed by Tsai Fong Books, Inc.\r\n'),(449,4,68,0,89,''),(450,4,89,0,89,''),(451,4,502,0,90,'Tre'),(452,4,57,0,90,'The 5 fairy tales in this book are recounted by Hermione, heroine of the Harry Potter series, for the young wizards, students of Hogwarts, school for wizards... Vietnamese translation by Ly Lan.\r\n'),(453,4,58,0,90,'The 5 fairy tales in this book are recounted by Hermione, heroine of the Harry Potter series, for the young wizards, students of Hogwarts, school for wizards... Vietnamese translation by Ly Lan.\r\n'),(454,4,68,0,90,''),(455,4,89,0,90,''),(456,4,502,0,91,'Tre'),(457,4,57,0,91,'Vietnamese edition of Eclipse. Third book in the saga of the love story between the young girl Bella Swan, and vampire Edward. This episode found Bella wavering between the love for her vampire Edward, and the intrigue she felt for werewolf Jacob.. Vietnamese translation by Tinh Thuy.\r\n'),(458,4,58,0,91,'Vietnamese edition of Eclipse. Third book in the saga of the love story between the young girl Bella Swan, and vampire Edward. This episode found Bella wavering between the love for her vampire Edward, and the intrigue she felt for werewolf Jacob.. Vietnamese translation by Tinh Thuy.\r\n'),(459,4,68,0,91,''),(460,4,89,0,91,''),(461,4,502,0,92,'Tre'),(462,4,57,0,92,'When Annie, a 14-year old girl, discovered that she was pregnant with 16-year old manipulative Dannys child, she was devastated, and not knowing who to confide in, she put all her doubt and fear into her faithful friend, her Diary... Vietnamese translation by Tran Huu Kham.\r\n'),(463,4,58,0,92,'When Annie, a 14-year old girl, discovered that she was pregnant with 16-year old manipulative Dannys child, she was devastated, and not knowing who to confide in, she put all her doubt and fear into her faithful friend, her Diary... Vietnamese translation by Tran Huu Kham.\r\n'),(464,4,68,0,92,''),(465,4,89,0,92,''),(466,4,502,0,93,'Tre'),(467,4,57,0,93,'14-year-old Will Burrows has little in common with his strange, dysfunctional family. In fact, the only bond he shares with his eccentric father is a passion for archaeological excavation. So when Dad mysteriously vanishes, Will is compelled to dig up the truth behind his disappearance. He unearths the unbelievable: a secret subterranean society... . Vietnamese translation by Ly Lan, who also translated the 7-volume of Harry Potter. In Vietnamese. Distributed by Tsai Fong Books, Inc.\r\n'),(468,4,58,0,93,'14-year-old Will Burrows has little in common with his strange, dysfunctional family. In fact, the only bond he shares with his eccentric father is a passion for archaeological excavation. So when Dad mysteriously vanishes, Will is compelled to dig up the truth behind his disappearance. He unearths the unbelievable: a secret subterranean society... . Vietnamese translation by Ly Lan, who also translated the 7-volume of Harry Potter. In Vietnamese. Distributed by Tsai Fong Books, Inc.\r\n'),(469,4,68,0,93,''),(470,4,89,0,93,''),(471,4,502,0,94,'Kim Dong'),(472,4,57,0,94,'Comic story about Edison in the series \"Story of 10 Famous people and their EQ.\" Original Korean story and illustration by Han Kyeol. Vietnamese translation by Nguyen Thi Tham and Nguyen Kim Dung. Distributed by Tsai Fong Books, Inc.\r\n'),(473,4,58,0,94,'Comic story about Edison in the series \"Story of 10 Famous people and their EQ.\" Original Korean story and illustration by Han Kyeol. Vietnamese translation by Nguyen Thi Tham and Nguyen Kim Dung. Distributed by Tsai Fong Books, Inc.\r\n'),(474,4,68,0,94,''),(475,4,89,0,94,''),(476,4,502,0,95,'Kim Dong'),(477,4,57,0,95,'Comic story about the brilliant English scientist who invented calculus, among his numerous discoveries... Original Korean story by Mi-Sun Lee with illustration by Tae-Won Kwon. Vietnamese translation by Nguyen Thi Tham and Nguyen Kim Dung. Distributed by Tsai Fong Books, Inc.\r\n'),(478,4,58,0,95,'Comic story about the brilliant English scientist who invented calculus, among his numerous discoveries... Original Korean story by Mi-Sun Lee with illustration by Tae-Won Kwon. Vietnamese translation by Nguyen Thi Tham and Nguyen Kim Dung. Distributed by Tsai Fong Books, Inc.\r\n'),(479,4,68,0,95,''),(480,4,89,0,95,''),(481,4,502,0,96,'Kim Dong'),(482,4,57,0,96,'Comic story about the French emperor Napoleon Bonaparte who was a great militarist and who was famous for the saying \"Nothing is impossible.\" Original Korean story by Naite with illustration by Tae-Won Kwon. Vietnamese translation by Nguyen Thi Tham and Nguyen Kim Dung. Distributed by Tsai Fong Books, Inc.\r\n'),(483,4,58,0,96,'Comic story about the French emperor Napoleon Bonaparte who was a great militarist and who was famous for the saying \"Nothing is impossible.\" Original Korean story by Naite with illustration by Tae-Won Kwon. Vietnamese translation by Nguyen Thi Tham and Nguyen Kim Dung. Distributed by Tsai Fong Books, Inc.\r\n'),(484,4,68,0,96,''),(485,4,89,0,96,''),(486,4,502,0,97,'Kim Dong'),(487,4,57,0,97,'Comic story about the Alfred Bernhard Nobel who had left behind 350 inventions and discoveries and who had given his whole estate to promote peace. Original Korean story and illustrations by Han Kyeol. Vietnamese translation by Nguyen Thi Tham and Nguyen Kim Dung. Distributed by Tsai Fong Books, Inc.\r\n'),(488,4,58,0,97,'Comic story about the Alfred Bernhard Nobel who had left behind 350 inventions and discoveries and who had given his whole estate to promote peace. Original Korean story and illustrations by Han Kyeol. Vietnamese translation by Nguyen Thi Tham and Nguyen Kim Dung. Distributed by Tsai Fong Books, Inc.\r\n'),(489,4,68,0,97,''),(490,4,89,0,97,''),(491,4,502,0,98,'Kim Dong'),(492,4,57,0,98,'Comic story about Fabre, a French scientist who specialized in the study of insects, in the series \"Story of 10 Famous people and their EQ.\" Original Korean story and illustration by Han Kyeol. Vietnamese translation by Nguyen Thi Tham and Nguyen Kim Dung. Distributed by Tsai Fong Books, Inc.\r\n'),(493,4,58,0,98,'Comic story about Fabre, a French scientist who specialized in the study of insects, in the series \"Story of 10 Famous people and their EQ.\" Original Korean story and illustration by Han Kyeol. Vietnamese translation by Nguyen Thi Tham and Nguyen Kim Dung. Distributed by Tsai Fong Books, Inc.\r\n'),(494,4,68,0,98,''),(495,4,89,0,98,''),(496,4,502,0,99,'Kim Dong'),(497,4,57,0,99,'Comic story about the French scientist who was the first female scientist to receive 2 Nobel prizes. Original Korean story by Nam-Kil Kim with illustration by Jeong-Hyeon Back. Vietnamese translation by Nguyen Thi Tham and Nguyen Kim Dung. Distributed by Tsai Fong Books, Inc.\r\n'),(498,4,58,0,99,'Comic story about the French scientist who was the first female scientist to receive 2 Nobel prizes. Original Korean story by Nam-Kil Kim with illustration by Jeong-Hyeon Back. Vietnamese translation by Nguyen Thi Tham and Nguyen Kim Dung. Distributed by Tsai Fong Books, Inc.\r\n'),(499,4,68,0,99,''),(500,4,89,0,99,''),(501,4,502,0,100,'Kim Dong'),(502,4,57,0,100,'Comic story about Helen Keller who was deaf and blind since she was 2 years old, and with extraordinary effort and her teachers help, had graduated from Radcliff and devoted her life to helping the handicapped. Original Korean story and illustration by Jong-Kwan Park. Vietnamese translation by Nguyen Thi Tham and Nguyen Kim Dung. Distributed by Tsai Fong Books, Inc.\r\n'),(503,4,58,0,100,'Comic story about Helen Keller who was deaf and blind since she was 2 years old, and with extraordinary effort and her teachers help, had graduated from Radcliff and devoted her life to helping the handicapped. Original Korean story and illustration by Jong-Kwan Park. Vietnamese translation by Nguyen Thi Tham and Nguyen Kim Dung. Distributed by Tsai Fong Books, Inc.\r\n'),(504,4,68,0,100,''),(505,4,89,0,100,'');
/*!40000 ALTER TABLE `catalog_product_entity_text` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalog_product_entity_tier_price`
--

DROP TABLE IF EXISTS `catalog_product_entity_tier_price`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalog_product_entity_tier_price` (
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
  KEY `FK_CATALOG_PRODUCT_TIER_WEBSITE` (`website_id`),
  CONSTRAINT `FK_CATALOG_PRODUCT_TIER_WEBSITE` FOREIGN KEY (`website_id`) REFERENCES `core_website` (`website_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CATALOG_PRODUCT_ENTITY_TIER_PRICE_GROUP` FOREIGN KEY (`customer_group_id`) REFERENCES `customer_group` (`customer_group_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CATALOG_PRODUCT_ENTITY_TIER_PRICE_PRODUCT_ENTITY` FOREIGN KEY (`entity_id`) REFERENCES `catalog_product_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalog_product_entity_tier_price`
--

LOCK TABLES `catalog_product_entity_tier_price` WRITE;
/*!40000 ALTER TABLE `catalog_product_entity_tier_price` DISABLE KEYS */;
/*!40000 ALTER TABLE `catalog_product_entity_tier_price` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalog_product_entity_varchar`
--

DROP TABLE IF EXISTS `catalog_product_entity_varchar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalog_product_entity_varchar` (
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
  KEY `FK_CATALOG_PRODUCT_ENTITY_VARCHAR_PRODUCT_ENTITY` (`entity_id`),
  CONSTRAINT `FK_CATALOG_PRODUCT_ENTITY_VARCHAR_ATTRIBUTE` FOREIGN KEY (`attribute_id`) REFERENCES `eav_attribute` (`attribute_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CATALOG_PRODUCT_ENTITY_VARCHAR_PRODUCT_ENTITY` FOREIGN KEY (`entity_id`) REFERENCES `catalog_product_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CATALOG_PRODUCT_ENTITY_VARCHAR_STORE` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2526 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalog_product_entity_varchar`
--

LOCK TABLES `catalog_product_entity_varchar` WRITE;
/*!40000 ALTER TABLE `catalog_product_entity_varchar` DISABLE KEYS */;
INSERT INTO `catalog_product_entity_varchar` VALUES (26,4,56,0,1,'Time to Jam! [With Stickers]'),(27,4,67,0,1,''),(28,4,69,0,1,''),(29,4,82,0,1,'Time-to-Jam!-[With-Stickers]-0030099690202'),(30,4,83,0,1,'Time-to-Jam!-[With-Stickers]-0030099690202.html'),(31,4,92,0,1,'container2'),(32,4,95,0,1,''),(33,4,96,0,1,''),(34,4,97,0,1,''),(35,4,469,0,1,'2'),(36,4,496,0,1,'Gist, Karin & Hicks, Regina & Brown, Julie'),(37,4,497,0,1,'0030099690202'),(38,4,499,0,1,'paperback'),(39,4,500,0,1,''),(40,4,503,0,1,'English'),(41,4,504,0,1,'28'),(42,4,505,0,1,'19.304x12.446x1.016'),(43,4,506,0,1,''),(44,4,507,0,1,'  '),(45,4,509,0,1,''),(46,4,70,0,1,'/P/2/P20030099690202.jpg'),(47,4,71,0,1,'/P/2/P20030099690202.jpg'),(48,4,72,0,1,'/P/2/P20030099690202.jpg'),(49,4,511,0,1,'0'),(50,4,512,0,1,'US'),(51,4,56,0,2,'Chanukah Medley; For String & Wind Combinations #991258: For String & Wind Combinations'),(52,4,67,0,2,''),(53,4,69,0,2,''),(54,4,82,0,2,'Chanukah-Medley;-For-String-&-Wind-Combinations-#991258:-For-String-&-Wind-Combinations-0073999668766'),(55,4,83,0,2,'Chanukah-Medley;-For-String-&-Wind-Combinations-#991258:-For-String-&-Wind-Combinations-0073999668766.html'),(56,4,92,0,2,'container2'),(57,4,95,0,2,''),(58,4,96,0,2,''),(59,4,97,0,2,''),(60,4,469,0,2,'2'),(61,4,496,0,2,'Bronstein, Tamar'),(62,4,497,0,2,'0073999668766'),(63,4,499,0,2,'paperback'),(64,4,500,0,2,''),(65,4,503,0,2,'English'),(66,4,504,0,2,'0'),(67,4,505,0,2,'30.3784x22.9616x0.3048'),(68,4,506,0,2,''),(69,4,507,0,2,'  '),(70,4,509,0,2,''),(71,4,70,0,2,'/C/6/C60073999668766.jpg'),(72,4,71,0,2,'/C/6/C60073999668766.jpg'),(73,4,72,0,2,'/C/6/C60073999668766.jpg'),(74,4,511,0,2,'0'),(75,4,512,0,2,'US'),(76,4,56,0,3,'Can We Talk? Leader Kit: Soul-Stirring Conversations with God'),(77,4,67,0,3,''),(78,4,69,0,3,''),(79,4,82,0,3,'Can-We-Talk?-Leader-Kit:-Soul-Stirring-Conversations-with-God-0634337008486'),(80,4,83,0,3,'Can-We-Talk?-Leader-Kit:-Soul-Stirring-Conversations-with-God-0634337008486.html'),(81,4,92,0,3,'container2'),(82,4,95,0,3,''),(83,4,96,0,3,''),(84,4,97,0,3,''),(85,4,469,0,3,'2'),(86,4,496,0,3,'Shirer, Priscilla'),(87,4,497,0,3,'0634337008486'),(88,4,499,0,3,'paperback'),(89,4,500,0,3,''),(90,4,503,0,3,'English'),(91,4,504,0,3,'0'),(92,4,505,0,3,'0x0x0'),(93,4,506,0,3,''),(94,4,507,0,3,'  '),(95,4,509,0,3,''),(96,4,70,0,3,'/D/6/D60634337008486.jpg'),(97,4,71,0,3,'/D/6/D60634337008486.jpg'),(98,4,72,0,3,'/D/6/D60634337008486.jpg'),(99,4,511,0,3,'0'),(100,4,512,0,3,'US'),(101,4,56,0,4,'Mystery of Moosehead Falls [With CD]'),(102,4,67,0,4,''),(103,4,69,0,4,''),(104,4,82,0,4,'Mystery-of-Moosehead-Falls-[With-CD]-0690249442220'),(105,4,83,0,4,'Mystery-of-Moosehead-Falls-[With-CD]-0690249442220.html'),(106,4,92,0,4,'container2'),(107,4,95,0,4,''),(108,4,96,0,4,''),(109,4,97,0,4,''),(110,4,469,0,4,'2'),(111,4,496,0,4,'Knoche, Keith & Wood, Jeff'),(112,4,497,0,4,'0690249442220'),(113,4,499,0,4,'paperback'),(114,4,500,0,4,''),(115,4,503,0,4,'English'),(116,4,504,0,4,'20'),(117,4,505,0,4,'28.0162x21.6916x1.6764'),(118,4,506,0,4,''),(119,4,507,0,4,'  '),(120,4,509,0,4,''),(121,4,70,0,4,'/U/0/U00690249442220.jpg'),(122,4,71,0,4,'/U/0/U00690249442220.jpg'),(123,4,72,0,4,'/U/0/U00690249442220.jpg'),(124,4,511,0,4,'0'),(125,4,512,0,4,'US'),(126,4,56,0,5,'Mystery of Moosehead Falls [With Cassette]'),(127,4,67,0,5,''),(128,4,69,0,5,''),(129,4,82,0,5,'Mystery-of-Moosehead-Falls-[With-Cassette]-0690249442244'),(130,4,83,0,5,'Mystery-of-Moosehead-Falls-[With-Cassette]-0690249442244.html'),(131,4,92,0,5,'container2'),(132,4,95,0,5,''),(133,4,96,0,5,''),(134,4,97,0,5,''),(135,4,469,0,5,'2'),(136,4,496,0,5,'Knoche, Keith & Wood, Jeff'),(137,4,497,0,5,'0690249442244'),(138,4,499,0,5,'paperback'),(139,4,500,0,5,''),(140,4,503,0,5,'English'),(141,4,504,0,5,'20'),(142,4,505,0,5,'28.067x21.6154x2.2352'),(143,4,506,0,5,''),(144,4,507,0,5,'  '),(145,4,509,0,5,''),(146,4,70,0,5,'/M/4/M40690249442244.jpg'),(147,4,71,0,5,'/M/4/M40690249442244.jpg'),(148,4,72,0,5,'/M/4/M40690249442244.jpg'),(149,4,511,0,5,'0'),(150,4,512,0,5,'US'),(151,4,56,0,6,'In Adoration of the King of Kings'),(152,4,67,0,6,''),(153,4,69,0,6,''),(154,4,82,0,6,'In-Adoration-of-the-King-of-Kings-0765762013001'),(155,4,83,0,6,'In-Adoration-of-the-King-of-Kings-0765762013001.html'),(156,4,92,0,6,'container2'),(157,4,95,0,6,''),(158,4,96,0,6,''),(159,4,97,0,6,''),(160,4,469,0,6,'2'),(161,4,496,0,6,'Fettke, Kirkland'),(162,4,497,0,6,'0765762013001'),(163,4,499,0,6,'paperback'),(164,4,500,0,6,''),(165,4,503,0,6,'English'),(166,4,504,0,6,'0'),(167,4,505,0,6,'0x0x0'),(168,4,506,0,6,''),(169,4,507,0,6,'  '),(170,4,509,0,6,''),(171,4,70,0,6,'/N/1/N10765762013001.jpg'),(172,4,71,0,6,'/N/1/N10765762013001.jpg'),(173,4,72,0,6,'/N/1/N10765762013001.jpg'),(174,4,511,0,6,'0'),(175,4,512,0,6,'US'),(176,4,56,0,7,'All on a Christmas Day Director\'s Production Guide [With Video]'),(177,4,67,0,7,''),(178,4,69,0,7,''),(179,4,82,0,7,'All-on-a-Christmas-Day-Directors-Production-Guide-[With-Video]-0765762060401'),(180,4,83,0,7,'All-on-a-Christmas-Day-Directors-Production-Guide-[With-Video]-0765762060401.html'),(181,4,92,0,7,'container2'),(182,4,95,0,7,''),(183,4,96,0,7,''),(184,4,97,0,7,''),(185,4,469,0,7,'2'),(186,4,496,0,7,'Allen, Dennis & Allen, Nan'),(187,4,497,0,7,'0765762060401'),(188,4,499,0,7,''),(189,4,500,0,7,''),(190,4,503,0,7,'English'),(191,4,504,0,7,'0'),(192,4,505,0,7,'29.6926x26.3144x4.0132'),(193,4,506,0,7,''),(194,4,507,0,7,'  '),(195,4,509,0,7,''),(196,4,70,0,7,'/O/1/O10765762060401.jpg'),(197,4,71,0,7,'/O/1/O10765762060401.jpg'),(198,4,72,0,7,'/O/1/O10765762060401.jpg'),(199,4,511,0,7,'0'),(200,4,512,0,7,'US'),(201,4,56,0,8,'More Than Worthy with Offering'),(202,4,67,0,8,''),(203,4,69,0,8,''),(204,4,82,0,8,'More-Than-Worthy-with-Offering-0765762072008'),(205,4,83,0,8,'More-Than-Worthy-with-Offering-0765762072008.html'),(206,4,92,0,8,'container2'),(207,4,95,0,8,''),(208,4,96,0,8,''),(209,4,97,0,8,''),(210,4,469,0,8,'2'),(211,4,496,0,8,'Smith, J. Daniel'),(212,4,497,0,8,'0765762072008'),(213,4,499,0,8,'paperback'),(214,4,500,0,8,''),(215,4,503,0,8,'English'),(216,4,504,0,8,'72'),(217,4,505,0,8,'0x0x0'),(218,4,506,0,8,''),(219,4,507,0,8,'  '),(220,4,509,0,8,''),(221,4,70,0,8,'/O/8/O80765762072008.jpg'),(222,4,71,0,8,'/O/8/O80765762072008.jpg'),(223,4,72,0,8,'/O/8/O80765762072008.jpg'),(224,4,511,0,8,'0'),(225,4,512,0,8,'US'),(226,4,56,0,9,'All the Best for Christmas: 21 Choral Favorites for Pageant, Concert, or Worship'),(227,4,67,0,9,''),(228,4,69,0,9,''),(229,4,82,0,9,'All-the-Best-for-Christmas:-21-Choral-Favorites-for-Pageant,-Concert,-or-Worship-0765762092501'),(230,4,83,0,9,'All-the-Best-for-Christmas:-21-Choral-Favorites-for-Pageant,-Concert,-or-Worship-0765762092501.html'),(231,4,92,0,9,'container2'),(232,4,95,0,9,''),(233,4,96,0,9,''),(234,4,97,0,9,''),(235,4,469,0,9,'2'),(236,4,496,0,9,'Various'),(237,4,497,0,9,'0765762092501'),(238,4,499,0,9,'paperback'),(239,4,500,0,9,''),(240,4,503,0,9,'English'),(241,4,504,0,9,'0'),(242,4,505,0,9,'0x0x0'),(243,4,506,0,9,''),(244,4,507,0,9,'  '),(245,4,509,0,9,''),(246,4,70,0,9,'/M/1/M10765762092501.jpg'),(247,4,71,0,9,'/M/1/M10765762092501.jpg'),(248,4,72,0,9,'/M/1/M10765762092501.jpg'),(249,4,511,0,9,'0'),(250,4,512,0,9,'US'),(251,4,56,0,10,'Christ Is Born, Sing Alleluia'),(252,4,67,0,10,''),(253,4,69,0,10,''),(254,4,82,0,10,'Christ-Is-Born,-Sing-Alleluia-0765762101609'),(255,4,83,0,10,'Christ-Is-Born,-Sing-Alleluia-0765762101609.html'),(256,4,92,0,10,'container2'),(257,4,95,0,10,''),(258,4,96,0,10,''),(259,4,97,0,10,''),(260,4,469,0,10,'2'),(261,4,496,0,10,'Parks, Marty'),(262,4,497,0,10,'0765762101609'),(263,4,499,0,10,'paperback'),(264,4,500,0,10,''),(265,4,503,0,10,'English'),(266,4,504,0,10,'60'),(267,4,505,0,10,'27.686x21.082x0.254'),(268,4,506,0,10,''),(269,4,507,0,10,'  '),(270,4,509,0,10,''),(271,4,70,0,10,'/G/9/G90765762101609.jpg'),(272,4,71,0,10,'/G/9/G90765762101609.jpg'),(273,4,72,0,10,'/G/9/G90765762101609.jpg'),(274,4,511,0,10,'0'),(275,4,512,0,10,'US'),(276,4,56,0,11,'Great Is the Lord Almighty'),(277,4,67,0,11,''),(278,4,69,0,11,''),(279,4,82,0,11,'Great-Is-the-Lord-Almighty-0765762106000'),(280,4,83,0,11,'Great-Is-the-Lord-Almighty-0765762106000.html'),(281,4,92,0,11,'container2'),(282,4,95,0,11,''),(283,4,96,0,11,''),(284,4,97,0,11,''),(285,4,469,0,11,'2'),(286,4,496,0,11,'Greer, Bruce Arr'),(287,4,497,0,11,'0765762106000'),(288,4,499,0,11,'paperback'),(289,4,500,0,11,''),(290,4,503,0,11,'English'),(291,4,504,0,11,'0'),(292,4,505,0,11,'0x0x0'),(293,4,506,0,11,''),(294,4,507,0,11,'  '),(295,4,509,0,11,''),(296,4,70,0,11,'/J/0/J00765762106000.jpg'),(297,4,71,0,11,'/J/0/J00765762106000.jpg'),(298,4,72,0,11,'/J/0/J00765762106000.jpg'),(299,4,511,0,11,'0'),(300,4,512,0,11,'US'),(301,4,56,0,12,'Here I Am to Worship'),(302,4,67,0,12,''),(303,4,69,0,12,''),(304,4,82,0,12,'Here-I-Am-to-Worship-0765762108004'),(305,4,83,0,12,'Here-I-Am-to-Worship-0765762108004.html'),(306,4,92,0,12,'container2'),(307,4,95,0,12,''),(308,4,96,0,12,''),(309,4,97,0,12,''),(310,4,469,0,12,'2'),(311,4,496,0,12,'Mauldin, Russell'),(312,4,497,0,12,'0765762108004'),(313,4,499,0,12,'paperback'),(314,4,500,0,12,''),(315,4,503,0,12,'English'),(316,4,504,0,12,'0'),(317,4,505,0,12,'27.686x21.082x1.016'),(318,4,506,0,12,''),(319,4,507,0,12,'  '),(320,4,509,0,12,''),(321,4,70,0,12,'/X/4/X40765762108004.jpg'),(322,4,71,0,12,'/X/4/X40765762108004.jpg'),(323,4,72,0,12,'/X/4/X40765762108004.jpg'),(324,4,511,0,12,'0'),(325,4,512,0,12,'US'),(326,4,56,0,13,'Jesus, Draw Me Ever Nearer'),(327,4,67,0,13,''),(328,4,69,0,13,''),(329,4,82,0,13,'Jesus,-Draw-Me-Ever-Nearer-0765762112506'),(330,4,83,0,13,'Jesus,-Draw-Me-Ever-Nearer-0765762112506.html'),(331,4,92,0,13,'container2'),(332,4,95,0,13,''),(333,4,96,0,13,''),(334,4,97,0,13,''),(335,4,469,0,13,'2'),(336,4,496,0,13,'Lawrence, Michael Arr'),(337,4,497,0,13,'0765762112506'),(338,4,499,0,13,'paperback'),(339,4,500,0,13,''),(340,4,503,0,13,'English'),(341,4,504,0,13,'0'),(342,4,505,0,13,'0x0x0'),(343,4,506,0,13,''),(344,4,507,0,13,'  '),(345,4,509,0,13,''),(346,4,70,0,13,'/D/6/D60765762112506.jpg'),(347,4,71,0,13,'/D/6/D60765762112506.jpg'),(348,4,72,0,13,'/D/6/D60765762112506.jpg'),(349,4,511,0,13,'0'),(350,4,512,0,13,'US'),(351,4,56,0,14,'The Lord Is the Strength of My Life'),(352,4,67,0,14,''),(353,4,69,0,14,''),(354,4,82,0,14,'The-Lord-Is-the-Strength-of-My-Life-0765762114906'),(355,4,83,0,14,'The-Lord-Is-the-Strength-of-My-Life-0765762114906.html'),(356,4,92,0,14,'container2'),(357,4,95,0,14,''),(358,4,96,0,14,''),(359,4,97,0,14,''),(360,4,469,0,14,'2'),(361,4,496,0,14,'Kirkland, Camp'),(362,4,497,0,14,'0765762114906'),(363,4,499,0,14,'paperback'),(364,4,500,0,14,''),(365,4,503,0,14,'English'),(366,4,504,0,14,'61'),(367,4,505,0,14,'0x0x0'),(368,4,506,0,14,''),(369,4,507,0,14,'  '),(370,4,509,0,14,''),(371,4,70,0,14,'/R/6/R60765762114906.jpg'),(372,4,71,0,14,'/R/6/R60765762114906.jpg'),(373,4,72,0,14,'/R/6/R60765762114906.jpg'),(374,4,511,0,14,'0'),(375,4,512,0,14,'US'),(376,4,56,0,15,'Salvation Belongs to Our God'),(377,4,67,0,15,''),(378,4,69,0,15,''),(379,4,82,0,15,'Salvation-Belongs-to-Our-God-0765762119406'),(380,4,83,0,15,'Salvation-Belongs-to-Our-God-0765762119406.html'),(381,4,92,0,15,'container2'),(382,4,95,0,15,''),(383,4,96,0,15,''),(384,4,97,0,15,''),(385,4,469,0,15,'2'),(386,4,496,0,15,'Arr by Greer, Bruce'),(387,4,497,0,15,'0765762119406'),(388,4,499,0,15,'paperback'),(389,4,500,0,15,''),(390,4,503,0,15,'English'),(391,4,504,0,15,'0'),(392,4,505,0,15,'27.432x21.336x1.524'),(393,4,506,0,15,''),(394,4,507,0,15,'  '),(395,4,509,0,15,''),(396,4,70,0,15,'/M/6/M60765762119406.jpg'),(397,4,71,0,15,'/M/6/M60765762119406.jpg'),(398,4,72,0,15,'/M/6/M60765762119406.jpg'),(399,4,511,0,15,'0'),(400,4,512,0,15,'US'),(401,4,56,0,16,'Shout to the North with O Zion, Haste'),(402,4,67,0,16,''),(403,4,69,0,16,''),(404,4,82,0,16,'Shout-to-the-North-with-O-Zion,-Haste-0765762119901'),(405,4,83,0,16,'Shout-to-the-North-with-O-Zion,-Haste-0765762119901.html'),(406,4,92,0,16,'container2'),(407,4,95,0,16,''),(408,4,96,0,16,''),(409,4,97,0,16,''),(410,4,469,0,16,'2'),(411,4,496,0,16,'Greer, Bruce'),(412,4,497,0,16,'0765762119901'),(413,4,499,0,16,'paperback'),(414,4,500,0,16,''),(415,4,503,0,16,'English'),(416,4,504,0,16,'0'),(417,4,505,0,16,'0x0x0'),(418,4,506,0,16,''),(419,4,507,0,16,'  '),(420,4,509,0,16,''),(421,4,70,0,16,'/M/1/M10765762119901.jpg'),(422,4,71,0,16,'/M/1/M10765762119901.jpg'),(423,4,72,0,16,'/M/1/M10765762119901.jpg'),(424,4,511,0,16,'0'),(425,4,512,0,16,'US'),(426,4,56,0,17,'Your Grace Still Amazes Me'),(427,4,67,0,17,''),(428,4,69,0,17,''),(429,4,82,0,17,'Your-Grace-Still-Amazes-Me-0765762127807'),(430,4,83,0,17,'Your-Grace-Still-Amazes-Me-0765762127807.html'),(431,4,92,0,17,'container2'),(432,4,95,0,17,''),(433,4,96,0,17,''),(434,4,97,0,17,''),(435,4,469,0,17,'2'),(436,4,496,0,17,'Arr by Bourland, Gaylen'),(437,4,497,0,17,'0765762127807'),(438,4,499,0,17,'paperback'),(439,4,500,0,17,''),(440,4,503,0,17,'English'),(441,4,504,0,17,'58'),(442,4,505,0,17,'0x0x0'),(443,4,506,0,17,''),(444,4,507,0,17,'  '),(445,4,509,0,17,''),(446,4,70,0,17,'/C/7/C70765762127807.jpg'),(447,4,71,0,17,'/C/7/C70765762127807.jpg'),(448,4,72,0,17,'/C/7/C70765762127807.jpg'),(449,4,511,0,17,'0'),(450,4,512,0,17,'US'),(451,4,56,0,18,'Gloria'),(452,4,67,0,18,''),(453,4,69,0,18,''),(454,4,82,0,18,'Gloria-0765762132702'),(455,4,83,0,18,'Gloria-0765762132702.html'),(456,4,92,0,18,'container2'),(457,4,95,0,18,''),(458,4,96,0,18,''),(459,4,97,0,18,''),(460,4,469,0,18,'2'),(461,4,496,0,18,'Allen, Phillip'),(462,4,497,0,18,'0765762132702'),(463,4,499,0,18,'paperback'),(464,4,500,0,18,''),(465,4,503,0,18,'English'),(466,4,504,0,18,'0'),(467,4,505,0,18,'0x0x0'),(468,4,506,0,18,''),(469,4,507,0,18,'  '),(470,4,509,0,18,''),(471,4,70,0,18,'/B/2/B20765762132702.jpg'),(472,4,71,0,18,'/B/2/B20765762132702.jpg'),(473,4,72,0,18,'/B/2/B20765762132702.jpg'),(474,4,511,0,18,'0'),(475,4,512,0,18,'US'),(476,4,56,0,19,'The Lord Is My Light'),(477,4,67,0,19,''),(478,4,69,0,19,''),(479,4,82,0,19,'The-Lord-Is-My-Light-0765762132801'),(480,4,83,0,19,'The-Lord-Is-My-Light-0765762132801.html'),(481,4,92,0,19,'container2'),(482,4,95,0,19,''),(483,4,96,0,19,''),(484,4,97,0,19,''),(485,4,469,0,19,'2'),(486,4,496,0,19,'Hamby, Marty'),(487,4,497,0,19,'0765762132801'),(488,4,499,0,19,'paperback'),(489,4,500,0,19,''),(490,4,503,0,19,'English'),(491,4,504,0,19,'0'),(492,4,505,0,19,'0x0x0'),(493,4,506,0,19,''),(494,4,507,0,19,'  '),(495,4,509,0,19,''),(496,4,70,0,19,'/B/1/B10765762132801.jpg'),(497,4,71,0,19,'/B/1/B10765762132801.jpg'),(498,4,72,0,19,'/B/1/B10765762132801.jpg'),(499,4,511,0,19,'0'),(500,4,512,0,19,'US'),(501,4,56,0,20,'Messiah Suite'),(502,4,67,0,20,''),(503,4,69,0,20,''),(504,4,82,0,20,'Messiah-Suite-0765762132900'),(505,4,83,0,20,'Messiah-Suite-0765762132900.html'),(506,4,92,0,20,'container2'),(507,4,95,0,20,''),(508,4,96,0,20,''),(509,4,97,0,20,''),(510,4,469,0,20,'2'),(511,4,496,0,20,'Christopher, Keith'),(512,4,497,0,20,'0765762132900'),(513,4,499,0,20,'paperback'),(514,4,500,0,20,''),(515,4,503,0,20,'English'),(516,4,504,0,20,'0'),(517,4,505,0,20,'0x0x0'),(518,4,506,0,20,''),(519,4,507,0,20,'  '),(520,4,509,0,20,''),(521,4,70,0,20,'/B/0/B00765762132900.jpg'),(522,4,71,0,20,'/B/0/B00765762132900.jpg'),(523,4,72,0,20,'/B/0/B00765762132900.jpg'),(524,4,511,0,20,'0'),(525,4,512,0,20,'US'),(526,4,56,0,21,'Easter Song'),(527,4,67,0,21,''),(528,4,69,0,21,''),(529,4,82,0,21,'Easter-Song-0765762133303'),(530,4,83,0,21,'Easter-Song-0765762133303.html'),(531,4,92,0,21,'container2'),(532,4,95,0,21,''),(533,4,96,0,21,''),(534,4,97,0,21,''),(535,4,469,0,21,'2'),(536,4,496,0,21,'Greer, Bruce (Arranger)'),(537,4,497,0,21,'0765762133303'),(538,4,499,0,21,'paperback'),(539,4,500,0,21,''),(540,4,503,0,21,'English'),(541,4,504,0,21,'0'),(542,4,505,0,21,'0x0x0'),(543,4,506,0,21,''),(544,4,507,0,21,'  '),(545,4,509,0,21,''),(546,4,70,0,21,'/M/3/M30765762133303.jpg'),(547,4,71,0,21,'/M/3/M30765762133303.jpg'),(548,4,72,0,21,'/M/3/M30765762133303.jpg'),(549,4,511,0,21,'0'),(550,4,512,0,21,'US'),(551,4,56,0,22,'How Beautiful'),(552,4,67,0,22,''),(553,4,69,0,22,''),(554,4,82,0,22,'How-Beautiful-0765762133600'),(555,4,83,0,22,'How-Beautiful-0765762133600.html'),(556,4,92,0,22,'container2'),(557,4,95,0,22,''),(558,4,96,0,22,''),(559,4,97,0,22,''),(560,4,469,0,22,'2'),(561,4,496,0,22,'Winkler, David'),(562,4,497,0,22,'0765762133600'),(563,4,499,0,22,'paperback'),(564,4,500,0,22,''),(565,4,503,0,22,'English'),(566,4,504,0,22,'0'),(567,4,505,0,22,'0x0x0'),(568,4,506,0,22,''),(569,4,507,0,22,'  '),(570,4,509,0,22,''),(571,4,70,0,22,'/M/0/M00765762133600.jpg'),(572,4,71,0,22,'/M/0/M00765762133600.jpg'),(573,4,72,0,22,'/M/0/M00765762133600.jpg'),(574,4,511,0,22,'0'),(575,4,512,0,22,'US'),(576,4,56,0,23,'O Come, O Come, Emmanuel'),(577,4,67,0,23,''),(578,4,69,0,23,''),(579,4,82,0,23,'O-Come,-O-Come,-Emmanuel-0765762133808'),(580,4,83,0,23,'O-Come,-O-Come,-Emmanuel-0765762133808.html'),(581,4,92,0,23,'container2'),(582,4,95,0,23,''),(583,4,96,0,23,''),(584,4,97,0,23,''),(585,4,469,0,23,'2'),(586,4,496,0,23,'Hill, Kyle'),(587,4,497,0,23,'0765762133808'),(588,4,499,0,23,'paperback'),(589,4,500,0,23,''),(590,4,503,0,23,'English'),(591,4,504,0,23,'0'),(592,4,505,0,23,'29.464x22.606x1.016'),(593,4,506,0,23,''),(594,4,507,0,23,'  '),(595,4,509,0,23,''),(596,4,70,0,23,'/E/8/E80765762133808.jpg'),(597,4,71,0,23,'/E/8/E80765762133808.jpg'),(598,4,72,0,23,'/E/8/E80765762133808.jpg'),(599,4,511,0,23,'0'),(600,4,512,0,23,'US'),(601,4,56,0,24,'Now Unto the King Eternal W/ Immortal, Invisible'),(602,4,67,0,24,''),(603,4,69,0,24,''),(604,4,82,0,24,'Now-Unto-the-King-Eternal-W/-Immortal,-Invisible-0765762134201'),(605,4,83,0,24,'Now-Unto-the-King-Eternal-W/-Immortal,-Invisible-0765762134201.html'),(606,4,92,0,24,'container2'),(607,4,95,0,24,''),(608,4,96,0,24,''),(609,4,97,0,24,''),(610,4,469,0,24,'2'),(611,4,496,0,24,'Cranfill, Jeff'),(612,4,497,0,24,'0765762134201'),(613,4,499,0,24,'paperback'),(614,4,500,0,24,''),(615,4,503,0,24,'English'),(616,4,504,0,24,'0'),(617,4,505,0,24,'30.226x21.082x1.016'),(618,4,506,0,24,''),(619,4,507,0,24,'  '),(620,4,509,0,24,''),(621,4,70,0,24,'/X/1/X10765762134201.jpg'),(622,4,71,0,24,'/X/1/X10765762134201.jpg'),(623,4,72,0,24,'/X/1/X10765762134201.jpg'),(624,4,511,0,24,'0'),(625,4,512,0,24,'US'),(626,4,56,0,25,'I\'m Feeling Fine W/ Goodby, World, Goodby'),(627,4,67,0,25,''),(628,4,69,0,25,''),(629,4,82,0,25,'Im-Feeling-Fine-W/-Goodby,-World,-Goodby-0765762134409'),(630,4,83,0,25,'Im-Feeling-Fine-W/-Goodby,-World,-Goodby-0765762134409.html'),(631,4,92,0,25,'container2'),(632,4,95,0,25,''),(633,4,96,0,25,''),(634,4,97,0,25,''),(635,4,469,0,25,'2'),(636,4,496,0,25,'Hogan, Ed (Arranger)'),(637,4,497,0,25,'0765762134409'),(638,4,499,0,25,'paperback'),(639,4,500,0,25,''),(640,4,503,0,25,'English'),(641,4,504,0,25,'0'),(642,4,505,0,25,'0x0x0'),(643,4,506,0,25,''),(644,4,507,0,25,'  '),(645,4,509,0,25,''),(646,4,70,0,25,'/P/9/P90765762134409.jpg'),(647,4,71,0,25,'/P/9/P90765762134409.jpg'),(648,4,72,0,25,'/P/9/P90765762134409.jpg'),(649,4,511,0,25,'0'),(650,4,512,0,25,'US'),(651,4,56,0,26,'Freedom\'s Song'),(652,4,67,0,26,''),(653,4,69,0,26,''),(654,4,82,0,26,'Freedoms-Song-0765762134508'),(655,4,83,0,26,'Freedoms-Song-0765762134508.html'),(656,4,92,0,26,'container2'),(657,4,95,0,26,''),(658,4,96,0,26,''),(659,4,97,0,26,''),(660,4,469,0,26,'2'),(661,4,496,0,26,'Parks, Marty'),(662,4,497,0,26,'0765762134508'),(663,4,499,0,26,'paperback'),(664,4,500,0,26,''),(665,4,503,0,26,'English'),(666,4,504,0,26,'0'),(667,4,505,0,26,'0x0x0'),(668,4,506,0,26,''),(669,4,507,0,26,'  '),(670,4,509,0,26,''),(671,4,70,0,26,'/P/8/P80765762134508.jpg'),(672,4,71,0,26,'/P/8/P80765762134508.jpg'),(673,4,72,0,26,'/P/8/P80765762134508.jpg'),(674,4,511,0,26,'0'),(675,4,512,0,26,'US'),(676,4,56,0,27,'No Other Name'),(677,4,67,0,27,''),(678,4,69,0,27,''),(679,4,82,0,27,'No-Other-Name-0765762134607'),(680,4,83,0,27,'No-Other-Name-0765762134607.html'),(681,4,92,0,27,'container2'),(682,4,95,0,27,''),(683,4,96,0,27,''),(684,4,97,0,27,''),(685,4,469,0,27,'2'),(686,4,496,0,27,'Cranfill, Jeff'),(687,4,497,0,27,'0765762134607'),(688,4,499,0,27,'paperback'),(689,4,500,0,27,''),(690,4,503,0,27,'English'),(691,4,504,0,27,'0'),(692,4,505,0,27,'0x0x0'),(693,4,506,0,27,''),(694,4,507,0,27,'  '),(695,4,509,0,27,''),(696,4,70,0,27,'/P/7/P70765762134607.jpg'),(697,4,71,0,27,'/P/7/P70765762134607.jpg'),(698,4,72,0,27,'/P/7/P70765762134607.jpg'),(699,4,511,0,27,'0'),(700,4,512,0,27,'US'),(701,4,56,0,28,'O Come, All Ye Faithful'),(702,4,67,0,28,''),(703,4,69,0,28,''),(704,4,82,0,28,'O-Come,-All-Ye-Faithful-0765762134706'),(705,4,83,0,28,'O-Come,-All-Ye-Faithful-0765762134706.html'),(706,4,92,0,28,'container2'),(707,4,95,0,28,''),(708,4,96,0,28,''),(709,4,97,0,28,''),(710,4,469,0,28,'2'),(711,4,496,0,28,'Arr by Lawrence, Mike'),(712,4,497,0,28,'0765762134706'),(713,4,499,0,28,'paperback'),(714,4,500,0,28,''),(715,4,503,0,28,'English'),(716,4,504,0,28,'97'),(717,4,505,0,28,'32.766x23.368x1.27'),(718,4,506,0,28,''),(719,4,507,0,28,'  '),(720,4,509,0,28,''),(721,4,70,0,28,'/P/6/P60765762134706.jpg'),(722,4,71,0,28,'/P/6/P60765762134706.jpg'),(723,4,72,0,28,'/P/6/P60765762134706.jpg'),(724,4,511,0,28,'0'),(725,4,512,0,28,'US'),(726,4,56,0,29,'The Heart of Worship with Come, Thou Fount of Every Blessing'),(727,4,67,0,29,''),(728,4,69,0,29,''),(729,4,82,0,29,'The-Heart-of-Worship-with-Come,-Thou-Fount-of-Every-Blessing-0765762134805'),(730,4,83,0,29,'The-Heart-of-Worship-with-Come,-Thou-Fount-of-Every-Blessing-0765762134805.html'),(731,4,92,0,29,'container2'),(732,4,95,0,29,''),(733,4,96,0,29,''),(734,4,97,0,29,''),(735,4,469,0,29,'2'),(736,4,496,0,29,'Cranfill, Jeff'),(737,4,497,0,29,'0765762134805'),(738,4,499,0,29,'paperback'),(739,4,500,0,29,''),(740,4,503,0,29,'English'),(741,4,504,0,29,'0'),(742,4,505,0,29,'31.75x23.622x1.016'),(743,4,506,0,29,''),(744,4,507,0,29,'  '),(745,4,509,0,29,''),(746,4,70,0,29,'/P/5/P50765762134805.jpg'),(747,4,71,0,29,'/P/5/P50765762134805.jpg'),(748,4,72,0,29,'/P/5/P50765762134805.jpg'),(749,4,511,0,29,'0'),(750,4,512,0,29,'US'),(751,4,56,0,30,'I Exalt Thee'),(752,4,67,0,30,''),(753,4,69,0,30,''),(754,4,82,0,30,'I-Exalt-Thee-0765762134904'),(755,4,83,0,30,'I-Exalt-Thee-0765762134904.html'),(756,4,92,0,30,'container2'),(757,4,95,0,30,''),(758,4,96,0,30,''),(759,4,97,0,30,''),(760,4,469,0,30,'2'),(761,4,496,0,30,'Lawrence, Michael (Arranger)'),(762,4,497,0,30,'0765762134904'),(763,4,499,0,30,'paperback'),(764,4,500,0,30,''),(765,4,503,0,30,'English'),(766,4,504,0,30,'0'),(767,4,505,0,30,'0x0x0'),(768,4,506,0,30,''),(769,4,507,0,30,'  '),(770,4,509,0,30,''),(771,4,70,0,30,'/P/4/P40765762134904.jpg'),(772,4,71,0,30,'/P/4/P40765762134904.jpg'),(773,4,72,0,30,'/P/4/P40765762134904.jpg'),(774,4,511,0,30,'0'),(775,4,512,0,30,'US'),(776,4,56,0,31,'My Life Is in You, Lord'),(777,4,67,0,31,''),(778,4,69,0,31,''),(779,4,82,0,31,'My-Life-Is-in-You,-Lord-0765762135000'),(780,4,83,0,31,'My-Life-Is-in-You,-Lord-0765762135000.html'),(781,4,92,0,31,'container2'),(782,4,95,0,31,''),(783,4,96,0,31,''),(784,4,97,0,31,''),(785,4,469,0,31,'2'),(786,4,496,0,31,'Dunn, Steve'),(787,4,497,0,31,'0765762135000'),(788,4,499,0,31,'paperback'),(789,4,500,0,31,''),(790,4,503,0,31,'English'),(791,4,504,0,31,'0'),(792,4,505,0,31,'0x0x0'),(793,4,506,0,31,''),(794,4,507,0,31,'  '),(795,4,509,0,31,''),(796,4,70,0,31,'/I/0/I00765762135000.jpg'),(797,4,71,0,31,'/I/0/I00765762135000.jpg'),(798,4,72,0,31,'/I/0/I00765762135000.jpg'),(799,4,511,0,31,'0'),(800,4,512,0,31,'US'),(801,4,56,0,32,'Shout to the North'),(802,4,67,0,32,''),(803,4,69,0,32,''),(804,4,82,0,32,'Shout-to-the-North-0765762135109'),(805,4,83,0,32,'Shout-to-the-North-0765762135109.html'),(806,4,92,0,32,'container2'),(807,4,95,0,32,''),(808,4,96,0,32,''),(809,4,97,0,32,''),(810,4,469,0,32,'2'),(811,4,496,0,32,'Bourland, Gaylen'),(812,4,497,0,32,'0765762135109'),(813,4,499,0,32,'paperback'),(814,4,500,0,32,''),(815,4,503,0,32,'English'),(816,4,504,0,32,'0'),(817,4,505,0,32,'30.734x21.844x1.27'),(818,4,506,0,32,''),(819,4,507,0,32,'  '),(820,4,509,0,32,''),(821,4,70,0,32,'/A/9/A90765762135109.jpg'),(822,4,71,0,32,'/A/9/A90765762135109.jpg'),(823,4,72,0,32,'/A/9/A90765762135109.jpg'),(824,4,511,0,32,'0'),(825,4,512,0,32,'US'),(826,4,56,0,33,'O Holy Night'),(827,4,67,0,33,''),(828,4,69,0,33,''),(829,4,82,0,33,'O-Holy-Night-0765762135208'),(830,4,83,0,33,'O-Holy-Night-0765762135208.html'),(831,4,92,0,33,'container2'),(832,4,95,0,33,''),(833,4,96,0,33,''),(834,4,97,0,33,''),(835,4,469,0,33,'2'),(836,4,496,0,33,'Arr Lawrence, Michael'),(837,4,497,0,33,'0765762135208'),(838,4,499,0,33,'paperback'),(839,4,500,0,33,''),(840,4,503,0,33,'English'),(841,4,504,0,33,'0'),(842,4,505,0,33,'0x0x0'),(843,4,506,0,33,''),(844,4,507,0,33,'  '),(845,4,509,0,33,''),(846,4,70,0,33,'/A/8/A80765762135208.jpg'),(847,4,71,0,33,'/A/8/A80765762135208.jpg'),(848,4,72,0,33,'/A/8/A80765762135208.jpg'),(849,4,511,0,33,'0'),(850,4,512,0,33,'US'),(851,4,56,0,34,'Come, Now Is the Time to Worship'),(852,4,67,0,34,''),(853,4,69,0,34,''),(854,4,82,0,34,'Come,-Now-Is-the-Time-to-Worship-0765762135307'),(855,4,83,0,34,'Come,-Now-Is-the-Time-to-Worship-0765762135307.html'),(856,4,92,0,34,'container2'),(857,4,95,0,34,''),(858,4,96,0,34,''),(859,4,97,0,34,''),(860,4,469,0,34,'2'),(861,4,496,0,34,'Lawrence, Mike'),(862,4,497,0,34,'0765762135307'),(863,4,499,0,34,'paperback'),(864,4,500,0,34,''),(865,4,503,0,34,'English'),(866,4,504,0,34,'82'),(867,4,505,0,34,'0x0x0'),(868,4,506,0,34,''),(869,4,507,0,34,'  '),(870,4,509,0,34,''),(871,4,70,0,34,'/A/7/A70765762135307.jpg'),(872,4,71,0,34,'/A/7/A70765762135307.jpg'),(873,4,72,0,34,'/A/7/A70765762135307.jpg'),(874,4,511,0,34,'0'),(875,4,512,0,34,'US'),(876,4,56,0,35,'O the Deep, Deep Love of Jesus'),(877,4,67,0,35,''),(878,4,69,0,35,''),(879,4,82,0,35,'O-the-Deep,-Deep-Love-of-Jesus-0765762135406'),(880,4,83,0,35,'O-the-Deep,-Deep-Love-of-Jesus-0765762135406.html'),(881,4,92,0,35,'container2'),(882,4,95,0,35,''),(883,4,96,0,35,''),(884,4,97,0,35,''),(885,4,469,0,35,'2'),(886,4,496,0,35,'Cranfill, Jeff'),(887,4,497,0,35,'0765762135406'),(888,4,499,0,35,'paperback'),(889,4,500,0,35,''),(890,4,503,0,35,'English'),(891,4,504,0,35,'63'),(892,4,505,0,35,'31.496x22.86x1.016'),(893,4,506,0,35,''),(894,4,507,0,35,'  '),(895,4,509,0,35,''),(896,4,70,0,35,'/A/6/A60765762135406.jpg'),(897,4,71,0,35,'/A/6/A60765762135406.jpg'),(898,4,72,0,35,'/A/6/A60765762135406.jpg'),(899,4,511,0,35,'0'),(900,4,512,0,35,'US'),(901,4,56,0,36,'Great Is Thy Faithfulness'),(902,4,67,0,36,''),(903,4,69,0,36,''),(904,4,82,0,36,'Great-Is-Thy-Faithfulness-0765762135505'),(905,4,83,0,36,'Great-Is-Thy-Faithfulness-0765762135505.html'),(906,4,92,0,36,'container2'),(907,4,95,0,36,''),(908,4,96,0,36,''),(909,4,97,0,36,''),(910,4,469,0,36,'2'),(911,4,496,0,36,'Marsh, Don'),(912,4,497,0,36,'0765762135505'),(913,4,499,0,36,'paperback'),(914,4,500,0,36,''),(915,4,503,0,36,'English'),(916,4,504,0,36,'0'),(917,4,505,0,36,'31.242x22.352x1.016'),(918,4,506,0,36,''),(919,4,507,0,36,'  '),(920,4,509,0,36,''),(921,4,70,0,36,'/A/5/A50765762135505.jpg'),(922,4,71,0,36,'/A/5/A50765762135505.jpg'),(923,4,72,0,36,'/A/5/A50765762135505.jpg'),(924,4,511,0,36,'0'),(925,4,512,0,36,'US'),(926,4,56,0,37,'A Christmas Portrait'),(927,4,67,0,37,''),(928,4,69,0,37,''),(929,4,82,0,37,'A-Christmas-Portrait-0765762135703'),(930,4,83,0,37,'A-Christmas-Portrait-0765762135703.html'),(931,4,92,0,37,'container2'),(932,4,95,0,37,''),(933,4,96,0,37,''),(934,4,97,0,37,''),(935,4,469,0,37,'2'),(936,4,496,0,37,'Hayes, Mark'),(937,4,497,0,37,'0765762135703'),(938,4,499,0,37,'paperback'),(939,4,500,0,37,''),(940,4,503,0,37,'English'),(941,4,504,0,37,'0'),(942,4,505,0,37,'0x0x0'),(943,4,506,0,37,''),(944,4,507,0,37,'  '),(945,4,509,0,37,''),(946,4,70,0,37,'/A/3/A30765762135703.jpg'),(947,4,71,0,37,'/A/3/A30765762135703.jpg'),(948,4,72,0,37,'/A/3/A30765762135703.jpg'),(949,4,511,0,37,'0'),(950,4,512,0,37,'US'),(951,4,56,0,38,'Praise to the Lord, the Almighty'),(952,4,67,0,38,''),(953,4,69,0,38,''),(954,4,82,0,38,'Praise-to-the-Lord,-the-Almighty-0765762136007'),(955,4,83,0,38,'Praise-to-the-Lord,-the-Almighty-0765762136007.html'),(956,4,92,0,38,'container2'),(957,4,95,0,38,''),(958,4,96,0,38,''),(959,4,97,0,38,''),(960,4,469,0,38,'2'),(961,4,496,0,38,'Marsh, Don'),(962,4,497,0,38,'0765762136007'),(963,4,499,0,38,'paperback'),(964,4,500,0,38,''),(965,4,503,0,38,'English'),(966,4,504,0,38,'0'),(967,4,505,0,38,'0x0x0'),(968,4,506,0,38,''),(969,4,507,0,38,'  '),(970,4,509,0,38,''),(971,4,70,0,38,'/L/7/L70765762136007.jpg'),(972,4,71,0,38,'/L/7/L70765762136007.jpg'),(973,4,72,0,38,'/L/7/L70765762136007.jpg'),(974,4,511,0,38,'0'),(975,4,512,0,38,'US'),(976,4,56,0,39,'Prelude in Classic Style'),(977,4,67,0,39,''),(978,4,69,0,39,''),(979,4,82,0,39,'Prelude-in-Classic-Style-0765762136403'),(980,4,83,0,39,'Prelude-in-Classic-Style-0765762136403.html'),(981,4,92,0,39,'container2'),(982,4,95,0,39,''),(983,4,96,0,39,''),(984,4,97,0,39,''),(985,4,469,0,39,'2'),(986,4,496,0,39,'Christopher, Keith'),(987,4,497,0,39,'0765762136403'),(988,4,499,0,39,'paperback'),(989,4,500,0,39,''),(990,4,503,0,39,'English'),(991,4,504,0,39,'0'),(992,4,505,0,39,'0x0x0'),(993,4,506,0,39,''),(994,4,507,0,39,'  '),(995,4,509,0,39,''),(996,4,70,0,39,'/L/3/L30765762136403.jpg'),(997,4,71,0,39,'/L/3/L30765762136403.jpg'),(998,4,72,0,39,'/L/3/L30765762136403.jpg'),(999,4,511,0,39,'0'),(1000,4,512,0,39,'US'),(1001,4,56,0,40,'Go, Tell It on the Mountain'),(1002,4,67,0,40,''),(1003,4,69,0,40,''),(1004,4,82,0,40,'Go,-Tell-It-on-the-Mountain-0765762136502'),(1005,4,83,0,40,'Go,-Tell-It-on-the-Mountain-0765762136502.html'),(1006,4,92,0,40,'container2'),(1007,4,95,0,40,''),(1008,4,96,0,40,''),(1009,4,97,0,40,''),(1010,4,469,0,40,'2'),(1011,4,496,0,40,'Arr by Goeller, Dan'),(1012,4,497,0,40,'0765762136502'),(1013,4,499,0,40,'paperback'),(1014,4,500,0,40,''),(1015,4,503,0,40,'English'),(1016,4,504,0,40,'0'),(1017,4,505,0,40,'0x0x0'),(1018,4,506,0,40,''),(1019,4,507,0,40,'  '),(1020,4,509,0,40,''),(1021,4,70,0,40,'/L/2/L20765762136502.jpg'),(1022,4,71,0,40,'/L/2/L20765762136502.jpg'),(1023,4,72,0,40,'/L/2/L20765762136502.jpg'),(1024,4,511,0,40,'0'),(1025,4,512,0,40,'US'),(1026,4,56,0,41,'How Deep the Father\'s Love for Us'),(1027,4,67,0,41,''),(1028,4,69,0,41,''),(1029,4,82,0,41,'How-Deep-the-Fathers-Love-for-Us-0765762136809'),(1030,4,83,0,41,'How-Deep-the-Fathers-Love-for-Us-0765762136809.html'),(1031,4,92,0,41,'container2'),(1032,4,95,0,41,''),(1033,4,96,0,41,''),(1034,4,97,0,41,''),(1035,4,469,0,41,'2'),(1036,4,496,0,41,'Kingsmore, Richard'),(1037,4,497,0,41,'0765762136809'),(1038,4,499,0,41,'paperback'),(1039,4,500,0,41,''),(1040,4,503,0,41,'English'),(1041,4,504,0,41,'90'),(1042,4,505,0,41,'0x0x0'),(1043,4,506,0,41,''),(1044,4,507,0,41,'  '),(1045,4,509,0,41,''),(1046,4,70,0,41,'/D/9/D90765762136809.jpg'),(1047,4,71,0,41,'/D/9/D90765762136809.jpg'),(1048,4,72,0,41,'/D/9/D90765762136809.jpg'),(1049,4,511,0,41,'0'),(1050,4,512,0,41,'US'),(1051,4,56,0,42,'I Bowed on My Knees and Cried \'Holy\''),(1052,4,67,0,42,''),(1053,4,69,0,42,''),(1054,4,82,0,42,'I-Bowed-on-My-Knees-and-Cried-Holy-0765762137004'),(1055,4,83,0,42,'I-Bowed-on-My-Knees-and-Cried-Holy-0765762137004.html'),(1056,4,92,0,42,'container2'),(1057,4,95,0,42,''),(1058,4,96,0,42,''),(1059,4,97,0,42,''),(1060,4,469,0,42,'2'),(1061,4,496,0,42,'Arr Gray, Jim'),(1062,4,497,0,42,'0765762137004'),(1063,4,499,0,42,'paperback'),(1064,4,500,0,42,''),(1065,4,503,0,42,'English'),(1066,4,504,0,42,'0'),(1067,4,505,0,42,'0x0x0'),(1068,4,506,0,42,''),(1069,4,507,0,42,'  '),(1070,4,509,0,42,''),(1071,4,70,0,42,'/W/4/W40765762137004.jpg'),(1072,4,71,0,42,'/W/4/W40765762137004.jpg'),(1073,4,72,0,42,'/W/4/W40765762137004.jpg'),(1074,4,511,0,42,'0'),(1075,4,512,0,42,'US'),(1076,4,56,0,43,'I\'ve Been Changed'),(1077,4,67,0,43,''),(1078,4,69,0,43,''),(1079,4,82,0,43,'Ive-Been-Changed-0765762137103'),(1080,4,83,0,43,'Ive-Been-Changed-0765762137103.html'),(1081,4,92,0,43,'container2'),(1082,4,95,0,43,''),(1083,4,96,0,43,''),(1084,4,97,0,43,''),(1085,4,469,0,43,'2'),(1086,4,496,0,43,'Winkler, David'),(1087,4,497,0,43,'0765762137103'),(1088,4,499,0,43,'paperback'),(1089,4,500,0,43,''),(1090,4,503,0,43,'English'),(1091,4,504,0,43,'0'),(1092,4,505,0,43,'0x0x0'),(1093,4,506,0,43,''),(1094,4,507,0,43,'  '),(1095,4,509,0,43,''),(1096,4,70,0,43,'/W/3/W30765762137103.jpg'),(1097,4,71,0,43,'/W/3/W30765762137103.jpg'),(1098,4,72,0,43,'/W/3/W30765762137103.jpg'),(1099,4,511,0,43,'0'),(1100,4,512,0,43,'US'),(1101,4,56,0,44,'Jesus Is the Answer'),(1102,4,67,0,44,''),(1103,4,69,0,44,''),(1104,4,82,0,44,'Jesus-Is-the-Answer-0765762137202'),(1105,4,83,0,44,'Jesus-Is-the-Answer-0765762137202.html'),(1106,4,92,0,44,'container2'),(1107,4,95,0,44,''),(1108,4,96,0,44,''),(1109,4,97,0,44,''),(1110,4,469,0,44,'2'),(1111,4,496,0,44,'Winch, Terry'),(1112,4,497,0,44,'0765762137202'),(1113,4,499,0,44,'paperback'),(1114,4,500,0,44,''),(1115,4,503,0,44,'English'),(1116,4,504,0,44,'0'),(1117,4,505,0,44,'0x0x0'),(1118,4,506,0,44,''),(1119,4,507,0,44,'  '),(1120,4,509,0,44,''),(1121,4,70,0,44,'/W/2/W20765762137202.jpg'),(1122,4,71,0,44,'/W/2/W20765762137202.jpg'),(1123,4,72,0,44,'/W/2/W20765762137202.jpg'),(1124,4,511,0,44,'0'),(1125,4,512,0,44,'US'),(1126,4,56,0,45,'Since Jesus Came Into My Heart'),(1127,4,67,0,45,''),(1128,4,69,0,45,''),(1129,4,82,0,45,'Since-Jesus-Came-Into-My-Heart-0765762137301'),(1130,4,83,0,45,'Since-Jesus-Came-Into-My-Heart-0765762137301.html'),(1131,4,92,0,45,'container2'),(1132,4,95,0,45,''),(1133,4,96,0,45,''),(1134,4,97,0,45,''),(1135,4,469,0,45,'2'),(1136,4,496,0,45,'Kingsmore, Richard'),(1137,4,497,0,45,'0765762137301'),(1138,4,499,0,45,'paperback'),(1139,4,500,0,45,''),(1140,4,503,0,45,'English'),(1141,4,504,0,45,'0'),(1142,4,505,0,45,'0x0x0'),(1143,4,506,0,45,''),(1144,4,507,0,45,'  '),(1145,4,509,0,45,''),(1146,4,70,0,45,'/W/1/W10765762137301.jpg'),(1147,4,71,0,45,'/W/1/W10765762137301.jpg'),(1148,4,72,0,45,'/W/1/W10765762137301.jpg'),(1149,4,511,0,45,'0'),(1150,4,512,0,45,'US'),(1151,4,56,0,46,'Blessed Be Your Name'),(1152,4,67,0,46,''),(1153,4,69,0,46,''),(1154,4,82,0,46,'Blessed-Be-Your-Name-0765762139800'),(1155,4,83,0,46,'Blessed-Be-Your-Name-0765762139800.html'),(1156,4,92,0,46,'container2'),(1157,4,95,0,46,''),(1158,4,96,0,46,''),(1159,4,97,0,46,''),(1160,4,469,0,46,'2'),(1161,4,496,0,46,'Dunn, Steve'),(1162,4,497,0,46,'0765762139800'),(1163,4,499,0,46,'paperback'),(1164,4,500,0,46,''),(1165,4,503,0,46,'English'),(1166,4,504,0,46,'0'),(1167,4,505,0,46,'30.734x23.114x2.286'),(1168,4,506,0,46,''),(1169,4,507,0,46,'  '),(1170,4,509,0,46,''),(1171,4,70,0,46,'/K/0/K00765762139800.jpg'),(1172,4,71,0,46,'/K/0/K00765762139800.jpg'),(1173,4,72,0,46,'/K/0/K00765762139800.jpg'),(1174,4,511,0,46,'0'),(1175,4,512,0,46,'US'),(1176,4,56,0,47,'God Rest Ye Merry, Gentlemen'),(1177,4,67,0,47,''),(1178,4,69,0,47,''),(1179,4,82,0,47,'God-Rest-Ye-Merry,-Gentlemen-0765762140103'),(1180,4,83,0,47,'God-Rest-Ye-Merry,-Gentlemen-0765762140103.html'),(1181,4,92,0,47,'container2'),(1182,4,95,0,47,''),(1183,4,96,0,47,''),(1184,4,97,0,47,''),(1185,4,469,0,47,'2'),(1186,4,496,0,47,'Lawrence, Mike'),(1187,4,497,0,47,'0765762140103'),(1188,4,499,0,47,'paperback'),(1189,4,500,0,47,''),(1190,4,503,0,47,'English'),(1191,4,504,0,47,'0'),(1192,4,505,0,47,'0x0x0'),(1193,4,506,0,47,''),(1194,4,507,0,47,'  '),(1195,4,509,0,47,''),(1196,4,70,0,47,'/Z/3/Z30765762140103.jpg'),(1197,4,71,0,47,'/Z/3/Z30765762140103.jpg'),(1198,4,72,0,47,'/Z/3/Z30765762140103.jpg'),(1199,4,511,0,47,'0'),(1200,4,512,0,47,'US'),(1201,4,56,0,48,'May Jesus Christ Be Praised'),(1202,4,67,0,48,''),(1203,4,69,0,48,''),(1204,4,82,0,48,'May-Jesus-Christ-Be-Praised-0765762140400'),(1205,4,83,0,48,'May-Jesus-Christ-Be-Praised-0765762140400.html'),(1206,4,92,0,48,'container2'),(1207,4,95,0,48,''),(1208,4,96,0,48,''),(1209,4,97,0,48,''),(1210,4,469,0,48,'2'),(1211,4,496,0,48,'Allen, Omar'),(1212,4,497,0,48,'0765762140400'),(1213,4,499,0,48,'paperback'),(1214,4,500,0,48,''),(1215,4,503,0,48,'English'),(1216,4,504,0,48,'0'),(1217,4,505,0,48,'0x0x0'),(1218,4,506,0,48,''),(1219,4,507,0,48,'  '),(1220,4,509,0,48,''),(1221,4,70,0,48,'/Z/0/Z00765762140400.jpg'),(1222,4,71,0,48,'/Z/0/Z00765762140400.jpg'),(1223,4,72,0,48,'/Z/0/Z00765762140400.jpg'),(1224,4,511,0,48,'0'),(1225,4,512,0,48,'US'),(1226,4,56,0,49,'Worthy! the Song of the Ages: An Easter Celebration for Any Choir'),(1227,4,67,0,49,''),(1228,4,69,0,49,''),(1229,4,82,0,49,'Worthy!-the-Song-of-the-Ages:-An-Easter-Celebration-for-Any-Choir-0765762155008'),(1230,4,83,0,49,'Worthy!-the-Song-of-the-Ages:-An-Easter-Celebration-for-Any-Choir-0765762155008.html'),(1231,4,92,0,49,'container2'),(1232,4,95,0,49,''),(1233,4,96,0,49,''),(1234,4,97,0,49,''),(1235,4,469,0,49,'2'),(1236,4,496,0,49,'Parks, Marty'),(1237,4,497,0,49,'0765762155008'),(1238,4,499,0,49,'hardcover'),(1239,4,500,0,49,''),(1240,4,503,0,49,'English'),(1241,4,504,0,49,'0'),(1242,4,505,0,49,'27.686x21.336x1.778'),(1243,4,506,0,49,''),(1244,4,507,0,49,'  '),(1245,4,509,0,49,''),(1246,4,70,0,49,'/Y/8/Y80765762155008.jpg'),(1247,4,71,0,49,'/Y/8/Y80765762155008.jpg'),(1248,4,72,0,49,'/Y/8/Y80765762155008.jpg'),(1249,4,511,0,49,'0'),(1250,4,512,0,49,'US'),(1251,4,56,0,50,'African Bass Bible, Volume 1'),(1252,4,67,0,50,''),(1253,4,69,0,50,''),(1254,4,82,0,50,'African-Bass-Bible,-Volume-1-0796279109260'),(1255,4,83,0,50,'African-Bass-Bible,-Volume-1-0796279109260.html'),(1256,4,92,0,50,'container2'),(1257,4,95,0,50,''),(1258,4,96,0,50,''),(1259,4,97,0,50,''),(1260,4,469,0,50,'2'),(1261,4,496,0,50,'Douglas, Kibisi & Kibisi, Douglas'),(1262,4,497,0,50,'0796279109260'),(1263,4,499,0,50,'hardcover'),(1264,4,500,0,50,''),(1265,4,503,0,50,'English'),(1266,4,504,0,50,'0'),(1267,4,505,0,50,'18.796x13.716x1.524'),(1268,4,506,0,50,''),(1269,4,507,0,50,'  '),(1270,4,509,0,50,''),(1271,4,70,0,50,'/S/0/S00796279109260.jpg'),(1272,4,71,0,50,'/S/0/S00796279109260.jpg'),(1273,4,72,0,50,'/S/0/S00796279109260.jpg'),(1274,4,511,0,50,'0'),(1275,4,512,0,50,'US'),(1276,4,56,0,51,'What Is a Gas?'),(1277,4,67,0,51,''),(1278,4,69,0,51,''),(1279,4,82,0,51,'What-Is-a-Gas?-0978082568186'),(1280,4,83,0,51,'What-Is-a-Gas?-0978082568186.html'),(1281,4,92,0,51,'container2'),(1282,4,95,0,51,''),(1283,4,96,0,51,''),(1284,4,97,0,51,''),(1285,4,469,0,51,'2'),(1286,4,496,0,51,'Boothroyd, Jennifer'),(1287,4,497,0,51,'0978082568186'),(1288,4,499,0,51,'paperback'),(1289,4,500,0,51,''),(1290,4,503,0,51,'English'),(1291,4,504,0,51,'24'),(1292,4,505,0,51,'0x0x0'),(1293,4,506,0,51,''),(1294,4,507,0,51,'  '),(1295,4,509,0,51,''),(1296,4,70,0,51,'/W/6/W60978082568186.jpg'),(1297,4,71,0,51,'/W/6/W60978082568186.jpg'),(1298,4,72,0,51,'/W/6/W60978082568186.jpg'),(1299,4,511,0,51,'0'),(1300,4,512,0,51,'US'),(1301,4,56,0,52,'Denver Broncos'),(1302,4,67,0,52,''),(1303,4,69,0,52,''),(1304,4,82,0,52,'Denver-Broncos-0978089125351'),(1305,4,83,0,52,'Denver-Broncos-0978089125351.html'),(1306,4,92,0,52,'container2'),(1307,4,95,0,52,''),(1308,4,96,0,52,''),(1309,4,97,0,52,''),(1310,4,469,0,52,'2'),(1311,4,496,0,52,'Omoth, Tyler'),(1312,4,497,0,52,'0978089125351'),(1313,4,499,0,52,'paperback'),(1314,4,500,0,52,''),(1315,4,503,0,52,'English'),(1316,4,504,0,52,'48'),(1317,4,505,0,52,'0x0x0'),(1318,4,506,0,52,''),(1319,4,507,0,52,'  '),(1320,4,509,0,52,''),(1321,4,70,0,52,'/E/1/E10978089125351.jpg'),(1322,4,71,0,52,'/E/1/E10978089125351.jpg'),(1323,4,72,0,52,'/E/1/E10978089125351.jpg'),(1324,4,511,0,52,'0'),(1325,4,512,0,52,'US'),(1326,4,56,0,53,'Afloat and Ashore'),(1327,4,67,0,53,''),(1328,4,69,0,53,''),(1329,4,82,0,53,'Afloat-and-Ashore-0978144380572'),(1330,4,83,0,53,'Afloat-and-Ashore-0978144380572.html'),(1331,4,92,0,53,'container2'),(1332,4,95,0,53,''),(1333,4,96,0,53,''),(1334,4,97,0,53,''),(1335,4,469,0,53,'2'),(1336,4,496,0,53,'Cooper, James Fenimore'),(1337,4,497,0,53,'0978144380572'),(1338,4,499,0,53,'paperback'),(1339,4,500,0,53,''),(1340,4,503,0,53,'English'),(1341,4,504,0,53,'0'),(1342,4,505,0,53,'0x0x0'),(1343,4,506,0,53,''),(1344,4,507,0,53,'  '),(1345,4,509,0,53,''),(1346,4,70,0,53,'/L/2/L20978144380572.jpg'),(1347,4,71,0,53,'/L/2/L20978144380572.jpg'),(1348,4,72,0,53,'/L/2/L20978144380572.jpg'),(1349,4,511,0,53,'0'),(1350,4,512,0,53,'US'),(1351,4,56,0,54,'Pride and Prejudice'),(1352,4,67,0,54,''),(1353,4,69,0,54,''),(1354,4,82,0,54,'Pride-and-Prejudice-1116090014687'),(1355,4,83,0,54,'Pride-and-Prejudice-1116090014687.html'),(1356,4,92,0,54,'container2'),(1357,4,95,0,54,''),(1358,4,96,0,54,''),(1359,4,97,0,54,''),(1360,4,469,0,54,'2'),(1361,4,496,0,54,'Austen, Jane'),(1362,4,497,0,54,'1116090014687'),(1363,4,499,0,54,'paperback'),(1364,4,500,0,54,''),(1365,4,503,0,54,'English'),(1366,4,504,0,54,'455'),(1367,4,505,0,54,'0x0x0'),(1368,4,506,0,54,''),(1369,4,507,0,54,'  '),(1370,4,509,0,54,''),(1371,4,70,0,54,'/A/7/A71116090014687.jpg'),(1372,4,71,0,54,'/A/7/A71116090014687.jpg'),(1373,4,72,0,54,'/A/7/A71116090014687.jpg'),(1374,4,511,0,54,'0'),(1375,4,512,0,54,'US'),(1376,4,56,0,55,'[Little Doggie Cun and Friends: A Pretty Bow]'),(1377,4,67,0,55,''),(1378,4,69,0,55,''),(1379,4,82,0,55,'[Little-Doggie-Cun-and-Friends:-A-Pretty-Bow]-1200600710005'),(1380,4,83,0,55,'[Little-Doggie-Cun-and-Friends:-A-Pretty-Bow]-1200600710005.html'),(1381,4,92,0,55,'container2'),(1382,4,95,0,55,''),(1383,4,96,0,55,''),(1384,4,97,0,55,''),(1385,4,469,0,55,'2'),(1386,4,496,0,55,'Phuong, Hoa'),(1387,4,497,0,55,'1200600710005'),(1388,4,499,0,55,''),(1389,4,500,0,55,''),(1390,4,503,0,55,'English'),(1391,4,504,0,55,'10'),(1392,4,505,0,55,'0x0x0'),(1393,4,506,0,55,''),(1394,4,507,0,55,'  '),(1395,4,509,0,55,''),(1396,4,70,0,55,'/Z/5/Z51200600710005.jpg'),(1397,4,71,0,55,'/Z/5/Z51200600710005.jpg'),(1398,4,72,0,55,'/Z/5/Z51200600710005.jpg'),(1399,4,511,0,55,'0'),(1400,4,512,0,55,'US'),(1401,4,56,0,56,'Peyton Place'),(1402,4,67,0,56,''),(1403,4,69,0,56,''),(1404,4,82,0,56,'Peyton-Place-2010000001189'),(1405,4,83,0,56,'Peyton-Place-2010000001189.html'),(1406,4,92,0,56,'container2'),(1407,4,95,0,56,''),(1408,4,96,0,56,''),(1409,4,97,0,56,''),(1410,4,469,0,56,'2'),(1411,4,496,0,56,'Metalious, Grace'),(1412,4,497,0,56,'2010000001189'),(1413,4,499,0,56,'paperback'),(1414,4,500,0,56,''),(1415,4,503,0,56,'English'),(1416,4,504,0,56,'631'),(1417,4,505,0,56,'0x0x0'),(1418,4,506,0,56,''),(1419,4,507,0,56,'  '),(1420,4,509,0,56,''),(1421,4,70,0,56,'/J/9/J92010000001189.jpg'),(1422,4,71,0,56,'/J/9/J92010000001189.jpg'),(1423,4,72,0,56,'/J/9/J92010000001189.jpg'),(1424,4,511,0,56,'0'),(1425,4,512,0,56,'US'),(1426,4,56,0,57,'88 DAO Tai WAN Ren Zui AI Xia Fan Xiao Cai'),(1427,4,67,0,57,''),(1428,4,69,0,57,''),(1429,4,82,0,57,'88-DAO-Tai-WAN-Ren-Zui-AI-Xia-Fan-Xiao-Cai-4711213292675'),(1430,4,83,0,57,'88-DAO-Tai-WAN-Ren-Zui-AI-Xia-Fan-Xiao-Cai-4711213292675.html'),(1431,4,92,0,57,'container2'),(1432,4,95,0,57,''),(1433,4,96,0,57,''),(1434,4,97,0,57,''),(1435,4,469,0,57,'2'),(1436,4,496,0,57,'Jiang, Lizhu'),(1437,4,497,0,57,'4711213292675'),(1438,4,499,0,57,'paperback'),(1439,4,500,0,57,''),(1440,4,503,0,57,'English'),(1441,4,504,0,57,'0'),(1442,4,505,0,57,'0x0x0'),(1443,4,506,0,57,''),(1444,4,507,0,57,'  '),(1445,4,509,0,57,''),(1446,4,70,0,57,'/E/5/E54711213292675.jpg'),(1447,4,71,0,57,'/E/5/E54711213292675.jpg'),(1448,4,72,0,57,'/E/5/E54711213292675.jpg'),(1449,4,511,0,57,'0'),(1450,4,512,0,57,'US'),(1451,4,56,0,58,'Where\'s Spot, Spot Goes to the Farm, and Spot\'s First Walk'),(1452,4,67,0,58,''),(1453,4,69,0,58,''),(1454,4,82,0,58,'Wheres-Spot,-Spot-Goes-to-the-Farm,-and-Spots-First-Walk-4713482004256'),(1455,4,83,0,58,'Wheres-Spot,-Spot-Goes-to-the-Farm,-and-Spots-First-Walk-4713482004256.html'),(1456,4,92,0,58,'container2'),(1457,4,95,0,58,''),(1458,4,96,0,58,''),(1459,4,97,0,58,''),(1460,4,469,0,58,'2'),(1461,4,496,0,58,'Hill, Eric'),(1462,4,497,0,58,'4713482004256'),(1463,4,499,0,58,'hardcover'),(1464,4,500,0,58,''),(1465,4,503,0,58,'English'),(1466,4,504,0,58,'22'),(1467,4,505,0,58,'0x0x0'),(1468,4,506,0,58,''),(1469,4,507,0,58,'  '),(1470,4,509,0,58,''),(1471,4,70,0,58,'/Z/6/Z64713482004256.jpg'),(1472,4,71,0,58,'/Z/6/Z64713482004256.jpg'),(1473,4,72,0,58,'/Z/6/Z64713482004256.jpg'),(1474,4,511,0,58,'0'),(1475,4,512,0,58,'US'),(1476,4,56,0,59,'Henry Lee\'s Crime Scene Handbook'),(1477,4,67,0,59,''),(1478,4,69,0,59,''),(1479,4,82,0,59,'Henry-Lees-Crime-Scene-Handbook-4717702066765'),(1480,4,83,0,59,'Henry-Lees-Crime-Scene-Handbook-4717702066765.html'),(1481,4,92,0,59,'container2'),(1482,4,95,0,59,''),(1483,4,96,0,59,''),(1484,4,97,0,59,''),(1485,4,469,0,59,'2'),(1486,4,496,0,59,'Li, Changyu'),(1487,4,497,0,59,'4717702066765'),(1488,4,499,0,59,'paperback'),(1489,4,500,0,59,''),(1490,4,503,0,59,'English'),(1491,4,504,0,59,'416'),(1492,4,505,0,59,'0x0x0'),(1493,4,506,0,59,''),(1494,4,507,0,59,'  '),(1495,4,509,0,59,''),(1496,4,70,0,59,'/C/5/C54717702066765.jpg'),(1497,4,71,0,59,'/C/5/C54717702066765.jpg'),(1498,4,72,0,59,'/C/5/C54717702066765.jpg'),(1499,4,511,0,59,'0'),(1500,4,512,0,59,'US'),(1501,4,56,0,60,'Michael Jackson: Life of a Legend 1958-2009'),(1502,4,67,0,60,''),(1503,4,69,0,60,''),(1504,4,82,0,60,'Michael-Jackson:-Life-of-a-Legend-1958-2009-4717702228606'),(1505,4,83,0,60,'Michael-Jackson:-Life-of-a-Legend-1958-2009-4717702228606.html'),(1506,4,92,0,60,'container2'),(1507,4,95,0,60,''),(1508,4,96,0,60,''),(1509,4,97,0,60,''),(1510,4,469,0,60,'2'),(1511,4,496,0,60,'Heatley, Michael'),(1512,4,497,0,60,'4717702228606'),(1513,4,499,0,60,'paperback'),(1514,4,500,0,60,''),(1515,4,503,0,60,'English'),(1516,4,504,0,60,'192'),(1517,4,505,0,60,'0x0x0'),(1518,4,506,0,60,''),(1519,4,507,0,60,'  '),(1520,4,509,0,60,''),(1521,4,70,0,60,'/C/6/C64717702228606.jpg'),(1522,4,71,0,60,'/C/6/C64717702228606.jpg'),(1523,4,72,0,60,'/C/6/C64717702228606.jpg'),(1524,4,511,0,60,'0'),(1525,4,512,0,60,'US'),(1526,4,56,0,61,'123 for You and Me!'),(1527,4,67,0,61,''),(1528,4,69,0,61,''),(1529,4,82,0,61,'123-for-You-and-Me!-6006937084346'),(1530,4,83,0,61,'123-for-You-and-Me!-6006937084346.html'),(1531,4,92,0,61,'container2'),(1532,4,95,0,61,''),(1533,4,96,0,61,''),(1534,4,97,0,61,''),(1535,4,469,0,61,'2'),(1536,4,496,0,61,'Larsen, Carolyn'),(1537,4,497,0,61,'6006937084346'),(1538,4,499,0,61,'paperback'),(1539,4,500,0,61,''),(1540,4,503,0,61,'English'),(1541,4,504,0,61,'0'),(1542,4,505,0,61,'16.637x11.8872x3.429'),(1543,4,506,0,61,''),(1544,4,507,0,61,'  '),(1545,4,509,0,61,''),(1546,4,70,0,61,'/N/6/N66006937084346.jpg'),(1547,4,71,0,61,'/N/6/N66006937084346.jpg'),(1548,4,72,0,61,'/N/6/N66006937084346.jpg'),(1549,4,511,0,61,'0'),(1550,4,512,0,61,'US'),(1551,4,56,0,62,'Daniel in the Lions\' Den'),(1552,4,67,0,62,''),(1553,4,69,0,62,''),(1554,4,82,0,62,'Daniel-in-the-Lions-Den-6006937084377'),(1555,4,83,0,62,'Daniel-in-the-Lions-Den-6006937084377.html'),(1556,4,92,0,62,'container2'),(1557,4,95,0,62,''),(1558,4,96,0,62,''),(1559,4,97,0,62,''),(1560,4,469,0,62,'2'),(1561,4,496,0,62,'Christian Art Gifts'),(1562,4,497,0,62,'6006937084377'),(1563,4,499,0,62,'paperback'),(1564,4,500,0,62,''),(1565,4,503,0,62,'English'),(1566,4,504,0,62,'0'),(1567,4,505,0,62,'0x0x0'),(1568,4,506,0,62,''),(1569,4,507,0,62,'  '),(1570,4,509,0,62,''),(1571,4,70,0,62,'/S/7/S76006937084377.jpg'),(1572,4,71,0,62,'/S/7/S76006937084377.jpg'),(1573,4,72,0,62,'/S/7/S76006937084377.jpg'),(1574,4,511,0,62,'0'),(1575,4,512,0,62,'US'),(1576,4,56,0,63,'Postsozialistischer Wandel Landlicher Siedlungen in Mecklenburg'),(1577,4,67,0,63,''),(1578,4,69,0,63,''),(1579,4,82,0,63,'Postsozialistischer-Wandel-Landlicher-Siedlungen-in-Mecklenburg-7835150933921'),(1580,4,83,0,63,'Postsozialistischer-Wandel-Landlicher-Siedlungen-in-Mecklenburg-7835150933921.html'),(1581,4,92,0,63,'container2'),(1582,4,95,0,63,''),(1583,4,96,0,63,''),(1584,4,97,0,63,''),(1585,4,469,0,63,'2'),(1586,4,496,0,63,'Rogge, Christian'),(1587,4,497,0,63,'7835150933921'),(1588,4,499,0,63,'paperback'),(1589,4,500,0,63,''),(1590,4,503,0,63,'English'),(1591,4,504,0,63,'311'),(1592,4,505,0,63,'0x0x0'),(1593,4,506,0,63,''),(1594,4,507,0,63,'  '),(1595,4,509,0,63,''),(1596,4,70,0,63,'/I/1/I17835150933921.jpg'),(1597,4,71,0,63,'/I/1/I17835150933921.jpg'),(1598,4,72,0,63,'/I/1/I17835150933921.jpg'),(1599,4,511,0,63,'0'),(1600,4,512,0,63,'US'),(1601,4,56,0,64,'Wings of War: Fire from the Sky'),(1602,4,67,0,64,''),(1603,4,69,0,64,''),(1604,4,82,0,64,'Wings-of-War:-Fire-from-the-Sky-8033772895149'),(1605,4,83,0,64,'Wings-of-War:-Fire-from-the-Sky-8033772895149.html'),(1606,4,92,0,64,'container2'),(1607,4,95,0,64,''),(1608,4,96,0,64,''),(1609,4,97,0,64,''),(1610,4,469,0,64,'2'),(1611,4,496,0,64,'Fantasy Flight Games'),(1612,4,497,0,64,'8033772895149'),(1613,4,499,0,64,'hardcover'),(1614,4,500,0,64,''),(1615,4,503,0,64,'English'),(1616,4,504,0,64,'0'),(1617,4,505,0,64,'0x0x0'),(1618,4,506,0,64,''),(1619,4,507,0,64,'  '),(1620,4,509,0,64,''),(1621,4,70,0,64,'/Z/9/Z98033772895149.jpg'),(1622,4,71,0,64,'/Z/9/Z98033772895149.jpg'),(1623,4,72,0,64,'/Z/9/Z98033772895149.jpg'),(1624,4,511,0,64,'0'),(1625,4,512,0,64,'US'),(1626,4,56,0,65,'Hoang Tu Ham Doc Sach (Chuyen Ke Cho Chau Nghe)'),(1627,4,67,0,65,''),(1628,4,69,0,65,''),(1629,4,82,0,65,'Hoang-Tu-Ham-Doc-Sach-(Chuyen-Ke-Cho-Chau-Nghe)-8932000113713'),(1630,4,83,0,65,'Hoang-Tu-Ham-Doc-Sach-(Chuyen-Ke-Cho-Chau-Nghe)-8932000113713.html'),(1631,4,92,0,65,'container2'),(1632,4,95,0,65,''),(1633,4,96,0,65,''),(1634,4,97,0,65,''),(1635,4,469,0,65,'2'),(1636,4,496,0,65,'Tran, Dongminh'),(1637,4,497,0,65,'8932000113713'),(1638,4,499,0,65,'paperback'),(1639,4,500,0,65,''),(1640,4,503,0,65,'English'),(1641,4,504,0,65,'138'),(1642,4,505,0,65,'0x0x0'),(1643,4,506,0,65,''),(1644,4,507,0,65,'  '),(1645,4,509,0,65,''),(1646,4,70,0,65,'/S/3/S38932000113713.jpg'),(1647,4,71,0,65,'/S/3/S38932000113713.jpg'),(1648,4,72,0,65,'/S/3/S38932000113713.jpg'),(1649,4,511,0,65,'0'),(1650,4,512,0,65,'US'),(1651,4,56,0,66,'The Adventures of Batman'),(1652,4,67,0,66,''),(1653,4,69,0,66,''),(1654,4,82,0,66,'The-Adventures-of-Batman-8934661181209'),(1655,4,83,0,66,'The-Adventures-of-Batman-8934661181209.html'),(1656,4,92,0,66,'container2'),(1657,4,95,0,66,''),(1658,4,96,0,66,''),(1659,4,97,0,66,''),(1660,4,469,0,66,'2'),(1661,4,496,0,66,'Greenberg, Martin Harry'),(1662,4,497,0,66,'8934661181209'),(1663,4,499,0,66,'paperback'),(1664,4,500,0,66,''),(1665,4,503,0,66,'English'),(1666,4,504,0,66,'1392'),(1667,4,505,0,66,'19.05x12.954x5.334'),(1668,4,506,0,66,''),(1669,4,507,0,66,'  '),(1670,4,509,0,66,''),(1671,4,70,0,66,'/B/9/B98934661181209.jpg'),(1672,4,71,0,66,'/B/9/B98934661181209.jpg'),(1673,4,72,0,66,'/B/9/B98934661181209.jpg'),(1674,4,511,0,66,'0'),(1675,4,512,0,66,'US'),(1676,4,56,0,67,'Ut Quyen Va Toi'),(1677,4,67,0,67,''),(1678,4,69,0,67,''),(1679,4,82,0,67,'Ut-Quyen-Va-Toi-8934974008972'),(1680,4,83,0,67,'Ut-Quyen-Va-Toi-8934974008972.html'),(1681,4,92,0,67,'container2'),(1682,4,95,0,67,''),(1683,4,96,0,67,''),(1684,4,97,0,67,''),(1685,4,469,0,67,'2'),(1686,4,496,0,67,'Nguyen, Nhatanh'),(1687,4,497,0,67,'8934974008972'),(1688,4,499,0,67,'paperback'),(1689,4,500,0,67,''),(1690,4,503,0,67,'English'),(1691,4,504,0,67,'151'),(1692,4,505,0,67,'17.018x10.414x0.762'),(1693,4,506,0,67,''),(1694,4,507,0,67,'  '),(1695,4,509,0,67,''),(1696,4,70,0,67,'/L/2/L28934974008972.jpg'),(1697,4,71,0,67,'/L/2/L28934974008972.jpg'),(1698,4,72,0,67,'/L/2/L28934974008972.jpg'),(1699,4,511,0,67,'0'),(1700,4,512,0,67,'US'),(1701,4,56,0,68,'Harry Potter and the Prisoner of Azkaban'),(1702,4,67,0,68,''),(1703,4,69,0,68,''),(1704,4,82,0,68,'Harry-Potter-and-the-Prisoner-of-Azkaban-8934974048480'),(1705,4,83,0,68,'Harry-Potter-and-the-Prisoner-of-Azkaban-8934974048480.html'),(1706,4,92,0,68,'container2'),(1707,4,95,0,68,''),(1708,4,96,0,68,''),(1709,4,97,0,68,''),(1710,4,469,0,68,'2'),(1711,4,496,0,68,'Rowling, J. K.'),(1712,4,497,0,68,'8934974048480'),(1713,4,499,0,68,'paperback'),(1714,4,500,0,68,''),(1715,4,503,0,68,'English'),(1716,4,504,0,68,'511'),(1717,4,505,0,68,'19.812x13.97x2.54'),(1718,4,506,0,68,''),(1719,4,507,0,68,'  '),(1720,4,509,0,68,''),(1721,4,70,0,68,'/U/0/U08934974048480.jpg'),(1722,4,71,0,68,'/U/0/U08934974048480.jpg'),(1723,4,72,0,68,'/U/0/U08934974048480.jpg'),(1724,4,511,0,68,'0'),(1725,4,512,0,68,'US'),(1726,4,56,0,69,'Harry Potter Va Hoang Tu Lai'),(1727,4,67,0,69,''),(1728,4,69,0,69,''),(1729,4,82,0,69,'Harry-Potter-Va-Hoang-Tu-Lai-8934974048794'),(1730,4,83,0,69,'Harry-Potter-Va-Hoang-Tu-Lai-8934974048794.html'),(1731,4,92,0,69,'container2'),(1732,4,95,0,69,''),(1733,4,96,0,69,''),(1734,4,97,0,69,''),(1735,4,469,0,69,'2'),(1736,4,496,0,69,'Rowling, J. K.'),(1737,4,497,0,69,'8934974048794'),(1738,4,499,0,69,'paperback'),(1739,4,500,0,69,''),(1740,4,503,0,69,'English'),(1741,4,504,0,69,'649'),(1742,4,505,0,69,'19.812x13.97x3.302'),(1743,4,506,0,69,''),(1744,4,507,0,69,'  '),(1745,4,509,0,69,''),(1746,4,70,0,69,'/Z/4/Z48934974048794.jpg'),(1747,4,71,0,69,'/Z/4/Z48934974048794.jpg'),(1748,4,72,0,69,'/Z/4/Z48934974048794.jpg'),(1749,4,511,0,69,'0'),(1750,4,512,0,69,'US'),(1751,4,56,0,70,'Inheritance Series: Eldest'),(1752,4,67,0,70,''),(1753,4,69,0,70,''),(1754,4,82,0,70,'Inheritance-Series:-Eldest-8934974055143'),(1755,4,83,0,70,'Inheritance-Series:-Eldest-8934974055143.html'),(1756,4,92,0,70,'container2'),(1757,4,95,0,70,''),(1758,4,96,0,70,''),(1759,4,97,0,70,''),(1760,4,469,0,70,'2'),(1761,4,496,0,70,'Paolini, Christopher'),(1762,4,497,0,70,'8934974055143'),(1763,4,499,0,70,'paperback'),(1764,4,500,0,70,''),(1765,4,503,0,70,'English'),(1766,4,504,0,70,'0'),(1767,4,505,0,70,'19.2532x13.1064x4.4704'),(1768,4,506,0,70,''),(1769,4,507,0,70,'  '),(1770,4,509,0,70,''),(1771,4,70,0,70,'/P/3/P38934974055143.jpg'),(1772,4,71,0,70,'/P/3/P38934974055143.jpg'),(1773,4,72,0,70,'/P/3/P38934974055143.jpg'),(1774,4,511,0,70,'0'),(1775,4,512,0,70,'US'),(1776,4,56,0,71,'The Merchant of Death'),(1777,4,67,0,71,''),(1778,4,69,0,71,''),(1779,4,82,0,71,'The-Merchant-of-Death-8934974061670'),(1780,4,83,0,71,'The-Merchant-of-Death-8934974061670.html'),(1781,4,92,0,71,'container2'),(1782,4,95,0,71,''),(1783,4,96,0,71,''),(1784,4,97,0,71,''),(1785,4,469,0,71,'2'),(1786,4,496,0,71,'MacHale, D. J.'),(1787,4,497,0,71,'8934974061670'),(1788,4,499,0,71,'paperback'),(1789,4,500,0,71,''),(1790,4,503,0,71,'English'),(1791,4,504,0,71,'557'),(1792,4,505,0,71,'18.796x12.954x2.794'),(1793,4,506,0,71,''),(1794,4,507,0,71,'  '),(1795,4,509,0,71,''),(1796,4,70,0,71,'/W/0/W08934974061670.jpg'),(1797,4,71,0,71,'/W/0/W08934974061670.jpg'),(1798,4,72,0,71,'/W/0/W08934974061670.jpg'),(1799,4,511,0,71,'0'),(1800,4,512,0,71,'US'),(1801,4,56,0,72,'The Lost City of Fear'),(1802,4,67,0,72,''),(1803,4,69,0,72,''),(1804,4,82,0,72,'The-Lost-City-of-Fear-8934974063308'),(1805,4,83,0,72,'The-Lost-City-of-Fear-8934974063308.html'),(1806,4,92,0,72,'container2'),(1807,4,95,0,72,''),(1808,4,96,0,72,''),(1809,4,97,0,72,''),(1810,4,469,0,72,'2'),(1811,4,496,0,72,'MacHale, D. J.'),(1812,4,497,0,72,'8934974063308'),(1813,4,499,0,72,'paperback'),(1814,4,500,0,72,''),(1815,4,503,0,72,'English'),(1816,4,504,0,72,'586'),(1817,4,505,0,72,'18.796x12.954x2.794'),(1818,4,506,0,72,''),(1819,4,507,0,72,'  '),(1820,4,509,0,72,''),(1821,4,70,0,72,'/N/8/N88934974063308.jpg'),(1822,4,71,0,72,'/N/8/N88934974063308.jpg'),(1823,4,72,0,72,'/N/8/N88934974063308.jpg'),(1824,4,511,0,72,'0'),(1825,4,512,0,72,'US'),(1826,4,56,0,73,'The Never War'),(1827,4,67,0,73,''),(1828,4,69,0,73,''),(1829,4,82,0,73,'The-Never-War-8934974068976'),(1830,4,83,0,73,'The-Never-War-8934974068976.html'),(1831,4,92,0,73,'container2'),(1832,4,95,0,73,''),(1833,4,96,0,73,''),(1834,4,97,0,73,''),(1835,4,469,0,73,'2'),(1836,4,496,0,73,'MacHale, D. J.'),(1837,4,497,0,73,'8934974068976'),(1838,4,499,0,73,'paperback'),(1839,4,500,0,73,''),(1840,4,503,0,73,'English'),(1841,4,504,0,73,'531'),(1842,4,505,0,73,'18.796x12.954x2.54'),(1843,4,506,0,73,''),(1844,4,507,0,73,'  '),(1845,4,509,0,73,''),(1846,4,70,0,73,'/X/6/X68934974068976.jpg'),(1847,4,71,0,73,'/X/6/X68934974068976.jpg'),(1848,4,72,0,73,'/X/6/X68934974068976.jpg'),(1849,4,511,0,73,'0'),(1850,4,512,0,73,'US'),(1851,4,56,0,74,'Pendragon: The Reality Bug'),(1852,4,67,0,74,''),(1853,4,69,0,74,''),(1854,4,82,0,74,'Pendragon:-The-Reality-Bug-8934974072720'),(1855,4,83,0,74,'Pendragon:-The-Reality-Bug-8934974072720.html'),(1856,4,92,0,74,'container2'),(1857,4,95,0,74,''),(1858,4,96,0,74,''),(1859,4,97,0,74,''),(1860,4,469,0,74,'2'),(1861,4,496,0,74,'MacHale, D. J.'),(1862,4,497,0,74,'8934974072720'),(1863,4,499,0,74,'paperback'),(1864,4,500,0,74,''),(1865,4,503,0,74,'English'),(1866,4,504,0,74,'599'),(1867,4,505,0,74,'18.542x12.954x3.556'),(1868,4,506,0,74,''),(1869,4,507,0,74,'  '),(1870,4,509,0,74,''),(1871,4,70,0,74,'/O/0/O08934974072720.jpg'),(1872,4,71,0,74,'/O/0/O08934974072720.jpg'),(1873,4,72,0,74,'/O/0/O08934974072720.jpg'),(1874,4,511,0,74,'0'),(1875,4,512,0,74,'US'),(1876,4,56,0,75,'Septimus Heap Book Two: Flyte'),(1877,4,67,0,75,''),(1878,4,69,0,75,''),(1879,4,82,0,75,'Septimus-Heap-Book-Two:-Flyte-8934974072805'),(1880,4,83,0,75,'Septimus-Heap-Book-Two:-Flyte-8934974072805.html'),(1881,4,92,0,75,'container2'),(1882,4,95,0,75,''),(1883,4,96,0,75,''),(1884,4,97,0,75,''),(1885,4,469,0,75,'2'),(1886,4,496,0,75,'Sage, Angie'),(1887,4,497,0,75,'8934974072805'),(1888,4,499,0,75,'paperback'),(1889,4,500,0,75,''),(1890,4,503,0,75,'English'),(1891,4,504,0,75,'562'),(1892,4,505,0,75,'18.796x12.954x2.286'),(1893,4,506,0,75,''),(1894,4,507,0,75,'  '),(1895,4,509,0,75,''),(1896,4,70,0,75,'/O/5/O58934974072805.jpg'),(1897,4,71,0,75,'/O/5/O58934974072805.jpg'),(1898,4,72,0,75,'/O/5/O58934974072805.jpg'),(1899,4,511,0,75,'0'),(1900,4,512,0,75,'US'),(1901,4,56,0,76,'Les Voies de la Lumiere'),(1902,4,67,0,76,''),(1903,4,69,0,76,''),(1904,4,82,0,76,'Les-Voies-de-la-Lumiere-8934974073109'),(1905,4,83,0,76,'Les-Voies-de-la-Lumiere-8934974073109.html'),(1906,4,92,0,76,'container2'),(1907,4,95,0,76,''),(1908,4,96,0,76,''),(1909,4,97,0,76,''),(1910,4,469,0,76,'2'),(1911,4,496,0,76,'Trinh, Xuanthuan'),(1912,4,497,0,76,'8934974073109'),(1913,4,499,0,76,'paperback'),(1914,4,500,0,76,''),(1915,4,503,0,76,'English'),(1916,4,504,0,76,'324'),(1917,4,505,0,76,'23.876x16.002x1.778'),(1918,4,506,0,76,''),(1919,4,507,0,76,'  '),(1920,4,509,0,76,''),(1921,4,70,0,76,'/Z/9/Z98934974073109.jpg'),(1922,4,71,0,76,'/Z/9/Z98934974073109.jpg'),(1923,4,72,0,76,'/Z/9/Z98934974073109.jpg'),(1924,4,511,0,76,'0'),(1925,4,512,0,76,'US'),(1926,4,56,0,77,'Black Water'),(1927,4,67,0,77,''),(1928,4,69,0,77,''),(1929,4,82,0,77,'Black-Water-8934974075912'),(1930,4,83,0,77,'Black-Water-8934974075912.html'),(1931,4,92,0,77,'container2'),(1932,4,95,0,77,''),(1933,4,96,0,77,''),(1934,4,97,0,77,''),(1935,4,469,0,77,'2'),(1936,4,496,0,77,'MacHale, D. J.'),(1937,4,497,0,77,'8934974075912'),(1938,4,499,0,77,'paperback'),(1939,4,500,0,77,''),(1940,4,503,0,77,'English'),(1941,4,504,0,77,'650'),(1942,4,505,0,77,'18.796x12.7x3.302'),(1943,4,506,0,77,''),(1944,4,507,0,77,'  '),(1945,4,509,0,77,''),(1946,4,70,0,77,'/A/2/A28934974075912.jpg'),(1947,4,71,0,77,'/A/2/A28934974075912.jpg'),(1948,4,72,0,77,'/A/2/A28934974075912.jpg'),(1949,4,511,0,77,'0'),(1950,4,512,0,77,'US'),(1951,4,56,0,78,'Harry Potter and the Order of the Phoenix'),(1952,4,67,0,78,''),(1953,4,69,0,78,''),(1954,4,82,0,78,'Harry-Potter-and-the-Order-of-the-Phoenix-8934974076278'),(1955,4,83,0,78,'Harry-Potter-and-the-Order-of-the-Phoenix-8934974076278.html'),(1956,4,92,0,78,'container2'),(1957,4,95,0,78,''),(1958,4,96,0,78,''),(1959,4,97,0,78,''),(1960,4,469,0,78,'2'),(1961,4,496,0,78,'Rowling, J. K.'),(1962,4,497,0,78,'8934974076278'),(1963,4,499,0,78,'paperback'),(1964,4,500,0,78,''),(1965,4,503,0,78,'English'),(1966,4,504,0,78,'0'),(1967,4,505,0,78,'0x0x0'),(1968,4,506,0,78,''),(1969,4,507,0,78,'  '),(1970,4,509,0,78,''),(1971,4,70,0,78,'/V/8/V88934974076278.jpg'),(1972,4,71,0,78,'/V/8/V88934974076278.jpg'),(1973,4,72,0,78,'/V/8/V88934974076278.jpg'),(1974,4,511,0,78,'0'),(1975,4,512,0,78,'US'),(1976,4,56,0,79,'Harry Potter and the Goblet of Fire'),(1977,4,67,0,79,''),(1978,4,69,0,79,''),(1979,4,82,0,79,'Harry-Potter-and-the-Goblet-of-Fire-8934974076797'),(1980,4,83,0,79,'Harry-Potter-and-the-Goblet-of-Fire-8934974076797.html'),(1981,4,92,0,79,'container2'),(1982,4,95,0,79,''),(1983,4,96,0,79,''),(1984,4,97,0,79,''),(1985,4,469,0,79,'2'),(1986,4,496,0,79,'Rowling, J. K.'),(1987,4,497,0,79,'8934974076797'),(1988,4,499,0,79,'paperback'),(1989,4,500,0,79,''),(1990,4,503,0,79,'English'),(1991,4,504,0,79,'991'),(1992,4,505,0,79,'19.812x13.97x4.318'),(1993,4,506,0,79,''),(1994,4,507,0,79,'  '),(1995,4,509,0,79,''),(1996,4,70,0,79,'/N/7/N78934974076797.jpg'),(1997,4,71,0,79,'/N/7/N78934974076797.jpg'),(1998,4,72,0,79,'/N/7/N78934974076797.jpg'),(1999,4,511,0,79,'0'),(2000,4,512,0,79,'US'),(2001,4,56,0,80,'Harry Potter and the Sorcerer\'s Stone'),(2002,4,67,0,80,''),(2003,4,69,0,80,''),(2004,4,82,0,80,'Harry-Potter-and-the-Sorcerers-Stone-8934974076803'),(2005,4,83,0,80,'Harry-Potter-and-the-Sorcerers-Stone-8934974076803.html'),(2006,4,92,0,80,'container2'),(2007,4,95,0,80,''),(2008,4,96,0,80,''),(2009,4,97,0,80,''),(2010,4,469,0,80,'2'),(2011,4,496,0,80,'Rowling, J. K.'),(2012,4,497,0,80,'8934974076803'),(2013,4,499,0,80,'paperback'),(2014,4,500,0,80,''),(2015,4,503,0,80,'English'),(2016,4,504,0,80,'435'),(2017,4,505,0,80,'19.812x13.716x1.778'),(2018,4,506,0,80,''),(2019,4,507,0,80,'  '),(2020,4,509,0,80,''),(2021,4,70,0,80,'/Y/3/Y38934974076803.jpg'),(2022,4,71,0,80,'/Y/3/Y38934974076803.jpg'),(2023,4,72,0,80,'/Y/3/Y38934974076803.jpg'),(2024,4,511,0,80,'0'),(2025,4,512,0,80,'US'),(2026,4,56,0,81,'Inheritance Series: Eragon'),(2027,4,67,0,81,''),(2028,4,69,0,81,''),(2029,4,82,0,81,'Inheritance-Series:-Eragon-8934974076933'),(2030,4,83,0,81,'Inheritance-Series:-Eragon-8934974076933.html'),(2031,4,92,0,81,'container2'),(2032,4,95,0,81,''),(2033,4,96,0,81,''),(2034,4,97,0,81,''),(2035,4,469,0,81,'2'),(2036,4,496,0,81,'Paolini, Christopher'),(2037,4,497,0,81,'8934974076933'),(2038,4,499,0,81,'paperback'),(2039,4,500,0,81,''),(2040,4,503,0,81,'English'),(2041,4,504,0,81,'0'),(2042,4,505,0,81,'18.796x12.954x2.032'),(2043,4,506,0,81,''),(2044,4,507,0,81,'  '),(2045,4,509,0,81,''),(2046,4,70,0,81,'/D/3/D38934974076933.jpg'),(2047,4,71,0,81,'/D/3/D38934974076933.jpg'),(2048,4,72,0,81,'/D/3/D38934974076933.jpg'),(2049,4,511,0,81,'0'),(2050,4,512,0,81,'US'),(2051,4,56,0,82,'Harry Potter and the Deathly Hallows'),(2052,4,67,0,82,''),(2053,4,69,0,82,''),(2054,4,82,0,82,'Harry-Potter-and-the-Deathly-Hallows-8934974076995'),(2055,4,83,0,82,'Harry-Potter-and-the-Deathly-Hallows-8934974076995.html'),(2056,4,92,0,82,'container2'),(2057,4,95,0,82,''),(2058,4,96,0,82,''),(2059,4,97,0,82,''),(2060,4,469,0,82,'2'),(2061,4,496,0,82,'Rowling, J. K.'),(2062,4,497,0,82,'8934974076995'),(2063,4,499,0,82,'paperback'),(2064,4,500,0,82,''),(2065,4,503,0,82,'English'),(2066,4,504,0,82,'0'),(2067,4,505,0,82,'0x0x0'),(2068,4,506,0,82,''),(2069,4,507,0,82,'  '),(2070,4,509,0,82,''),(2071,4,70,0,82,'/N/5/N58934974076995.jpg'),(2072,4,71,0,82,'/N/5/N58934974076995.jpg'),(2073,4,72,0,82,'/N/5/N58934974076995.jpg'),(2074,4,511,0,82,'0'),(2075,4,512,0,82,'US'),(2076,4,56,0,83,'The Code Book: The Science of Secrecy from Ancient Egypt to Quantum Cryotpgraphy'),(2077,4,67,0,83,''),(2078,4,69,0,83,''),(2079,4,82,0,83,'The-Code-Book:-The-Science-of-Secrecy-from-Ancient-Egypt-to-Quantum-Cryotpgraphy-8934974077657'),(2080,4,83,0,83,'The-Code-Book:-The-Science-of-Secrecy-from-Ancient-Egypt-to-Quantum-Cryotpgraphy-8934974077657.html'),(2081,4,92,0,83,'container2'),(2082,4,95,0,83,''),(2083,4,96,0,83,''),(2084,4,97,0,83,''),(2085,4,469,0,83,'2'),(2086,4,496,0,83,'Singh, Simon'),(2087,4,497,0,83,'8934974077657'),(2088,4,499,0,83,'paperback'),(2089,4,500,0,83,''),(2090,4,503,0,83,'English'),(2091,4,504,0,83,'490'),(2092,4,505,0,83,'20.574x14.224x2.54'),(2093,4,506,0,83,''),(2094,4,507,0,83,'  '),(2095,4,509,0,83,''),(2096,4,70,0,83,'/G/7/G78934974077657.jpg'),(2097,4,71,0,83,'/G/7/G78934974077657.jpg'),(2098,4,72,0,83,'/G/7/G78934974077657.jpg'),(2099,4,511,0,83,'0'),(2100,4,512,0,83,'US'),(2101,4,56,0,84,'Bay Nang Con Gai Cua Eva'),(2102,4,67,0,84,''),(2103,4,69,0,84,''),(2104,4,82,0,84,'Bay-Nang-Con-Gai-Cua-Eva-8934974077671'),(2105,4,83,0,84,'Bay-Nang-Con-Gai-Cua-Eva-8934974077671.html'),(2106,4,92,0,84,'container2'),(2107,4,95,0,84,''),(2108,4,96,0,84,''),(2109,4,97,0,84,''),(2110,4,469,0,84,'2'),(2111,4,496,0,84,'Sykes, Bryan'),(2112,4,497,0,84,'8934974077671'),(2113,4,499,0,84,'paperback'),(2114,4,500,0,84,''),(2115,4,503,0,84,'English'),(2116,4,504,0,84,'325'),(2117,4,505,0,84,'20.066x14.224x1.778'),(2118,4,506,0,84,''),(2119,4,507,0,84,'  '),(2120,4,509,0,84,''),(2121,4,70,0,84,'/G/1/G18934974077671.jpg'),(2122,4,71,0,84,'/G/1/G18934974077671.jpg'),(2123,4,72,0,84,'/G/1/G18934974077671.jpg'),(2124,4,511,0,84,'0'),(2125,4,512,0,84,'US'),(2126,4,56,0,85,'Harry Potter and the Chamber of Secrets'),(2127,4,67,0,85,''),(2128,4,69,0,85,''),(2129,4,82,0,85,'Harry-Potter-and-the-Chamber-of-Secrets-8934974078258'),(2130,4,83,0,85,'Harry-Potter-and-the-Chamber-of-Secrets-8934974078258.html'),(2131,4,92,0,85,'container2'),(2132,4,95,0,85,''),(2133,4,96,0,85,''),(2134,4,97,0,85,''),(2135,4,469,0,85,'2'),(2136,4,496,0,85,'Rowling, J. K.'),(2137,4,497,0,85,'8934974078258'),(2138,4,499,0,85,'paperback'),(2139,4,500,0,85,''),(2140,4,503,0,85,'English'),(2141,4,504,0,85,'463'),(2142,4,505,0,85,'19.812x13.716x2.032'),(2143,4,506,0,85,''),(2144,4,507,0,85,'  '),(2145,4,509,0,85,''),(2146,4,70,0,85,'/R/8/R88934974078258.jpg'),(2147,4,71,0,85,'/R/8/R88934974078258.jpg'),(2148,4,72,0,85,'/R/8/R88934974078258.jpg'),(2149,4,511,0,85,'0'),(2150,4,512,0,85,'US'),(2151,4,56,0,86,'Inheritance Series: Eragon'),(2152,4,67,0,86,''),(2153,4,69,0,86,''),(2154,4,82,0,86,'Inheritance-Series:-Eragon-8934974079446'),(2155,4,83,0,86,'Inheritance-Series:-Eragon-8934974079446.html'),(2156,4,92,0,86,'container2'),(2157,4,95,0,86,''),(2158,4,96,0,86,''),(2159,4,97,0,86,''),(2160,4,469,0,86,'2'),(2161,4,496,0,86,'Paolini, Christopher'),(2162,4,497,0,86,'8934974079446'),(2163,4,499,0,86,'paperback'),(2164,4,500,0,86,''),(2165,4,503,0,86,'English'),(2166,4,504,0,86,'0'),(2167,4,505,0,86,'18.796x12.954x1.778'),(2168,4,506,0,86,''),(2169,4,507,0,86,'  '),(2170,4,509,0,86,''),(2171,4,70,0,86,'/P/6/P68934974079446.jpg'),(2172,4,71,0,86,'/P/6/P68934974079446.jpg'),(2173,4,72,0,86,'/P/6/P68934974079446.jpg'),(2174,4,511,0,86,'0'),(2175,4,512,0,86,'US'),(2176,4,56,0,87,'Twilight'),(2177,4,67,0,87,''),(2178,4,69,0,87,''),(2179,4,82,0,87,'Twilight-8934974080336'),(2180,4,83,0,87,'Twilight-8934974080336.html'),(2181,4,92,0,87,'container2'),(2182,4,95,0,87,''),(2183,4,96,0,87,''),(2184,4,97,0,87,''),(2185,4,469,0,87,'2'),(2186,4,496,0,87,'Meyer, Stephenie'),(2187,4,497,0,87,'8934974080336'),(2188,4,499,0,87,'paperback'),(2189,4,500,0,87,''),(2190,4,503,0,87,'English'),(2191,4,504,0,87,'693'),(2192,4,505,0,87,'18.796x12.7x3.556'),(2193,4,506,0,87,''),(2194,4,507,0,87,'  '),(2195,4,509,0,87,''),(2196,4,70,0,87,'/R/6/R68934974080336.jpg'),(2197,4,71,0,87,'/R/6/R68934974080336.jpg'),(2198,4,72,0,87,'/R/6/R68934974080336.jpg'),(2199,4,511,0,87,'0'),(2200,4,512,0,87,'US'),(2201,4,56,0,88,'Trang Non'),(2202,4,67,0,88,''),(2203,4,69,0,88,''),(2204,4,82,0,88,'Trang-Non-8934974081067'),(2205,4,83,0,88,'Trang-Non-8934974081067.html'),(2206,4,92,0,88,'container2'),(2207,4,95,0,88,''),(2208,4,96,0,88,''),(2209,4,97,0,88,''),(2210,4,469,0,88,'2'),(2211,4,496,0,88,'Meyer, Stephenie'),(2212,4,497,0,88,'8934974081067'),(2213,4,499,0,88,'paperback'),(2214,4,500,0,88,''),(2215,4,503,0,88,'English'),(2216,4,504,0,88,'747'),(2217,4,505,0,88,'18.542x12.7x3.81'),(2218,4,506,0,88,''),(2219,4,507,0,88,'  '),(2220,4,509,0,88,''),(2221,4,70,0,88,'/H/7/H78934974081067.jpg'),(2222,4,71,0,88,'/H/7/H78934974081067.jpg'),(2223,4,72,0,88,'/H/7/H78934974081067.jpg'),(2224,4,511,0,88,'0'),(2225,4,512,0,88,'US'),(2226,4,56,0,89,'Brisingr'),(2227,4,67,0,89,''),(2228,4,69,0,89,''),(2229,4,82,0,89,'Brisingr-8934974082910'),(2230,4,83,0,89,'Brisingr-8934974082910.html'),(2231,4,92,0,89,'container2'),(2232,4,95,0,89,''),(2233,4,96,0,89,''),(2234,4,97,0,89,''),(2235,4,469,0,89,'2'),(2236,4,496,0,89,'Paolini, Christopher'),(2237,4,497,0,89,'8934974082910'),(2238,4,499,0,89,'paperback'),(2239,4,500,0,89,''),(2240,4,503,0,89,'English'),(2241,4,504,0,89,'544'),(2242,4,505,0,89,'18.796x12.954x2.54'),(2243,4,506,0,89,''),(2244,4,507,0,89,'  '),(2245,4,509,0,89,''),(2246,4,70,0,89,'/N/0/N08934974082910.jpg'),(2247,4,71,0,89,'/N/0/N08934974082910.jpg'),(2248,4,72,0,89,'/N/0/N08934974082910.jpg'),(2249,4,511,0,89,'0'),(2250,4,512,0,89,'US'),(2251,4,56,0,90,'The Tales of Beedle the Bard'),(2252,4,67,0,90,''),(2253,4,69,0,90,''),(2254,4,82,0,90,'The-Tales-of-Beedle-the-Bard-8934974082927'),(2255,4,83,0,90,'The-Tales-of-Beedle-the-Bard-8934974082927.html'),(2256,4,92,0,90,'container2'),(2257,4,95,0,90,''),(2258,4,96,0,90,''),(2259,4,97,0,90,''),(2260,4,469,0,90,'2'),(2261,4,496,0,90,'Rowling, J. K.'),(2262,4,497,0,90,'8934974082927'),(2263,4,499,0,90,'paperback'),(2264,4,500,0,90,''),(2265,4,503,0,90,'English'),(2266,4,504,0,90,'130'),(2267,4,505,0,90,'18.796x12.954x1.016'),(2268,4,506,0,90,''),(2269,4,507,0,90,'  '),(2270,4,509,0,90,''),(2271,4,70,0,90,'/S/7/S78934974082927.jpg'),(2272,4,71,0,90,'/S/7/S78934974082927.jpg'),(2273,4,72,0,90,'/S/7/S78934974082927.jpg'),(2274,4,511,0,90,'0'),(2275,4,512,0,90,'US'),(2276,4,56,0,91,'Twilight: Eclipse'),(2277,4,67,0,91,''),(2278,4,69,0,91,''),(2279,4,82,0,91,'Twilight:-Eclipse-8934974085911'),(2280,4,83,0,91,'Twilight:-Eclipse-8934974085911.html'),(2281,4,92,0,91,'container2'),(2282,4,95,0,91,''),(2283,4,96,0,91,''),(2284,4,97,0,91,''),(2285,4,469,0,91,'2'),(2286,4,496,0,91,'Meyer, Stephenie'),(2287,4,497,0,91,'8934974085911'),(2288,4,499,0,91,'paperback'),(2289,4,500,0,91,''),(2290,4,503,0,91,'English'),(2291,4,504,0,91,'942'),(2292,4,505,0,91,'18.8468x13.9192x4.6482'),(2293,4,506,0,91,''),(2294,4,507,0,91,'  '),(2295,4,509,0,91,''),(2296,4,70,0,91,'/M/1/M18934974085911.jpg'),(2297,4,71,0,91,'/M/1/M18934974085911.jpg'),(2298,4,72,0,91,'/M/1/M18934974085911.jpg'),(2299,4,511,0,91,'0'),(2300,4,512,0,91,'US'),(2301,4,56,0,92,'Annie\'s Baby'),(2302,4,67,0,92,''),(2303,4,69,0,92,''),(2304,4,82,0,92,'Annies-Baby-8934974086246'),(2305,4,83,0,92,'Annies-Baby-8934974086246.html'),(2306,4,92,0,92,'container2'),(2307,4,95,0,92,''),(2308,4,96,0,92,''),(2309,4,97,0,92,''),(2310,4,469,0,92,'2'),(2311,4,496,0,92,'Spark, Beatrice'),(2312,4,497,0,92,'8934974086246'),(2313,4,499,0,92,'paperback'),(2314,4,500,0,92,''),(2315,4,503,0,92,'English'),(2316,4,504,0,92,'330'),(2317,4,505,0,92,'0x0x0'),(2318,4,506,0,92,''),(2319,4,507,0,92,'  '),(2320,4,509,0,92,''),(2321,4,70,0,92,'/C/6/C68934974086246.jpg'),(2322,4,71,0,92,'/C/6/C68934974086246.jpg'),(2323,4,72,0,92,'/C/6/C68934974086246.jpg'),(2324,4,511,0,92,'0'),(2325,4,512,0,92,'US'),(2326,4,56,0,93,'Tunnels'),(2327,4,67,0,93,''),(2328,4,69,0,93,''),(2329,4,82,0,93,'Tunnels-8934974089780'),(2330,4,83,0,93,'Tunnels-8934974089780.html'),(2331,4,92,0,93,'container2'),(2332,4,95,0,93,''),(2333,4,96,0,93,''),(2334,4,97,0,93,''),(2335,4,469,0,93,'2'),(2336,4,496,0,93,'Gordon, Rodorick &. Brian Williams'),(2337,4,497,0,93,'8934974089780'),(2338,4,499,0,93,'paperback'),(2339,4,500,0,93,''),(2340,4,503,0,93,'English'),(2341,4,504,0,93,'571'),(2342,4,505,0,93,'0x0x0'),(2343,4,506,0,93,''),(2344,4,507,0,93,'  '),(2345,4,509,0,93,''),(2346,4,70,0,93,'/T/0/T08934974089780.jpg'),(2347,4,71,0,93,'/T/0/T08934974089780.jpg'),(2348,4,72,0,93,'/T/0/T08934974089780.jpg'),(2349,4,511,0,93,'0'),(2350,4,512,0,93,'US'),(2351,4,56,0,94,'Eq Inmuljeon Thomas Alva Edison'),(2352,4,67,0,94,''),(2353,4,69,0,94,''),(2354,4,82,0,94,'Eq-Inmuljeon-Thomas-Alva-Edison-8935036602206'),(2355,4,83,0,94,'Eq-Inmuljeon-Thomas-Alva-Edison-8935036602206.html'),(2356,4,92,0,94,'container2'),(2357,4,95,0,94,''),(2358,4,96,0,94,''),(2359,4,97,0,94,''),(2360,4,469,0,94,'2'),(2361,4,496,0,94,'Han, Kyeol'),(2362,4,497,0,94,'8935036602206'),(2363,4,499,0,94,'paperback'),(2364,4,500,0,94,''),(2365,4,503,0,94,'English'),(2366,4,504,0,94,'159'),(2367,4,505,0,94,'0x0x0'),(2368,4,506,0,94,''),(2369,4,507,0,94,'  '),(2370,4,509,0,94,''),(2371,4,70,0,94,'/L/6/L68935036602206.jpg'),(2372,4,71,0,94,'/L/6/L68935036602206.jpg'),(2373,4,72,0,94,'/L/6/L68935036602206.jpg'),(2374,4,511,0,94,'0'),(2375,4,512,0,94,'US'),(2376,4,56,0,95,'Eq Inmuljeon Isaac Newton'),(2377,4,67,0,95,''),(2378,4,69,0,95,''),(2379,4,82,0,95,'Eq-Inmuljeon-Isaac-Newton-8935036602213'),(2380,4,83,0,95,'Eq-Inmuljeon-Isaac-Newton-8935036602213.html'),(2381,4,92,0,95,'container2'),(2382,4,95,0,95,''),(2383,4,96,0,95,''),(2384,4,97,0,95,''),(2385,4,469,0,95,'2'),(2386,4,496,0,95,'Han, Kyeol'),(2387,4,497,0,95,'8935036602213'),(2388,4,499,0,95,'paperback'),(2389,4,500,0,95,''),(2390,4,503,0,95,'English'),(2391,4,504,0,95,'159'),(2392,4,505,0,95,'0x0x0'),(2393,4,506,0,95,''),(2394,4,507,0,95,'  '),(2395,4,509,0,95,''),(2396,4,70,0,95,'/Y/3/Y38935036602213.jpg'),(2397,4,71,0,95,'/Y/3/Y38935036602213.jpg'),(2398,4,72,0,95,'/Y/3/Y38935036602213.jpg'),(2399,4,511,0,95,'0'),(2400,4,512,0,95,'US'),(2401,4,56,0,96,'Eq Inmuljeon Napoleon Bonaparte'),(2402,4,67,0,96,''),(2403,4,69,0,96,''),(2404,4,82,0,96,'Eq-Inmuljeon-Napoleon-Bonaparte-8935036602220'),(2405,4,83,0,96,'Eq-Inmuljeon-Napoleon-Bonaparte-8935036602220.html'),(2406,4,92,0,96,'container2'),(2407,4,95,0,96,''),(2408,4,96,0,96,''),(2409,4,97,0,96,''),(2410,4,469,0,96,'2'),(2411,4,496,0,96,'Han, Kyeol'),(2412,4,497,0,96,'8935036602220'),(2413,4,499,0,96,'paperback'),(2414,4,500,0,96,''),(2415,4,503,0,96,'English'),(2416,4,504,0,96,'159'),(2417,4,505,0,96,'0x0x0'),(2418,4,506,0,96,''),(2419,4,507,0,96,'  '),(2420,4,509,0,96,''),(2421,4,70,0,96,'/L/0/L08935036602220.jpg'),(2422,4,71,0,96,'/L/0/L08935036602220.jpg'),(2423,4,72,0,96,'/L/0/L08935036602220.jpg'),(2424,4,511,0,96,'0'),(2425,4,512,0,96,'US'),(2426,4,56,0,97,'Eq Inmuljeon Alfred Bernhard Nobel'),(2427,4,67,0,97,''),(2428,4,69,0,97,''),(2429,4,82,0,97,'Eq-Inmuljeon-Alfred-Bernhard-Nobel-8935036602244'),(2430,4,83,0,97,'Eq-Inmuljeon-Alfred-Bernhard-Nobel-8935036602244.html'),(2431,4,92,0,97,'container2'),(2432,4,95,0,97,''),(2433,4,96,0,97,''),(2434,4,97,0,97,''),(2435,4,469,0,97,'2'),(2436,4,496,0,97,'Han, Kyeol'),(2437,4,497,0,97,'8935036602244'),(2438,4,499,0,97,'paperback'),(2439,4,500,0,97,''),(2440,4,503,0,97,'English'),(2441,4,504,0,97,'159'),(2442,4,505,0,97,'0x0x0'),(2443,4,506,0,97,''),(2444,4,507,0,97,'  '),(2445,4,509,0,97,''),(2446,4,70,0,97,'/D/4/D48935036602244.jpg'),(2447,4,71,0,97,'/D/4/D48935036602244.jpg'),(2448,4,72,0,97,'/D/4/D48935036602244.jpg'),(2449,4,511,0,97,'0'),(2450,4,512,0,97,'US'),(2451,4,56,0,98,'Eq Inmuljeon Jean Henri Fabre'),(2452,4,67,0,98,''),(2453,4,69,0,98,''),(2454,4,82,0,98,'Eq-Inmuljeon-Jean-Henri-Fabre-8935036602251'),(2455,4,83,0,98,'Eq-Inmuljeon-Jean-Henri-Fabre-8935036602251.html'),(2456,4,92,0,98,'container2'),(2457,4,95,0,98,''),(2458,4,96,0,98,''),(2459,4,97,0,98,''),(2460,4,469,0,98,'2'),(2461,4,496,0,98,'Han, Kyeol'),(2462,4,497,0,98,'8935036602251'),(2463,4,499,0,98,'paperback'),(2464,4,500,0,98,''),(2465,4,503,0,98,'English'),(2466,4,504,0,98,'159'),(2467,4,505,0,98,'0x0x0'),(2468,4,506,0,98,''),(2469,4,507,0,98,'  '),(2470,4,509,0,98,''),(2471,4,70,0,98,'/Q/1/Q18935036602251.jpg'),(2472,4,71,0,98,'/Q/1/Q18935036602251.jpg'),(2473,4,72,0,98,'/Q/1/Q18935036602251.jpg'),(2474,4,511,0,98,'0'),(2475,4,512,0,98,'US'),(2476,4,56,0,99,'Eq Inmuljeon Marie Curie'),(2477,4,67,0,99,''),(2478,4,69,0,99,''),(2479,4,82,0,99,'Eq-Inmuljeon-Marie-Curie-8935036602268'),(2480,4,83,0,99,'Eq-Inmuljeon-Marie-Curie-8935036602268.html'),(2481,4,92,0,99,'container2'),(2482,4,95,0,99,''),(2483,4,96,0,99,''),(2484,4,97,0,99,''),(2485,4,469,0,99,'2'),(2486,4,496,0,99,'Han, Kyeol'),(2487,4,497,0,99,'8935036602268'),(2488,4,499,0,99,'paperback'),(2489,4,500,0,99,''),(2490,4,503,0,99,'English'),(2491,4,504,0,99,'159'),(2492,4,505,0,99,'0x0x0'),(2493,4,506,0,99,''),(2494,4,507,0,99,'  '),(2495,4,509,0,99,''),(2496,4,70,0,99,'/V/8/V88935036602268.jpg'),(2497,4,71,0,99,'/V/8/V88935036602268.jpg'),(2498,4,72,0,99,'/V/8/V88935036602268.jpg'),(2499,4,511,0,99,'0'),(2500,4,512,0,99,'US'),(2501,4,56,0,100,'Eq Inmuljeon Helen Adams Keller'),(2502,4,67,0,100,''),(2503,4,69,0,100,''),(2504,4,82,0,100,'Eq-Inmuljeon-Helen-Adams-Keller-8935036602275'),(2505,4,83,0,100,'Eq-Inmuljeon-Helen-Adams-Keller-8935036602275.html'),(2506,4,92,0,100,'container2'),(2507,4,95,0,100,''),(2508,4,96,0,100,''),(2509,4,97,0,100,''),(2510,4,469,0,100,'2'),(2511,4,496,0,100,'Han, Kyeol'),(2512,4,497,0,100,'8935036602275'),(2513,4,499,0,100,'paperback'),(2514,4,500,0,100,''),(2515,4,503,0,100,'English'),(2516,4,504,0,100,'159'),(2517,4,505,0,100,'0x0x0'),(2518,4,506,0,100,''),(2519,4,507,0,100,'  '),(2520,4,509,0,100,''),(2521,4,70,0,100,'/I/5/I58935036602275.jpg'),(2522,4,71,0,100,'/I/5/I58935036602275.jpg'),(2523,4,72,0,100,'/I/5/I58935036602275.jpg'),(2524,4,511,0,100,'0'),(2525,4,512,0,100,'US');
/*!40000 ALTER TABLE `catalog_product_entity_varchar` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalog_product_link`
--

DROP TABLE IF EXISTS `catalog_product_link`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalog_product_link` (
  `link_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `product_id` int(10) unsigned NOT NULL DEFAULT '0',
  `linked_product_id` int(10) unsigned NOT NULL DEFAULT '0',
  `link_type_id` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`link_id`),
  KEY `FK_LINK_PRODUCT` (`product_id`),
  KEY `FK_LINKED_PRODUCT` (`linked_product_id`),
  KEY `FK_PRODUCT_LINK_TYPE` (`link_type_id`),
  CONSTRAINT `FK_PRODUCT_LINK_LINKED_PRODUCT` FOREIGN KEY (`linked_product_id`) REFERENCES `catalog_product_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_PRODUCT_LINK_PRODUCT` FOREIGN KEY (`product_id`) REFERENCES `catalog_product_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_PRODUCT_LINK_TYPE` FOREIGN KEY (`link_type_id`) REFERENCES `catalog_product_link_type` (`link_type_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Related products';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalog_product_link`
--

LOCK TABLES `catalog_product_link` WRITE;
/*!40000 ALTER TABLE `catalog_product_link` DISABLE KEYS */;
/*!40000 ALTER TABLE `catalog_product_link` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalog_product_link_attribute`
--

DROP TABLE IF EXISTS `catalog_product_link_attribute`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalog_product_link_attribute` (
  `product_link_attribute_id` smallint(6) unsigned NOT NULL AUTO_INCREMENT,
  `link_type_id` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `product_link_attribute_code` varchar(32) NOT NULL DEFAULT '',
  `data_type` varchar(32) NOT NULL DEFAULT '',
  PRIMARY KEY (`product_link_attribute_id`),
  KEY `FK_ATTRIBUTE_PRODUCT_LINK_TYPE` (`link_type_id`),
  CONSTRAINT `FK_ATTRIBUTE_PRODUCT_LINK_TYPE` FOREIGN KEY (`link_type_id`) REFERENCES `catalog_product_link_type` (`link_type_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COMMENT='Attributes for product link';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalog_product_link_attribute`
--

LOCK TABLES `catalog_product_link_attribute` WRITE;
/*!40000 ALTER TABLE `catalog_product_link_attribute` DISABLE KEYS */;
INSERT INTO `catalog_product_link_attribute` VALUES (1,2,'qty','decimal'),(2,1,'position','int'),(3,4,'position','int'),(4,5,'position','int'),(6,1,'qty','decimal'),(7,3,'position','int'),(8,3,'qty','decimal');
/*!40000 ALTER TABLE `catalog_product_link_attribute` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalog_product_link_attribute_decimal`
--

DROP TABLE IF EXISTS `catalog_product_link_attribute_decimal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalog_product_link_attribute_decimal` (
  `value_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `product_link_attribute_id` smallint(6) unsigned DEFAULT NULL,
  `link_id` int(11) unsigned DEFAULT NULL,
  `value` decimal(12,4) NOT NULL DEFAULT '0.0000',
  PRIMARY KEY (`value_id`),
  KEY `FK_DECIMAL_PRODUCT_LINK_ATTRIBUTE` (`product_link_attribute_id`),
  KEY `FK_DECIMAL_LINK` (`link_id`),
  CONSTRAINT `FK_DECIMAL_LINK` FOREIGN KEY (`link_id`) REFERENCES `catalog_product_link` (`link_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_DECIMAL_PRODUCT_LINK_ATTRIBUTE` FOREIGN KEY (`product_link_attribute_id`) REFERENCES `catalog_product_link_attribute` (`product_link_attribute_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Decimal attributes values';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalog_product_link_attribute_decimal`
--

LOCK TABLES `catalog_product_link_attribute_decimal` WRITE;
/*!40000 ALTER TABLE `catalog_product_link_attribute_decimal` DISABLE KEYS */;
/*!40000 ALTER TABLE `catalog_product_link_attribute_decimal` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalog_product_link_attribute_int`
--

DROP TABLE IF EXISTS `catalog_product_link_attribute_int`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalog_product_link_attribute_int` (
  `value_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `product_link_attribute_id` smallint(6) unsigned DEFAULT NULL,
  `link_id` int(11) unsigned DEFAULT NULL,
  `value` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`value_id`),
  KEY `FK_INT_PRODUCT_LINK_ATTRIBUTE` (`product_link_attribute_id`),
  KEY `FK_INT_PRODUCT_LINK` (`link_id`),
  CONSTRAINT `FK_INT_PRODUCT_LINK` FOREIGN KEY (`link_id`) REFERENCES `catalog_product_link` (`link_id`) ON DELETE CASCADE,
  CONSTRAINT `FK_INT_PRODUCT_LINK_ATTRIBUTE` FOREIGN KEY (`product_link_attribute_id`) REFERENCES `catalog_product_link_attribute` (`product_link_attribute_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalog_product_link_attribute_int`
--

LOCK TABLES `catalog_product_link_attribute_int` WRITE;
/*!40000 ALTER TABLE `catalog_product_link_attribute_int` DISABLE KEYS */;
/*!40000 ALTER TABLE `catalog_product_link_attribute_int` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalog_product_link_attribute_varchar`
--

DROP TABLE IF EXISTS `catalog_product_link_attribute_varchar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalog_product_link_attribute_varchar` (
  `value_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `product_link_attribute_id` smallint(6) unsigned NOT NULL DEFAULT '0',
  `link_id` int(11) unsigned DEFAULT NULL,
  `value` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`value_id`),
  KEY `FK_VARCHAR_PRODUCT_LINK_ATTRIBUTE` (`product_link_attribute_id`),
  KEY `FK_VARCHAR_LINK` (`link_id`),
  CONSTRAINT `FK_VARCHAR_LINK` FOREIGN KEY (`link_id`) REFERENCES `catalog_product_link` (`link_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_VARCHAR_PRODUCT_LINK_ATTRIBUTE` FOREIGN KEY (`product_link_attribute_id`) REFERENCES `catalog_product_link_attribute` (`product_link_attribute_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Varchar attributes values';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalog_product_link_attribute_varchar`
--

LOCK TABLES `catalog_product_link_attribute_varchar` WRITE;
/*!40000 ALTER TABLE `catalog_product_link_attribute_varchar` DISABLE KEYS */;
/*!40000 ALTER TABLE `catalog_product_link_attribute_varchar` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalog_product_link_type`
--

DROP TABLE IF EXISTS `catalog_product_link_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalog_product_link_type` (
  `link_type_id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(32) NOT NULL DEFAULT '',
  PRIMARY KEY (`link_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COMMENT='Types of product link(Related, superproduct, bundles)';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalog_product_link_type`
--

LOCK TABLES `catalog_product_link_type` WRITE;
/*!40000 ALTER TABLE `catalog_product_link_type` DISABLE KEYS */;
INSERT INTO `catalog_product_link_type` VALUES (1,'relation'),(2,'bundle'),(3,'super'),(4,'up_sell'),(5,'cross_sell');
/*!40000 ALTER TABLE `catalog_product_link_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalog_product_option`
--

DROP TABLE IF EXISTS `catalog_product_option`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalog_product_option` (
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
  KEY `CATALOG_PRODUCT_OPTION_PRODUCT` (`product_id`),
  CONSTRAINT `FK_CATALOG_PRODUCT_OPTION_PRODUCT` FOREIGN KEY (`product_id`) REFERENCES `catalog_product_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalog_product_option`
--

LOCK TABLES `catalog_product_option` WRITE;
/*!40000 ALTER TABLE `catalog_product_option` DISABLE KEYS */;
/*!40000 ALTER TABLE `catalog_product_option` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalog_product_option_price`
--

DROP TABLE IF EXISTS `catalog_product_option_price`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalog_product_option_price` (
  `option_price_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `option_id` int(10) unsigned NOT NULL DEFAULT '0',
  `store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `price` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `price_type` enum('fixed','percent') NOT NULL DEFAULT 'fixed',
  PRIMARY KEY (`option_price_id`),
  KEY `CATALOG_PRODUCT_OPTION_PRICE_OPTION` (`option_id`),
  KEY `CATALOG_PRODUCT_OPTION_TITLE_STORE` (`store_id`),
  KEY `IDX_CATALOG_PRODUCT_OPTION_PRICE_SI_OI` (`store_id`,`option_id`),
  CONSTRAINT `FK_CATALOG_PRODUCT_OPTION_PRICE_OPTION` FOREIGN KEY (`option_id`) REFERENCES `catalog_product_option` (`option_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CATALOG_PRODUCT_OPTION_PRICE_STORE` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalog_product_option_price`
--

LOCK TABLES `catalog_product_option_price` WRITE;
/*!40000 ALTER TABLE `catalog_product_option_price` DISABLE KEYS */;
/*!40000 ALTER TABLE `catalog_product_option_price` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalog_product_option_title`
--

DROP TABLE IF EXISTS `catalog_product_option_title`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalog_product_option_title` (
  `option_title_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `option_id` int(10) unsigned NOT NULL DEFAULT '0',
  `store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `title` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`option_title_id`),
  KEY `CATALOG_PRODUCT_OPTION_TITLE_OPTION` (`option_id`),
  KEY `CATALOG_PRODUCT_OPTION_TITLE_STORE` (`store_id`),
  KEY `IDX_CATALOG_PRODUCT_OPTION_TITLE_SI_OI` (`store_id`,`option_id`),
  CONSTRAINT `FK_CATALOG_PRODUCT_OPTION_TITLE_OPTION` FOREIGN KEY (`option_id`) REFERENCES `catalog_product_option` (`option_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CATALOG_PRODUCT_OPTION_TITLE_STORE` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalog_product_option_title`
--

LOCK TABLES `catalog_product_option_title` WRITE;
/*!40000 ALTER TABLE `catalog_product_option_title` DISABLE KEYS */;
/*!40000 ALTER TABLE `catalog_product_option_title` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalog_product_option_type_price`
--

DROP TABLE IF EXISTS `catalog_product_option_type_price`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalog_product_option_type_price` (
  `option_type_price_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `option_type_id` int(10) unsigned NOT NULL DEFAULT '0',
  `store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `price` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `price_type` enum('fixed','percent') NOT NULL DEFAULT 'fixed',
  PRIMARY KEY (`option_type_price_id`),
  KEY `CATALOG_PRODUCT_OPTION_TYPE_PRICE_OPTION_TYPE` (`option_type_id`),
  KEY `CATALOG_PRODUCT_OPTION_TYPE_PRICE_STORE` (`store_id`),
  KEY `IDX_CATALOG_PRODUCT_OPTION_TYPE_PRICE_SI_OTI` (`store_id`,`option_type_id`),
  CONSTRAINT `FK_CATALOG_PRODUCT_OPTION_TYPE_PRICE_OPTION` FOREIGN KEY (`option_type_id`) REFERENCES `catalog_product_option_type_value` (`option_type_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CATALOG_PRODUCT_OPTION_TYPE_PRICE_STORE` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalog_product_option_type_price`
--

LOCK TABLES `catalog_product_option_type_price` WRITE;
/*!40000 ALTER TABLE `catalog_product_option_type_price` DISABLE KEYS */;
/*!40000 ALTER TABLE `catalog_product_option_type_price` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalog_product_option_type_title`
--

DROP TABLE IF EXISTS `catalog_product_option_type_title`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalog_product_option_type_title` (
  `option_type_title_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `option_type_id` int(10) unsigned NOT NULL DEFAULT '0',
  `store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `title` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`option_type_title_id`),
  KEY `CATALOG_PRODUCT_OPTION_TYPE_TITLE_OPTION` (`option_type_id`),
  KEY `CATALOG_PRODUCT_OPTION_TYPE_TITLE_STORE` (`store_id`),
  KEY `IDX_CATALOG_PRODUCT_OPTION_TYPE_TITLE_SI_OTI` (`store_id`,`option_type_id`),
  CONSTRAINT `FK_CATALOG_PRODUCT_OPTION_TYPE_TITLE_OPTION` FOREIGN KEY (`option_type_id`) REFERENCES `catalog_product_option_type_value` (`option_type_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CATALOG_PRODUCT_OPTION_TYPE_TITLE_STORE` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalog_product_option_type_title`
--

LOCK TABLES `catalog_product_option_type_title` WRITE;
/*!40000 ALTER TABLE `catalog_product_option_type_title` DISABLE KEYS */;
/*!40000 ALTER TABLE `catalog_product_option_type_title` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalog_product_option_type_value`
--

DROP TABLE IF EXISTS `catalog_product_option_type_value`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalog_product_option_type_value` (
  `option_type_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `option_id` int(10) unsigned NOT NULL DEFAULT '0',
  `sku` varchar(64) NOT NULL DEFAULT '',
  `sort_order` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`option_type_id`),
  KEY `CATALOG_PRODUCT_OPTION_TYPE_VALUE_OPTION` (`option_id`),
  CONSTRAINT `FK_CATALOG_PRODUCT_OPTION_TYPE_VALUE_OPTION` FOREIGN KEY (`option_id`) REFERENCES `catalog_product_option` (`option_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalog_product_option_type_value`
--

LOCK TABLES `catalog_product_option_type_value` WRITE;
/*!40000 ALTER TABLE `catalog_product_option_type_value` DISABLE KEYS */;
/*!40000 ALTER TABLE `catalog_product_option_type_value` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalog_product_super_attribute`
--

DROP TABLE IF EXISTS `catalog_product_super_attribute`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalog_product_super_attribute` (
  `product_super_attribute_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `product_id` int(10) unsigned NOT NULL DEFAULT '0',
  `attribute_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `position` smallint(5) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`product_super_attribute_id`),
  KEY `FK_SUPER_PRODUCT_ATTRIBUTE_PRODUCT` (`product_id`),
  CONSTRAINT `FK_SUPER_PRODUCT_ATTRIBUTE_PRODUCT` FOREIGN KEY (`product_id`) REFERENCES `catalog_product_entity` (`entity_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalog_product_super_attribute`
--

LOCK TABLES `catalog_product_super_attribute` WRITE;
/*!40000 ALTER TABLE `catalog_product_super_attribute` DISABLE KEYS */;
/*!40000 ALTER TABLE `catalog_product_super_attribute` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalog_product_super_attribute_label`
--

DROP TABLE IF EXISTS `catalog_product_super_attribute_label`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalog_product_super_attribute_label` (
  `value_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `product_super_attribute_id` int(10) unsigned NOT NULL DEFAULT '0',
  `store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `value` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`value_id`),
  KEY `FK_SUPER_PRODUCT_ATTRIBUTE_LABEL` (`product_super_attribute_id`),
  KEY `IDX_CATALOG_PRODUCT_SUPER_ATTRIBUTE_STORE_PSAI_SI` (`product_super_attribute_id`,`store_id`),
  CONSTRAINT `FK_SUPER_PRODUCT_ATTRIBUTE_LABEL` FOREIGN KEY (`product_super_attribute_id`) REFERENCES `catalog_product_super_attribute` (`product_super_attribute_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalog_product_super_attribute_label`
--

LOCK TABLES `catalog_product_super_attribute_label` WRITE;
/*!40000 ALTER TABLE `catalog_product_super_attribute_label` DISABLE KEYS */;
/*!40000 ALTER TABLE `catalog_product_super_attribute_label` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalog_product_super_attribute_pricing`
--

DROP TABLE IF EXISTS `catalog_product_super_attribute_pricing`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalog_product_super_attribute_pricing` (
  `value_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `product_super_attribute_id` int(10) unsigned NOT NULL DEFAULT '0',
  `value_index` varchar(255) NOT NULL DEFAULT '',
  `is_percent` tinyint(1) unsigned DEFAULT '0',
  `pricing_value` decimal(10,4) DEFAULT NULL,
  `website_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`value_id`),
  KEY `FK_SUPER_PRODUCT_ATTRIBUTE_PRICING` (`product_super_attribute_id`),
  KEY `FK_CATALOG_PRODUCT_SUPER_PRICE_WEBSITE` (`website_id`),
  CONSTRAINT `FK_SUPER_PRODUCT_ATTRIBUTE_PRICING` FOREIGN KEY (`product_super_attribute_id`) REFERENCES `catalog_product_super_attribute` (`product_super_attribute_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CATALOG_PRODUCT_SUPER_PRICE_WEBSITE` FOREIGN KEY (`website_id`) REFERENCES `core_website` (`website_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalog_product_super_attribute_pricing`
--

LOCK TABLES `catalog_product_super_attribute_pricing` WRITE;
/*!40000 ALTER TABLE `catalog_product_super_attribute_pricing` DISABLE KEYS */;
/*!40000 ALTER TABLE `catalog_product_super_attribute_pricing` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalog_product_super_link`
--

DROP TABLE IF EXISTS `catalog_product_super_link`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalog_product_super_link` (
  `link_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `product_id` int(10) unsigned NOT NULL DEFAULT '0',
  `parent_id` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`link_id`),
  KEY `FK_SUPER_PRODUCT_LINK_PARENT` (`parent_id`),
  KEY `FK_catalog_product_super_link` (`product_id`),
  CONSTRAINT `FK_SUPER_PRODUCT_LINK_PARENT` FOREIGN KEY (`parent_id`) REFERENCES `catalog_product_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_SUPER_PRODUCT_LINK_ENTITY` FOREIGN KEY (`product_id`) REFERENCES `catalog_product_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalog_product_super_link`
--

LOCK TABLES `catalog_product_super_link` WRITE;
/*!40000 ALTER TABLE `catalog_product_super_link` DISABLE KEYS */;
/*!40000 ALTER TABLE `catalog_product_super_link` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalog_product_website`
--

DROP TABLE IF EXISTS `catalog_product_website`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalog_product_website` (
  `product_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `website_id` smallint(5) unsigned NOT NULL,
  PRIMARY KEY (`product_id`,`website_id`),
  KEY `FK_CATALOG_PRODUCT_WEBSITE_WEBSITE` (`website_id`),
  CONSTRAINT `FK_CATALOG_WEBSITE_PRODUCT_PRODUCT` FOREIGN KEY (`product_id`) REFERENCES `catalog_product_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CATALOG_PRODUCT_WEBSITE_WEBSITE` FOREIGN KEY (`website_id`) REFERENCES `core_website` (`website_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalog_product_website`
--

LOCK TABLES `catalog_product_website` WRITE;
/*!40000 ALTER TABLE `catalog_product_website` DISABLE KEYS */;
INSERT INTO `catalog_product_website` VALUES (1,1),(2,1),(3,1),(4,1),(5,1),(6,1),(7,1),(8,1),(9,1),(10,1),(11,1),(12,1),(13,1),(14,1),(15,1),(16,1),(17,1),(18,1),(19,1),(20,1),(21,1),(22,1),(23,1),(24,1),(25,1),(26,1),(27,1),(28,1),(29,1),(30,1),(31,1),(32,1),(33,1),(34,1),(35,1),(36,1),(37,1),(38,1),(39,1),(40,1),(41,1),(42,1),(43,1),(44,1),(45,1),(46,1),(47,1),(48,1),(49,1),(50,1),(51,1),(52,1),(53,1),(54,1),(55,1),(56,1),(57,1),(58,1),(59,1),(60,1),(61,1),(62,1),(63,1),(64,1),(65,1),(66,1),(67,1),(68,1),(69,1),(70,1),(71,1),(72,1),(73,1),(74,1),(75,1),(76,1),(77,1),(78,1),(79,1),(80,1),(81,1),(82,1),(83,1),(84,1),(85,1),(86,1),(87,1),(88,1),(89,1),(90,1),(91,1),(92,1),(93,1),(94,1),(95,1),(96,1),(97,1),(98,1),(99,1),(100,1);
/*!40000 ALTER TABLE `catalog_product_website` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalogindex_aggregation`
--

DROP TABLE IF EXISTS `catalogindex_aggregation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalogindex_aggregation` (
  `aggregation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `store_id` smallint(5) unsigned NOT NULL,
  `created_at` datetime NOT NULL,
  `key` varchar(255) DEFAULT NULL,
  `data` mediumtext,
  PRIMARY KEY (`aggregation_id`),
  UNIQUE KEY `IDX_STORE_KEY` (`store_id`,`key`),
  CONSTRAINT `FK_CATALOGINDEX_AGGREGATION_STORE` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalogindex_aggregation`
--

LOCK TABLES `catalogindex_aggregation` WRITE;
/*!40000 ALTER TABLE `catalogindex_aggregation` DISABLE KEYS */;
/*!40000 ALTER TABLE `catalogindex_aggregation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalogindex_aggregation_tag`
--

DROP TABLE IF EXISTS `catalogindex_aggregation_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalogindex_aggregation_tag` (
  `tag_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `tag_code` varchar(255) NOT NULL,
  PRIMARY KEY (`tag_id`),
  UNIQUE KEY `IDX_CODE` (`tag_code`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalogindex_aggregation_tag`
--

LOCK TABLES `catalogindex_aggregation_tag` WRITE;
/*!40000 ALTER TABLE `catalogindex_aggregation_tag` DISABLE KEYS */;
/*!40000 ALTER TABLE `catalogindex_aggregation_tag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalogindex_aggregation_to_tag`
--

DROP TABLE IF EXISTS `catalogindex_aggregation_to_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalogindex_aggregation_to_tag` (
  `aggregation_id` int(10) unsigned NOT NULL,
  `tag_id` int(10) unsigned NOT NULL,
  UNIQUE KEY `IDX_AGGREGATION_TAG` (`aggregation_id`,`tag_id`),
  KEY `FK_CATALOGINDEX_AGGREGATION_TO_TAG_TAG` (`tag_id`),
  CONSTRAINT `FK_CATALOGINDEX_AGGREGATION_TO_TAG_AGGREGATION` FOREIGN KEY (`aggregation_id`) REFERENCES `catalogindex_aggregation` (`aggregation_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CATALOGINDEX_AGGREGATION_TO_TAG_TAG` FOREIGN KEY (`tag_id`) REFERENCES `catalogindex_aggregation_tag` (`tag_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalogindex_aggregation_to_tag`
--

LOCK TABLES `catalogindex_aggregation_to_tag` WRITE;
/*!40000 ALTER TABLE `catalogindex_aggregation_to_tag` DISABLE KEYS */;
/*!40000 ALTER TABLE `catalogindex_aggregation_to_tag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalogindex_eav`
--

DROP TABLE IF EXISTS `catalogindex_eav`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalogindex_eav` (
  `store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `entity_id` int(10) unsigned NOT NULL DEFAULT '0',
  `attribute_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `value` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`store_id`,`entity_id`,`attribute_id`,`value`),
  KEY `IDX_VALUE` (`value`),
  KEY `FK_CATALOGINDEX_EAV_ENTITY` (`entity_id`),
  KEY `FK_CATALOGINDEX_EAV_ATTRIBUTE` (`attribute_id`),
  KEY `FK_CATALOGINDEX_EAV_STORE` (`store_id`),
  CONSTRAINT `FK_CATALOGINDEX_EAV_ATTRIBUTE` FOREIGN KEY (`attribute_id`) REFERENCES `eav_attribute` (`attribute_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CATALOGINDEX_EAV_ENTITY` FOREIGN KEY (`entity_id`) REFERENCES `catalog_product_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CATALOGINDEX_EAV_STORE` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalogindex_eav`
--

LOCK TABLES `catalogindex_eav` WRITE;
/*!40000 ALTER TABLE `catalogindex_eav` DISABLE KEYS */;
INSERT INTO `catalogindex_eav` VALUES (1,1,81,0),(1,2,81,0),(1,3,81,0),(1,4,81,0),(1,5,81,0),(1,6,81,0),(1,7,81,0),(1,8,81,0),(1,9,81,0),(1,10,81,0),(1,11,81,0),(1,12,81,0),(1,13,81,0),(1,14,81,0),(1,15,81,0),(1,16,81,0),(1,17,81,0),(1,18,81,0),(1,19,81,0),(1,20,81,0),(1,21,81,0),(1,22,81,0),(1,23,81,0),(1,24,81,0),(1,25,81,0),(1,26,81,0),(1,27,81,0),(1,28,81,0),(1,29,81,0),(1,30,81,0),(1,31,81,0),(1,32,81,0),(1,33,81,0),(1,34,81,0),(1,35,81,0),(1,36,81,0),(1,37,81,0),(1,38,81,0),(1,39,81,0),(1,40,81,0),(1,41,81,0),(1,42,81,0),(1,43,81,0),(1,44,81,0),(1,45,81,0),(1,46,81,0),(1,47,81,0),(1,48,81,0),(1,49,81,0),(1,50,81,0),(1,51,81,0),(1,52,81,0),(1,53,81,0),(1,54,81,0),(1,55,81,0),(1,56,81,0),(1,57,81,0),(1,58,81,0),(1,59,81,0),(1,60,81,0),(1,61,81,0),(1,62,81,0),(1,63,81,0),(1,64,81,0),(1,65,81,0),(1,66,81,0),(1,67,81,0),(1,68,81,0),(1,69,81,0),(1,70,81,0),(1,71,81,0),(1,72,81,0),(1,73,81,0),(1,74,81,0),(1,75,81,0),(1,76,81,0),(1,77,81,0),(1,78,81,0),(1,79,81,0),(1,80,81,0),(1,81,81,0),(1,82,81,0),(1,83,81,0),(1,84,81,0),(1,85,81,0),(1,86,81,0),(1,87,81,0),(1,88,81,0),(1,89,81,0),(1,90,81,0),(1,91,81,0),(1,92,81,0),(1,93,81,0),(1,94,81,0),(1,95,81,0),(1,96,81,0),(1,97,81,0),(1,98,81,0),(1,99,81,0),(1,100,81,0);
/*!40000 ALTER TABLE `catalogindex_eav` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalogindex_minimal_price`
--

DROP TABLE IF EXISTS `catalogindex_minimal_price`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalogindex_minimal_price` (
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
  KEY `IDX_FULL` (`entity_id`,`qty`,`customer_group_id`,`value`,`website_id`),
  CONSTRAINT `FK_CATALOGINDEX_MINIMAL_PRICE_CUSTOMER_GROUP` FOREIGN KEY (`customer_group_id`) REFERENCES `customer_group` (`customer_group_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CATALOGINDEX_MINIMAL_PRICE_ENTITY` FOREIGN KEY (`entity_id`) REFERENCES `catalog_product_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CI_MINIMAL_PRICE_WEBSITE_ID` FOREIGN KEY (`website_id`) REFERENCES `core_website` (`website_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalogindex_minimal_price`
--

LOCK TABLES `catalogindex_minimal_price` WRITE;
/*!40000 ALTER TABLE `catalogindex_minimal_price` DISABLE KEYS */;
/*!40000 ALTER TABLE `catalogindex_minimal_price` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalogindex_price`
--

DROP TABLE IF EXISTS `catalogindex_price`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalogindex_price` (
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
  KEY `IDX_FULL` (`entity_id`,`attribute_id`,`customer_group_id`,`value`,`website_id`),
  CONSTRAINT `FK_CATALOGINDEX_PRICE_ATTRIBUTE` FOREIGN KEY (`attribute_id`) REFERENCES `eav_attribute` (`attribute_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CATALOGINDEX_PRICE_ENTITY` FOREIGN KEY (`entity_id`) REFERENCES `catalog_product_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CI_PRICE_WEBSITE_ID` FOREIGN KEY (`website_id`) REFERENCES `core_website` (`website_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalogindex_price`
--

LOCK TABLES `catalogindex_price` WRITE;
/*!40000 ALTER TABLE `catalogindex_price` DISABLE KEYS */;
INSERT INTO `catalogindex_price` VALUES (1,60,0,'0.0000','99.5000',0,1),(1,60,1,'0.0000','99.5000',0,1),(1,60,2,'0.0000','99.5000',0,1),(1,60,3,'0.0000','99.5000',0,1),(2,60,0,'0.0000','600.0000',0,1),(2,60,1,'0.0000','600.0000',0,1),(2,60,2,'0.0000','600.0000',0,1),(2,60,3,'0.0000','600.0000',0,1),(3,60,0,'0.0000','10425.0000',0,1),(3,60,1,'0.0000','10425.0000',0,1),(3,60,2,'0.0000','10425.0000',0,1),(3,60,3,'0.0000','10425.0000',0,1),(4,60,0,'0.0000','749.5000',0,1),(4,60,1,'0.0000','749.5000',0,1),(4,60,2,'0.0000','749.5000',0,1),(4,60,3,'0.0000','749.5000',0,1),(5,60,0,'0.0000','599.5000',0,1),(5,60,1,'0.0000','599.5000',0,1),(5,60,2,'0.0000','599.5000',0,1),(5,60,3,'0.0000','599.5000',0,1),(6,60,0,'0.0000','1000.0000',0,1),(6,60,1,'0.0000','1000.0000',0,1),(6,60,2,'0.0000','1000.0000',0,1),(6,60,3,'0.0000','1000.0000',0,1),(7,60,0,'0.0000','3499.5000',0,1),(7,60,1,'0.0000','3499.5000',0,1),(7,60,2,'0.0000','3499.5000',0,1),(7,60,3,'0.0000','3499.5000',0,1),(8,60,0,'0.0000','3749.5000',0,1),(8,60,1,'0.0000','3749.5000',0,1),(8,60,2,'0.0000','3749.5000',0,1),(8,60,3,'0.0000','3749.5000',0,1),(9,60,0,'0.0000','19750.0000',0,1),(9,60,1,'0.0000','19750.0000',0,1),(9,60,2,'0.0000','19750.0000',0,1),(9,60,3,'0.0000','19750.0000',0,1),(10,60,0,'0.0000','3749.5000',0,1),(10,60,1,'0.0000','3749.5000',0,1),(10,60,2,'0.0000','3749.5000',0,1),(10,60,3,'0.0000','3749.5000',0,1),(11,60,0,'0.0000','3749.5000',0,1),(11,60,1,'0.0000','3749.5000',0,1),(11,60,2,'0.0000','3749.5000',0,1),(11,60,3,'0.0000','3749.5000',0,1),(12,60,0,'0.0000','3749.5000',0,1),(12,60,1,'0.0000','3749.5000',0,1),(12,60,2,'0.0000','3749.5000',0,1),(12,60,3,'0.0000','3749.5000',0,1),(13,60,0,'0.0000','3749.5000',0,1),(13,60,1,'0.0000','3749.5000',0,1),(13,60,2,'0.0000','3749.5000',0,1),(13,60,3,'0.0000','3749.5000',0,1),(14,60,0,'0.0000','3749.5000',0,1),(14,60,1,'0.0000','3749.5000',0,1),(14,60,2,'0.0000','3749.5000',0,1),(14,60,3,'0.0000','3749.5000',0,1),(15,60,0,'0.0000','3749.5000',0,1),(15,60,1,'0.0000','3749.5000',0,1),(15,60,2,'0.0000','3749.5000',0,1),(15,60,3,'0.0000','3749.5000',0,1),(16,60,0,'0.0000','3749.5000',0,1),(16,60,1,'0.0000','3749.5000',0,1),(16,60,2,'0.0000','3749.5000',0,1),(16,60,3,'0.0000','3749.5000',0,1),(17,60,0,'0.0000','3749.5000',0,1),(17,60,1,'0.0000','3749.5000',0,1),(17,60,2,'0.0000','3749.5000',0,1),(17,60,3,'0.0000','3749.5000',0,1),(18,60,0,'0.0000','3749.5000',0,1),(18,60,1,'0.0000','3749.5000',0,1),(18,60,2,'0.0000','3749.5000',0,1),(18,60,3,'0.0000','3749.5000',0,1),(19,60,0,'0.0000','3749.5000',0,1),(19,60,1,'0.0000','3749.5000',0,1),(19,60,2,'0.0000','3749.5000',0,1),(19,60,3,'0.0000','3749.5000',0,1),(20,60,0,'0.0000','3749.5000',0,1),(20,60,1,'0.0000','3749.5000',0,1),(20,60,2,'0.0000','3749.5000',0,1),(20,60,3,'0.0000','3749.5000',0,1),(21,60,0,'0.0000','3749.5000',0,1),(21,60,1,'0.0000','3749.5000',0,1),(21,60,2,'0.0000','3749.5000',0,1),(21,60,3,'0.0000','3749.5000',0,1),(22,60,0,'0.0000','3749.5000',0,1),(22,60,1,'0.0000','3749.5000',0,1),(22,60,2,'0.0000','3749.5000',0,1),(22,60,3,'0.0000','3749.5000',0,1),(23,60,0,'0.0000','3749.5000',0,1),(23,60,1,'0.0000','3749.5000',0,1),(23,60,2,'0.0000','3749.5000',0,1),(23,60,3,'0.0000','3749.5000',0,1),(24,60,0,'0.0000','3749.5000',0,1),(24,60,1,'0.0000','3749.5000',0,1),(24,60,2,'0.0000','3749.5000',0,1),(24,60,3,'0.0000','3749.5000',0,1),(25,60,0,'0.0000','3749.5000',0,1),(25,60,1,'0.0000','3749.5000',0,1),(25,60,2,'0.0000','3749.5000',0,1),(25,60,3,'0.0000','3749.5000',0,1),(26,60,0,'0.0000','3749.5000',0,1),(26,60,1,'0.0000','3749.5000',0,1),(26,60,2,'0.0000','3749.5000',0,1),(26,60,3,'0.0000','3749.5000',0,1),(27,60,0,'0.0000','3749.5000',0,1),(27,60,1,'0.0000','3749.5000',0,1),(27,60,2,'0.0000','3749.5000',0,1),(27,60,3,'0.0000','3749.5000',0,1),(28,60,0,'0.0000','3749.5000',0,1),(28,60,1,'0.0000','3749.5000',0,1),(28,60,2,'0.0000','3749.5000',0,1),(28,60,3,'0.0000','3749.5000',0,1),(29,60,0,'0.0000','3749.5000',0,1),(29,60,1,'0.0000','3749.5000',0,1),(29,60,2,'0.0000','3749.5000',0,1),(29,60,3,'0.0000','3749.5000',0,1),(30,60,0,'0.0000','3749.5000',0,1),(30,60,1,'0.0000','3749.5000',0,1),(30,60,2,'0.0000','3749.5000',0,1),(30,60,3,'0.0000','3749.5000',0,1),(31,60,0,'0.0000','3749.5000',0,1),(31,60,1,'0.0000','3749.5000',0,1),(31,60,2,'0.0000','3749.5000',0,1),(31,60,3,'0.0000','3749.5000',0,1),(32,60,0,'0.0000','3749.5000',0,1),(32,60,1,'0.0000','3749.5000',0,1),(32,60,2,'0.0000','3749.5000',0,1),(32,60,3,'0.0000','3749.5000',0,1),(33,60,0,'0.0000','3749.5000',0,1),(33,60,1,'0.0000','3749.5000',0,1),(33,60,2,'0.0000','3749.5000',0,1),(33,60,3,'0.0000','3749.5000',0,1),(34,60,0,'0.0000','3749.5000',0,1),(34,60,1,'0.0000','3749.5000',0,1),(34,60,2,'0.0000','3749.5000',0,1),(34,60,3,'0.0000','3749.5000',0,1),(35,60,0,'0.0000','3749.5000',0,1),(35,60,1,'0.0000','3749.5000',0,1),(35,60,2,'0.0000','3749.5000',0,1),(35,60,3,'0.0000','3749.5000',0,1),(36,60,0,'0.0000','3749.5000',0,1),(36,60,1,'0.0000','3749.5000',0,1),(36,60,2,'0.0000','3749.5000',0,1),(36,60,3,'0.0000','3749.5000',0,1),(37,60,0,'0.0000','3749.5000',0,1),(37,60,1,'0.0000','3749.5000',0,1),(37,60,2,'0.0000','3749.5000',0,1),(37,60,3,'0.0000','3749.5000',0,1),(38,60,0,'0.0000','3749.5000',0,1),(38,60,1,'0.0000','3749.5000',0,1),(38,60,2,'0.0000','3749.5000',0,1),(38,60,3,'0.0000','3749.5000',0,1),(39,60,0,'0.0000','3749.5000',0,1),(39,60,1,'0.0000','3749.5000',0,1),(39,60,2,'0.0000','3749.5000',0,1),(39,60,3,'0.0000','3749.5000',0,1),(40,60,0,'0.0000','3749.5000',0,1),(40,60,1,'0.0000','3749.5000',0,1),(40,60,2,'0.0000','3749.5000',0,1),(40,60,3,'0.0000','3749.5000',0,1),(41,60,0,'0.0000','3749.5000',0,1),(41,60,1,'0.0000','3749.5000',0,1),(41,60,2,'0.0000','3749.5000',0,1),(41,60,3,'0.0000','3749.5000',0,1),(42,60,0,'0.0000','3749.5000',0,1),(42,60,1,'0.0000','3749.5000',0,1),(42,60,2,'0.0000','3749.5000',0,1),(42,60,3,'0.0000','3749.5000',0,1),(43,60,0,'0.0000','3749.5000',0,1),(43,60,1,'0.0000','3749.5000',0,1),(43,60,2,'0.0000','3749.5000',0,1),(43,60,3,'0.0000','3749.5000',0,1),(44,60,0,'0.0000','3749.5000',0,1),(44,60,1,'0.0000','3749.5000',0,1),(44,60,2,'0.0000','3749.5000',0,1),(44,60,3,'0.0000','3749.5000',0,1),(45,60,0,'0.0000','3749.5000',0,1),(45,60,1,'0.0000','3749.5000',0,1),(45,60,2,'0.0000','3749.5000',0,1),(45,60,3,'0.0000','3749.5000',0,1),(46,60,0,'0.0000','3749.5000',0,1),(46,60,1,'0.0000','3749.5000',0,1),(46,60,2,'0.0000','3749.5000',0,1),(46,60,3,'0.0000','3749.5000',0,1),(47,60,0,'0.0000','3749.5000',0,1),(47,60,1,'0.0000','3749.5000',0,1),(47,60,2,'0.0000','3749.5000',0,1),(47,60,3,'0.0000','3749.5000',0,1),(48,60,0,'0.0000','3749.5000',0,1),(48,60,1,'0.0000','3749.5000',0,1),(48,60,2,'0.0000','3749.5000',0,1),(48,60,3,'0.0000','3749.5000',0,1),(49,60,0,'0.0000','1000.0000',0,1),(49,60,1,'0.0000','1000.0000',0,1),(49,60,2,'0.0000','1000.0000',0,1),(49,60,3,'0.0000','1000.0000',0,1),(50,60,0,'0.0000','1247.5000',0,1),(50,60,1,'0.0000','1247.5000',0,1),(50,60,2,'0.0000','1247.5000',0,1),(50,60,3,'0.0000','1247.5000',0,1),(51,60,0,'0.0000','297.5000',0,1),(51,60,1,'0.0000','297.5000',0,1),(51,60,2,'0.0000','297.5000',0,1),(51,60,3,'0.0000','297.5000',0,1),(52,60,0,'0.0000','497.5000',0,1),(52,60,1,'0.0000','497.5000',0,1),(52,60,2,'0.0000','497.5000',0,1),(52,60,3,'0.0000','497.5000',0,1),(53,60,0,'0.0000','1249.5000',0,1),(53,60,1,'0.0000','1249.5000',0,1),(53,60,2,'0.0000','1249.5000',0,1),(53,60,3,'0.0000','1249.5000',0,1),(54,60,0,'0.0000','1100.0000',0,1),(54,60,1,'0.0000','1100.0000',0,1),(54,60,2,'0.0000','1100.0000',0,1),(54,60,3,'0.0000','1100.0000',0,1),(55,60,0,'0.0000','575.0000',0,1),(55,60,1,'0.0000','575.0000',0,1),(55,60,2,'0.0000','575.0000',0,1),(55,60,3,'0.0000','575.0000',0,1),(56,60,0,'0.0000','1670.0000',0,1),(56,60,1,'0.0000','1670.0000',0,1),(56,60,2,'0.0000','1670.0000',0,1),(56,60,3,'0.0000','1670.0000',0,1),(57,60,0,'0.0000','630.0000',0,1),(57,60,1,'0.0000','630.0000',0,1),(57,60,2,'0.0000','630.0000',0,1),(57,60,3,'0.0000','630.0000',0,1),(58,60,0,'0.0000','4500.0000',0,1),(58,60,1,'0.0000','4500.0000',0,1),(58,60,2,'0.0000','4500.0000',0,1),(58,60,3,'0.0000','4500.0000',0,1),(59,60,0,'0.0000','1425.0000',0,1),(59,60,1,'0.0000','1425.0000',0,1),(59,60,2,'0.0000','1425.0000',0,1),(59,60,3,'0.0000','1425.0000',0,1),(60,60,0,'0.0000','2065.0000',0,1),(60,60,1,'0.0000','2065.0000',0,1),(60,60,2,'0.0000','2065.0000',0,1),(60,60,3,'0.0000','2065.0000',0,1),(61,60,0,'0.0000','499.5000',0,1),(61,60,1,'0.0000','499.5000',0,1),(61,60,2,'0.0000','499.5000',0,1),(61,60,3,'0.0000','499.5000',0,1),(62,60,0,'0.0000','649.5000',0,1),(62,60,1,'0.0000','649.5000',0,1),(62,60,2,'0.0000','649.5000',0,1),(62,60,3,'0.0000','649.5000',0,1),(63,60,0,'0.0000','5200.0000',0,1),(63,60,1,'0.0000','5200.0000',0,1),(63,60,2,'0.0000','5200.0000',0,1),(63,60,3,'0.0000','5200.0000',0,1),(64,60,0,'0.0000','497.5000',0,1),(64,60,1,'0.0000','497.5000',0,1),(64,60,2,'0.0000','497.5000',0,1),(64,60,3,'0.0000','497.5000',0,1),(65,60,0,'0.0000','575.0000',0,1),(65,60,1,'0.0000','575.0000',0,1),(65,60,2,'0.0000','575.0000',0,1),(65,60,3,'0.0000','575.0000',0,1),(66,60,0,'0.0000','3150.0000',0,1),(66,60,1,'0.0000','3150.0000',0,1),(66,60,2,'0.0000','3150.0000',0,1),(66,60,3,'0.0000','3150.0000',0,1),(67,60,0,'0.0000','605.0000',0,1),(67,60,1,'0.0000','605.0000',0,1),(67,60,2,'0.0000','605.0000',0,1),(67,60,3,'0.0000','605.0000',0,1),(68,60,0,'0.0000','1810.0000',0,1),(68,60,1,'0.0000','1810.0000',0,1),(68,60,2,'0.0000','1810.0000',0,1),(68,60,3,'0.0000','1810.0000',0,1),(69,60,0,'0.0000','1670.0000',0,1),(69,60,1,'0.0000','1670.0000',0,1),(69,60,2,'0.0000','1670.0000',0,1),(69,60,3,'0.0000','1670.0000',0,1),(70,60,0,'0.0000','1900.0000',0,1),(70,60,1,'0.0000','1900.0000',0,1),(70,60,2,'0.0000','1900.0000',0,1),(70,60,3,'0.0000','1900.0000',0,1),(71,60,0,'0.0000','1210.0000',0,1),(71,60,1,'0.0000','1210.0000',0,1),(71,60,2,'0.0000','1210.0000',0,1),(71,60,3,'0.0000','1210.0000',0,1),(72,60,0,'0.0000','1280.0000',0,1),(72,60,1,'0.0000','1280.0000',0,1),(72,60,2,'0.0000','1280.0000',0,1),(72,60,3,'0.0000','1280.0000',0,1),(73,60,0,'0.0000','1260.0000',0,1),(73,60,1,'0.0000','1260.0000',0,1),(73,60,2,'0.0000','1260.0000',0,1),(73,60,3,'0.0000','1260.0000',0,1),(74,60,0,'0.0000','1430.0000',0,1),(74,60,1,'0.0000','1430.0000',0,1),(74,60,2,'0.0000','1430.0000',0,1),(74,60,3,'0.0000','1430.0000',0,1),(75,60,0,'0.0000','1340.0000',0,1),(75,60,1,'0.0000','1340.0000',0,1),(75,60,2,'0.0000','1340.0000',0,1),(75,60,3,'0.0000','1340.0000',0,1),(76,60,0,'0.0000','1425.0000',0,1),(76,60,1,'0.0000','1425.0000',0,1),(76,60,2,'0.0000','1425.0000',0,1),(76,60,3,'0.0000','1425.0000',0,1),(77,60,0,'0.0000','1725.0000',0,1),(77,60,1,'0.0000','1725.0000',0,1),(77,60,2,'0.0000','1725.0000',0,1),(77,60,3,'0.0000','1725.0000',0,1),(78,60,0,'0.0000','2300.0000',0,1),(78,60,1,'0.0000','2300.0000',0,1),(78,60,2,'0.0000','2300.0000',0,1),(78,60,3,'0.0000','2300.0000',0,1),(79,60,0,'0.0000','2155.0000',0,1),(79,60,1,'0.0000','2155.0000',0,1),(79,60,2,'0.0000','2155.0000',0,1),(79,60,3,'0.0000','2155.0000',0,1),(80,60,0,'0.0000','1620.0000',0,1),(80,60,1,'0.0000','1620.0000',0,1),(80,60,2,'0.0000','1620.0000',0,1),(80,60,3,'0.0000','1620.0000',0,1),(81,60,0,'0.0000','805.0000',0,1),(81,60,1,'0.0000','805.0000',0,1),(81,60,2,'0.0000','805.0000',0,1),(81,60,3,'0.0000','805.0000',0,1),(82,60,0,'0.0000','1840.0000',0,1),(82,60,1,'0.0000','1840.0000',0,1),(82,60,2,'0.0000','1840.0000',0,1),(82,60,3,'0.0000','1840.0000',0,1),(83,60,0,'0.0000','1650.0000',0,1),(83,60,1,'0.0000','1650.0000',0,1),(83,60,2,'0.0000','1650.0000',0,1),(83,60,3,'0.0000','1650.0000',0,1),(84,60,0,'0.0000','1100.0000',0,1),(84,60,1,'0.0000','1100.0000',0,1),(84,60,2,'0.0000','1100.0000',0,1),(84,60,3,'0.0000','1100.0000',0,1),(85,60,0,'0.0000','1620.0000',0,1),(85,60,1,'0.0000','1620.0000',0,1),(85,60,2,'0.0000','1620.0000',0,1),(85,60,3,'0.0000','1620.0000',0,1),(86,60,0,'0.0000','690.0000',0,1),(86,60,1,'0.0000','690.0000',0,1),(86,60,2,'0.0000','690.0000',0,1),(86,60,3,'0.0000','690.0000',0,1),(87,60,0,'0.0000','1750.0000',0,1),(87,60,1,'0.0000','1750.0000',0,1),(87,60,2,'0.0000','1750.0000',0,1),(87,60,3,'0.0000','1750.0000',0,1),(88,60,0,'0.0000','2125.0000',0,1),(88,60,1,'0.0000','2125.0000',0,1),(88,60,2,'0.0000','2125.0000',0,1),(88,60,3,'0.0000','2125.0000',0,1),(89,60,0,'0.0000','1250.0000',0,1),(89,60,1,'0.0000','1250.0000',0,1),(89,60,2,'0.0000','1250.0000',0,1),(89,60,3,'0.0000','1250.0000',0,1),(90,60,0,'0.0000','550.0000',0,1),(90,60,1,'0.0000','550.0000',0,1),(90,60,2,'0.0000','550.0000',0,1),(90,60,3,'0.0000','550.0000',0,1),(91,60,0,'0.0000','2500.0000',0,1),(91,60,1,'0.0000','2500.0000',0,1),(91,60,2,'0.0000','2500.0000',0,1),(91,60,3,'0.0000','2500.0000',0,1),(92,60,0,'0.0000','800.0000',0,1),(92,60,1,'0.0000','800.0000',0,1),(92,60,2,'0.0000','800.0000',0,1),(92,60,3,'0.0000','800.0000',0,1),(93,60,0,'0.0000','1400.0000',0,1),(93,60,1,'0.0000','1400.0000',0,1),(93,60,2,'0.0000','1400.0000',0,1),(93,60,3,'0.0000','1400.0000',0,1),(94,60,0,'0.0000','550.0000',0,1),(94,60,1,'0.0000','550.0000',0,1),(94,60,2,'0.0000','550.0000',0,1),(94,60,3,'0.0000','550.0000',0,1),(95,60,0,'0.0000','550.0000',0,1),(95,60,1,'0.0000','550.0000',0,1),(95,60,2,'0.0000','550.0000',0,1),(95,60,3,'0.0000','550.0000',0,1),(96,60,0,'0.0000','550.0000',0,1),(96,60,1,'0.0000','550.0000',0,1),(96,60,2,'0.0000','550.0000',0,1),(96,60,3,'0.0000','550.0000',0,1),(97,60,0,'0.0000','550.0000',0,1),(97,60,1,'0.0000','550.0000',0,1),(97,60,2,'0.0000','550.0000',0,1),(97,60,3,'0.0000','550.0000',0,1),(98,60,0,'0.0000','550.0000',0,1),(98,60,1,'0.0000','550.0000',0,1),(98,60,2,'0.0000','550.0000',0,1),(98,60,3,'0.0000','550.0000',0,1),(99,60,0,'0.0000','550.0000',0,1),(99,60,1,'0.0000','550.0000',0,1),(99,60,2,'0.0000','550.0000',0,1),(99,60,3,'0.0000','550.0000',0,1),(100,60,0,'0.0000','550.0000',0,1),(100,60,1,'0.0000','550.0000',0,1),(100,60,2,'0.0000','550.0000',0,1),(100,60,3,'0.0000','550.0000',0,1);
/*!40000 ALTER TABLE `catalogindex_price` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cataloginventory_stock`
--

DROP TABLE IF EXISTS `cataloginventory_stock`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cataloginventory_stock` (
  `stock_id` smallint(4) unsigned NOT NULL AUTO_INCREMENT,
  `stock_name` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`stock_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='Catalog inventory Stocks list';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cataloginventory_stock`
--

LOCK TABLES `cataloginventory_stock` WRITE;
/*!40000 ALTER TABLE `cataloginventory_stock` DISABLE KEYS */;
INSERT INTO `cataloginventory_stock` VALUES (1,'Default');
/*!40000 ALTER TABLE `cataloginventory_stock` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cataloginventory_stock_item`
--

DROP TABLE IF EXISTS `cataloginventory_stock_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cataloginventory_stock_item` (
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
  KEY `FK_CATALOGINVENTORY_STOCK_ITEM_STOCK` (`stock_id`),
  CONSTRAINT `FK_CATALOGINVENTORY_STOCK_ITEM_PRODUCT` FOREIGN KEY (`product_id`) REFERENCES `catalog_product_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CATALOGINVENTORY_STOCK_ITEM_STOCK` FOREIGN KEY (`stock_id`) REFERENCES `cataloginventory_stock` (`stock_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=102 DEFAULT CHARSET=utf8 COMMENT='Inventory Stock Item Data';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cataloginventory_stock_item`
--

LOCK TABLES `cataloginventory_stock_item` WRITE;
/*!40000 ALTER TABLE `cataloginventory_stock_item` DISABLE KEYS */;
INSERT INTO `cataloginventory_stock_item` VALUES (2,1,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,1,NULL,NULL,1,0,1,0),(3,2,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,0,NULL,NULL,1,0,1,0),(4,3,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,0,NULL,NULL,1,0,1,0),(5,4,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,0,NULL,NULL,1,0,1,0),(6,5,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,0,NULL,NULL,1,0,1,0),(7,6,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,0,NULL,NULL,1,0,1,0),(8,7,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,1,NULL,NULL,1,0,1,0),(9,8,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,0,NULL,NULL,1,0,1,0),(10,9,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,0,NULL,NULL,1,0,1,0),(11,10,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,1,NULL,NULL,1,0,1,0),(12,11,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,0,NULL,NULL,1,0,1,0),(13,12,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,1,NULL,NULL,1,0,1,0),(14,13,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,0,NULL,NULL,1,0,1,0),(15,14,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,0,NULL,NULL,1,0,1,0),(16,15,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,1,NULL,NULL,1,0,1,0),(17,16,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,0,NULL,NULL,1,0,1,0),(18,17,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,0,NULL,NULL,1,0,1,0),(19,18,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,0,NULL,NULL,1,0,1,0),(20,19,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,0,NULL,NULL,1,0,1,0),(21,20,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,0,NULL,NULL,1,0,1,0),(22,21,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,0,NULL,NULL,1,0,1,0),(23,22,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,0,NULL,NULL,1,0,1,0),(24,23,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,1,NULL,NULL,1,0,1,0),(25,24,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,1,NULL,NULL,1,0,1,0),(26,25,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,0,NULL,NULL,1,0,1,0),(27,26,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,0,NULL,NULL,1,0,1,0),(28,27,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,0,NULL,NULL,1,0,1,0),(29,28,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,1,NULL,NULL,1,0,1,0),(30,29,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,1,NULL,NULL,1,0,1,0),(31,30,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,0,NULL,NULL,1,0,1,0),(32,31,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,0,NULL,NULL,1,0,1,0),(33,32,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,1,NULL,NULL,1,0,1,0),(34,33,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,0,NULL,NULL,1,0,1,0),(35,34,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,0,NULL,NULL,1,0,1,0),(36,35,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,1,NULL,NULL,1,0,1,0),(37,36,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,1,NULL,NULL,1,0,1,0),(38,37,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,0,NULL,NULL,1,0,1,0),(39,38,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,0,NULL,NULL,1,0,1,0),(40,39,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,0,NULL,NULL,1,0,1,0),(41,40,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,0,NULL,NULL,1,0,1,0),(42,41,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,0,NULL,NULL,1,0,1,0),(43,42,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,0,NULL,NULL,1,0,1,0),(44,43,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,0,NULL,NULL,1,0,1,0),(45,44,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,0,NULL,NULL,1,0,1,0),(46,45,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,0,NULL,NULL,1,0,1,0),(47,46,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,1,NULL,NULL,1,0,1,0),(48,47,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,0,NULL,NULL,1,0,1,0),(49,48,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,0,NULL,NULL,1,0,1,0),(50,49,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,1,NULL,NULL,1,0,1,0),(51,50,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,1,NULL,NULL,1,0,1,0),(52,51,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,0,NULL,NULL,1,0,1,0),(53,52,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,0,NULL,NULL,1,0,1,0),(54,53,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,0,NULL,NULL,1,0,1,0),(55,54,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,0,NULL,NULL,1,0,1,0),(56,55,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,0,NULL,NULL,1,0,1,0),(57,56,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,0,NULL,NULL,1,0,1,0),(58,57,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,0,NULL,NULL,1,0,1,0),(59,58,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,0,NULL,NULL,1,0,1,0),(60,59,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,0,NULL,NULL,1,0,1,0),(61,60,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,0,NULL,NULL,1,0,1,0),(62,61,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,1,NULL,NULL,1,0,1,0),(63,62,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,0,NULL,NULL,1,0,1,0),(64,63,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,0,NULL,NULL,1,0,1,0),(65,64,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,0,NULL,NULL,1,0,1,0),(66,65,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,0,NULL,NULL,1,0,1,0),(67,66,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,1,NULL,NULL,1,0,1,0),(68,67,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,1,NULL,NULL,1,0,1,0),(69,68,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,1,NULL,NULL,1,0,1,0),(70,69,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,1,NULL,NULL,1,0,1,0),(71,70,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,1,NULL,NULL,1,0,1,0),(72,71,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,1,NULL,NULL,1,0,1,0),(73,72,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,1,NULL,NULL,1,0,1,0),(74,73,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,1,NULL,NULL,1,0,1,0),(75,74,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,1,NULL,NULL,1,0,1,0),(76,75,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,0,NULL,NULL,1,0,1,0),(77,76,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,1,NULL,NULL,1,0,1,0),(78,77,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,1,NULL,NULL,1,0,1,0),(79,78,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,0,NULL,NULL,1,0,1,0),(80,79,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,1,NULL,NULL,1,0,1,0),(81,80,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,1,NULL,NULL,1,0,1,0),(82,81,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,1,NULL,NULL,1,0,1,0),(83,82,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,0,NULL,NULL,1,0,1,0),(84,83,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,1,NULL,NULL,1,0,1,0),(85,84,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,1,NULL,NULL,1,0,1,0),(86,85,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,0,NULL,NULL,1,0,1,0),(87,86,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,1,NULL,NULL,1,0,1,0),(88,87,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,1,NULL,NULL,1,0,1,0),(89,88,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,1,NULL,NULL,1,0,1,0),(90,89,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,1,NULL,NULL,1,0,1,0),(91,90,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,1,NULL,NULL,1,0,1,0),(92,91,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,0,NULL,NULL,1,0,1,0),(93,92,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,0,NULL,NULL,1,0,1,0),(94,93,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,0,NULL,NULL,1,0,1,0),(95,94,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,0,NULL,NULL,1,0,1,0),(96,95,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,0,NULL,NULL,1,0,1,0),(97,96,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,0,NULL,NULL,1,0,1,0),(98,97,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,0,NULL,NULL,1,0,1,0),(99,98,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,0,NULL,NULL,1,0,1,0),(100,99,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,0,NULL,NULL,1,0,1,0),(101,100,1,'0.0000','0.0000',1,0,0,0,'1.0000',1,'0.0000',1,0,NULL,NULL,1,0,1,0);
/*!40000 ALTER TABLE `cataloginventory_stock_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cataloginventory_stock_status`
--

DROP TABLE IF EXISTS `cataloginventory_stock_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cataloginventory_stock_status` (
  `product_id` int(10) unsigned NOT NULL,
  `website_id` smallint(5) unsigned NOT NULL,
  `stock_id` smallint(4) unsigned NOT NULL,
  `qty` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `stock_status` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`product_id`,`website_id`,`stock_id`),
  KEY `FK_CATALOGINVENTORY_STOCK_STATUS_STOCK` (`stock_id`),
  KEY `FK_CATALOGINVENTORY_STOCK_STATUS_WEBSITE` (`website_id`),
  CONSTRAINT `FK_CATALOGINVENTORY_STOCK_STATUS_STOCK` FOREIGN KEY (`stock_id`) REFERENCES `cataloginventory_stock` (`stock_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CATALOGINVENTORY_STOCK_STATUS_PRODUCT` FOREIGN KEY (`product_id`) REFERENCES `catalog_product_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CATALOGINVENTORY_STOCK_STATUS_WEBSITE` FOREIGN KEY (`website_id`) REFERENCES `core_website` (`website_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cataloginventory_stock_status`
--

LOCK TABLES `cataloginventory_stock_status` WRITE;
/*!40000 ALTER TABLE `cataloginventory_stock_status` DISABLE KEYS */;
INSERT INTO `cataloginventory_stock_status` VALUES (1,1,1,'0.0000',1),(2,1,1,'0.0000',1),(3,1,1,'0.0000',1),(4,1,1,'0.0000',1),(5,1,1,'0.0000',1),(6,1,1,'0.0000',1),(7,1,1,'0.0000',1),(8,1,1,'0.0000',1),(9,1,1,'0.0000',1),(10,1,1,'0.0000',1),(11,1,1,'0.0000',1),(12,1,1,'0.0000',1),(13,1,1,'0.0000',1),(14,1,1,'0.0000',1),(15,1,1,'0.0000',1),(16,1,1,'0.0000',1),(17,1,1,'0.0000',1),(18,1,1,'0.0000',1),(19,1,1,'0.0000',1),(20,1,1,'0.0000',1),(21,1,1,'0.0000',1),(22,1,1,'0.0000',1),(23,1,1,'0.0000',1),(24,1,1,'0.0000',1),(25,1,1,'0.0000',1),(26,1,1,'0.0000',1),(27,1,1,'0.0000',1),(28,1,1,'0.0000',1),(29,1,1,'0.0000',1),(30,1,1,'0.0000',1),(31,1,1,'0.0000',1),(32,1,1,'0.0000',1),(33,1,1,'0.0000',1),(34,1,1,'0.0000',1),(35,1,1,'0.0000',1),(36,1,1,'0.0000',1),(37,1,1,'0.0000',1),(38,1,1,'0.0000',1),(39,1,1,'0.0000',1),(40,1,1,'0.0000',1),(41,1,1,'0.0000',1),(42,1,1,'0.0000',1),(43,1,1,'0.0000',1),(44,1,1,'0.0000',1),(45,1,1,'0.0000',1),(46,1,1,'0.0000',1),(47,1,1,'0.0000',1),(48,1,1,'0.0000',1),(49,1,1,'0.0000',1),(50,1,1,'0.0000',1),(51,1,1,'0.0000',1),(52,1,1,'0.0000',1),(53,1,1,'0.0000',1),(54,1,1,'0.0000',1),(55,1,1,'0.0000',1),(56,1,1,'0.0000',1),(57,1,1,'0.0000',1),(58,1,1,'0.0000',1),(59,1,1,'0.0000',1),(60,1,1,'0.0000',1),(61,1,1,'0.0000',1),(62,1,1,'0.0000',1),(63,1,1,'0.0000',1),(64,1,1,'0.0000',1),(65,1,1,'0.0000',1),(66,1,1,'0.0000',1),(67,1,1,'0.0000',1),(68,1,1,'0.0000',1),(69,1,1,'0.0000',1),(70,1,1,'0.0000',1),(71,1,1,'0.0000',1),(72,1,1,'0.0000',1),(73,1,1,'0.0000',1),(74,1,1,'0.0000',1),(75,1,1,'0.0000',1),(76,1,1,'0.0000',1),(77,1,1,'0.0000',1),(78,1,1,'0.0000',1),(79,1,1,'0.0000',1),(80,1,1,'0.0000',1),(81,1,1,'0.0000',1),(82,1,1,'0.0000',1),(83,1,1,'0.0000',1),(84,1,1,'0.0000',1),(85,1,1,'0.0000',1),(86,1,1,'0.0000',1),(87,1,1,'0.0000',1),(88,1,1,'0.0000',1),(89,1,1,'0.0000',1),(90,1,1,'0.0000',1),(91,1,1,'0.0000',1),(92,1,1,'0.0000',1),(93,1,1,'0.0000',1),(94,1,1,'0.0000',1),(95,1,1,'0.0000',1),(96,1,1,'0.0000',1),(97,1,1,'0.0000',1),(98,1,1,'0.0000',1),(99,1,1,'0.0000',1),(100,1,1,'0.0000',1);
/*!40000 ALTER TABLE `cataloginventory_stock_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalogrule`
--

DROP TABLE IF EXISTS `catalogrule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalogrule` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalogrule`
--

LOCK TABLES `catalogrule` WRITE;
/*!40000 ALTER TABLE `catalogrule` DISABLE KEYS */;
/*!40000 ALTER TABLE `catalogrule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalogrule_affected_product`
--

DROP TABLE IF EXISTS `catalogrule_affected_product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalogrule_affected_product` (
  `product_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalogrule_affected_product`
--

LOCK TABLES `catalogrule_affected_product` WRITE;
/*!40000 ALTER TABLE `catalogrule_affected_product` DISABLE KEYS */;
/*!40000 ALTER TABLE `catalogrule_affected_product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalogrule_product`
--

DROP TABLE IF EXISTS `catalogrule_product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalogrule_product` (
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
  KEY `FK_CATALOGRULE_PRODUCT_PRODUCT` (`product_id`),
  CONSTRAINT `FK_CATALOGRULE_PRODUCT_PRODUCT` FOREIGN KEY (`product_id`) REFERENCES `catalog_product_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_catalogrule_product_customergroup` FOREIGN KEY (`customer_group_id`) REFERENCES `customer_group` (`customer_group_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_catalogrule_product_rule` FOREIGN KEY (`rule_id`) REFERENCES `catalogrule` (`rule_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_catalogrule_product_website` FOREIGN KEY (`website_id`) REFERENCES `core_website` (`website_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalogrule_product`
--

LOCK TABLES `catalogrule_product` WRITE;
/*!40000 ALTER TABLE `catalogrule_product` DISABLE KEYS */;
/*!40000 ALTER TABLE `catalogrule_product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalogrule_product_price`
--

DROP TABLE IF EXISTS `catalogrule_product_price`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalogrule_product_price` (
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
  KEY `FK_CATALOGRULE_PRODUCT_PRICE_PRODUCT` (`product_id`),
  CONSTRAINT `FK_CATALOGRULE_PRODUCT_PRICE_PRODUCT` FOREIGN KEY (`product_id`) REFERENCES `catalog_product_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_catalogrule_product_price_customergroup` FOREIGN KEY (`customer_group_id`) REFERENCES `customer_group` (`customer_group_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_catalogrule_product_price_website` FOREIGN KEY (`website_id`) REFERENCES `core_website` (`website_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalogrule_product_price`
--

LOCK TABLES `catalogrule_product_price` WRITE;
/*!40000 ALTER TABLE `catalogrule_product_price` DISABLE KEYS */;
/*!40000 ALTER TABLE `catalogrule_product_price` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalogsearch_fulltext`
--

DROP TABLE IF EXISTS `catalogsearch_fulltext`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalogsearch_fulltext` (
  `product_id` int(10) unsigned NOT NULL,
  `store_id` smallint(5) unsigned NOT NULL,
  `data_index` longtext NOT NULL,
  PRIMARY KEY (`product_id`,`store_id`),
  FULLTEXT KEY `data_index` (`data_index`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalogsearch_fulltext`
--

LOCK TABLES `catalogsearch_fulltext` WRITE;
/*!40000 ALTER TABLE `catalogsearch_fulltext` DISABLE KEYS */;
/*!40000 ALTER TABLE `catalogsearch_fulltext` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalogsearch_query`
--

DROP TABLE IF EXISTS `catalogsearch_query`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalogsearch_query` (
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
  KEY `IDX_SEARCH_QUERY` (`query_text`,`store_id`,`popularity`),
  CONSTRAINT `FK_CATALOGSEARCH_QUERY_STORE` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalogsearch_query`
--

LOCK TABLES `catalogsearch_query` WRITE;
/*!40000 ALTER TABLE `catalogsearch_query` DISABLE KEYS */;
/*!40000 ALTER TABLE `catalogsearch_query` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalogsearch_result`
--

DROP TABLE IF EXISTS `catalogsearch_result`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalogsearch_result` (
  `query_id` int(10) unsigned NOT NULL,
  `product_id` int(10) unsigned NOT NULL,
  `relevance` decimal(6,4) NOT NULL DEFAULT '0.0000',
  PRIMARY KEY (`query_id`,`product_id`),
  KEY `IDX_QUERY` (`query_id`),
  KEY `IDX_PRODUCT` (`product_id`),
  KEY `IDX_RELEVANCE` (`query_id`,`relevance`),
  CONSTRAINT `FK_CATALOGSEARCH_RESULT_QUERY` FOREIGN KEY (`query_id`) REFERENCES `catalogsearch_query` (`query_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CATALOGSEARCH_RESULT_CATALOG_PRODUCT` FOREIGN KEY (`product_id`) REFERENCES `catalog_product_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalogsearch_result`
--

LOCK TABLES `catalogsearch_result` WRITE;
/*!40000 ALTER TABLE `catalogsearch_result` DISABLE KEYS */;
/*!40000 ALTER TABLE `catalogsearch_result` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `checkout_agreement`
--

DROP TABLE IF EXISTS `checkout_agreement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `checkout_agreement` (
  `agreement_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `content` text NOT NULL,
  `content_height` varchar(25) DEFAULT NULL,
  `checkbox_text` text NOT NULL,
  `is_active` tinyint(4) NOT NULL DEFAULT '0',
  `is_html` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`agreement_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `checkout_agreement`
--

LOCK TABLES `checkout_agreement` WRITE;
/*!40000 ALTER TABLE `checkout_agreement` DISABLE KEYS */;
/*!40000 ALTER TABLE `checkout_agreement` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `checkout_agreement_store`
--

DROP TABLE IF EXISTS `checkout_agreement_store`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `checkout_agreement_store` (
  `agreement_id` int(10) unsigned NOT NULL,
  `store_id` smallint(5) unsigned NOT NULL,
  UNIQUE KEY `agreement_id` (`agreement_id`,`store_id`),
  KEY `FK_CHECKOUT_AGREEMENT_STORE` (`store_id`),
  CONSTRAINT `FK_CHECKOUT_AGREEMENT` FOREIGN KEY (`agreement_id`) REFERENCES `checkout_agreement` (`agreement_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CHECKOUT_AGREEMENT_STORE` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `checkout_agreement_store`
--

LOCK TABLES `checkout_agreement_store` WRITE;
/*!40000 ALTER TABLE `checkout_agreement_store` DISABLE KEYS */;
/*!40000 ALTER TABLE `checkout_agreement_store` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_block`
--

DROP TABLE IF EXISTS `cms_block`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_block` (
  `block_id` smallint(6) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL DEFAULT '',
  `identifier` varchar(255) NOT NULL DEFAULT '',
  `content` text,
  `creation_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`block_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COMMENT='CMS Blocks';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_block`
--

LOCK TABLES `cms_block` WRITE;
/*!40000 ALTER TABLE `cms_block` DISABLE KEYS */;
INSERT INTO `cms_block` VALUES (5,'Footer Links','footer_links','<ul>\r\n<li><a href=\"{{store url=\"\"}}about-ekkitab\">About Us</a></li>\r\n<li class=\"last\"><a href=\"{{store url=\"\"}}customer-service\">Customer Service</a></li>\r\n</ul>','2009-10-15 15:05:20','2009-10-15 15:05:20',1);
/*!40000 ALTER TABLE `cms_block` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_block_store`
--

DROP TABLE IF EXISTS `cms_block_store`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_block_store` (
  `block_id` smallint(6) NOT NULL,
  `store_id` smallint(5) unsigned NOT NULL,
  PRIMARY KEY (`block_id`,`store_id`),
  KEY `FK_CMS_BLOCK_STORE_STORE` (`store_id`),
  CONSTRAINT `FK_CMS_BLOCK_STORE_BLOCK` FOREIGN KEY (`block_id`) REFERENCES `cms_block` (`block_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CMS_BLOCK_STORE_STORE` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='CMS Blocks to Stores';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_block_store`
--

LOCK TABLES `cms_block_store` WRITE;
/*!40000 ALTER TABLE `cms_block_store` DISABLE KEYS */;
INSERT INTO `cms_block_store` VALUES (5,0);
/*!40000 ALTER TABLE `cms_block_store` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_page`
--

DROP TABLE IF EXISTS `cms_page`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_page` (
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COMMENT='CMS pages';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_page`
--

LOCK TABLES `cms_page` WRITE;
/*!40000 ALTER TABLE `cms_page` DISABLE KEYS */;
INSERT INTO `cms_page` VALUES (1,'404 Not Found 1','two_columns_right','Page keywords','Page description','no-route','<div class=\"page-head-alt\"><h3>Our apologies... </h3></div>\r\n<dl>\r\n<dt>The page you requested was not found.</dt>\r\n<dd>\r\n<ul class=\"disc\">\r\n<li>If you typed the URL directly, please make sure the spelling is correct.</li>\r\n<li>If you clicked on a link to get here, the link is outdated.</li>\r\n</ul></dd>\r\n</dl>\r\n<br/>\r\n<dl>\r\n<dt>What can you do?</dt>\r\n<dd>Please contact Customer Care at ccare@ekkitab.com and let us know of this problem. We appreciate your help in ensuring that the service is always available and runs error free.</dd>\r\n<dd>\r\n<ul class=\"disc\">\r\n<li><a href=\"#\" onclick=\"history.go(-1);\">Go back</a> to the previous page.</li>\r\n<li>Use the search bar at the top of the page to search the site.</li>\r\n<li>Follow these links to get you back on track!<br/><a href=\"{{store url=\"\"}}\">Store Home</a><br/><a href=\"{{store url=\"customer/account\"}}\">My Account</a></li></ul></dd></dl><br/>','2007-06-20 18:38:32','2007-08-26 19:11:13',1,0,NULL,NULL,NULL,NULL),(2,'Home page','three_columns','','','home','<div class=\"topRow\">\r\n		<div class=\"textArea\">\r\n			<div class=\"mainHdr\">Enabling a billion readers</div>\r\n			Some text explaining the \"Donate a book\" concept will come here. How to find whether your institution / school / college / club whatever is listed. The various \"donations\" one can do - books, discount amounts, Gift Certificates etc. You\'ve come to the right place! The various \"donations\" one can do - books, discount amounts, Gift Certificates etc.\r\n			<div class=\"readMore\"><a href=\"#\">Read more &raquo;</a></div><!-- raedMore -->\r\n		</div><!-- textArea -->\r\n      </div><!-- topRow -->\r\n\r\n       {{block type=\"ekkitab_catalog/product_bestsellers\" name=\"bestsellers\"  template=\"catalog/product/bestsellers.phtml\" }}\r\n        {{block type=\"ekkitab_catalog/product_newreleases\" name=\"newreleases\"  template=\"catalog/product/newreleases.phtml\" }}\r\n        {{block type=\"ekkitab_catalog/product_bestboxedsets\" name=\"best.boxed.sets\"  template=\"catalog/product/bestboxedsets.phtml\" }}\r\n\r\n	<div class=\"hmMainRows\">\r\n		<div class=\"mainLeftHdr\">The ekkitab exclusive collections</div>\r\n		<img src=\"{{skin url=\'images/hm_collections.jpg\'}}\" width=\"215\" height=\"120\" id=\"collImage\" />\r\n		<div class=\"collText\">For the past 10 years, NYRB Classics has resurrected lost classics, cult favorites, and canonical masters with an impeccable and eclectic eye for great literature. Now, for the first time, we are offering an exclusive, complete set of 250 NYRB Classics, the NYRB 10th Anniversary Complete Classics Collection, the perfect gift for the reader in your life who is hungry for a shelf full of literary discoveries. <div class=\"collLink\"><a href=\"#\">Read more about ekkitab Collections</a></div>\r\n		</div>\r\n		<div class=\"clear\"></div>\r\n	</div><!-- hmMainRows -->\r\n\r\n	<div class=\"hmMainRows\">\r\n		<div class=\"mainLeftHdr\">Gift Ideas for Book Lovers</div>\r\n		<img src=\"{{skin url=\'images/hm_sm_bks.jpg\'}}\" width=\"75\" height=\"75\" id=\"giftImage\" />\r\n		<div class=\"giftText\">Find the best deals on this season\'s newest releases, blockbusters, cookbooks, festive reads, and more terrific book gifts in dozens of categories. Find the best deals on this season\'s newest releases, blockbusters, cookbooks, festive reads, and more terrific book gifts in dozens of categories. <div class=\"collLink\"><a href=\"#\">See more Gift Ideas</a></div>\r\n		</div>\r\n		<div class=\"clear\"></div>\r\n	</div><!-- hmMainRows -->\r\n      \r\n\r\n              <div class=\"hmMainRows\">\r\n		<div class=\"mainLeftHdr\">Specials for the Holiday Season</div>\r\n		Catch up on the complicated paranormal love triangle of Bella, Edward, and Jacob in New Moon, the second book in Stephenie Meyer\'s bestselling Twilight saga, and the inspiration behind the big-screen adaptation. Sink your teeth \"or claws\" into these new Twilight titles:\r\n		<div class=\"vColumns\">\r\n			<img src=\"{{skin url=\'images/hmbk1.jpg\'}}\" width=\"89\" height=\"135\" />\r\n			<div class=\"titleEtc\">\r\n				<div class=\"bkTitle\"><a href=\"#\">Superfreakonomics</a></div><!-- bkTitle -->\r\n				<div class=\"authorEtc\">Steven D. Levitt</div>\r\n				<div class=\"authorEtc\">Our Price: Rs. 340</div>\r\n				<div class=\"youSave\">Save 19% off</div>\r\n			</div><!-- titleEtc -->\r\n		</div>\r\n		<div class=\"vMidColumn\">\r\n			<img src=\"{{skin url=\'images/hmbk2.jpg\'}}\" width=\"91\" height=\"135\" />\r\n			<div class=\"titleEtc\">\r\n			<div class=\"bkTitle\"><a href=\"#\">Superfreakonomics</a></div><!-- bkTitle -->\r\n			<div class=\"authorEtc\">Steven D. Levitt</div>\r\n			<div class=\"authorEtc\">Our Price: Rs. 340</div>\r\n			<div class=\"youSave\">Save 19% off</div>\r\n			</div><!-- titleEtc -->\r\n		</div>\r\n		<div class=\"vColumns\">\r\n			<img src=\"{{skin url=\'images/hmbk3.jpg\'}}\" width=\"89\" height=\"135\" />\r\n			<div class=\"titleEtc\">\r\n			<div class=\"bkTitle\"><a href=\"#\">Superfreakonomics</a></div><!-- bkTitle -->\r\n			<div class=\"authorEtc\">Steven D. Levitt</div>\r\n			<div class=\"authorEtc\">Our Price: Rs. 340</div>\r\n			<div class=\"youSave\">Save 19% off</div>\r\n			</div><!-- titleEtc -->\r\n		</div>\r\n		<div class=\"clear\"></div>\r\n	</div><!-- hmMainRows -->\r\n\r\n','0000-00-00 00:00:00','0000-00-00 00:00:00',1,0,NULL,NULL,NULL,NULL),(3,'About  Us','one_column','','','about-ekkitab','<br class=\"clear\"/><div class=\"col3-set\"><div class=\"col-1\"><p><img src=\"{{skin url=\'images/logo_aboutus.png\'}}\" alt=\"Ekkitab Logo\"/></p><p style=\"line-height:1.2em;\"><small>Ekkitab Educational Services Pvt. Ltd. was founded in 2009 and is headquartered in Bangalore, India. </small></p><p style=\"color:#888; font:1.2em/1.4em georgia, serif;\">Ekkitab is founded on the desire to promote reading.  It is based on the belief that every child and adult in India should have access to good books irrespective of where they live and their level in society.</p><p><strong>To achieve this objective, Ekkitab is putting up a globally accessible book store that carries English and all Indian language books.  The immediate goal is to make this on-line bookstore very successful by virtue of good design, easy access and comprehensive stocking.</strong></p></div><div class=\"col-2\"><p>Ekkitab will actively promote organizations that are centers of learning, like school, college, city, town and village libraries, by inviting its visitors to donate to these organizations. The company wishes to encourage readership by making good books available easily and by making community reading centers like city and town libraries active and popular by virtue of having good content.</p><p>Ekkitab wants to create the largest donor network in books in the country and thereby realize its vision of providing every Indian with access to good books. This donor network will be driven by goodwill, community and a sense of commitment to the cause that Ekkitab is working towards. We hope to solve the difficulties that exist today for people to share good books and promote reading.</p><p>In the process of achieving its vision, Ekkitab hopes to become the best known and best loved brand in bookshops, on-line or otherwise.  We hope to be able to take the bookstore and the concept of on-line buying to smaller towns and villages across the country.  Eventually, we hope to increase readership and the sheer size of the book business in India. We hope to be able to work with publishers and distributors in the country to help increase access to every book that is in print. This will help the publishing industry by extending their reach across the country and will help readers by decreasing the cost of books.</p></div><div class=\"col-3\"><p><strong>We hope to become an important channel for publishers to reach their customers and are willing to work with them to build new digital models of commerce that can provide conveniences that are not possible today. In making the business a success we hope to stimulate the donor network to give liberally to the cause of reading in India and to reduce the digital divide between the rich and the poor.</strong></p><p>We also hope that by doing so, we can remove the bane of piracy from the industry and ensure that the benefits of each sale reaches its rightful owners.  In the longer term, Ekkitab wants to promote good writers and provide a platform for publishers to promote new authors and their works.  In everything, we want to support and nourish the book eco-system in the country by scaling it manifold across the Indian population.</p><div class=\"divider\"></div><p>Thank you for your interest. </p><p>We hope that you have a pleasant experience at ekkitab.com and we count on your support of the cause. <br/><br/>You can reach us at: ccare@ekkitab.com. <br/><br/>We are located at: #82/83, Borewell Road, Whitefield Main, Bangalore - 560066.</p><p style=\"line-height:1.0em;\"><br/><small>Team Ekkitab</small></p></div></div>','2007-08-30 14:01:18','2007-08-30 14:01:18',1,0,NULL,NULL,NULL,NULL),(4,'Customer Service','three_columns','','','customer-service','<div class=\"page-head\">\r\n<h3>Customer Service</h3>\r\n</div>\r\n<ul class=\"disc\" style=\"margin-bottom:15px;\">\r\n<li><a href=\"#answer1\">Shipping & Delivery</a></li>\r\n<li><a href=\"#answer2\">Privacy & Security</a></li>\r\n<li><a href=\"#answer3\">Returns & Replacements</a></li>\r\n<li><a href=\"#answer4\">Ordering</a></li>\r\n<li><a href=\"#answer5\">Payment, Pricing & Promotions</a></li>\r\n<li><a href=\"#answer6\">Viewing Orders</a></li>\r\n<li><a href=\"#answer7\">Updating Account Information</a></li>\r\n</ul>\r\n<dl>\r\n<dt id=\"answer1\">Shipping & Delivery</dt>\r\n<dd style=\"margin-bottom:10px;\">To be updated.</dd>\r\n<dt id=\"answer2\">Privacy & Security</dt>\r\n<dd style=\"margin-bottom:10px;\"></dd>\r\n<dt id=\"answer3\">Returns & Replacements</dt>\r\n<dd style=\"margin-bottom:10px;\">To be updated</dd>\r\n<dt id=\"answer4\">Ordering</dt>\r\n<dd style=\"margin-bottom:10px;\">To be updated</dd>\r\n<dt id=\"answer5\">Payment, Pricing & Promotions</dt>\r\n<dd style=\"margin-bottom:10px;\">To be updated</dd>\r\n<dt id=\"answer6\">Viewing Orders</dt>\r\n<dd style=\"margin-bottom:10px;\">To be updated</dd>\r\n<dt id=\"answer7\">Updating Account Information</dt>\r\n<dd style=\"margin-bottom:10px;\">To be updated</dd>\r\n</dl>','2007-08-30 14:02:20','2007-08-30 14:03:37',1,0,NULL,NULL,NULL,NULL),(5,'Enable Cookies','one_column','','','enable-cookies','<div class=\"std\">\r\n    <ul class=\"messages\">\r\n        <li class=\"notice-msg\">\r\n            <ul>\r\n                <li>Please enable cookies in your web browser to continue.</li>\r\n            </ul>\r\n        </li>\r\n    </ul>\r\n    <div class=\"page-head\">\r\n        <h3><a name=\"top\"></a>What are Cookies?</h3>\r\n    </div>\r\n    <p>Cookies are short pieces of data that are sent to your computer when you visit a website. On later visits, this data is then returned to that website. Cookies allow us to recognize you automatically whenever you visit our site so that we can personalize your experience and provide you with better service. We also use cookies (and similar browser data, such as Flash cookies) for fraud prevention and other purposes. If your web browser is set to refuse cookies from our website, you will not be able to complete a purchase or take advantage of certain features of our website, such as storing items in your Shopping Cart or receiving personalized recommendations. As a result, we strongly encourage you to configure your web browser to accept cookies from our website.</p>\r\n    <h3>Enabling Cookies</h3>\r\n    <ul>\r\n        <li><a href=\"#ie7\">Internet Explorer 7.x</a></li>\r\n        <li><a href=\"#ie6\">Internet Explorer 6.x</a></li>\r\n        <li><a href=\"#firefox\">Mozilla/Firefox</a></li>\r\n        <li><a href=\"#opera\">Opera 7.x</a></li>\r\n    </ul>\r\n    <h4><a name=\"ie7\"></a>Internet Explorer 7.x</h4>\r\n    <ol>\r\n        <li>\r\n            <p>Start Internet Explorer</p>\r\n        </li>\r\n        <li>\r\n            <p>Under the <strong>Tools</strong> menu, click <strong>Internet Options</strong></p>\r\n            <p><img src=\"{{skin url=\"images/cookies/ie7-1.gif\"}}\" alt=\"\" /></p>\r\n        </li>\r\n        <li>\r\n            <p>Click the <strong>Privacy</strong> tab</p>\r\n            <p><img src=\"{{skin url=\"images/cookies/ie7-2.gif\"}}\" alt=\"\" /></p>\r\n        </li>\r\n        <li>\r\n            <p>Click the <strong>Advanced</strong> button</p>\r\n            <p><img src=\"{{skin url=\"images/cookies/ie7-3.gif\"}}\" alt=\"\" /></p>\r\n        </li>\r\n        <li>\r\n            <p>Put a check mark in the box for <strong>Override Automatic Cookie Handling</strong>, put another check mark in the <strong>Always accept session cookies </strong>box</p>\r\n            <p><img src=\"{{skin url=\"images/cookies/ie7-4.gif\"}}\" alt=\"\" /></p>\r\n        </li>\r\n        <li>\r\n            <p>Click <strong>OK</strong></p>\r\n            <p><img src=\"{{skin url=\"images/cookies/ie7-5.gif\"}}\" alt=\"\" /></p>\r\n        </li>\r\n        <li>\r\n            <p>Click <strong>OK</strong></p>\r\n            <p><img src=\"{{skin url=\"images/cookies/ie7-6.gif\"}}\" alt=\"\" /></p>\r\n        </li>\r\n        <li>\r\n            <p>Restart Internet Explore</p>\r\n        </li>\r\n    </ol>\r\n    <p class=\"a-top\"><a href=\"#top\">Back to Top</a></p>\r\n    <h4><a name=\"ie6\"></a>Internet Explorer 6.x</h4>\r\n    <ol>\r\n        <li>\r\n            <p>Select <strong>Internet Options</strong> from the Tools menu</p>\r\n            <p><img src=\"{{skin url=\"images/cookies/ie6-1.gif\"}}\" alt=\"\" /></p>\r\n        </li>\r\n        <li>\r\n            <p>Click on the <strong>Privacy</strong> tab</p>\r\n        </li>\r\n        <li>\r\n            <p>Click the <strong>Default</strong> button (or manually slide the bar down to <strong>Medium</strong>) under <strong>Settings</strong>. Click <strong>OK</strong></p>\r\n            <p><img src=\"{{skin url=\"images/cookies/ie6-2.gif\"}}\" alt=\"\" /></p>\r\n        </li>\r\n    </ol>\r\n    <p class=\"a-top\"><a href=\"#top\">Back to Top</a></p>\r\n    <h4><a name=\"firefox\"></a>Mozilla/Firefox</h4>\r\n    <ol>\r\n        <li>\r\n            <p>Click on the <strong>Tools</strong>-menu in Mozilla</p>\r\n        </li>\r\n        <li>\r\n            <p>Click on the <strong>Options...</strong> item in the menu - a new window open</p>\r\n        </li>\r\n        <li>\r\n            <p>Click on the <strong>Privacy</strong> selection in the left part of the window. (See image below)</p>\r\n            <p><img src=\"{{skin url=\"images/cookies/firefox.png\"}}\" alt=\"\" /></p>\r\n        </li>\r\n        <li>\r\n            <p>Expand the <strong>Cookies</strong> section</p>\r\n        </li>\r\n        <li>\r\n            <p>Check the <strong>Enable cookies</strong> and <strong>Accept cookies normally</strong> checkboxes</p>\r\n        </li>\r\n        <li>\r\n            <p>Save changes by clicking <strong>Ok</strong>.</p>\r\n        </li>\r\n    </ol>\r\n    <p class=\"a-top\"><a href=\"#top\">Back to Top</a></p>\r\n    <h4><a name=\"opera\"></a>Opera 7.x</h4>\r\n    <ol>\r\n        <li>\r\n            <p>Click on the <strong>Tools</strong> menu in Opera</p>\r\n        </li>\r\n        <li>\r\n            <p>Click on the <strong>Preferences...</strong> item in the menu - a new window open</p>\r\n        </li>\r\n        <li>\r\n            <p>Click on the <strong>Privacy</strong> selection near the bottom left of the window. (See image below)</p>\r\n            <p><img src=\"{{skin url=\"images/cookies/opera.png\"}}\" alt=\"\" /></p>\r\n        </li>\r\n        <li>\r\n            <p>The <strong>Enable cookies</strong> checkbox must be checked, and <strong>Accept all cookies</strong> should be selected in the &quot;<strong>Normal cookies</strong>&quot; drop-down</p>\r\n        </li>\r\n        <li>\r\n            <p>Save changes by clicking <strong>Ok</strong></p>\r\n        </li>\r\n    </ol>\r\n    <p class=\"a-top\"><a href=\"#top\">Back to Top</a></p>\r\n</div>\r\n','2009-10-15 09:35:23','2009-10-15 09:35:23',1,0,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `cms_page` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_page_store`
--

DROP TABLE IF EXISTS `cms_page_store`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_page_store` (
  `page_id` smallint(6) NOT NULL,
  `store_id` smallint(5) unsigned NOT NULL,
  PRIMARY KEY (`page_id`,`store_id`),
  KEY `FK_CMS_PAGE_STORE_STORE` (`store_id`),
  CONSTRAINT `FK_CMS_PAGE_STORE_PAGE` FOREIGN KEY (`page_id`) REFERENCES `cms_page` (`page_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CMS_PAGE_STORE_STORE` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='CMS Pages to Stores';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_page_store`
--

LOCK TABLES `cms_page_store` WRITE;
/*!40000 ALTER TABLE `cms_page_store` DISABLE KEYS */;
INSERT INTO `cms_page_store` VALUES (1,0),(2,0),(3,0),(4,0),(5,0);
/*!40000 ALTER TABLE `cms_page_store` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_config_data`
--

DROP TABLE IF EXISTS `core_config_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_config_data` (
  `config_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `scope` enum('default','websites','stores','config') NOT NULL DEFAULT 'default',
  `scope_id` int(11) NOT NULL DEFAULT '0',
  `path` varchar(255) NOT NULL DEFAULT 'general',
  `value` text NOT NULL,
  PRIMARY KEY (`config_id`),
  UNIQUE KEY `config_scope` (`scope`,`scope_id`,`path`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_config_data`
--

LOCK TABLES `core_config_data` WRITE;
/*!40000 ALTER TABLE `core_config_data` DISABLE KEYS */;
INSERT INTO `core_config_data` VALUES (15,'default',0,'payment/paypal_standard/active','1'),(16,'default',0,'payment/paypal_standard/title','Paypal Standard'),(17,'default',0,'payment/paypal_standard/payment_action','SALE'),(18,'default',0,'payment/paypal_standard/types','IPN'),(19,'default',0,'payment/paypal_standard/order_status','processing'),(20,'default',0,'payment/paypal_standard/transaction_type','O'),(21,'default',0,'payment/paypal_standard/allowspecific','0'),(22,'default',0,'payment/paypal_standard/sort_order',''),(23,'default',0,'paypal/wps/business_name','Ekkitab Educational Services Pvt Ltd'),(24,'default',0,'paypal/wps/logo_url',''),(25,'default',0,'paypal/wps/sandbox_flag','1'),(26,'default',0,'paypal/wps/debug_flag','1'),(27,'default',0,'dev/log/active','1'),(28,'default',0,'dev/log/file','system.log'),(29,'default',0,'dev/log/exception_file','exception.log'),(30,'default',0,'catalog/category/root_id','2'),(31,'default',0,'design/theme/default','ekkitab'),(32,'default',0,'currency/options/base','INR'),(33,'stores',1,'currency/options/default','INR'),(34,'stores',1,'currency/options/allow','EUR,INR,USD'),(35,'stores',1,'currency/options/trim_sign','0'),(36,'stores',1,'design/theme/default','ekkitab'),(37,'stores',1,'design/head/default_title','Ekkitab Education Services Pvt Ltd'),(38,'stores',1,'design/head/default_keywords','Ekkitab, online bookstore'),(39,'stores',1,'design/header/logo_src','images/logo.png'),(40,'stores',1,'design/header/logo_alt','Ekkitab Education Services Pvt Ltd'),(41,'stores',1,'design/header/welcome','Welcome Guest!'),(42,'stores',1,'design/footer/copyright','&copy; 2009 Ekkitab Educational Services Pvt Ltd. All Rights Reserved.');
/*!40000 ALTER TABLE `core_config_data` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_email_template`
--

DROP TABLE IF EXISTS `core_email_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_email_template` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Email templates';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_email_template`
--

LOCK TABLES `core_email_template` WRITE;
/*!40000 ALTER TABLE `core_email_template` DISABLE KEYS */;
/*!40000 ALTER TABLE `core_email_template` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_flag`
--

DROP TABLE IF EXISTS `core_flag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_flag` (
  `flag_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `flag_code` varchar(255) NOT NULL,
  `state` smallint(5) unsigned NOT NULL DEFAULT '0',
  `flag_data` text,
  `last_update` datetime NOT NULL,
  PRIMARY KEY (`flag_id`),
  KEY `last_update` (`last_update`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_flag`
--

LOCK TABLES `core_flag` WRITE;
/*!40000 ALTER TABLE `core_flag` DISABLE KEYS */;
INSERT INTO `core_flag` VALUES (1,'catalog_product_flat',0,'a:1:{s:8:\"is_built\";b:0;}','2009-10-15 09:34:05');
/*!40000 ALTER TABLE `core_flag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_layout_link`
--

DROP TABLE IF EXISTS `core_layout_link`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_layout_link` (
  `layout_link_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `package` varchar(64) NOT NULL DEFAULT '',
  `theme` varchar(64) NOT NULL DEFAULT '',
  `layout_update_id` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`layout_link_id`),
  UNIQUE KEY `store_id` (`store_id`,`package`,`theme`,`layout_update_id`),
  KEY `FK_core_layout_link_update` (`layout_update_id`),
  CONSTRAINT `FK_CORE_LAYOUT_LINK_STORE` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CORE_LAYOUT_LINK_UPDATE` FOREIGN KEY (`layout_update_id`) REFERENCES `core_layout_update` (`layout_update_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_layout_link`
--

LOCK TABLES `core_layout_link` WRITE;
/*!40000 ALTER TABLE `core_layout_link` DISABLE KEYS */;
/*!40000 ALTER TABLE `core_layout_link` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_layout_update`
--

DROP TABLE IF EXISTS `core_layout_update`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_layout_update` (
  `layout_update_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `handle` varchar(255) DEFAULT NULL,
  `xml` text,
  PRIMARY KEY (`layout_update_id`),
  KEY `handle` (`handle`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_layout_update`
--

LOCK TABLES `core_layout_update` WRITE;
/*!40000 ALTER TABLE `core_layout_update` DISABLE KEYS */;
/*!40000 ALTER TABLE `core_layout_update` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_resource`
--

DROP TABLE IF EXISTS `core_resource`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_resource` (
  `code` varchar(50) NOT NULL DEFAULT '',
  `version` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Resource version registry';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_resource`
--

LOCK TABLES `core_resource` WRITE;
/*!40000 ALTER TABLE `core_resource` DISABLE KEYS */;
INSERT INTO `core_resource` VALUES ('adminnotification_setup','1.0.0'),('admin_setup','0.7.1'),('amazonpayments_setup','0.1.2'),('api_setup','0.8.1'),('backup_setup','0.7.0'),('bundle_setup','0.1.7'),('catalogindex_setup','0.7.10'),('cataloginventory_setup','0.7.5'),('catalogrule_setup','0.7.7'),('catalogsearch_setup','0.7.6'),('catalog_setup','0.7.69'),('checkout_setup','0.9.3'),('cms_setup','0.7.8'),('compiler_setup','0.1.0'),('contacts_setup','0.8.0'),('core_setup','0.8.13'),('cron_setup','0.7.1'),('customer_setup','0.8.11'),('dataflow_setup','0.7.4'),('directory_setup','0.8.5'),('downloadable_setup','0.1.14'),('eav_setup','0.7.13'),('giftmessage_setup','0.7.2'),('googlebase_setup','0.1.1'),('googlecheckout_setup','0.7.3'),('googleoptimizer_setup','0.1.2'),('log_setup','0.7.6'),('newsletter_setup','0.8.0'),('paygate_setup','0.7.0'),('payment_setup','0.7.0'),('paypaluk_setup','0.7.0'),('paypal_setup','0.7.2'),('poll_setup','0.7.2'),('productalert_setup','0.7.2'),('rating_setup','0.7.2'),('reports_setup','0.7.7'),('review_setup','0.7.4'),('salesrule_setup','0.7.7'),('sales_setup','0.9.38'),('sendfriend_setup','0.7.2'),('shipping_setup','0.7.0'),('sitemap_setup','0.7.2'),('tag_setup','0.7.2'),('tax_setup','0.7.8'),('usa_setup','0.7.0'),('weee_setup','0.13'),('wishlist_setup','0.7.4');
/*!40000 ALTER TABLE `core_resource` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_session`
--

DROP TABLE IF EXISTS `core_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_session` (
  `session_id` varchar(255) NOT NULL DEFAULT '',
  `website_id` smallint(5) unsigned DEFAULT NULL,
  `session_expires` int(10) unsigned NOT NULL DEFAULT '0',
  `session_data` mediumblob NOT NULL,
  PRIMARY KEY (`session_id`),
  KEY `FK_SESSION_WEBSITE` (`website_id`),
  CONSTRAINT `FK_SESSION_WEBSITE` FOREIGN KEY (`website_id`) REFERENCES `core_website` (`website_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Session data store';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_session`
--

LOCK TABLES `core_session` WRITE;
/*!40000 ALTER TABLE `core_session` DISABLE KEYS */;
/*!40000 ALTER TABLE `core_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_store`
--

DROP TABLE IF EXISTS `core_store`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_store` (
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
  KEY `FK_STORE_GROUP` (`group_id`),
  CONSTRAINT `FK_STORE_GROUP_STORE` FOREIGN KEY (`group_id`) REFERENCES `core_store_group` (`group_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_STORE_WEBSITE` FOREIGN KEY (`website_id`) REFERENCES `core_website` (`website_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='Stores';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_store`
--

LOCK TABLES `core_store` WRITE;
/*!40000 ALTER TABLE `core_store` DISABLE KEYS */;
INSERT INTO `core_store` VALUES (0,'admin',0,0,'Admin',0,1),(1,'default',1,1,'Default Store View',0,1);
/*!40000 ALTER TABLE `core_store` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_store_group`
--

DROP TABLE IF EXISTS `core_store_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_store_group` (
  `group_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `website_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `name` varchar(255) NOT NULL,
  `root_category_id` int(10) unsigned NOT NULL DEFAULT '0',
  `default_store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`group_id`),
  KEY `FK_STORE_GROUP_WEBSITE` (`website_id`),
  KEY `default_store_id` (`default_store_id`),
  CONSTRAINT `FK_STORE_GROUP_WEBSITE` FOREIGN KEY (`website_id`) REFERENCES `core_website` (`website_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_store_group`
--

LOCK TABLES `core_store_group` WRITE;
/*!40000 ALTER TABLE `core_store_group` DISABLE KEYS */;
INSERT INTO `core_store_group` VALUES (0,0,'Default',0,0),(1,1,'Main Website Store',2,1);
/*!40000 ALTER TABLE `core_store_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_translate`
--

DROP TABLE IF EXISTS `core_translate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_translate` (
  `key_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `string` varchar(255) NOT NULL DEFAULT '',
  `store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `translate` varchar(255) NOT NULL DEFAULT '',
  `locale` varchar(20) NOT NULL DEFAULT 'en_US',
  PRIMARY KEY (`key_id`),
  UNIQUE KEY `IDX_CODE` (`store_id`,`locale`,`string`),
  KEY `FK_CORE_TRANSLATE_STORE` (`store_id`),
  CONSTRAINT `FK_CORE_TRANSLATE_STORE` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Translation data';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_translate`
--

LOCK TABLES `core_translate` WRITE;
/*!40000 ALTER TABLE `core_translate` DISABLE KEYS */;
/*!40000 ALTER TABLE `core_translate` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_url_rewrite`
--

DROP TABLE IF EXISTS `core_url_rewrite`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_url_rewrite` (
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
  KEY `IDX_CATEGORY_REWRITE` (`category_id`,`is_system`,`product_id`,`store_id`,`id_path`),
  CONSTRAINT `FK_CORE_URL_REWRITE_CATEGORY` FOREIGN KEY (`category_id`) REFERENCES `catalog_category_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CORE_URL_REWRITE_PRODUCT` FOREIGN KEY (`product_id`) REFERENCES `catalog_product_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CORE_URL_REWRITE_STORE` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=521 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_url_rewrite`
--

LOCK TABLES `core_url_rewrite` WRITE;
/*!40000 ALTER TABLE `core_url_rewrite` DISABLE KEYS */;
INSERT INTO `core_url_rewrite` VALUES (3,1,NULL,1,'product/1','Time-to-Jam!-[With-Stickers]-0030099690202.html','catalog/product/view/id/1',1,'',NULL),(4,1,2107,1,'product/1/2107','juvenile-fiction/general/Time-to-Jam!-[With-Stickers]-0030099690202.html','catalog/product/view/id/1/category/2107',1,'',NULL),(5,1,2106,1,'product/1/2106','juvenile-fiction/Time-to-Jam!-[With-Stickers]-0030099690202.html','catalog/product/view/id/1/category/2106',1,'',NULL),(6,1,NULL,2,'product/2','Chanukah-Medley;-For-String-&-Wind-Combinations-#991258:-For-String-&-Wind-Combinations-0073999668766.html','catalog/product/view/id/2',1,'',NULL),(7,1,3453,2,'product/2/3453','music/religious/general/Chanukah-Medley;-For-String-&-Wind-Combinations-#991258:-For-String-&-Wind-Combinations-0073999668766.html','catalog/product/view/id/2/category/3453',1,'',NULL),(8,1,3452,2,'product/2/3452','music/religious/Chanukah-Medley;-For-String-&-Wind-Combinations-#991258:-For-String-&-Wind-Combinations-0073999668766.html','catalog/product/view/id/2/category/3452',1,'',NULL),(9,1,3384,2,'product/2/3384','music/Chanukah-Medley;-For-String-&-Wind-Combinations-#991258:-For-String-&-Wind-Combinations-0073999668766.html','catalog/product/view/id/2/category/3384',1,'',NULL),(10,1,NULL,3,'product/3','Can-We-Talk?-Leader-Kit:-Soul-Stirring-Conversations-with-God-0634337008486.html','catalog/product/view/id/3',1,'',NULL),(11,1,4036,3,'product/3/4036','religion/christian-life/womens-issues/Can-We-Talk?-Leader-Kit:-Soul-Stirring-Conversations-with-God-0634337008486.html','catalog/product/view/id/3/category/4036',1,'',NULL),(12,1,4015,3,'product/3/4015','religion/christian-life/Can-We-Talk?-Leader-Kit:-Soul-Stirring-Conversations-with-God-0634337008486.html','catalog/product/view/id/3/category/4015',1,'',NULL),(13,1,3944,3,'product/3/3944','religion/Can-We-Talk?-Leader-Kit:-Soul-Stirring-Conversations-with-God-0634337008486.html','catalog/product/view/id/3/category/3944',1,'',NULL),(14,1,NULL,4,'product/4','Mystery-of-Moosehead-Falls-[With-CD]-0690249442220.html','catalog/product/view/id/4',1,'',NULL),(15,1,2107,4,'product/4/2107','juvenile-fiction/general/Mystery-of-Moosehead-Falls-[With-CD]-0690249442220.html','catalog/product/view/id/4/category/2107',1,'',NULL),(16,1,2106,4,'product/4/2106','juvenile-fiction/Mystery-of-Moosehead-Falls-[With-CD]-0690249442220.html','catalog/product/view/id/4/category/2106',1,'',NULL),(17,1,NULL,5,'product/5','Mystery-of-Moosehead-Falls-[With-Cassette]-0690249442244.html','catalog/product/view/id/5',1,'',NULL),(18,1,2107,5,'product/5/2107','juvenile-fiction/general/Mystery-of-Moosehead-Falls-[With-Cassette]-0690249442244.html','catalog/product/view/id/5/category/2107',1,'',NULL),(19,1,2106,5,'product/5/2106','juvenile-fiction/Mystery-of-Moosehead-Falls-[With-Cassette]-0690249442244.html','catalog/product/view/id/5/category/2106',1,'',NULL),(20,1,NULL,6,'product/6','In-Adoration-of-the-King-of-Kings-0765762013001.html','catalog/product/view/id/6',1,'',NULL),(21,1,3454,6,'product/6/3454','music/religious/christian////In-Adoration-of-the-King-of-Kings-0765762013001.html','catalog/product/view/id/6/category/3454',1,'',NULL),(22,1,3452,6,'product/6/3452','music/religious/christian///In-Adoration-of-the-King-of-Kings-0765762013001.html','catalog/product/view/id/6/category/3452',1,'',NULL),(23,1,3384,6,'product/6/3384','music/religious/christian//In-Adoration-of-the-King-of-Kings-0765762013001.html','catalog/product/view/id/6/category/3384',1,'',NULL),(24,1,4016,6,'product/6/4016','music/religious/christian/In-Adoration-of-the-King-of-Kings-0765762013001.html','catalog/product/view/id/6/category/4016',1,'',NULL),(25,1,4015,6,'product/6/4015','music/religious/In-Adoration-of-the-King-of-Kings-0765762013001.html','catalog/product/view/id/6/category/4015',1,'',NULL),(26,1,3944,6,'product/6/3944','music/In-Adoration-of-the-King-of-Kings-0765762013001.html','catalog/product/view/id/6/category/3944',1,'',NULL),(27,1,NULL,7,'product/7','All-on-a-Christmas-Day-Directors-Production-Guide-[With-Video]-0765762060401.html','catalog/product/view/id/7',1,'',NULL),(28,1,3454,7,'product/7/3454','music/religious/christian////All-on-a-Christmas-Day-Directors-Production-Guide-[With-Video]-0765762060401.html','catalog/product/view/id/7/category/3454',1,'',NULL),(29,1,3452,7,'product/7/3452','music/religious/christian///All-on-a-Christmas-Day-Directors-Production-Guide-[With-Video]-0765762060401.html','catalog/product/view/id/7/category/3452',1,'',NULL),(30,1,3384,7,'product/7/3384','music/religious/christian//All-on-a-Christmas-Day-Directors-Production-Guide-[With-Video]-0765762060401.html','catalog/product/view/id/7/category/3384',1,'',NULL),(31,1,4016,7,'product/7/4016','music/religious/christian/All-on-a-Christmas-Day-Directors-Production-Guide-[With-Video]-0765762060401.html','catalog/product/view/id/7/category/4016',1,'',NULL),(32,1,4015,7,'product/7/4015','music/religious/All-on-a-Christmas-Day-Directors-Production-Guide-[With-Video]-0765762060401.html','catalog/product/view/id/7/category/4015',1,'',NULL),(33,1,3944,7,'product/7/3944','music/All-on-a-Christmas-Day-Directors-Production-Guide-[With-Video]-0765762060401.html','catalog/product/view/id/7/category/3944',1,'',NULL),(34,1,NULL,8,'product/8','More-Than-Worthy-with-Offering-0765762072008.html','catalog/product/view/id/8',1,'',NULL),(35,1,3455,8,'product/8/3455','music/religious/contemporary-christian////More-Than-Worthy-with-Offering-0765762072008.html','catalog/product/view/id/8/category/3455',1,'',NULL),(36,1,3452,8,'product/8/3452','music/religious/contemporary-christian///More-Than-Worthy-with-Offering-0765762072008.html','catalog/product/view/id/8/category/3452',1,'',NULL),(37,1,3384,8,'product/8/3384','music/religious/contemporary-christian//More-Than-Worthy-with-Offering-0765762072008.html','catalog/product/view/id/8/category/3384',1,'',NULL),(38,1,4016,8,'product/8/4016','music/religious/contemporary-christian/More-Than-Worthy-with-Offering-0765762072008.html','catalog/product/view/id/8/category/4016',1,'',NULL),(39,1,4015,8,'product/8/4015','music/religious/More-Than-Worthy-with-Offering-0765762072008.html','catalog/product/view/id/8/category/4015',1,'',NULL),(40,1,3944,8,'product/8/3944','music/More-Than-Worthy-with-Offering-0765762072008.html','catalog/product/view/id/8/category/3944',1,'',NULL),(41,1,NULL,9,'product/9','All-the-Best-for-Christmas:-21-Choral-Favorites-for-Pageant,-Concert,-or-Worship-0765762092501.html','catalog/product/view/id/9',1,'',NULL),(42,1,3454,9,'product/9/3454','music/religious/christian////All-the-Best-for-Christmas:-21-Choral-Favorites-for-Pageant,-Concert,-or-Worship-0765762092501.html','catalog/product/view/id/9/category/3454',1,'',NULL),(43,1,3452,9,'product/9/3452','music/religious/christian///All-the-Best-for-Christmas:-21-Choral-Favorites-for-Pageant,-Concert,-or-Worship-0765762092501.html','catalog/product/view/id/9/category/3452',1,'',NULL),(44,1,3384,9,'product/9/3384','music/religious/christian//All-the-Best-for-Christmas:-21-Choral-Favorites-for-Pageant,-Concert,-or-Worship-0765762092501.html','catalog/product/view/id/9/category/3384',1,'',NULL),(45,1,4016,9,'product/9/4016','music/religious/christian/All-the-Best-for-Christmas:-21-Choral-Favorites-for-Pageant,-Concert,-or-Worship-0765762092501.html','catalog/product/view/id/9/category/4016',1,'',NULL),(46,1,4015,9,'product/9/4015','music/religious/All-the-Best-for-Christmas:-21-Choral-Favorites-for-Pageant,-Concert,-or-Worship-0765762092501.html','catalog/product/view/id/9/category/4015',1,'',NULL),(47,1,3944,9,'product/9/3944','music/All-the-Best-for-Christmas:-21-Choral-Favorites-for-Pageant,-Concert,-or-Worship-0765762092501.html','catalog/product/view/id/9/category/3944',1,'',NULL),(48,1,NULL,10,'product/10','Christ-Is-Born,-Sing-Alleluia-0765762101609.html','catalog/product/view/id/10',1,'',NULL),(49,1,3454,10,'product/10/3454','music/religious/christian////Christ-Is-Born,-Sing-Alleluia-0765762101609.html','catalog/product/view/id/10/category/3454',1,'',NULL),(50,1,3452,10,'product/10/3452','music/religious/christian///Christ-Is-Born,-Sing-Alleluia-0765762101609.html','catalog/product/view/id/10/category/3452',1,'',NULL),(51,1,3384,10,'product/10/3384','music/religious/christian//Christ-Is-Born,-Sing-Alleluia-0765762101609.html','catalog/product/view/id/10/category/3384',1,'',NULL),(52,1,4016,10,'product/10/4016','music/religious/christian/Christ-Is-Born,-Sing-Alleluia-0765762101609.html','catalog/product/view/id/10/category/4016',1,'',NULL),(53,1,4015,10,'product/10/4015','music/religious/Christ-Is-Born,-Sing-Alleluia-0765762101609.html','catalog/product/view/id/10/category/4015',1,'',NULL),(54,1,3944,10,'product/10/3944','music/Christ-Is-Born,-Sing-Alleluia-0765762101609.html','catalog/product/view/id/10/category/3944',1,'',NULL),(55,1,NULL,11,'product/11','Great-Is-the-Lord-Almighty-0765762106000.html','catalog/product/view/id/11',1,'',NULL),(56,1,3455,11,'product/11/3455','music/religious/contemporary-christian////Great-Is-the-Lord-Almighty-0765762106000.html','catalog/product/view/id/11/category/3455',1,'',NULL),(57,1,3452,11,'product/11/3452','music/religious/contemporary-christian///Great-Is-the-Lord-Almighty-0765762106000.html','catalog/product/view/id/11/category/3452',1,'',NULL),(58,1,3384,11,'product/11/3384','music/religious/contemporary-christian//Great-Is-the-Lord-Almighty-0765762106000.html','catalog/product/view/id/11/category/3384',1,'',NULL),(59,1,4016,11,'product/11/4016','music/religious/contemporary-christian/Great-Is-the-Lord-Almighty-0765762106000.html','catalog/product/view/id/11/category/4016',1,'',NULL),(60,1,4015,11,'product/11/4015','music/religious/Great-Is-the-Lord-Almighty-0765762106000.html','catalog/product/view/id/11/category/4015',1,'',NULL),(61,1,3944,11,'product/11/3944','music/Great-Is-the-Lord-Almighty-0765762106000.html','catalog/product/view/id/11/category/3944',1,'',NULL),(62,1,NULL,12,'product/12','Here-I-Am-to-Worship-0765762108004.html','catalog/product/view/id/12',1,'',NULL),(63,1,3454,12,'product/12/3454','music/religious/christian/////Here-I-Am-to-Worship-0765762108004.html','catalog/product/view/id/12/category/3454',1,'',NULL),(64,1,3455,12,'product/12/3455','music/religious/christian////Here-I-Am-to-Worship-0765762108004.html','catalog/product/view/id/12/category/3455',1,'',NULL),(65,1,3452,12,'product/12/3452','music/religious/christian///Here-I-Am-to-Worship-0765762108004.html','catalog/product/view/id/12/category/3452',1,'',NULL),(66,1,3384,12,'product/12/3384','music/religious/christian//Here-I-Am-to-Worship-0765762108004.html','catalog/product/view/id/12/category/3384',1,'',NULL),(67,1,4016,12,'product/12/4016','music/religious/christian/Here-I-Am-to-Worship-0765762108004.html','catalog/product/view/id/12/category/4016',1,'',NULL),(68,1,4015,12,'product/12/4015','music/religious/Here-I-Am-to-Worship-0765762108004.html','catalog/product/view/id/12/category/4015',1,'',NULL),(69,1,3944,12,'product/12/3944','music/Here-I-Am-to-Worship-0765762108004.html','catalog/product/view/id/12/category/3944',1,'',NULL),(70,1,NULL,13,'product/13','Jesus,-Draw-Me-Ever-Nearer-0765762112506.html','catalog/product/view/id/13',1,'',NULL),(71,1,3455,13,'product/13/3455','music/religious/contemporary-christian////Jesus,-Draw-Me-Ever-Nearer-0765762112506.html','catalog/product/view/id/13/category/3455',1,'',NULL),(72,1,3452,13,'product/13/3452','music/religious/contemporary-christian///Jesus,-Draw-Me-Ever-Nearer-0765762112506.html','catalog/product/view/id/13/category/3452',1,'',NULL),(73,1,3384,13,'product/13/3384','music/religious/contemporary-christian//Jesus,-Draw-Me-Ever-Nearer-0765762112506.html','catalog/product/view/id/13/category/3384',1,'',NULL),(74,1,4016,13,'product/13/4016','music/religious/contemporary-christian/Jesus,-Draw-Me-Ever-Nearer-0765762112506.html','catalog/product/view/id/13/category/4016',1,'',NULL),(75,1,4015,13,'product/13/4015','music/religious/Jesus,-Draw-Me-Ever-Nearer-0765762112506.html','catalog/product/view/id/13/category/4015',1,'',NULL),(76,1,3944,13,'product/13/3944','music/Jesus,-Draw-Me-Ever-Nearer-0765762112506.html','catalog/product/view/id/13/category/3944',1,'',NULL),(77,1,NULL,14,'product/14','The-Lord-Is-the-Strength-of-My-Life-0765762114906.html','catalog/product/view/id/14',1,'',NULL),(78,1,3455,14,'product/14/3455','music/religious/contemporary-christian////The-Lord-Is-the-Strength-of-My-Life-0765762114906.html','catalog/product/view/id/14/category/3455',1,'',NULL),(79,1,3452,14,'product/14/3452','music/religious/contemporary-christian///The-Lord-Is-the-Strength-of-My-Life-0765762114906.html','catalog/product/view/id/14/category/3452',1,'',NULL),(80,1,3384,14,'product/14/3384','music/religious/contemporary-christian//The-Lord-Is-the-Strength-of-My-Life-0765762114906.html','catalog/product/view/id/14/category/3384',1,'',NULL),(81,1,4016,14,'product/14/4016','music/religious/contemporary-christian/The-Lord-Is-the-Strength-of-My-Life-0765762114906.html','catalog/product/view/id/14/category/4016',1,'',NULL),(82,1,4015,14,'product/14/4015','music/religious/The-Lord-Is-the-Strength-of-My-Life-0765762114906.html','catalog/product/view/id/14/category/4015',1,'',NULL),(83,1,3944,14,'product/14/3944','music/The-Lord-Is-the-Strength-of-My-Life-0765762114906.html','catalog/product/view/id/14/category/3944',1,'',NULL),(84,1,NULL,15,'product/15','Salvation-Belongs-to-Our-God-0765762119406.html','catalog/product/view/id/15',1,'',NULL),(85,1,3455,15,'product/15/3455','music/religious/contemporary-christian////Salvation-Belongs-to-Our-God-0765762119406.html','catalog/product/view/id/15/category/3455',1,'',NULL),(86,1,3452,15,'product/15/3452','music/religious/contemporary-christian///Salvation-Belongs-to-Our-God-0765762119406.html','catalog/product/view/id/15/category/3452',1,'',NULL),(87,1,3384,15,'product/15/3384','music/religious/contemporary-christian//Salvation-Belongs-to-Our-God-0765762119406.html','catalog/product/view/id/15/category/3384',1,'',NULL),(88,1,4016,15,'product/15/4016','music/religious/contemporary-christian/Salvation-Belongs-to-Our-God-0765762119406.html','catalog/product/view/id/15/category/4016',1,'',NULL),(89,1,4015,15,'product/15/4015','music/religious/Salvation-Belongs-to-Our-God-0765762119406.html','catalog/product/view/id/15/category/4015',1,'',NULL),(90,1,3944,15,'product/15/3944','music/Salvation-Belongs-to-Our-God-0765762119406.html','catalog/product/view/id/15/category/3944',1,'',NULL),(91,1,NULL,16,'product/16','Shout-to-the-North-with-O-Zion,-Haste-0765762119901.html','catalog/product/view/id/16',1,'',NULL),(92,1,3455,16,'product/16/3455','music/religious/contemporary-christian////Shout-to-the-North-with-O-Zion,-Haste-0765762119901.html','catalog/product/view/id/16/category/3455',1,'',NULL),(93,1,3452,16,'product/16/3452','music/religious/contemporary-christian///Shout-to-the-North-with-O-Zion,-Haste-0765762119901.html','catalog/product/view/id/16/category/3452',1,'',NULL),(94,1,3384,16,'product/16/3384','music/religious/contemporary-christian//Shout-to-the-North-with-O-Zion,-Haste-0765762119901.html','catalog/product/view/id/16/category/3384',1,'',NULL),(95,1,4016,16,'product/16/4016','music/religious/contemporary-christian/Shout-to-the-North-with-O-Zion,-Haste-0765762119901.html','catalog/product/view/id/16/category/4016',1,'',NULL),(96,1,4015,16,'product/16/4015','music/religious/Shout-to-the-North-with-O-Zion,-Haste-0765762119901.html','catalog/product/view/id/16/category/4015',1,'',NULL),(97,1,3944,16,'product/16/3944','music/Shout-to-the-North-with-O-Zion,-Haste-0765762119901.html','catalog/product/view/id/16/category/3944',1,'',NULL),(98,1,NULL,17,'product/17','Your-Grace-Still-Amazes-Me-0765762127807.html','catalog/product/view/id/17',1,'',NULL),(99,1,3454,17,'product/17/3454','music/religious/christian////Your-Grace-Still-Amazes-Me-0765762127807.html','catalog/product/view/id/17/category/3454',1,'',NULL),(100,1,3452,17,'product/17/3452','music/religious/christian///Your-Grace-Still-Amazes-Me-0765762127807.html','catalog/product/view/id/17/category/3452',1,'',NULL),(101,1,3384,17,'product/17/3384','music/religious/christian//Your-Grace-Still-Amazes-Me-0765762127807.html','catalog/product/view/id/17/category/3384',1,'',NULL),(102,1,4016,17,'product/17/4016','music/religious/christian/Your-Grace-Still-Amazes-Me-0765762127807.html','catalog/product/view/id/17/category/4016',1,'',NULL),(103,1,4015,17,'product/17/4015','music/religious/Your-Grace-Still-Amazes-Me-0765762127807.html','catalog/product/view/id/17/category/4015',1,'',NULL),(104,1,3944,17,'product/17/3944','music/Your-Grace-Still-Amazes-Me-0765762127807.html','catalog/product/view/id/17/category/3944',1,'',NULL),(105,1,NULL,18,'product/18','Gloria-0765762132702.html','catalog/product/view/id/18',1,'',NULL),(106,1,3454,18,'product/18/3454','music/religious/christian////Gloria-0765762132702.html','catalog/product/view/id/18/category/3454',1,'',NULL),(107,1,3452,18,'product/18/3452','music/religious/christian///Gloria-0765762132702.html','catalog/product/view/id/18/category/3452',1,'',NULL),(108,1,3384,18,'product/18/3384','music/religious/christian//Gloria-0765762132702.html','catalog/product/view/id/18/category/3384',1,'',NULL),(109,1,4016,18,'product/18/4016','music/religious/christian/Gloria-0765762132702.html','catalog/product/view/id/18/category/4016',1,'',NULL),(110,1,4015,18,'product/18/4015','music/religious/Gloria-0765762132702.html','catalog/product/view/id/18/category/4015',1,'',NULL),(111,1,3944,18,'product/18/3944','music/Gloria-0765762132702.html','catalog/product/view/id/18/category/3944',1,'',NULL),(112,1,NULL,19,'product/19','The-Lord-Is-My-Light-0765762132801.html','catalog/product/view/id/19',1,'',NULL),(113,1,3454,19,'product/19/3454','music/religious/christian////The-Lord-Is-My-Light-0765762132801.html','catalog/product/view/id/19/category/3454',1,'',NULL),(114,1,3452,19,'product/19/3452','music/religious/christian///The-Lord-Is-My-Light-0765762132801.html','catalog/product/view/id/19/category/3452',1,'',NULL),(115,1,3384,19,'product/19/3384','music/religious/christian//The-Lord-Is-My-Light-0765762132801.html','catalog/product/view/id/19/category/3384',1,'',NULL),(116,1,4016,19,'product/19/4016','music/religious/christian/The-Lord-Is-My-Light-0765762132801.html','catalog/product/view/id/19/category/4016',1,'',NULL),(117,1,4015,19,'product/19/4015','music/religious/The-Lord-Is-My-Light-0765762132801.html','catalog/product/view/id/19/category/4015',1,'',NULL),(118,1,3944,19,'product/19/3944','music/The-Lord-Is-My-Light-0765762132801.html','catalog/product/view/id/19/category/3944',1,'',NULL),(119,1,NULL,20,'product/20','Messiah-Suite-0765762132900.html','catalog/product/view/id/20',1,'',NULL),(120,1,3454,20,'product/20/3454','music/religious/christian////Messiah-Suite-0765762132900.html','catalog/product/view/id/20/category/3454',1,'',NULL),(121,1,3452,20,'product/20/3452','music/religious/christian///Messiah-Suite-0765762132900.html','catalog/product/view/id/20/category/3452',1,'',NULL),(122,1,3384,20,'product/20/3384','music/religious/christian//Messiah-Suite-0765762132900.html','catalog/product/view/id/20/category/3384',1,'',NULL),(123,1,4016,20,'product/20/4016','music/religious/christian/Messiah-Suite-0765762132900.html','catalog/product/view/id/20/category/4016',1,'',NULL),(124,1,4015,20,'product/20/4015','music/religious/Messiah-Suite-0765762132900.html','catalog/product/view/id/20/category/4015',1,'',NULL),(125,1,3944,20,'product/20/3944','music/Messiah-Suite-0765762132900.html','catalog/product/view/id/20/category/3944',1,'',NULL),(126,1,NULL,21,'product/21','Easter-Song-0765762133303.html','catalog/product/view/id/21',1,'',NULL),(127,1,3455,21,'product/21/3455','music/religious/contemporary-christian////Easter-Song-0765762133303.html','catalog/product/view/id/21/category/3455',1,'',NULL),(128,1,3452,21,'product/21/3452','music/religious/contemporary-christian///Easter-Song-0765762133303.html','catalog/product/view/id/21/category/3452',1,'',NULL),(129,1,3384,21,'product/21/3384','music/religious/contemporary-christian//Easter-Song-0765762133303.html','catalog/product/view/id/21/category/3384',1,'',NULL),(130,1,4016,21,'product/21/4016','music/religious/contemporary-christian/Easter-Song-0765762133303.html','catalog/product/view/id/21/category/4016',1,'',NULL),(131,1,4015,21,'product/21/4015','music/religious/Easter-Song-0765762133303.html','catalog/product/view/id/21/category/4015',1,'',NULL),(132,1,3944,21,'product/21/3944','music/Easter-Song-0765762133303.html','catalog/product/view/id/21/category/3944',1,'',NULL),(133,1,NULL,22,'product/22','How-Beautiful-0765762133600.html','catalog/product/view/id/22',1,'',NULL),(134,1,3454,22,'product/22/3454','music/religious/christian////How-Beautiful-0765762133600.html','catalog/product/view/id/22/category/3454',1,'',NULL),(135,1,3452,22,'product/22/3452','music/religious/christian///How-Beautiful-0765762133600.html','catalog/product/view/id/22/category/3452',1,'',NULL),(136,1,3384,22,'product/22/3384','music/religious/christian//How-Beautiful-0765762133600.html','catalog/product/view/id/22/category/3384',1,'',NULL),(137,1,4016,22,'product/22/4016','music/religious/christian/How-Beautiful-0765762133600.html','catalog/product/view/id/22/category/4016',1,'',NULL),(138,1,4015,22,'product/22/4015','music/religious/How-Beautiful-0765762133600.html','catalog/product/view/id/22/category/4015',1,'',NULL),(139,1,3944,22,'product/22/3944','music/How-Beautiful-0765762133600.html','catalog/product/view/id/22/category/3944',1,'',NULL),(140,1,NULL,23,'product/23','O-Come,-O-Come,-Emmanuel-0765762133808.html','catalog/product/view/id/23',1,'',NULL),(141,1,3454,23,'product/23/3454','music/religious/christian/////O-Come,-O-Come,-Emmanuel-0765762133808.html','catalog/product/view/id/23/category/3454',1,'',NULL),(142,1,3457,23,'product/23/3457','music/religious/christian////O-Come,-O-Come,-Emmanuel-0765762133808.html','catalog/product/view/id/23/category/3457',1,'',NULL),(143,1,3452,23,'product/23/3452','music/religious/christian///O-Come,-O-Come,-Emmanuel-0765762133808.html','catalog/product/view/id/23/category/3452',1,'',NULL),(144,1,3384,23,'product/23/3384','music/religious/christian//O-Come,-O-Come,-Emmanuel-0765762133808.html','catalog/product/view/id/23/category/3384',1,'',NULL),(145,1,4016,23,'product/23/4016','music/religious/christian/O-Come,-O-Come,-Emmanuel-0765762133808.html','catalog/product/view/id/23/category/4016',1,'',NULL),(146,1,4015,23,'product/23/4015','music/religious/O-Come,-O-Come,-Emmanuel-0765762133808.html','catalog/product/view/id/23/category/4015',1,'',NULL),(147,1,3944,23,'product/23/3944','music/O-Come,-O-Come,-Emmanuel-0765762133808.html','catalog/product/view/id/23/category/3944',1,'',NULL),(148,1,NULL,24,'product/24','Now-Unto-the-King-Eternal-W/-Immortal,-Invisible-0765762134201.html','catalog/product/view/id/24',1,'',NULL),(149,1,3454,24,'product/24/3454','music/religious/christian/////Now-Unto-the-King-Eternal-W/-Immortal,-Invisible-0765762134201.html','catalog/product/view/id/24/category/3454',1,'',NULL),(150,1,3455,24,'product/24/3455','music/religious/christian////Now-Unto-the-King-Eternal-W/-Immortal,-Invisible-0765762134201.html','catalog/product/view/id/24/category/3455',1,'',NULL),(151,1,3452,24,'product/24/3452','music/religious/christian///Now-Unto-the-King-Eternal-W/-Immortal,-Invisible-0765762134201.html','catalog/product/view/id/24/category/3452',1,'',NULL),(152,1,3384,24,'product/24/3384','music/religious/christian//Now-Unto-the-King-Eternal-W/-Immortal,-Invisible-0765762134201.html','catalog/product/view/id/24/category/3384',1,'',NULL),(153,1,4016,24,'product/24/4016','music/religious/christian/Now-Unto-the-King-Eternal-W/-Immortal,-Invisible-0765762134201.html','catalog/product/view/id/24/category/4016',1,'',NULL),(154,1,4015,24,'product/24/4015','music/religious/Now-Unto-the-King-Eternal-W/-Immortal,-Invisible-0765762134201.html','catalog/product/view/id/24/category/4015',1,'',NULL),(155,1,3944,24,'product/24/3944','music/Now-Unto-the-King-Eternal-W/-Immortal,-Invisible-0765762134201.html','catalog/product/view/id/24/category/3944',1,'',NULL),(156,1,NULL,25,'product/25','Im-Feeling-Fine-W/-Goodby,-World,-Goodby-0765762134409.html','catalog/product/view/id/25',1,'',NULL),(157,1,3456,25,'product/25/3456','music/religious/gospel////Im-Feeling-Fine-W/-Goodby,-World,-Goodby-0765762134409.html','catalog/product/view/id/25/category/3456',1,'',NULL),(158,1,3452,25,'product/25/3452','music/religious/gospel///Im-Feeling-Fine-W/-Goodby,-World,-Goodby-0765762134409.html','catalog/product/view/id/25/category/3452',1,'',NULL),(159,1,3384,25,'product/25/3384','music/religious/gospel//Im-Feeling-Fine-W/-Goodby,-World,-Goodby-0765762134409.html','catalog/product/view/id/25/category/3384',1,'',NULL),(160,1,4016,25,'product/25/4016','music/religious/gospel/Im-Feeling-Fine-W/-Goodby,-World,-Goodby-0765762134409.html','catalog/product/view/id/25/category/4016',1,'',NULL),(161,1,4015,25,'product/25/4015','music/religious/Im-Feeling-Fine-W/-Goodby,-World,-Goodby-0765762134409.html','catalog/product/view/id/25/category/4015',1,'',NULL),(162,1,3944,25,'product/25/3944','music/Im-Feeling-Fine-W/-Goodby,-World,-Goodby-0765762134409.html','catalog/product/view/id/25/category/3944',1,'',NULL),(163,1,NULL,26,'product/26','Freedoms-Song-0765762134508.html','catalog/product/view/id/26',1,'',NULL),(164,1,3454,26,'product/26/3454','music/religious/christian////Freedoms-Song-0765762134508.html','catalog/product/view/id/26/category/3454',1,'',NULL),(165,1,3452,26,'product/26/3452','music/religious/christian///Freedoms-Song-0765762134508.html','catalog/product/view/id/26/category/3452',1,'',NULL),(166,1,3384,26,'product/26/3384','music/religious/christian//Freedoms-Song-0765762134508.html','catalog/product/view/id/26/category/3384',1,'',NULL),(167,1,4016,26,'product/26/4016','music/religious/christian/Freedoms-Song-0765762134508.html','catalog/product/view/id/26/category/4016',1,'',NULL),(168,1,4015,26,'product/26/4015','music/religious/Freedoms-Song-0765762134508.html','catalog/product/view/id/26/category/4015',1,'',NULL),(169,1,3944,26,'product/26/3944','music/Freedoms-Song-0765762134508.html','catalog/product/view/id/26/category/3944',1,'',NULL),(170,1,NULL,27,'product/27','No-Other-Name-0765762134607.html','catalog/product/view/id/27',1,'',NULL),(171,1,3455,27,'product/27/3455','music/religious/contemporary-christian////No-Other-Name-0765762134607.html','catalog/product/view/id/27/category/3455',1,'',NULL),(172,1,3452,27,'product/27/3452','music/religious/contemporary-christian///No-Other-Name-0765762134607.html','catalog/product/view/id/27/category/3452',1,'',NULL),(173,1,3384,27,'product/27/3384','music/religious/contemporary-christian//No-Other-Name-0765762134607.html','catalog/product/view/id/27/category/3384',1,'',NULL),(174,1,4016,27,'product/27/4016','music/religious/contemporary-christian/No-Other-Name-0765762134607.html','catalog/product/view/id/27/category/4016',1,'',NULL),(175,1,4015,27,'product/27/4015','music/religious/No-Other-Name-0765762134607.html','catalog/product/view/id/27/category/4015',1,'',NULL),(176,1,3944,27,'product/27/3944','music/No-Other-Name-0765762134607.html','catalog/product/view/id/27/category/3944',1,'',NULL),(177,1,NULL,28,'product/28','O-Come,-All-Ye-Faithful-0765762134706.html','catalog/product/view/id/28',1,'',NULL),(178,1,3454,28,'product/28/3454','music/religious/christian/////O-Come,-All-Ye-Faithful-0765762134706.html','catalog/product/view/id/28/category/3454',1,'',NULL),(179,1,3457,28,'product/28/3457','music/religious/christian////O-Come,-All-Ye-Faithful-0765762134706.html','catalog/product/view/id/28/category/3457',1,'',NULL),(180,1,3452,28,'product/28/3452','music/religious/christian///O-Come,-All-Ye-Faithful-0765762134706.html','catalog/product/view/id/28/category/3452',1,'',NULL),(181,1,3384,28,'product/28/3384','music/religious/christian//O-Come,-All-Ye-Faithful-0765762134706.html','catalog/product/view/id/28/category/3384',1,'',NULL),(182,1,4016,28,'product/28/4016','music/religious/christian/O-Come,-All-Ye-Faithful-0765762134706.html','catalog/product/view/id/28/category/4016',1,'',NULL),(183,1,4015,28,'product/28/4015','music/religious/O-Come,-All-Ye-Faithful-0765762134706.html','catalog/product/view/id/28/category/4015',1,'',NULL),(184,1,3944,28,'product/28/3944','music/O-Come,-All-Ye-Faithful-0765762134706.html','catalog/product/view/id/28/category/3944',1,'',NULL),(185,1,NULL,29,'product/29','The-Heart-of-Worship-with-Come,-Thou-Fount-of-Every-Blessing-0765762134805.html','catalog/product/view/id/29',1,'',NULL),(186,1,3454,29,'product/29/3454','music/religious/christian/////The-Heart-of-Worship-with-Come,-Thou-Fount-of-Every-Blessing-0765762134805.html','catalog/product/view/id/29/category/3454',1,'',NULL),(187,1,3455,29,'product/29/3455','music/religious/christian////The-Heart-of-Worship-with-Come,-Thou-Fount-of-Every-Blessing-0765762134805.html','catalog/product/view/id/29/category/3455',1,'',NULL),(188,1,3452,29,'product/29/3452','music/religious/christian///The-Heart-of-Worship-with-Come,-Thou-Fount-of-Every-Blessing-0765762134805.html','catalog/product/view/id/29/category/3452',1,'',NULL),(189,1,3384,29,'product/29/3384','music/religious/christian//The-Heart-of-Worship-with-Come,-Thou-Fount-of-Every-Blessing-0765762134805.html','catalog/product/view/id/29/category/3384',1,'',NULL),(190,1,4016,29,'product/29/4016','music/religious/christian/The-Heart-of-Worship-with-Come,-Thou-Fount-of-Every-Blessing-0765762134805.html','catalog/product/view/id/29/category/4016',1,'',NULL),(191,1,4015,29,'product/29/4015','music/religious/The-Heart-of-Worship-with-Come,-Thou-Fount-of-Every-Blessing-0765762134805.html','catalog/product/view/id/29/category/4015',1,'',NULL),(192,1,3944,29,'product/29/3944','music/The-Heart-of-Worship-with-Come,-Thou-Fount-of-Every-Blessing-0765762134805.html','catalog/product/view/id/29/category/3944',1,'',NULL),(193,1,NULL,30,'product/30','I-Exalt-Thee-0765762134904.html','catalog/product/view/id/30',1,'',NULL),(194,1,3455,30,'product/30/3455','music/religious/contemporary-christian////I-Exalt-Thee-0765762134904.html','catalog/product/view/id/30/category/3455',1,'',NULL),(195,1,3452,30,'product/30/3452','music/religious/contemporary-christian///I-Exalt-Thee-0765762134904.html','catalog/product/view/id/30/category/3452',1,'',NULL),(196,1,3384,30,'product/30/3384','music/religious/contemporary-christian//I-Exalt-Thee-0765762134904.html','catalog/product/view/id/30/category/3384',1,'',NULL),(197,1,4016,30,'product/30/4016','music/religious/contemporary-christian/I-Exalt-Thee-0765762134904.html','catalog/product/view/id/30/category/4016',1,'',NULL),(198,1,4015,30,'product/30/4015','music/religious/I-Exalt-Thee-0765762134904.html','catalog/product/view/id/30/category/4015',1,'',NULL),(199,1,3944,30,'product/30/3944','music/I-Exalt-Thee-0765762134904.html','catalog/product/view/id/30/category/3944',1,'',NULL),(200,1,NULL,31,'product/31','My-Life-Is-in-You,-Lord-0765762135000.html','catalog/product/view/id/31',1,'',NULL),(201,1,3455,31,'product/31/3455','music/religious/contemporary-christian////My-Life-Is-in-You,-Lord-0765762135000.html','catalog/product/view/id/31/category/3455',1,'',NULL),(202,1,3452,31,'product/31/3452','music/religious/contemporary-christian///My-Life-Is-in-You,-Lord-0765762135000.html','catalog/product/view/id/31/category/3452',1,'',NULL),(203,1,3384,31,'product/31/3384','music/religious/contemporary-christian//My-Life-Is-in-You,-Lord-0765762135000.html','catalog/product/view/id/31/category/3384',1,'',NULL),(204,1,4016,31,'product/31/4016','music/religious/contemporary-christian/My-Life-Is-in-You,-Lord-0765762135000.html','catalog/product/view/id/31/category/4016',1,'',NULL),(205,1,4015,31,'product/31/4015','music/religious/My-Life-Is-in-You,-Lord-0765762135000.html','catalog/product/view/id/31/category/4015',1,'',NULL),(206,1,3944,31,'product/31/3944','music/My-Life-Is-in-You,-Lord-0765762135000.html','catalog/product/view/id/31/category/3944',1,'',NULL),(207,1,NULL,32,'product/32','Shout-to-the-North-0765762135109.html','catalog/product/view/id/32',1,'',NULL),(208,1,3454,32,'product/32/3454','music/religious/christian/////Shout-to-the-North-0765762135109.html','catalog/product/view/id/32/category/3454',1,'',NULL),(209,1,3455,32,'product/32/3455','music/religious/christian////Shout-to-the-North-0765762135109.html','catalog/product/view/id/32/category/3455',1,'',NULL),(210,1,3452,32,'product/32/3452','music/religious/christian///Shout-to-the-North-0765762135109.html','catalog/product/view/id/32/category/3452',1,'',NULL),(211,1,3384,32,'product/32/3384','music/religious/christian//Shout-to-the-North-0765762135109.html','catalog/product/view/id/32/category/3384',1,'',NULL),(212,1,4016,32,'product/32/4016','music/religious/christian/Shout-to-the-North-0765762135109.html','catalog/product/view/id/32/category/4016',1,'',NULL),(213,1,4015,32,'product/32/4015','music/religious/Shout-to-the-North-0765762135109.html','catalog/product/view/id/32/category/4015',1,'',NULL),(214,1,3944,32,'product/32/3944','music/Shout-to-the-North-0765762135109.html','catalog/product/view/id/32/category/3944',1,'',NULL),(215,1,NULL,33,'product/33','O-Holy-Night-0765762135208.html','catalog/product/view/id/33',1,'',NULL),(216,1,3457,33,'product/33/3457','music/religious/hymns////O-Holy-Night-0765762135208.html','catalog/product/view/id/33/category/3457',1,'',NULL),(217,1,3452,33,'product/33/3452','music/religious/hymns///O-Holy-Night-0765762135208.html','catalog/product/view/id/33/category/3452',1,'',NULL),(218,1,3384,33,'product/33/3384','music/religious/hymns//O-Holy-Night-0765762135208.html','catalog/product/view/id/33/category/3384',1,'',NULL),(219,1,4016,33,'product/33/4016','music/religious/hymns/O-Holy-Night-0765762135208.html','catalog/product/view/id/33/category/4016',1,'',NULL),(220,1,4015,33,'product/33/4015','music/religious/O-Holy-Night-0765762135208.html','catalog/product/view/id/33/category/4015',1,'',NULL),(221,1,3944,33,'product/33/3944','music/O-Holy-Night-0765762135208.html','catalog/product/view/id/33/category/3944',1,'',NULL),(222,1,NULL,34,'product/34','Come,-Now-Is-the-Time-to-Worship-0765762135307.html','catalog/product/view/id/34',1,'',NULL),(223,1,3455,34,'product/34/3455','music/religious/contemporary-christian////Come,-Now-Is-the-Time-to-Worship-0765762135307.html','catalog/product/view/id/34/category/3455',1,'',NULL),(224,1,3452,34,'product/34/3452','music/religious/contemporary-christian///Come,-Now-Is-the-Time-to-Worship-0765762135307.html','catalog/product/view/id/34/category/3452',1,'',NULL),(225,1,3384,34,'product/34/3384','music/religious/contemporary-christian//Come,-Now-Is-the-Time-to-Worship-0765762135307.html','catalog/product/view/id/34/category/3384',1,'',NULL),(226,1,4016,34,'product/34/4016','music/religious/contemporary-christian/Come,-Now-Is-the-Time-to-Worship-0765762135307.html','catalog/product/view/id/34/category/4016',1,'',NULL),(227,1,4015,34,'product/34/4015','music/religious/Come,-Now-Is-the-Time-to-Worship-0765762135307.html','catalog/product/view/id/34/category/4015',1,'',NULL),(228,1,3944,34,'product/34/3944','music/Come,-Now-Is-the-Time-to-Worship-0765762135307.html','catalog/product/view/id/34/category/3944',1,'',NULL),(229,1,NULL,35,'product/35','O-the-Deep,-Deep-Love-of-Jesus-0765762135406.html','catalog/product/view/id/35',1,'',NULL),(230,1,3454,35,'product/35/3454','music/religious/christian/////O-the-Deep,-Deep-Love-of-Jesus-0765762135406.html','catalog/product/view/id/35/category/3454',1,'',NULL),(231,1,3457,35,'product/35/3457','music/religious/christian////O-the-Deep,-Deep-Love-of-Jesus-0765762135406.html','catalog/product/view/id/35/category/3457',1,'',NULL),(232,1,3452,35,'product/35/3452','music/religious/christian///O-the-Deep,-Deep-Love-of-Jesus-0765762135406.html','catalog/product/view/id/35/category/3452',1,'',NULL),(233,1,3384,35,'product/35/3384','music/religious/christian//O-the-Deep,-Deep-Love-of-Jesus-0765762135406.html','catalog/product/view/id/35/category/3384',1,'',NULL),(234,1,4016,35,'product/35/4016','music/religious/christian/O-the-Deep,-Deep-Love-of-Jesus-0765762135406.html','catalog/product/view/id/35/category/4016',1,'',NULL),(235,1,4015,35,'product/35/4015','music/religious/O-the-Deep,-Deep-Love-of-Jesus-0765762135406.html','catalog/product/view/id/35/category/4015',1,'',NULL),(236,1,3944,35,'product/35/3944','music/O-the-Deep,-Deep-Love-of-Jesus-0765762135406.html','catalog/product/view/id/35/category/3944',1,'',NULL),(237,1,NULL,36,'product/36','Great-Is-Thy-Faithfulness-0765762135505.html','catalog/product/view/id/36',1,'',NULL),(238,1,3454,36,'product/36/3454','music/religious/christian/////Great-Is-Thy-Faithfulness-0765762135505.html','catalog/product/view/id/36/category/3454',1,'',NULL),(239,1,3457,36,'product/36/3457','music/religious/christian////Great-Is-Thy-Faithfulness-0765762135505.html','catalog/product/view/id/36/category/3457',1,'',NULL),(240,1,3452,36,'product/36/3452','music/religious/christian///Great-Is-Thy-Faithfulness-0765762135505.html','catalog/product/view/id/36/category/3452',1,'',NULL),(241,1,3384,36,'product/36/3384','music/religious/christian//Great-Is-Thy-Faithfulness-0765762135505.html','catalog/product/view/id/36/category/3384',1,'',NULL),(242,1,4016,36,'product/36/4016','music/religious/christian/Great-Is-Thy-Faithfulness-0765762135505.html','catalog/product/view/id/36/category/4016',1,'',NULL),(243,1,4015,36,'product/36/4015','music/religious/Great-Is-Thy-Faithfulness-0765762135505.html','catalog/product/view/id/36/category/4015',1,'',NULL),(244,1,3944,36,'product/36/3944','music/Great-Is-Thy-Faithfulness-0765762135505.html','catalog/product/view/id/36/category/3944',1,'',NULL),(245,1,NULL,37,'product/37','A-Christmas-Portrait-0765762135703.html','catalog/product/view/id/37',1,'',NULL),(246,1,3454,37,'product/37/3454','music/religious/christian////A-Christmas-Portrait-0765762135703.html','catalog/product/view/id/37/category/3454',1,'',NULL),(247,1,3452,37,'product/37/3452','music/religious/christian///A-Christmas-Portrait-0765762135703.html','catalog/product/view/id/37/category/3452',1,'',NULL),(248,1,3384,37,'product/37/3384','music/religious/christian//A-Christmas-Portrait-0765762135703.html','catalog/product/view/id/37/category/3384',1,'',NULL),(249,1,4016,37,'product/37/4016','music/religious/christian/A-Christmas-Portrait-0765762135703.html','catalog/product/view/id/37/category/4016',1,'',NULL),(250,1,4015,37,'product/37/4015','music/religious/A-Christmas-Portrait-0765762135703.html','catalog/product/view/id/37/category/4015',1,'',NULL),(251,1,3944,37,'product/37/3944','music/A-Christmas-Portrait-0765762135703.html','catalog/product/view/id/37/category/3944',1,'',NULL),(252,1,NULL,38,'product/38','Praise-to-the-Lord,-the-Almighty-0765762136007.html','catalog/product/view/id/38',1,'',NULL),(253,1,3457,38,'product/38/3457','music/religious/hymns////Praise-to-the-Lord,-the-Almighty-0765762136007.html','catalog/product/view/id/38/category/3457',1,'',NULL),(254,1,3452,38,'product/38/3452','music/religious/hymns///Praise-to-the-Lord,-the-Almighty-0765762136007.html','catalog/product/view/id/38/category/3452',1,'',NULL),(255,1,3384,38,'product/38/3384','music/religious/hymns//Praise-to-the-Lord,-the-Almighty-0765762136007.html','catalog/product/view/id/38/category/3384',1,'',NULL),(256,1,4016,38,'product/38/4016','music/religious/hymns/Praise-to-the-Lord,-the-Almighty-0765762136007.html','catalog/product/view/id/38/category/4016',1,'',NULL),(257,1,4015,38,'product/38/4015','music/religious/Praise-to-the-Lord,-the-Almighty-0765762136007.html','catalog/product/view/id/38/category/4015',1,'',NULL),(258,1,3944,38,'product/38/3944','music/Praise-to-the-Lord,-the-Almighty-0765762136007.html','catalog/product/view/id/38/category/3944',1,'',NULL),(259,1,NULL,39,'product/39','Prelude-in-Classic-Style-0765762136403.html','catalog/product/view/id/39',1,'',NULL),(260,1,3454,39,'product/39/3454','music/religious/christian////Prelude-in-Classic-Style-0765762136403.html','catalog/product/view/id/39/category/3454',1,'',NULL),(261,1,3452,39,'product/39/3452','music/religious/christian///Prelude-in-Classic-Style-0765762136403.html','catalog/product/view/id/39/category/3452',1,'',NULL),(262,1,3384,39,'product/39/3384','music/religious/christian//Prelude-in-Classic-Style-0765762136403.html','catalog/product/view/id/39/category/3384',1,'',NULL),(263,1,4016,39,'product/39/4016','music/religious/christian/Prelude-in-Classic-Style-0765762136403.html','catalog/product/view/id/39/category/4016',1,'',NULL),(264,1,4015,39,'product/39/4015','music/religious/Prelude-in-Classic-Style-0765762136403.html','catalog/product/view/id/39/category/4015',1,'',NULL),(265,1,3944,39,'product/39/3944','music/Prelude-in-Classic-Style-0765762136403.html','catalog/product/view/id/39/category/3944',1,'',NULL),(266,1,NULL,40,'product/40','Go,-Tell-It-on-the-Mountain-0765762136502.html','catalog/product/view/id/40',1,'',NULL),(267,1,3457,40,'product/40/3457','music/religious/hymns////Go,-Tell-It-on-the-Mountain-0765762136502.html','catalog/product/view/id/40/category/3457',1,'',NULL),(268,1,3452,40,'product/40/3452','music/religious/hymns///Go,-Tell-It-on-the-Mountain-0765762136502.html','catalog/product/view/id/40/category/3452',1,'',NULL),(269,1,3384,40,'product/40/3384','music/religious/hymns//Go,-Tell-It-on-the-Mountain-0765762136502.html','catalog/product/view/id/40/category/3384',1,'',NULL),(270,1,4016,40,'product/40/4016','music/religious/hymns/Go,-Tell-It-on-the-Mountain-0765762136502.html','catalog/product/view/id/40/category/4016',1,'',NULL),(271,1,4015,40,'product/40/4015','music/religious/Go,-Tell-It-on-the-Mountain-0765762136502.html','catalog/product/view/id/40/category/4015',1,'',NULL),(272,1,3944,40,'product/40/3944','music/Go,-Tell-It-on-the-Mountain-0765762136502.html','catalog/product/view/id/40/category/3944',1,'',NULL),(273,1,NULL,41,'product/41','How-Deep-the-Fathers-Love-for-Us-0765762136809.html','catalog/product/view/id/41',1,'',NULL),(274,1,3455,41,'product/41/3455','music/religious/contemporary-christian////How-Deep-the-Fathers-Love-for-Us-0765762136809.html','catalog/product/view/id/41/category/3455',1,'',NULL),(275,1,3452,41,'product/41/3452','music/religious/contemporary-christian///How-Deep-the-Fathers-Love-for-Us-0765762136809.html','catalog/product/view/id/41/category/3452',1,'',NULL),(276,1,3384,41,'product/41/3384','music/religious/contemporary-christian//How-Deep-the-Fathers-Love-for-Us-0765762136809.html','catalog/product/view/id/41/category/3384',1,'',NULL),(277,1,4016,41,'product/41/4016','music/religious/contemporary-christian/How-Deep-the-Fathers-Love-for-Us-0765762136809.html','catalog/product/view/id/41/category/4016',1,'',NULL),(278,1,4015,41,'product/41/4015','music/religious/How-Deep-the-Fathers-Love-for-Us-0765762136809.html','catalog/product/view/id/41/category/4015',1,'',NULL),(279,1,3944,41,'product/41/3944','music/How-Deep-the-Fathers-Love-for-Us-0765762136809.html','catalog/product/view/id/41/category/3944',1,'',NULL),(280,1,NULL,42,'product/42','I-Bowed-on-My-Knees-and-Cried-Holy-0765762137004.html','catalog/product/view/id/42',1,'',NULL),(281,1,3456,42,'product/42/3456','music/religious/gospel////I-Bowed-on-My-Knees-and-Cried-Holy-0765762137004.html','catalog/product/view/id/42/category/3456',1,'',NULL),(282,1,3452,42,'product/42/3452','music/religious/gospel///I-Bowed-on-My-Knees-and-Cried-Holy-0765762137004.html','catalog/product/view/id/42/category/3452',1,'',NULL),(283,1,3384,42,'product/42/3384','music/religious/gospel//I-Bowed-on-My-Knees-and-Cried-Holy-0765762137004.html','catalog/product/view/id/42/category/3384',1,'',NULL),(284,1,4016,42,'product/42/4016','music/religious/gospel/I-Bowed-on-My-Knees-and-Cried-Holy-0765762137004.html','catalog/product/view/id/42/category/4016',1,'',NULL),(285,1,4015,42,'product/42/4015','music/religious/I-Bowed-on-My-Knees-and-Cried-Holy-0765762137004.html','catalog/product/view/id/42/category/4015',1,'',NULL),(286,1,3944,42,'product/42/3944','music/I-Bowed-on-My-Knees-and-Cried-Holy-0765762137004.html','catalog/product/view/id/42/category/3944',1,'',NULL),(287,1,NULL,43,'product/43','Ive-Been-Changed-0765762137103.html','catalog/product/view/id/43',1,'',NULL),(288,1,3456,43,'product/43/3456','music/religious/gospel////Ive-Been-Changed-0765762137103.html','catalog/product/view/id/43/category/3456',1,'',NULL),(289,1,3452,43,'product/43/3452','music/religious/gospel///Ive-Been-Changed-0765762137103.html','catalog/product/view/id/43/category/3452',1,'',NULL),(290,1,3384,43,'product/43/3384','music/religious/gospel//Ive-Been-Changed-0765762137103.html','catalog/product/view/id/43/category/3384',1,'',NULL),(291,1,4016,43,'product/43/4016','music/religious/gospel/Ive-Been-Changed-0765762137103.html','catalog/product/view/id/43/category/4016',1,'',NULL),(292,1,4015,43,'product/43/4015','music/religious/Ive-Been-Changed-0765762137103.html','catalog/product/view/id/43/category/4015',1,'',NULL),(293,1,3944,43,'product/43/3944','music/Ive-Been-Changed-0765762137103.html','catalog/product/view/id/43/category/3944',1,'',NULL),(294,1,NULL,44,'product/44','Jesus-Is-the-Answer-0765762137202.html','catalog/product/view/id/44',1,'',NULL),(295,1,3454,44,'product/44/3454','music/religious/christian////Jesus-Is-the-Answer-0765762137202.html','catalog/product/view/id/44/category/3454',1,'',NULL),(296,1,3452,44,'product/44/3452','music/religious/christian///Jesus-Is-the-Answer-0765762137202.html','catalog/product/view/id/44/category/3452',1,'',NULL),(297,1,3384,44,'product/44/3384','music/religious/christian//Jesus-Is-the-Answer-0765762137202.html','catalog/product/view/id/44/category/3384',1,'',NULL),(298,1,4016,44,'product/44/4016','music/religious/christian/Jesus-Is-the-Answer-0765762137202.html','catalog/product/view/id/44/category/4016',1,'',NULL),(299,1,4015,44,'product/44/4015','music/religious/Jesus-Is-the-Answer-0765762137202.html','catalog/product/view/id/44/category/4015',1,'',NULL),(300,1,3944,44,'product/44/3944','music/Jesus-Is-the-Answer-0765762137202.html','catalog/product/view/id/44/category/3944',1,'',NULL),(301,1,NULL,45,'product/45','Since-Jesus-Came-Into-My-Heart-0765762137301.html','catalog/product/view/id/45',1,'',NULL),(302,1,3457,45,'product/45/3457','music/religious/hymns////Since-Jesus-Came-Into-My-Heart-0765762137301.html','catalog/product/view/id/45/category/3457',1,'',NULL),(303,1,3452,45,'product/45/3452','music/religious/hymns///Since-Jesus-Came-Into-My-Heart-0765762137301.html','catalog/product/view/id/45/category/3452',1,'',NULL),(304,1,3384,45,'product/45/3384','music/religious/hymns//Since-Jesus-Came-Into-My-Heart-0765762137301.html','catalog/product/view/id/45/category/3384',1,'',NULL),(305,1,4016,45,'product/45/4016','music/religious/hymns/Since-Jesus-Came-Into-My-Heart-0765762137301.html','catalog/product/view/id/45/category/4016',1,'',NULL),(306,1,4015,45,'product/45/4015','music/religious/Since-Jesus-Came-Into-My-Heart-0765762137301.html','catalog/product/view/id/45/category/4015',1,'',NULL),(307,1,3944,45,'product/45/3944','music/Since-Jesus-Came-Into-My-Heart-0765762137301.html','catalog/product/view/id/45/category/3944',1,'',NULL),(308,1,NULL,46,'product/46','Blessed-Be-Your-Name-0765762139800.html','catalog/product/view/id/46',1,'',NULL),(309,1,3454,46,'product/46/3454','music/religious/christian/////Blessed-Be-Your-Name-0765762139800.html','catalog/product/view/id/46/category/3454',1,'',NULL),(310,1,3455,46,'product/46/3455','music/religious/christian////Blessed-Be-Your-Name-0765762139800.html','catalog/product/view/id/46/category/3455',1,'',NULL),(311,1,3452,46,'product/46/3452','music/religious/christian///Blessed-Be-Your-Name-0765762139800.html','catalog/product/view/id/46/category/3452',1,'',NULL),(312,1,3384,46,'product/46/3384','music/religious/christian//Blessed-Be-Your-Name-0765762139800.html','catalog/product/view/id/46/category/3384',1,'',NULL),(313,1,4016,46,'product/46/4016','music/religious/christian/Blessed-Be-Your-Name-0765762139800.html','catalog/product/view/id/46/category/4016',1,'',NULL),(314,1,4015,46,'product/46/4015','music/religious/Blessed-Be-Your-Name-0765762139800.html','catalog/product/view/id/46/category/4015',1,'',NULL),(315,1,3944,46,'product/46/3944','music/Blessed-Be-Your-Name-0765762139800.html','catalog/product/view/id/46/category/3944',1,'',NULL),(316,1,NULL,47,'product/47','God-Rest-Ye-Merry,-Gentlemen-0765762140103.html','catalog/product/view/id/47',1,'',NULL),(317,1,3457,47,'product/47/3457','music/religious/hymns////God-Rest-Ye-Merry,-Gentlemen-0765762140103.html','catalog/product/view/id/47/category/3457',1,'',NULL),(318,1,3452,47,'product/47/3452','music/religious/hymns///God-Rest-Ye-Merry,-Gentlemen-0765762140103.html','catalog/product/view/id/47/category/3452',1,'',NULL),(319,1,3384,47,'product/47/3384','music/religious/hymns//God-Rest-Ye-Merry,-Gentlemen-0765762140103.html','catalog/product/view/id/47/category/3384',1,'',NULL),(320,1,4016,47,'product/47/4016','music/religious/hymns/God-Rest-Ye-Merry,-Gentlemen-0765762140103.html','catalog/product/view/id/47/category/4016',1,'',NULL),(321,1,4015,47,'product/47/4015','music/religious/God-Rest-Ye-Merry,-Gentlemen-0765762140103.html','catalog/product/view/id/47/category/4015',1,'',NULL),(322,1,3944,47,'product/47/3944','music/God-Rest-Ye-Merry,-Gentlemen-0765762140103.html','catalog/product/view/id/47/category/3944',1,'',NULL),(323,1,NULL,48,'product/48','May-Jesus-Christ-Be-Praised-0765762140400.html','catalog/product/view/id/48',1,'',NULL),(324,1,3457,48,'product/48/3457','music/religious/hymns////May-Jesus-Christ-Be-Praised-0765762140400.html','catalog/product/view/id/48/category/3457',1,'',NULL),(325,1,3452,48,'product/48/3452','music/religious/hymns///May-Jesus-Christ-Be-Praised-0765762140400.html','catalog/product/view/id/48/category/3452',1,'',NULL),(326,1,3384,48,'product/48/3384','music/religious/hymns//May-Jesus-Christ-Be-Praised-0765762140400.html','catalog/product/view/id/48/category/3384',1,'',NULL),(327,1,4016,48,'product/48/4016','music/religious/hymns/May-Jesus-Christ-Be-Praised-0765762140400.html','catalog/product/view/id/48/category/4016',1,'',NULL),(328,1,4015,48,'product/48/4015','music/religious/May-Jesus-Christ-Be-Praised-0765762140400.html','catalog/product/view/id/48/category/4015',1,'',NULL),(329,1,3944,48,'product/48/3944','music/May-Jesus-Christ-Be-Praised-0765762140400.html','catalog/product/view/id/48/category/3944',1,'',NULL),(330,1,NULL,49,'product/49','Worthy!-the-Song-of-the-Ages:-An-Easter-Celebration-for-Any-Choir-0765762155008.html','catalog/product/view/id/49',1,'',NULL),(331,1,3454,49,'product/49/3454','music/religious/christian/Worthy!-the-Song-of-the-Ages:-An-Easter-Celebration-for-Any-Choir-0765762155008.html','catalog/product/view/id/49/category/3454',1,'',NULL),(332,1,3452,49,'product/49/3452','music/religious/Worthy!-the-Song-of-the-Ages:-An-Easter-Celebration-for-Any-Choir-0765762155008.html','catalog/product/view/id/49/category/3452',1,'',NULL),(333,1,3384,49,'product/49/3384','music/Worthy!-the-Song-of-the-Ages:-An-Easter-Celebration-for-Any-Choir-0765762155008.html','catalog/product/view/id/49/category/3384',1,'',NULL),(334,1,NULL,50,'product/50','African-Bass-Bible,-Volume-1-0796279109260.html','catalog/product/view/id/50',1,'',NULL),(335,1,3419,50,'product/50/3419','music/instruction-study/general/African-Bass-Bible,-Volume-1-0796279109260.html','catalog/product/view/id/50/category/3419',1,'',NULL),(336,1,3418,50,'product/50/3418','music/instruction-study/African-Bass-Bible,-Volume-1-0796279109260.html','catalog/product/view/id/50/category/3418',1,'',NULL),(337,1,3384,50,'product/50/3384','music/African-Bass-Bible,-Volume-1-0796279109260.html','catalog/product/view/id/50/category/3384',1,'',NULL),(338,1,NULL,51,'product/51','What-Is-a-Gas?-0978082568186.html','catalog/product/view/id/51',1,'',NULL),(339,1,2778,51,'product/51/2778','juvenile-nonfiction/science-nature/general///What-Is-a-Gas?-0978082568186.html','catalog/product/view/id/51/category/2778',1,'',NULL),(340,1,2777,51,'product/51/2777','juvenile-nonfiction/science-nature/general//What-Is-a-Gas?-0978082568186.html','catalog/product/view/id/51/category/2777',1,'',NULL),(341,1,2533,51,'product/51/2533','juvenile-nonfiction/science-nature/general/What-Is-a-Gas?-0978082568186.html','catalog/product/view/id/51/category/2533',1,'',NULL),(342,1,2532,51,'product/51/2532','juvenile-nonfiction/science-nature/What-Is-a-Gas?-0978082568186.html','catalog/product/view/id/51/category/2532',1,'',NULL),(343,1,2446,51,'product/51/2446','juvenile-nonfiction/What-Is-a-Gas?-0978082568186.html','catalog/product/view/id/51/category/2446',1,'',NULL),(344,1,NULL,52,'product/52','Denver-Broncos-0978089125351.html','catalog/product/view/id/52',1,'',NULL),(345,1,2851,52,'product/52/2851','juvenile-nonfiction/sports-recreation/football/Denver-Broncos-0978089125351.html','catalog/product/view/id/52/category/2851',1,'',NULL),(346,1,2843,52,'product/52/2843','juvenile-nonfiction/sports-recreation/Denver-Broncos-0978089125351.html','catalog/product/view/id/52/category/2843',1,'',NULL),(347,1,2446,52,'product/52/2446','juvenile-nonfiction/Denver-Broncos-0978089125351.html','catalog/product/view/id/52/category/2446',1,'',NULL),(348,1,NULL,53,'product/53','Afloat-and-Ashore-0978144380572.html','catalog/product/view/id/53',1,'',NULL),(349,1,1568,53,'product/53/1568','fiction/historical//Afloat-and-Ashore-0978144380572.html','catalog/product/view/id/53/category/1568',1,'',NULL),(350,1,1512,53,'product/53/1512','fiction/historical/Afloat-and-Ashore-0978144380572.html','catalog/product/view/id/53/category/1512',1,'',NULL),(351,1,1510,53,'product/53/1510','fiction/Afloat-and-Ashore-0978144380572.html','catalog/product/view/id/53/category/1510',1,'',NULL),(352,1,NULL,54,'product/54','Pride-and-Prejudice-1116090014687.html','catalog/product/view/id/54',1,'',NULL),(353,1,1540,54,'product/54/1540','fiction/classics/Pride-and-Prejudice-1116090014687.html','catalog/product/view/id/54/category/1540',1,'',NULL),(354,1,1510,54,'product/54/1510','fiction/Pride-and-Prejudice-1116090014687.html','catalog/product/view/id/54/category/1510',1,'',NULL),(355,1,NULL,55,'product/55','[Little-Doggie-Cun-and-Friends:-A-Pretty-Bow]-1200600710005.html','catalog/product/view/id/55',1,'',NULL),(356,1,2124,55,'product/55/2124','juvenile-fiction/animals/dogs/[Little-Doggie-Cun-and-Friends:-A-Pretty-Bow]-1200600710005.html','catalog/product/view/id/55/category/2124',1,'',NULL),(357,1,2113,55,'product/55/2113','juvenile-fiction/animals/[Little-Doggie-Cun-and-Friends:-A-Pretty-Bow]-1200600710005.html','catalog/product/view/id/55/category/2113',1,'',NULL),(358,1,2106,55,'product/55/2106','juvenile-fiction/[Little-Doggie-Cun-and-Friends:-A-Pretty-Bow]-1200600710005.html','catalog/product/view/id/55/category/2106',1,'',NULL),(359,1,NULL,56,'product/56','Peyton-Place-2010000001189.html','catalog/product/view/id/56',1,'',NULL),(360,1,1511,56,'product/56/1511','fiction/general/Peyton-Place-2010000001189.html','catalog/product/view/id/56/category/1511',1,'',NULL),(361,1,1510,56,'product/56/1510','fiction/Peyton-Place-2010000001189.html','catalog/product/view/id/56/category/1510',1,'',NULL),(362,1,NULL,57,'product/57','88-DAO-Tai-WAN-Ren-Zui-AI-Xia-Fan-Xiao-Cai-4711213292675.html','catalog/product/view/id/57',1,'',NULL),(363,1,1214,57,'product/57/1214','cooking/regional-ethnic/chinese/88-DAO-Tai-WAN-Ren-Zui-AI-Xia-Fan-Xiao-Cai-4711213292675.html','catalog/product/view/id/57/category/1214',1,'',NULL),(364,1,1196,57,'product/57/1196','cooking/regional-ethnic/88-DAO-Tai-WAN-Ren-Zui-AI-Xia-Fan-Xiao-Cai-4711213292675.html','catalog/product/view/id/57/category/1196',1,'',NULL),(365,1,1125,57,'product/57/1125','cooking/88-DAO-Tai-WAN-Ren-Zui-AI-Xia-Fan-Xiao-Cai-4711213292675.html','catalog/product/view/id/57/category/1125',1,'',NULL),(366,1,NULL,58,'product/58','Wheres-Spot,-Spot-Goes-to-the-Farm,-and-Spots-First-Walk-4713482004256.html','catalog/product/view/id/58',1,'',NULL),(367,1,2162,58,'product/58/2162','juvenile-fiction/classics/Wheres-Spot,-Spot-Goes-to-the-Farm,-and-Spots-First-Walk-4713482004256.html','catalog/product/view/id/58/category/2162',1,'',NULL),(368,1,2106,58,'product/58/2106','juvenile-fiction/Wheres-Spot,-Spot-Goes-to-the-Farm,-and-Spots-First-Walk-4713482004256.html','catalog/product/view/id/58/category/2106',1,'',NULL),(369,1,NULL,59,'product/59','Henry-Lees-Crime-Scene-Handbook-4717702066765.html','catalog/product/view/id/59',1,'',NULL),(370,1,4407,59,'product/59/4407','social-science/criminology/Henry-Lees-Crime-Scene-Handbook-4717702066765.html','catalog/product/view/id/59/category/4407',1,'',NULL),(371,1,4396,59,'product/59/4396','social-science/Henry-Lees-Crime-Scene-Handbook-4717702066765.html','catalog/product/view/id/59/category/4396',1,'',NULL),(372,1,NULL,60,'product/60','Michael-Jackson:-Life-of-a-Legend-1958-2009-4717702228606.html','catalog/product/view/id/60',1,'',NULL),(373,1,471,60,'product/60/471','biography-autobiography/entertainment-performing-arts/Michael-Jackson:-Life-of-a-Legend-1958-2009-4717702228606.html','catalog/product/view/id/60/category/471',1,'',NULL),(374,1,452,60,'product/60/452','biography-autobiography/Michael-Jackson:-Life-of-a-Legend-1958-2009-4717702228606.html','catalog/product/view/id/60/category/452',1,'',NULL),(375,1,NULL,61,'product/61','123-for-You-and-Me!-6006937084346.html','catalog/product/view/id/61',1,'',NULL),(376,1,3964,61,'product/61/3964','religion/biblical-meditations/general/123-for-You-and-Me!-6006937084346.html','catalog/product/view/id/61/category/3964',1,'',NULL),(377,1,3963,61,'product/61/3963','religion/biblical-meditations/123-for-You-and-Me!-6006937084346.html','catalog/product/view/id/61/category/3963',1,'',NULL),(378,1,3944,61,'product/61/3944','religion/123-for-You-and-Me!-6006937084346.html','catalog/product/view/id/61/category/3944',1,'',NULL),(379,1,NULL,62,'product/62','Daniel-in-the-Lions-Den-6006937084377.html','catalog/product/view/id/62',1,'',NULL),(380,1,2742,62,'product/62/2742','juvenile-nonfiction/religion/bible-stories/general/Daniel-in-the-Lions-Den-6006937084377.html','catalog/product/view/id/62/category/2742',1,'',NULL),(381,1,2741,62,'product/62/2741','juvenile-nonfiction/religion/bible-stories/Daniel-in-the-Lions-Den-6006937084377.html','catalog/product/view/id/62/category/2741',1,'',NULL),(382,1,2739,62,'product/62/2739','juvenile-nonfiction/religion/Daniel-in-the-Lions-Den-6006937084377.html','catalog/product/view/id/62/category/2739',1,'',NULL),(383,1,2446,62,'product/62/2446','juvenile-nonfiction/Daniel-in-the-Lions-Den-6006937084377.html','catalog/product/view/id/62/category/2446',1,'',NULL),(384,1,NULL,63,'product/63','Postsozialistischer-Wandel-Landlicher-Siedlungen-in-Mecklenburg-7835150933921.html','catalog/product/view/id/63',1,'',NULL),(385,1,1991,63,'product/63/1991','history/modern/20th-century////Postsozialistischer-Wandel-Landlicher-Siedlungen-in-Mecklenburg-7835150933921.html','catalog/product/view/id/63/category/1991',1,'',NULL),(386,1,1985,63,'product/63/1985','history/modern/20th-century///Postsozialistischer-Wandel-Landlicher-Siedlungen-in-Mecklenburg-7835150933921.html','catalog/product/view/id/63/category/1985',1,'',NULL),(387,1,1930,63,'product/63/1930','history/modern/20th-century//Postsozialistischer-Wandel-Landlicher-Siedlungen-in-Mecklenburg-7835150933921.html','catalog/product/view/id/63/category/1930',1,'',NULL),(388,1,1923,63,'product/63/1923','history/modern/20th-century/Postsozialistischer-Wandel-Landlicher-Siedlungen-in-Mecklenburg-7835150933921.html','catalog/product/view/id/63/category/1923',1,'',NULL),(389,1,1941,63,'product/63/1941','history/modern/Postsozialistischer-Wandel-Landlicher-Siedlungen-in-Mecklenburg-7835150933921.html','catalog/product/view/id/63/category/1941',1,'',NULL),(390,1,1880,63,'product/63/1880','history/Postsozialistischer-Wandel-Landlicher-Siedlungen-in-Mecklenburg-7835150933921.html','catalog/product/view/id/63/category/1880',1,'',NULL),(391,1,NULL,64,'product/64','Wings-of-War:-Fire-from-the-Sky-8033772895149.html','catalog/product/view/id/64',1,'',NULL),(392,1,1701,64,'product/64/1701','games/board/Wings-of-War:-Fire-from-the-Sky-8033772895149.html','catalog/product/view/id/64/category/1701',1,'',NULL),(393,1,1698,64,'product/64/1698','games/Wings-of-War:-Fire-from-the-Sky-8033772895149.html','catalog/product/view/id/64/category/1698',1,'',NULL),(394,1,NULL,65,'product/65','Hoang-Tu-Ham-Doc-Sach-(Chuyen-Ke-Cho-Chau-Nghe)-8932000113713.html','catalog/product/view/id/65',1,'',NULL),(395,1,2188,65,'product/65/2188','juvenile-fiction/fairy-tales-folklore/adaptations/Hoang-Tu-Ham-Doc-Sach-(Chuyen-Ke-Cho-Chau-Nghe)-8932000113713.html','catalog/product/view/id/65/category/2188',1,'',NULL),(396,1,2186,65,'product/65/2186','juvenile-fiction/fairy-tales-folklore/Hoang-Tu-Ham-Doc-Sach-(Chuyen-Ke-Cho-Chau-Nghe)-8932000113713.html','catalog/product/view/id/65/category/2186',1,'',NULL),(397,1,2106,65,'product/65/2106','juvenile-fiction/Hoang-Tu-Ham-Doc-Sach-(Chuyen-Ke-Cho-Chau-Nghe)-8932000113713.html','catalog/product/view/id/65/category/2106',1,'',NULL),(398,1,NULL,66,'product/66','The-Adventures-of-Batman-8934661181209.html','catalog/product/view/id/66',1,'',NULL),(399,1,2109,66,'product/66/2109','juvenile-fiction/action-adventure/general/The-Adventures-of-Batman-8934661181209.html','catalog/product/view/id/66/category/2109',1,'',NULL),(400,1,2108,66,'product/66/2108','juvenile-fiction/action-adventure/The-Adventures-of-Batman-8934661181209.html','catalog/product/view/id/66/category/2108',1,'',NULL),(401,1,2106,66,'product/66/2106','juvenile-fiction/The-Adventures-of-Batman-8934661181209.html','catalog/product/view/id/66/category/2106',1,'',NULL),(402,1,NULL,67,'product/67','Ut-Quyen-Va-Toi-8934974008972.html','catalog/product/view/id/67',1,'',NULL),(403,1,2366,67,'product/67/2366','juvenile-fiction/short-stories/Ut-Quyen-Va-Toi-8934974008972.html','catalog/product/view/id/67/category/2366',1,'',NULL),(404,1,2106,67,'product/67/2106','juvenile-fiction/Ut-Quyen-Va-Toi-8934974008972.html','catalog/product/view/id/67/category/2106',1,'',NULL),(405,1,NULL,68,'product/68','Harry-Potter-and-the-Prisoner-of-Azkaban-8934974048480.html','catalog/product/view/id/68',1,'',NULL),(406,1,2213,68,'product/68/2213','juvenile-fiction/fantasy-magic/Harry-Potter-and-the-Prisoner-of-Azkaban-8934974048480.html','catalog/product/view/id/68/category/2213',1,'',NULL),(407,1,2106,68,'product/68/2106','juvenile-fiction/Harry-Potter-and-the-Prisoner-of-Azkaban-8934974048480.html','catalog/product/view/id/68/category/2106',1,'',NULL),(408,1,NULL,69,'product/69','Harry-Potter-Va-Hoang-Tu-Lai-8934974048794.html','catalog/product/view/id/69',1,'',NULL),(409,1,2213,69,'product/69/2213','juvenile-fiction/fantasy-magic/Harry-Potter-Va-Hoang-Tu-Lai-8934974048794.html','catalog/product/view/id/69/category/2213',1,'',NULL),(410,1,2106,69,'product/69/2106','juvenile-fiction/Harry-Potter-Va-Hoang-Tu-Lai-8934974048794.html','catalog/product/view/id/69/category/2106',1,'',NULL),(411,1,NULL,70,'product/70','Inheritance-Series:-Eldest-8934974055143.html','catalog/product/view/id/70',1,'',NULL),(412,1,2213,70,'product/70/2213','juvenile-fiction/fantasy-magic/Inheritance-Series:-Eldest-8934974055143.html','catalog/product/view/id/70/category/2213',1,'',NULL),(413,1,2106,70,'product/70/2106','juvenile-fiction/Inheritance-Series:-Eldest-8934974055143.html','catalog/product/view/id/70/category/2106',1,'',NULL),(414,1,NULL,71,'product/71','The-Merchant-of-Death-8934974061670.html','catalog/product/view/id/71',1,'',NULL),(415,1,2365,71,'product/71/2365','juvenile-fiction/science-fiction/The-Merchant-of-Death-8934974061670.html','catalog/product/view/id/71/category/2365',1,'',NULL),(416,1,2106,71,'product/71/2106','juvenile-fiction/The-Merchant-of-Death-8934974061670.html','catalog/product/view/id/71/category/2106',1,'',NULL),(417,1,NULL,72,'product/72','The-Lost-City-of-Fear-8934974063308.html','catalog/product/view/id/72',1,'',NULL),(418,1,2365,72,'product/72/2365','juvenile-fiction/science-fiction/The-Lost-City-of-Fear-8934974063308.html','catalog/product/view/id/72/category/2365',1,'',NULL),(419,1,2106,72,'product/72/2106','juvenile-fiction/The-Lost-City-of-Fear-8934974063308.html','catalog/product/view/id/72/category/2106',1,'',NULL),(420,1,NULL,73,'product/73','The-Never-War-8934974068976.html','catalog/product/view/id/73',1,'',NULL),(421,1,2365,73,'product/73/2365','juvenile-fiction/science-fiction/The-Never-War-8934974068976.html','catalog/product/view/id/73/category/2365',1,'',NULL),(422,1,2106,73,'product/73/2106','juvenile-fiction/The-Never-War-8934974068976.html','catalog/product/view/id/73/category/2106',1,'',NULL),(423,1,NULL,74,'product/74','Pendragon:-The-Reality-Bug-8934974072720.html','catalog/product/view/id/74',1,'',NULL),(424,1,2365,74,'product/74/2365','juvenile-fiction/science-fiction/Pendragon:-The-Reality-Bug-8934974072720.html','catalog/product/view/id/74/category/2365',1,'',NULL),(425,1,2106,74,'product/74/2106','juvenile-fiction/Pendragon:-The-Reality-Bug-8934974072720.html','catalog/product/view/id/74/category/2106',1,'',NULL),(426,1,NULL,75,'product/75','Septimus-Heap-Book-Two:-Flyte-8934974072805.html','catalog/product/view/id/75',1,'',NULL),(427,1,2213,75,'product/75/2213','juvenile-fiction/fantasy-magic/Septimus-Heap-Book-Two:-Flyte-8934974072805.html','catalog/product/view/id/75/category/2213',1,'',NULL),(428,1,2106,75,'product/75/2106','juvenile-fiction/Septimus-Heap-Book-Two:-Flyte-8934974072805.html','catalog/product/view/id/75/category/2106',1,'',NULL),(429,1,NULL,76,'product/76','Les-Voies-de-la-Lumiere-8934974073109.html','catalog/product/view/id/76',1,'',NULL),(430,1,3480,76,'product/76/3480','nature/general/Les-Voies-de-la-Lumiere-8934974073109.html','catalog/product/view/id/76/category/3480',1,'',NULL),(431,1,3479,76,'product/76/3479','nature/Les-Voies-de-la-Lumiere-8934974073109.html','catalog/product/view/id/76/category/3479',1,'',NULL),(432,1,NULL,77,'product/77','Black-Water-8934974075912.html','catalog/product/view/id/77',1,'',NULL),(433,1,2365,77,'product/77/2365','juvenile-fiction/science-fiction/Black-Water-8934974075912.html','catalog/product/view/id/77/category/2365',1,'',NULL),(434,1,2106,77,'product/77/2106','juvenile-fiction/Black-Water-8934974075912.html','catalog/product/view/id/77/category/2106',1,'',NULL),(435,1,NULL,78,'product/78','Harry-Potter-and-the-Order-of-the-Phoenix-8934974076278.html','catalog/product/view/id/78',1,'',NULL),(436,1,2213,78,'product/78/2213','juvenile-fiction/fantasy-magic/Harry-Potter-and-the-Order-of-the-Phoenix-8934974076278.html','catalog/product/view/id/78/category/2213',1,'',NULL),(437,1,2106,78,'product/78/2106','juvenile-fiction/Harry-Potter-and-the-Order-of-the-Phoenix-8934974076278.html','catalog/product/view/id/78/category/2106',1,'',NULL),(438,1,NULL,79,'product/79','Harry-Potter-and-the-Goblet-of-Fire-8934974076797.html','catalog/product/view/id/79',1,'',NULL),(439,1,2213,79,'product/79/2213','juvenile-fiction/fantasy-magic/Harry-Potter-and-the-Goblet-of-Fire-8934974076797.html','catalog/product/view/id/79/category/2213',1,'',NULL),(440,1,2106,79,'product/79/2106','juvenile-fiction/Harry-Potter-and-the-Goblet-of-Fire-8934974076797.html','catalog/product/view/id/79/category/2106',1,'',NULL),(441,1,NULL,80,'product/80','Harry-Potter-and-the-Sorcerers-Stone-8934974076803.html','catalog/product/view/id/80',1,'',NULL),(442,1,2213,80,'product/80/2213','juvenile-fiction/fantasy-magic/Harry-Potter-and-the-Sorcerers-Stone-8934974076803.html','catalog/product/view/id/80/category/2213',1,'',NULL),(443,1,2106,80,'product/80/2106','juvenile-fiction/Harry-Potter-and-the-Sorcerers-Stone-8934974076803.html','catalog/product/view/id/80/category/2106',1,'',NULL),(444,1,NULL,81,'product/81','Inheritance-Series:-Eragon-8934974076933.html','catalog/product/view/id/81',1,'',NULL),(445,1,2213,81,'product/81/2213','juvenile-fiction/fantasy-magic/Inheritance-Series:-Eragon-8934974076933.html','catalog/product/view/id/81/category/2213',1,'',NULL),(446,1,2106,81,'product/81/2106','juvenile-fiction/Inheritance-Series:-Eragon-8934974076933.html','catalog/product/view/id/81/category/2106',1,'',NULL),(447,1,NULL,82,'product/82','Harry-Potter-and-the-Deathly-Hallows-8934974076995.html','catalog/product/view/id/82',1,'',NULL),(448,1,2213,82,'product/82/2213','juvenile-fiction/fantasy-magic/Harry-Potter-and-the-Deathly-Hallows-8934974076995.html','catalog/product/view/id/82/category/2213',1,'',NULL),(449,1,2106,82,'product/82/2106','juvenile-fiction/Harry-Potter-and-the-Deathly-Hallows-8934974076995.html','catalog/product/view/id/82/category/2106',1,'',NULL),(450,1,NULL,83,'product/83','The-Code-Book:-The-Science-of-Secrecy-from-Ancient-Egypt-to-Quantum-Cryotpgraphy-8934974077657.html','catalog/product/view/id/83',1,'',NULL),(451,1,618,83,'product/83/618','business-economics/business-writing///The-Code-Book:-The-Science-of-Secrecy-from-Ancient-Egypt-to-Quantum-Cryotpgraphy-8934974077657.html','catalog/product/view/id/83/category/618',1,'',NULL),(452,1,597,83,'product/83/597','business-economics/business-writing//The-Code-Book:-The-Science-of-Secrecy-from-Ancient-Egypt-to-Quantum-Cryotpgraphy-8934974077657.html','catalog/product/view/id/83/category/597',1,'',NULL),(453,1,3480,83,'product/83/3480','business-economics/business-writing/The-Code-Book:-The-Science-of-Secrecy-from-Ancient-Egypt-to-Quantum-Cryotpgraphy-8934974077657.html','catalog/product/view/id/83/category/3480',1,'',NULL),(454,1,3479,83,'product/83/3479','business-economics/The-Code-Book:-The-Science-of-Secrecy-from-Ancient-Egypt-to-Quantum-Cryotpgraphy-8934974077657.html','catalog/product/view/id/83/category/3479',1,'',NULL),(455,1,NULL,84,'product/84','Bay-Nang-Con-Gai-Cua-Eva-8934974077671.html','catalog/product/view/id/84',1,'',NULL),(456,1,4300,84,'product/84/4300','science/life-sciences/evolution/human/////Bay-Nang-Con-Gai-Cua-Eva-8934974077671.html','catalog/product/view/id/84/category/4300',1,'',NULL),(457,1,4299,84,'product/84/4299','science/life-sciences/evolution/human////Bay-Nang-Con-Gai-Cua-Eva-8934974077671.html','catalog/product/view/id/84/category/4299',1,'',NULL),(458,1,4301,84,'product/84/4301','science/life-sciences/evolution/human///Bay-Nang-Con-Gai-Cua-Eva-8934974077671.html','catalog/product/view/id/84/category/4301',1,'',NULL),(459,1,4280,84,'product/84/4280','science/life-sciences/evolution/human//Bay-Nang-Con-Gai-Cua-Eva-8934974077671.html','catalog/product/view/id/84/category/4280',1,'',NULL),(460,1,4240,84,'product/84/4240','science/life-sciences/evolution/human/Bay-Nang-Con-Gai-Cua-Eva-8934974077671.html','catalog/product/view/id/84/category/4240',1,'',NULL),(461,1,4403,84,'product/84/4403','science/life-sciences/evolution/Bay-Nang-Con-Gai-Cua-Eva-8934974077671.html','catalog/product/view/id/84/category/4403',1,'',NULL),(462,1,4400,84,'product/84/4400','science/life-sciences/Bay-Nang-Con-Gai-Cua-Eva-8934974077671.html','catalog/product/view/id/84/category/4400',1,'',NULL),(463,1,4396,84,'product/84/4396','science/Bay-Nang-Con-Gai-Cua-Eva-8934974077671.html','catalog/product/view/id/84/category/4396',1,'',NULL),(464,1,NULL,85,'product/85','Harry-Potter-and-the-Chamber-of-Secrets-8934974078258.html','catalog/product/view/id/85',1,'',NULL),(465,1,2213,85,'product/85/2213','juvenile-fiction/fantasy-magic/Harry-Potter-and-the-Chamber-of-Secrets-8934974078258.html','catalog/product/view/id/85/category/2213',1,'',NULL),(466,1,2106,85,'product/85/2106','juvenile-fiction/Harry-Potter-and-the-Chamber-of-Secrets-8934974078258.html','catalog/product/view/id/85/category/2106',1,'',NULL),(467,1,NULL,86,'product/86','Inheritance-Series:-Eragon-8934974079446.html','catalog/product/view/id/86',1,'',NULL),(468,1,2213,86,'product/86/2213','juvenile-fiction/fantasy-magic/Inheritance-Series:-Eragon-8934974079446.html','catalog/product/view/id/86/category/2213',1,'',NULL),(469,1,2106,86,'product/86/2106','juvenile-fiction/Inheritance-Series:-Eragon-8934974079446.html','catalog/product/view/id/86/category/2106',1,'',NULL),(470,1,NULL,87,'product/87','Twilight-8934974080336.html','catalog/product/view/id/87',1,'',NULL),(471,1,2213,87,'product/87/2213','juvenile-fiction/fantasy-magic/Twilight-8934974080336.html','catalog/product/view/id/87/category/2213',1,'',NULL),(472,1,2106,87,'product/87/2106','juvenile-fiction/Twilight-8934974080336.html','catalog/product/view/id/87/category/2106',1,'',NULL),(473,1,NULL,88,'product/88','Trang-Non-8934974081067.html','catalog/product/view/id/88',1,'',NULL),(474,1,2213,88,'product/88/2213','juvenile-fiction/fantasy-magic/Trang-Non-8934974081067.html','catalog/product/view/id/88/category/2213',1,'',NULL),(475,1,2106,88,'product/88/2106','juvenile-fiction/Trang-Non-8934974081067.html','catalog/product/view/id/88/category/2106',1,'',NULL),(476,1,NULL,89,'product/89','Brisingr-8934974082910.html','catalog/product/view/id/89',1,'',NULL),(477,1,2213,89,'product/89/2213','juvenile-fiction/fantasy-magic/Brisingr-8934974082910.html','catalog/product/view/id/89/category/2213',1,'',NULL),(478,1,2106,89,'product/89/2106','juvenile-fiction/Brisingr-8934974082910.html','catalog/product/view/id/89/category/2106',1,'',NULL),(479,1,NULL,90,'product/90','The-Tales-of-Beedle-the-Bard-8934974082927.html','catalog/product/view/id/90',1,'',NULL),(480,1,2213,90,'product/90/2213','juvenile-fiction/fantasy-magic/The-Tales-of-Beedle-the-Bard-8934974082927.html','catalog/product/view/id/90/category/2213',1,'',NULL),(481,1,2106,90,'product/90/2106','juvenile-fiction/The-Tales-of-Beedle-the-Bard-8934974082927.html','catalog/product/view/id/90/category/2106',1,'',NULL),(482,1,NULL,91,'product/91','Twilight:-Eclipse-8934974085911.html','catalog/product/view/id/91',1,'',NULL),(483,1,2213,91,'product/91/2213','juvenile-fiction/fantasy-magic/Twilight:-Eclipse-8934974085911.html','catalog/product/view/id/91/category/2213',1,'',NULL),(484,1,2106,91,'product/91/2106','juvenile-fiction/Twilight:-Eclipse-8934974085911.html','catalog/product/view/id/91/category/2106',1,'',NULL),(485,1,NULL,92,'product/92','Annies-Baby-8934974086246.html','catalog/product/view/id/92',1,'',NULL),(486,1,2384,92,'product/92/2384','juvenile-fiction/social-issues/pregnancy/Annies-Baby-8934974086246.html','catalog/product/view/id/92/category/2384',1,'',NULL),(487,1,2367,92,'product/92/2367','juvenile-fiction/social-issues/Annies-Baby-8934974086246.html','catalog/product/view/id/92/category/2367',1,'',NULL),(488,1,2106,92,'product/92/2106','juvenile-fiction/Annies-Baby-8934974086246.html','catalog/product/view/id/92/category/2106',1,'',NULL),(489,1,NULL,93,'product/93','Tunnels-8934974089780.html','catalog/product/view/id/93',1,'',NULL),(490,1,1615,93,'product/93/1615','fiction/science-fiction/adventure/Tunnels-8934974089780.html','catalog/product/view/id/93/category/1615',1,'',NULL),(491,1,1613,93,'product/93/1613','fiction/science-fiction/Tunnels-8934974089780.html','catalog/product/view/id/93/category/1613',1,'',NULL),(492,1,1510,93,'product/93/1510','fiction/Tunnels-8934974089780.html','catalog/product/view/id/93/category/1510',1,'',NULL),(493,1,NULL,94,'product/94','Eq-Inmuljeon-Thomas-Alva-Edison-8935036602206.html','catalog/product/view/id/94',1,'',NULL),(494,1,2154,94,'product/94/2154','juvenile-fiction/biographical/general/Eq-Inmuljeon-Thomas-Alva-Edison-8935036602206.html','catalog/product/view/id/94/category/2154',1,'',NULL),(495,1,2153,94,'product/94/2153','juvenile-fiction/biographical/Eq-Inmuljeon-Thomas-Alva-Edison-8935036602206.html','catalog/product/view/id/94/category/2153',1,'',NULL),(496,1,2106,94,'product/94/2106','juvenile-fiction/Eq-Inmuljeon-Thomas-Alva-Edison-8935036602206.html','catalog/product/view/id/94/category/2106',1,'',NULL),(497,1,NULL,95,'product/95','Eq-Inmuljeon-Isaac-Newton-8935036602213.html','catalog/product/view/id/95',1,'',NULL),(498,1,2154,95,'product/95/2154','juvenile-fiction/biographical/general/Eq-Inmuljeon-Isaac-Newton-8935036602213.html','catalog/product/view/id/95/category/2154',1,'',NULL),(499,1,2153,95,'product/95/2153','juvenile-fiction/biographical/Eq-Inmuljeon-Isaac-Newton-8935036602213.html','catalog/product/view/id/95/category/2153',1,'',NULL),(500,1,2106,95,'product/95/2106','juvenile-fiction/Eq-Inmuljeon-Isaac-Newton-8935036602213.html','catalog/product/view/id/95/category/2106',1,'',NULL),(501,1,NULL,96,'product/96','Eq-Inmuljeon-Napoleon-Bonaparte-8935036602220.html','catalog/product/view/id/96',1,'',NULL),(502,1,2154,96,'product/96/2154','juvenile-fiction/biographical/general/Eq-Inmuljeon-Napoleon-Bonaparte-8935036602220.html','catalog/product/view/id/96/category/2154',1,'',NULL),(503,1,2153,96,'product/96/2153','juvenile-fiction/biographical/Eq-Inmuljeon-Napoleon-Bonaparte-8935036602220.html','catalog/product/view/id/96/category/2153',1,'',NULL),(504,1,2106,96,'product/96/2106','juvenile-fiction/Eq-Inmuljeon-Napoleon-Bonaparte-8935036602220.html','catalog/product/view/id/96/category/2106',1,'',NULL),(505,1,NULL,97,'product/97','Eq-Inmuljeon-Alfred-Bernhard-Nobel-8935036602244.html','catalog/product/view/id/97',1,'',NULL),(506,1,2154,97,'product/97/2154','juvenile-fiction/biographical/general/Eq-Inmuljeon-Alfred-Bernhard-Nobel-8935036602244.html','catalog/product/view/id/97/category/2154',1,'',NULL),(507,1,2153,97,'product/97/2153','juvenile-fiction/biographical/Eq-Inmuljeon-Alfred-Bernhard-Nobel-8935036602244.html','catalog/product/view/id/97/category/2153',1,'',NULL),(508,1,2106,97,'product/97/2106','juvenile-fiction/Eq-Inmuljeon-Alfred-Bernhard-Nobel-8935036602244.html','catalog/product/view/id/97/category/2106',1,'',NULL),(509,1,NULL,98,'product/98','Eq-Inmuljeon-Jean-Henri-Fabre-8935036602251.html','catalog/product/view/id/98',1,'',NULL),(510,1,2154,98,'product/98/2154','juvenile-fiction/biographical/general/Eq-Inmuljeon-Jean-Henri-Fabre-8935036602251.html','catalog/product/view/id/98/category/2154',1,'',NULL),(511,1,2153,98,'product/98/2153','juvenile-fiction/biographical/Eq-Inmuljeon-Jean-Henri-Fabre-8935036602251.html','catalog/product/view/id/98/category/2153',1,'',NULL),(512,1,2106,98,'product/98/2106','juvenile-fiction/Eq-Inmuljeon-Jean-Henri-Fabre-8935036602251.html','catalog/product/view/id/98/category/2106',1,'',NULL),(513,1,NULL,99,'product/99','Eq-Inmuljeon-Marie-Curie-8935036602268.html','catalog/product/view/id/99',1,'',NULL),(514,1,2154,99,'product/99/2154','juvenile-fiction/biographical/general/Eq-Inmuljeon-Marie-Curie-8935036602268.html','catalog/product/view/id/99/category/2154',1,'',NULL),(515,1,2153,99,'product/99/2153','juvenile-fiction/biographical/Eq-Inmuljeon-Marie-Curie-8935036602268.html','catalog/product/view/id/99/category/2153',1,'',NULL),(516,1,2106,99,'product/99/2106','juvenile-fiction/Eq-Inmuljeon-Marie-Curie-8935036602268.html','catalog/product/view/id/99/category/2106',1,'',NULL),(517,1,NULL,100,'product/100','Eq-Inmuljeon-Helen-Adams-Keller-8935036602275.html','catalog/product/view/id/100',1,'',NULL),(518,1,2154,100,'product/100/2154','juvenile-fiction/biographical/general/Eq-Inmuljeon-Helen-Adams-Keller-8935036602275.html','catalog/product/view/id/100/category/2154',1,'',NULL),(519,1,2153,100,'product/100/2153','juvenile-fiction/biographical/Eq-Inmuljeon-Helen-Adams-Keller-8935036602275.html','catalog/product/view/id/100/category/2153',1,'',NULL),(520,1,2106,100,'product/100/2106','juvenile-fiction/Eq-Inmuljeon-Helen-Adams-Keller-8935036602275.html','catalog/product/view/id/100/category/2106',1,'',NULL);
/*!40000 ALTER TABLE `core_url_rewrite` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_website`
--

DROP TABLE IF EXISTS `core_website`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_website` (
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='Websites';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_website`
--

LOCK TABLES `core_website` WRITE;
/*!40000 ALTER TABLE `core_website` DISABLE KEYS */;
INSERT INTO `core_website` VALUES (0,'admin','Admin',0,0,0),(1,'base','Main Website',0,1,1);
/*!40000 ALTER TABLE `core_website` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cron_schedule`
--

DROP TABLE IF EXISTS `cron_schedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cron_schedule` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cron_schedule`
--

LOCK TABLES `cron_schedule` WRITE;
/*!40000 ALTER TABLE `cron_schedule` DISABLE KEYS */;
/*!40000 ALTER TABLE `cron_schedule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer_address_entity`
--

DROP TABLE IF EXISTS `customer_address_entity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customer_address_entity` (
  `entity_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `entity_type_id` smallint(8) unsigned NOT NULL DEFAULT '0',
  `attribute_set_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `increment_id` varchar(50) NOT NULL DEFAULT '',
  `parent_id` int(10) unsigned DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `is_active` tinyint(1) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`entity_id`),
  KEY `FK_CUSTOMER_ADDRESS_CUSTOMER_ID` (`parent_id`),
  CONSTRAINT `FK_CUSTOMER_ADDRESS_CUSTOMER_ID` FOREIGN KEY (`parent_id`) REFERENCES `customer_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='Customer Address Entities';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer_address_entity`
--

LOCK TABLES `customer_address_entity` WRITE;
/*!40000 ALTER TABLE `customer_address_entity` DISABLE KEYS */;
/*!40000 ALTER TABLE `customer_address_entity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer_address_entity_datetime`
--

DROP TABLE IF EXISTS `customer_address_entity_datetime`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customer_address_entity_datetime` (
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
  KEY `IDX_VALUE` (`entity_id`,`attribute_id`,`value`),
  CONSTRAINT `FK_CUSTOMER_ADDRESS_DATETIME_ATTRIBUTE` FOREIGN KEY (`attribute_id`) REFERENCES `eav_attribute` (`attribute_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CUSTOMER_ADDRESS_DATETIME_ENTITY` FOREIGN KEY (`entity_id`) REFERENCES `customer_address_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CUSTOMER_ADDRESS_DATETIME_ENTITY_TYPE` FOREIGN KEY (`entity_type_id`) REFERENCES `eav_entity_type` (`entity_type_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer_address_entity_datetime`
--

LOCK TABLES `customer_address_entity_datetime` WRITE;
/*!40000 ALTER TABLE `customer_address_entity_datetime` DISABLE KEYS */;
/*!40000 ALTER TABLE `customer_address_entity_datetime` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer_address_entity_decimal`
--

DROP TABLE IF EXISTS `customer_address_entity_decimal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customer_address_entity_decimal` (
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
  KEY `IDX_VALUE` (`entity_id`,`attribute_id`,`value`),
  CONSTRAINT `FK_CUSTOMER_ADDRESS_DECIMAL_ATTRIBUTE` FOREIGN KEY (`attribute_id`) REFERENCES `eav_attribute` (`attribute_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CUSTOMER_ADDRESS_DECIMAL_ENTITY` FOREIGN KEY (`entity_id`) REFERENCES `customer_address_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CUSTOMER_ADDRESS_DECIMAL_ENTITY_TYPE` FOREIGN KEY (`entity_type_id`) REFERENCES `eav_entity_type` (`entity_type_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer_address_entity_decimal`
--

LOCK TABLES `customer_address_entity_decimal` WRITE;
/*!40000 ALTER TABLE `customer_address_entity_decimal` DISABLE KEYS */;
/*!40000 ALTER TABLE `customer_address_entity_decimal` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer_address_entity_int`
--

DROP TABLE IF EXISTS `customer_address_entity_int`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customer_address_entity_int` (
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
  KEY `IDX_VALUE` (`entity_id`,`attribute_id`,`value`),
  CONSTRAINT `FK_CUSTOMER_ADDRESS_INT_ATTRIBUTE` FOREIGN KEY (`attribute_id`) REFERENCES `eav_attribute` (`attribute_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CUSTOMER_ADDRESS_INT_ENTITY` FOREIGN KEY (`entity_id`) REFERENCES `customer_address_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CUSTOMER_ADDRESS_INT_ENTITY_TYPE` FOREIGN KEY (`entity_type_id`) REFERENCES `eav_entity_type` (`entity_type_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer_address_entity_int`
--

LOCK TABLES `customer_address_entity_int` WRITE;
/*!40000 ALTER TABLE `customer_address_entity_int` DISABLE KEYS */;
/*!40000 ALTER TABLE `customer_address_entity_int` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer_address_entity_text`
--

DROP TABLE IF EXISTS `customer_address_entity_text`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customer_address_entity_text` (
  `value_id` int(11) NOT NULL AUTO_INCREMENT,
  `entity_type_id` smallint(8) unsigned NOT NULL DEFAULT '0',
  `attribute_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `entity_id` int(10) unsigned NOT NULL DEFAULT '0',
  `value` text NOT NULL,
  PRIMARY KEY (`value_id`),
  UNIQUE KEY `IDX_ATTRIBUTE_VALUE` (`entity_id`,`attribute_id`),
  KEY `FK_CUSTOMER_ADDRESS_TEXT_ENTITY_TYPE` (`entity_type_id`),
  KEY `FK_CUSTOMER_ADDRESS_TEXT_ATTRIBUTE` (`attribute_id`),
  KEY `FK_CUSTOMER_ADDRESS_TEXT_ENTITY` (`entity_id`),
  CONSTRAINT `FK_CUSTOMER_ADDRESS_TEXT_ATTRIBUTE` FOREIGN KEY (`attribute_id`) REFERENCES `eav_attribute` (`attribute_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CUSTOMER_ADDRESS_TEXT_ENTITY` FOREIGN KEY (`entity_id`) REFERENCES `customer_address_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CUSTOMER_ADDRESS_TEXT_ENTITY_TYPE` FOREIGN KEY (`entity_type_id`) REFERENCES `eav_entity_type` (`entity_type_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer_address_entity_text`
--

LOCK TABLES `customer_address_entity_text` WRITE;
/*!40000 ALTER TABLE `customer_address_entity_text` DISABLE KEYS */;
/*!40000 ALTER TABLE `customer_address_entity_text` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer_address_entity_varchar`
--

DROP TABLE IF EXISTS `customer_address_entity_varchar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customer_address_entity_varchar` (
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
  KEY `IDX_VALUE` (`entity_id`,`attribute_id`,`value`),
  CONSTRAINT `FK_CUSTOMER_ADDRESS_VARCHAR_ATTRIBUTE` FOREIGN KEY (`attribute_id`) REFERENCES `eav_attribute` (`attribute_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CUSTOMER_ADDRESS_VARCHAR_ENTITY` FOREIGN KEY (`entity_id`) REFERENCES `customer_address_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CUSTOMER_ADDRESS_VARCHAR_ENTITY_TYPE` FOREIGN KEY (`entity_type_id`) REFERENCES `eav_entity_type` (`entity_type_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer_address_entity_varchar`
--

LOCK TABLES `customer_address_entity_varchar` WRITE;
/*!40000 ALTER TABLE `customer_address_entity_varchar` DISABLE KEYS */;
/*!40000 ALTER TABLE `customer_address_entity_varchar` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer_entity`
--

DROP TABLE IF EXISTS `customer_entity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customer_entity` (
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
  KEY `FK_CUSTOMER_WEBSITE` (`website_id`),
  CONSTRAINT `FK_CUSTOMER_ENTITY_STORE` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `FK_CUSTOMER_WEBSITE` FOREIGN KEY (`website_id`) REFERENCES `core_website` (`website_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='Customer Entityies';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer_entity`
--

LOCK TABLES `customer_entity` WRITE;
/*!40000 ALTER TABLE `customer_entity` DISABLE KEYS */;
/*!40000 ALTER TABLE `customer_entity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer_entity_datetime`
--

DROP TABLE IF EXISTS `customer_entity_datetime`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customer_entity_datetime` (
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
  KEY `IDX_VALUE` (`entity_id`,`attribute_id`,`value`),
  CONSTRAINT `FK_CUSTOMER_DATETIME_ATTRIBUTE` FOREIGN KEY (`attribute_id`) REFERENCES `eav_attribute` (`attribute_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CUSTOMER_DATETIME_ENTITY` FOREIGN KEY (`entity_id`) REFERENCES `customer_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CUSTOMER_DATETIME_ENTITY_TYPE` FOREIGN KEY (`entity_type_id`) REFERENCES `eav_entity_type` (`entity_type_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer_entity_datetime`
--

LOCK TABLES `customer_entity_datetime` WRITE;
/*!40000 ALTER TABLE `customer_entity_datetime` DISABLE KEYS */;
/*!40000 ALTER TABLE `customer_entity_datetime` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer_entity_decimal`
--

DROP TABLE IF EXISTS `customer_entity_decimal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customer_entity_decimal` (
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
  KEY `IDX_VALUE` (`entity_id`,`attribute_id`,`value`),
  CONSTRAINT `FK_CUSTOMER_DECIMAL_ATTRIBUTE` FOREIGN KEY (`attribute_id`) REFERENCES `eav_attribute` (`attribute_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CUSTOMER_DECIMAL_ENTITY` FOREIGN KEY (`entity_id`) REFERENCES `customer_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CUSTOMER_DECIMAL_ENTITY_TYPE` FOREIGN KEY (`entity_type_id`) REFERENCES `eav_entity_type` (`entity_type_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer_entity_decimal`
--

LOCK TABLES `customer_entity_decimal` WRITE;
/*!40000 ALTER TABLE `customer_entity_decimal` DISABLE KEYS */;
/*!40000 ALTER TABLE `customer_entity_decimal` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer_entity_int`
--

DROP TABLE IF EXISTS `customer_entity_int`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customer_entity_int` (
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
  KEY `IDX_VALUE` (`entity_id`,`attribute_id`,`value`),
  CONSTRAINT `FK_CUSTOMER_INT_ATTRIBUTE` FOREIGN KEY (`attribute_id`) REFERENCES `eav_attribute` (`attribute_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CUSTOMER_INT_ENTITY` FOREIGN KEY (`entity_id`) REFERENCES `customer_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CUSTOMER_INT_ENTITY_TYPE` FOREIGN KEY (`entity_type_id`) REFERENCES `eav_entity_type` (`entity_type_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer_entity_int`
--

LOCK TABLES `customer_entity_int` WRITE;
/*!40000 ALTER TABLE `customer_entity_int` DISABLE KEYS */;
/*!40000 ALTER TABLE `customer_entity_int` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer_entity_text`
--

DROP TABLE IF EXISTS `customer_entity_text`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customer_entity_text` (
  `value_id` int(11) NOT NULL AUTO_INCREMENT,
  `entity_type_id` smallint(8) unsigned NOT NULL DEFAULT '0',
  `attribute_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `entity_id` int(10) unsigned NOT NULL DEFAULT '0',
  `value` text NOT NULL,
  PRIMARY KEY (`value_id`),
  UNIQUE KEY `IDX_ATTRIBUTE_VALUE` (`entity_id`,`attribute_id`),
  KEY `FK_CUSTOMER_TEXT_ENTITY_TYPE` (`entity_type_id`),
  KEY `FK_CUSTOMER_TEXT_ATTRIBUTE` (`attribute_id`),
  KEY `FK_CUSTOMER_TEXT_ENTITY` (`entity_id`),
  CONSTRAINT `FK_CUSTOMER_TEXT_ATTRIBUTE` FOREIGN KEY (`attribute_id`) REFERENCES `eav_attribute` (`attribute_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CUSTOMER_TEXT_ENTITY` FOREIGN KEY (`entity_id`) REFERENCES `customer_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CUSTOMER_TEXT_ENTITY_TYPE` FOREIGN KEY (`entity_type_id`) REFERENCES `eav_entity_type` (`entity_type_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer_entity_text`
--

LOCK TABLES `customer_entity_text` WRITE;
/*!40000 ALTER TABLE `customer_entity_text` DISABLE KEYS */;
/*!40000 ALTER TABLE `customer_entity_text` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer_entity_varchar`
--

DROP TABLE IF EXISTS `customer_entity_varchar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customer_entity_varchar` (
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
  KEY `IDX_VALUE` (`entity_id`,`attribute_id`,`value`),
  CONSTRAINT `FK_CUSTOMER_VARCHAR_ATTRIBUTE` FOREIGN KEY (`attribute_id`) REFERENCES `eav_attribute` (`attribute_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CUSTOMER_VARCHAR_ENTITY` FOREIGN KEY (`entity_id`) REFERENCES `customer_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CUSTOMER_VARCHAR_ENTITY_TYPE` FOREIGN KEY (`entity_type_id`) REFERENCES `eav_entity_type` (`entity_type_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer_entity_varchar`
--

LOCK TABLES `customer_entity_varchar` WRITE;
/*!40000 ALTER TABLE `customer_entity_varchar` DISABLE KEYS */;
/*!40000 ALTER TABLE `customer_entity_varchar` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer_group`
--

DROP TABLE IF EXISTS `customer_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customer_group` (
  `customer_group_id` smallint(3) unsigned NOT NULL AUTO_INCREMENT,
  `customer_group_code` varchar(32) NOT NULL DEFAULT '',
  `tax_class_id` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`customer_group_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='Customer groups';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer_group`
--

LOCK TABLES `customer_group` WRITE;
/*!40000 ALTER TABLE `customer_group` DISABLE KEYS */;
INSERT INTO `customer_group` VALUES (0,'NOT LOGGED IN',3),(1,'General',3),(2,'Wholesale',3),(3,'Retailer',3);
/*!40000 ALTER TABLE `customer_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dataflow_batch`
--

DROP TABLE IF EXISTS `dataflow_batch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dataflow_batch` (
  `batch_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `profile_id` int(10) unsigned NOT NULL DEFAULT '0',
  `store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `adapter` varchar(128) DEFAULT NULL,
  `params` text,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`batch_id`),
  KEY `FK_DATAFLOW_BATCH_PROFILE` (`profile_id`),
  KEY `FK_DATAFLOW_BATCH_STORE` (`store_id`),
  KEY `IDX_CREATED_AT` (`created_at`),
  CONSTRAINT `FK_DATAFLOW_BATCH_PROFILE` FOREIGN KEY (`profile_id`) REFERENCES `dataflow_profile` (`profile_id`) ON DELETE CASCADE,
  CONSTRAINT `FK_DATAFLOW_BATCH_STORE` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dataflow_batch`
--

LOCK TABLES `dataflow_batch` WRITE;
/*!40000 ALTER TABLE `dataflow_batch` DISABLE KEYS */;
/*!40000 ALTER TABLE `dataflow_batch` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dataflow_batch_export`
--

DROP TABLE IF EXISTS `dataflow_batch_export`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dataflow_batch_export` (
  `batch_export_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `batch_id` int(10) unsigned NOT NULL DEFAULT '0',
  `batch_data` longtext,
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`batch_export_id`),
  KEY `FK_DATAFLOW_BATCH_EXPORT_BATCH` (`batch_id`),
  CONSTRAINT `FK_DATAFLOW_BATCH_EXPORT_BATCH` FOREIGN KEY (`batch_id`) REFERENCES `dataflow_batch` (`batch_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dataflow_batch_export`
--

LOCK TABLES `dataflow_batch_export` WRITE;
/*!40000 ALTER TABLE `dataflow_batch_export` DISABLE KEYS */;
/*!40000 ALTER TABLE `dataflow_batch_export` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dataflow_batch_import`
--

DROP TABLE IF EXISTS `dataflow_batch_import`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dataflow_batch_import` (
  `batch_import_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `batch_id` int(10) unsigned NOT NULL DEFAULT '0',
  `batch_data` longtext,
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`batch_import_id`),
  KEY `FK_DATAFLOW_BATCH_IMPORT_BATCH` (`batch_id`),
  CONSTRAINT `FK_DATAFLOW_BATCH_IMPORT_BATCH` FOREIGN KEY (`batch_id`) REFERENCES `dataflow_batch` (`batch_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dataflow_batch_import`
--

LOCK TABLES `dataflow_batch_import` WRITE;
/*!40000 ALTER TABLE `dataflow_batch_import` DISABLE KEYS */;
/*!40000 ALTER TABLE `dataflow_batch_import` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dataflow_import_data`
--

DROP TABLE IF EXISTS `dataflow_import_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dataflow_import_data` (
  `import_id` int(11) NOT NULL AUTO_INCREMENT,
  `session_id` int(11) DEFAULT NULL,
  `serial_number` int(11) NOT NULL DEFAULT '0',
  `value` text,
  `status` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`import_id`),
  KEY `FK_dataflow_import_data` (`session_id`),
  CONSTRAINT `FK_dataflow_import_data` FOREIGN KEY (`session_id`) REFERENCES `dataflow_session` (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dataflow_import_data`
--

LOCK TABLES `dataflow_import_data` WRITE;
/*!40000 ALTER TABLE `dataflow_import_data` DISABLE KEYS */;
/*!40000 ALTER TABLE `dataflow_import_data` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dataflow_profile`
--

DROP TABLE IF EXISTS `dataflow_profile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dataflow_profile` (
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dataflow_profile`
--

LOCK TABLES `dataflow_profile` WRITE;
/*!40000 ALTER TABLE `dataflow_profile` DISABLE KEYS */;
INSERT INTO `dataflow_profile` VALUES (1,'Export All Products','2009-10-15 15:02:35','2009-10-15 15:02:35','<action type=\"catalog/convert_adapter_product\" method=\"load\">\r\n    <var name=\"store\"><![CDATA[0]]></var>\r\n</action>\r\n\r\n<action type=\"catalog/convert_parser_product\" method=\"unparse\">\r\n    <var name=\"store\"><![CDATA[0]]></var>\r\n</action>\r\n\r\n<action type=\"dataflow/convert_mapper_column\" method=\"map\">\r\n</action>\r\n\r\n<action type=\"dataflow/convert_parser_csv\" method=\"unparse\">\r\n    <var name=\"delimiter\"><![CDATA[,]]></var>\r\n    <var name=\"enclose\"><![CDATA[\"]]></var>\r\n    <var name=\"fieldnames\">true</var>\r\n</action>\r\n\r\n<action type=\"dataflow/convert_adapter_io\" method=\"save\">\r\n    <var name=\"type\">file</var>\r\n    <var name=\"path\">var/export</var>\r\n    <var name=\"filename\"><![CDATA[export_all_products.csv]]></var>\r\n</action>\r\n\r\n','a:5:{s:4:\"file\";a:7:{s:4:\"type\";s:4:\"file\";s:8:\"filename\";s:23:\"export_all_products.csv\";s:4:\"path\";s:10:\"var/export\";s:4:\"host\";s:0:\"\";s:4:\"user\";s:0:\"\";s:8:\"password\";s:0:\"\";s:7:\"passive\";s:0:\"\";}s:5:\"parse\";a:5:{s:4:\"type\";s:3:\"csv\";s:12:\"single_sheet\";s:0:\"\";s:9:\"delimiter\";s:1:\",\";s:7:\"enclose\";s:1:\"\"\";s:10:\"fieldnames\";s:4:\"true\";}s:3:\"map\";a:3:{s:14:\"only_specified\";s:0:\"\";s:7:\"product\";a:2:{s:2:\"db\";a:0:{}s:4:\"file\";a:0:{}}s:8:\"customer\";a:2:{s:2:\"db\";a:0:{}s:4:\"file\";a:0:{}}}s:7:\"product\";a:1:{s:6:\"filter\";a:8:{s:4:\"name\";s:0:\"\";s:3:\"sku\";s:0:\"\";s:4:\"type\";s:1:\"0\";s:13:\"attribute_set\";s:0:\"\";s:5:\"price\";a:2:{s:4:\"from\";s:0:\"\";s:2:\"to\";s:0:\"\";}s:3:\"qty\";a:2:{s:4:\"from\";s:0:\"\";s:2:\"to\";s:0:\"\";}s:10:\"visibility\";s:1:\"0\";s:6:\"status\";s:1:\"0\";}}s:8:\"customer\";a:1:{s:6:\"filter\";a:10:{s:9:\"firstname\";s:0:\"\";s:8:\"lastname\";s:0:\"\";s:5:\"email\";s:0:\"\";s:5:\"group\";s:1:\"0\";s:10:\"adressType\";s:15:\"default_billing\";s:9:\"telephone\";s:0:\"\";s:8:\"postcode\";s:0:\"\";s:7:\"country\";s:0:\"\";s:6:\"region\";s:0:\"\";s:10:\"created_at\";a:2:{s:4:\"from\";s:0:\"\";s:2:\"to\";s:0:\"\";}}}}','export','product',0,'file'),(2,'Export Product Stocks','2009-10-15 15:02:35','2009-10-15 15:02:35','<action type=\"catalog/convert_adapter_product\" method=\"load\">\r\n    <var name=\"store\"><![CDATA[0]]></var>\r\n</action>\r\n\r\n<action type=\"catalog/convert_parser_product\" method=\"unparse\">\r\n    <var name=\"store\"><![CDATA[0]]></var>\r\n</action>\r\n\r\n<action type=\"dataflow/convert_mapper_column\" method=\"map\">\r\n    <var name=\"map\">\r\n        <map name=\"store\"><![CDATA[store]]></map>\r\n        <map name=\"sku\"><![CDATA[sku]]></map>\r\n        <map name=\"qty\"><![CDATA[qty]]></map>\r\n        <map name=\"is_in_stock\"><![CDATA[is_in_stock]]></map>\r\n    </var>\r\n    <var name=\"_only_specified\">true</var>\r\n</action>\r\n\r\n<action type=\"dataflow/convert_parser_csv\" method=\"unparse\">\r\n    <var name=\"delimiter\"><![CDATA[,]]></var>\r\n    <var name=\"enclose\"><![CDATA[\"]]></var>\r\n    <var name=\"fieldnames\">true</var>\r\n</action>\r\n\r\n<action type=\"dataflow/convert_adapter_io\" method=\"save\">\r\n    <var name=\"type\">file</var>\r\n    <var name=\"path\">var/export</var>\r\n    <var name=\"filename\"><![CDATA[export_product_stocks.csv]]></var>\r\n</action>\r\n\r\n','a:5:{s:4:\"file\";a:7:{s:4:\"type\";s:4:\"file\";s:8:\"filename\";s:25:\"export_product_stocks.csv\";s:4:\"path\";s:10:\"var/export\";s:4:\"host\";s:0:\"\";s:4:\"user\";s:0:\"\";s:8:\"password\";s:0:\"\";s:7:\"passive\";s:0:\"\";}s:5:\"parse\";a:5:{s:4:\"type\";s:3:\"csv\";s:12:\"single_sheet\";s:0:\"\";s:9:\"delimiter\";s:1:\",\";s:7:\"enclose\";s:1:\"\"\";s:10:\"fieldnames\";s:4:\"true\";}s:3:\"map\";a:3:{s:14:\"only_specified\";s:4:\"true\";s:7:\"product\";a:2:{s:2:\"db\";a:4:{i:1;s:5:\"store\";i:2;s:3:\"sku\";i:3;s:3:\"qty\";i:4;s:11:\"is_in_stock\";}s:4:\"file\";a:4:{i:1;s:5:\"store\";i:2;s:3:\"sku\";i:3;s:3:\"qty\";i:4;s:11:\"is_in_stock\";}}s:8:\"customer\";a:2:{s:2:\"db\";a:0:{}s:4:\"file\";a:0:{}}}s:7:\"product\";a:1:{s:6:\"filter\";a:8:{s:4:\"name\";s:0:\"\";s:3:\"sku\";s:0:\"\";s:4:\"type\";s:1:\"0\";s:13:\"attribute_set\";s:0:\"\";s:5:\"price\";a:2:{s:4:\"from\";s:0:\"\";s:2:\"to\";s:0:\"\";}s:3:\"qty\";a:2:{s:4:\"from\";s:0:\"\";s:2:\"to\";s:0:\"\";}s:10:\"visibility\";s:1:\"0\";s:6:\"status\";s:1:\"0\";}}s:8:\"customer\";a:1:{s:6:\"filter\";a:10:{s:9:\"firstname\";s:0:\"\";s:8:\"lastname\";s:0:\"\";s:5:\"email\";s:0:\"\";s:5:\"group\";s:1:\"0\";s:10:\"adressType\";s:15:\"default_billing\";s:9:\"telephone\";s:0:\"\";s:8:\"postcode\";s:0:\"\";s:7:\"country\";s:0:\"\";s:6:\"region\";s:0:\"\";s:10:\"created_at\";a:2:{s:4:\"from\";s:0:\"\";s:2:\"to\";s:0:\"\";}}}}','export','product',0,'file'),(3,'Import All Products','2009-10-15 15:02:35','2009-10-15 15:02:35','<action type=\"dataflow/convert_parser_csv\" method=\"parse\">\r\n    <var name=\"delimiter\"><![CDATA[,]]></var>\r\n    <var name=\"enclose\"><![CDATA[\"]]></var>\r\n    <var name=\"fieldnames\">true</var>\r\n    <var name=\"store\"><![CDATA[0]]></var>\r\n    <var name=\"adapter\">catalog/convert_adapter_product</var>\r\n    <var name=\"method\">parse</var>\r\n</action>','a:5:{s:4:\"file\";a:7:{s:4:\"type\";s:4:\"file\";s:8:\"filename\";s:23:\"export_all_products.csv\";s:4:\"path\";s:10:\"var/export\";s:4:\"host\";s:0:\"\";s:4:\"user\";s:0:\"\";s:8:\"password\";s:0:\"\";s:7:\"passive\";s:0:\"\";}s:5:\"parse\";a:5:{s:4:\"type\";s:3:\"csv\";s:12:\"single_sheet\";s:0:\"\";s:9:\"delimiter\";s:1:\",\";s:7:\"enclose\";s:1:\"\"\";s:10:\"fieldnames\";s:4:\"true\";}s:3:\"map\";a:3:{s:14:\"only_specified\";s:0:\"\";s:7:\"product\";a:2:{s:2:\"db\";a:0:{}s:4:\"file\";a:0:{}}s:8:\"customer\";a:2:{s:2:\"db\";a:0:{}s:4:\"file\";a:0:{}}}s:7:\"product\";a:1:{s:6:\"filter\";a:8:{s:4:\"name\";s:0:\"\";s:3:\"sku\";s:0:\"\";s:4:\"type\";s:1:\"0\";s:13:\"attribute_set\";s:0:\"\";s:5:\"price\";a:2:{s:4:\"from\";s:0:\"\";s:2:\"to\";s:0:\"\";}s:3:\"qty\";a:2:{s:4:\"from\";s:0:\"\";s:2:\"to\";s:0:\"\";}s:10:\"visibility\";s:1:\"0\";s:6:\"status\";s:1:\"0\";}}s:8:\"customer\";a:1:{s:6:\"filter\";a:10:{s:9:\"firstname\";s:0:\"\";s:8:\"lastname\";s:0:\"\";s:5:\"email\";s:0:\"\";s:5:\"group\";s:1:\"0\";s:10:\"adressType\";s:15:\"default_billing\";s:9:\"telephone\";s:0:\"\";s:8:\"postcode\";s:0:\"\";s:7:\"country\";s:0:\"\";s:6:\"region\";s:0:\"\";s:10:\"created_at\";a:2:{s:4:\"from\";s:0:\"\";s:2:\"to\";s:0:\"\";}}}}','import','product',0,'interactive'),(4,'Import Product Stocks','2009-10-15 15:02:35','2009-10-15 15:02:35','<action type=\"dataflow/convert_parser_csv\" method=\"parse\">\r\n    <var name=\"delimiter\"><![CDATA[,]]></var>\r\n    <var name=\"enclose\"><![CDATA[\"]]></var>\r\n    <var name=\"fieldnames\">true</var>\r\n    <var name=\"store\"><![CDATA[0]]></var>\r\n    <var name=\"adapter\">catalog/convert_adapter_product</var>\r\n    <var name=\"method\">parse</var>\r\n</action>','a:5:{s:4:\"file\";a:7:{s:4:\"type\";s:4:\"file\";s:8:\"filename\";s:18:\"export_product.csv\";s:4:\"path\";s:10:\"var/export\";s:4:\"host\";s:0:\"\";s:4:\"user\";s:0:\"\";s:8:\"password\";s:0:\"\";s:7:\"passive\";s:0:\"\";}s:5:\"parse\";a:5:{s:4:\"type\";s:3:\"csv\";s:12:\"single_sheet\";s:0:\"\";s:9:\"delimiter\";s:1:\",\";s:7:\"enclose\";s:1:\"\"\";s:10:\"fieldnames\";s:4:\"true\";}s:3:\"map\";a:3:{s:14:\"only_specified\";s:0:\"\";s:7:\"product\";a:2:{s:2:\"db\";a:0:{}s:4:\"file\";a:0:{}}s:8:\"customer\";a:2:{s:2:\"db\";a:0:{}s:4:\"file\";a:0:{}}}s:7:\"product\";a:1:{s:6:\"filter\";a:8:{s:4:\"name\";s:0:\"\";s:3:\"sku\";s:0:\"\";s:4:\"type\";s:1:\"0\";s:13:\"attribute_set\";s:0:\"\";s:5:\"price\";a:2:{s:4:\"from\";s:0:\"\";s:2:\"to\";s:0:\"\";}s:3:\"qty\";a:2:{s:4:\"from\";s:0:\"\";s:2:\"to\";s:0:\"\";}s:10:\"visibility\";s:1:\"0\";s:6:\"status\";s:1:\"0\";}}s:8:\"customer\";a:1:{s:6:\"filter\";a:10:{s:9:\"firstname\";s:0:\"\";s:8:\"lastname\";s:0:\"\";s:5:\"email\";s:0:\"\";s:5:\"group\";s:1:\"0\";s:10:\"adressType\";s:15:\"default_billing\";s:9:\"telephone\";s:0:\"\";s:8:\"postcode\";s:0:\"\";s:7:\"country\";s:0:\"\";s:6:\"region\";s:0:\"\";s:10:\"created_at\";a:2:{s:4:\"from\";s:0:\"\";s:2:\"to\";s:0:\"\";}}}}','import','product',0,'interactive'),(5,'Export Customers','2009-10-15 15:02:35','2009-10-15 15:02:35','<action type=\"customer/convert_adapter_customer\" method=\"load\">\r\n    <var name=\"store\"><![CDATA[0]]></var>\r\n    <var name=\"filter/adressType\"><![CDATA[default_billing]]></var>\r\n</action>\r\n\r\n<action type=\"customer/convert_parser_customer\" method=\"unparse\">\r\n    <var name=\"store\"><![CDATA[0]]></var>\r\n</action>\r\n\r\n<action type=\"dataflow/convert_mapper_column\" method=\"map\">\r\n</action>\r\n\r\n<action type=\"dataflow/convert_parser_csv\" method=\"unparse\">\r\n    <var name=\"delimiter\"><![CDATA[,]]></var>\r\n    <var name=\"enclose\"><![CDATA[\"]]></var>\r\n    <var name=\"fieldnames\">true</var>\r\n</action>\r\n\r\n<action type=\"dataflow/convert_adapter_io\" method=\"save\">\r\n    <var name=\"type\">file</var>\r\n    <var name=\"path\">var/export</var>\r\n    <var name=\"filename\"><![CDATA[export_customers.csv]]></var>\r\n</action>\r\n\r\n','a:5:{s:4:\"file\";a:7:{s:4:\"type\";s:4:\"file\";s:8:\"filename\";s:20:\"export_customers.csv\";s:4:\"path\";s:10:\"var/export\";s:4:\"host\";s:0:\"\";s:4:\"user\";s:0:\"\";s:8:\"password\";s:0:\"\";s:7:\"passive\";s:0:\"\";}s:5:\"parse\";a:5:{s:4:\"type\";s:3:\"csv\";s:12:\"single_sheet\";s:0:\"\";s:9:\"delimiter\";s:1:\",\";s:7:\"enclose\";s:1:\"\"\";s:10:\"fieldnames\";s:4:\"true\";}s:3:\"map\";a:3:{s:14:\"only_specified\";s:0:\"\";s:7:\"product\";a:2:{s:2:\"db\";a:0:{}s:4:\"file\";a:0:{}}s:8:\"customer\";a:2:{s:2:\"db\";a:0:{}s:4:\"file\";a:0:{}}}s:7:\"product\";a:1:{s:6:\"filter\";a:8:{s:4:\"name\";s:0:\"\";s:3:\"sku\";s:0:\"\";s:4:\"type\";s:1:\"0\";s:13:\"attribute_set\";s:0:\"\";s:5:\"price\";a:2:{s:4:\"from\";s:0:\"\";s:2:\"to\";s:0:\"\";}s:3:\"qty\";a:2:{s:4:\"from\";s:0:\"\";s:2:\"to\";s:0:\"\";}s:10:\"visibility\";s:1:\"0\";s:6:\"status\";s:1:\"0\";}}s:8:\"customer\";a:1:{s:6:\"filter\";a:10:{s:9:\"firstname\";s:0:\"\";s:8:\"lastname\";s:0:\"\";s:5:\"email\";s:0:\"\";s:5:\"group\";s:1:\"0\";s:10:\"adressType\";s:15:\"default_billing\";s:9:\"telephone\";s:0:\"\";s:8:\"postcode\";s:0:\"\";s:7:\"country\";s:0:\"\";s:6:\"region\";s:0:\"\";s:10:\"created_at\";a:2:{s:4:\"from\";s:0:\"\";s:2:\"to\";s:0:\"\";}}}}','export','customer',0,'file'),(6,'Import Customers','2009-10-15 15:02:35','2009-10-15 15:02:35','<action type=\"dataflow/convert_parser_csv\" method=\"parse\">\r\n    <var name=\"delimiter\"><![CDATA[,]]></var>\r\n    <var name=\"enclose\"><![CDATA[\"]]></var>\r\n    <var name=\"fieldnames\">true</var>\r\n    <var name=\"store\"><![CDATA[0]]></var>\r\n    <var name=\"adapter\">customer/convert_adapter_customer</var>\r\n    <var name=\"method\">parse</var>\r\n</action>','a:5:{s:4:\"file\";a:7:{s:4:\"type\";s:4:\"file\";s:8:\"filename\";s:19:\"export_customer.csv\";s:4:\"path\";s:10:\"var/export\";s:4:\"host\";s:0:\"\";s:4:\"user\";s:0:\"\";s:8:\"password\";s:0:\"\";s:7:\"passive\";s:0:\"\";}s:5:\"parse\";a:5:{s:4:\"type\";s:3:\"csv\";s:12:\"single_sheet\";s:0:\"\";s:9:\"delimiter\";s:1:\",\";s:7:\"enclose\";s:1:\"\"\";s:10:\"fieldnames\";s:4:\"true\";}s:3:\"map\";a:3:{s:14:\"only_specified\";s:0:\"\";s:7:\"product\";a:2:{s:2:\"db\";a:0:{}s:4:\"file\";a:0:{}}s:8:\"customer\";a:2:{s:2:\"db\";a:0:{}s:4:\"file\";a:0:{}}}s:7:\"product\";a:1:{s:6:\"filter\";a:8:{s:4:\"name\";s:0:\"\";s:3:\"sku\";s:0:\"\";s:4:\"type\";s:1:\"0\";s:13:\"attribute_set\";s:0:\"\";s:5:\"price\";a:2:{s:4:\"from\";s:0:\"\";s:2:\"to\";s:0:\"\";}s:3:\"qty\";a:2:{s:4:\"from\";s:0:\"\";s:2:\"to\";s:0:\"\";}s:10:\"visibility\";s:1:\"0\";s:6:\"status\";s:1:\"0\";}}s:8:\"customer\";a:1:{s:6:\"filter\";a:10:{s:9:\"firstname\";s:0:\"\";s:8:\"lastname\";s:0:\"\";s:5:\"email\";s:0:\"\";s:5:\"group\";s:1:\"0\";s:10:\"adressType\";s:15:\"default_billing\";s:9:\"telephone\";s:0:\"\";s:8:\"postcode\";s:0:\"\";s:7:\"country\";s:0:\"\";s:6:\"region\";s:0:\"\";s:10:\"created_at\";a:2:{s:4:\"from\";s:0:\"\";s:2:\"to\";s:0:\"\";}}}}','import','customer',0,'interactive');
/*!40000 ALTER TABLE `dataflow_profile` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dataflow_profile_history`
--

DROP TABLE IF EXISTS `dataflow_profile_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dataflow_profile_history` (
  `history_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `profile_id` int(10) unsigned NOT NULL DEFAULT '0',
  `action_code` varchar(64) DEFAULT NULL,
  `user_id` int(10) unsigned NOT NULL DEFAULT '0',
  `performed_at` datetime DEFAULT NULL,
  PRIMARY KEY (`history_id`),
  KEY `FK_dataflow_profile_history` (`profile_id`),
  CONSTRAINT `FK_dataflow_profile_history` FOREIGN KEY (`profile_id`) REFERENCES `dataflow_profile` (`profile_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dataflow_profile_history`
--

LOCK TABLES `dataflow_profile_history` WRITE;
/*!40000 ALTER TABLE `dataflow_profile_history` DISABLE KEYS */;
/*!40000 ALTER TABLE `dataflow_profile_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dataflow_session`
--

DROP TABLE IF EXISTS `dataflow_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dataflow_session` (
  `session_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `created_date` datetime DEFAULT NULL,
  `file` varchar(255) DEFAULT NULL,
  `type` varchar(32) DEFAULT NULL,
  `direction` varchar(32) DEFAULT NULL,
  `comment` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dataflow_session`
--

LOCK TABLES `dataflow_session` WRITE;
/*!40000 ALTER TABLE `dataflow_session` DISABLE KEYS */;
/*!40000 ALTER TABLE `dataflow_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `design_change`
--

DROP TABLE IF EXISTS `design_change`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `design_change` (
  `design_change_id` int(11) NOT NULL AUTO_INCREMENT,
  `store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `design` varchar(255) NOT NULL DEFAULT '',
  `date_from` date DEFAULT NULL,
  `date_to` date DEFAULT NULL,
  PRIMARY KEY (`design_change_id`),
  KEY `FK_DESIGN_CHANGE_STORE` (`store_id`),
  CONSTRAINT `FK_DESIGN_CHANGE_STORE` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `design_change`
--

LOCK TABLES `design_change` WRITE;
/*!40000 ALTER TABLE `design_change` DISABLE KEYS */;
/*!40000 ALTER TABLE `design_change` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `directory_country`
--

DROP TABLE IF EXISTS `directory_country`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `directory_country` (
  `country_id` varchar(2) NOT NULL DEFAULT '',
  `iso2_code` varchar(2) NOT NULL DEFAULT '',
  `iso3_code` varchar(3) NOT NULL DEFAULT '',
  PRIMARY KEY (`country_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Countries';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `directory_country`
--

LOCK TABLES `directory_country` WRITE;
/*!40000 ALTER TABLE `directory_country` DISABLE KEYS */;
INSERT INTO `directory_country` VALUES ('AD','AD','AND'),('AE','AE','ARE'),('AF','AF','AFG'),('AG','AG','ATG'),('AI','AI','AIA'),('AL','AL','ALB'),('AM','AM','ARM'),('AN','AN','ANT'),('AO','AO','AGO'),('AQ','AQ','ATA'),('AR','AR','ARG'),('AS','AS','ASM'),('AT','AT','AUT'),('AU','AU','AUS'),('AW','AW','ABW'),('AX','AX','ALA'),('AZ','AZ','AZE'),('BA','BA','BIH'),('BB','BB','BRB'),('BD','BD','BGD'),('BE','BE','BEL'),('BF','BF','BFA'),('BG','BG','BGR'),('BH','BH','BHR'),('BI','BI','BDI'),('BJ','BJ','BEN'),('BL','BL','BLM'),('BM','BM','BMU'),('BN','BN','BRN'),('BO','BO','BOL'),('BR','BR','BRA'),('BS','BS','BHS'),('BT','BT','BTN'),('BV','BV','BVT'),('BW','BW','BWA'),('BY','BY','BLR'),('BZ','BZ','BLZ'),('CA','CA','CAN'),('CC','CC','CCK'),('CD','CD','COD'),('CF','CF','CAF'),('CG','CG','COG'),('CH','CH','CHE'),('CI','CI','CIV'),('CK','CK','COK'),('CL','CL','CHL'),('CM','CM','CMR'),('CN','CN','CHN'),('CO','CO','COL'),('CR','CR','CRI'),('CS','CS','SCG'),('CU','CU','CUB'),('CV','CV','CPV'),('CX','CX','CXR'),('CY','CY','CYP'),('CZ','CZ','CZE'),('DE','DE','DEU'),('DJ','DJ','DJI'),('DK','DK','DNK'),('DM','DM','DMA'),('DO','DO','DOM'),('DZ','DZ','DZA'),('EC','EC','ECU'),('EE','EE','EST'),('EG','EG','EGY'),('EH','EH','ESH'),('ER','ER','ERI'),('ES','ES','ESP'),('ET','ET','ETH'),('FI','FI','FIN'),('FJ','FJ','FJI'),('FK','FK','FLK'),('FM','FM','FSM'),('FO','FO','FRO'),('FR','FR','FRA'),('FX','FX','FXX'),('GA','GA','GAB'),('GB','GB','GBR'),('GD','GD','GRD'),('GE','GE','GEO'),('GF','GF','GUF'),('GG','GG','GGY'),('GH','GH','GHA'),('GI','GI','GIB'),('GL','GL','GRL'),('GM','GM','GMB'),('GN','GN','GIN'),('GP','GP','GLP'),('GQ','GQ','GNQ'),('GR','GR','GRC'),('GS','GS','SGS'),('GT','GT','GTM'),('GU','GU','GUM'),('GW','GW','GNB'),('GY','GY','GUY'),('HK','HK','HKG'),('HM','HM','HMD'),('HN','HN','HND'),('HR','HR','HRV'),('HT','HT','HTI'),('HU','HU','HUN'),('ID','ID','IDN'),('IE','IE','IRL'),('IL','IL','ISR'),('IM','IM','IMN'),('IN','IN','IND'),('IO','IO','IOT'),('IQ','IQ','IRQ'),('IR','IR','IRN'),('IS','IS','ISL'),('IT','IT','ITA'),('JE','JE','JEY'),('JM','JM','JAM'),('JO','JO','JOR'),('JP','JP','JPN'),('KE','KE','KEN'),('KG','KG','KGZ'),('KH','KH','KHM'),('KI','KI','KIR'),('KM','KM','COM'),('KN','KN','KNA'),('KP','KP','PRK'),('KR','KR','KOR'),('KW','KW','KWT'),('KY','KY','CYM'),('KZ','KZ','KAZ'),('LA','LA','LAO'),('LB','LB','LBN'),('LC','LC','LCA'),('LI','LI','LIE'),('LK','LK','LKA'),('LR','LR','LBR'),('LS','LS','LSO'),('LT','LT','LTU'),('LU','LU','LUX'),('LV','LV','LVA'),('LY','LY','LBY'),('MA','MA','MAR'),('MC','MC','MCO'),('MD','MD','MDA'),('ME','ME','MNE'),('MF','MF','MAF'),('MG','MG','MDG'),('MH','MH','MHL'),('MK','MK','MKD'),('ML','ML','MLI'),('MM','MM','MMR'),('MN','MN','MNG'),('MO','MO','MAC'),('MP','MP','MNP'),('MQ','MQ','MTQ'),('MR','MR','MRT'),('MS','MS','MSR'),('MT','MT','MLT'),('MU','MU','MUS'),('MV','MV','MDV'),('MW','MW','MWI'),('MX','MX','MEX'),('MY','MY','MYS'),('MZ','MZ','MOZ'),('NA','NA','NAM'),('NC','NC','NCL'),('NE','NE','NER'),('NF','NF','NFK'),('NG','NG','NGA'),('NI','NI','NIC'),('NL','NL','NLD'),('NO','NO','NOR'),('NP','NP','NPL'),('NR','NR','NRU'),('NU','NU','NIU'),('NZ','NZ','NZL'),('OM','OM','OMN'),('PA','PA','PAN'),('PE','PE','PER'),('PF','PF','PYF'),('PG','PG','PNG'),('PH','PH','PHL'),('PK','PK','PAK'),('PL','PL','POL'),('PM','PM','SPM'),('PN','PN','PCN'),('PR','PR','PRI'),('PS','PS','PSE'),('PT','PT','PRT'),('PW','PW','PLW'),('PY','PY','PRY'),('QA','QA','QAT'),('RE','RE','REU'),('RO','RO','ROM'),('RS','RS','SRB'),('RU','RU','RUS'),('RW','RW','RWA'),('SA','SA','SAU'),('SB','SB','SLB'),('SC','SC','SYC'),('SD','SD','SDN'),('SE','SE','SWE'),('SG','SG','SGP'),('SH','SH','SHN'),('SI','SI','SVN'),('SJ','SJ','SJM'),('SK','SK','SVK'),('SL','SL','SLE'),('SM','SM','SMR'),('SN','SN','SEN'),('SO','SO','SOM'),('SR','SR','SUR'),('ST','ST','STP'),('SV','SV','SLV'),('SY','SY','SYR'),('SZ','SZ','SWZ'),('TC','TC','TCA'),('TD','TD','TCD'),('TF','TF','ATF'),('TG','TG','TGO'),('TH','TH','THA'),('TJ','TJ','TJK'),('TK','TK','TKL'),('TL','TL','TLS'),('TM','TM','TKM'),('TN','TN','TUN'),('TO','TO','TON'),('TR','TR','TUR'),('TT','TT','TTO'),('TV','TV','TUV'),('TW','TW','TWN'),('TZ','TZ','TZA'),('UA','UA','UKR'),('UG','UG','UGA'),('UM','UM','UMI'),('US','US','USA'),('UY','UY','URY'),('UZ','UZ','UZB'),('VA','VA','VAT'),('VC','VC','VCT'),('VE','VE','VEN'),('VG','VG','VGB'),('VI','VI','VIR'),('VN','VN','VNM'),('VU','VU','VUT'),('WF','WF','WLF'),('WS','WS','WSM'),('YE','YE','YEM'),('YT','YT','MYT'),('ZA','ZA','ZAF'),('ZM','ZM','ZMB'),('ZW','ZW','ZWE');
/*!40000 ALTER TABLE `directory_country` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `directory_country_format`
--

DROP TABLE IF EXISTS `directory_country_format`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `directory_country_format` (
  `country_format_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `country_id` varchar(2) NOT NULL DEFAULT '',
  `type` varchar(30) NOT NULL DEFAULT '',
  `format` text NOT NULL,
  PRIMARY KEY (`country_format_id`),
  UNIQUE KEY `country_type` (`country_id`,`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Countries format';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `directory_country_format`
--

LOCK TABLES `directory_country_format` WRITE;
/*!40000 ALTER TABLE `directory_country_format` DISABLE KEYS */;
/*!40000 ALTER TABLE `directory_country_format` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `directory_country_region`
--

DROP TABLE IF EXISTS `directory_country_region`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `directory_country_region` (
  `region_id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `country_id` varchar(4) NOT NULL DEFAULT '0',
  `code` varchar(32) NOT NULL DEFAULT '',
  `default_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`region_id`),
  KEY `FK_REGION_COUNTRY` (`country_id`)
) ENGINE=InnoDB AUTO_INCREMENT=278 DEFAULT CHARSET=utf8 COMMENT='Country regions';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `directory_country_region`
--

LOCK TABLES `directory_country_region` WRITE;
/*!40000 ALTER TABLE `directory_country_region` DISABLE KEYS */;
INSERT INTO `directory_country_region` VALUES (1,'US','AL','Alabama'),(2,'US','AK','Alaska'),(3,'US','AS','American Samoa'),(4,'US','AZ','Arizona'),(5,'US','AR','Arkansas'),(6,'US','AF','Armed Forces Africa'),(7,'US','AA','Armed Forces Americas'),(8,'US','AC','Armed Forces Canada'),(9,'US','AE','Armed Forces Europe'),(10,'US','AM','Armed Forces Middle East'),(11,'US','AP','Armed Forces Pacific'),(12,'US','CA','California'),(13,'US','CO','Colorado'),(14,'US','CT','Connecticut'),(15,'US','DE','Delaware'),(16,'US','DC','District of Columbia'),(17,'US','FM','Federated States Of Micronesia'),(18,'US','FL','Florida'),(19,'US','GA','Georgia'),(20,'US','GU','Guam'),(21,'US','HI','Hawaii'),(22,'US','ID','Idaho'),(23,'US','IL','Illinois'),(24,'US','IN','Indiana'),(25,'US','IA','Iowa'),(26,'US','KS','Kansas'),(27,'US','KY','Kentucky'),(28,'US','LA','Louisiana'),(29,'US','ME','Maine'),(30,'US','MH','Marshall Islands'),(31,'US','MD','Maryland'),(32,'US','MA','Massachusetts'),(33,'US','MI','Michigan'),(34,'US','MN','Minnesota'),(35,'US','MS','Mississippi'),(36,'US','MO','Missouri'),(37,'US','MT','Montana'),(38,'US','NE','Nebraska'),(39,'US','NV','Nevada'),(40,'US','NH','New Hampshire'),(41,'US','NJ','New Jersey'),(42,'US','NM','New Mexico'),(43,'US','NY','New York'),(44,'US','NC','North Carolina'),(45,'US','ND','North Dakota'),(46,'US','MP','Northern Mariana Islands'),(47,'US','OH','Ohio'),(48,'US','OK','Oklahoma'),(49,'US','OR','Oregon'),(50,'US','PW','Palau'),(51,'US','PA','Pennsylvania'),(52,'US','PR','Puerto Rico'),(53,'US','RI','Rhode Island'),(54,'US','SC','South Carolina'),(55,'US','SD','South Dakota'),(56,'US','TN','Tennessee'),(57,'US','TX','Texas'),(58,'US','UT','Utah'),(59,'US','VT','Vermont'),(60,'US','VI','Virgin Islands'),(61,'US','VA','Virginia'),(62,'US','WA','Washington'),(63,'US','WV','West Virginia'),(64,'US','WI','Wisconsin'),(65,'US','WY','Wyoming'),(66,'CA','AB','Alberta'),(67,'CA','BC','British Columbia'),(68,'CA','MB','Manitoba'),(69,'CA','NF','Newfoundland'),(70,'CA','NB','New Brunswick'),(71,'CA','NS','Nova Scotia'),(72,'CA','NT','Northwest Territories'),(73,'CA','NU','Nunavut'),(74,'CA','ON','Ontario'),(75,'CA','PE','Prince Edward Island'),(76,'CA','QC','Quebec'),(77,'CA','SK','Saskatchewan'),(78,'CA','YT','Yukon Territory'),(79,'DE','NDS','Niedersachsen'),(80,'DE','BAW','Baden-Württemberg'),(81,'DE','BAY','Bayern'),(82,'DE','BER','Berlin'),(83,'DE','BRG','Brandenburg'),(84,'DE','BRE','Bremen'),(85,'DE','HAM','Hamburg'),(86,'DE','HES','Hessen'),(87,'DE','MEC','Mecklenburg-Vorpommern'),(88,'DE','NRW','Nordrhein-Westfalen'),(89,'DE','RHE','Rheinland-Pfalz'),(90,'DE','SAR','Saarland'),(91,'DE','SAS','Sachsen'),(92,'DE','SAC','Sachsen-Anhalt'),(93,'DE','SCN','Schleswig-Holstein'),(94,'DE','THE','Thüringen'),(95,'AT','WI','Wien'),(96,'AT','NO','Niederösterreich'),(97,'AT','OO','Oberösterreich'),(98,'AT','SB','Salzburg'),(99,'AT','KN','Kärnten'),(100,'AT','ST','Steiermark'),(101,'AT','TI','Tirol'),(102,'AT','BL','Burgenland'),(103,'AT','VB','Voralberg'),(104,'CH','AG','Aargau'),(105,'CH','AI','Appenzell Innerrhoden'),(106,'CH','AR','Appenzell Ausserrhoden'),(107,'CH','BE','Bern'),(108,'CH','BL','Basel-Landschaft'),(109,'CH','BS','Basel-Stadt'),(110,'CH','FR','Freiburg'),(111,'CH','GE','Genf'),(112,'CH','GL','Glarus'),(113,'CH','GR','Graubünden'),(114,'CH','JU','Jura'),(115,'CH','LU','Luzern'),(116,'CH','NE','Neuenburg'),(117,'CH','NW','Nidwalden'),(118,'CH','OW','Obwalden'),(119,'CH','SG','St. Gallen'),(120,'CH','SH','Schaffhausen'),(121,'CH','SO','Solothurn'),(122,'CH','SZ','Schwyz'),(123,'CH','TG','Thurgau'),(124,'CH','TI','Tessin'),(125,'CH','UR','Uri'),(126,'CH','VD','Waadt'),(127,'CH','VS','Wallis'),(128,'CH','ZG','Zug'),(129,'CH','ZH','Zürich'),(130,'ES','A Coru?a','A Coruña'),(131,'ES','Alava','Alava'),(132,'ES','Albacete','Albacete'),(133,'ES','Alicante','Alicante'),(134,'ES','Almeria','Almeria'),(135,'ES','Asturias','Asturias'),(136,'ES','Avila','Avila'),(137,'ES','Badajoz','Badajoz'),(138,'ES','Baleares','Baleares'),(139,'ES','Barcelona','Barcelona'),(140,'ES','Burgos','Burgos'),(141,'ES','Caceres','Caceres'),(142,'ES','Cadiz','Cadiz'),(143,'ES','Cantabria','Cantabria'),(144,'ES','Castellon','Castellon'),(145,'ES','Ceuta','Ceuta'),(146,'ES','Ciudad Real','Ciudad Real'),(147,'ES','Cordoba','Cordoba'),(148,'ES','Cuenca','Cuenca'),(149,'ES','Girona','Girona'),(150,'ES','Granada','Granada'),(151,'ES','Guadalajara','Guadalajara'),(152,'ES','Guipuzcoa','Guipuzcoa'),(153,'ES','Huelva','Huelva'),(154,'ES','Huesca','Huesca'),(155,'ES','Jaen','Jaen'),(156,'ES','La Rioja','La Rioja'),(157,'ES','Las Palmas','Las Palmas'),(158,'ES','Leon','Leon'),(159,'ES','Lleida','Lleida'),(160,'ES','Lugo','Lugo'),(161,'ES','Madrid','Madrid'),(162,'ES','Malaga','Malaga'),(163,'ES','Melilla','Melilla'),(164,'ES','Murcia','Murcia'),(165,'ES','Navarra','Navarra'),(166,'ES','Ourense','Ourense'),(167,'ES','Palencia','Palencia'),(168,'ES','Pontevedra','Pontevedra'),(169,'ES','Salamanca','Salamanca'),(170,'ES','Santa Cruz de Tenerife','Santa Cruz de Tenerife'),(171,'ES','Segovia','Segovia'),(172,'ES','Sevilla','Sevilla'),(173,'ES','Soria','Soria'),(174,'ES','Tarragona','Tarragona'),(175,'ES','Teruel','Teruel'),(176,'ES','Toledo','Toledo'),(177,'ES','Valencia','Valencia'),(178,'ES','Valladolid','Valladolid'),(179,'ES','Vizcaya','Vizcaya'),(180,'ES','Zamora','Zamora'),(181,'ES','Zaragoza','Zaragoza'),(182,'FR','01','Ain'),(183,'FR','02','Aisne'),(184,'FR','03','Allier'),(185,'FR','04','Alpes-de-Haute-Provence'),(186,'FR','05','Hautes-Alpes'),(187,'FR','06','Alpes-Maritimes'),(188,'FR','07','Ardèche'),(189,'FR','08','Ardennes'),(190,'FR','09','Ariège'),(191,'FR','10','Aube'),(192,'FR','11','Aude'),(193,'FR','12','Aveyron'),(194,'FR','13','Bouches-du-Rhône'),(195,'FR','14','Calvados'),(196,'FR','15','Cantal'),(197,'FR','16','Charente'),(198,'FR','17','Charente-Maritime'),(199,'FR','18','Cher'),(200,'FR','19','Corrèze'),(201,'FR','2A','Corse-du-Sud'),(202,'FR','2B','Haute-Corse'),(203,'FR','21','Côte-d\'Or'),(204,'FR','22','Côtes-d\'Armor'),(205,'FR','23','Creuse'),(206,'FR','24','Dordogne'),(207,'FR','25','Doubs'),(208,'FR','26','Drôme'),(209,'FR','27','Eure'),(210,'FR','28','Eure-et-Loir'),(211,'FR','29','Finistère'),(212,'FR','30','Gard'),(213,'FR','31','Haute-Garonne'),(214,'FR','32','Gers'),(215,'FR','33','Gironde'),(216,'FR','34','Hérault'),(217,'FR','35','Ille-et-Vilaine'),(218,'FR','36','Indre'),(219,'FR','37','Indre-et-Loire'),(220,'FR','38','Isère'),(221,'FR','39','Jura'),(222,'FR','40','Landes'),(223,'FR','41','Loir-et-Cher'),(224,'FR','42','Loire'),(225,'FR','43','Haute-Loire'),(226,'FR','44','Loire-Atlantique'),(227,'FR','45','Loiret'),(228,'FR','46','Lot'),(229,'FR','47','Lot-et-Garonne'),(230,'FR','48','Lozère'),(231,'FR','49','Maine-et-Loire'),(232,'FR','50','Manche'),(233,'FR','51','Marne'),(234,'FR','52','Haute-Marne'),(235,'FR','53','Mayenne'),(236,'FR','54','Meurthe-et-Moselle'),(237,'FR','55','Meuse'),(238,'FR','56','Morbihan'),(239,'FR','57','Moselle'),(240,'FR','58','Nièvre'),(241,'FR','59','Nord'),(242,'FR','60','Oise'),(243,'FR','61','Orne'),(244,'FR','62','Pas-de-Calais'),(245,'FR','63','Puy-de-Dôme'),(246,'FR','64','Pyrénées-Atlantiques'),(247,'FR','65','Hautes-Pyrénées'),(248,'FR','66','Pyrénées-Orientales'),(249,'FR','67','Bas-Rhin'),(250,'FR','68','Haut-Rhin'),(251,'FR','69','Rhône'),(252,'FR','70','Haute-Saône'),(253,'FR','71','Saône-et-Loire'),(254,'FR','72','Sarthe'),(255,'FR','73','Savoie'),(256,'FR','74','Haute-Savoie'),(257,'FR','75','Paris'),(258,'FR','76','Seine-Maritime'),(259,'FR','77','Seine-et-Marne'),(260,'FR','78','Yvelines'),(261,'FR','79','Deux-Sèvres'),(262,'FR','80','Somme'),(263,'FR','81','Tarn'),(264,'FR','82','Tarn-et-Garonne'),(265,'FR','83','Var'),(266,'FR','84','Vaucluse'),(267,'FR','85','Vendée'),(268,'FR','86','Vienne'),(269,'FR','87','Haute-Vienne'),(270,'FR','88','Vosges'),(271,'FR','89','Yonne'),(272,'FR','90','Territoire-de-Belfort'),(273,'FR','91','Essonne'),(274,'FR','92','Hauts-de-Seine'),(275,'FR','93','Seine-Saint-Denis'),(276,'FR','94','Val-de-Marne'),(277,'FR','95','Val-d\'Oise');
/*!40000 ALTER TABLE `directory_country_region` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `directory_country_region_name`
--

DROP TABLE IF EXISTS `directory_country_region_name`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `directory_country_region_name` (
  `locale` varchar(8) NOT NULL DEFAULT '',
  `region_id` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `name` varchar(64) NOT NULL DEFAULT '',
  PRIMARY KEY (`locale`,`region_id`),
  KEY `FK_DIRECTORY_REGION_NAME_REGION` (`region_id`),
  CONSTRAINT `FK_DIRECTORY_REGION_NAME_REGION` FOREIGN KEY (`region_id`) REFERENCES `directory_country_region` (`region_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Regions names';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `directory_country_region_name`
--

LOCK TABLES `directory_country_region_name` WRITE;
/*!40000 ALTER TABLE `directory_country_region_name` DISABLE KEYS */;
INSERT INTO `directory_country_region_name` VALUES ('en_US',1,'Alabama'),('en_US',2,'Alaska'),('en_US',3,'American Samoa'),('en_US',4,'Arizona'),('en_US',5,'Arkansas'),('en_US',6,'Armed Forces Africa'),('en_US',7,'Armed Forces Americas'),('en_US',8,'Armed Forces Canada'),('en_US',9,'Armed Forces Europe'),('en_US',10,'Armed Forces Middle East'),('en_US',11,'Armed Forces Pacific'),('en_US',12,'California'),('en_US',13,'Colorado'),('en_US',14,'Connecticut'),('en_US',15,'Delaware'),('en_US',16,'District of Columbia'),('en_US',17,'Federated States Of Micronesia'),('en_US',18,'Florida'),('en_US',19,'Georgia'),('en_US',20,'Guam'),('en_US',21,'Hawaii'),('en_US',22,'Idaho'),('en_US',23,'Illinois'),('en_US',24,'Indiana'),('en_US',25,'Iowa'),('en_US',26,'Kansas'),('en_US',27,'Kentucky'),('en_US',28,'Louisiana'),('en_US',29,'Maine'),('en_US',30,'Marshall Islands'),('en_US',31,'Maryland'),('en_US',32,'Massachusetts'),('en_US',33,'Michigan'),('en_US',34,'Minnesota'),('en_US',35,'Mississippi'),('en_US',36,'Missouri'),('en_US',37,'Montana'),('en_US',38,'Nebraska'),('en_US',39,'Nevada'),('en_US',40,'New Hampshire'),('en_US',41,'New Jersey'),('en_US',42,'New Mexico'),('en_US',43,'New York'),('en_US',44,'North Carolina'),('en_US',45,'North Dakota'),('en_US',46,'Northern Mariana Islands'),('en_US',47,'Ohio'),('en_US',48,'Oklahoma'),('en_US',49,'Oregon'),('en_US',50,'Palau'),('en_US',51,'Pennsylvania'),('en_US',52,'Puerto Rico'),('en_US',53,'Rhode Island'),('en_US',54,'South Carolina'),('en_US',55,'South Dakota'),('en_US',56,'Tennessee'),('en_US',57,'Texas'),('en_US',58,'Utah'),('en_US',59,'Vermont'),('en_US',60,'Virgin Islands'),('en_US',61,'Virginia'),('en_US',62,'Washington'),('en_US',63,'West Virginia'),('en_US',64,'Wisconsin'),('en_US',65,'Wyoming'),('en_US',66,'Alberta'),('en_US',67,'British Columbia'),('en_US',68,'Manitoba'),('en_US',69,'Newfoundland'),('en_US',70,'New Brunswick'),('en_US',71,'Nova Scotia'),('en_US',72,'Northwest Territories'),('en_US',73,'Nunavut'),('en_US',74,'Ontario'),('en_US',75,'Prince Edward Island'),('en_US',76,'Quebec'),('en_US',77,'Saskatchewan'),('en_US',78,'Yukon Territory'),('en_US',79,'Niedersachsen'),('en_US',80,'Baden-Württemberg'),('en_US',81,'Bayern'),('en_US',82,'Berlin'),('en_US',83,'Brandenburg'),('en_US',84,'Bremen'),('en_US',85,'Hamburg'),('en_US',86,'Hessen'),('en_US',87,'Mecklenburg-Vorpommern'),('en_US',88,'Nordrhein-Westfalen'),('en_US',89,'Rheinland-Pfalz'),('en_US',90,'Saarland'),('en_US',91,'Sachsen'),('en_US',92,'Sachsen-Anhalt'),('en_US',93,'Schleswig-Holstein'),('en_US',94,'Thüringen'),('en_US',95,'Wien'),('en_US',96,'Niederösterreich'),('en_US',97,'Oberösterreich'),('en_US',98,'Salzburg'),('en_US',99,'Kärnten'),('en_US',100,'Steiermark'),('en_US',101,'Tirol'),('en_US',102,'Burgenland'),('en_US',103,'Voralberg'),('en_US',104,'Aargau'),('en_US',105,'Appenzell Innerrhoden'),('en_US',106,'Appenzell Ausserrhoden'),('en_US',107,'Bern'),('en_US',108,'Basel-Landschaft'),('en_US',109,'Basel-Stadt'),('en_US',110,'Freiburg'),('en_US',111,'Genf'),('en_US',112,'Glarus'),('en_US',113,'Graubünden'),('en_US',114,'Jura'),('en_US',115,'Luzern'),('en_US',116,'Neuenburg'),('en_US',117,'Nidwalden'),('en_US',118,'Obwalden'),('en_US',119,'St. Gallen'),('en_US',120,'Schaffhausen'),('en_US',121,'Solothurn'),('en_US',122,'Schwyz'),('en_US',123,'Thurgau'),('en_US',124,'Tessin'),('en_US',125,'Uri'),('en_US',126,'Waadt'),('en_US',127,'Wallis'),('en_US',128,'Zug'),('en_US',129,'Zürich'),('en_US',130,'A Coruña'),('en_US',131,'Alava'),('en_US',132,'Albacete'),('en_US',133,'Alicante'),('en_US',134,'Almeria'),('en_US',135,'Asturias'),('en_US',136,'Avila'),('en_US',137,'Badajoz'),('en_US',138,'Baleares'),('en_US',139,'Barcelona'),('en_US',140,'Burgos'),('en_US',141,'Caceres'),('en_US',142,'Cadiz'),('en_US',143,'Cantabria'),('en_US',144,'Castellon'),('en_US',145,'Ceuta'),('en_US',146,'Ciudad Real'),('en_US',147,'Cordoba'),('en_US',148,'Cuenca'),('en_US',149,'Girona'),('en_US',150,'Granada'),('en_US',151,'Guadalajara'),('en_US',152,'Guipuzcoa'),('en_US',153,'Huelva'),('en_US',154,'Huesca'),('en_US',155,'Jaen'),('en_US',156,'La Rioja'),('en_US',157,'Las Palmas'),('en_US',158,'Leon'),('en_US',159,'Lleida'),('en_US',160,'Lugo'),('en_US',161,'Madrid'),('en_US',162,'Malaga'),('en_US',163,'Melilla'),('en_US',164,'Murcia'),('en_US',165,'Navarra'),('en_US',166,'Ourense'),('en_US',167,'Palencia'),('en_US',168,'Pontevedra'),('en_US',169,'Salamanca'),('en_US',170,'Santa Cruz de Tenerife'),('en_US',171,'Segovia'),('en_US',172,'Sevilla'),('en_US',173,'Soria'),('en_US',174,'Tarragona'),('en_US',175,'Teruel'),('en_US',176,'Toledo'),('en_US',177,'Valencia'),('en_US',178,'Valladolid'),('en_US',179,'Vizcaya'),('en_US',180,'Zamora'),('en_US',181,'Zaragoza'),('en_US',182,'Ain'),('en_US',183,'Aisne'),('en_US',184,'Allier'),('en_US',185,'Alpes-de-Haute-Provence'),('en_US',186,'Hautes-Alpes'),('en_US',187,'Alpes-Maritimes'),('en_US',188,'Ardèche'),('en_US',189,'Ardennes'),('en_US',190,'Ariège'),('en_US',191,'Aube'),('en_US',192,'Aude'),('en_US',193,'Aveyron'),('en_US',194,'Bouches-du-Rhône'),('en_US',195,'Calvados'),('en_US',196,'Cantal'),('en_US',197,'Charente'),('en_US',198,'Charente-Maritime'),('en_US',199,'Cher'),('en_US',200,'Corrèze'),('en_US',201,'Corse-du-Sud'),('en_US',202,'Haute-Corse'),('en_US',203,'Côte-d\'Or'),('en_US',204,'Côtes-d\'Armor'),('en_US',205,'Creuse'),('en_US',206,'Dordogne'),('en_US',207,'Doubs'),('en_US',208,'Drôme'),('en_US',209,'Eure'),('en_US',210,'Eure-et-Loir'),('en_US',211,'Finistère'),('en_US',212,'Gard'),('en_US',213,'Haute-Garonne'),('en_US',214,'Gers'),('en_US',215,'Gironde'),('en_US',216,'Hérault'),('en_US',217,'Ille-et-Vilaine'),('en_US',218,'Indre'),('en_US',219,'Indre-et-Loire'),('en_US',220,'Isère'),('en_US',221,'Jura'),('en_US',222,'Landes'),('en_US',223,'Loir-et-Cher'),('en_US',224,'Loire'),('en_US',225,'Haute-Loire'),('en_US',226,'Loire-Atlantique'),('en_US',227,'Loiret'),('en_US',228,'Lot'),('en_US',229,'Lot-et-Garonne'),('en_US',230,'Lozère'),('en_US',231,'Maine-et-Loire'),('en_US',232,'Manche'),('en_US',233,'Marne'),('en_US',234,'Haute-Marne'),('en_US',235,'Mayenne'),('en_US',236,'Meurthe-et-Moselle'),('en_US',237,'Meuse'),('en_US',238,'Morbihan'),('en_US',239,'Moselle'),('en_US',240,'Nièvre'),('en_US',241,'Nord'),('en_US',242,'Oise'),('en_US',243,'Orne'),('en_US',244,'Pas-de-Calais'),('en_US',245,'Puy-de-Dôme'),('en_US',246,'Pyrénées-Atlantiques'),('en_US',247,'Hautes-Pyrénées'),('en_US',248,'Pyrénées-Orientales'),('en_US',249,'Bas-Rhin'),('en_US',250,'Haut-Rhin'),('en_US',251,'Rhône'),('en_US',252,'Haute-Saône'),('en_US',253,'Saône-et-Loire'),('en_US',254,'Sarthe'),('en_US',255,'Savoie'),('en_US',256,'Haute-Savoie'),('en_US',257,'Paris'),('en_US',258,'Seine-Maritime'),('en_US',259,'Seine-et-Marne'),('en_US',260,'Yvelines'),('en_US',261,'Deux-Sèvres'),('en_US',262,'Somme'),('en_US',263,'Tarn'),('en_US',264,'Tarn-et-Garonne'),('en_US',265,'Var'),('en_US',266,'Vaucluse'),('en_US',267,'Vendée'),('en_US',268,'Vienne'),('en_US',269,'Haute-Vienne'),('en_US',270,'Vosges'),('en_US',271,'Yonne'),('en_US',272,'Territoire-de-Belfort'),('en_US',273,'Essonne'),('en_US',274,'Hauts-de-Seine'),('en_US',275,'Seine-Saint-Denis'),('en_US',276,'Val-de-Marne'),('en_US',277,'Val-d\'Oise');
/*!40000 ALTER TABLE `directory_country_region_name` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `directory_currency_rate`
--

DROP TABLE IF EXISTS `directory_currency_rate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `directory_currency_rate` (
  `currency_from` char(3) NOT NULL DEFAULT '',
  `currency_to` char(3) NOT NULL DEFAULT '',
  `rate` decimal(24,12) NOT NULL DEFAULT '0.000000000000',
  PRIMARY KEY (`currency_from`,`currency_to`),
  KEY `FK_CURRENCY_RATE_TO` (`currency_to`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `directory_currency_rate`
--

LOCK TABLES `directory_currency_rate` WRITE;
/*!40000 ALTER TABLE `directory_currency_rate` DISABLE KEYS */;
INSERT INTO `directory_currency_rate` VALUES ('EUR','EUR','1.000000000000'),('EUR','USD','1.415000000000'),('INR','EUR','0.014710600000'),('INR','INR','1.000000000000'),('INR','USD','0.021418600000'),('USD','EUR','0.706700000000'),('USD','USD','1.000000000000');
/*!40000 ALTER TABLE `directory_currency_rate` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `downloadable_link`
--

DROP TABLE IF EXISTS `downloadable_link`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `downloadable_link` (
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
  KEY `DOWNLODABLE_LINK_PRODUCT_SORT_ORDER` (`product_id`,`sort_order`),
  CONSTRAINT `FK_DOWNLODABLE_LINK_PRODUCT` FOREIGN KEY (`product_id`) REFERENCES `catalog_product_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `downloadable_link`
--

LOCK TABLES `downloadable_link` WRITE;
/*!40000 ALTER TABLE `downloadable_link` DISABLE KEYS */;
/*!40000 ALTER TABLE `downloadable_link` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `downloadable_link_price`
--

DROP TABLE IF EXISTS `downloadable_link_price`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `downloadable_link_price` (
  `price_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `link_id` int(10) unsigned NOT NULL DEFAULT '0',
  `website_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `price` decimal(12,4) NOT NULL DEFAULT '0.0000',
  PRIMARY KEY (`price_id`),
  KEY `DOWNLOADABLE_LINK_PRICE_LINK` (`link_id`),
  KEY `DOWNLOADABLE_LINK_PRICE_WEBSITE` (`website_id`),
  CONSTRAINT `FK_DOWNLOADABLE_LINK_PRICE_WEBSITE` FOREIGN KEY (`website_id`) REFERENCES `core_website` (`website_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_DOWNLOADABLE_LINK_PRICE_LINK` FOREIGN KEY (`link_id`) REFERENCES `downloadable_link` (`link_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `downloadable_link_price`
--

LOCK TABLES `downloadable_link_price` WRITE;
/*!40000 ALTER TABLE `downloadable_link_price` DISABLE KEYS */;
/*!40000 ALTER TABLE `downloadable_link_price` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `downloadable_link_purchased`
--

DROP TABLE IF EXISTS `downloadable_link_purchased`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `downloadable_link_purchased` (
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
  KEY `KEY_DOWNLOADABLE_ORDER_ITEM_ID` (`order_item_id`),
  CONSTRAINT `FK_DOWNLOADABLE_PURCHASED_ORDER_ITEM_ID` FOREIGN KEY (`order_item_id`) REFERENCES `sales_flat_order_item` (`item_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_DOWNLOADABLE_ORDER_ID` FOREIGN KEY (`order_id`) REFERENCES `sales_order` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `downloadable_link_purchased`
--

LOCK TABLES `downloadable_link_purchased` WRITE;
/*!40000 ALTER TABLE `downloadable_link_purchased` DISABLE KEYS */;
/*!40000 ALTER TABLE `downloadable_link_purchased` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `downloadable_link_purchased_item`
--

DROP TABLE IF EXISTS `downloadable_link_purchased_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `downloadable_link_purchased_item` (
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
  KEY `DOWNLOADALBE_LINK_HASH` (`link_hash`),
  CONSTRAINT `FK_DOWNLOADABLE_LINK_PURCHASED_ID` FOREIGN KEY (`purchased_id`) REFERENCES `downloadable_link_purchased` (`purchased_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_DOWNLOADABLE_ORDER_ITEM_ID` FOREIGN KEY (`order_item_id`) REFERENCES `sales_flat_order_item` (`item_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `downloadable_link_purchased_item`
--

LOCK TABLES `downloadable_link_purchased_item` WRITE;
/*!40000 ALTER TABLE `downloadable_link_purchased_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `downloadable_link_purchased_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `downloadable_link_title`
--

DROP TABLE IF EXISTS `downloadable_link_title`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `downloadable_link_title` (
  `title_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `link_id` int(10) unsigned NOT NULL DEFAULT '0',
  `store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `title` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`title_id`),
  KEY `DOWNLOADABLE_LINK_TITLE_LINK` (`link_id`),
  KEY `DOWNLOADABLE_LINK_TITLE_STORE` (`store_id`),
  CONSTRAINT `FK_DOWNLOADABLE_LINK_TITLE_STORE` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_DOWNLOADABLE_LINK_TITLE_LINK` FOREIGN KEY (`link_id`) REFERENCES `downloadable_link` (`link_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `downloadable_link_title`
--

LOCK TABLES `downloadable_link_title` WRITE;
/*!40000 ALTER TABLE `downloadable_link_title` DISABLE KEYS */;
/*!40000 ALTER TABLE `downloadable_link_title` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `downloadable_sample`
--

DROP TABLE IF EXISTS `downloadable_sample`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `downloadable_sample` (
  `sample_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `product_id` int(10) unsigned NOT NULL DEFAULT '0',
  `sample_url` varchar(255) NOT NULL DEFAULT '',
  `sample_file` varchar(255) NOT NULL DEFAULT '',
  `sample_type` varchar(20) NOT NULL DEFAULT '',
  `sort_order` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`sample_id`),
  KEY `DOWNLODABLE_SAMPLE_PRODUCT` (`product_id`),
  CONSTRAINT `FK_DOWNLODABLE_SAMPLE_PRODUCT` FOREIGN KEY (`product_id`) REFERENCES `catalog_product_entity` (`entity_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `downloadable_sample`
--

LOCK TABLES `downloadable_sample` WRITE;
/*!40000 ALTER TABLE `downloadable_sample` DISABLE KEYS */;
/*!40000 ALTER TABLE `downloadable_sample` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `downloadable_sample_title`
--

DROP TABLE IF EXISTS `downloadable_sample_title`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `downloadable_sample_title` (
  `title_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `sample_id` int(10) unsigned NOT NULL DEFAULT '0',
  `store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `title` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`title_id`),
  KEY `DOWNLOADABLE_SAMPLE_TITLE_SAMPLE` (`sample_id`),
  KEY `DOWNLOADABLE_SAMPLE_TITLE_STORE` (`store_id`),
  CONSTRAINT `FK_DOWNLOADABLE_SAMPLE_TITLE_STORE` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_DOWNLOADABLE_SAMPLE_TITLE_SAMPLE` FOREIGN KEY (`sample_id`) REFERENCES `downloadable_sample` (`sample_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `downloadable_sample_title`
--

LOCK TABLES `downloadable_sample_title` WRITE;
/*!40000 ALTER TABLE `downloadable_sample_title` DISABLE KEYS */;
/*!40000 ALTER TABLE `downloadable_sample_title` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eav_attribute`
--

DROP TABLE IF EXISTS `eav_attribute`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `eav_attribute` (
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
  KEY `IDX_USED_IN_PRODUCT_LISTING` (`entity_type_id`,`used_in_product_listing`),
  CONSTRAINT `FK_eav_attribute` FOREIGN KEY (`entity_type_id`) REFERENCES `eav_entity_type` (`entity_type_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=513 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eav_attribute`
--

LOCK TABLES `eav_attribute` WRITE;
/*!40000 ALTER TABLE `eav_attribute` DISABLE KEYS */;
INSERT INTO `eav_attribute` VALUES (1,1,'website_id',NULL,'customer/customer_attribute_backend_website','static','','','select','','Associate to Website','','customer/customer_attribute_source_website',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',1,'',0),(2,1,'store_id',NULL,'customer/customer_attribute_backend_store','static','','','select','','Create In','','customer/customer_attribute_source_store',1,0,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',1,'',0),(3,1,'created_in',NULL,'','varchar','','','text','','Created From','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',1,'',0),(4,1,'prefix',NULL,'','varchar','','','text','','Prefix','','',1,1,0,0,'',0,0,0,0,0,0,1,0,0,0,1,'',1,'',0),(5,1,'firstname',NULL,'','varchar','','','text','','First Name','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',1,'',0),(6,1,'middlename',NULL,'','varchar','','','text','','Middle Name/Initial','','',1,1,0,0,'',0,0,0,0,0,0,1,0,0,0,1,'',1,'',0),(7,1,'lastname',NULL,'','varchar','','','text','','Last Name','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',1,'',0),(8,1,'suffix',NULL,'','varchar','','','text','','Suffix','','',1,1,0,0,'',0,0,0,0,0,0,1,0,0,0,1,'',1,'',0),(9,1,'email',NULL,'','static','','','text','','Email','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',1,'',0),(10,1,'group_id',NULL,'','static','','','select','','Customer Group','','customer/customer_attribute_source_group',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',1,'',0),(11,1,'dob',NULL,'eav/entity_attribute_backend_datetime','datetime','','','date','','Date Of Birth','','',1,1,0,0,'',0,0,0,0,0,0,1,0,0,0,1,'',1,'',0),(12,1,'password_hash',NULL,'customer/customer_attribute_backend_password','varchar','','','hidden','','','','',1,1,0,0,'',0,0,0,0,0,0,1,0,0,0,1,'',1,'',0),(13,1,'default_billing',NULL,'customer/customer_attribute_backend_billing','int','','','text','','','','',1,0,0,0,'',0,0,0,0,0,0,1,0,0,0,1,'',1,'',0),(14,1,'default_shipping',NULL,'customer/customer_attribute_backend_shipping','int','','','text','','','','',1,0,0,0,'',0,0,0,0,0,0,1,0,0,0,1,'',1,'',0),(15,1,'taxvat',NULL,'','varchar','','','text','','Tax/VAT number','','',1,1,0,0,'',0,0,0,0,0,0,1,0,0,0,1,'',1,'',0),(16,1,'confirmation',NULL,'','varchar','','','text','','Is confirmed','','',1,0,0,0,'',0,0,0,0,0,0,1,0,0,0,1,'',1,'',0),(17,2,'prefix',NULL,'','varchar','','','text','','Prefix','','',1,1,0,0,'',0,0,0,0,0,0,1,0,0,0,1,'',1,'',0),(18,2,'firstname',NULL,'','varchar','','','text','','First Name','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',1,'',0),(19,2,'middlename',NULL,'','varchar','','','text','','Middle Name/Initial','','',1,1,0,0,'',0,0,0,0,0,0,1,0,0,0,1,'',1,'',0),(20,2,'lastname',NULL,'','varchar','','','text','','Last Name','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',1,'',0),(21,2,'suffix',NULL,'','varchar','','','text','','Suffix','','',1,1,0,0,'',0,0,0,0,0,0,1,0,0,0,1,'',1,'',0),(22,2,'company',NULL,'','varchar','','','text','','Company','','',1,1,0,0,'',0,0,0,0,0,0,1,0,0,0,1,'',1,'',0),(23,2,'street',NULL,'customer_entity/address_attribute_backend_street','text','','','multiline','','Street Address','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',1,'',0),(24,2,'city',NULL,'','varchar','','','text','','City','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',1,'',0),(25,2,'country_id',NULL,'','varchar','','','select','','Country','','customer_entity/address_attribute_source_country',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',1,'',0),(26,2,'region',NULL,'customer_entity/address_attribute_backend_region','varchar','','','text','','State/Province','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',1,'',0),(27,2,'region_id',NULL,'','int','','','hidden','','','','customer_entity/address_attribute_source_region',1,1,0,0,'',0,0,0,0,0,0,1,0,0,0,1,'',1,'',0),(28,2,'postcode',NULL,'','varchar','','','text','','Zip/Postal Code','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',1,'',0),(29,2,'telephone',NULL,'','varchar','','','text','','Telephone','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',1,'',0),(30,2,'fax',NULL,'','varchar','','','text','','Fax','','',1,1,0,0,'',0,0,0,0,0,0,1,0,0,0,1,'',1,'',0),(31,3,'name',NULL,'','varchar','','','text','','Name','','',0,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',1,'',0),(32,3,'is_active',NULL,'','int','','','select','','Is Active','','eav/entity_attribute_source_boolean',0,1,0,0,'',0,0,0,0,0,0,1,0,0,0,1,'',1,'',0),(33,3,'url_key',NULL,'catalog/category_attribute_backend_urlkey','varchar','','','text','','URL key','','',1,1,0,0,'',0,0,0,0,0,0,1,0,0,0,1,'',1,'',0),(34,3,'description',NULL,'','text','','','textarea','','Description','','',0,1,0,0,'',0,0,0,0,0,0,1,0,0,0,1,'',1,'',0),(35,3,'image',NULL,'catalog/category_attribute_backend_image','varchar','','','image','','Image','','',0,1,0,0,'',0,0,0,0,0,0,1,0,0,0,1,'',1,'',0),(36,3,'meta_title',NULL,'','varchar','','','text','','Page Title','','',0,1,0,0,'',0,0,0,0,0,0,1,0,0,0,1,'',1,'',0),(37,3,'meta_keywords',NULL,'','text','','','textarea','','Meta Keywords','','',0,1,0,0,'',0,0,0,0,0,0,1,0,0,0,1,'',1,'',0),(38,3,'meta_description',NULL,'','text','','','textarea','','Meta Description','','',0,1,0,0,'',0,0,0,0,0,0,1,0,0,0,1,'',1,'',0),(39,3,'display_mode',NULL,'','varchar','','','select','','Display Mode','','catalog/category_attribute_source_mode',0,1,0,0,'',0,0,0,0,0,0,1,0,0,0,1,'',1,'',0),(40,3,'landing_page',NULL,'','int','','','select','','CMS Block','','catalog/category_attribute_source_page',0,1,0,0,'',0,0,0,0,0,0,1,0,0,0,1,'',1,'',0),(41,3,'is_anchor',NULL,'','int','','','select','','Is Anchor','','eav/entity_attribute_source_boolean',1,1,0,0,'',0,0,0,0,0,0,1,0,0,0,1,'',1,'',0),(42,3,'path',NULL,'','static','','','','','Path','','',1,0,0,0,'',0,0,0,0,0,0,1,0,0,0,1,'',1,'',0),(43,3,'position',NULL,'','static','','','','','Position','','',1,0,0,0,'',0,0,0,0,0,0,1,0,0,0,1,'',1,'',0),(44,3,'all_children',NULL,'','text','','','','','','','',1,0,0,0,'',0,0,0,0,0,0,1,0,0,0,1,'',1,'',0),(45,3,'path_in_store',NULL,'','text','','','','','','','',1,0,0,0,'',0,0,0,0,0,0,1,0,0,0,1,'',1,'',0),(46,3,'children',NULL,'','text','','','','','','','',1,0,0,0,'',0,0,0,0,0,0,1,0,0,0,1,'',1,'',0),(47,3,'url_path',NULL,'','varchar','','','','','','','',0,0,0,0,'',0,0,0,0,0,1,1,0,0,0,1,'',1,'',0),(48,3,'custom_design',NULL,'','varchar','','','select','','Custom Design','','core/design_source_design',0,1,0,0,'',0,0,0,0,0,0,1,0,0,0,1,'',1,'',0),(49,3,'custom_design_apply',NULL,'','int','','','select','','Apply To','','core/design_source_apply',0,1,0,0,'',0,0,0,0,0,0,1,0,0,0,1,'',1,'',0),(50,3,'custom_design_from',NULL,'eav/entity_attribute_backend_datetime','datetime','','','date','','Active From','','',0,1,0,0,'',0,0,0,0,0,0,1,0,0,0,1,'',1,'',0),(51,3,'custom_design_to',NULL,'eav/entity_attribute_backend_datetime','datetime','','','date','','Active To','','',0,1,0,0,'',0,0,0,0,0,0,1,0,0,0,1,'',1,'',0),(52,3,'page_layout',NULL,'','varchar','','','select','','Page Layout','','catalog/category_attribute_source_layout',0,1,0,0,'',0,0,0,0,0,0,1,0,0,0,1,'',1,'',0),(53,3,'custom_layout_update',NULL,'','text','','','textarea','','Custom Layout Update','','',0,1,0,0,'',0,0,0,0,0,0,1,0,0,0,1,'',1,'',0),(54,3,'level',NULL,'','static','','','','','Level','','',1,0,0,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(55,3,'children_count',NULL,'','static','','','','','Children Count','','',1,0,0,0,'',0,0,0,0,0,0,1,0,0,0,1,'',1,'',0),(56,4,'name',NULL,'','varchar','','','text','','Name','','',0,1,1,0,'',1,0,0,0,0,0,1,0,1,1,1,'',1,'',1),(57,4,'description',NULL,'','text','','','textarea','','Description','','',0,1,0,0,'',0,0,1,0,0,0,1,0,0,0,1,'',1,'',1),(58,4,'short_description',NULL,'','text','','','textarea','','Short Description','','',0,1,0,0,'',0,0,1,0,0,0,1,0,1,0,1,'',1,'',1),(59,4,'sku',NULL,'','static','','','text','','SKU','','',1,1,1,0,'',0,0,1,0,0,1,1,0,0,0,1,'',1,'',1),(60,4,'price',NULL,'catalog/product_attribute_backend_price','decimal','','','price','','Price','','',2,1,1,0,'',0,1,0,0,0,0,1,0,1,1,1,'simple,configurable,virtual,bundle,downloadable',0,'',1),(61,4,'special_price',NULL,'catalog/product_attribute_backend_price','decimal','','','price','','Special Price','','',2,1,0,0,'',0,0,0,0,0,0,1,0,1,0,1,'simple,configurable,virtual,bundle,downloadable',1,'',0),(62,4,'special_from_date',NULL,'catalog/product_attribute_backend_startdate','datetime','','','date','','Special Price From Date','','',2,1,0,0,'',0,0,0,0,0,0,1,0,1,0,1,'simple,configurable,virtual,bundle,downloadable',1,'',0),(63,4,'special_to_date',NULL,'eav/entity_attribute_backend_datetime','datetime','','','date','','Special Price To Date','','',2,1,0,0,'',0,0,0,0,0,0,1,0,1,0,1,'simple,configurable,virtual,bundle,downloadable',1,'',0),(64,4,'cost',NULL,'catalog/product_attribute_backend_price','decimal','','','price','','Cost','','',2,1,0,1,'',0,0,0,0,0,0,1,0,0,0,1,'simple,configurable,virtual,bundle,downloadable',1,'',0),(65,4,'weight',NULL,'','decimal','','','text','','Weight','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'simple,bundle',1,'',0),(66,4,'manufacturer',NULL,'','int','','','select','','Manufacturer','','',1,1,0,1,'',0,1,1,0,0,0,1,0,0,0,1,'simple',1,'',1),(67,4,'meta_title',NULL,'','varchar','','','text','','Meta Title','','',0,1,0,0,'',0,0,0,0,0,0,1,0,0,0,1,'',1,'',0),(68,4,'meta_keyword',NULL,'','text','','','textarea','','Meta Keywords','','',0,1,0,0,'',0,0,0,0,0,0,1,0,0,0,1,'',1,'',0),(69,4,'meta_description',NULL,'','varchar','','','textarea','','Meta Description','','',0,1,0,0,'',0,0,0,0,0,0,1,0,0,0,1,'',1,'Maximum 255 chars',0),(70,4,'image',NULL,'','varchar','','catalog/product_attribute_frontend_image','media_image','','Base Image','','',0,1,0,0,'',0,0,0,0,0,0,1,0,0,0,1,'',1,'',0),(71,4,'small_image',NULL,'','varchar','','catalog/product_attribute_frontend_image','media_image','','Small Image','','',0,1,0,0,'',0,0,0,0,0,0,1,0,1,0,1,'',1,'',0),(72,4,'thumbnail',NULL,'','varchar','','catalog/product_attribute_frontend_image','media_image','','Thumbnail','','',0,1,0,0,'',0,0,0,0,0,0,1,0,1,0,1,'',1,'',0),(73,4,'media_gallery',NULL,'catalog/product_attribute_backend_media','varchar','','','gallery','','Media Gallery','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',1,'',0),(74,4,'old_id',NULL,'','int','','','','','','','',1,0,0,0,'',0,0,0,0,0,0,1,0,0,0,1,'',1,'',0),(75,4,'tier_price',NULL,'catalog/product_attribute_backend_tierprice','decimal','','','text','','Tier Price','','',2,1,0,0,'',0,0,0,0,0,0,0,0,0,0,1,'simple,configurable,virtual,bundle,downloadable',1,'',0),(76,4,'color',NULL,'','int','','','select','','Color','','',1,1,0,1,'',0,1,1,0,0,0,1,0,0,0,1,'simple',1,'',1),(77,4,'news_from_date',NULL,'eav/entity_attribute_backend_datetime','datetime','','','date','','Set Product as New from Date','','',2,1,0,0,'',0,0,0,0,0,0,1,0,1,0,1,'',1,'',0),(78,4,'news_to_date',NULL,'eav/entity_attribute_backend_datetime','datetime','','','date','','Set Product as New to Date','','',2,1,0,0,'',0,0,0,0,0,0,1,0,1,0,1,'',1,'',0),(79,4,'gallery',NULL,'','varchar','','','gallery','','Image Gallery','','',1,1,0,0,'',0,0,0,0,0,0,1,0,0,0,1,'',1,'',0),(80,4,'status',NULL,'','int','','','select','','Status','','catalog/product_status',2,1,1,0,'',0,0,0,0,0,0,1,0,1,0,1,'',1,'',0),(81,4,'tax_class_id',NULL,'','int','','','select','','Tax Class','','tax/class_source_product',2,1,1,0,'',0,0,0,0,0,0,1,0,1,0,1,'simple,configurable,virtual,bundle,downloadable',1,'',1),(82,4,'url_key',NULL,'catalog/product_attribute_backend_urlkey','varchar','','','text','','URL key','','',1,1,0,0,'',0,0,0,0,0,0,1,0,1,0,1,'',1,'',0),(83,4,'url_path',NULL,'','varchar','','','','','','','',0,0,0,0,'',0,0,0,0,0,1,1,0,0,0,1,'',1,'',0),(84,4,'minimal_price',NULL,'','decimal','','','price','','Minimal Price','','',0,0,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'simple,configurable,virtual,bundle,downloadable',1,'',0),(85,4,'visibility',NULL,'','int','','','select','','Visibility','','catalog/product_visibility',0,1,1,0,'4',0,0,0,0,0,0,1,0,0,0,1,'',1,'',0),(86,4,'custom_design',NULL,'','varchar','','','select','','Custom Design','','core/design_source_design',0,1,0,0,'',0,0,0,0,0,0,1,0,0,0,1,'',1,'',0),(87,4,'custom_design_from',NULL,'eav/entity_attribute_backend_datetime','datetime','','','date','','Active From','','',0,1,0,0,'',0,0,0,0,0,0,1,0,0,0,1,'',1,'',0),(88,4,'custom_design_to',NULL,'eav/entity_attribute_backend_datetime','datetime','','','date','','Active To','','',0,1,0,0,'',0,0,0,0,0,0,1,0,0,0,1,'',1,'',0),(89,4,'custom_layout_update',NULL,'','text','','','textarea','','Custom Layout Update','','',1,1,0,0,'',0,0,0,0,0,0,1,0,0,0,1,'',1,'',0),(90,4,'page_layout',NULL,'','varchar','','','select','','Page Layout','','catalog/product_attribute_source_layout',0,1,0,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(91,4,'category_ids',NULL,'','static','','','','','','','',1,0,0,0,'',0,0,0,0,0,0,1,0,0,0,1,'',1,'',0),(92,4,'options_container',NULL,'','varchar','','','select','','Display product options in','','catalog/entity_product_attribute_design_options_container',0,1,0,0,'container2',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(93,4,'required_options',NULL,'','static','','','text','','','','',1,0,1,0,'',0,0,0,0,0,0,1,0,1,0,1,'',0,'',0),(94,4,'has_options',NULL,'','static','','','text','','','','',1,0,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(95,4,'image_label',NULL,'','varchar','','','text','','Image Label','','',0,0,0,0,'',0,0,0,0,0,0,1,0,1,0,0,'',0,'',0),(96,4,'small_image_label',NULL,'','varchar','','','text','','Small Image Label','','',0,0,0,0,'',0,0,0,0,0,0,1,0,1,0,0,'',0,'',0),(97,4,'thumbnail_label',NULL,'','varchar','','','text','','Thumbnail Label','','',0,0,0,0,'',0,0,0,0,0,0,1,0,1,0,0,'',0,'',0),(98,3,'available_sort_by',NULL,'catalog/category_attribute_backend_sortby','text','','','multiselect','adminhtml/catalog_category_helper_sortby_available','Available Product Listing Sort by','','catalog/category_attribute_source_sortby',0,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(99,3,'default_sort_by',NULL,'catalog/category_attribute_backend_sortby','varchar','','','select','adminhtml/catalog_category_helper_sortby_default','Default Product Listing Sort by','','catalog/category_attribute_source_sortby',0,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(100,4,'created_at',NULL,'eav/entity_attribute_backend_time_created','static','','','text','','','','',1,0,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(101,4,'updated_at',NULL,'eav/entity_attribute_backend_time_updated','static','','','text','','','','',1,0,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(102,11,'entity_id',NULL,'sales_entity/order_attribute_backend_parent','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(103,11,'store_id',NULL,'','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(104,11,'store_name',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(105,11,'remote_ip',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(106,11,'status',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(107,11,'state',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(108,11,'hold_before_status',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(109,11,'hold_before_state',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(110,11,'relation_parent_id',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(111,11,'relation_parent_real_id',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(112,11,'relation_child_id',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(113,11,'relation_child_real_id',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(114,11,'original_increment_id',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(115,11,'edit_increment',NULL,'','int','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(116,11,'ext_order_id',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(117,11,'ext_customer_id',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(118,11,'quote_id',NULL,'','int','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(119,11,'quote_address_id',NULL,'','int','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(120,11,'billing_address_id',NULL,'sales_entity/order_attribute_backend_billing','int','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(121,11,'shipping_address_id',NULL,'sales_entity/order_attribute_backend_shipping','int','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(122,11,'coupon_code',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(123,11,'applied_rule_ids',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(124,11,'giftcert_code',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(125,11,'global_currency_code',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(126,11,'base_currency_code',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(127,11,'store_currency_code',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(128,11,'order_currency_code',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(129,11,'store_to_base_rate',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(130,11,'store_to_order_rate',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(131,11,'base_to_global_rate',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(132,11,'base_to_order_rate',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(133,11,'is_virtual',NULL,'','int','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(134,11,'shipping_method',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(135,11,'shipping_description',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(136,11,'weight',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(137,11,'tax_amount',NULL,'','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(138,11,'shipping_amount',NULL,'','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(139,11,'shipping_tax_amount',NULL,'','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(140,11,'discount_amount',NULL,'','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(141,11,'giftcert_amount',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(142,11,'subtotal',NULL,'','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(143,11,'grand_total',NULL,'','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(144,11,'total_paid',NULL,'','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(145,11,'total_due',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(146,11,'total_refunded',NULL,'','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(147,11,'total_qty_ordered',NULL,'','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(148,11,'total_canceled',NULL,'','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(149,11,'total_invoiced',NULL,'','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(150,11,'total_online_refunded',NULL,'','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(151,11,'total_offline_refunded',NULL,'','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(152,11,'adjustment_positive',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(153,11,'adjustment_negative',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(154,11,'base_tax_amount',NULL,'','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(155,11,'base_shipping_amount',NULL,'','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(156,11,'base_shipping_tax_amount',NULL,'','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(157,11,'base_discount_amount',NULL,'','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(158,11,'base_giftcert_amount',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(159,11,'base_subtotal',NULL,'','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(160,11,'base_grand_total',NULL,'','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(161,11,'base_total_paid',NULL,'','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(162,11,'base_total_due',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(163,11,'base_total_refunded',NULL,'','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(164,11,'base_total_qty_ordered',NULL,'','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(165,11,'base_total_canceled',NULL,'','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(166,11,'base_total_invoiced',NULL,'','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(167,11,'base_total_online_refunded',NULL,'','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(168,11,'base_total_offline_refunded',NULL,'','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(169,11,'base_adjustment_positive',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(170,11,'base_adjustment_negative',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(171,11,'subtotal_refunded',NULL,'','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(172,11,'subtotal_canceled',NULL,'','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(173,11,'discount_refunded',NULL,'','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(174,11,'discount_canceled',NULL,'','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(175,11,'discount_invoiced',NULL,'','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(176,11,'subtotal_invoiced',NULL,'','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(177,11,'tax_refunded',NULL,'','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(178,11,'tax_canceled',NULL,'','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(179,11,'tax_invoiced',NULL,'','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(180,11,'shipping_refunded',NULL,'','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(181,11,'shipping_canceled',NULL,'','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(182,11,'shipping_invoiced',NULL,'','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(183,11,'base_subtotal_refunded',NULL,'','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(184,11,'base_subtotal_canceled',NULL,'','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(185,11,'base_discount_refunded',NULL,'','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(186,11,'base_discount_canceled',NULL,'','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(187,11,'base_discount_invoiced',NULL,'','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(188,11,'base_subtotal_invoiced',NULL,'','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(189,11,'base_tax_refunded',NULL,'','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(190,11,'base_tax_canceled',NULL,'','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(191,11,'base_tax_invoiced',NULL,'','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(192,11,'base_shipping_refunded',NULL,'','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(193,11,'base_shipping_canceled',NULL,'','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(194,11,'base_shipping_invoiced',NULL,'','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(195,11,'customer_id',NULL,'','static','','','text','','','','',1,0,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(196,11,'customer_group_id',NULL,'','int','','','text','','','','',1,0,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(197,11,'customer_email',NULL,'','varchar','','','text','','','','',1,0,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(198,11,'customer_prefix',NULL,'','varchar','','','text','','','','',1,0,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(199,11,'customer_firstname',NULL,'','varchar','','','text','','','','',1,0,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(200,11,'customer_middlename',NULL,'','varchar','','','text','','','','',1,0,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(201,11,'customer_lastname',NULL,'','varchar','','','text','','','','',1,0,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(202,11,'customer_suffix',NULL,'','varchar','','','text','','','','',1,0,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(203,11,'customer_note',NULL,'','text','','','text','','','','',1,0,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(204,11,'customer_note_notify',NULL,'','int','','','text','','','','',1,0,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(205,11,'customer_is_guest',NULL,'','int','','','text','','','','',1,0,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(206,11,'email_sent',NULL,'','int','','','text','','','','',1,0,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(207,11,'customer_taxvat',NULL,'','varchar','','','text','','','','',1,0,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(208,11,'customer_dob',NULL,'eav/entity_attribute_backend_datetime','datetime','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(209,12,'parent_id',NULL,'sales_entity/order_attribute_backend_child','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(210,12,'quote_address_id',NULL,'','int','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(211,12,'address_type',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(212,12,'customer_id',NULL,'','int','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(213,12,'customer_address_id',NULL,'','int','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(214,12,'email',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(215,12,'prefix',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(216,12,'firstname',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(217,12,'middlename',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(218,12,'lastname',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(219,12,'suffix',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(220,12,'company',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(221,12,'street',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(222,12,'city',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(223,12,'region',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(224,12,'region_id',NULL,'','int','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(225,12,'postcode',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(226,12,'country_id',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(227,12,'telephone',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(228,12,'fax',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(229,13,'parent_id',NULL,'sales_entity/order_attribute_backend_child','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(230,13,'quote_item_id',NULL,'','int','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(231,13,'product_id',NULL,'','int','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(232,13,'super_product_id',NULL,'','int','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(233,13,'parent_product_id',NULL,'','int','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(234,13,'is_virtual',NULL,'','int','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(235,13,'sku',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(236,13,'name',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(237,13,'description',NULL,'','text','','','text','','','','',1,1,0,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(238,13,'weight',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(239,13,'is_qty_decimal',NULL,'','int','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(240,13,'qty_ordered',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(241,13,'qty_backordered',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(242,13,'qty_invoiced',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(243,13,'qty_canceled',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(244,13,'qty_shipped',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(245,13,'qty_refunded',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(246,13,'original_price',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(247,13,'price',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(248,13,'cost',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(249,13,'discount_percent',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(250,13,'discount_amount',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(251,13,'discount_invoiced',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(252,13,'tax_percent',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(253,13,'tax_amount',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(254,13,'tax_invoiced',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(255,13,'row_total',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(256,13,'row_weight',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(257,13,'row_invoiced',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(258,13,'invoiced_total',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(259,13,'amount_refunded',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(260,13,'base_price',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(261,13,'base_original_price',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(262,13,'base_discount_amount',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(263,13,'base_discount_invoiced',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(264,13,'base_tax_amount',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(265,13,'base_tax_invoiced',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(266,13,'base_row_total',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(267,13,'base_row_invoiced',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(268,13,'base_invoiced_total',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(269,13,'base_amount_refunded',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(270,13,'applied_rule_ids',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(271,13,'additional_data',NULL,'','text','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(272,14,'parent_id',NULL,'sales_entity/order_attribute_backend_child','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(273,14,'quote_payment_id',NULL,'','int','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(274,14,'method',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(275,14,'additional_data',NULL,'','text','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(276,14,'last_trans_id',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(277,14,'po_number',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(278,14,'cc_type',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(279,14,'cc_number_enc',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(280,14,'cc_last4',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(281,14,'cc_owner',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(282,14,'cc_exp_month',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(283,14,'cc_exp_year',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(284,14,'cc_ss_issue',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(285,14,'cc_ss_start_month',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(286,14,'cc_ss_start_year',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(287,14,'cc_status',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(288,14,'cc_status_description',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(289,14,'cc_trans_id',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(290,14,'cc_approval',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(291,14,'cc_avs_status',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(292,14,'cc_cid_status',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(293,14,'cc_debug_request_body',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(294,14,'cc_debug_response_body',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(295,14,'cc_debug_response_serialized',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(296,14,'anet_trans_method',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(297,14,'echeck_routing_number',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(298,14,'echeck_bank_name',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(299,14,'echeck_account_type',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(300,14,'echeck_account_name',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(301,14,'echeck_type',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(302,14,'amount_ordered',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(303,14,'amount_authorized',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(304,14,'amount_paid',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(305,14,'amount_canceled',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(306,14,'amount_refunded',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(307,14,'shipping_amount',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(308,14,'shipping_captured',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(309,14,'shipping_refunded',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(310,14,'base_amount_ordered',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(311,14,'base_amount_authorized',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(312,14,'base_amount_paid',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(313,14,'base_amount_canceled',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(314,14,'base_amount_refunded',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(315,14,'base_shipping_amount',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(316,14,'base_shipping_captured',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(317,14,'base_shipping_refunded',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(318,15,'parent_id',NULL,'sales_entity/order_attribute_backend_child','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(319,15,'status',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(320,15,'comment',NULL,'','text','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(321,15,'is_customer_notified',NULL,'','int','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(322,16,'entity_id',NULL,'sales_entity/order_invoice_attribute_backend_parent','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(323,16,'state',NULL,'','int','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(324,16,'is_used_for_refund',NULL,'','int','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(325,16,'transaction_id',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(326,16,'order_id',NULL,'sales_entity/order_invoice_attribute_backend_order','int','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(327,16,'billing_address_id',NULL,'','int','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(328,16,'shipping_address_id',NULL,'','int','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(329,16,'global_currency_code',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(330,16,'base_currency_code',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(331,16,'store_currency_code',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(332,16,'order_currency_code',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(333,16,'store_to_base_rate',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(334,16,'store_to_order_rate',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(335,16,'base_to_global_rate',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(336,16,'base_to_order_rate',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(337,16,'subtotal',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(338,16,'discount_amount',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(339,16,'tax_amount',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(340,16,'shipping_amount',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(341,16,'grand_total',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(342,16,'total_qty',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(343,16,'can_void_flag',NULL,'','int','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(344,16,'base_subtotal',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(345,16,'base_discount_amount',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(346,16,'base_tax_amount',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(347,16,'base_shipping_amount',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(348,16,'base_grand_total',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(349,16,'email_sent',NULL,'','int','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(350,16,'store_id',NULL,'','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(351,17,'parent_id',NULL,'sales_entity/order_invoice_attribute_backend_child','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(352,17,'order_item_id',NULL,'','int','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(353,17,'product_id',NULL,'','int','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(354,17,'name',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(355,17,'description',NULL,'','text','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(356,17,'sku',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(357,17,'qty',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(358,17,'cost',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(359,17,'price',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(360,17,'discount_amount',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(361,17,'tax_amount',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(362,17,'row_total',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(363,17,'base_price',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(364,17,'base_discount_amount',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(365,17,'base_tax_amount',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(366,17,'base_row_total',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(367,17,'additional_data',NULL,'','text','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(368,18,'parent_id',NULL,'sales_entity/order_invoice_attribute_backend_child','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(369,18,'comment',NULL,'','text','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(370,18,'is_customer_notified',NULL,'','int','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(371,19,'entity_id',NULL,'sales_entity/order_shipment_attribute_backend_parent','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(372,19,'customer_id',NULL,'','int','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(373,19,'order_id',NULL,'','int','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(374,19,'shipment_status',NULL,'','int','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(375,19,'billing_address_id',NULL,'','int','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(376,19,'shipping_address_id',NULL,'','int','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(377,19,'total_qty',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(378,19,'total_weight',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(379,19,'email_sent',NULL,'','int','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(380,19,'store_id',NULL,'','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(381,20,'parent_id',NULL,'sales_entity/order_shipment_attribute_backend_child','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(382,20,'order_item_id',NULL,'','int','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(383,20,'product_id',NULL,'','int','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(384,20,'name',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(385,20,'description',NULL,'','text','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(386,20,'sku',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(387,20,'qty',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(388,20,'price',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(389,20,'weight',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(390,20,'row_total',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(391,20,'additional_data',NULL,'','text','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(392,21,'parent_id',NULL,'sales_entity/order_shipment_attribute_backend_child','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(393,21,'comment',NULL,'','text','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(394,21,'is_customer_notified',NULL,'','int','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(395,22,'parent_id',NULL,'sales_entity/order_shipment_attribute_backend_child','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(396,22,'order_id',NULL,'','int','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(397,22,'number',NULL,'','text','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(398,22,'carrier_code',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(399,22,'title',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(400,22,'description',NULL,'','text','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(401,22,'qty',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(402,22,'weight',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(403,23,'entity_id',NULL,'sales_entity/order_creditmemo_attribute_backend_parent','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(404,23,'state',NULL,'','int','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(405,23,'invoice_id',NULL,'','int','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(406,23,'transaction_id',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(407,23,'order_id',NULL,'','int','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(408,23,'creditmemo_status',NULL,'','int','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(409,23,'billing_address_id',NULL,'','int','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(410,23,'shipping_address_id',NULL,'','int','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(411,23,'global_currency_code',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(412,23,'base_currency_code',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(413,23,'store_currency_code',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(414,23,'order_currency_code',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(415,23,'store_to_base_rate',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(416,23,'store_to_order_rate',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(417,23,'base_to_global_rate',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(418,23,'base_to_order_rate',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(419,23,'subtotal',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(420,23,'discount_amount',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(421,23,'tax_amount',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(422,23,'shipping_amount',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(423,23,'adjustment',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(424,23,'adjustment_positive',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(425,23,'adjustment_negative',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(426,23,'grand_total',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(427,23,'base_subtotal',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(428,23,'base_discount_amount',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(429,23,'base_tax_amount',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(430,23,'base_shipping_amount',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(431,23,'base_adjustment',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(432,23,'base_adjustment_positive',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(433,23,'base_adjustment_negative',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(434,23,'base_grand_total',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(435,23,'email_sent',NULL,'','int','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(436,23,'store_id',NULL,'','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(437,24,'parent_id',NULL,'sales_entity/order_creditmemo_attribute_backend_child','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(438,24,'order_item_id',NULL,'','int','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(439,24,'product_id',NULL,'','int','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(440,24,'name',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(441,24,'description',NULL,'','text','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(442,24,'sku',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(443,24,'qty',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(444,24,'cost',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(445,24,'price',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(446,24,'discount_amount',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(447,24,'tax_amount',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(448,24,'row_total',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(449,24,'base_price',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(450,24,'base_discount_amount',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(451,24,'base_tax_amount',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(452,24,'base_row_total',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(453,24,'additional_data',NULL,'','text','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(454,25,'parent_id',NULL,'sales_entity/order_creditmemo_attribute_backend_child','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(455,25,'comment',NULL,'','text','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(456,25,'is_customer_notified',NULL,'','int','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(457,13,'product_type',NULL,'','varchar','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(458,11,'can_ship_partially',NULL,'','int','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(459,11,'can_ship_partially_item',NULL,'','int','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(460,11,'payment_authorization_amount',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(461,11,'payment_authorization_expiration',NULL,'','int','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(462,11,'shipping_tax_refunded',NULL,'','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(463,11,'base_shipping_tax_refunded',NULL,'','static','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(465,11,'forced_do_shipment_with_invoice',NULL,'','int','','','text','','','','',1,1,1,0,'0',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(466,11,'paypal_ipn_customer_notified',NULL,'','int','','','text','','','','',1,0,1,0,'0',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(467,4,'enable_googlecheckout',NULL,'','int','','','select','','Is product available for purchase with Google Checkout','','eav/entity_attribute_source_boolean',1,1,0,0,'1',0,0,0,0,0,0,1,0,0,0,0,'',0,'',0),(468,11,'gift_message_id',NULL,'','int','','','text','','','','',1,0,0,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(469,4,'gift_message_available',NULL,'giftmessage/entity_attribute_backend_boolean_config','varchar','','','select','','Allow Gift Message','','giftmessage/entity_attribute_source_boolean_config',1,1,0,0,'2',0,0,0,0,0,0,1,0,0,0,0,'',0,'',0),(470,4,'price_type',NULL,'','int','','','','','','','',1,0,1,0,'',0,0,0,0,0,0,1,0,1,0,0,'bundle',0,'',0),(471,4,'sku_type',NULL,'','int','','','','','','','',1,0,1,0,'',0,0,0,0,0,0,1,0,0,0,0,'bundle',0,'',0),(472,4,'weight_type',NULL,'','int','','','','','','','',1,0,1,0,'',0,0,0,0,0,0,1,0,1,0,0,'bundle',0,'',0),(473,4,'price_view',NULL,'','int','','','select','','Price View','','bundle/product_attribute_source_price_view',1,1,1,0,'',0,0,0,0,0,0,1,0,1,0,0,'bundle',0,'',0),(474,4,'shipment_type',NULL,'','int','','','','','Shipment','','',1,0,1,0,'',0,0,0,0,0,0,1,0,1,0,0,'bundle',0,'',0),(475,4,'links_purchased_separately',NULL,'','int','','','','','Links can be purchased separately','','',1,0,1,0,'',0,0,0,0,0,0,1,0,0,0,0,'downloadable',0,'',0),(476,4,'samples_title',NULL,'','varchar','','','','','Samples title','','',0,0,1,0,'',0,0,0,0,0,0,1,0,0,0,0,'downloadable',0,'',0),(477,4,'links_title',NULL,'','varchar','','','','','Links title','','',0,0,1,0,'',0,0,0,0,0,0,1,0,0,0,0,'downloadable',0,'',0),(478,24,'base_weee_tax_applied_amount',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(479,24,'base_weee_tax_applied_row_amount',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(480,24,'weee_tax_applied_amount',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(481,24,'weee_tax_applied_row_amount',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(482,17,'base_weee_tax_applied_amount',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(483,17,'base_weee_tax_applied_row_amount',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(484,17,'weee_tax_applied_amount',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(485,17,'weee_tax_applied_row_amount',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(486,17,'weee_tax_applied',NULL,'','text','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(487,24,'weee_tax_applied',NULL,'','text','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(488,24,'weee_tax_disposition',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(489,24,'weee_tax_row_disposition',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(490,24,'base_weee_tax_disposition',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(491,24,'base_weee_tax_row_disposition',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(492,17,'weee_tax_disposition',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(493,17,'weee_tax_row_disposition',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(494,17,'base_weee_tax_disposition',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(495,17,'base_weee_tax_row_disposition',NULL,'','decimal','','','text','','','','',1,1,1,0,'',0,0,0,0,0,0,1,0,0,0,1,'',0,'',0),(496,4,'bo_author',NULL,NULL,'varchar',NULL,NULL,'text',NULL,'Author','',NULL,1,1,1,1,'',1,0,0,1,1,0,0,0,1,0,0,'',0,'',1),(497,4,'bo_ISBN',NULL,NULL,'varchar',NULL,NULL,'text',NULL,'ISBN-13','',NULL,1,1,1,1,NULL,1,0,0,1,1,1,0,0,1,0,0,'',0,'',1),(499,4,'bo_binding',NULL,NULL,'varchar',NULL,NULL,'text',NULL,'Binding','',NULL,2,1,0,1,'',0,0,0,1,1,0,0,0,0,0,0,'',0,'',1),(500,4,'bo_isbn10',NULL,NULL,'varchar',NULL,NULL,'text',NULL,'ISBN-10','validate-digits',NULL,1,1,0,1,'',0,0,0,1,1,1,0,0,1,0,0,'',0,'',1),(501,4,'bo_pu_date',NULL,'eav/entity_attribute_backend_datetime','datetime',NULL,'eav/entity_attribute_frontend_datetime','date',NULL,'Publishing Date','',NULL,0,1,0,1,'',0,0,0,1,0,0,0,0,1,0,0,'',0,'',1),(502,4,'bo_publisher',NULL,NULL,'text',NULL,NULL,'textarea',NULL,'Publisher','',NULL,1,1,1,1,'',0,0,0,1,1,0,0,0,1,0,0,'',0,'',1),(503,4,'bo_language',NULL,NULL,'varchar',NULL,NULL,'text',NULL,'Language','',NULL,1,1,1,1,'',0,0,0,1,1,0,0,0,1,0,0,'',0,'',0),(504,4,'bo_no_pg',NULL,NULL,'varchar',NULL,NULL,'text',NULL,'No of Pages','validate-digits',NULL,0,1,0,1,'',0,0,0,1,1,0,0,0,0,0,0,'',0,'',0),(505,4,'bo_dimension',NULL,NULL,'varchar',NULL,NULL,'text',NULL,'Dimension','',NULL,0,1,0,1,'',0,0,0,1,1,0,0,0,0,0,0,'',0,'',0),(506,4,'bo_illustrator',NULL,NULL,'varchar',NULL,NULL,'text',NULL,'illustrator','',NULL,0,1,0,1,'',0,0,0,1,1,0,0,0,0,0,0,'',0,'',1),(507,4,'bo_edition',NULL,NULL,'varchar',NULL,NULL,'text',NULL,'Edition','',NULL,0,1,0,1,'',0,0,0,1,1,0,0,0,0,0,0,'',0,'',1),(508,4,'bo_int_shipping',NULL,NULL,'int',NULL,NULL,'boolean',NULL,'International Shipping','',NULL,0,1,0,1,'0',0,0,0,1,0,0,0,0,0,0,0,'',0,'',1),(509,4,'bo_rating',NULL,NULL,'varchar',NULL,NULL,'text',NULL,'Rating','',NULL,0,1,0,1,'',0,0,0,1,1,0,0,0,0,0,0,'',0,'',0),(511,4,'bo_shipping_region',NULL,NULL,'varchar',NULL,NULL,'text',NULL,'Shipping Region','validate-digits',NULL,0,1,1,1,'',0,0,0,0,1,0,0,0,0,0,0,'',0,'',0),(512,4,'bo_sourced_from',NULL,NULL,'varchar',NULL,NULL,'text',NULL,'Sourced From','',NULL,0,1,1,1,'',0,0,0,0,1,0,0,0,0,0,0,'',0,'',0);
/*!40000 ALTER TABLE `eav_attribute` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eav_attribute_group`
--

DROP TABLE IF EXISTS `eav_attribute_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `eav_attribute_group` (
  `attribute_group_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `attribute_set_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `attribute_group_name` varchar(255) NOT NULL DEFAULT '',
  `sort_order` smallint(6) NOT NULL DEFAULT '0',
  `default_id` smallint(5) unsigned DEFAULT '0',
  PRIMARY KEY (`attribute_group_id`),
  UNIQUE KEY `attribute_set_id` (`attribute_set_id`,`attribute_group_name`),
  KEY `attribute_set_id_2` (`attribute_set_id`,`sort_order`),
  CONSTRAINT `FK_eav_attribute_group` FOREIGN KEY (`attribute_set_id`) REFERENCES `eav_attribute_set` (`attribute_set_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eav_attribute_group`
--

LOCK TABLES `eav_attribute_group` WRITE;
/*!40000 ALTER TABLE `eav_attribute_group` DISABLE KEYS */;
INSERT INTO `eav_attribute_group` VALUES (1,1,'General',1,1),(2,2,'General',1,1),(3,3,'General Information',10,1),(4,4,'General',1,1),(5,4,'Prices',2,0),(6,4,'Meta Information',3,0),(7,4,'Images',4,0),(8,4,'Design',6,0),(9,3,'Display Settings',20,0),(10,3,'Custom Design',30,0),(11,5,'General',1,1),(12,6,'General',1,1),(13,7,'General',1,1),(14,8,'General',1,1),(15,9,'General',1,1),(16,10,'General',1,1),(17,11,'General',1,1),(18,12,'General',1,1),(19,13,'General',1,1),(20,14,'General',1,1),(21,15,'General',1,1),(22,16,'General',1,1),(23,17,'General',1,1),(24,18,'General',1,1),(25,19,'General',1,1),(26,20,'General',1,1),(27,21,'General',1,1),(28,22,'General',1,1),(29,23,'General',1,1),(30,24,'General',1,1),(31,25,'General',1,1),(32,26,'General',1,1),(33,26,'Prices',2,0),(34,26,'Meta Information',3,0),(35,26,'Images',4,0),(36,26,'Design',5,0);
/*!40000 ALTER TABLE `eav_attribute_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eav_attribute_option`
--

DROP TABLE IF EXISTS `eav_attribute_option`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `eav_attribute_option` (
  `option_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `attribute_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `sort_order` smallint(5) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`option_id`),
  KEY `FK_ATTRIBUTE_OPTION_ATTRIBUTE` (`attribute_id`),
  CONSTRAINT `FK_ATTRIBUTE_OPTION_ATTRIBUTE` FOREIGN KEY (`attribute_id`) REFERENCES `eav_attribute` (`attribute_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Attributes option (for source model)';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eav_attribute_option`
--

LOCK TABLES `eav_attribute_option` WRITE;
/*!40000 ALTER TABLE `eav_attribute_option` DISABLE KEYS */;
/*!40000 ALTER TABLE `eav_attribute_option` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eav_attribute_option_value`
--

DROP TABLE IF EXISTS `eav_attribute_option_value`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `eav_attribute_option_value` (
  `value_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `option_id` int(10) unsigned NOT NULL DEFAULT '0',
  `store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `value` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`value_id`),
  KEY `FK_ATTRIBUTE_OPTION_VALUE_OPTION` (`option_id`),
  KEY `FK_ATTRIBUTE_OPTION_VALUE_STORE` (`store_id`),
  CONSTRAINT `FK_ATTRIBUTE_OPTION_VALUE_OPTION` FOREIGN KEY (`option_id`) REFERENCES `eav_attribute_option` (`option_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_ATTRIBUTE_OPTION_VALUE_STORE` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Attribute option values per store';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eav_attribute_option_value`
--

LOCK TABLES `eav_attribute_option_value` WRITE;
/*!40000 ALTER TABLE `eav_attribute_option_value` DISABLE KEYS */;
/*!40000 ALTER TABLE `eav_attribute_option_value` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eav_attribute_set`
--

DROP TABLE IF EXISTS `eav_attribute_set`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `eav_attribute_set` (
  `attribute_set_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `entity_type_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `attribute_set_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_swedish_ci NOT NULL DEFAULT '',
  `sort_order` smallint(6) NOT NULL DEFAULT '0',
  PRIMARY KEY (`attribute_set_id`),
  UNIQUE KEY `entity_type_id` (`entity_type_id`,`attribute_set_name`),
  KEY `entity_type_id_2` (`entity_type_id`,`sort_order`),
  CONSTRAINT `FK_eav_attribute_set` FOREIGN KEY (`entity_type_id`) REFERENCES `eav_entity_type` (`entity_type_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eav_attribute_set`
--

LOCK TABLES `eav_attribute_set` WRITE;
/*!40000 ALTER TABLE `eav_attribute_set` DISABLE KEYS */;
INSERT INTO `eav_attribute_set` VALUES (1,1,'Default',3),(2,2,'Default',3),(3,3,'Default',11),(4,4,'Default',11),(5,5,'Default',1),(6,6,'Default',1),(7,7,'Default',1),(8,8,'Default',1),(9,9,'Default',1),(10,10,'Default',1),(11,11,'Default',1),(12,12,'Default',1),(13,13,'Default',1),(14,14,'Default',1),(15,15,'Default',1),(16,16,'Default',1),(17,17,'Default',1),(18,18,'Default',1),(19,19,'Default',1),(20,20,'Default',1),(21,21,'Default',1),(22,22,'Default',1),(23,23,'Default',1),(24,24,'Default',1),(25,25,'Default',1),(26,4,'book',0);
/*!40000 ALTER TABLE `eav_attribute_set` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eav_entity`
--

DROP TABLE IF EXISTS `eav_entity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `eav_entity` (
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
  KEY `FK_ENTITY_STORE` (`store_id`),
  CONSTRAINT `FK_eav_entity` FOREIGN KEY (`entity_type_id`) REFERENCES `eav_entity_type` (`entity_type_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_eav_entity_store` FOREIGN KEY (`store_id`) REFERENCES `core_store` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Entityies';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eav_entity`
--

LOCK TABLES `eav_entity` WRITE;
/*!40000 ALTER TABLE `eav_entity` DISABLE KEYS */;
/*!40000 ALTER TABLE `eav_entity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eav_entity_attribute`
--

DROP TABLE IF EXISTS `eav_entity_attribute`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `eav_entity_attribute` (
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
) ENGINE=InnoDB AUTO_INCREMENT=902 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eav_entity_attribute`
--

LOCK TABLES `eav_entity_attribute` WRITE;
/*!40000 ALTER TABLE `eav_entity_attribute` DISABLE KEYS */;
INSERT INTO `eav_entity_attribute` VALUES (1,1,1,1,1,10),(2,1,1,1,2,20),(3,1,1,1,3,30),(4,1,1,1,4,37),(5,1,1,1,5,40),(6,1,1,1,6,43),(7,1,1,1,7,50),(8,1,1,1,8,53),(9,1,1,1,9,60),(10,1,1,1,10,70),(11,1,1,1,11,80),(12,1,1,1,12,81),(13,1,1,1,13,82),(14,1,1,1,14,83),(15,1,1,1,15,84),(16,1,1,1,16,85),(17,2,2,2,17,7),(18,2,2,2,18,10),(19,2,2,2,19,13),(20,2,2,2,20,20),(21,2,2,2,21,23),(22,2,2,2,22,30),(23,2,2,2,23,40),(24,2,2,2,24,50),(25,2,2,2,25,60),(26,2,2,2,26,70),(27,2,2,2,27,80),(28,2,2,2,28,90),(29,2,2,2,29,100),(30,2,2,2,30,110),(31,3,3,3,31,1),(32,3,3,3,32,2),(33,3,3,3,33,3),(34,3,3,3,34,4),(35,3,3,3,35,5),(36,3,3,3,36,6),(37,3,3,3,37,7),(38,3,3,3,38,8),(39,3,3,9,39,10),(40,3,3,9,40,20),(41,3,3,9,41,30),(42,3,3,3,42,12),(43,3,3,3,43,13),(44,3,3,3,44,14),(45,3,3,3,45,15),(46,3,3,3,46,16),(47,3,3,3,47,17),(48,3,3,10,48,10),(49,3,3,10,49,20),(50,3,3,10,50,30),(51,3,3,10,51,40),(52,3,3,10,52,50),(53,3,3,10,53,60),(54,3,3,3,54,24),(55,3,3,3,55,25),(56,4,4,4,56,1),(57,4,4,4,57,2),(58,4,4,4,58,3),(59,4,4,4,59,4),(60,4,4,5,60,1),(61,4,4,5,61,2),(62,4,4,5,62,3),(63,4,4,5,63,4),(64,4,4,5,64,5),(65,4,4,4,65,5),(66,4,4,4,66,6),(67,4,4,6,67,1),(68,4,4,6,68,2),(69,4,4,6,69,3),(70,4,4,7,70,1),(71,4,4,7,71,2),(72,4,4,7,72,3),(73,4,4,7,73,4),(74,4,4,4,74,7),(75,4,4,5,75,10),(76,4,4,4,76,8),(77,4,4,4,77,9),(78,4,4,4,78,10),(79,4,4,7,79,5),(80,4,4,4,80,11),(81,4,4,5,81,7),(82,4,4,4,82,12),(83,4,4,4,83,13),(84,4,4,5,84,8),(85,4,4,4,85,14),(86,4,4,8,86,1),(87,4,4,8,87,2),(88,4,4,8,88,3),(89,4,4,8,89,4),(90,4,4,8,90,5),(91,4,4,4,91,15),(92,4,4,8,92,6),(93,4,4,4,93,16),(94,4,4,4,94,17),(95,4,4,4,95,18),(96,4,4,4,96,19),(97,4,4,4,97,20),(98,3,3,9,98,40),(99,3,3,9,99,50),(100,4,4,4,100,21),(101,4,4,4,101,22),(102,11,11,17,102,1),(103,11,11,17,103,2),(104,11,11,17,104,3),(105,11,11,17,105,4),(106,11,11,17,106,5),(107,11,11,17,107,6),(108,11,11,17,108,7),(109,11,11,17,109,8),(110,11,11,17,110,9),(111,11,11,17,111,10),(112,11,11,17,112,11),(113,11,11,17,113,12),(114,11,11,17,114,13),(115,11,11,17,115,14),(116,11,11,17,116,15),(117,11,11,17,117,16),(118,11,11,17,118,17),(119,11,11,17,119,18),(120,11,11,17,120,19),(121,11,11,17,121,20),(122,11,11,17,122,21),(123,11,11,17,123,22),(124,11,11,17,124,23),(125,11,11,17,125,24),(126,11,11,17,126,25),(127,11,11,17,127,26),(128,11,11,17,128,27),(129,11,11,17,129,28),(130,11,11,17,130,29),(131,11,11,17,131,30),(132,11,11,17,132,31),(133,11,11,17,133,32),(134,11,11,17,134,33),(135,11,11,17,135,34),(136,11,11,17,136,35),(137,11,11,17,137,36),(138,11,11,17,138,37),(139,11,11,17,139,38),(140,11,11,17,140,39),(141,11,11,17,141,40),(142,11,11,17,142,41),(143,11,11,17,143,42),(144,11,11,17,144,43),(145,11,11,17,145,44),(146,11,11,17,146,45),(147,11,11,17,147,46),(148,11,11,17,148,47),(149,11,11,17,149,48),(150,11,11,17,150,49),(151,11,11,17,151,50),(152,11,11,17,152,51),(153,11,11,17,153,52),(154,11,11,17,154,53),(155,11,11,17,155,54),(156,11,11,17,156,55),(157,11,11,17,157,56),(158,11,11,17,158,57),(159,11,11,17,159,58),(160,11,11,17,160,59),(161,11,11,17,161,60),(162,11,11,17,162,61),(163,11,11,17,163,62),(164,11,11,17,164,63),(165,11,11,17,165,64),(166,11,11,17,166,65),(167,11,11,17,167,66),(168,11,11,17,168,67),(169,11,11,17,169,68),(170,11,11,17,170,69),(171,11,11,17,171,70),(172,11,11,17,172,71),(173,11,11,17,173,72),(174,11,11,17,174,73),(175,11,11,17,175,74),(176,11,11,17,176,75),(177,11,11,17,177,76),(178,11,11,17,178,77),(179,11,11,17,179,78),(180,11,11,17,180,79),(181,11,11,17,181,80),(182,11,11,17,182,81),(183,11,11,17,183,82),(184,11,11,17,184,83),(185,11,11,17,185,84),(186,11,11,17,186,85),(187,11,11,17,187,86),(188,11,11,17,188,87),(189,11,11,17,189,88),(190,11,11,17,190,89),(191,11,11,17,191,90),(192,11,11,17,192,91),(193,11,11,17,193,92),(194,11,11,17,194,93),(195,11,11,17,195,94),(196,11,11,17,196,95),(197,11,11,17,197,96),(198,11,11,17,198,97),(199,11,11,17,199,98),(200,11,11,17,200,99),(201,11,11,17,201,100),(202,11,11,17,202,101),(203,11,11,17,203,102),(204,11,11,17,204,103),(205,11,11,17,205,104),(206,11,11,17,206,105),(207,11,11,17,207,106),(208,11,11,17,208,107),(209,12,12,18,209,1),(210,12,12,18,210,2),(211,12,12,18,211,3),(212,12,12,18,212,4),(213,12,12,18,213,5),(214,12,12,18,214,6),(215,12,12,18,215,7),(216,12,12,18,216,8),(217,12,12,18,217,9),(218,12,12,18,218,10),(219,12,12,18,219,11),(220,12,12,18,220,12),(221,12,12,18,221,13),(222,12,12,18,222,14),(223,12,12,18,223,15),(224,12,12,18,224,16),(225,12,12,18,225,17),(226,12,12,18,226,18),(227,12,12,18,227,19),(228,12,12,18,228,20),(229,13,13,19,229,1),(230,13,13,19,230,2),(231,13,13,19,231,3),(232,13,13,19,232,4),(233,13,13,19,233,5),(234,13,13,19,234,6),(235,13,13,19,235,7),(236,13,13,19,236,8),(237,13,13,19,237,9),(238,13,13,19,238,10),(239,13,13,19,239,11),(240,13,13,19,240,12),(241,13,13,19,241,13),(242,13,13,19,242,14),(243,13,13,19,243,15),(244,13,13,19,244,16),(245,13,13,19,245,17),(246,13,13,19,246,18),(247,13,13,19,247,19),(248,13,13,19,248,20),(249,13,13,19,249,21),(250,13,13,19,250,22),(251,13,13,19,251,23),(252,13,13,19,252,24),(253,13,13,19,253,25),(254,13,13,19,254,26),(255,13,13,19,255,27),(256,13,13,19,256,28),(257,13,13,19,257,29),(258,13,13,19,258,30),(259,13,13,19,259,31),(260,13,13,19,260,32),(261,13,13,19,261,33),(262,13,13,19,262,34),(263,13,13,19,263,35),(264,13,13,19,264,36),(265,13,13,19,265,37),(266,13,13,19,266,38),(267,13,13,19,267,39),(268,13,13,19,268,40),(269,13,13,19,269,41),(270,13,13,19,270,42),(271,13,13,19,271,43),(272,14,14,20,272,1),(273,14,14,20,273,2),(274,14,14,20,274,3),(275,14,14,20,275,4),(276,14,14,20,276,5),(277,14,14,20,277,6),(278,14,14,20,278,7),(279,14,14,20,279,8),(280,14,14,20,280,9),(281,14,14,20,281,10),(282,14,14,20,282,11),(283,14,14,20,283,12),(284,14,14,20,284,13),(285,14,14,20,285,14),(286,14,14,20,286,15),(287,14,14,20,287,16),(288,14,14,20,288,17),(289,14,14,20,289,18),(290,14,14,20,290,19),(291,14,14,20,291,20),(292,14,14,20,292,21),(293,14,14,20,293,22),(294,14,14,20,294,23),(295,14,14,20,295,24),(296,14,14,20,296,25),(297,14,14,20,297,26),(298,14,14,20,298,27),(299,14,14,20,299,28),(300,14,14,20,300,29),(301,14,14,20,301,30),(302,14,14,20,302,31),(303,14,14,20,303,32),(304,14,14,20,304,33),(305,14,14,20,305,34),(306,14,14,20,306,35),(307,14,14,20,307,36),(308,14,14,20,308,37),(309,14,14,20,309,38),(310,14,14,20,310,39),(311,14,14,20,311,40),(312,14,14,20,312,41),(313,14,14,20,313,42),(314,14,14,20,314,43),(315,14,14,20,315,44),(316,14,14,20,316,45),(317,14,14,20,317,46),(318,15,15,21,318,1),(319,15,15,21,319,2),(320,15,15,21,320,3),(321,15,15,21,321,4),(322,16,16,22,322,1),(323,16,16,22,323,2),(324,16,16,22,324,3),(325,16,16,22,325,4),(326,16,16,22,326,5),(327,16,16,22,327,6),(328,16,16,22,328,7),(329,16,16,22,329,8),(330,16,16,22,330,9),(331,16,16,22,331,10),(332,16,16,22,332,11),(333,16,16,22,333,12),(334,16,16,22,334,13),(335,16,16,22,335,14),(336,16,16,22,336,15),(337,16,16,22,337,16),(338,16,16,22,338,17),(339,16,16,22,339,18),(340,16,16,22,340,19),(341,16,16,22,341,20),(342,16,16,22,342,21),(343,16,16,22,343,22),(344,16,16,22,344,23),(345,16,16,22,345,24),(346,16,16,22,346,25),(347,16,16,22,347,26),(348,16,16,22,348,27),(349,16,16,22,349,28),(350,16,16,22,350,29),(351,17,17,23,351,1),(352,17,17,23,352,2),(353,17,17,23,353,3),(354,17,17,23,354,4),(355,17,17,23,355,5),(356,17,17,23,356,6),(357,17,17,23,357,7),(358,17,17,23,358,8),(359,17,17,23,359,9),(360,17,17,23,360,10),(361,17,17,23,361,11),(362,17,17,23,362,12),(363,17,17,23,363,13),(364,17,17,23,364,14),(365,17,17,23,365,15),(366,17,17,23,366,16),(367,17,17,23,367,17),(368,18,18,24,368,1),(369,18,18,24,369,2),(370,18,18,24,370,3),(371,19,19,25,371,1),(372,19,19,25,372,2),(373,19,19,25,373,3),(374,19,19,25,374,4),(375,19,19,25,375,5),(376,19,19,25,376,6),(377,19,19,25,377,7),(378,19,19,25,378,8),(379,19,19,25,379,9),(380,19,19,25,380,10),(381,20,20,26,381,1),(382,20,20,26,382,2),(383,20,20,26,383,3),(384,20,20,26,384,4),(385,20,20,26,385,5),(386,20,20,26,386,6),(387,20,20,26,387,7),(388,20,20,26,388,8),(389,20,20,26,389,9),(390,20,20,26,390,10),(391,20,20,26,391,11),(392,21,21,27,392,1),(393,21,21,27,393,2),(394,21,21,27,394,3),(395,22,22,28,395,1),(396,22,22,28,396,2),(397,22,22,28,397,3),(398,22,22,28,398,4),(399,22,22,28,399,5),(400,22,22,28,400,6),(401,22,22,28,401,7),(402,22,22,28,402,8),(403,23,23,29,403,1),(404,23,23,29,404,2),(405,23,23,29,405,3),(406,23,23,29,406,4),(407,23,23,29,407,5),(408,23,23,29,408,6),(409,23,23,29,409,7),(410,23,23,29,410,8),(411,23,23,29,411,9),(412,23,23,29,412,10),(413,23,23,29,413,11),(414,23,23,29,414,12),(415,23,23,29,415,13),(416,23,23,29,416,14),(417,23,23,29,417,15),(418,23,23,29,418,16),(419,23,23,29,419,17),(420,23,23,29,420,18),(421,23,23,29,421,19),(422,23,23,29,422,20),(423,23,23,29,423,21),(424,23,23,29,424,22),(425,23,23,29,425,23),(426,23,23,29,426,24),(427,23,23,29,427,25),(428,23,23,29,428,26),(429,23,23,29,429,27),(430,23,23,29,430,28),(431,23,23,29,431,29),(432,23,23,29,432,30),(433,23,23,29,433,31),(434,23,23,29,434,32),(435,23,23,29,435,33),(436,23,23,29,436,34),(437,24,24,30,437,1),(438,24,24,30,438,2),(439,24,24,30,439,3),(440,24,24,30,440,4),(441,24,24,30,441,5),(442,24,24,30,442,6),(443,24,24,30,443,7),(444,24,24,30,444,8),(445,24,24,30,445,9),(446,24,24,30,446,10),(447,24,24,30,447,11),(448,24,24,30,448,12),(449,24,24,30,449,13),(450,24,24,30,450,14),(451,24,24,30,451,15),(452,24,24,30,452,16),(453,24,24,30,453,17),(454,25,25,31,454,1),(455,25,25,31,455,2),(456,25,25,31,456,3),(457,13,13,19,457,44),(458,11,11,17,458,108),(459,11,11,17,459,109),(460,11,11,17,460,110),(461,11,11,17,461,111),(462,11,11,17,462,112),(463,11,11,17,463,113),(464,11,11,17,464,114),(465,11,11,17,465,115),(466,11,11,17,466,116),(467,4,4,5,467,23),(468,11,11,17,468,117),(469,4,4,4,469,23),(470,4,4,4,470,24),(471,4,4,4,471,25),(472,4,4,4,472,26),(473,4,4,5,473,24),(474,4,4,4,474,27),(475,4,4,4,475,28),(476,4,4,4,476,29),(477,4,4,4,477,30),(478,24,24,30,478,18),(479,24,24,30,479,19),(480,24,24,30,480,20),(481,24,24,30,481,21),(482,17,17,23,482,18),(483,17,17,23,483,19),(484,17,17,23,484,20),(485,17,17,23,485,21),(486,17,17,23,486,22),(487,24,24,30,487,22),(488,24,24,30,488,23),(489,24,24,30,489,24),(490,24,24,30,490,25),(491,24,24,30,491,26),(492,17,17,23,492,23),(493,17,17,23,493,24),(494,17,17,23,494,25),(495,17,17,23,495,26),(509,4,26,32,74,7),(521,4,26,32,83,13),(525,4,26,32,91,15),(527,4,26,32,93,16),(529,4,26,32,94,17),(531,4,26,32,95,18),(533,4,26,32,96,19),(535,4,26,32,97,20),(537,4,26,32,100,21),(539,4,26,32,101,22),(543,4,26,32,470,24),(545,4,26,32,471,25),(547,4,26,32,472,26),(549,4,26,32,474,27),(551,4,26,32,475,28),(553,4,26,32,476,29),(555,4,26,32,477,30),(569,4,26,33,84,8),(755,4,26,32,510,26),(803,4,26,32,56,1),(805,4,26,32,57,11),(807,4,26,32,58,12),(809,4,26,32,59,13),(811,4,26,32,65,14),(813,4,26,32,66,15),(815,4,26,32,76,16),(817,4,26,32,77,17),(819,4,26,32,78,18),(821,4,26,32,80,19),(823,4,26,32,82,20),(825,4,26,32,85,21),(827,4,26,32,469,22),(829,4,26,32,496,2),(831,4,26,32,497,3),(833,4,26,32,499,23),(835,4,26,32,500,4),(837,4,26,32,501,8),(839,4,26,32,502,6),(841,4,26,32,503,9),(843,4,26,32,504,10),(845,4,26,32,505,24),(847,4,26,32,506,5),(849,4,26,32,507,7),(851,4,26,32,508,27),(853,4,26,32,509,25),(855,4,26,32,511,26),(857,4,26,33,60,1),(859,4,26,33,61,2),(861,4,26,33,62,3),(863,4,26,33,63,4),(865,4,26,33,64,5),(867,4,26,33,75,7),(869,4,26,33,81,6),(871,4,26,33,467,8),(873,4,26,33,473,9),(875,4,26,34,67,1),(877,4,26,34,68,2),(879,4,26,34,69,3),(881,4,26,35,70,1),(883,4,26,35,71,2),(885,4,26,35,72,3),(887,4,26,35,73,4),(889,4,26,35,79,5),(891,4,26,36,86,1),(893,4,26,36,87,2),(895,4,26,36,88,3),(897,4,26,36,89,4),(899,4,26,36,90,5),(901,4,26,36,92,6);
/*!40000 ALTER TABLE `eav_entity_attribute` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eav_entity_datetime`
--

DROP TABLE IF EXISTS `eav_entity_datetime`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `eav_entity_datetime` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Datetime values of attributes';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eav_entity_datetime`
--

LOCK TABLES `eav_entity_datetime` WRITE;
/*!40000 ALTER TABLE `eav_entity_datetime` DISABLE KEYS */;
/*!40000 ALTER TABLE `eav_entity_datetime` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eav_entity_decimal`
--

DROP TABLE IF EXISTS `eav_entity_decimal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `eav_entity_decimal` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Decimal values of attributes';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eav_entity_decimal`
--

LOCK TABLES `eav_entity_decimal` WRITE;
/*!40000 ALTER TABLE `eav_entity_decimal` DISABLE KEYS */;
/*!40000 ALTER TABLE `eav_entity_decimal` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eav_entity_int`
--

DROP TABLE IF EXISTS `eav_entity_int`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `eav_entity_int` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Integer values of attributes';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eav_entity_int`
--

LOCK TABLES `eav_entity_int` WRITE;
/*!40000 ALTER TABLE `eav_entity_int` DISABLE KEYS */;
/*!40000 ALTER TABLE `eav_entity_int` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eav_entity_store`
--

DROP TABLE IF EXISTS `eav_entity_store`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `eav_entity_store` (
  `entity_store_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `entity_type_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `increment_prefix` varchar(20) NOT NULL DEFAULT '',
  `increment_last_id` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`entity_store_id`),
  KEY `FK_eav_entity_store_entity_type` (`entity_type_id`),
  KEY `FK_eav_entity_store_store` (`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eav_entity_store`
--

LOCK TABLES `eav_entity_store` WRITE;
/*!40000 ALTER TABLE `eav_entity_store` DISABLE KEYS */;
/*!40000 ALTER TABLE `eav_entity_store` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eav_entity_text`
--

DROP TABLE IF EXISTS `eav_entity_text`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `eav_entity_text` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Text values of attributes';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eav_entity_text`
--

LOCK TABLES `eav_entity_text` WRITE;
/*!40000 ALTER TABLE `eav_entity_text` DISABLE KEYS */;
/*!40000 ALTER TABLE `eav_entity_text` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eav_entity_type`
--

DROP TABLE IF EXISTS `eav_entity_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `eav_entity_type` (
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
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eav_entity_type`
--

LOCK TABLES `eav_entity_type` WRITE;
/*!40000 ALTER TABLE `eav_entity_type` DISABLE KEYS */;
INSERT INTO `eav_entity_type` VALUES (1,'customer','customer/customer','','customer/entity','','',1,'default',1,'eav/entity_increment_numeric',0,8,'0'),(2,'customer_address','customer/customer_address','','customer/address_entity','','',1,'default',2,'',0,8,'0'),(3,'catalog_category','catalog/category','catalog/resource_eav_attribute','catalog/category','','',1,'default',3,'',0,8,'0'),(4,'catalog_product','catalog/product','catalog/resource_eav_attribute','catalog/product','','',1,'default',4,'',0,8,'0'),(5,'quote','sales/quote','','sales/quote','','',1,'default',5,'',0,8,'0'),(6,'quote_item','sales/quote_item','','sales/quote_item','','',1,'default',6,'',0,8,'0'),(7,'quote_address','sales/quote_address','','sales/quote_address','','',1,'default',7,'',0,8,'0'),(8,'quote_address_item','sales/quote_address_item','','sales/quote_entity','','',1,'default',8,'',0,8,'0'),(9,'quote_address_rate','sales/quote_address_rate','','sales/quote_entity','','',1,'default',9,'',0,8,'0'),(10,'quote_payment','sales/quote_payment','','sales/quote_entity','','',1,'default',10,'',0,8,'0'),(11,'order','sales/order','','sales/order','','',1,'default',11,'eav/entity_increment_numeric',1,8,'0'),(12,'order_address','sales/order_address','','sales/order_entity','','',1,'default',12,'',0,8,'0'),(13,'order_item','sales/order_item','','sales/order_entity','','',1,'default',13,'',0,8,'0'),(14,'order_payment','sales/order_payment','','sales/order_entity','','',1,'default',14,'',0,8,'0'),(15,'order_status_history','sales/order_status_history','','sales/order_entity','','',1,'default',15,'',0,8,'0'),(16,'invoice','sales/order_invoice','','sales/order_entity','','',1,'default',16,'eav/entity_increment_numeric',1,8,'0'),(17,'invoice_item','sales/order_invoice_item','','sales/order_entity','','',1,'default',17,'',0,8,'0'),(18,'invoice_comment','sales/order_invoice_comment','','sales/order_entity','','',1,'default',18,'',0,8,'0'),(19,'shipment','sales/order_shipment','','sales/order_entity','','',1,'default',19,'eav/entity_increment_numeric',1,8,'0'),(20,'shipment_item','sales/order_shipment_item','','sales/order_entity','','',1,'default',20,'',0,8,'0'),(21,'shipment_comment','sales/order_shipment_comment','','sales/order_entity','','',1,'default',21,'',0,8,'0'),(22,'shipment_track','sales/order_shipment_track','','sales/order_entity','','',1,'default',22,'',0,8,'0'),(23,'creditmemo','sales/order_creditmemo','','sales/order_entity','','',1,'default',23,'eav/entity_increment_numeric',1,8,'0'),(24,'creditmemo_item','sales/order_creditmemo_item','','sales/order_entity','','',1,'default',24,'',0,8,'0'),(25,'creditmemo_comment','sales/order_creditmemo_comment','','sales/order_entity','','',1,'default',25,'',0,8,'0');
/*!40000 ALTER TABLE `eav_entity_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eav_entity_varchar`
--

DROP TABLE IF EXISTS `eav_entity_varchar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `eav_entity_varchar` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Varchar values of attributes';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eav_entity_varchar`
--

LOCK TABLES `eav_entity_varchar` WRITE;
/*!40000 ALTER TABLE `eav_entity_varchar` DISABLE KEYS */;
/*!40000 ALTER TABLE `eav_entity_varchar` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ek_catalog_popular_categories`
--

DROP TABLE IF EXISTS `ek_catalog_popular_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ek_catalog_popular_categories` (
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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ek_catalog_popular_categories`
--

LOCK TABLES `ek_catalog_popular_categories` WRITE;
/*!40000 ALTER TABLE `ek_catalog_popular_categories` DISABLE KEYS */;
INSERT INTO `ek_catalog_popular_categories` VALUES (1,'Fiction','fiction.html',1,1,15,'2009-11-19 16:20:53','2009-11-19 10:50:56'),(2,'Comics & Graphic Novels','comics-graphic-novels.html',2,1,11,'2009-11-19 14:18:57','2009-11-19 08:48:57'),(3,'Religion','religion.html',3,1,13,'2009-11-19 16:19:28','2009-11-19 10:49:46'),(4,'Juvenile Nonfiction','juvenile-nonfiction.html',4,1,15,'2009-11-19 16:20:31','2009-11-19 10:50:56'),(5,'Business & Economics','business-economics.html',5,1,10,'2009-11-19 16:20:31','2009-11-19 10:50:56'),(6,'Travel','travel.html',6,1,14,'2009-11-19 16:20:31','2009-11-19 10:50:56'),(7,'Cooking','cooking.html',7,1,11,'2009-11-19 16:20:31','2009-11-19 10:50:56');
/*!40000 ALTER TABLE `ek_catalog_popular_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ek_catalog_product_best_boxedsets`
--

DROP TABLE IF EXISTS `ek_catalog_product_best_boxedsets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ek_catalog_product_best_boxedsets` (
  `product_id` int(11) NOT NULL,
  `is_active` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `order_no` int(11) NOT NULL,
  `date` datetime DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ek_catalog_product_best_boxedsets`
--

LOCK TABLES `ek_catalog_product_best_boxedsets` WRITE;
/*!40000 ALTER TABLE `ek_catalog_product_best_boxedsets` DISABLE KEYS */;
INSERT INTO `ek_catalog_product_best_boxedsets` VALUES (41,1,4,'2009-11-19 16:20:31','2009-11-19 10:50:56'),(55,1,2,'2009-11-19 14:18:57','2009-11-19 08:48:57'),(56,1,1,'2009-11-19 16:20:53','2009-11-19 10:50:56'),(96,1,3,'2009-11-19 16:19:28','2009-11-19 10:49:46');
/*!40000 ALTER TABLE `ek_catalog_product_best_boxedsets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ek_catalog_product_bestsellers`
--

DROP TABLE IF EXISTS `ek_catalog_product_bestsellers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ek_catalog_product_bestsellers` (
  `product_id` int(11) NOT NULL,
  `is_active` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `order_no` int(11) NOT NULL,
  `date` datetime DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ek_catalog_product_bestsellers`
--

LOCK TABLES `ek_catalog_product_bestsellers` WRITE;
/*!40000 ALTER TABLE `ek_catalog_product_bestsellers` DISABLE KEYS */;
INSERT INTO `ek_catalog_product_bestsellers` VALUES (6,1,4,'2009-11-19 16:20:31','2009-11-19 10:50:56'),(7,1,1,'2009-11-19 16:20:53','2009-11-19 10:50:56'),(13,1,3,'2009-11-19 16:19:28','2009-11-19 10:49:46'),(19,1,2,'2009-11-19 14:18:57','2009-11-19 08:48:57');
/*!40000 ALTER TABLE `ek_catalog_product_bestsellers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ek_catalog_product_newreleases`
--

DROP TABLE IF EXISTS `ek_catalog_product_newreleases`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ek_catalog_product_newreleases` (
  `product_id` int(11) NOT NULL,
  `is_active` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `order_no` int(11) NOT NULL,
  `date` datetime DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ek_catalog_product_newreleases`
--

LOCK TABLES `ek_catalog_product_newreleases` WRITE;
/*!40000 ALTER TABLE `ek_catalog_product_newreleases` DISABLE KEYS */;
INSERT INTO `ek_catalog_product_newreleases` VALUES (36,1,1,'2009-11-19 16:20:53','2009-11-19 10:50:56'),(37,1,2,'2009-11-19 14:18:57','2009-11-19 08:48:57'),(38,1,3,'2009-11-19 16:19:28','2009-11-19 10:49:46'),(77,1,4,'2009-11-19 16:20:31','2009-11-19 10:50:56');
/*!40000 ALTER TABLE `ek_catalog_product_newreleases` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ek_catalog_top_authors`
--

DROP TABLE IF EXISTS `ek_catalog_top_authors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ek_catalog_top_authors` (
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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ek_catalog_top_authors`
--

LOCK TABLES `ek_catalog_top_authors` WRITE;
/*!40000 ALTER TABLE `ek_catalog_top_authors` DISABLE KEYS */;
INSERT INTO `ek_catalog_top_authors` VALUES (1,'Agatha Christie',1,1,14,'2009-11-12 16:19:28','2009-11-12 10:49:46'),(2,'Megan McDonald',2,1,10,'2009-11-12 16:20:31','2009-11-12 10:50:56'),(3,'Edith Wharton',3,1,13,'2009-11-12 16:20:53','2009-11-12 10:50:56'),(4,'Jillian Powell',4,1,10,NULL,'2009-11-17 08:48:57'),(5,'Patricia Cornwell',5,1,14,NULL,'2009-11-17 08:48:57'),(6,'Colin Harrison',6,1,11,NULL,'2009-11-17 08:48:57'),(7,'Arthur Edward Waite',7,1,15,NULL,'2009-11-17 08:48:57');
/*!40000 ALTER TABLE `ek_catalog_top_authors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ek_shipping_region`
--

DROP TABLE IF EXISTS `ek_shipping_region`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ek_shipping_region` (
  `VALUE_ID` tinyint(4) NOT NULL AUTO_INCREMENT,
  `CODE` tinyint(4) NOT NULL,
  `REGION` varchar(255) NOT NULL,
  PRIMARY KEY (`VALUE_ID`),
  UNIQUE KEY `code` (`CODE`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ek_shipping_region`
--

LOCK TABLES `ek_shipping_region` WRITE;
/*!40000 ALTER TABLE `ek_shipping_region` DISABLE KEYS */;
INSERT INTO `ek_shipping_region` VALUES (1,1,'India only'),(2,2,'Indian Sub-continent only'),(3,3,'International');
/*!40000 ALTER TABLE `ek_shipping_region` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gift_message`
--

DROP TABLE IF EXISTS `gift_message`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gift_message` (
  `gift_message_id` int(7) unsigned NOT NULL AUTO_INCREMENT,
  `customer_id` int(7) unsigned NOT NULL DEFAULT '0',
  `sender` varchar(255) NOT NULL DEFAULT '',
  `recipient` varchar(255) NOT NULL DEFAULT '',
  `message` text NOT NULL,
  PRIMARY KEY (`gift_message_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gift_message`
--

LOCK TABLES `gift_message` WRITE;
/*!40000 ALTER TABLE `gift_message` DISABLE KEYS */;
/*!40000 ALTER TABLE `gift_message` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `googlebase_attributes`
--

DROP TABLE IF EXISTS `googlebase_attributes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `googlebase_attributes` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `attribute_id` smallint(5) unsigned NOT NULL,
  `gbase_attribute` varchar(255) NOT NULL,
  `type_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `GOOGLEBASE_ATTRIBUTES_ATTRIBUTE_ID` (`attribute_id`),
  KEY `GOOGLEBASE_ATTRIBUTES_TYPE_ID` (`type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Google Base Attributes link Product Attributes';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `googlebase_attributes`
--

LOCK TABLES `googlebase_attributes` WRITE;
/*!40000 ALTER TABLE `googlebase_attributes` DISABLE KEYS */;
/*!40000 ALTER TABLE `googlebase_attributes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `googlebase_items`
--

DROP TABLE IF EXISTS `googlebase_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `googlebase_items` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Google Base Items Products';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `googlebase_items`
--

LOCK TABLES `googlebase_items` WRITE;
/*!40000 ALTER TABLE `googlebase_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `googlebase_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `googlebase_types`
--

DROP TABLE IF EXISTS `googlebase_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `googlebase_types` (
  `type_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `attribute_set_id` smallint(5) unsigned NOT NULL,
  `gbase_itemtype` varchar(255) NOT NULL,
  `target_country` varchar(2) NOT NULL DEFAULT 'US',
  PRIMARY KEY (`type_id`),
  KEY `GOOGLEBASE_TYPES_ATTRIBUTE_SET_ID` (`attribute_set_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Google Base Item Types link Attribute Sets';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `googlebase_types`
--

LOCK TABLES `googlebase_types` WRITE;
/*!40000 ALTER TABLE `googlebase_types` DISABLE KEYS */;
/*!40000 ALTER TABLE `googlebase_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `googlecheckout_api_debug`
--

DROP TABLE IF EXISTS `googlecheckout_api_debug`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `googlecheckout_api_debug` (
  `debug_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `dir` enum('in','out') DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `request_body` text,
  `response_body` text,
  PRIMARY KEY (`debug_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `googlecheckout_api_debug`
--

LOCK TABLES `googlecheckout_api_debug` WRITE;
/*!40000 ALTER TABLE `googlecheckout_api_debug` DISABLE KEYS */;
/*!40000 ALTER TABLE `googlecheckout_api_debug` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `googleoptimizer_code`
--

DROP TABLE IF EXISTS `googleoptimizer_code`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `googleoptimizer_code` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `googleoptimizer_code`
--

LOCK TABLES `googleoptimizer_code` WRITE;
/*!40000 ALTER TABLE `googleoptimizer_code` DISABLE KEYS */;
/*!40000 ALTER TABLE `googleoptimizer_code` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_customer`
--

DROP TABLE IF EXISTS `log_customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `log_customer` (
  `log_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `visitor_id` bigint(20) unsigned DEFAULT NULL,
  `customer_id` int(11) NOT NULL DEFAULT '0',
  `login_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `logout_at` datetime DEFAULT NULL,
  `store_id` smallint(5) unsigned NOT NULL,
  PRIMARY KEY (`log_id`),
  KEY `IDX_VISITOR` (`visitor_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Customers log information';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_customer`
--

LOCK TABLES `log_customer` WRITE;
/*!40000 ALTER TABLE `log_customer` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_quote`
--

DROP TABLE IF EXISTS `log_quote`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `log_quote` (
  `quote_id` int(10) unsigned NOT NULL DEFAULT '0',
  `visitor_id` bigint(20) unsigned DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`quote_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Quote log data';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_quote`
--

LOCK TABLES `log_quote` WRITE;
/*!40000 ALTER TABLE `log_quote` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_quote` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_summary`
--

DROP TABLE IF EXISTS `log_summary`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `log_summary` (
  `summary_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `store_id` smallint(5) unsigned NOT NULL,
  `type_id` smallint(5) unsigned DEFAULT NULL,
  `visitor_count` int(11) NOT NULL DEFAULT '0',
  `customer_count` int(11) NOT NULL DEFAULT '0',
  `add_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`summary_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Summary log information';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_summary`
--

LOCK TABLES `log_summary` WRITE;
/*!40000 ALTER TABLE `log_summary` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_summary` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_summary_type`
--

DROP TABLE IF EXISTS `log_summary_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `log_summary_type` (
  `type_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `type_code` varchar(64) NOT NULL DEFAULT '',
  `period` smallint(5) unsigned NOT NULL DEFAULT '0',
  `period_type` enum('MINUTE','HOUR','DAY','WEEK','MONTH') NOT NULL DEFAULT 'MINUTE',
  PRIMARY KEY (`type_id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='Type of summary information';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_summary_type`
--

LOCK TABLES `log_summary_type` WRITE;
/*!40000 ALTER TABLE `log_summary_type` DISABLE KEYS */;
INSERT INTO `log_summary_type` VALUES (1,'hour',1,'HOUR'),(2,'day',1,'DAY');
/*!40000 ALTER TABLE `log_summary_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_url`
--

DROP TABLE IF EXISTS `log_url`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `log_url` (
  `url_id` bigint(20) unsigned NOT NULL DEFAULT '0',
  `visitor_id` bigint(20) unsigned DEFAULT NULL,
  `visit_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`url_id`),
  KEY `IDX_VISITOR` (`visitor_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='URL visiting history';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_url`
--

LOCK TABLES `log_url` WRITE;
/*!40000 ALTER TABLE `log_url` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_url` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_url_info`
--

DROP TABLE IF EXISTS `log_url_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `log_url_info` (
  `url_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `url` varchar(255) NOT NULL DEFAULT '',
  `referer` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`url_id`)
) ENGINE=MyISAM AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 COMMENT='Detale information about url visit';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_url_info`
--

LOCK TABLES `log_url_info` WRITE;
/*!40000 ALTER TABLE `log_url_info` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_url_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_visitor`
--

DROP TABLE IF EXISTS `log_visitor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `log_visitor` (
  `visitor_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `session_id` char(64) NOT NULL DEFAULT '',
  `first_visit_at` datetime DEFAULT NULL,
  `last_visit_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `last_url_id` bigint(20) unsigned NOT NULL DEFAULT '0',
  `store_id` smallint(5) unsigned NOT NULL,
  PRIMARY KEY (`visitor_id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='System visitors log';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_visitor`
--

LOCK TABLES `log_visitor` WRITE;
/*!40000 ALTER TABLE `log_visitor` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_visitor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_visitor_info`
--

DROP TABLE IF EXISTS `log_visitor_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `log_visitor_info` (
  `visitor_id` bigint(20) unsigned NOT NULL DEFAULT '0',
  `http_referer` varchar(255) DEFAULT NULL,
  `http_user_agent` varchar(255) DEFAULT NULL,
  `http_accept_charset` varchar(255) DEFAULT NULL,
  `http_accept_language` varchar(255) DEFAULT NULL,
  `server_addr` bigint(20) DEFAULT NULL,
  `remote_addr` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`visitor_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Additional information by visitor';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_visitor_info`
--

LOCK TABLES `log_visitor_info` WRITE;
/*!40000 ALTER TABLE `log_visitor_info` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_visitor_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_visitor_online`
--

DROP TABLE IF EXISTS `log_visitor_online`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `log_visitor_online` (
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
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_visitor_online`
--

LOCK TABLES `log_visitor_online` WRITE;
/*!40000 ALTER TABLE `log_visitor_online` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_visitor_online` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `newsletter_problem`
--

DROP TABLE IF EXISTS `newsletter_problem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `newsletter_problem` (
  `problem_id` int(7) unsigned NOT NULL AUTO_INCREMENT,
  `subscriber_id` int(7) unsigned DEFAULT NULL,
  `queue_id` int(7) unsigned NOT NULL DEFAULT '0',
  `problem_error_code` int(3) unsigned DEFAULT '0',
  `problem_error_text` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`problem_id`),
  KEY `FK_PROBLEM_SUBSCRIBER` (`subscriber_id`),
  KEY `FK_PROBLEM_QUEUE` (`queue_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Newsletter problems';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `newsletter_problem`
--

LOCK TABLES `newsletter_problem` WRITE;
/*!40000 ALTER TABLE `newsletter_problem` DISABLE KEYS */;
/*!40000 ALTER TABLE `newsletter_problem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `newsletter_queue`
--

DROP TABLE IF EXISTS `newsletter_queue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `newsletter_queue` (
  `queue_id` int(7) unsigned NOT NULL AUTO_INCREMENT,
  `template_id` int(7) unsigned NOT NULL DEFAULT '0',
  `queue_status` int(3) unsigned NOT NULL DEFAULT '0',
  `queue_start_at` datetime DEFAULT NULL,
  `queue_finish_at` datetime DEFAULT NULL,
  PRIMARY KEY (`queue_id`),
  KEY `FK_QUEUE_TEMPLATE` (`template_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Newsletter queue';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `newsletter_queue`
--

LOCK TABLES `newsletter_queue` WRITE;
/*!40000 ALTER TABLE `newsletter_queue` DISABLE KEYS */;
/*!40000 ALTER TABLE `newsletter_queue` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `newsletter_queue_link`
--

DROP TABLE IF EXISTS `newsletter_queue_link`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `newsletter_queue_link` (
  `queue_link_id` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `queue_id` int(7) unsigned NOT NULL DEFAULT '0',
  `subscriber_id` int(7) unsigned NOT NULL DEFAULT '0',
  `letter_sent_at` datetime DEFAULT NULL,
  PRIMARY KEY (`queue_link_id`),
  KEY `FK_QUEUE_LINK_SUBSCRIBER` (`subscriber_id`),
  KEY `FK_QUEUE_LINK_QUEUE` (`queue_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Newsletter queue to subscriber link';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `newsletter_queue_link`
--

LOCK TABLES `newsletter_queue_link` WRITE;
/*!40000 ALTER TABLE `newsletter_queue_link` DISABLE KEYS */;
/*!40000 ALTER TABLE `newsletter_queue_link` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `newsletter_queue_store_link`
--

DROP TABLE IF EXISTS `newsletter_queue_store_link`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `newsletter_queue_store_link` (
  `queue_id` int(7) unsigned NOT NULL DEFAULT '0',
  `store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`queue_id`,`store_id`),
  KEY `FK_NEWSLETTER_QUEUE_STORE_LINK_STORE` (`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `newsletter_queue_store_link`
--

LOCK TABLES `newsletter_queue_store_link` WRITE;
/*!40000 ALTER TABLE `newsletter_queue_store_link` DISABLE KEYS */;
/*!40000 ALTER TABLE `newsletter_queue_store_link` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `newsletter_subscriber`
--

DROP TABLE IF EXISTS `newsletter_subscriber`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `newsletter_subscriber` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Newsletter subscribers';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `newsletter_subscriber`
--

LOCK TABLES `newsletter_subscriber` WRITE;
/*!40000 ALTER TABLE `newsletter_subscriber` DISABLE KEYS */;
/*!40000 ALTER TABLE `newsletter_subscriber` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `newsletter_template`
--

DROP TABLE IF EXISTS `newsletter_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `newsletter_template` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Newsletter templates';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `newsletter_template`
--

LOCK TABLES `newsletter_template` WRITE;
/*!40000 ALTER TABLE `newsletter_template` DISABLE KEYS */;
/*!40000 ALTER TABLE `newsletter_template` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `paygate_authorizenet_debug`
--

DROP TABLE IF EXISTS `paygate_authorizenet_debug`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `paygate_authorizenet_debug` (
  `debug_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `request_body` text,
  `response_body` text,
  `request_serialized` text,
  `result_serialized` text,
  `request_dump` text,
  `result_dump` text,
  PRIMARY KEY (`debug_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `paygate_authorizenet_debug`
--

LOCK TABLES `paygate_authorizenet_debug` WRITE;
/*!40000 ALTER TABLE `paygate_authorizenet_debug` DISABLE KEYS */;
/*!40000 ALTER TABLE `paygate_authorizenet_debug` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `paypal_api_debug`
--

DROP TABLE IF EXISTS `paypal_api_debug`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `paypal_api_debug` (
  `debug_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `debug_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `request_body` text,
  `response_body` text,
  PRIMARY KEY (`debug_id`),
  KEY `debug_at` (`debug_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `paypal_api_debug`
--

LOCK TABLES `paypal_api_debug` WRITE;
/*!40000 ALTER TABLE `paypal_api_debug` DISABLE KEYS */;
/*!40000 ALTER TABLE `paypal_api_debug` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `paypaluk_api_debug`
--

DROP TABLE IF EXISTS `paypaluk_api_debug`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `paypaluk_api_debug` (
  `debug_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `debug_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `request_body` text,
  `response_body` text,
  PRIMARY KEY (`debug_id`),
  KEY `debug_at` (`debug_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `paypaluk_api_debug`
--

LOCK TABLES `paypaluk_api_debug` WRITE;
/*!40000 ALTER TABLE `paypaluk_api_debug` DISABLE KEYS */;
/*!40000 ALTER TABLE `paypaluk_api_debug` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `poll`
--

DROP TABLE IF EXISTS `poll`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `poll` (
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `poll`
--

LOCK TABLES `poll` WRITE;
/*!40000 ALTER TABLE `poll` DISABLE KEYS */;
INSERT INTO `poll` VALUES (1,'What is your favorite color',5,1,'2009-10-15 15:05:14',NULL,1,0,NULL);
/*!40000 ALTER TABLE `poll` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `poll_answer`
--

DROP TABLE IF EXISTS `poll_answer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `poll_answer` (
  `answer_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `poll_id` int(10) unsigned NOT NULL DEFAULT '0',
  `answer_title` varchar(255) NOT NULL DEFAULT '',
  `votes_count` int(10) unsigned NOT NULL DEFAULT '0',
  `answer_order` smallint(6) NOT NULL DEFAULT '0',
  PRIMARY KEY (`answer_id`),
  KEY `FK_POLL_PARENT` (`poll_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `poll_answer`
--

LOCK TABLES `poll_answer` WRITE;
/*!40000 ALTER TABLE `poll_answer` DISABLE KEYS */;
INSERT INTO `poll_answer` VALUES (1,1,'Green',4,0),(2,1,'Red',1,0),(3,1,'Black',0,0),(4,1,'Magenta',0,0);
/*!40000 ALTER TABLE `poll_answer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `poll_store`
--

DROP TABLE IF EXISTS `poll_store`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `poll_store` (
  `poll_id` int(10) unsigned NOT NULL DEFAULT '0',
  `store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`poll_id`,`store_id`),
  KEY `FK_POLL_STORE_STORE` (`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `poll_store`
--

LOCK TABLES `poll_store` WRITE;
/*!40000 ALTER TABLE `poll_store` DISABLE KEYS */;
INSERT INTO `poll_store` VALUES (1,1);
/*!40000 ALTER TABLE `poll_store` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `poll_vote`
--

DROP TABLE IF EXISTS `poll_vote`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `poll_vote` (
  `vote_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `poll_id` int(10) unsigned NOT NULL DEFAULT '0',
  `poll_answer_id` int(10) unsigned NOT NULL DEFAULT '0',
  `ip_address` bigint(20) DEFAULT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `vote_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`vote_id`),
  KEY `FK_POLL_ANSWER` (`poll_answer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `poll_vote`
--

LOCK TABLES `poll_vote` WRITE;
/*!40000 ALTER TABLE `poll_vote` DISABLE KEYS */;
/*!40000 ALTER TABLE `poll_vote` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_alert_price`
--

DROP TABLE IF EXISTS `product_alert_price`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_alert_price` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_alert_price`
--

LOCK TABLES `product_alert_price` WRITE;
/*!40000 ALTER TABLE `product_alert_price` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_alert_price` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_alert_stock`
--

DROP TABLE IF EXISTS `product_alert_stock`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_alert_stock` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_alert_stock`
--

LOCK TABLES `product_alert_stock` WRITE;
/*!40000 ALTER TABLE `product_alert_stock` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_alert_stock` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rating`
--

DROP TABLE IF EXISTS `rating`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rating` (
  `rating_id` smallint(6) unsigned NOT NULL AUTO_INCREMENT,
  `entity_id` smallint(6) unsigned NOT NULL DEFAULT '0',
  `rating_code` varchar(64) NOT NULL DEFAULT '',
  `position` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`rating_id`),
  UNIQUE KEY `IDX_CODE` (`rating_code`),
  KEY `FK_RATING_ENTITY` (`entity_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='ratings';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rating`
--

LOCK TABLES `rating` WRITE;
/*!40000 ALTER TABLE `rating` DISABLE KEYS */;
INSERT INTO `rating` VALUES (1,1,'Quality',0),(2,1,'Value',0),(3,1,'Price',0);
/*!40000 ALTER TABLE `rating` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rating_entity`
--

DROP TABLE IF EXISTS `rating_entity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rating_entity` (
  `entity_id` smallint(6) unsigned NOT NULL AUTO_INCREMENT,
  `entity_code` varchar(64) NOT NULL DEFAULT '',
  PRIMARY KEY (`entity_id`),
  UNIQUE KEY `IDX_CODE` (`entity_code`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='Rating entities';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rating_entity`
--

LOCK TABLES `rating_entity` WRITE;
/*!40000 ALTER TABLE `rating_entity` DISABLE KEYS */;
INSERT INTO `rating_entity` VALUES (1,'product'),(2,'product_review'),(3,'review');
/*!40000 ALTER TABLE `rating_entity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rating_option`
--

DROP TABLE IF EXISTS `rating_option`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rating_option` (
  `option_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `rating_id` smallint(6) unsigned NOT NULL DEFAULT '0',
  `code` varchar(32) NOT NULL DEFAULT '',
  `value` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `position` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`option_id`),
  KEY `FK_RATING_OPTION_RATING` (`rating_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8 COMMENT='Rating options';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rating_option`
--

LOCK TABLES `rating_option` WRITE;
/*!40000 ALTER TABLE `rating_option` DISABLE KEYS */;
INSERT INTO `rating_option` VALUES (1,1,'1',1,1),(2,1,'2',2,2),(3,1,'3',3,3),(4,1,'4',4,4),(5,1,'5',5,5),(6,2,'1',1,1),(7,2,'2',2,2),(8,2,'3',3,3),(9,2,'4',4,4),(10,2,'5',5,5),(11,3,'1',1,1),(12,3,'2',2,2),(13,3,'3',3,3),(14,3,'4',4,4),(15,3,'5',5,5);
/*!40000 ALTER TABLE `rating_option` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rating_option_vote`
--

DROP TABLE IF EXISTS `rating_option_vote`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rating_option_vote` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Rating option values';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rating_option_vote`
--

LOCK TABLES `rating_option_vote` WRITE;
/*!40000 ALTER TABLE `rating_option_vote` DISABLE KEYS */;
/*!40000 ALTER TABLE `rating_option_vote` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rating_option_vote_aggregated`
--

DROP TABLE IF EXISTS `rating_option_vote_aggregated`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rating_option_vote_aggregated` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rating_option_vote_aggregated`
--

LOCK TABLES `rating_option_vote_aggregated` WRITE;
/*!40000 ALTER TABLE `rating_option_vote_aggregated` DISABLE KEYS */;
/*!40000 ALTER TABLE `rating_option_vote_aggregated` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rating_store`
--

DROP TABLE IF EXISTS `rating_store`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rating_store` (
  `rating_id` smallint(6) unsigned NOT NULL DEFAULT '0',
  `store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`rating_id`,`store_id`),
  KEY `FK_RATING_STORE_STORE` (`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rating_store`
--

LOCK TABLES `rating_store` WRITE;
/*!40000 ALTER TABLE `rating_store` DISABLE KEYS */;
/*!40000 ALTER TABLE `rating_store` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rating_title`
--

DROP TABLE IF EXISTS `rating_title`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rating_title` (
  `rating_id` smallint(6) unsigned NOT NULL DEFAULT '0',
  `store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `value` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`rating_id`,`store_id`),
  KEY `FK_RATING_TITLE_STORE` (`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rating_title`
--

LOCK TABLES `rating_title` WRITE;
/*!40000 ALTER TABLE `rating_title` DISABLE KEYS */;
/*!40000 ALTER TABLE `rating_title` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `report_event`
--

DROP TABLE IF EXISTS `report_event`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `report_event` (
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `report_event`
--

LOCK TABLES `report_event` WRITE;
/*!40000 ALTER TABLE `report_event` DISABLE KEYS */;
/*!40000 ALTER TABLE `report_event` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `report_event_types`
--

DROP TABLE IF EXISTS `report_event_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `report_event_types` (
  `event_type_id` smallint(6) unsigned NOT NULL AUTO_INCREMENT,
  `event_name` varchar(64) NOT NULL,
  `customer_login` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`event_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `report_event_types`
--

LOCK TABLES `report_event_types` WRITE;
/*!40000 ALTER TABLE `report_event_types` DISABLE KEYS */;
INSERT INTO `report_event_types` VALUES (1,'catalog_product_view',1),(2,'sendfriend_product',1),(3,'catalog_product_compare_add_product',1),(4,'checkout_cart_add_product',1),(5,'wishlist_add_product',1),(6,'wishlist_share',1);
/*!40000 ALTER TABLE `report_event_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `review`
--

DROP TABLE IF EXISTS `review`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `review` (
  `review_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `entity_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `entity_pk_value` int(10) unsigned NOT NULL DEFAULT '0',
  `status_id` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`review_id`),
  KEY `FK_REVIEW_ENTITY` (`entity_id`),
  KEY `FK_REVIEW_STATUS` (`status_id`),
  KEY `FK_REVIEW_PARENT_PRODUCT` (`entity_pk_value`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Review base information';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `review`
--

LOCK TABLES `review` WRITE;
/*!40000 ALTER TABLE `review` DISABLE KEYS */;
/*!40000 ALTER TABLE `review` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `review_detail`
--

DROP TABLE IF EXISTS `review_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `review_detail` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Review detail information';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `review_detail`
--

LOCK TABLES `review_detail` WRITE;
/*!40000 ALTER TABLE `review_detail` DISABLE KEYS */;
/*!40000 ALTER TABLE `review_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `review_entity`
--

DROP TABLE IF EXISTS `review_entity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `review_entity` (
  `entity_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `entity_code` varchar(32) NOT NULL DEFAULT '',
  PRIMARY KEY (`entity_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='Review entities';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `review_entity`
--

LOCK TABLES `review_entity` WRITE;
/*!40000 ALTER TABLE `review_entity` DISABLE KEYS */;
INSERT INTO `review_entity` VALUES (1,'product'),(2,'customer'),(3,'category');
/*!40000 ALTER TABLE `review_entity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `review_entity_summary`
--

DROP TABLE IF EXISTS `review_entity_summary`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `review_entity_summary` (
  `primary_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `entity_pk_value` bigint(20) NOT NULL DEFAULT '0',
  `entity_type` tinyint(4) NOT NULL DEFAULT '0',
  `reviews_count` smallint(6) NOT NULL DEFAULT '0',
  `rating_summary` tinyint(4) NOT NULL DEFAULT '0',
  `store_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`primary_id`),
  KEY `FK_REVIEW_ENTITY_SUMMARY_STORE` (`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `review_entity_summary`
--

LOCK TABLES `review_entity_summary` WRITE;
/*!40000 ALTER TABLE `review_entity_summary` DISABLE KEYS */;
/*!40000 ALTER TABLE `review_entity_summary` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `review_status`
--

DROP TABLE IF EXISTS `review_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `review_status` (
  `status_id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `status_code` varchar(32) NOT NULL DEFAULT '',
  PRIMARY KEY (`status_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='Review statuses';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `review_status`
--

LOCK TABLES `review_status` WRITE;
/*!40000 ALTER TABLE `review_status` DISABLE KEYS */;
INSERT INTO `review_status` VALUES (1,'Approved'),(2,'Pending'),(3,'Not Approved');
/*!40000 ALTER TABLE `review_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `review_store`
--

DROP TABLE IF EXISTS `review_store`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `review_store` (
  `review_id` bigint(20) unsigned NOT NULL,
  `store_id` smallint(5) unsigned NOT NULL,
  PRIMARY KEY (`review_id`,`store_id`),
  KEY `FK_REVIEW_STORE_STORE` (`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `review_store`
--

LOCK TABLES `review_store` WRITE;
/*!40000 ALTER TABLE `review_store` DISABLE KEYS */;
/*!40000 ALTER TABLE `review_store` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sales_flat_order_item`
--

DROP TABLE IF EXISTS `sales_flat_order_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sales_flat_order_item` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sales_flat_order_item`
--

LOCK TABLES `sales_flat_order_item` WRITE;
/*!40000 ALTER TABLE `sales_flat_order_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `sales_flat_order_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sales_flat_quote`
--

DROP TABLE IF EXISTS `sales_flat_quote`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sales_flat_quote` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sales_flat_quote`
--

LOCK TABLES `sales_flat_quote` WRITE;
/*!40000 ALTER TABLE `sales_flat_quote` DISABLE KEYS */;
/*!40000 ALTER TABLE `sales_flat_quote` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sales_flat_quote_address`
--

DROP TABLE IF EXISTS `sales_flat_quote_address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sales_flat_quote_address` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sales_flat_quote_address`
--

LOCK TABLES `sales_flat_quote_address` WRITE;
/*!40000 ALTER TABLE `sales_flat_quote_address` DISABLE KEYS */;
/*!40000 ALTER TABLE `sales_flat_quote_address` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sales_flat_quote_address_item`
--

DROP TABLE IF EXISTS `sales_flat_quote_address_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sales_flat_quote_address_item` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sales_flat_quote_address_item`
--

LOCK TABLES `sales_flat_quote_address_item` WRITE;
/*!40000 ALTER TABLE `sales_flat_quote_address_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `sales_flat_quote_address_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sales_flat_quote_item`
--

DROP TABLE IF EXISTS `sales_flat_quote_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sales_flat_quote_item` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sales_flat_quote_item`
--

LOCK TABLES `sales_flat_quote_item` WRITE;
/*!40000 ALTER TABLE `sales_flat_quote_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `sales_flat_quote_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sales_flat_quote_item_option`
--

DROP TABLE IF EXISTS `sales_flat_quote_item_option`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sales_flat_quote_item_option` (
  `option_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `item_id` int(10) unsigned NOT NULL,
  `product_id` int(10) unsigned NOT NULL,
  `code` varchar(255) NOT NULL,
  `value` text NOT NULL,
  PRIMARY KEY (`option_id`),
  KEY `FK_SALES_QUOTE_ITEM_OPTION_ITEM_ID` (`item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Additional options for quote item';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sales_flat_quote_item_option`
--

LOCK TABLES `sales_flat_quote_item_option` WRITE;
/*!40000 ALTER TABLE `sales_flat_quote_item_option` DISABLE KEYS */;
/*!40000 ALTER TABLE `sales_flat_quote_item_option` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sales_flat_quote_payment`
--

DROP TABLE IF EXISTS `sales_flat_quote_payment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sales_flat_quote_payment` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sales_flat_quote_payment`
--

LOCK TABLES `sales_flat_quote_payment` WRITE;
/*!40000 ALTER TABLE `sales_flat_quote_payment` DISABLE KEYS */;
/*!40000 ALTER TABLE `sales_flat_quote_payment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sales_flat_quote_shipping_rate`
--

DROP TABLE IF EXISTS `sales_flat_quote_shipping_rate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sales_flat_quote_shipping_rate` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sales_flat_quote_shipping_rate`
--

LOCK TABLES `sales_flat_quote_shipping_rate` WRITE;
/*!40000 ALTER TABLE `sales_flat_quote_shipping_rate` DISABLE KEYS */;
/*!40000 ALTER TABLE `sales_flat_quote_shipping_rate` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sales_order`
--

DROP TABLE IF EXISTS `sales_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sales_order` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sales_order`
--

LOCK TABLES `sales_order` WRITE;
/*!40000 ALTER TABLE `sales_order` DISABLE KEYS */;
/*!40000 ALTER TABLE `sales_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sales_order_datetime`
--

DROP TABLE IF EXISTS `sales_order_datetime`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sales_order_datetime` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sales_order_datetime`
--

LOCK TABLES `sales_order_datetime` WRITE;
/*!40000 ALTER TABLE `sales_order_datetime` DISABLE KEYS */;
/*!40000 ALTER TABLE `sales_order_datetime` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sales_order_decimal`
--

DROP TABLE IF EXISTS `sales_order_decimal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sales_order_decimal` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sales_order_decimal`
--

LOCK TABLES `sales_order_decimal` WRITE;
/*!40000 ALTER TABLE `sales_order_decimal` DISABLE KEYS */;
/*!40000 ALTER TABLE `sales_order_decimal` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sales_order_entity`
--

DROP TABLE IF EXISTS `sales_order_entity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sales_order_entity` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sales_order_entity`
--

LOCK TABLES `sales_order_entity` WRITE;
/*!40000 ALTER TABLE `sales_order_entity` DISABLE KEYS */;
/*!40000 ALTER TABLE `sales_order_entity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sales_order_entity_datetime`
--

DROP TABLE IF EXISTS `sales_order_entity_datetime`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sales_order_entity_datetime` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sales_order_entity_datetime`
--

LOCK TABLES `sales_order_entity_datetime` WRITE;
/*!40000 ALTER TABLE `sales_order_entity_datetime` DISABLE KEYS */;
/*!40000 ALTER TABLE `sales_order_entity_datetime` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sales_order_entity_decimal`
--

DROP TABLE IF EXISTS `sales_order_entity_decimal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sales_order_entity_decimal` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sales_order_entity_decimal`
--

LOCK TABLES `sales_order_entity_decimal` WRITE;
/*!40000 ALTER TABLE `sales_order_entity_decimal` DISABLE KEYS */;
/*!40000 ALTER TABLE `sales_order_entity_decimal` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sales_order_entity_int`
--

DROP TABLE IF EXISTS `sales_order_entity_int`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sales_order_entity_int` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sales_order_entity_int`
--

LOCK TABLES `sales_order_entity_int` WRITE;
/*!40000 ALTER TABLE `sales_order_entity_int` DISABLE KEYS */;
/*!40000 ALTER TABLE `sales_order_entity_int` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sales_order_entity_text`
--

DROP TABLE IF EXISTS `sales_order_entity_text`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sales_order_entity_text` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sales_order_entity_text`
--

LOCK TABLES `sales_order_entity_text` WRITE;
/*!40000 ALTER TABLE `sales_order_entity_text` DISABLE KEYS */;
/*!40000 ALTER TABLE `sales_order_entity_text` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sales_order_entity_varchar`
--

DROP TABLE IF EXISTS `sales_order_entity_varchar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sales_order_entity_varchar` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sales_order_entity_varchar`
--

LOCK TABLES `sales_order_entity_varchar` WRITE;
/*!40000 ALTER TABLE `sales_order_entity_varchar` DISABLE KEYS */;
/*!40000 ALTER TABLE `sales_order_entity_varchar` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sales_order_int`
--

DROP TABLE IF EXISTS `sales_order_int`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sales_order_int` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sales_order_int`
--

LOCK TABLES `sales_order_int` WRITE;
/*!40000 ALTER TABLE `sales_order_int` DISABLE KEYS */;
/*!40000 ALTER TABLE `sales_order_int` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sales_order_tax`
--

DROP TABLE IF EXISTS `sales_order_tax`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sales_order_tax` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sales_order_tax`
--

LOCK TABLES `sales_order_tax` WRITE;
/*!40000 ALTER TABLE `sales_order_tax` DISABLE KEYS */;
/*!40000 ALTER TABLE `sales_order_tax` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sales_order_text`
--

DROP TABLE IF EXISTS `sales_order_text`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sales_order_text` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sales_order_text`
--

LOCK TABLES `sales_order_text` WRITE;
/*!40000 ALTER TABLE `sales_order_text` DISABLE KEYS */;
/*!40000 ALTER TABLE `sales_order_text` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sales_order_varchar`
--

DROP TABLE IF EXISTS `sales_order_varchar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sales_order_varchar` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sales_order_varchar`
--

LOCK TABLES `sales_order_varchar` WRITE;
/*!40000 ALTER TABLE `sales_order_varchar` DISABLE KEYS */;
/*!40000 ALTER TABLE `sales_order_varchar` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `salesrule`
--

DROP TABLE IF EXISTS `salesrule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `salesrule` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `salesrule`
--

LOCK TABLES `salesrule` WRITE;
/*!40000 ALTER TABLE `salesrule` DISABLE KEYS */;
/*!40000 ALTER TABLE `salesrule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `salesrule_customer`
--

DROP TABLE IF EXISTS `salesrule_customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `salesrule_customer` (
  `rule_customer_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `rule_id` int(10) unsigned NOT NULL DEFAULT '0',
  `customer_id` int(10) unsigned NOT NULL DEFAULT '0',
  `times_used` smallint(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`rule_customer_id`),
  KEY `rule_id` (`rule_id`,`customer_id`),
  KEY `customer_id` (`customer_id`,`rule_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `salesrule_customer`
--

LOCK TABLES `salesrule_customer` WRITE;
/*!40000 ALTER TABLE `salesrule_customer` DISABLE KEYS */;
/*!40000 ALTER TABLE `salesrule_customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sendfriend_log`
--

DROP TABLE IF EXISTS `sendfriend_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sendfriend_log` (
  `log_id` int(11) NOT NULL AUTO_INCREMENT,
  `ip` int(11) unsigned NOT NULL DEFAULT '0',
  `time` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`log_id`),
  KEY `ip` (`ip`),
  KEY `time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Send to friend function log storage table';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sendfriend_log`
--

LOCK TABLES `sendfriend_log` WRITE;
/*!40000 ALTER TABLE `sendfriend_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `sendfriend_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shipping_tablerate`
--

DROP TABLE IF EXISTS `shipping_tablerate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shipping_tablerate` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shipping_tablerate`
--

LOCK TABLES `shipping_tablerate` WRITE;
/*!40000 ALTER TABLE `shipping_tablerate` DISABLE KEYS */;
/*!40000 ALTER TABLE `shipping_tablerate` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sitemap`
--

DROP TABLE IF EXISTS `sitemap`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sitemap` (
  `sitemap_id` int(11) NOT NULL AUTO_INCREMENT,
  `sitemap_type` varchar(32) DEFAULT NULL,
  `sitemap_filename` varchar(32) DEFAULT NULL,
  `sitemap_path` tinytext,
  `sitemap_time` timestamp NULL DEFAULT NULL,
  `store_id` smallint(5) unsigned NOT NULL,
  PRIMARY KEY (`sitemap_id`),
  KEY `FK_SITEMAP_STORE` (`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sitemap`
--

LOCK TABLES `sitemap` WRITE;
/*!40000 ALTER TABLE `sitemap` DISABLE KEYS */;
/*!40000 ALTER TABLE `sitemap` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tag`
--

DROP TABLE IF EXISTS `tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tag` (
  `tag_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `status` smallint(6) NOT NULL DEFAULT '0',
  PRIMARY KEY (`tag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tag`
--

LOCK TABLES `tag` WRITE;
/*!40000 ALTER TABLE `tag` DISABLE KEYS */;
/*!40000 ALTER TABLE `tag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tag_relation`
--

DROP TABLE IF EXISTS `tag_relation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tag_relation` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tag_relation`
--

LOCK TABLES `tag_relation` WRITE;
/*!40000 ALTER TABLE `tag_relation` DISABLE KEYS */;
/*!40000 ALTER TABLE `tag_relation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tag_summary`
--

DROP TABLE IF EXISTS `tag_summary`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tag_summary` (
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tag_summary`
--

LOCK TABLES `tag_summary` WRITE;
/*!40000 ALTER TABLE `tag_summary` DISABLE KEYS */;
/*!40000 ALTER TABLE `tag_summary` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tax_calculation`
--

DROP TABLE IF EXISTS `tax_calculation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tax_calculation` (
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tax_calculation`
--

LOCK TABLES `tax_calculation` WRITE;
/*!40000 ALTER TABLE `tax_calculation` DISABLE KEYS */;
INSERT INTO `tax_calculation` VALUES (1,1,3,2),(2,1,3,2);
/*!40000 ALTER TABLE `tax_calculation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tax_calculation_rate`
--

DROP TABLE IF EXISTS `tax_calculation_rate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tax_calculation_rate` (
  `tax_calculation_rate_id` int(11) NOT NULL AUTO_INCREMENT,
  `tax_country_id` char(2) NOT NULL,
  `tax_region_id` mediumint(9) NOT NULL,
  `tax_postcode` varchar(12) NOT NULL,
  `code` varchar(255) NOT NULL,
  `rate` decimal(12,4) NOT NULL,
  PRIMARY KEY (`tax_calculation_rate_id`),
  KEY `IDX_TAX_CALCULATION_RATE` (`tax_country_id`,`tax_region_id`,`tax_postcode`),
  KEY `IDX_TAX_CALCULATION_RATE_CODE` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tax_calculation_rate`
--

LOCK TABLES `tax_calculation_rate` WRITE;
/*!40000 ALTER TABLE `tax_calculation_rate` DISABLE KEYS */;
INSERT INTO `tax_calculation_rate` VALUES (1,'US',12,'*','US-CA-*-Rate 1','8.2500'),(2,'US',43,'*','US-NY-*-Rate 1','8.3750');
/*!40000 ALTER TABLE `tax_calculation_rate` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tax_calculation_rate_title`
--

DROP TABLE IF EXISTS `tax_calculation_rate_title`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tax_calculation_rate_title` (
  `tax_calculation_rate_title_id` int(11) NOT NULL AUTO_INCREMENT,
  `tax_calculation_rate_id` int(11) NOT NULL,
  `store_id` smallint(5) unsigned NOT NULL,
  `value` varchar(255) NOT NULL,
  PRIMARY KEY (`tax_calculation_rate_title_id`),
  KEY `IDX_TAX_CALCULATION_RATE_TITLE` (`tax_calculation_rate_id`,`store_id`),
  KEY `FK_TAX_CALCULATION_RATE_TITLE_RATE` (`tax_calculation_rate_id`),
  KEY `FK_TAX_CALCULATION_RATE_TITLE_STORE` (`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tax_calculation_rate_title`
--

LOCK TABLES `tax_calculation_rate_title` WRITE;
/*!40000 ALTER TABLE `tax_calculation_rate_title` DISABLE KEYS */;
/*!40000 ALTER TABLE `tax_calculation_rate_title` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tax_calculation_rule`
--

DROP TABLE IF EXISTS `tax_calculation_rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tax_calculation_rule` (
  `tax_calculation_rule_id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(255) NOT NULL,
  `priority` mediumint(9) NOT NULL,
  `position` mediumint(9) NOT NULL,
  PRIMARY KEY (`tax_calculation_rule_id`),
  KEY `IDX_TAX_CALCULATION_RULE` (`priority`,`position`,`tax_calculation_rule_id`),
  KEY `IDX_TAX_CALCULATION_RULE_CODE` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tax_calculation_rule`
--

LOCK TABLES `tax_calculation_rule` WRITE;
/*!40000 ALTER TABLE `tax_calculation_rule` DISABLE KEYS */;
INSERT INTO `tax_calculation_rule` VALUES (1,'Retail Customer-Taxable Goods-Rate 1',1,1);
/*!40000 ALTER TABLE `tax_calculation_rule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tax_class`
--

DROP TABLE IF EXISTS `tax_class`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tax_class` (
  `class_id` smallint(6) NOT NULL AUTO_INCREMENT,
  `class_name` varchar(255) NOT NULL DEFAULT '',
  `class_type` enum('CUSTOMER','PRODUCT') NOT NULL DEFAULT 'CUSTOMER',
  PRIMARY KEY (`class_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tax_class`
--

LOCK TABLES `tax_class` WRITE;
/*!40000 ALTER TABLE `tax_class` DISABLE KEYS */;
INSERT INTO `tax_class` VALUES (2,'Taxable Goods','PRODUCT'),(3,'Retail Customer','CUSTOMER'),(4,'Shipping','PRODUCT');
/*!40000 ALTER TABLE `tax_class` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `weee_discount`
--

DROP TABLE IF EXISTS `weee_discount`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weee_discount` (
  `entity_id` int(10) unsigned NOT NULL DEFAULT '0',
  `website_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `customer_group_id` smallint(5) unsigned NOT NULL,
  `value` decimal(12,4) NOT NULL DEFAULT '0.0000',
  KEY `FK_CATALOG_PRODUCT_ENTITY_WEEE_DISCOUNT_WEBSITE` (`website_id`),
  KEY `FK_CATALOG_PRODUCT_ENTITY_WEEE_DISCOUNT_PRODUCT_ENTITY` (`entity_id`),
  KEY `FK_CATALOG_PRODUCT_ENTITY_WEEE_DISCOUNT_GROUP` (`customer_group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `weee_discount`
--

LOCK TABLES `weee_discount` WRITE;
/*!40000 ALTER TABLE `weee_discount` DISABLE KEYS */;
/*!40000 ALTER TABLE `weee_discount` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `weee_tax`
--

DROP TABLE IF EXISTS `weee_tax`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weee_tax` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `weee_tax`
--

LOCK TABLES `weee_tax` WRITE;
/*!40000 ALTER TABLE `weee_tax` DISABLE KEYS */;
/*!40000 ALTER TABLE `weee_tax` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wishlist`
--

DROP TABLE IF EXISTS `wishlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wishlist` (
  `wishlist_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `customer_id` int(10) unsigned NOT NULL DEFAULT '0',
  `shared` tinyint(1) unsigned DEFAULT '0',
  `sharing_code` varchar(32) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`wishlist_id`),
  UNIQUE KEY `FK_CUSTOMER` (`customer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='Wishlist main';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wishlist`
--

LOCK TABLES `wishlist` WRITE;
/*!40000 ALTER TABLE `wishlist` DISABLE KEYS */;
/*!40000 ALTER TABLE `wishlist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wishlist_item`
--

DROP TABLE IF EXISTS `wishlist_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wishlist_item` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Wishlist items';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wishlist_item`
--

LOCK TABLES `wishlist_item` WRITE;
/*!40000 ALTER TABLE `wishlist_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `wishlist_item` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2010-02-04  8:43:05
