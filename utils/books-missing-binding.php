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

function missingBindingInfo($db, $filePrefix, $fileExt){
    $query = "SELECT isbn,binding,DATE_FORMAT(publishing_date, '%e %b %Y') from `books` where binding='' OR binding is null";
	$ISBNS_PER_FILE=1000;
    $counter=1;
    $fileNo=1;
	$file= $filePrefix."_".$fileNo.".".$fileExt;
	$fh = fopen($file, "w"); 
	if (!$fh) {
		fatal("Could not open file: $file");
	}
	try {
		$result = mysqli_query($db, $query);
		fwrite($fh,"ISBNS,BINDING, PUBLISHING_DATE\n");
		if ($result && (mysqli_num_rows($result) > 0)) {
			while( $row=mysqli_fetch_row($result)){
				fwrite($fh,"'".$row[0]."',".$row[1].",".$row[2]);
				fwrite($fh,"\n");
				$counter++;
				if($counter > $ISBNS_PER_FILE){
					fclose($fh);
					$fileNo+=1;
					$file="missing_data_".$fileNo.".".$fileExt;
					$fh = fopen($file, "w"); 
					if (!$fh) {
						fatal("Could not open file: $file");
					}
					fwrite($fh,"ISBNS,BINDING, PUBLISHING_DATE\n");
					$counter=1;
				}
		   }
		   fclose($fh);

		}
    }
	catch (Exception $e) {
	   echo  "[Books Missing Binding Information] SQL Exception. $e->getMessage()\n"; 
	   return(1);
	}
    return (0);
}

if ($argc <= 2) {
	echo "No arguments. Please provide the output file prefix and extension (csv/xls/txt only) .\n";
	echo "Usage: ".$argv[0]."  <output file prefix> <output file extension> \n";
	exit(1);
} else{
	$filePrefix = trim($argv[1]);
	$fileExt = trim($argv[2]);
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
	missingBindingInfo($db,$filePrefix,$fileExt);
}
catch (Exception $e) {
	echo "Exception encountered during processing. " . $e->getmessage() . "\n"; 
	mysqli_close($db);
	exit(1);
}
mysqli_close($db);
?>
