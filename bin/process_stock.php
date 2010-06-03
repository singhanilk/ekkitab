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

if($argc < 5) {
    echo "Usage: $argv[0] <stocklist> <catalog> <outputmissinglist> <outputpricelist>\n";
	exit (1);
}

$stocklistfile    = $argv[1];
$catalogfile      = $argv[2];
$missingisbnfile  = $argv[3];
$pricefile        = $argv[4];

$books = array();
/* open catalog.txt */

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
    $fields = explode("\t", $contents);
    $isbn = $fields[0];
    $title = $fields[5];
    $author = $fields[6];
    $currency = $fields[2];
    $listPrice = $fields[1];
    $availability = $fields[3];

    if (!isset($books[$isbn])) { // not in catalog
      fprintf($fhandle2, "%s\t%s\t%s\n" $isbn, $title, $author);
    }
    else {
      fprintf($fhandle3, "%s\t%s\t%s\t%s\n" $isbn, $currency, $listPrice, $availability);
    }
}

fclose($fhandle);
fclose($fhandle2);
fclose($fhandle3);

?>
