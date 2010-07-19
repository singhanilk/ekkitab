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
ini_set(include_path, ${include_path}.PATH_SEPARATOR.EKKITAB_HOME."/"."config");
include("ekkitab.php");


$checks = array();
$checks[] = "checkBookCount";
$checks[] = "checkValidity";


function getConfig($file) {
    $config = parse_ini_file($file, true);
    if (! $config) {
        fatal("Configuration file missing or incorrect."); 
    }
    return $config;
}

function checkValidity($db, $fh){
    while ($data = fgets($fh)){
        $details[] = explode("\t", $data);
        $isbn = $details[0];
        $listprice = $details[1];
        $discountprice = $details[2];
	    $query = "SELECT isbn, list_price, discount_price FROM  `books` WHERE isbn = '$isbn'";
	    try {
	        $result = mysqli_query($db, $query);
		    if ($result && (mysqli_num_rows($result) > 0)) {
                while( $row=mysqli_fetch_row($result)){
                    if(strcmp(trim($listprice), trim($row[1])) != 0){
                        print "[Warning] Listprice in file->$listprice is different from that of Database->$row[1]\n"; 
                        return (1);
                    }
                    $ratio = (($row[2]+0)/($row[1]+0))*100;
                    if($ratio > 95){
                       print "[Warning] We are loosing too Much Money!! Discount Greater than 35% $row[2]\n";
                       return (1); 
                    }
                }
            }
        } 
	    catch (Exception $e) {
	        echo  "Fatal: SQL Exception. $e->getMessage()\n"; 
	        return(1);
	    }
    }
    return (0);
}

function checkBookCount($db, $fh){
    $query = "SELECT COUNT(*) from `books`";
    try {
       $result = mysqli_query($db, $query);
	   if ($result && (mysqli_num_rows($result) > 0)) {
           while( $row=mysqli_fetch_row($result)){
             if (($row[0]+0) < 3000000){
                print "[Warning] Number of books less than estimated amount\n";
                return (1);
            }
          } 
       }
    }
	catch (Exception $e) {
	   echo  "Fatal: SQL Exception. $e->getMessage()\n"; 
	   return(1);
	}
    return (0);
}

if (!isset($argv[1])){
    echo "Error! Not enough Parameters... <Usage> $argv[0] <textfilename>\n";
    exit (1);
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
    $db     = null;
    try  {
	    $db = mysqli_connect($host,$user,$psw,"ekkitab_books");
    }
    catch (exception $e) {
        $db = null;
    }

    if ($db == null) { 
       fprintf($ferr,  "Fatal: Could not connect to database.");
       exit(1);
    }
    $fh = fopen($argv[1],"r");

    $testnumber = 0;
    $exitvalue = 0;
    foreach ($checks as $check) {
       $testnumber++;
       $failed = $check($db, $fh);
       if ($failed) {
          echo "Failed: $testnumber\n";
          $exitvalue = $testnumber;
          break;
       }
    }
    fclose($fh);
    exit($exitvalue);
?>
