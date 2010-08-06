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


function getConfig($file) {
    $config = parse_ini_file($file, true);
    if (! $config) {
        print("[Books Missing Binding Information] [Fatal] Configuration file missing or incorrect."); 
        exit(1);
    }
    return $config;
}

function missingBindingInfo($db, $fh){
    $query = "SELECT isbn from `books` where binding='' OR binding is null";
    try {
       $result = mysqli_query($db, $query);
		fwrite($fh,"ISBNS\n");
	   if ($result && (mysqli_num_rows($result) > 0)) {
			while( $row=mysqli_fetch_row($result)){
				fwrite($fh,"'".$row[0]."'");
				fwrite($fh,"\n");
			}
       }
    }
	catch (Exception $e) {
	   echo  "[Books Missing Binding Information] SQL Exception. $e->getMessage()\n"; 
	   return(1);
	}
    return (0);
}

if ($argc <= 1) {
	echo "No arguments. Please provide the output file name (csv/xls/txt only) .\n";
	echo "Usage: ".$argv[0]."  <output file path> \n";
	exit(1);
} else{
	$file = $argv[1];
}

$fh = fopen($file, "w"); 
if (!$fh) {
	fatal("Could not open file: $file");
}

$configinifile = CONFIG_FILE;
if (!file_exists($configinifile)) {
	echo "Configuration file is missing.\n";
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
   fprintf($ferr,  "[Books Missing Binding Information] [Fatal] Could not connect to database.");
   exit(1);
}
try {
	missingBindingInfo($db,$fh);
}
catch (Exception $e) {
	echo "Exception encountered during processing. " . $e->getmessage() . "\n"; 
	fclose($fh);
	mysqli_close($db);
	exit(1);
}
fclose($fh);
mysqli_close($db);
?>
