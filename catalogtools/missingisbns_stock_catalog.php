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

/* missingisbns_stock_to_catalog is the program which converts all the missing isbns into catalog information 
** A book is valid if the isbn and the title are present. The author can be null.
** Reason for creating this code - After running missing isbns againts book google, we are not getting any more data.
**  
** Version - 0.1 Prasad Potula
*/

include "common_catalog_functions.php";

$missingIsbnDirectory = "/mnt4/publisherdata/indiacatalog/missingisbns";
$catalogOutputDirectory = "/tmp/missingisbns/catalog/";

// The directory where to look for missing isbns files.
function missingisbns_stock_catalog_start($argc, $argv) {
  global $missingIsbnDirectory;
  global $catalogOutputDirectory;
  global $FIELD_SEPARATOR;
  $db = null;
  $config = null;
  $missingIsbnList = Array();

  if ($argc < 3) {
       echo "Usage: $argv[0] <config file> <path for missing isbn files>\n";
       exit(1);
  }
  // Parse the config file passed.
  if ( isset($argv[1])) { 
     $config = parse_ini_file($argv[1], true); 
     if ( $config = null ) {
       echo "Usage: $argv[0] <config file> <path for missing isbn files>\n";
       exit(1);
     }
  } 
  // Check the missing isbns directory passed.
  if ( isset($argv[2])) { 
    $missingIsbnDirectory = $argv[2];
    $handle = opendir($missingIsbnDirectory);
    if ( !$handle) { 
       echo "Usage: $argv[0] <config file> <path for missing isbn files>\n";
       exit(1);
    } 
  }
 // Check if the output directory exists else create the same.
   if (!is_dir($catalogOutputDirectory)) {
     echo "Error: Catalog Output Directory $catalogOutputDirectory  missing\n";
     echo "Usage: $argv[0] <config file> <path for missing isbn files>\n";
     exit(1);
   }
  // Read all the missing isbns files into an array.
  while (false !== ($file = readdir($handle))) {
    if ($file != "." && $file != "..") {
     $filename = $missingIsbnDirectory . "/". $file;
     if(is_file($filename)){
       $supplier = explode("-", $file);
       if ( validSupplier($supplier[0])){
         $missingIsbnList[$supplier[0]] = $filename;
       }
       }
    }
  }
  closedir($handle);

  // Process all the missing isbn files and create a catalog for them.
  $missingIsbnFile = null;
  $catalogFile = null;
  $book = null;
  foreach($missingIsbnList as $supplier=>$missingIsbnFileName ){
     $missingIsbnFile = fopen($missingIsbnFileName, "r") or die ("Cannot open" . $missingIsbnFileName . "\n");
     $catalogFile = fopen($catalogOutputDirectory.$supplier.".txt", "w") or die ("Cannot open catalog file\n");
     //Ignore the first line of missing isbn files as it is a header.
     $tmpString = fgets($missingIsbnFile);   
     while (!feof($missingIsbnFile)){ 
      $tmpString = fgets($missingIsbnFile);   
      if ( $tmpString == null ) { break; }
      // Remove new lines from the tmpString if any.
      $tmpString = preg_replace("/\n/", "", $tmpString);
      $values = explode($FIELD_SEPARATOR, $tmpString);
      $book = Array();
      $book['ISBN'] = trim($values[0]);
      $book['TITLE'] = trim($values[1]);
      $book['AUTHOR'] = trim($values[2]);
      $book = validMissingIsbnBook($book); 
      $book = fillDefaultCatalogValues($book);
      print_r($book);
      if ( $book != null ) {
        writeBookToCatalog($book, $catalogFile);
      }
     } // reading all the lines from the missing isbn file.
    fclose($missingIsbnFile);
    fclose($catalogFile);
   }// for each missing isbn file.
 
  // Check import of each and every catalog which has been written.
     
}

missingisbns_stock_catalog_start($argc, $argv);

?>
