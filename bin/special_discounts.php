<?php
# The field separator is a tab
$EKKITAB_HOME= getenv("EKKITAB_HOME");
$configArray=null;
$globalSectionsXMLFile=null;
$globalSectionsINIFile=null;
$sectionsDirectory=null;
$databaseConfigArray=null;
$db=null;



function initDatabase(){
  global $db;
  global $databaseConfigArray;

  $database_server = $databaseConfigArray["database"]["server"];
  $database_user = $databaseConfigArray["database"]["user"];
  $database_password = $databaseConfigArray["database"]["password"];
  $ref_db = $databaseConfigArray["database"]["ref_db"];

  try  {
    $db = mysqli_connect($database_server,$database_user,$database_password,$ref_db);
    if (mysqli_connect_errno()) {
      print "[Fatal]:Cannot connect to DB:" . mysqli_connect_error() . "\n";
    }
    mysqli_select_db($db, $ref_db);
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
}

function closeDatabase(){
   global $db;

   mysqli_commit($db);
   mysqli_close($db);
}

function updateDiscounts($isbnArray){
   global $db;

   foreach($isbnArray as $key => $value ) {
     $tokens = explode(" ", $value);
     $discount = trim($tokens[0]);
     //print "isbn=>$key:value=$value:Discount=$discount\n";
     if ( is_numeric($discount) and $discount > 0 ) {
       try {
         $discount = $discount/100;

         $sqlString = "select floor(list_price - (list_price * $discount)) as new_discount_price from books "
                    . " where isbn = '$key' and list_price is not null and list_price > 0 and list_price != 'NULL'";
         //print $sqlString . "\n";
         $result = mysqli_query($db,$sqlString);
         if ( $result ) {
           $row = mysqli_fetch_assoc($result);
           if ($row ) {
             $discount = $row['new_discount_price'];
             $sqlString = "update books set discount_price = $discount where isbn = '$key' and discount_price > $discount"; 
             //print $sqlString . "\n";
             $updateResult = mysqli_query($db,$sqlString);
             if (!$updateResult) { print "[Fatal] Update Result=$updateResult Error=". mysqli_errno($db) . "\n"; }
           }
        } else {
           print "[Fatal] Result=$result Error=". mysqli_errno($db) . "\n"; 
        }
       } catch(exception $e) {
         print "[Exception] Failed while running query:Message=$e->getmessage()\n";
       }
     }
  }
}

/* Takes input as the ini files
** Parses each ini file and creates a list of isbns on which the discount has to be applied
** Calls the updateDiscounts function with the isbn Array.
*/
function applyDiscounts($iniArray){
  global $sectionsDirectory;
  global $configArray;
  $isbnArray = Array();

   foreach( $iniArray as $sectionFileName){
      // Parse the specific section file
      $sectionFileName = $sectionsDirectory.$sectionFileName . ".ini";
      // Read the section's ini file.
      if( !file_exists($sectionFileName)){
        continue; 
      } 
      $sectionConfigArray = parse_ini_file($sectionFileName, true); 
      // Read the section part for the variables.
      $section = $sectionConfigArray['section'];
      // Read the isbns part
      $isbnArray += $sectionConfigArray['isbns'];
   }
   updateDiscounts($isbnArray);
}

/* Main function for catalogs 
** Reads the section_menu.ini file and obtains the list of sections and menu.
*/
function special_discounts_start($argc, $argv) {
   global $EKKITAB_HOME;
   global $configArray;
   global $sectionsDirectory;
   global $databaseConfigArray;
   global $db;
    
   //Parse the main ini file
   $configArray = parse_ini_file($EKKITAB_HOME."/bin/ui/sections/sections_menu.ini", true); 
   // Parse the database config file 
   $databaseConfigArray = parse_ini_file($EKKITAB_HOME. "/config/ekkitab.ini", true); 
   // Initialize the database.
   initDatabase();
   // Call to apply discounts
   $sectionsDirectory = $EKKITAB_HOME.$configArray["paths"]["SECTIONS_DIRECTORY"];
   $sectionsArray = $configArray["sections"];
   $menusArray = $configArray["menus"];
   $iniArrays = array_merge($sectionsArray, $menusArray);
   // iniArrays contains the list of sections and menu ini file names. 
   if( $iniArrays != null and !empty($iniArrays)) {
     applyDiscounts($iniArrays);
   }
   closeDatabase();
}

special_discounts_start($argc, $argv);

?>
