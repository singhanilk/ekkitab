<?php
#---- All the ENV variables to be set here -----.
$EKKITAB_HOME = "/Volumes/ppotula_data/Users/admin/ppotula/development/ekkitab/src/scm"; 
putenv("EKKITAB_HOME=$EKKITAB_HOME");

#---- All the INCLUDES ------.
include $EKKITAB_HOME . "/catalogtools/common_catalog_functions.php";

#----- All the GLOBAL variables which will be used by different UI programs. ------.
#Temporary directory when uploading a document
$baseURL="/magento/internalutils/";
$catalogWorkDirectory="/tmp/work/catalogs/";
$imagesWorkDirectory="/tmp/work/images/";

#---- All the programs to be referred to. -----.
#Catalog Stock Generator Method.
$catalogStockGeneratorCode = $EKKITAB_HOME. "catalogtools/catalog_stock_generator.php";
#Import Method.
$importBooksCode = $EKKITAB_HOME. "/db/importbooks.php";

?>
