<?php
//  
//
// COPYRIGHT (C) 2009 Ekkitab Educational Services India Pvt. Ltd.  
// All Rights Reserved. All material contained in this file (including, but not 
// limited to, text, images, graphics, HTML, programming code and scripts) constitute 
// proprietary and confidential information protected by copyright laws, trade secret 
// and other laws. No part of this software may be copied, reproduced, modified 
// or distributed in any form or by any means, or stored in a database or retrieval 
// system without the prior written permission of Ekkitab Educational Services.
//
// @author Vijaya Raghavan (vijay@ekkitab.com)
// @version 1.0     Jan 19, 2010
//
// Modified by Chris (christopher@ekkitab.com)
// Aug 30, 2010
//
// This script processes all excel stock files located in the target directory and
// creates the corresponding text files that can be processed by process_stock.php
// afterwards.
//
// Modifications : Process new-arrivals. 
// The process of converting a stocklist to a price-file and finding the missing isbns 
// is now performed within a function processfile()
// Another function added to this script is to check if a book in the newarrivals file is carried
// by the other stocklists. If this is true then these books must be removed from newarrivals file.
//  
// Another requirement that will be satisfied by the script is to process the newarrivals only after all the 
// other stocklists have been processed. This is necessary because, a book in the newarrivals will be published or carried by
// another publisher/distributor soon. Hence, carrying the same book as a newarrival will not be necessary.
//
// Another modification done to this script is to populate the missing_isbns table in the reference db
// 
//
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
ini_set(“memory_limit”,"1024M");

ini_set(include_path, ${include_path}.PATH_SEPARATOR.EKKITAB_HOME."/"."config");
include("ekkitab.php");
ini_set(include_path, ${include_path}.PATH_SEPARATOR.EKKITAB_HOME."/"."bin");
include("convertisbn.php");

function getConfig($file) {
   $config  = parse_ini_file($file, true);
   if (! $config) {
      echo "Configuration file missing. $file\n";
      exit (1); 
   }
   return $config;
}
// Check if a book in the newarrivals is carried by any other stocklist. If yes remove them from the newarrivals.
function checknewarrivalfile($isbn){
global $newarrivalkeydata;
    if(isset($newarrivalkeydata[$isbn])){
        unset($newarrivalkeydata[$isbn]);
    }
}

function getBookPrices($file) {

   $books = array();

   if ($file == "") {
      return ($books);
   }
   $fh = fopen($file,"r");
   if (!$fh) {
     return ($books); 
   }

   while($contents = fgets($fh)) {
      if (preg_match("/^#/", trim($contents))) {
         continue;
      }
      $fields = explode("\t", $contents);
      $isbn = $fields[0];
      // convert isbn to 13 digits if required.
      if (strlen($isbn) == 10) {
         $isbn = convertisbn($isbn);
      } 
      $currency = $fields[2];
      $listPrice = $fields[1];
      if (isset($books[$isbn])) {
        // Rule: If currencies are different, go with Indian currency.
        // Rule: If currencies are both Indian, go with higher value.
        $book = $books[$isbn];
        if ($book['currency'] == $currency) {
            if ($listPrice > $book['list_price']) {
                $book['list_price'] = $listPrice;
            }
        }
        else {
            if ($currency == "I") {
                $book['list_price'] = $listPrice;
                $book['currency'] = $currency;
            }
            elseif ($book['currency'] != "I") {
                $book['discard'] = "true";
            }
        }
        $books[$isbn] = $book;
      }
      else {
        $book = array();
        $book['list_price'] = $listPrice;
        $book['currency'] = $currency;
        $books[$isbn] = $book;
      } 
   }
   fclose($fh);
   return $books;
}

// process a stocklist file and generate missing isbns and price files.
function processfile($db, $outputdir, $file){
global $duplicatebook, $newarrival;
    if ((strlen($file) > 4) && (substr($file, strlen($file) - 4, 4) == ".txt")) {
        $count = 0;                
        $bookprices = getBookPrices($file);
        $basefilename = basename($file);
        $plugin = substr($basefilename, 0, strpos($basefilename, "-"));
        $missingisbnfile  = $outputdir . "/missingisbns/" . $plugin . "-" ."missingisbns.txt";
        $pricefile        = $outputdir . "/prices/" . $plugin . "-" ."prices.txt";
        //echo "Missing ISBN file: $missingisbnfile\n";
        //echo "Price file: $pricefile\n";
        $fh1 = fopen($missingisbnfile, "w");
        if (!$fh1){
            echo("[Process Stock] Could not open file to write missing isbns: " . $missingisbnfile . "\n");
            exit(1);
        }
        fprintf($fh1, "# ISBN\tTITLE\tAUTHOR\n");

        $fh2 = fopen($pricefile, "w");
        if (!$fh2){
            echo("Could not open file to write price information: " . $pricefile . "\n");
            exit(1);
        }
        fprintf($fh2, "# ISBN\tCURRENCY\tLIST-PRICE\tAVAILABILITY\tDISTRIBUTOR\t[DELIVERY DAYS]\n");

        $fh = fopen($file,"r");
        if (!$fh){
            echo("Could not open data file: " . $file . "\n");
            exit(1);
        }
        while($contents = fgets($fh)) {
            if (preg_match("/^#/", trim($contents))) {
                continue;
            }
            $contents = str_replace("\n", "", $contents);
            $fields = explode("\t", $contents);
            $isbn = $fields[0];
            // convert isbn to 13 digits if required.
            if (strlen($isbn) == 10) {
                $isbn = convertisbn($isbn);
            } 
            $title = $fields[5];
            $author = $fields[6];
            $currency = $bookprices[$isbn]['currency'];
            $listPrice = $bookprices[$isbn]['list_price'];
            $availability = $fields[3];
            $distributor = $fields[4];
            $deliverydays = 0;
            if(isset($fields[7])){
                $deliverydays = $fields[7];
            }
            $query = "select count(1) from books where isbn = '$isbn'";
            $query1 = "INSERT INTO `missing_isbns` (isbn, title, author, supplier) VALUES ('$isbn', '$title','$author','$plugin')";
            try{
            $result = mysqli_query($db, $query);
                while ($row = mysqli_fetch_row($result)){
                    $available = $row[0] + 0;
                    if(!$available){
                        if(!isset($duplicatebook[$isbn])){
                            $duplicatebook[$isbn] = 1;
                            mysqli_query($db,$query1);
                            fprintf($fh1, "%s\t%s\t%s\n", $isbn, $title, $author);
                        }
                        else{
                           $duplicatecount++;
                        }
                    }
                    if (!isset($bookprices[$isbn]['discard'])) {
                        fprintf($fh2, "%s\t%s\t%s\t%s\t%s", $isbn, $currency, $listPrice, $availability, $distributor);
                        if ($deliverydays > 0) {
                            fprintf($fh2, "\t%s", $deliverydays);
                        }
                        fprintf($fh2, "\n");
                    }
                }
                if($file != $newarrival){
                    checknewarrivalfile($isbn);
                }
            }   
        
          catch (Exception $e) {
          echo  "[Catalog Validation] Fatal: SQL Exception. $e->getMessage()\n";
          return(1);
          }
        }
            //if (!isset($books[$isbn])) { // not in catalog
                //#fprintf($fh1, "%s\t%s\t%s\n", $isbn, $title, $author);
            //}
            //#if (!isset($bookprices[$isbn]['discard'])) {
              //  #fprintf($fh2, "%s\t%s\t%s\t%s\t%s", $isbn, $currency, $listPrice, $availability, $plugin);
              //  #if ($deliverydays > 0) {
              //      #fprintf($fh2, "\t%s", $deliverydays);
              //  #}
              //  #fprintf($fh2, "\n");
            //#}
       

        foreach ($bookprices as $k => $b) {
            if (isset($b['discard'])) {
                echo "[Process Stock] [Warning]  ISBN $k is ignored because of conflicting duplicate entries in file: $file [processed by $plugin]\n";
            }
        }
        fclose($fh);
        fclose($fh1);
        fclose($fh2);
    }
}
// Process a directory which has the stocklists, the newarrivals stocklist is not processed here. This will be 
// processed only in the lend after books(if exists)  have been removed from other stocklists.
function process($directory, $outputdir, $db) {
   global $newarrival;
   if (!is_dir($directory))
       return;

   //echo "Processing directory: $directory\n";
   $duplicatecount = 0;

   $dir = opendir($directory);
   if (! $dir) {
       echo "Failed to open source directory. $directory\n";
       return;
   }

   while ($file = readdir($dir)) {
        if (($file == ".") || ($file == ".." || ($file == basename($newarrival))))
            continue;
        if (is_dir($directory."/".$file)) {
            echo "[Process Stock] [Warning] Found subdirectory $file. Ignored.\n";
            // process($directory."/".$file, $config, $books); 
        }
        else {
            processfile($db, $outputdir,$directory. "/" . $file);
        }
   }
}

$dbconfig = getConfig(CONFIG_FILE);
$host   = $dbconfig[database][server];
$user   = $dbconfig[database][user];
$psw    = $dbconfig[database][password];
$db     = null;
$truncatequery = "truncate missing_isbns";    
    try  {
        $db = mysqli_connect($host,$user,$psw,"reference");
    }
    catch (exception $e) {
        $db = null;
    }
//truncate missing isbns table-- A new table will be created and populated
    try  {
        mysqli_query($db,$truncatequery);
    }
    catch (exception $e) {
        $db = null;
    }

    if ($db == null) { 
       #fprintf($ferr,  "[Fatal] Could not connect to database.");
       exit(1);
    }

if($argc < 2) {
    echo "Usage: $argv[0] <stocklist directory>\n";
    exit (1);
}

$stocklistdir = $argv[1];

$config = getConfig(STOCK_PROCESS_CONFIG_FILE);


if (!isset($config['general']['outputdir'])) {
    echo "[Process Stock] Output directory is not defined in the configuration. Cannot continue.\n";
    exit(1);
}
$targetdir = $config['general']['outputdir'];
if (!isset($config['general']['newarrivals'])) {
    echo "[Process Stock] New Arrivals file is not defined in the configuration. Cannot continue.\n";
    exit(1);
}
$newarrival = $config['general']['newarrivals'];

$isbn = array();
$newarrivalkeydata = array();
$newarrfilehandle = fopen($newarrival, "r");

while($contents = fgets($newarrfilehandle)){
        $isbn = explode("\t", $contents);
        if(strlen($isbn[0]) == 10){
            $isbn[0] = isbn10to13($isbn[0]);
        }
        $newarrivalkeydata[$isbn[0]] = $contents;
}

$duplicatebook = array();
fclose($newarrfilehandle);
//process the stocklists directory
process($stocklistdir, $targetdir, $db);

//write the newarrivals after checking with the other stocklists if they carry any of the books.
$newarrfilehandle = fopen($newarrival, "w");
foreach ($newarrivalkeydata as $line){
    fwrite ($newarrfilehandle, $line);
}
fclose($newarrfilehandle);

//process the newarrival stocklist.
processfile($db, $targetdir, $newarrival);
