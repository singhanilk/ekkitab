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

    $configinifile = "$EKKITAB_HOME/config/ekkitab.ini" ;
    if (!file_exists($configinifile)) {
        echo "Fatal: Configuration file is missing.\n";
        exit (1);
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

    function getDbVersion($db) {
        $query = "select version from ekkitab_db_version";
        $dbversion = -1;
        try {
	        $result = mysqli_query($db, $query);
            if ($result && (mysqli_num_rows($result) > 0)) {
                $row = mysqli_fetch_array($result);
                $dbversion = $row[0];
            }
        }
        catch (exception $e) {
        } 
        return $dbversion;
    }

    $config = getConfig($configinifile);
	$host   = $config[database][server];
	$user   = $config[database][user];
	$psw    = $config[database][password];

    $dbversion = -1;
    $db = null;

    $ferr = fopen("php://stderr", "w");
    if (!$ferr) {
        echo "Fatal: Cannot open standard error output.\n";
        exit (1);
    }

    try  {
	    $db     = mysqli_connect($host,$user,$psw,"ekkitab_books");
    }
    catch (exception $e) {
        $db = null;
    }

    if ($db == null) { 
       fprintf($ferr,  "Fatal: Could not connect to database.");
       exit(1);
    }

    $dbversion = getDbVersion($db);
    
    if ($dbversion < 0) {
        // Create the version table in the database.
        $queries = array();
        $queries[] = "create table if not exists ekkitab_db_version(`version` int not null) engine=InnoDB default charset=utf8;";
        $queries[] = "delete from ekkitab_db_version";
        $queries[] = "insert into ekkitab_db_version (version) values ('0')";
 
        fprintf($ferr, "Initializing database version table.\n");
        foreach ($queries as $query) {
            try {
	           $result = mysqli_query($db, $query);
               if (!$result) {
                  fprintf($ferr, "Fatal: Could not correctly run sql script to initialize database version table.\n"); 
                  fprintf($ferr, "SQL: $query\n"); 
                  fprintf($ferr, "SQL Error: " . mysqli_error($db) . "\n"); 
                  exit(1);
               }
            }
            catch (Exception $e) {
               fprintf($ferr, "Fatal: SQL Exception. $e->getMessage()\n"); 
               exit(1);
            }
        }
        $dbversion = getDbVersion($db);
    }
    fclose($ferr); 
    echo "$dbversion";
    mysqli_close($db);
    exit(0);

?>

