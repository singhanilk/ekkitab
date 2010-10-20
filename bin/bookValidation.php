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

function percentage($listprice, $dbprice){
#convert string to double
    $listprice += 0;
    $dbprice   += 0;
    if (($listprice == 0) || ($dbprice == 0)) {
        return -1;
    }
    $listprice = round($listprice);
    $dbprice   = round($dbprice);
        if($dbprice < $listprice){
            $percentage =round(100-(($dbprice/$listprice)*100));
        }
        else{
            $percentage =round(100-(($listprice/$dbprice)*100));
        }
    return $percentage;
}
function checkValidity($db, $fh){
    $num_errors = 0;
    $num_books = 0;
    $source = "India";
    //$catalog_validation_stopper = false;
    while ($data = fgets($fh)){
        $num_books++;
        $details = explode(",", $data);
        $isbn = $details[0];
        $listprice = $details[1];
        // $localsource is the distributor/publisher from the file 
        $localsource = trim(strtoupper($details[2]));
	    $query = "SELECT isbn, list_price, discount_price FROM  `books` WHERE isbn = '$isbn'";
        $sourced_from = "SELECT sourced_from,info_source FROM `books` WHERE isbn = '$isbn'";
	    try {
            $result_source = mysqli_query($db, $sourced_from);
	        $result = mysqli_query($db, $query);
		    if ($result && (mysqli_num_rows($result) > 0) && (mysqli_num_rows($result_source) > 0)) {
                while( $row=mysqli_fetch_row($result)){ 
                while( $row1=mysqli_fetch_row($result_source)){
                    // $db_localsource is the distributor/publisher from the database, row1[0] has the locale information eg : 'India' 
                    $db_localsource = strtoupper($row1[1]);
                    if($source == $row1[0] && $localsource == $db_localsource){
                        $percentage = percentage(trim($listprice), trim($row[1]));
                        if ($percentage < 0) {
                            print "[Catalog Validation] [Warning] Likely null value for list price for isbn-> $isbn.  $row[1]\n"; 
                        }
                        elseif($percentage >= 50){
                            print "[Catalog Validation] [Severe] Listprice in file->$listprice for isbn-> $isbn is different from that of Database->$row[1] by more than 50%\n"; 
                            $num_errors++;
                            //$catalog_validation_stopper = true;
                        }
                        elseif($percentage >= 5 && $percentage < 50){
                            print "[Catalog Validation] [Warning] Listprice in file->$listprice for isbn-> $isbn is different from that of Database->$row[1] by more than 5%\n"; 
                            $num_errors++;
                        }
                        $listprice = $row[1] + 0;
                        $discountprice = $row[2] + 0;
                        $ratio = 100;
                        if (($listprice > 0) && ($discountprice > 0)) {
                            $ratio = round(100 -  (($discountprice/$listprice)*100));
                        }
                        if ($ratio == 100) {
                            print "[Catalog Validation] [Severe] Discount or list price is likely null for isbn --> $row[0] $discountprice $listprice\n";
                            $num_errors++; 
                        }
                        elseif($ratio > 35){
                            print "[Catalog Validation] [Warning] Discount greater than 35% on isbn --> $row[0] $row[2]\n";
                            $num_errors++; 
                        }
                    }
                }
                }
            }
        } 
	    catch (Exception $e) {
	        echo  "[Catalog Validation] Fatal: SQL Exception. $e->getMessage()\n"; 
	        return(1);
	    }
    }
    print "[Catalog Validation] [Info] $num_errors out of $num_books books failed validation.\n";
    if ($num_errors > 15){
        return (1);
    }
    /*
        elseif($catalog_validation_stopper){
        return (1);
    }*/
    else{
        return (0);
    }
}


function checkBookCount($db, $fh){
    $num_errors = 0;
    $query = "SELECT COUNT(*) FROM `books`";
    $query1 = "select count(*) from books where sourced_from = 'India' and (list_price is not null or list_price != 'NULL')";
    try {
       $ingram = mysqli_query($db, $query);
       $india  = mysqli_query($db, $query1);
	   if ($ingram && $india && (mysqli_num_rows($ingram) > 0) && (mysqli_num_rows($india))) {
           while( $row=mysqli_fetch_row($ingram)){
           while( $row1=mysqli_fetch_row($india)){
                $books_in_db = ($row[0]+0);
                $books_from_india = ($row1[0]+0);
             if ($books_in_db < 3000000 || $books_from_india < 55950){
                print "[Catalog Validation] [Warning] Number of books less than estimated amount\n";
                $num_errors++;
            }
          }
          } 
       }
    }
	catch (Exception $e) {
	   echo  "[Catalog Validation] [Fatal] SQL Exception. $e->getMessage()\n"; 
	   return(1);
	}
    if($num_errors > 0){
        print "[Catalog Validation] [Info] Expected atleast number of books not in catalog, Total book count-> $books_in_db(Expected 3,000,000)  Indian book count -> $books_from_india(Expected 55,950)\n";
        return (1);
    }
    else{
        return ($num_errors);
    }
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
       if($failed) {
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
