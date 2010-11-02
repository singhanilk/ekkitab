-- Patch 23
-- Author: Anisha S.

Alter table sales_flat_quote_item add column 
`is_donation` tinyint(1) NOT NULL DEFAULT '0';

Alter table sales_flat_quote_item add column 
`organization_id` int(11) NOT NULL DEFAULT '0';

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
	 admin_id int(10) unsigned NOT NULL,
	 created timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	 modified datetime DEFAULT NULL,
	 PRIMARY KEY (id),
	 UNIQUE KEY UK_EK_INSTITUTE (name,postcode),
	 UNIQUE KEY email (email)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3;

CREATE TABLE IF NOT EXISTS ek_social_institute_types (
	id int(11) NOT NULL AUTO_INCREMENT,
	type varchar(100) DEFAULT NULL,
	created timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (id)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;
