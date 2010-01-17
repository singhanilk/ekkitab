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

    define(UNCLASSIFIED, "ZZZ000000");
    $unclassified = array();

    // global logger
    $logger =& LoggerManager::getLogger("loadbooks");

   /** 
    * Log the error and terminate the program.
    * Optionally, will accept the query that failed.
    */
    function fatal($message, $query = "") {
        global $logger;
	    $logger->fatal("$message " . "[ $query ]" . "\n");
        exit(1);
    }

   /** 
    * This function will log the error.
    * Optionally, will accept the query that failed.
    */
    function warn($message, $query = "") {
        global $logger;
	    $logger->error("$message " . "[ $query ]" . "\n");
    }

   /** 
    * This function will log a debug message.
    * Optionally, will accept the query that failed.
    */
    function debug($message, $query = "") {
        global $logger;
	    $logger->debug("$message " . "[ $query ]" . "\n");
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
               fprintf($fh, "%s - %s - %s\n", $infosource, date("d-M-Y H:i:s"), $key);
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
            $lookup = "select category_id,rewrite_url from ek_bisac_category_map where bisac_code = '".UNCLASSIFIED."'";
            $result = mysqli_query($db, $lookup);
            if (($result) && (mysqli_num_rows($result) > 0)){
	            $row = mysqli_fetch_array($result);
                $book['catcode'] = $row[0] . ",";
                $book['rewrite_url'] = $row[1];
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

      $book['catcode'] = "";
      if (! empty($book['bisac'])) {
        foreach($book['bisac'] as $value) {
            $lookup = "select category_id,rewrite_url from ek_bisac_category_map where bisac_code = '". $value . "'";
            $result = mysqli_query($db, $lookup);
            if (($result) && (mysqli_num_rows($result) > 0)){
	            $row = mysqli_fetch_array($result);
                $book['catcode'] = $row[0] . ",";
                $book['rewrite_url'] = $row[1];
            }
        }
      }
      if (strcmp($book['catcode'], "")) 
        $book['catcode'] = substr($book['catcode'], 0, strrpos($book['catcode'], ","));
      else {
        $tmp = getUnclassifiedCategoryCode($db);
        $book['catcode'] = $tmp['catcode'];
        $book['rewrite_url'] = $tmp['rewrite_url'];
        if (!empty($book['bisac'])) {
            foreach($book['bisac'] as $value) 
                $unclassified[$value] = 0;
        }
      }
      return ($book);
    }

   /** 
    *  Convert BISAC codes to Magento Category Codes. 
    */
    function insertBook($book, $db, $language, $shipregion, $infosource) {

       $query = "insert into books (`isbn10`, `isbn`, `author`, `publisher`, `title`, `pages`, " .
                "`language`, `bisac1`, `cover_thumb`, `image`, `weight`, " .
                "`dimension`, `edition`, `shipping_region`, `info_source`, `new`, `rewrite_url`) values (";

       $query = $query . "'" . $book['isbn'] . "'".",";
       $query = $query . "'" . $book['isbn13'] . "'".",";
       $query = $query . "'" . $book['author'] . "'".",";
       $query = $query . "'" . $book['publisher'] . "'".",";
       $query = $query . "'" . $book['title'] . "'".",";
       $query = $query . "'" . $book['pages'] . "'" . ",";
       $query = $query . "'$language'" . ",";
       $query = $query . "'" . $book['catcode'] . "'" . ",";
       #$query = $query . "'" . $book['catcode'][1] . "'" . ",";
       #$query = $query . "'" . $book['catcode'][2] . "'" . ",";
       $query = $query . "'" . $book['thumbnail'] . "'" . ",";
       $query = $query . "'" . $book['image'] . "'" . ",";
       $query = $query . "'" . $book['weight'] . "'" . ",";
       $query = $query . "'" . $book['dimension'] . "'".",";
       $query = $query . "'" . $book['edition'] . "'" . ",";
       $query = $query . "'" . $shipregion . "'" . ",";
       $query = $query . "'" . $infosource . "'" . ",";
       $query = $query . "0" . ",";
       $query = $query . "'" . $book['rewrite_url'] . "'". ");";
       if (! $result = mysqli_query($db, $query)) {
           warn("Failed to write to Books: ". mysqli_error($db), $query);
           return(0); 
       }
       else {
           return(1);
       }
    }

   /** 
    * The main program. 
    */
    function start($argc, $argv) {

        if ($argc == 1) {
           echo "Usage: $argv[0] <Data Source> <Data File> <Language>\n";
           exit(0);
        }
        if ($argc != 4) 
            fatal("No supplier name or import file."); 

        $fh = fopen($argv[2], "r"); 
        if (!$fh) {
            fatal("Could not open data file: $argv[2]");
        }
        $infosource = $argv[1];
        $language   = $argv[3];
        require_once(IMPORTBOOKS_CLASSDIR . "/" . $infosource . ".php");
        $config = getConfig(IMPORTBOOKS_INI);
        $db = initDatabases($config);

        $parser       = new Parser;
        $i            = 1;
        $unresolved   = 0;
        $errorcount   = 0;
        $filenotfound = 0;
        $shipregion   = 0; 
    
        while ($line = fgets($fh)) {
            $book = $parser->getBook($line);
            $book = addCategoryCodes($book, $db);
            if (!strcmp($book['catcode'][0], "")) { 
                $unresolved++;
                //debug("Unresolved: " . $book['bisac'][0]);
            }
            //elseif (!file_exists("../magento/media/catalog/product/9/7/" . $book['thumbnail'])) {
                //$filenotfound++;
                //debug("File not found: " . $book['thumbnail']);
            //}
            elseif (!insertBook($book, $db, $language, $shipregion, $infosource)){
                $errorcount++;
            }
            else {
                //debug("Updated book: " . $book['isbn13']);
            }
        
            if ($i++ % 10000 == 0) {
                $inserted = $i - ($errorcount + $unresolved + $filenotfound + 1);
                debug("Processed $i books. [$inserted] inserted. [$errorcount] errors. [$unresolved] unresolved. [$filenotfound] files not found.\n");
            }
        }
        writeUnclassifiedCodesToFile($infosource);
    
        fclose($fh);
        mysqli_close($db);
    }

    $start = (float) array_sum(explode(' ', microtime()));
    start($argc, $argv);
    $end = (float) array_sum(explode(' ', microtime()));
    echo "Processing time: " . sprintf("%.2f", ($end - $start)) . " seconds.\n";
?>
