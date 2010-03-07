<?php
    error_reporting(E_ALL  & ~E_NOTICE);
    ini_set("display_errors", 1); 
    if ($argc != 5) {
        echo "Usage: $argv[0] <host> <username> <password> <base url>\n";
        exit(0);
    }
    try  {
	    $db     = mysqli_connect($argv[1],$argv[2],$argv[3],"ekkitab_books");
    }
    catch (exception $e) {
        echo "Database connection failed. " .  $e->getmessage() . "\n";
        exit(1);
    }

    $query = "insert into core_config_data (scope, scope_id, path, value) values ('default', 0, 'web/unsecure/base_url', '" . $argv[4] . "')";
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

    $query = "insert into core_config_data (scope, scope_id, path, value) values ('default', 0, 'web/secure/base_url', '" . $argv[4] . "')";
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

    echo "Base urls set correctly.\n";

    mysqli_close($db);
?>

