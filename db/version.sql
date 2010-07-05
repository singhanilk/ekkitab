CREATE TABLE IF NOT EXISTS `ekkitab_db_version` ( `version` int NOT NULL) ENGINE=InnoDB DEFAULT CHARSET=utf8;
DELETE FROM ekkitab_db_version;
INSERT INTO ekkitab_db_version (version) VALUES ('4');

