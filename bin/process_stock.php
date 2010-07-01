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

function getBookPrices($file) {

   $books = array();

   if ($file == "") {
      return ($books);
   }
   $fh = fopen($file,"r");
   if (!$fh) {
     return ($books); 
   }

   while($contents = fgets($fh)) {
      if (preg_match("/^#/", trim($contents))) {
         continue;
      }
      $fields = explode("\t", $contents);
      $isbn = $fields[0];
      $currency = $fields[2];
      $listPrice = $fields[1];
      if (isset($books[$isbn])) {
        // Rule: If currencies are different, go with Indian currency.
        // Rule: If currencies are both Indian, go with higher value.
        $book = $books[$isbn];
        if ($book['currency'] == $currency) {
            if ($listPrice < $book['list_price']) {
                $book['list_price'] = $listPrice;
            }
        }
        else {
            if ($currency == "I") {
                $book['list_price'] = $listPrice;
                $book['currency'] = $currency;
            }
            elseif ($book['currency'] != "I") {
                $book['discard'] = "true";
            }
        }
        $books[$isbn] = $book;
      }
      else {
        $book = array();
        $book['list_price'] = $listPrice;
        $book['currency'] = $currency;
        $books[$isbn] = $book;
      } 
   }
   fclose($fh);
   return $books;
}

function process($directory, $outputdir, $config, $books) {

   if (!is_dir($directory))
       return;

   echo "Processing directory: $directory\n";
   $count = 0;

   $dir = opendir($directory);
   if (! $dir) {
       echo "Failed to open source directory. $directory\n";
       return;
   }

   while ($file = readdir($dir)) {
        if (($file == ".") || ($file == ".."))
	        continue;
		if (is_dir($directory."/".$file)) {
            echo "Found subdirectory $file. Ignoring....\n";
		    // process($directory."/".$file, $config, $books); 
		}
        else {
            if ((strlen($file) > 4) && (substr($file, strlen($file) - 4, 4) == ".txt")) {
                
                $bookprices = getBookPrices($directory . "/" . $file);

                $plugin = substr($file, 0, strpos($file, "-"));
                $missingisbnfile  = $outputdir . "/MissingISBNs/" . $plugin . "-" ."missingisbns.txt";
                $pricefile        = $outputdir . "/Prices/" . $plugin . "-" ."prices.txt";
                echo "Missing ISBN file: $missingisbnfile\n";
                echo "Price file: $pricefile\n";
                $fh1 = fopen($missingisbnfile, "w");
                if (!$fh1){
                    echo("Could not open file to write missing isbns: " . $missingisbnfile . "\n");
                    exit(1);
                }
                fprintf($fh1, "# ISBN\tTITLE\tAUTHOR\n");

                $fh2 = fopen($pricefile, "w");
                if (!$fh2){
                    echo("Could not open file to write price information: " . $pricefile . "\n");
                    exit(1);
                }
                fprintf($fh2, "# ISBN\tCURRENCY\tLIST-PRICE\tAVAILABILITY\tDISTRIBUTOR\n");

                $fh = fopen($directory . "/" . $file,"r");
                if (!$fh){
                    echo("Could not open data file: " . $file . "\n");
                    exit(1);
                }
                while($contents = fgets($fh)) {
                    if (preg_match("/^#/", trim($contents))) {
                        continue;
                    }
                    $contents = str_replace("\n", "", $contents);
                    $fields = explode("\t", $contents);
                    $isbn = $fields[0];
                    $title = $fields[5];
                    $author = $fields[6];
                    $currency = $bookprices[$isbn]['currency'];
                    $listPrice = $bookprices[$isbn]['list_price'];
                    $availability = $fields[3];

                    if (!isset($books[$isbn])) { // not in catalog
                        fprintf($fh1, "%s\t%s\t%s\n", $isbn, $title, $author);
                    }
                    if (!isset($bookprices[$isbn]['discard'])) {
                        fprintf($fh2, "%s\t%s\t%s\t%s\t%s\n", $isbn, $currency, $listPrice, $availability, $plugin);
                    }
                }

                foreach ($bookprices as $k => $b) {
                    if (isset($b['discard'])) {
                        echo "Warning:  ISBN $k is ignored because of duplicate entries in file: $file [processed by $plugin]\n";
                    }
                }

                fclose($fh);
                fclose($fh1);
                fclose($fh2);
            }
        }
   }
}

if($argc < 2) {
    echo "Usage: $argv[0] <stocklist directory>\n";
	exit (1);
}
$stocklistdir = $argv[1];

$config = getConfig(STOCK_PROCESS_CONFIG_FILE);

if (!isset($config['general']['catalog'])) {
    echo "Catalog file is not defined in the configuration. Cannot continue.\n";
    exit(1);
}
if (!isset($config['general']['outputdir'])) {
    echo "Output directory is not defined in the configuration. Cannot continue.\n";
    exit(1);
}

$catalogfile  = $config['general']['catalog'];
$targetdir = $config['general']['outputdir'];

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
   if (isset($books[$isbn])){
      echo "Duplicate ISBN $isbn found in catalog file.\n";
   }
   else{
	  $books[$isbn] = 1;
   }
}
fclose($fhandle);
process($stocklistdir, $targetdir, $config, $books);

?>
