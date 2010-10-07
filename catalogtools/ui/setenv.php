<?php
#---- All the ENV variables to be set here -----.
$EKKITAB_HOME = "/mnt2/scm"; 
putenv("EKKITAB_HOME=$EKKITAB_HOME");

#---- All the INCLUDES ------.
include $EKKITAB_HOME . "/catalogtools/common_catalog_functions.php";

#----- All the GLOBAL variables which will be used by different UI programs. ------.
#Temporary directory when uploading a document
$baseURL="internalutils";
$catalogWorkDirectory="./work/catalogs/";
$imagesWorkDirectory="./work/images/";

// Set up the config to be used by initDatabase.
$config = Array();
$config["database"]["server"] = "localhost";
$config["database"]["user"] = "root";
$config["database"]["password"] = "root";
$config["database"]["ekkitab_db"] = "ekkitab_books";
$config["database"]["ref_db"] = "reference";

#---- All the programs to be referred to. -----.
#Catalog Stock Generator Method.
$catalogStockGeneratorCode = $EKKITAB_HOME. "/catalogtools/catalog_stock_generator.php";
#Import Method.
$importBooksCode = $EKKITAB_HOME. "/db/importbooks.php";

?>
