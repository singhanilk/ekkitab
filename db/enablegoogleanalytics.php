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

    try  {
	    $db     = mysqli_connect($host,$user,$psw,"ekkitab_books");
    }
    catch (exception $e) {
        echo "Database connection failed. " .  $e->getmessage() . "\n";
        exit(1);
    }

    if (!isset($config['google']['analytics_id'])) {
        echo "Google id not set in configuration file. Cannot continue.\n";
        mysqli_close($db);
        exit(1);
    }

    $google_id = $config['google']['analytics_id'];

    $query = "insert into core_config_data (scope, scope_id, path, value) values " .
             "('default', 0, 'google/analytics/active', '1') " .
             "on duplicate key update value = '1'" ;

    try {
	    $result = mysqli_query($db, $query);
        if (!$result) {
            echo "Enabling of google analytics failed. \n";
            mysqli_close($db);
            exit(1);
        }
    }
    catch (exception $e) {
        echo "Enabling of google analytics failed. " . $e->getmessage() . "\n";
        mysqli_close($db);
        exit(1);
    } 

    $query = "insert into core_config_data (scope, scope_id, path, value) values " .
             "('default', 0, 'google/analytics/account', '$google_id') " .
             "on duplicate key update value = '$google_id'" ;

    try {
	    $result = mysqli_query($db, $query);
        if (!$result) {
            echo "Enabling of google analytics failed. \n";
            mysqli_close($db);
            exit(1);
        }
    }
    catch (exception $e) {
        echo "Enabling of google analytics failed. " . $e->getmessage() . "\n";
        mysqli_close($db);
        exit(1);
    } 

    echo "Google analytics enabled correctly.\n";

    mysqli_close($db);
?>

