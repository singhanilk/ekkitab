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
ini_set(“memory_limit”,"1024M");

ini_set(include_path, ${include_path}.PATH_SEPARATOR.EKKITAB_HOME."/"."config");
include("ekkitab.php");

function getConfig($file) {
   $config	= parse_ini_file($file, true);
   if (! $config) {
      echo "Configuration file missing. $file\n";
      exit (1); 
   }
   return $config;
}

if($argc < 2) {
    echo "Usage: $argv[0] <stocklist>\n";
	exit (1);
}

$stocklistfile    = $argv[1];

$config = getConfig(STOCK_PROCESS_CONFIG_FILE);

$catalogfile      = $config['penguin']['catalog'];
$missingisbnfile  = $config['penguin']['missingisbns'];
$pricefile        = $config['penguin']['pricefile'];

echo "Catalog file: $catalogfile\n";
echo "Missing ISBN file: $missingisbnfile\n";
echo "Price file: $pricefile\n";

$books = array();

$fhandle = fopen($catalogfile,"r");
if (!$fhandle){
    echo("Could not open data file: " . $catalogfile . "\n");
    exit(1);
}

while($contents = fgets($fhandle)){
   if ($contents[0] == '#'){
      continue;
   }
   $fields = explode("\t", $contents);
   $isbn = $fields[0]; 
   $availability = $fields[3];
   if (isset($books[$isbn])){
      echo "Duplicate ISBN $isbn found in catalog file.\n";
   }
   else{
	  $books[$isbn] = $availability;
   }
}

/*open stocklist.txt and print missing ISBN */

$fhandle = fopen($stocklistfile,"r");
if (!$fhandle){
    echo("Could not open data file: " . $stocklistfile . "\n");
    exit(1);
}

$fhandle2 = fopen($missingisbnfile, "w");
if (!$fhandle2){
    echo("Could not open file to write missing isbns: " . $missingisbnfile . "\n");
    exit(1);
}
fprintf($fhandle2, "# ISBN\tTITLE\tAUTHOR\n");

$fhandle3 = fopen($pricefile, "w");
if (!$fhandle3){
    echo("Could not open file to write price information: " . $pricefile . "\n");
    exit(1);
}
fprintf($fhandle3, "# ISBN\tCURRENCY\tLIST-PRICE\tAVAILABILITY\n");

while($contents = fgets($fhandle)){
    $contents = str_replace("\n", "", $contents);
    $fields = explode("\t", $contents);
    $isbn = $fields[0];
    $title = $fields[5];
    $author = $fields[6];
    $currency = $fields[2];
    $listPrice = $fields[1];
    $availability = $fields[3];

    if (!isset($books[$isbn])) { // not in catalog
      fprintf($fhandle2, "%s\t%s\t%s\n", $isbn, $title, $author);
    }
    else {
      fprintf($fhandle3, "%s\t%s\t%s\t%s\n", $isbn, $currency, $listPrice, $availability);
    }
}

fclose($fhandle);
fclose($fhandle2);
fclose($fhandle3);

?>
