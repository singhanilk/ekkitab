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
// @version 1.0     Dec 17, 2009
//

// This script will import books into the reference database from a vendor file......

    ini_set(include_path, ${include_path}.PATH_SEPARATOR.EKKITAB_HOME."/"."config");
    include("ekkitab.php");
    require_once(LOG4PHP_DIR . '/LoggerManager.php');
    ini_set(include_path, ${include_path}.PATH_SEPARATOR.EKKITAB_HOME."/"."bin");
    include("imagehash.php");
    include("processdiscount.php");

    define(UNCLASSIFIED, "ZZZ000000");

    $unclassified = array();
    $equivalents = array();

    $logger =& LoggerManager::getLogger("loadbooks");

    // The following two variables are used for delta sql script and index.
    $catalogUpdateSqlFile = null;
    $catalogUpdateIndexFile = null;
    // The product id which will be incremented only if there is a succesfull insert.
    $productId = null;
   // Duplicate insert errors global count.
    $duplicateErrorCount = null;

   /** 
    * Log the error and terminate the program.
    * Optionally, will accept the query that failed.
    */
    function fatal($message, $query = "") {
        global $logger;
        $logger->fatal("$message " . (strlen($query) > 0 ? "[ $query ]" . "\n" : ""));
        echo "[Fatal] $message\n";
        exit(1);
    }

   /** 
    * This function will log the error.
    * Optionally, will accept the query that failed.
    */
    function warn($message, $query = "") {
        global $logger;
        $logger->error("$message " . (strlen($query) > 0 ? "[ $query ]" . "\n" : ""));
        echo "[Warning] $message\n";
    }

   /** 
    * This function will log a debug message.
    * Optionally, will accept the query that failed.
    */
    function debug($message, $query = "") {
        global $logger;
        $logger->debug("$message " . (strlen($query) > 0 ? "[ $query ]" . "\n" : ""));
    }

   /** 
    * This function will log an info message.
    * Optionally, will accept the query that failed.
    */
    function info($message, $query = "") {
        global $logger;
        $logger->info("$message " . (strlen($query) > 0 ? "[ $query ]" . "\n" : ""));
        echo "[Info] $message\n";
    }

   /** 
    * Read and return the configuration data from file. 
    */
    function getConfig($file) {
        $config    = parse_ini_file($file, true);
        if (! $config) {
            fatal("Configuration file missing or incorrect."); 
        }
        return $config;
    }

   /** 
    * Initialize reference database.
    */
    function initDatabases($config) {

        if (! $config) 
            return NULL;

        $database_server = $config[database][server];
        $database_user   = $config[database][user];
        $database_psw    = $config[database][password];
        $ref_db             = $config[database][ref_db];

        $db  = NULL;
 
        try  {
            $db     = mysqli_connect($database_server,$database_user,$database_psw,$ref_db);
        }
        catch (exception $e) {
           fatal($e->getmessage());
        }

        $query = "set autocommit = 0";
        
        try {
            $result = mysqli_query($db,$query);
            if (!$result) {
               fatal("Failed to set autocommit mode.");
            }
        }
        catch(exception $e) {
            fatal($e->getmessage());
        }

        return $db;
    }

    /*
     * Check if a data file has already been processed using data in table ek_import_state.
     */
     function checkFileProcessed($file, $db) {
        $processed = false;
        $filemodtime = "";
        $dbmodtime = "";
        if ($file != null) {
            if (file_exists($file)) {
                $filemodtime = date("Y-m-d H:i:s", filemtime($file));
            }
        }
        if ($filemodtime != "") {
            $query = "select updatetime from ek_import_state where filename = '$file'";
            try {
                $result = mysqli_query($db,$query);
                if (($result) && (mysqli_num_rows($result) > 0)) {
                    $row = mysqli_fetch_array($result);
                    $dbmodtime = $row[0];
                }
            }
            catch (exception $e) {
                fatal($e->getmessage());
            }
        }

        if (($dbmodtime == "") ||  ($filemodtime == "")) {
            $processed = false;
        }
        else {
            $db_mod = strtotime($dbmodtime);
            $file_mod = strtotime($filemodtime);
            if ($file_mod > $db_mod) {
                $processed = false;
            }
            else {
                $processed = true;
            }
        }
        return $processed;
     }

    /*
     * Update import_state table with the file that has been processed.
     */
     function setFileProcessed($file, $table, $db) {
        if (($file != null) && ($file != "")) {
            $query = "insert into  ek_import_state (filename, tablename, updatetime) values ('$file', '$table', now()) ";
            $query .= "on duplicate key update tablename = '$table', updatetime = now()";
            try {
                $result = mysqli_query($db,$query);
                if (!$result) {
                    fatal("Failed to update import state table.\n");
                }
            }
            catch (exception $e) {
                fatal("Exception in trying to update import state table. " . $e->getmessage());
                exit(1);
            }
        }
     }

   /** 
    *  Write delta sql scripts to update file
    *  These scripts will contain both insert and update scripts for applying to the production database. 
    */
    function writeCatalogUpdatesToFile($sqlString, $isbn, $mode) {
        global $catalogUpdateSqlFile;
        global $catalogUpdateIndexFile;
        
       if ($mode & MODE_BASIC) {
        fwrite($catalogUpdateSqlFile, $sqlString.";\n");
        fwrite($catalogUpdateIndexFile, $isbn."\n");
       } elseif ($mode & MODE_PRICE) {
        fwrite($catalogUpdateSqlFile, $sqlString.";\n");
       }
    }

   /** 
    *  Write unclassified category codes to file. 
    */
    function writeUnclassifiedCodesToFile($infosource) {
        global $unclassified;
        $fh = fopen(IMPORTBOOKS_UNCLASSIFIED, "a"); 
        if (!$fh) 
           warn("Could not open unclassified file: ".IMPORTBOOKS_UNCLASSIFIED);
        else {
           foreach($unclassified as $key => $value) {
               fprintf($fh, "%s - %s - %s[%s]\n", $infosource, date("d-M-Y H:i:s"), $key, $value);
           }
           fclose($fh);
        }
    }

   /** 
    *  Read equivalents for BISAC codes. 
    */
    function readBisacEquivalents() {
        global $equivalents;
        $fh = fopen(BISAC_CODE_EQUIVALENTS, "r"); 
        if (!$fh) 
           warn("Could not open bisac equivalents file: ". BISAC_CODE_EQUIVALENTS);
        else {
           while ($line = fgets($fh)) {
              $codes = explode("=", $line);
              $equivalents[$codes[0]] = trim($codes[1]);
           }
           fclose($fh);
        }
    }

   /** 
    *  Get the unclassified category code. 
    */
    function getUnclassifiedCategoryCode($db) {
       static $book = array(); 
       if (empty($book)) {
            $lookup = "select category_id from ek_bisac_category_map where bisac_code = '".UNCLASSIFIED."'";
            $result = mysqli_query($db, $lookup);
            if (($result) && (mysqli_num_rows($result) > 0)){
                $row = mysqli_fetch_array($result);
                $book['catcode'] = $row[0];
            }
            else {
                fatal("Could not get unclassified code.");
            }
       }
       return $book;
    }

   /** 
    *  Convert BISAC codes to Magento Category Codes. 
    */
    function addCategoryCodes($book, $db) {
      global $unclassified;
      global $equivalents;

      $catIds = array();

      $book['catcode'] = "";
      $bisac_codes = "";
      if (! empty($book['bisac'])) {
        foreach($book['bisac'] as $value) {
            if (strcmp($value, "")) {
                if (!empty($equivalents[$value]))
                    $value = $equivalents[$value];
                $lookup = "select category_id from ek_bisac_category_map where bisac_code = '". $value . "'";
                $result = mysqli_query($db, $lookup);
                if (($result) && (mysqli_num_rows($result) > 0)){
                    $row = mysqli_fetch_array($result);
                    $ids = explode(",", $row[0]);
                    foreach($ids as $id) {
                        $catIds[$id] = 1;
                    }
                    $bisac_codes = $bisac_codes . (empty($bisac_codes) ? "" : ",") . $value;
                }
                else {
                    $unclassified[$value]++;
                }
            }
        }
      }
      if (empty($catIds)) {
         $book['unclassified'] = true;
         $tmp = getUnclassifiedCategoryCode($db);
         $ids = explode(",", $tmp['catcode']);
         foreach($ids as $id) {
             $catIds[$id] = 1;
         }
         $bisac_codes = UNCLASSIFIED;
      }
      else 
         $book['unclassified'] = false;

      $book['bisac1'] = implode(",", array_keys($catIds));
      $book['bisac_codes'] = $bisac_codes;

      unset($book['catcode']);
      return ($book);
    }


   /** 
    *  Get the discount computation value from the reference database.  
    */
    function getDiscountSettings($db) {
       $discountrates = array();   
       $query = "select * from ek_discount_setting";
       try {
            $result = mysqli_query($db, $query);
            if (($result) && (mysqli_num_rows($result) > 0)) {
                while ($row = mysqli_fetch_array($result)) {
                    $type = strtolower($row[1]);
                    $discountrates[$type] = $row[2];
                }
            }
            else {
                throw new exception("Failed to get discount data from database");
            }
       }
       catch(exception $e) {
           fatal($e->getmessage());
       }
       return($discountrates);
    }
   /** 
    * Insert Promo material from Ingrams into books_promo table in the reference database.  
    */
    function insertPromo($book, $db, $linenumber){
        if($book['promo'] != "" ){
            $isbn  = $book['isbn'];
            $promo = $book['promo'];
            $query = "insert into books_promo ( isbn , promo_desc ) values ('$isbn','$promo')";
            if (!$result = mysqli_query($db, $query)) {
               warn("Failed to write to Books. [Line: $linenumber] ". mysqli_error($db), $query);
               return(0); 
            }
        }
        
        return(1);
    } 
   /**
    * Insert or Update the book in the database. 
    */
    function insertBook($book, $db, $mode, $linenumber) {
       global $productId;
       global $duplicateErrorCount;

       if ($mode & MODE_PROMO) {
           return insertPromo($book,$db, $linenumber);
       }
       if (!empty($book['image'])) {
            $book['image'] = getHashedPath($book['image']);
       }

       $insertfields = "";
       $insertvalues = "";
       $conjunct = "";
       $isbn = "";
       foreach($book as $key => $value) {
          if (strcmp($key, "isbn")) {
            $updatestatement  .= $conjunct . $key . " = " . "'" . $value . "'" ;
          }
          else {
            $isbn = $value;
          }
          $insertfields .= $conjunct . $key;
          $insertvalues .= $conjunct . "'" . $value . "'";
          $conjunct = ",";
       }
       // Add the productId in front of all other values as the autoincrement has been taken away.
       $insertfields = "id".$conjunct.$insertfields;
       $insertvalues = "$productId".$conjunct.$insertvalues;

       $updatestatement = preg_replace("/^\s*,/", "", $updatestatement);

       if ($mode & MODE_BASIC) {
            $query = "insert into books ( $insertfields ) values ( $insertvalues )"; 
       }
       elseif ($mode & MODE_PRICE) {
            $bookavailable = $book['in_stock'];
            $discountprice = $book['discount_price']; 
            $delivery_period = $book['delivery_period'];
            if ($bookavailable == '0') {
              $whereclause = "(isbn = '$isbn') and ((discount_price is null) or ((in_stock = '0') and discount_price > '$discountprice'))";
            } elseif ($bookavailable == '2') {
              $whereclause = "(isbn = '$isbn') and ((discount_price is null) or ((in_stock = '2') and discount_price > '$discountprice'))";
            } else {
              $whereclause = "(isbn = '$isbn') and ((discount_price is null) or (in_stock = '0') or ((in_stock = '1') and ((discount_price > '$discountprice') or (delivery_period > '$delivery_period'))))";
            }
            $query = "update books set " . $updatestatement . " where $whereclause";
       }
       else {
            $query = "update books set " . $updatestatement . " where isbn = '$isbn'";
       }
       if (! $result = mysqli_query($db, $query)) {
           if (mysqli_errno($db) != 1062) { // 1062 represents duplicate key
              $duplicateErrorCount++;
              warn("Failed to write to Books. [Line: $linenumber] ". mysqli_error($db), $query);
           }
           return(0); 
       }
       else {
           if( mysqli_affected_rows($db) > 0 ) {
            /* The query has been successful and check if it is a insert then increment the productId  */
            if ($mode & MODE_BASIC) $productId++;
            /* We have commented out the write as we are not applying delta right now */
            //writeCatalogUpdatesToFile($query, $isbn, $mode);
           }
           return(1);
       }
    }

    function updateBookAvailability($book, $db) {

       $query = "insert into book_availability (isbn, distributor, in_stock) values ( ";
       $query .= "'" . $book['isbn'] . "','" . $book['distributor'] . "','" . $book['in_stock'] . "'";
       $query .= " ) on duplicate key update in_stock = ";
       $query .= "'" . $book['in_stock'] . "'";

       if (! $result = mysqli_query($db, $query)) {
           warn("Failed to update book availability: ". mysqli_error($db), $query);
           return(0); 
       }
       else {
           return(1);
       }
    }

    function doCommit($db) {
       $query = "commit"; 

       if (! $result = mysqli_query($db, $query)) {
           fatal("Failed to commit: ". mysqli_error($db));
       }
    }

    function getStartId($db) {
        $query = "select max(id) from books";
        if (! $result = mysqli_query($db, $query)) {
           fatal("Failed to get maximum count: ". mysqli_error($db), $query);
           return(0); 
        }
        $row = mysqli_fetch_array($result);
        if ($row[0] == null)
            return 1;
        else
            return $row[0] + 1;
    }

    function getSellingPrice($source, $listprice, $costprice, $disc_rate) {

        if ($listprice <= 0) {
            return 0;
        }

        // Calculate expenditure on book, assuming single book purchase
        // Expenditure = cost price + shipping + packing + credit card commission
        define ("FREE_SHIPPING_THRESHOLD", 200);

        $shippingcost = 40;
        if (strtolower($source) != "india") {
            $shippingcost = 200;
        }
        $creditcardcost = 0.03 * $listprice;
        $othercost = 10;

        $collectshipping = 0;
        if ($listprice < FREE_SHIPPING_THRESHOLD) {
            $collectshipping = 30;
        }

        $expenses = $shippingcost + $creditcardcost + $othercost - $collectshipping; 
        if (($costprice + $expenses) > $listprice) {
            $listprice = $costprice + $expenses;
        }

        $margin = $listprice - ($costprice + $expenses); 
        $discount = ($disc_rate/100) * $margin;

        if ((($discount / $listprice) * 100) < 5) {
            $discount = 0;
        }

        $sellingprice =  round($listprice  - $discount);

        return $sellingprice;
    }

   /** 
    * The main program. 
    */
    function start($argc, $argv) {

        global $logger;
        global $catalogUpdateSqlFile;
        global $catalogUpdateIndexFile;
        global $productId;

        if ($argc == 1) {
           echo "Usage: $argv[0] [-abpd] <Data Source> <Data File>\n";
           exit(0);
        }
        $pgm_mode = 0;
        if ($argv[1][0] == '-') {
           for ($i = 1; $i < strlen($argv[1]) ; $i++) {
             switch ($argv[1][$i]) {
                case 'a':  $pgm_mode |= (MODE_BASIC | MODE_PRICE | MODE_DESC);
                           break;
                case 'b':  $pgm_mode |= MODE_BASIC;
                           break;
                case 'p':  $pgm_mode |= MODE_PRICE;
                           break;
                case 'd':  $pgm_mode |= MODE_DESC;
                           break;
                case 'z':  $pgm_mode |= MODE_PROMO;
                           break;
                default:   fatal("Unknown option: " . $argv[1][$i]);
                           break;
             }
           }
        }
        if ($argc != 4) {
            echo "Usage: $argv[0] [-abpdz] <Data Source> <Data File>\n";
            fatal("Not enough arguments."); 
        }

        $fh = fopen($argv[3], "r"); 
        if (!$fh) {
            fatal("Could not open data file: $argv[3]");
        }

        readBisacEquivalents();
        require_once(IMPORTBOOKS_PLUGINS_DIR . "/" . $argv[2] . ".php");
        $config = getConfig(CONFIG_FILE);
        $db = initDatabases($config);

        if (($pgm_mode & ~MODE_PRICE) && (checkFileProcessed($argv[3], $db))) {
            info("Data file ".$argv[3]. " has already been processed.");
            exit(0);
        }

        //Get the file that controls how much discount we give to customers.
        $discountfile = "";
        if (isset($config['files']['discountdatafile'])) {
            $discountfile = $config['files']['discountdatafile'];
        }
        else {
            fatal("No discount data file found. ");
        }
        $discountmodel = getDiscountData($argv[2], $discountfile);
        if ($discountmodel == null) {
           fatal("Could not get discount information from file."); 
        }
        $parser       = new Parser($pgm_mode, $db, $logger, $discountmodel);
        $i            = 0;
        $unresolved   = 0;
        $ignored      = 0;
        $errorcount   = 0;
        $unclassified = 0;
        $filenotfound = 0;
        $linenumber   = 0;

        // The catalog update file names
        $catalogUpdateDir = EKKITAB_HOME."/release/catalogupdate";
        $catalogUpdateSqlFileName = $catalogUpdateDir."/catalogupdate.sql";
        $catalogUpdateIndexFileName = $catalogUpdateDir."/catalogupdate.txt";

        // Open the updateScriptFile and the updateIndexFiles for writing out the deltas for books and indexes. 
        $catalogUpdateSqlFile = fopen($catalogUpdateSqlFileName, "a"); 
        if (!$catalogUpdateSqlFile) { fatal("Could not create the  catalog sql file"); }
        $catalogUpdateIndexFile = fopen($catalogUpdateIndexFileName, "a"); 
        if (!$catalogUpdateIndexFile) { fatal("Could not create the index text file"); }
        // Get the start Id  
        $productId = getStartId($db);
        $duplicateErrorCount = 0;
        while ($line = fgets($fh)) {
            $linenumber++;
            $book = array();
            try {
                $book = $parser->getBook($line);
            }
            catch(exception $e) {
                warn($e->getmessage());
                $book = null;
            }
            if (!$book) {
                $ignored++;
            }
            else {
                if ($pgm_mode & MODE_BASIC) {
                    $book = addCategoryCodes($book, $db);
                    unset($book['bisac']);
                    if (empty($book['bisac1'])) { 
                        $unresolved++;
                    }
                    if ($book['unclassified']) {
                        $unclassified++;
                    }
                    unset($book['unclassified']);
                }
                if ($pgm_mode & MODE_PRICE) {
                    //if (empty($discountrates)) {
                    //    $discountrates = getDiscountSettings($db);
                    //}

                    //$conv_rate = $currencyrates[strtoupper($book['currency'])];
                    //if (empty($conv_rate)) {
                    //    fatal("No currency conversion rate available for " . $book['currency']);
                    //}
                    //$book['list_price'] = round($book['list_price'] * $conv_rate);
                    //$book['suppliers_price'] = round($book['list_price'] * ((100 - $book['suppliers_discount'])/100));
                    $distributor = isset($book['info_source']) ? $book['info_source'] : $book['distributor'];
                    //$disc_rate = $discountrates[strtolower($distributor)];
                    //if (empty($disc_rate)) {
                    //    fatal("No discount rate available for supplier " . $distributor);
                    //}
                    //$book['discount_price'] = getSellingPrice($book['sourced_from'], $book['list_price'], $book['suppliers_price'], $disc_rate);
                    //if ($book['discount_price'] > $book['list_price']) { // Raise the list price
                    //    $book['list_price'] = $book['discount_price'];
                    //}
                    //$discount =  ($book['list_price'] - $book['suppliers_price']) * $disc_rate / 100 ;
                    //$book['discount_price'] = round($book['list_price'] - $discount);
                    if (isset($book['distributor'])) {
                        updateBookAvailability($book, $db);
                        unset($book['distributor']);
                    }
                }
          
                if (!insertBook($book, $db, $pgm_mode, $linenumber)){
                  $errorcount++;
               }
            }
        
            if (++$i % 100000 == 0) {
                doCommit($db);
                $inserted = $i - ($errorcount + $unresolved + $filenotfound + $ignored);
                debug("Processed $i rows. [$inserted] inserted. [$errorcount] errors. [$unresolved] unresolved. [$ignored] ignored. [$unclassified] unclassified.");
            }
        }
        doCommit($db);
        $inserted = $i - ($errorcount + $unresolved + $filenotfound + $ignored);
        writeUnclassifiedCodesToFile($infosource);
        info("Processed $i rows. [$inserted] inserted. [$errorcount] errors. [$unresolved] unresolved. [$ignored] ignored. [$unclassified] unclassified.\n");
        $updatedtable = ($pgm_mode & MODE_PROMO) ? "books_promo" : "books"; 
        setFileProcessed($argv[3], $updatedtable, $db);
        doCommit($db);
    
        fclose($fh);
        fclose($catalogUpdateSqlFile);
        fclose($catalogUpdateIndexFile);
        mysqli_close($db);
        return $inserted;
    }

    $start = (float) array_sum(explode(' ', microtime()));
    $errorRowCount = start($argc, $argv);
    $end = (float) array_sum(explode(' ', microtime()));
    info("Processing time: " . sprintf("%.2f", ($end - $start)/60) . " minutes.");
    exit($errorRowCount);
?>
