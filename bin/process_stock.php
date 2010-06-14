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
                fprintf($fh2, "# ISBN\tCURRENCY\tLIST-PRICE\tAVAILABILITY\n");

                $fh = fopen($directory . "/" . $file,"r");
                if (!$fh){
                    echo("Could not open data file: " . $file . "\n");
                    exit(1);
                }
                while($contents = fgets($fh)) {
                    $contents = str_replace("\n", "", $contents);
                    $fields = explode("\t", $contents);
                    $isbn = $fields[0];
                    $title = $fields[5];
                    $author = $fields[6];
                    $currency = $fields[2];
                    $listPrice = $fields[1];
                    $availability = $fields[3];

                    if (!isset($books[$isbn])) { // not in catalog
                        fprintf($fh1, "%s\t%s\t%s\n", $isbn, $title, $author);
                    }
                    fprintf($fh2, "%s\t%s\t%s\t%s\t%s\n", $isbn, $currency, $listPrice, $availability, $plugin);
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
