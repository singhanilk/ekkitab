<?php
error_reporting(E_ALL  & ~E_NOTICE);
ini_set("display_errors", 1); 
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

    include("importbooks_config.php");
    require_once(LOG4PHP_DIR . '/LoggerManager.php');
    ini_set(include_path, ${include_path}.EKKITAB_HOME."/"."bin");
    include("imagehash.php");

    define(UNCLASSIFIED, "ZZZ000000");

    $unclassified = array();
    $equivalents = array();

    // global logger
    $logger =& LoggerManager::getLogger("loadbooks");

   /** 
    * Log the error and terminate the program.
    * Optionally, will accept the query that failed.
    */
    function fatal($message, $query = "") {
        global $logger;
	    $logger->fatal("$message " . (strlen($query) > 0 ? "[ $query ]" . "\n" : ""));
        exit(1);
    }

   /** 
    * This function will log the error.
    * Optionally, will accept the query that failed.
    */
    function warn($message, $query = "") {
        global $logger;
	    $logger->error("$message " . (strlen($query) > 0 ? "[ $query ]" . "\n" : ""));
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
    * Read and return the configuration data from file. 
    */
    function getConfig($file) {
	    $config	= parse_ini_file($file, true);
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
	    $ref_db		     = $config[database][ref_db];

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
                }
                else {
                    $unclassified[$value]++;
                }
                $bisac_codes = $bisac_codes . (empty($bisac_codes) ? "" : ",") . $value;
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
     * This function will return all the currency conversion rates. 
     */
    function getCurrencyConversionRates($db) {
        $currencyrates = array();
        $query    = "select * from ek_currency_conversion"; 
        try {
            $result = mysqli_query($db, $query);
            if (($result) && (mysqli_num_rows($result) > 0)) {
                while($row = mysqli_fetch_array($result)) {
                    $type = strtoupper($row[1]);
                    $currencyrates[$type] = $row[2];
                }
            }
            else {
                throw new exception("Failed to get currency data from database");
            }
        }
        catch(exception $e) {
           fatal($e->getmessage());
        }
        return ($currencyrates);
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
    * Insert or Update the book in the database. 
    */
    function insertBook($book, $db, $mode) {

       if (!empty($book['image'])) {
            $book['image'] = getHashedPath($book['image']);
       }

       $updatestatement = "update ";
       $insertfields = "";
       $insertvalues = "";
       $conjunct = "";
       foreach($book as $key => $value) {
          $updatestatement  .= $conjunct . $key . " = " . "'" . $value . "'" ;
          $insertfields .= $conjunct . $key;
          $insertvalues .= $conjunct . "'" . $value . "'";
          $conjunct = ",";
       }

       $query = "insert into books ( $insertfields ) values ( $insertvalues )"; 

       if (!($mode & MODE_BASIC)) {
            $query .= " on duplicate key " . $updatestatement;
       }

       if (! $result = mysqli_query($db, $query)) {
           warn("Failed to write to Books: ". mysqli_error($db), $query);
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

    function writeOops($line) {
        static $fh  = null;
        if ($line == null) {
            fclose($fh);
            $fh = null;
            return;
        }
        if ($fh == null) {
            $fh = fopen("lines.oops", "a");
            if (!$fh) {
                fatal("Could not open data file: lines.oops");
            }
        }
        fprintf($fh, "%s", $line);
    }

    function writeOk($line) {
        static $fh  = null;
        if ($line == null) {
            fclose($fh);
            $fh = null;
            return;
        }
        if ($fh == null) {
            $fh = fopen("lines.ok", "a");
            if (!$fh) {
                fatal("Could not open data file: lines.ok");
            }
        }
        fprintf($fh, "%s", $line);
    }

   /** 
    * The main program. 
    */
    function start($argc, $argv) {

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
                default:   fatal("Unknown option: " . $argv[1][$i]);
                           break;
             }
           }
        }
        if ($argc != 4) {
            echo "Usage: $argv[0] [-abpd] <Data Source> <Data File>\n";
            fatal("Not enough arguments."); 
        }

        $fh = fopen($argv[3], "r"); 
        if (!$fh) {
            fatal("Could not open data file: $argv[3]");
        }

        readBisacEquivalents();
        require_once(IMPORTBOOKS_PLUGINS_DIR . "/" . $argv[2] . ".php");
        $config = getConfig(IMPORTBOOKS_INI);
        $db = initDatabases($config);

        $parser       = new Parser($pgm_mode);
        $i            = 0;
        $unresolved   = 0;
        $ignored      = 0;
        $errorcount   = 0;
        $unclassified = 0;
        $filenotfound = 0;
    
        $startid = getStartId($db);
        debug("Start Id: $startid");
    
        while ($line = fgets($fh)) {
            $book = array();
            try {
                $book = $parser->getBook($line, $book, $db, $logger);
            }
            catch(exception $e) {
                //fatal($e->getmessage());
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
                    if (empty($currencyrates)) {
                        $currencyrates = getCurrencyConversionRates($db);
                    }
                    if (empty($discountrates)) {
                        $discountrates = getDiscountSettings($db);
                    }

                    $conv_rate = $currencyrates[strtoupper($book['currency'])];
                    if (empty($conv_rate)) {
                        fatal("No currency conversion rate available for " . $book['currency']);
                    }
                    $book['list_price'] = $book['list_price'] * $conv_rate;
                    $book['suppliers_price'] = $book['list_price'] * ((100 - $book['suppliers_discount'])/100);
                    $disc_rate = $discountrates[strtolower($book['info_source'])];
                    if (empty($disc_rate)) {
                        fatal("No discount rate available for supplier " . $book['info_source']);
                    }
                    $discount =  ($book['list_price'] - $book['suppliers_price']) * $disc_rate / 100 ;
                    $book['discount_price'] = round($book['list_price'] - $discount);
                }
                if (!insertBook($book, $db, $pgm_mode)){
                    writeOops($line); 
                    $errorcount++;
                }
                else {
                    writeOk($line); 
                }
            }
        
            if (++$i % 10000 == 0) {
                doCommit($db);
                $inserted = $i - ($errorcount + $unresolved + $filenotfound + $ignored);
                debug("Processed $i rows. [$inserted] inserted. [$errorcount] errors. [$unresolved] unresolved. [$ignored] ignored. [$unclassified] unclassified.\n");
            }
        }
        doCommit($db);
        $inserted = $i - ($errorcount + $unresolved + $filenotfound + $ignored);
        writeUnclassifiedCodesToFile($infosource);
        debug("Processed $i rows. [$inserted] inserted. [$errorcount] errors. [$unresolved] unresolved. [$ignored] ignored. [$unclassified] unclassified.\n");
    
        fclose($fh);
        mysqli_close($db);
    }

    $start = (float) array_sum(explode(' ', microtime()));
    start($argc, $argv);
    $end = (float) array_sum(explode(' ', microtime()));
    debug("Processing time: " . sprintf("%.2f", ($end - $start)/60) . " minutes.\n");
?>
