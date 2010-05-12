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
// @author Anisha Srinivasan (anisha@ekkitab.com)
// @version 1.0     April 9, 2009
//

// This script will import books into the reference database from a vendor file......

    ini_set(include_path, ${include_path}.PATH_SEPARATOR.EKKITAB_HOME."/"."config");
    include("ekkitab.php");
    require_once(LOG4PHP_DIR . '/LoggerManager.php');
    ini_set(include_path, ${include_path}.EKKITAB_HOME."/"."bin");


    // global logger
    $logger =& LoggerManager::getLogger("loadglobalsection");

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
    * Read and return the configuration data from file. 
    */
    function getConfig($file) {
	    echo $config;
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
	    $ekkitab_db		 = $config[database][ekkitab_db];

        $db  = NULL;
 
        try  {
	        $db     = mysqli_connect($database_server,$database_user,$database_psw,$ekkitab_db);
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

    function doCommit($db) {
       $query = "commit"; 

       if (! $result = mysqli_query($db, $query)) {
           fatal("Failed to commit: ". mysqli_error($db));
       }
    }


   /** 
    * Insert or Update the book in the database. 
    */
    function insertGlobalSectionBook($globalSectionConfig, $db) {

        $today = date('Y-m-j'); 
		//$query = "select section_id,display_name from ek_catalog_global_sections where (active_from_date <= '$today') AND (active_to_date >= '$today')";
		
		if ($globalSectionConfig) 
		{
			//for each section
			foreach($globalSectionConfig as $globalSec=> $globalSecArr){
				
				//get the sectionId for the given section in the ini
				$query = "select section_id from ek_catalog_global_sections where lower(display_name) = '".strtolower($globalSec)."'";
				echo "\n".$query."\n";
				$result  = mysqli_query($db, $query);
                if (! $result)
                    throw new exception("Failed on query: $query");
	            $row	 = mysqli_fetch_array($result);
	            $sectonId = $row[0];

				if ($sectonId > 0) {
					//get all the isbns for that section
					$isbns="";
					$books = array();
					foreach($globalSecArr as $secBooks){
						$isbns =$isbns."'".trim($secBooks)."',";
					}
					$isbns =substr(trim($isbns), 0, -1);

					//get the equivalent bookId for the given isbns
					$i = 0;
					$query = "select id from books where isbn in (".$isbns.")";
					echo "\n".$query."\n";
					$result  = mysqli_query($db, $query);
					if (! $result)
						throw new exception("Failed on query: $query");
					$rowcount	 = mysqli_num_rows($result);
					while($row = mysqli_fetch_array($result)){
						$books[$i++] = $row['id'];
					}
					
					//delete all the books from ek_catalog_global_section_products for this section Id 
					$query = "delete from ek_catalog_global_section_products where section_id = ".$sectonId;
					echo "\n".$query."\n";
					$result  = mysqli_query($db, $query);
					if (! $result)
						throw new exception("Failed on query: $query");
					
					//insert the new books into ek_catalog_global_section_products for this section Id 
					$query =  "Insert into ek_catalog_global_section_products (section_id,product_id) values ";
					echo "\n".$query."\n";
					$subQuery="";
					foreach ($books as $book) {
						$subQuery = $subQuery."(".$sectonId.",".$book."),";
					}
					$subQuery =substr(trim($subQuery), 0, -1);
					echo "\n".$subQuery."\n";
					$query = $query.$subQuery;
					echo "\n".$query."\n";
					$result  = mysqli_query($db, $query);
					if (! $result)
						throw new exception("Failed on query: $query");

				}
			}
		}
		doCommit($db);

    }



   /** 
    * The main program. 
    */
    function start($argc, $argv) {

       // require_once(IMPORTBOOKS_PLUGINS_DIR . "/" . $argv[2] . ".php");
        $config = getConfig(CONFIG_FILE);
//		$config = getConfig(IMPORTBOOKS_INI);
		$db = initDatabases($config);

		if ($argc <= 1) {
			echo "\nNo arguments. Please provide the 'ini' file path after ". EKKITAB_HOME."\n\n";
			echo "Usage: ".$argv[0]."  <Data Source file path> \n";
			exit(1);
		} else{
			$file = EKKITAB_HOME.$argv[1];
		}

		$fh = fopen($file, "r"); 
		if (!$fh) {
			fatal("Could not open data file: $file");
		}

		$globalSectionConfig = getConfig($file);
		insertGlobalSectionBook($globalSectionConfig, $db);
		fclose($fh);
		mysqli_close($db);
    }
    start($argc, $argv);
?>
