<?php
   error_reporting(E_ALL  & ~E_NOTICE);
   ini_set("display_errors", 1); 

   include("importbooks_config.php");
   require_once(LOG4PHP_DIR . '/LoggerManager.php');
   ini_set(include_path, ${include_path}.":".EKKITAB_HOME."/"."bin");

   // global logger
    $logger =& LoggerManager::getLogger("loadpricestock");

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
       $config   = parse_ini_file($file, true);
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
       $ref_db           = $config[database][ref_db];

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

       $updatequery = "update";
       foreach ($bookprice as $field => $value){

          $updatequery  .= " $field = $value," ;
		  $insertfield  .= "$field,";
		  $insertvalues .= "$value,";

       }

      $updatequery   = substr($updatequery, 0, strrpos($updatequery, ","));
	  $insertfield   = substr($insertfield, 0, strrpos($insertfield, ","));
	  $insertvalues  = substr($insertvalues, 0, strrpos($insertvalues, ","));
    
	  $query = "insert into book_stock_and_prices (ISBN,$insertfield) values ('$isbn',$insertvalues) on duplicate key $updatequery";
      
	  return ($query);
    }

   /** 
    *  Get the discount computation value from the reference database.  
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
     * This function will return all the currency conversion rates. 
     */
    function getCurrency($db){
        $currency = array();
        $query    = "select * from ek_currency_conversion"; 
        try {
            $result = mysqli_query($db, $query);
            if(!($row = mysqli_fetch_array($result))){
                throw new exception("Failed to get currency list.");
            }
            else {
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
     * Main function.
     */
    function start($argc, $argv) {
    
        if ($argc == 1) {
           echo "Usage: $argv[0] <Data Source> <Data File> \n";
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
        $ignored       = 0;
        $startTime = (float) array_sum(explode(' ', microtime()));
    
        $currency      = getCurrency($db);
        $parser        = new parser;
        $discount_info = getDiscount($db, $infosource);
    
        while ($line = fgets($fh)) {

            $bookprice = $parser->getStockPrice($line);
            if ($bookprice == null) {
                $ignored++;
                continue;
            }
            $bookprocessed++;
            $isbn = $bookprice['ISBN'];
            unset($bookprice['ISBN']);

            //convert the list price to INR
            $b = $currency[str_replace("'", "", $bookprice['CURRENCY'])];
			$bookprice['LIST_PRICE'] = $bookprice['LIST_PRICE'] * $b;
			

            // discount computation
            $tmpPrice = $bookprice['LIST_PRICE'] * ( $bookprice['SUPPLIERS_DISCOUNT'] / 100);
            $bookprice['SUPPLIERS_PRICE'] = $bookprice['LIST_PRICE'] - $tmpPrice;

            // Our discount to the customer.
            $tmpPrice = $tmpPrice * ( $discount_info / 100);

            $bookprice['DISCOUNT_PRICE'] = round($bookprice['LIST_PRICE'] - $tmpPrice);

            //createing Update fields
            
            $bookprice['UPDATED']   = 1;
            $query = createUpdateSql($bookprice, $isbn);
         
            try{
                $result = mysqli_query($db, $query);
                if (!$result){
                    throw new exception("Failed to Update the Prices #$query.");
                }
                $updatedBooks++;
             }
             catch(exception $e) {
                warn($e->getmessage());
                warn("Book with ISBN number $isbn did not get updated with price and/or stock information.");
                $failedBooks++;
             }

             if ($bookprocessed % 10000 == 0){
                $endTime = (float) array_sum(explode(' ', microtime()));
                $endTime = ($endTime - $startTime)/60;
                debug(" Processed: $bookprocessed, Updated: $updatedBooks, Ignored: $ignored, Failed: $failedBooks in time: ". sprintf("%.2f minutes.",$endTime) . "\n");
             }
         }

         $endTime = (float) array_sum(explode(' ', microtime()));
         $endTime = ($endTime - $startTime)/60;
         debug(" Processed: $bookprocessed, Updated: $updatedBooks, Failed: $failedBooks in time: ". sprintf("%.2f minutes.",$endTime) . "\n");
         fclose($fh);
         mysqli_close($db);
    }
    $logger->info("Process started at " . date("d-M-Y G:i:sa"));
    start($argc, $argv);
    $logger->info("Process ended at " . date("d-M-Y G:i:sa"));

?>
