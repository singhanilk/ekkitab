<?php
/* Program which applies database updates to refernece.books table 
** The changes are applied as the last step before copying the database to production
** Dependencies - data/special_updates.ini
*/
$EKKITAB_HOME= getenv("EKKITAB_HOME");
$updateArray=null;
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

function getDiscountUpdateString($isbn, $value){
  global $db;
  $sqlString = "";

  if ( is_numeric($value) and $value > 0 ) {
    $value = $value/100;
    $sqlString = "select floor(list_price - (list_price * $value)) as new_discount_price from books "
                    . " where isbn = '$isbn' and list_price is not null and list_price > 0 and list_price != 'NULL'";
    $result = mysqli_query($db,$sqlString);
    if ( $result ) {
       $row = mysqli_fetch_assoc($result);
       if ($row ) { $value = $row['new_discount_price']; } else { $value = -1; }
     } else {
        print "[Fatal] Result=$result Error=". mysqli_errno($db) . "\n"; 
     }
    if ( $value != -1 ) {
     $sqlString = " discount_price = $value ";
    } else { $sqlString = ""; }
  } else {
     $sqlString = " discount_price = $value ";
  }
  return $sqlString;
}

function updateValues($isbn, $columns){
   global $db;
   $sqlString = "";
   $comma = ",";

   foreach($columns as $key => $value ) {
    if ( is_null($value) or empty($value))
      continue;
    if ( $key == "discount_price") {
      $sqlString .= ( $sqlString == "" ? "" : "," ) . getDiscountUpdateString($key, $value); 
    } else {
      $sqlString .= ( $sqlString == "" ? "" : ",") . "$key = $value" ; 
    }
   }

   if ( trim($sqlString) != "" ) {
     $sqlString = "update books set " . $sqlString . " where isbn = '$isbn'"; 
     //print_r($sqlString . "\n");
    try {
        $updateResult = mysqli_query($db,$sqlString);
        if (!$updateResult) { print "[Fatal] Update result=$updateResult Error=". mysqli_errno($db) . "\n"; }
       } catch(exception $e) {
         print "[Exception] Failed while running query:Message=$e->getmessage()\n";
       }
   }
}



/* Main function for catalogs 
** Reads the section_menu.ini file and obtains the list of sections and menu.
*/
function special_updates_start($argc, $argv) {
   global $EKKITAB_HOME;
   global $updateArray;
   global $databaseConfigArray;
   global $db;
    
   //Parse the main ini file
   $updateArray = parse_ini_file($EKKITAB_HOME."/data/special_updates.ini", true); 
   // Parse the database config file 
   $databaseConfigArray = parse_ini_file($EKKITAB_HOME. "/config/ekkitab.ini", true); 
   // Initialize the database.
   initDatabase();
   if( $updateArray != null and !empty($updateArray)) {
     foreach( $updateArray as $key => $value ){
        updateValues($key, $value ); 
     }
   }
   closeDatabase();
}

special_updates_start($argc, $argv);

?>
