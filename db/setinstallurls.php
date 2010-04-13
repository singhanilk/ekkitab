<?php
    $EKKITAB_HOME=getenv("EKKITAB_HOME");
    if (strlen($EKKITAB_HOME) == 0) {
        echo "EKKITAB_HOME is not defined...Exiting.\n";
        exit(1);
    }
    else {
        define(EKKITAB_HOME, $EKKITAB_HOME); 
    }
    error_reporting(E_ALL  & ~E_NOTICE);
    ini_set("display_errors", 1); 
    ini_set(include_path, ${include_path}.PATH_SEPARATOR.EKKITAB_HOME."/"."config");
    include("ekkitab.php");

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

    $config = getConfig(CONFIG_FILE);
	$host   = $config[database][server];
	$user   = $config[database][user];
	$psw    = $config[database][password];

    if ($argc != 2) {
        echo "Usage: $argv[0] <base url>\n";
        exit(0);
    }
    try  {
	    $db     = mysqli_connect($host,$user,$psw,"ekkitab_books");
    }
    catch (exception $e) {
        echo "Database connection failed. " .  $e->getmessage() . "\n";
        exit(1);
    }

    $query = "insert into core_config_data (scope, scope_id, path, value) values ('default', 0, 'web/unsecure/base_url', '" . $argv[1] . "')" . " on duplicate key update value = '" . $argv[1] . "'";
    try {
	    $result = mysqli_query($db, $query);
        if (!$result) {
            echo "Update of unsecure base url failed. \n";
            exit(1);
        }
    }
    catch (exception $e) {
        echo "Update of unsecure base url failed. " . $e->getmessage() . "\n";
        exit(1);
    } 

    $query = "insert into core_config_data (scope, scope_id, path, value) values ('default', 0, 'web/secure/base_url', '" . $argv[1] . "')" . " on duplicate key update value = '" . $argv[1] . "'";

    try {
	    $result = mysqli_query($db, $query);
        if (!$result) {
            echo "Update of secure base url failed. \n";
            exit(1);
        }
    }
    catch (exception $e) {
        echo "Update of secure base url failed. " . $e->getmessage() . "\n";
        exit(1);
    } 

    $query = "insert into core_config_data (scope, scope_id, path, value) values ('default', 0, 'billdesk/wps/return_url', '" . $argv[1] . "billdesk/standard/response" . "')" . " on duplicate key update value = '" . $argv[1] . "billdesk/standard/response" . "'";

    try {
	    $result = mysqli_query($db, $query);
        if (!$result) {
            echo "Update of billdesk return url failed. \n";
            exit(1);
        }
    }
    catch (exception $e) {
        echo "Update of billdesk return url failed. " . $e->getmessage() . "\n";
        exit(1);
    } 

    $query = "insert into core_config_data (scope, scope_id, path, value) values ('default', 0, 'ccav/wps/return_url', '" . $argv[1] . "ccav/standard/ccavresponse" . "')" . " on duplicate key update value = '" . $argv[1] . "ccav/standard/ccavresponse" . "'";

    try {
	    $result = mysqli_query($db, $query);
        if (!$result) {
            echo "Update of billdesk return url failed. \n";
            exit(1);
        }
    }
    catch (exception $e) {
        echo "Update of billdesk return url failed. " . $e->getmessage() . "\n";
        exit(1);
    } 

    echo "Installation specific urls set correctly.\n";

    mysqli_close($db);
?>

