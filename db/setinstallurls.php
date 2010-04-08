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

    $query = "insert into core_config_data (scope, scope_id, path, value) values ('default', 0, 'web/unsecure/base_url', '" . $argv[4] . "')" . " on duplicate key update value = '" . $argv[4] . "'";
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

    $query = "insert into core_config_data (scope, scope_id, path, value) values ('default', 0, 'web/secure/base_url', '" . $argv[4] . "')" . " on duplicate key update value = '" . $argv[4] . "'";

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

    $query = "insert into core_config_data (scope, scope_id, path, value) values ('default', 0, 'billdesk/wps/return_url', '" . $argv[4] . "billdesk/standard/response" . "')" . " on duplicate key update value = '" . $argv[4] . "billdesk/standard/response" . "'";

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

    $query = "insert into core_config_data (scope, scope_id, path, value) values ('default', 0, 'ccav/wps/return_url', '" . $argv[4] . "ccav/standard/ccavresponse" . "')" . " on duplicate key update value = '" . $argv[4] . "ccav/standard/ccavresponse" . "'";

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

