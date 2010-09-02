<?php

require_once("simple_html_dom.php");

global $ekkitabhome;

function hachette_getDetails($config, $isbnno, $title, $author ) {

$str = '<div class="info_box"><a href="/publishing_grand-central-publishing.aspx"><img src="/_assets/publishers/logos/grand_central.gif" alt="Grand Central Publishing" /></a> <dl> <dt>Category:</dt> <dd>HEALTH & FITNESS, TECHNOLOGY</dd> <dt>Format:</dt> <dd>ELECTRONIC BOOK</dd> <dt>Subformat:</dt> <dd>GEMSTAR</dd> <dt>Publish Date:</dt> <dd>7/31/2007</dd> <dt>Price:</dt> <dd>&#36;9.99/&#36;11.99</dd> <dt>ISBN:</dt> <dd>9780446508087</dd> <dt>Pages:</dt> <dd>0</dd> </dl> <div class="clear"></div></div>'; 

  $hachetteURL = $config["hachette"]["url"];
  $hachetteURL .= $isbnno . ".htm";
  $books = Array();

  // Get the web page for the Hachette publisher
  //$webPageResult = file_get_html($hachetteURL);
  $webPageResult = str_get_html($str);
  $infoBoxDiv = $webPageResult->find("div[class=info_box]", 0);
  foreach($infoBoxDiv->children() as $node) {
    if ( $node->tag == "a") {
        
    }
  }
  return $books; 
}

/* 
** The main start function which will be called 
*/
function hachette_start($argc, $argv) {
   global $ekkitabhome;

   $ekkitabhome = getenv("EKKITAB_HOME");
   if (empty($ekkitabhome)) {
    echo "EKKITAB_HOME is not set. Cannot continue.\n";
    exit(1);
   }

 	 if ($argc < 4) {
       echo "Usage: $argv[0] <isbn number> <title> <author>\n";
       exit(1);
    }

 	  $isbnno = $argv[1];          
 	  $title = $argv[2];          
 	  $author = $argv[3];          
    $config = parse_ini_file('updatecatalog.ini', true); 

  	try {
  		$books = hachette_getDetails($config, $isbnno, $title, $author);
  	} catch (Exception $e) {
    	echo "Data fetch exception: " . $e->getMessage() . "\n";
      exit(1);
      $books = array();
  	}
   return($books);
}

hachette_start($argc, $argv);

?>

