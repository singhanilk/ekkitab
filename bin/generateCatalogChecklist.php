<?php
  error_reporting(E_ALL  & ~E_NOTICE);
  ini_set(“memory_limit”,"1024M");
  ini_set("display_errors", 1); 
  $ekkitabhome = getenv("EKKITAB_HOME");
  define(CATALOG_FILE, $ekkitabhome . "/publishers/Penguin/catalog.txt" );
      if(empty($ekkitabhome)){
	echo "EKKITAB_HOME is not set. Cannot continue.\n";
	exit(1);
      }
      if($argc < 4){
	echo "Usage: $argv[0] <stocklist> <outputmissinglist> <outputpricelist>\n";
	exit (1);
      }


  $books = array();
/* open catalog.txt */
  $fhandle = fopen(CATALOG_FILE,"r");

  if (!$fhandle){
        echo("Could not open data file");
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
      echo "Duplicate ISBN $isbn \n";
	}
	else{
	  $books[$isbn] = $availability;
	}
      }
/*open stocklist.txt and print missing ISBN */
  $fhandle = fopen($argv[1],"r");

  if (!$fhandle){
         echo("Could not open data file: $argv[1]");
         exit(1);
       }
  while($contents = fgets($fhandle)){
      $fields = explode("\t", $contents);
      $isbn = $fields[0];
      $title = $fields[5];
      $author = $fields[6];
      $currency = $fields[2];
      $listPrice = $fields[1];
      $availability = $fields[3];
      if (!isset($books[$isbn])){
      $unknownISBNoutfile = fopen($argv[2],"a") or die("cannot open file");
      $stringISBN = "$isbn\t $title \t $author";
      fwrite($unknownISBNoutfile, $stringISBN);
  }
      else{
      $unknownISBNoutfile = fopen($argv[3],"a") or die("cannot open file");
      $stringISBN = "$isbn\t $currency \t $listPrice \t $availability \n";
      fwrite($unknownISBNoutfile, $stringISBN);
      }
}


?>