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
// @version 1.0     Feb 23, 2010


	

   include("crawler_config.php");
   require_once(LOG4PHP_DIR . '/LoggerManager.php');
   ini_set(include_path, ${include_path}.EKKITAB_HOME."/"."bin");

    //global db_user and db_password;
	$db_user     = '';
	$db_password = '';

	// global logger
    $logger =& LoggerManager::getLogger("crawler");

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
	* Crawles the directory
	*/
	function CrawlDir($path){
		$TrackDir = opendir($path);
		if(!$path){
			debug("Failure to open $path");
			return;
		}
		$filelist = array();
	
		while ($file = readdir($TrackDir)) {
				if ($file == "." || $file == "..") { } 
				 else {
					 $filelist[] = $file;				
				   }
		}

		foreach ($filelist as $file){
			$file = $path.'/'.$file;
			if(is_dir($file)){
				CrawlDir($file);
			}
			else{
				  $pfile = $path."/.processed";
				  if(file_exists($pfile)){
				  }
				  else {
					  startscripts($path);
					  break;
				  }
			}
		}
	}

   /**
    * This function excutes the commands and creates the .processed file
	*/
	function startscripts($path){
		 $list = getManifest($path);
		if(!empty($list)){
			 $commands = gencommands($path, $list);
			 $error_commands = array();
			 foreach($commands as $command){
				  $output = array();
				  exec($command, $output, $result);
				  if($result > 0){
					  $error_commands[] = $command; 
					  debug("Failed to execute [$command]");
					  debug("Error Message :-");
					  foreach($output as $message){
						  debug("$message");
					  }
				  }
				  else{
					  debug("Successfuly executed [$command]");
				  }
					  
			}
			$fh = fopen($path."/.processed","w");
			foreach($error_commands as $command){
				fputs($fh,$command."\n");
			}
			fclose($fh);
		}
	}

   /**
    * Reads the manifest file and returns an array
	*/
	function getManifest($path){
		$file = $path."/manifest.ini";
		if(!file_exists($file)){
			debug("Manifest file is missing in '$path'");
			return(null);
		}
		$config	= parse_ini_file($file, true);
	
		if(!$config){
			debug("Manifest file empty");
			return(null);
		}
		else{
			$list['catalog']      = $config[files][catalog];
			$list['description']  = $config[files][description];
			$list['pricestock']   = $config[files][pricestock];
			$list['infosource']   = $config[files][infosource];
			$list['langauge']     = $config[files][langauge];
			//$list['user']         = $config[database][username];
			//$list['password']     = $config[database][password];

			return($list);
		}
	}

   /**
    * Generates the commands to excute the required scripts
	*/
	function gencommands($path, $list){
		global $db_user, $db_password;
		$commands = array();
	
		if(!empty($list['catalog'])){
			$file = $path."/".$list['catalog'];
			$commands[] = "php importbooks.php ".$list['infosource']." $file ".$list['langauge'];
		}

		if(!empty($list['description'])){
			$file = $path."/".$list['description'];
			$commands[] = "php importdescription.php ".$list['infosource']." -l $file";
			if($db_password==''){
				$commands[] = "mysql -u$db_user <update_descriptions.sql";
			}
			else{
				$commands[] = "mysql -u$db_user -p$db_password <update_descriptions.sql";
			}
		}

		if(!empty($list['pricestock'])){
			$file = $path."/".$list['pricestock'];
			$commands[] = "php importpricestock.php ".$list['infosource']." $file";
			if($db_password==''){
				$commands[] = "mysql -u $db_user <update_prices_and_stock.sql";
			}
			else{
				$commands[] = "mysql -u $db_user -p $db_password <update_prices_and_stock.sql";
			}
		}

		return($commands);

	}

   /**
    * Main Function
    */
	 function start(){
		 global $db_user, $db_password;
		 $db_config     = getConfig(CRAWLER_INI);
		 $db_user       = $db_config[database][user];
		 $db_password   = $db_config[database][password];
		 CrawlDir(CRAWLER_PATH);
	 }

    $logger->info("Process started at " . date("d-M-Y G:i:sa"));
	start();
    $logger->info("Process ended at " . date("d-M-Y G:i:sa"));

?>
