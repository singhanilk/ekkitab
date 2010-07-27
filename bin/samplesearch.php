<?php
error_reporting(E_ALL  & ~E_NOTICE);
ini_set("display_errors", 1); 
$EKKITAB_HOME=getenv("EKKITAB_HOME");
if (strlen($EKKITAB_HOME) == 0) {
    echo "EKKITAB_HOME is not defined...Exiting.\n";
    exit(1);
}
else {
    define(EKKITAB_HOME, $EKKITAB_HOME); 
}
require_once("$EKKITAB_HOME/magento/Java.inc");

$search = new java("com.ekkitab.search.BookSearch", "$EKKITAB_HOME/magento/search_index_dir");
$query = "isbn:9781846141478";
$category = "";
$pagenum = "1";

$start = (float) array_sum(explode(' ', microtime()));
$page_sz = 15;
$results = $search->searchBook($category, $query, $page_sz, $pagenum);
$end = (float) array_sum(explode(' ', microtime()));
$time = sprintf("%.1f", ($end - $start));
    
$hitcount = 0;
if ($results) {
   $hitcount = $results->getHitCount();
}

if ($hitcount != 1) {
  echo "Search did not return the right result. Search initialization status uncertain.\n";
}
echo "Search warm up completed in $time seconds.\n";
?> 
