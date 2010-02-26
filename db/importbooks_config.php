<?php
include("ekkitab_home.php");
define("LOG4PHP_DIR", EKKITAB_HOME . "/extern/log4php");
define("LOG4PHP_CONFIGURATION", EKKITAB_HOME . "/config/logger.properties");
define("IMPORTBOOKS_INI", EKKITAB_HOME . "/config/importbooks.ini");
define("IMPORTBOOKS_CLASSDIR", ".");
define("IMPORTBOOKS_UNCLASSIFIED", "./unclassified_codes");
define("BISAC_CODE_EQUIVALENTS", EKKITAB_HOME . "/db/" . "bisac_equivalents.txt");
?>
