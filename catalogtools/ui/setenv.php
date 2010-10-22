<?php
#---- All the ENV variables to be set here -----.
$EKKITAB_HOME = "/home/ubuntu/prasad/src/scm"; 
putenv("EKKITAB_HOME=$EKKITAB_HOME");

#---- All the INCLUDES ------.
include $EKKITAB_HOME . "/catalogtools/common_catalog_functions.php";

#----- All the GLOBAL variables which will be used by different UI programs. ------.
#Main catalog directories
$catalogDirectory="/home/ubuntu/prasad/data/catalogs";
$stockDirectory="/home/ubuntu/prasad/data/catalogs";

#Temporary directory when uploading a document
$baseURL="internalutils";
$catalogWorkDirectory="./work/catalogs/";
$imagesWorkDirectory="./work/images/";
$pdfImagesWorkDirectory="./work/pdfimages/";

// Set up the reference_config to be used by initDatabase.
$reference_config = Array();
$reference_config["database"]["server"] = "localhost";
$reference_config["database"]["user"] = "root";
$reference_config["database"]["password"] = "root";
$reference_config["database"]["ekkitab_db"] = "ekkitab_books";
$reference_config["database"]["ref_db"] = "reference";

// Set up the development_config to be used by initDatabase.
$development_config = Array();
$development_config["database"]["server"] = "localhost";
$development_config["database"]["user"] = "dev";
$development_config["database"]["password"] = "dev";
$development_config["database"]["ekkitab_db"] = "ekkitab_books";
$development_config["database"]["ref_db"] = "development";

#---- All the programs to be referred to. -----.
#Catalog Stock Generator Method.
$catalogStockGeneratorCode = $EKKITAB_HOME. "/catalogtools/catalog_stock_generator.php";
#Import Method.
$importBooksCode = $EKKITAB_HOME. "/db/importbooks.php";

?>
