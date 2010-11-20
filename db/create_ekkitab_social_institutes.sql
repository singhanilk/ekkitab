--
-- create_ekkitab_social_institutes.sql
--
-- COPYRIGHT (C) 2009 Ekkitab Educational Services India Pvt. Ltd.  
-- All Rights Reserved. All material contained in this file (including, but not 
-- limited to, text, images, graphics, HTML, programming code and scripts) constitute 
-- proprietary and confidential information protected by copyright laws, trade secret 
-- and other laws. No part of this software may be copied, reproduced, modified 
-- or distributed in any form or by any means, or stored in a database or retrieval 
-- system without the prior written permission of Ekkitab Educational Servives.
--
-- @author Prasad Potula       (prasad@ekkitab.com)



SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

--
-- Database: `ekkitab_books`
--
USE `ekkitab_books`;

--
-- Table structure for table ek_social_institutes
--

CREATE TABLE IF NOT EXISTS ek_social_institutes (
 id int(10) unsigned NOT NULL AUTO_INCREMENT,
 name varchar(255) NOT NULL,
 email varchar(255) NOT NULL,
 type_id int(10) NOT NULL,
 street text NOT NULL,
 locality varchar(255) DEFAULT NULL,
 city varchar(255) NOT NULL,
 state varchar(255) NOT NULL,
 postcode varchar(255) NOT NULL,
 country_id varchar(20) NOT NULL,
 website_url varchar(255) DEFAULT NULL,
 telephone varchar(255) NOT NULL,
 aboutus text DEFAULT NULL,
 aboutus_summary varchar(2048) DEFAULT NULL,
 is_html tinyint(1) DEFAULT '0',
 image varchar(80) DEFAULT NULL,
 is_valid tinyint(1) DEFAULT '0',
 any_donation tinyint(1) DEFAULT '0',
 admin_id int(10) unsigned NOT NULL,
 created timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
 modified datetime DEFAULT NULL,
 PRIMARY KEY (id),
 UNIQUE KEY UK_EK_INSTITUTE (name,postcode),
 UNIQUE KEY email (email)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3;

--
-- Table structure for table ek_social_institute_types
--

CREATE TABLE IF NOT EXISTS ek_social_institute_types (
id int(11) NOT NULL AUTO_INCREMENT,
type varchar(100) DEFAULT NULL,
created timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
PRIMARY KEY (id)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Constraints for table ek_social_institutes
--
ALTER TABLE ek_social_institutes
ADD CONSTRAINT FK_EK_INSTITUTE_ADMIN FOREIGN KEY (admin_id) REFERENCES customer_entity (entity_id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE ek_social_institutes
ADD CONSTRAINT FK_EK_INSTITUTE_TYPE FOREIGN KEY (type_id) REFERENCES ek_social_institute_types (id) ON DELETE CASCADE ON UPDATE CASCADE;
