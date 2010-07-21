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
        print("[Catalog Validation] [Fatal] Configuration file missing or incorrect."); 
        exit(1);
    }
    return $config;
}

function checkValidity($db, $fh){
    while ($data = fgets($fh)){
        $details = explode("\t", $data);
        $isbn = $details[0];
        $listprice = $details[1];
        $discountprice = $details[2];
	    $query = "SELECT isbn, list_price, discount_price FROM  `books` WHERE isbn = '$isbn'";
	    try {
	        $result = mysqli_query($db, $query);
		    if ($result && (mysqli_num_rows($result) > 0)) {
                while( $row=mysqli_fetch_row($result)){
                    if(strcmp(trim($listprice), trim($row[1])) != 0){
                        print "[Catalog Validation] [Warning] Listprice in file->$listprice is different from that of Database->$row[1]\n"; 
                        return (1);
                    }
                    $ratio =round(100 -  ((($row[2]+0)/($row[1]+0))*100));
                    if($ratio > 35){
                       print "[Catalog Validation] [Warning] We are loosing too Much Money!! Discount Greater than 35% on isbn --> $row[0] $row[2]\n";
                       return (1); 
                    }
                }
            }
        } 
	    catch (Exception $e) {
	        echo  "[Catalog Validation] Fatal: SQL Exception. $e->getMessage()\n"; 
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
                print "[Catalog Validation] [Warning] Number of books less than estimated amount\n";
                return (1);
            }
          } 
       }
    }
	catch (Exception $e) {
	   echo  "[Catalog Validation] [Fatal] SQL Exception. $e->getMessage()\n"; 
	   return(1);
	}
    return (0);
}

    $configinifile = CONFIG_FILE;
	if (!file_exists($configinifile)) {
		echo "[Catalog Validation] [Fatal] Configuration file is missing.\n";
		exit (1);
	}
    $textFile = BOOK_VALIDATION;
    if (!file_exists($textFile)){
        echo "[Catalog Validation] [Fatal] Book check reference missing.\n";
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
       fprintf($ferr,  "[Catalog Validation] [Fatal] Could not connect to database.");
       exit(1);
    }
    $fh = fopen($textFile,"r");

    $testnumber = 0;
    $exitvalue = 0;
    foreach ($checks as $check) {
       $testnumber++;
       $failed = $check($db, $fh);
       if ($failed) {
          echo "[Catalog Validation] [Failed] Error number: $testnumber\n";
          $exitvalue = $testnumber;
          break;
       }
    }
    fclose($fh);
    if ($exitvalue == 0) {
       echo "[Catalog Validation] [Passed] Number of checks run: " . count($checks) . "\n";
    }
    exit($exitvalue);
?>
