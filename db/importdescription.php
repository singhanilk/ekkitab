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
// @author Arun Kuppuswamy (arun@ekkitab.com)
// @version 1.0     Feb 03, 2010
//

// This script will import Description and Short-description into the RefDb...


   include("importbooks_config.php");
   require_once(LOG4PHP_DIR . '/LoggerManager.php');
   ini_set(include_path, ${include_path}.":".EKKITAB_HOME."/"."bin");

   // global logger
    $logger =& LoggerManager::getLogger("loadDescription");

   /** 
    * Log the error and terminate the program.
    * Optionally, will accept the query that failed.
    */
    function  fatal($message, $query = "") {
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
       $config   = parse_ini_file($file, true);
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
       $ref_db           = $config[database][ref_db];

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
     * This function will create update sql statements
     */
    function createUpdateSql($bookdescription,$isbn){

       $updatequery = "update";
       foreach ($bookdescription as $field => $value){

          $updatequery  .= " $field = $value," ;
		  $insertfield  .= "$field,";
		  $insertvalues .= "$value,";
		  
       }
      $insertfield   = substr($insertfield, 0, strrpos($insertfield, ","));
	  $insertvalues  = substr($insertvalues, 0, strrpos($insertvalues, ","));
	  $updatequery   = substr($updatequery, 0, strrpos($updatequery, ","));
      
	  $query = "insert into book_description (ISBN,$insertfield) values ('$isbn',$insertvalues) on duplicate key $updatequery";
	 
      return ($query);
    }

	function updateDescription($db,$fh,$type){
	    
		$bookprocessed = 0;
        $failedBooks   = 0;
        $updatedBooks  = 0;
        $ignored       = 0;
        $startTime = (float) array_sum(explode(' ', microtime()));
	    $parser        = new parser;
           
        while($line = fgets($fh)) {

            $bookinfo = $parser->getBookDescription($line,$type);
            if ($bookinfo == null) {
                $ignored++;
                continue;
            }
            $bookprocessed++;
            $isbn = $bookinfo['ISBN'];
            unset($bookinfo['ISBN']);

            $bookinfo['UPDATED']   = 1;
            $query = createUpdateSql($bookinfo, $isbn);
         
            try{
                $result = mysqli_query($db, $query);
                if (!$result){
                    throw new exception("Failed to Update the Product Description #$query.");
                }
                $updatedBooks++;
             }
             catch(exception $e) {
                warn($e->getmessage());
                warn("Book with ISBN number $isbn did not get updated with Product Description.");
                $failedBooks++;
             }

             if ($bookprocessed % 10000 == 0){
                $endTime = (float) array_sum(explode(' ', microtime()));
                $endTime = ($endTime - $startTime)/60;
                debug(" Processed: $bookprocessed, Updated: $updatedBooks, Ignored: $ignored, Failed: $failedBooks in time: ". sprintf("%.2f minutes.",$endTime) . "\n");
             }
         }

         $endTime = (float) array_sum(explode(' ', microtime()));
         $endTime = ($endTime - $startTime)/60;
         debug(" Processed: $bookprocessed, Updated: $updatedBooks, Failed: $failedBooks in time: ". sprintf("%.2f minutes.",$endTime) . "\n");
	}
		


	/**
     * Main function.
     */
    function start($argc, $argv) {
    
        if ($argc == 1) {
           echo "Usage: $argv[0]  <Data Source> <Option> <Data File>\n";
           exit(0);
        }

		for($i = 1; $i < $argc; $i++) {
			if ($i == 1)
				$infosource = $argv[$i];
			elseif (($i == 2) || ($i == 4)) {
				if (($argv[$i] != "-s") && ($argv[$i] != "-l")) {
					fatal("Unknown parameter: " . $argv[$i]);
				}
				else {
					if ($i+1 >= $argc) {
						fatal ("insufficient arguments.\n");
					}
					if ($argv[$i] == "-s") {
						$fh['pub'] = fopen($argv[$i+1], "r");
						if(!$fh['pub']){
							fatal("Could not open data file: ".$argv[$i+1]);
						}
					}
					else {
						$fh['anno'] = fopen($argv[$i+1], "r");
						if(!$fh['anno']){
							fatal("Could not open data file:".$argv[$i+1]);
						}
					}
					$i++;
				}
			}
		}
           
        require_once(IMPORTBOOKS_CLASSDIR . "/" . $infosource . ".php");
        $config = getConfig(IMPORTBOOKS_INI);
        $db = initDatabases($config);

        if($db==NULL){ 
            fatal("Failed to initialize databases");
        }

		foreach($fh as $type => $file){

				if($type == 'anno'){
					debug("Updating Description");
					updateDescription($db,$file,'long');
				}
				else {
					debug("Updating Short Description");
					updateDescription($db,$file,'short');
				}
		}
		
		foreach($fh as $file){
			fclose($file);
		}
         mysqli_close($db);
    }
    $logger->info("Process started at " . date("d-M-Y G:i:sa"));
    start($argc, $argv);
    $logger->info("Process ended at " . date("d-M-Y G:i:sa"));

?>