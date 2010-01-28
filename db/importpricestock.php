<?php
error_reporting(E_ALL  & ~E_NOTICE);
ini_set("display_errors", 1); 



include("importbooks_config.php");
require_once(LOG4PHP_DIR . '/LoggerManager.php');
ini_set(include_path, ${include_path}.":".EKKITAB_HOME."/"."bin");

	// global logger
    $logger =& LoggerManager::getLogger("loadbooks");

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
    * Initialize reference database.
    */
    function initDatabases($config) {

        if (! $config) 
            return NULL;

	    $database_server = $config[database][server];
	    $database_user   = $config[database][user];
	    $database_psw    = $config[database][password];
	    $ref_db		     = $config[database][ref_db];

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

  function createUpdateSql($bookprice,$isbn){

    	$query = "update books set ";
	    foreach ($bookprice as $field => $value){

	       $query .= " $field = $value," ;

	    }
		$query  = $query = substr($query, 0, strrpos($query, ","));
        $query .= " where ISBN = '$isbn'"; 
	   return ($query);
}

   /** 
    * Set auto-commit mode for database.  
    */
  function getDiscount($db, $infosource){
	  $query = "select * from ek_discount_setting where INFO_SOURCE ='$infosource'";
	  $result = mysqli_query($db, $query);
	  if(!($row = mysqli_fetch_array($result))){
		  fatal("Could not get the discount Info from ref Db");
	  }
	  else{
		   return($row[2]);
	  }
  }
	
   /** 
    * Set auto-commit mode for database.  
    */
    function setAutoCommit($db, $mode = true) {
        global $logger;
        $query = "set autocommit = " . ($mode ? "1" : "0");
        $logger->info("Autocommit: $query");
        try {
	        $result = mysqli_query($db,$query);
            if (!$result)
                throw new exception("Failed to set requested autocommit mode. [$query]");
        }
        catch(exception $e) {
            fatal($e->getmessage());
        }
    }

/**
 * This function will return all the currency conversion rates. 
 */
 function getCurrency($db){
	 $currency = array();
	 $query    = "select * from ek_currency_conversion"; 
	 try{

	     $result = mysqli_query($db, $query);
		 if(!($row = mysqli_fetch_array($result))){
			 throw new exception("Failed to get currency list.");
		 }
		 else{
			  $type = $row[1];
			  $currency[$type] = $row[2];
		      while($row = mysqli_fetch_array($result)){
			     $type = $row[1];
			     $currency[$type] = $row[2];
		   }
		 }

	 }
	 
	 catch(exception $e) {
                       fatal($e->getmessage());
                       
	 }
	 return ($currency);

 }

/**
 * Checks if the books exist
 */
function checkBook($isbn, $db){
	$flag = 0;
	$query  = "select * from books where ISBN = '$isbn'";
	$result = mysqli_query($db, $query);
	if($row = mysqli_fetch_array($result)){
		
		$flag = 1;
		
	}
	
	return($flag);
}
 


/**
 * Main function.
 */
 function start($argc, $argv){
	 
	 if ($argc == 1) {
           echo "Usage: $argv[0] <Data Source> <Data File> ";
           exit(0);
        }
        if ($argc != 3) {
            fatal("No supplier name or import file.");
		}

        $fh = fopen($argv[2], "r"); 
        if (!$fh) {
           fatal("Could not open data file: $argv[2]");
        }
	 
	 
	 $infosource = $argv[1];
	 require_once(IMPORTBOOKS_CLASSDIR . "/" . $infosource . ".php");
	 $config = getConfig(IMPORTBOOKS_INI);
     $db = initDatabases($config);
	 if($db==NULL){
		 fatal("Failed to initialize databases");
	 }
	 $bookprocessed = 0;
	 $failedBooks   = 0;
	 $updatedBooks  = 0;
	 $startTime = (float) array_sum(explode(' ', microtime()));
	 
	 //setAutoCommit($db, false);
	 $currency      = getCurrency($db);
	 $parser        = new parser;
	 $discount_info = getDiscount($db, $infosource);
	 
	  while ($line = fgets($fh)){

		    $isbn = substr($line,1,13);
			$book_exist = checkBook($isbn, $db);
			if($book_exist == 1 ){
				$bookprocessed++;
				$bookprice = $parser->getStockPrice($line);
				//convert the list price to INR
				$bookprice['LIST_PRICE'] = $bookprice['LIST_PRICE'] * $b = $currency[str_replace("'", "", $bookprice['CURRENCY'])];
				//echo "list price $bookprice['LIST_PRICE']" ;
				// Discount computation
				$tmpPrice = $bookprice['LIST_PRICE'] * ( $book['SUPPLIERS_DISCOUNT'] / 100);
				$tmpPrice = $tmpPrice * ( $discount_info / 100);

				$bookprice['DISCOUNTED_PRICE'] = $bookprice['LIST_PRICE'] - $tmpPrice;
				//echo "discounted $bookprice['DISCOUNTED_PRICE'] \n";
				//createing Update fields
				$bookPrice['STOCK_UPDATED'] = 1;
				$bookPrice['PRICE_UPDATED'] = 1;
				$bookPrice['UPDATED_DATE']   = "curdate()";
				$query = createUpdateSql($bookprice, $isbn);
			
			    try{
                 
			     $result = mysqli_query($db, $query);
			     if (!$result){
				   throw new exception("Failed to Update the Prices #$query.");
			     }
				 //$result = mysqli_query($db, "commit");
				 $updatedBooks++;
			    }//End of try
			 
			    	    

			    catch(exception $e) {
                       warn($e->getmessage());
                       warn("Book with ISBN number $isbn did not get saved in the Ekkitab database.");
                       $failedBooks++;
                       $result = mysqli_query($db, "rollback");
                       if (! $result) 
                           warn("Failed to rollback on reference database.");
                 }
				 if($bookprocessed % 1000 == 0){
					 $endTime = (float) array_sum(explode(' ', microtime()));
					 $endTime = $endTime - $startTime;
					 Echo " The No of Book Processed: $bookprocessed, Updated: $updatedBooks, Failed: $fialedBooks in Time: $endTime";
				 }
			 

		   }// End of if block

			
			
	 
	  }//end of outer While

	fclose($fh);
	mysqli_close($db);
	
 }
$logger->info("Process started at " . date("d-M-Y G:i:sa"));
start($argc, $argv);
$logger->info("Process ended at " . date("d-M-Y G:i:sa"));

?>