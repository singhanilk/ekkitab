<?php
include("ekkitab_home.php");
define (LOG4PHP_DIR, EKKITAB_HOME . "/extern/log4php");
define (LOG4PHP_CONFIGURATION, EKKITAB_HOME . "/config/logger.properties");
define (IMPORTBOOKS_INI, EKKITAB_HOME . "/config/importbooks.ini");
define (IMPORTBOOKS_CLASSDIR, ".");
define (IMPORTBOOKS_UNCLASSIFIED, "./unclassified_codes");
define (BISAC_CODE_EQUIVALENTS, EKKITAB_HOME . "/db/" . "bisac_equivalents.txt");
define (IMPORTBOOKS_PLUGINS_DIR, EKKITAB_HOME . "/db/" . "plugins");
define (MODE_BASIC, 0x01);
define (MODE_PRICE, 0x02);
define (MODE_DESC, 0x04);
define (MAX_DESCRIPTION_LENGTH, 1024);
?>
