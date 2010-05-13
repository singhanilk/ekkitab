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
// @version 1.0     May 13, 2010
//

// This script will determine missing images and list them out.

    ini_set(include_path, ${include_path}.PATH_SEPARATOR.EKKITAB_HOME."/"."config");
    include("ekkitab.php");
    require_once(LOG4PHP_DIR . '/LoggerManager.php');
    ini_set(include_path, ${include_path}.PATH_SEPARATOR.EKKITAB_HOME."/"."bin");
    include("imagehash.php");

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

    function getMaxId($db) {
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

    function getImagePathAndIsbn($db, $id) {
        $query = "select image,isbn from books where id = '" . $id . "'";
        if (! $result = mysqli_query($db, $query)) {
           return null; 
        }
	    $row = mysqli_fetch_array($result);
        return $row;
    }


   /** 
    * The main program. 
    */
    function start($argc, $argv) {

        $fh = null;

        $config = getConfig(CONFIG_FILE);

	    $database_server = $config[database][server];
	    $database_user   = $config[database][user];
	    $database_psw    = $config[database][password];
	    $ekkitab_db		 = $config[database][ekkitab_db];

        $db = null;

        try  {
	        $db     = mysqli_connect($database_server,$database_user,$database_psw,$ekkitab_db);
        }
        catch (exception $e) {
            fatal($e->getmessage());
        }

        if ($argc < 2) {
            echo "No output file provided. ISBN numbers for missing images will not be written out.\n";
        }
        else {
            $fh = fopen($argv[1], "w"); 
            if (!$fh) {
                fatal("Could not open output file: $argv[1]");
            }
        }

        $maxId = getMaxId($db);
        $imagedir=EKKITAB_HOME."/"."magento/media/catalog/product";

        $missingimages = 0;
        $totalbooks = 0;

        for ($book = 0; $book < $maxId; $book++) {
            $data = getImagePathAndIsbn($db, $book);
            if ($data != null) {
                $totalbooks++;
                #echo "Checking for image: ".$imagedir."/".$data['image']."\n";
                if (!file_exists($imagedir."/".$data['image'])) {
                    $missingimages++;
                    if ($fh) {
                        fprintf($fh, "%s\n", $data['isbn']); 
                    }
                }
            }
        }
        mysqli_close($db);
        if ($fh) {
            fclose($fh);
        }
        echo "Total number of books: $totalbooks\n";
        echo "Number of missing images: $missingimages\n";
        if ($totalbooks > 0) {
            $percent=($missingimages/$totalbooks)*100;
            echo "Percent images missing: ".$percent."%\n";
        }
    }

    start($argc, $argv);
?>
