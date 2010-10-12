<?php
/*
	Generator for the global sections 
	Author - Prasad Potula 
	Date   - 07/September/2010
	Description 
  1. Sections.ini file has the list of files which should be read
  2. Individual ini files are ones which contain titles, descriptions and other attributes
  3. And the list of isbns
  Dependencies
   Configuration file updatecatalog.ini
*/

# The field separator is a tab
$EKKITAB_HOME= getenv("EKKITAB_HOME");
$configArray=null;
$globalSectionsXMLFile=null;
$globalSectionsINIFile=null;
$sectionsDirectory=null;
$debug=0;

function initDatabase($databaseConfigArray){
  $db = null;

  $database_server = $databaseConfigArray["database"]["server"];
  $database_user = $databaseConfigArray["database"]["user"];
  $database_password = $databaseConfigArray["database"]["password"];
  $ref_db = $databaseConfigArray["database"]["ref_db"];

  #print_r("Database server=" . $database_server . ":Database user=" . $database_user . "Database password=" . $database_password . "\n");
  try  {
    $db = mysqli_connect($database_server,$database_user,$database_password,$ref_db);
  } catch (exception $e) {
    fatal($e->getmessage());
  }
  $query = "set autocommit = 0";
  try {
   $result = mysqli_query($db,$query);
   if (!$result) {
     fatal("Failed to set autocommit mode.");
   }
  } catch(exception $e) {
    fatal($e->getmessage());
  }
 return $db;
}

function closeDatabase($db){
   mysqli_commit($db);
   mysqli_close($db);
}

function returnInStockBooks($db,$sectionName, $isbnArray){
   global $debug;
   $inStockIsbnArray = Array();

   foreach($isbnArray as $key => $value ) {
     $query = "select in_stock from books where isbn = '$key' and in_stock > 0 ";
     try {
       $result = mysqli_query($db,$query);
       //Add the isbn to the array only if the book is in stock.
       if ($result && mysqli_num_rows($result) > 0 ) { 
             $inStockIsbnArray[$key] = $value; 
       } else { 
        if ($debug) print "$key\t$sectionName\tNot Available\n"; 
       }
     } catch(exception $e) { 
       fatal($e->getmessage()); 
     }
   }
  return $inStockIsbnArray;
}

function updateDiscounts($db, $isbnArray){
   global $db;

   foreach($isbnArray as $key => $value ) {
     $tokens = explode(" ", $value);
     $discount = $tokens[0];
     if ( is_numeric($discount) and $discount > 0 ) {
       $discount = $discount/100;
       print "update books set discount_price = list_price - (list_price * $discount) where isbn = $key;\n"; 
     }
   }
}

function writeSections($db, $sectionsArray){
  global $globalSectionsXMLFile;
  global $globalSectionsINIFile;
  global $sectionsDirectory;
  global $configArray;

   $sectionXML='<SECTION id="SECTION_ID" title="SECTION_TITLE" displayOnHome="SECTION_DISPLAY_ON_HOME" activeFrom="SECTION_ACTIVE_FROM" activeTo="SECTION_ACTIVE_TO">
                 <DESCRIPTION>SECTION_DESCRIPTION</DESCRIPTION>
                 <HOMEPAGE_TEMPLATE_PATH>SECTION_HOMEPAGE_TEMPLATE_PATH</HOMEPAGE_TEMPLATE_PATH>
                 <BOOKSPAGE_TEMPLATE_PATH>SECTION_BOOKSPAGE_TEMPLATE_PATH</BOOKSPAGE_TEMPLATE_PATH>
                </SECTION>';
   $sectionSearchArray = array('SECTION_ID','SECTION_TITLE','SECTION_DISPLAY_ON_HOME',
                  'SECTION_ACTIVE_FROM','SECTION_ACTIVE_TO','SECTION_DESCRIPTION',
                  'SECTION_HOMEPAGE_TEMPLATE_PATH', 'SECTION_BOOKSPAGE_TEMPLATE_PATH');
   $sectionId = 1;
   $section = null;
   fwrite($globalSectionsXMLFile, "<GLOBALSECTIONS>\n"); 
   foreach( $sectionsArray as $sectionName){
      // Parse the specific section file
      $sectionFileName = $sectionsDirectory.$sectionName . ".ini";
      // Read the section's ini file.
      if( !file_exists($sectionFileName)){
        print "[Error]: $sectionFileName File does not exist\n";
        continue; 
      } 
      
      $sectionConfigArray = parse_ini_file($sectionFileName, true); 

      // Read the section part for the variables.
      $section = $sectionConfigArray['section'];
      // Read the isbns part
      $isbnArray = $sectionConfigArray['isbns'];
      //Return ISBN's which are present in the database with stock.
      $isbnArray = returnInStockBooks($db, $sectionName, $isbnArray);
      //updateDiscounts($db, $isbnArray);
      $isbns = implode(",", array_keys($isbnArray));
      $section['SECTION_ID'] = $sectionId;
      $replace = Array();
      foreach($sectionSearchArray as $item ) {
       if(!array_key_exists($item, $section)) {
          $section[$item] = $configArray["section_details"]["DEFAULT_".$item];
       } elseif( $section[$item] == "" ) {
          $section[$item] = $configArray["section_details"]["DEFAULT_".$item];
       }
       $replace[] = $section[$item];
      }
      //print_r($replace);
      $finalSectionXML = str_replace($sectionSearchArray, $replace, $sectionXML);
      //print $finalSectionXML;
      fwrite($globalSectionsXMLFile, "\n".$finalSectionXML."\n");

      $iniString = "\n[". $section['SECTION_TITLE']. "]\n";
      $iniString .= "isbns=". $isbns. "\n";
      fwrite($globalSectionsINIFile, $iniString);
      $sectionId++;
   }
  fwrite($globalSectionsXMLFile, "\n</GLOBALSECTIONS>"); 
}

/* Main function for catalogs */
function sections_menu_generate_start($argc, $argv) {
   global $EKKITAB_HOME;
   global $configArray;
   global $sectionsDirectory;
   global $globalSectionsXMLFile;
   global $globalSectionsINIFile;
   global $debug;

   if ( $argc == 2 ){
     if ($argv[1] != "-d" ) {
       echo "Usage sections_menu_generate -d\n";
       exit();
     } else {
      $debug = 1;
     }
   }
        
   //Parse the main ini file
   $configArray = parse_ini_file("sections_menu.ini", true); 
   // Parse the database config file 
   $databaseConfigArray = parse_ini_file($EKKITAB_HOME. "/config/ekkitab.ini", true); 
   $db = initDatabase($databaseConfigArray);

   $sectionsDirectory = $EKKITAB_HOME.$configArray["paths"]["SECTIONS_DIRECTORY"];

   //Global xml file and global ini files 
   $tmpString = $EKKITAB_HOME.$configArray["paths"]["SECTIONS_GLOBAL_XML_FILE"];
   $globalSectionsXMLFile = fopen($tmpString, "w") or die ("Cannot open" . $tmpString . "\n");

   $tmpString = $EKKITAB_HOME.$configArray["paths"]["SECTIONS_GLOBAL_INI_FILE"];
   $globalSectionsINIFile = fopen($tmpString, "w") or die ("Cannot open" . $tmpString . "\n");

   $sectionsArray = $configArray["sections"];
   //print_r($sectionsArray);
   if( $sectionsArray != null and !empty($sectionsArray)) {
     writeSections($db, $sectionsArray);
   }
   fclose($globalSectionsXMLFile);
   fclose($globalSectionsINIFile);
   closeDatabase($db);
}

sections_menu_generate_start($argc, $argv);

?>
