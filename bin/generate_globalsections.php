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
// @version 1.0     Dec 13, 2009
//

// This script will create category information in the ekkitab database. 

ini_set(include_path, ${include_path}.PATH_SEPARATOR.EKKITAB_HOME."/"."config");
include("ekkitab.php");

require_once(LOG4PHP_DIR . '/LoggerManager.php');


// global logger
$logger =& LoggerManager::getLogger("create_categories");

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
* Initialize the files to read from and write into. 
*/
function initXML($name) {
	return simplexml_load_file($name);
}



function writeGlobalSectionsStatements($fh,$globalsection) {

	$id = $globalsection["id"];
	$name = $globalsection["title"];
	$desc = (string)$globalsection->DESCRIPTION;
	$homePageTemplate =(string)$globalsection->HOMEPAGE_TEMPLATE_PATH;
	$booksPageTemplate = (string)$globalsection->BOOKSPAGE_TEMPLATE_PATH;
	$displayOnHome = $globalsection["displayOnHome"]=='yes'?1:0;
	$activeFrom=date('Y-m-d', strtotime($globalsection["activeFrom"]));
	$activeTo=date('Y-m-d', strtotime($globalsection["activeTo"]));
	
	if(!section_exists($id)){
		$statement = "INSERT INTO `ek_catalog_global_sections` (  `section_id` ,`display_name`, `description` , 
		`active_from_date`,  `active_to_date`,`template_path`, `is_homepage_display`, `homepage_template_path`) VALUE \n";
		$statement .= "(".$id.",'".$name."','".$desc."','".$activeFrom."','".$activeTo."','".$booksPageTemplate."',".$displayOnHome.",'".$homePageTemplate."');\n";

	} else{
		$statement = "Update `ek_catalog_global_sections` set `display_name`='".$name."', `description`='".$desc."' , 
		`active_from_date`='".$activeFrom."',  `active_to_date`='".$activeTo."',`template_path`='".$booksPageTemplate."', `is_homepage_display`=".$displayOnHome.", `homepage_template_path` ='".$homePageTemplate."' where `section_id`=".$id.";\n";
	}

	fputs($fh, $statement);

	return true;
}

function section_exists($id) {

	$configinifile = EKKITAB_HOME."/config/ekkitab.ini" ;
	if (!file_exists($configinifile)) {
		echo "Fatal: Configuration file is missing.\n";
		exit (1);
	}

	$config = getConfig($configinifile);
	$host   = $config[database][server];
	$user   = $config[database][user];
	$psw    = $config[database][password];

    $db = null;

    $ferr = fopen("php://stderr", "w");
    if (!$ferr) {
        echo "Fatal: Cannot open standard error output.\n";
        exit (1);
    }

    try  {
	    $db     = mysqli_connect($host,$user,$psw,"ekkitab_books");
    }
    catch (exception $e) {
        $db = null;
    }

    if ($db == null) { 
       fprintf($ferr,  "Fatal: Could not connect to database.");
       exit(1);
    }
	$query = "select section_id from ek_catalog_global_sections where section_id =".$id.";";

	try {
	   $result = mysqli_query($db, $query);
		if ($result && (mysqli_num_rows($result) > 0)) {
			return true;
		}
	}
	catch (Exception $e) {
	   fprintf($ferr, "Fatal: SQL Exception. $e->getMessage()\n"); 
	   exit(1);
	}

	return false;
}

if ($argc < 5) {
   echo "Usage: $argv[0] -i <Input XML file> -o <SQL File>\n";
   exit(1);
}

$inputfile = "";
$outputfile = "";

for ($i = 1; $i < $argc; $i+=2) {
    if ($argv[$i][0] == '-') {
        if (($i+1) >= $argc) {
            echo "Incomplete arguments. No value supplied for $i\n";
            exit(1);
        }
        switch($argv[$i][1]) {
            case 'i': $inputfile = $argv[$i+1];
                      break;
            case 'o': $outputfile = $argv[$i+1];
                      break;
            default:  break;
        }
    }
    else {
        echo "Unknown argument $i\n";
        exit(1);
    }
}

if (!strcmp($inputfile, "")) {
    echo "No input file provided....\n";
    exit(1);
} 

$xml = initXML($inputfile);

//$sqlFile = $EKKITAB_HOME."/db/globalsections.sql";
$sqlFile = $outputfile;

$fhtml = fopen($sqlFile, "w");
if (!$fhtml) {
    echo "Could not open file '$sqlfile' to create sql output for globalsections.\n";
    exit(1);
}

if($xml){
	fprintf($fhtml, "use `ekkitab_books`;\n");
	foreach ($xml as $globalSection) {
		if ($globalSection['id']!="" && $globalSection['title']!="" ) {
			writeGlobalSectionsStatements($fhtml,$globalSection);
		}
	}
}
fclose($fhtml);

?>
