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



function writeCustomerInsertStatements($fh,$custLine,$entityId,$incrementId) {

	$name = explode(" ",$custLine[1]);

	$firstName = trim(ucwords($name[0]));
	$lastName = trim(ucwords($name[1]));
	$email = trim($custLine[2]);
	$password = getHash(trim($custLine[6]));
	
	$query1 = "INSERT INTO `customer_entity` (`entity_id`, `entity_type_id`, `attribute_set_id`, `website_id`, `email`, `group_id`, `increment_id`, `store_id`, `created_at`, `updated_at`, `is_active`) VALUE (".$entityId.",1, 0, 1, '".$email."', 1, '".$incrementId."', 1, '2010-07-07 06:42:03', '2010-07-07 09:56:03', 1);\n";
	$query2 = "INSERT INTO `customer_entity_varchar` (`entity_type_id`, `attribute_id`, `entity_id`, `value`) VALUES (1,5,".$entityId.",'".$firstName."'),(1,7,".$entityId.",'".$lastName."'),(1,3,".$entityId.",'Ekkitab'),(1,12,".$entityId.",'".$password."');\n";

	fputs($fh, $query1);
	fputs($fh, $query2);

	return true;
}

function getHash($password)
{
		$len=2;
		$chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        mt_srand(10000000*(double)microtime());
        for ($i = 0, $str = '', $lc = strlen($chars)-1; $i < $len; $i++) {
            $str .= $chars[mt_rand(0, $lc)];
        }
		return $str === false ? md5($password) : md5($str . $password) . ':' . $str;
}

function getMaxCustomerEntityId($db) {


    if ($db == null) { 
       fprintf($ferr,  "Fatal: Could not connect to database.");
       exit(1);
    }
	$query = "select max(`entity_id`) from `customer_entity` ;";
	$entityId=0;
	try {
	   $result = mysqli_query($db, $query);
		if ($result && (mysqli_num_rows($result) > 0)) {
			$row = mysqli_fetch_array($result);
			$entityId = $row[0];
		}
	}
	catch (Exception $e) {
	   fprintf($ferr, "Fatal: SQL Exception. $e->getMessage()\n"); 
	   exit(1);
	}

	return ($entityId+1);
}

function getNextIncrementId($db)
{
    if ($db == null) { 
       fprintf($ferr,  "Fatal: Could not connect to database.");
       exit(1);
    }

	$query = "select increment_last_id from eav_entity_store where entity_type_id =1 and store_id=0 ;";
	$last='000000000';
	try {
	   $result = mysqli_query($db, $query);
		if ($result && (mysqli_num_rows($result) > 0)) {
			$row = mysqli_fetch_array($result);
			$last = (string)$row[0];
		}
	}
	catch (Exception $e) {
	   fprintf($ferr, "Fatal: SQL Exception. $e->getMessage()\n"); 
	   exit(1);
	} 
	$last = (int)$last ;
	return ($last+1);
}

function checkUserExists($db,$email)
{
    if ($db == null) { 
       fprintf($ferr,  "Fatal: Could not connect to database.");
       exit(1);
    }

	$query = "select email from `customer_entity` where email='".$email."' ;";
	try {
	   $result = mysqli_query($db, $query);
		if ($result && (mysqli_num_rows($result) > 0)) {
			return false;
		}
	}
	catch (Exception $e) {
	   fprintf($ferr, "Fatal: SQL Exception. $e->getMessage()\n"); 
	   exit(1);
	} 
	return true;
}

function setNextIncrementIdQuery($fh,$last)
{
	$query = "update eav_entity_store set increment_last_id='".$last."' where entity_type_id =1 and store_id=0 ;\n";
	fputs($fh, $query);
	return true;
}

function format($id)
{
	$result = '0';
	$result.= str_pad((string)$id, 8, '0', STR_PAD_LEFT);
	return $result;
}


if ($argc < 2) {
   echo "Usage: $argv[0] -i <Input comma seperated text file>  [<max_entityId>]  [<max_entityId>]\n";
   exit(1);
}

if($argc > 2 ){
	$entityId = (int)$argv[3];
}
if($argc > 3 ){
	$incrementId = (int)$argv[4];
}
$inputfile = "";

for ($i = 1; $i < $argc; $i+=2) {
    if ($argv[$i][0] == '-') {
        if (($i+1) >= $argc) {
            echo "Incomplete arguments. No value supplied for $i\n";
            exit(1);
        }
        switch($argv[$i][1]) {
            case 'i': $inputfile = $argv[$i+1];
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

$fh = fopen($inputfile, "r")or die("Error opening input file.");


$sqlFile = $EKKITAB_HOME."/db/beta_customers.sql";

$fsql = fopen($sqlFile, "w");
if (!$fsql) {
    echo "Could not open file to create sql output for globalsections.\n";
    exit(1);
}

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

if($fh){
	if(!$entityId || !is_int($entityId)){
		$entityId=getMaxCustomerEntityId($db);
	}
	if(!$incrementId || !is_int($incrementId)){
		$incrementId=getNextIncrementId($db);
	}
	fprintf($fsql, "use `ekkitab_books`;\n");
	while ($contents = fgets($fh)){
		if(substr(trim($contents), 0, 1)!='#'){
			$customer = explode(",", $contents);
			if (is_array($customer) && checkUserExists($db,trim($customer[2]))) {
				if(writeCustomerInsertStatements($fsql,$customer,$entityId,format($incrementId))){
					$incrementId++;
					$entityId++;
				}
			}
		}
	}
}
$result=format($incrementId);
setNextIncrementIdQuery($fsql,$result);
fclose($fsql);
fclose($fh);
mysqli_close($db);
exit(0);

?>
