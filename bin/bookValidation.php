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

    function checkValidity($db, $fh) {
        $num_errors = 0;
        $num_serious_errors = 0;
        $threshold_errors = 20;
        $threshold_serious_errors = 15;
        $num_books = 0;
        $source = "India";
        //$catalog_validation_stopper = false;
        while ($data = fgets($fh)){ // for each book in the reference file.
            $num_books++;
            $details = explode(",", $data);
            $isbn = $details[0];
            $reference_listprice = $details[1];
            $reference_supplier = trim(strtoupper($details[2]));
    	    $query = "select list_price, discount_price, in_stock, sourced_from, info_source from books where isbn = '$isbn'";
            $listprice = 0.0;
            $discountprice = 0.0;
            $instock = 0;
            $sourcedfrom = "";
            $supplier = "";
    	    try {
    	        $result = mysqli_query($db, $query);
    		    if ($result && (mysqli_num_rows($result) > 0)) {
                    $row=mysqli_fetch_array($result); 
                    $listprice = round($row['list_price']);
                    $listprice += 0;
                    $discountprice = round($row['discount_price']);
                    $discountprice += 0;
                    $instock = $row['in_stock'];
                    $instock += 0;
                    $sourcedfrom = $row['sourced_from'];
                    $supplier = $row['info_source'];
                }
            }
    	    catch (Exception $e) {
    	        echo  "[Catalog Validation] Fatal: SQL Exception. $e->getMessage()\n"; 
    	        return(1);
    	    }
        
            if (($sourcedfrom == "India") && ($supplier == $reference_supplier)) {
                if ($listprice > 0) {
                    $percentdiff = round(abs($listprice - $reference_listprice)/$reference_listprice)*100;
                    if ($percentdiff >= 50) {
                        print "[Catalog Validation] [Severe] Actual list price [$listprice] differs from reference value [$reference_listprice] for book: $isbn, by more than 50%.\n"; 
                        $num_serious_errors++;
                    }
                    elseif (($percentdiff >= 5) && ($percentdiff < 50)) {
                        print "[Catalog Validation] [Warning] Actual list price [$listprice] differs from reference value [$reference_listprice] for '$isbn', by more than 5%.\n"; 
                        $num_errors++;
                    }
                }
            }

            if (($instock > 0) && (($listprice == 0) || ($discountprice == 0))) {
                print "[Catalog Validation] [Severe] In stock book '$isbn' has no discount or list price \n";
                $num_serious_errors++; 
            }

            if ($discountprice > $listprice) {
                 print "[Catalog Validation] [Severe] Discount price [$discountprice] is greater than list price [$listprice] for '$isbn'.\n"; 
                 $num_serious_errors++;
            } 

            if ($listprice > 0) {
                $percentdiscount = round(($listprice - $discountprice)/$listprice)*100;
                if ($percentdiscount > 35) {
                   print "[Catalog Validation] [Warning] Discount greater than 35% on book '$isbn'\n";
                   $num_errors++; 
                }
            }
        }
        print "[Catalog Validation] [Info] $num_errors errors and $num_serious_errors serious errors in $num_books books checked.\n";
        if (($num_errors > $threshold_errors) || ($num_serious_errors > $threshold_serious_errors)) {
            return (1);
        }
        return(0);
    }


    function checkBookCount($db, $fh){
        $queries = array();
        $thresholds = array();
        $queries[] = "select count(*) from books";
        $thresholds[] = 3000000;
        $queries[] = "select count(*) from books where sourced_from = 'India' and list_price is not null";
        $thresholds[] = 60000;
        for ($i = 0; $i < count($queries); $i++) {
            $query = $queries[$i];
            $threshold = $thresholds[$i];
            $response = 0;
            try {
                $result = mysqli_query($db, $query);
                if ($result && (mysqli_num_rows($result) > 0)) {
                    $rows = mysqli_fetch_row($result);
                    $response = $rows[0] + 0;
                }
            }
    	    catch (Exception $e) {
    	        echo  "[Catalog Validation] [Fatal] SQL Exception. $e->getMessage()\n"; 
    	        return(1);
    	    }
            if ($response < $threshold) {
                print "[Catalog Validation] [Severe] SQL query '" . $query . "' returned [$response], less than expected value [$threshold].\n";
                return(1);
            }
        }
    }

    $configfile = CONFIG_FILE;
	if (!file_exists($configfile)) {
		echo "[Catalog Validation] [Fatal] Configuration file is missing.\n";
		exit (1);
	}
    $textFile = BOOK_VALIDATION;
    if (!file_exists($textFile)){
        echo "[Catalog Validation] [Fatal] Reference file of books is missing.\n";
        exit (1);
    } 

	$config = getConfig($configfile);
	$host   = $config[database][server];
	$user   = $config[database][user];
	$psw    = $config[database][password];
	$db     = $config[database][ekkitab_db];
    try  {
	    $db = mysqli_connect($host,$user,$psw,$db);
    }
    catch (exception $e) {
        $db = null;
    }

    if ($db == null) { 
       echo "[Catalog Validation] [Fatal] Could not connect to database.";
       exit(1);
    }

    $fh = fopen($textFile,"r");

    if ($fh == null) { 
       echo "[Catalog Validation] [Fatal] Could not open reference file of books.";
       exit(1);
    }

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
    mysqli_close($db);

    if ($exitvalue == 0) {
       echo "[Catalog Validation] [Passed] Number of checks run: " . count($checks) . "\n";
    }
    exit($exitvalue);

?>
