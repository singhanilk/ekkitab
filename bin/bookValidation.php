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
    $listprice = round($listprice);
    $dbprice   = round($dbprice);
        if($dbprice < $listprice){
            $percentage =round(100-(($dbprice/$listprice)*100));
        }
        else{
            $percentage =round(100-(($listprice/$dbprice)*100));
        }
    if ($percentage >= 5){
        return 0;
    }
    else{
        return 1;
    }
}
function checkValidity($db, $fh){
    $num_errors = 0;
    $num_books = 0;
    $source = "India";
    while ($data = fgets($fh)){
        $num_books++;
        $details = explode(",", $data);
        $isbn = $details[0];
        $listprice = $details[1];
        $localsource = trim(strtoupper($details[2]));
        //print "Isbn-> $isbn,listprice-> $listprice,discprice-> $discountprice\n";
	    $query = "SELECT isbn, list_price, discount_price FROM  `books` WHERE isbn = '$isbn'";
        $sourced_from = "SELECT sourced_from,info_source FROM `books` WHERE isbn = '$isbn'";
	    try {
            $result_source = mysqli_query($db, $sourced_from);
	        $result = mysqli_query($db, $query);
		    if ($result && (mysqli_num_rows($result) > 0) && (mysqli_num_rows($result_source) > 0)) {
                while( $row=mysqli_fetch_row($result)){ 
                while( $row1=mysqli_fetch_row($result_source)){
                    $db_localsource = strtoupper($row1[1]);
                    if($source == $row1[0] && $localsource == $db_localsource){
                        if(percentage(trim($listprice), trim($row[1])) == 0){
                            print "[Catalog Validation] [Warning] Listprice in file->$listprice for isbn-> $isbn is different from that of Database->$row[1] by more than 5%\n"; 
                            $num_errors++;
                        }
                        $ratio =round(100 -  ((($row[2]+0)/($row[1]+0))*100));
                        if($ratio > 35){
                            print "[Catalog Validation] [Warning] We are loosing too Much Money!! Discount Greater than 35% on isbn --> $row[0] $row[2]\n";
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
    else{
        return (0);
    }
        
}

function checkBookCount($db, $fh){
    $num_errors = 0;
    $query = "SELECT COUNT(*) from `books`";
    try {
       $result = mysqli_query($db, $query);
	   if ($result && (mysqli_num_rows($result) > 0)) {
           while( $row=mysqli_fetch_row($result)){
                $books_in_db = ($row[0]+0);
             if ($books_in_db < 3000000 ){
                print "[Catalog Validation] [Warning] Number of books less than estimated amount\n";
                $num_errors++;
            }
          } 
       }
    }
	catch (Exception $e) {
	   echo  "[Catalog Validation] [Fatal] SQL Exception. $e->getMessage()\n"; 
	   return(1);
	}
    if($num_errors > 0){
        print "[Catalog Validation] [Info] Expected atleast 3,000,000 books in catalog, only $books_in_db found\n";
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
