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
set_include_path(get_include_path() . PATH_SEPARATOR . $EKKITAB_HOME . "/bin");
include "imagehash.php"; 

if ($argc < 3) {
    echo "Require publisher. Usage: " . $argv[0] . " <publisher> <output file>\n";
    exit(1);
}

$inputfile1  = "/mnt4/publisherdata/indiacatalog/" . $argv[1] . ".txt";
$outputFile  = $argv[2];

$fh1 = fopen($inputfile1, "r");
if (!$fh1) {
    echo "Could not open input file: $inputfile1 \n";
    exit(1);
}

$fh2 = fopen($outputFile, "w");
if (!$fh2) {
    echo "Could not open output file: $outputFile \n";
    exit(1);
}

$linecount = 0;
$found=0;
$notfound=0;
$ignored=0;
while ($line1 = fgets($fh1)) {
  $linecount++;
  if ($line1[0] == '#') {
      $ignored++;
      continue;
  }
  $fields = explode("\t", $line1);
  $isbn = $fields[0];
  $isbn = trim($isbn);
  $imagepath = "/mnt3/magento-product-images/" . getHashedPath($isbn.".jpg");

  if (file_exists($imagepath)) {
     $found++;
  }
  else {
     $notfound++;     
     fwrite($fh2, $isbn."\n");
  }
  if (($linecount % 1000) == 0) {
     echo "Completed testing $linecount rows.\n";
  }
}
fclose($fh1);
fclose($fh2);
echo "Total: $linecount, Found: $found, Not found: $notfound, Ignored: $ignored\n";
?>
