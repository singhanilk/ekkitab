<?php
/** This file contains all the common catalog functions */

# The standard field separator for our catalog.
$FIELD_SEPARATOR = "\t";

# Control characters which have to be replaced
$controlCharactersToReplace = array("\x0D", "\n", '"');
$controlCharactersReplaceValues = array("", "<br>", "");
# characters outside the range.
$asciiExpression = '/(?:[^\x00-\x7F])/';

/* BISAC VARIABLES */
$GENERIC_BISAC_CODE='ZZZ000000';

/* DEFAULT VALUES FOR A BOOK */
$defaultCatalogValues = array (
"language" => "English",
"bisac_codes" => "ZZZ000000",
);

#columns in the excel sheet.
$columnList = array("isbn","list_price","currency","in_stock","imprint","delivery_period","title","author","binding", 
                 "description", "publishing_date","publisher","pages","language","weight","dimension", "shipping_region", "bisac_codes", "info_source");
# valid currency 
$currencyList = array("I" => "Rs", "U" => "USD", "P" => "Pound", "S" => "SD" );
# valid availability 
$availabilityList = array("1" => "Available", "0" => "Not Available", "2" => "Preorder");
# valid binding
$bindingList = array("None" => "", "Paperback" => "Paperback", "Hardcover" => "Hardcover", "Hardback" => "Hardback");
# valid Language
$languageList = array("English" => "English", "Hindi" => "Hindi", "Gujarati" => "Gujarati");
# The valid suppliers as of now. This is taken from /mnt4/publisherdata/
$supplierList = array (
"APK" => "APK",
"AMIT" => "AMIT",
"BOOKWORLDENTERPRISES" => "BOOKWORLDENTERPRISES",
"CAMBRIDGE" => "CAMBRIDGE",
"CINNAMONTEAL" => "CINNAMONTEAL",
"DOLPHIN" => "DOLPHIN",
"EUROKIDS" => "EUROKIDS",
"FORTYTWOBOOKZGALAXY" => "FORTYTWOBOOKZGALAXY",
"HACHETTE" => "HACHETTE",
"HARPERCOLLINS" => "HARPERCOLLINS",
"HARVARD" => "HARVARD",
"INDIABOOKS" => "INDIABOOKS",
"JAICO" => "JAICO",
"MEDIASTAR" => "MEDIASTAR",
"NARI" => "NARI",
"NEWINDIABOOKSOURCE" => "NEWINDIABOOKSOURCE",
"ORIENTBLACKSWAN" => "ORIENTBLACKSWAN",
"OXFORD" => "OXFORD",
"PANMACMILLAN" => "PANMACMILLAN",
"PARAGONBOOKS" => "PARAGONBOOKS",
"PENGUIN" => "PENGUIN",
"POPULARPRAKASHAM" => "POPULARPRAKASHAM",
"PRAKASH" => "PRAKSAH",
"PRISM" => "PRISM",
"RANDOMHOUSE" => "RANDOMHOUSE",
"RESEARCHPRESS" => "RESEARCHPRESS",
"ROLI" => "ROLI",
"RUPA" => "RUPA",
"SAGE" => "SAGE",
"SANJAY" => "SANJAY",
"SCHAND" => "SCHAND",
"SCHOLASTIC" => "SCHOLASTIC",
"TATAMCGRAWHILL"=>"TATAMCGRAWHILL",
"TBH"=>"TBH",
"UBS"=>"UBS",
"VINAYAKA" => "VINAYAKA",
"VIVA" => "VIVA",
"WESTLAND" => "WESTLAND",
"WILEY" => "WILEY",
);

// This list of invalid Author and title list is made after going through the missing isbns files.
$invalidMissingIsbnTitleList = array(".", "Not Available" ); 
$invalidMissingIsbnAuthorList = array(".", "Not Available", "NONE", "NA", "NO AUTHOR", "Required, No Author Name");


/* FUNCTIONS START FROM HERE */

/* Load Default values to book */
function fillDefaultCatalogValues($book){
  global $defaultCatalogValues;

  if ($book){
    foreach($defaultCatalogValues as $key => $value ) {
     if ( empty($book[$key]) || is_null($book[$key])) {
      $book[$key] = $value;
     }
    }   
  }
  return $book;
}
/* Replacing special char acters and other values in the book */
function formatValues($books){
  global $controlCharactersToReplace;
  global $controlCharactersReplaceValues;
  global $asciiExpression;

  $modifiedBooks = Array();
  foreach($books as $book){
   $book['title'] = preg_replace($asciiExpression, " ", $book['title']);
   $book['title'] = str_replace($controlCharactersToReplace, $controlCharactersReplaceValues, $book['title']);

   if ( $book['author'] == "NA" ) { $book['author'] = ""; }
   $book['author'] = preg_replace($asciiExpression, " ", $book['author']);
   $book['author'] = str_replace($controlCharactersToReplace, $controlCharactersReplaceValues, $book['author']);

   $book['description'] = str_replace($controlCharactersToReplace, $controlCharactersReplaceValues, $book['description']);
   $book['description'] = preg_replace($asciiExpression, " ", $book['description']);

   $modifiedBooks[] = $book;
  }
  //print_r($modifiedBooks);
  return $modifiedBooks;
}

/* Checks for validity of the book passed. Returns true or false. 
1. ISBN present
2. Title present
3. Author present
4. Description present.
*/
function validBooks($books){
  $errorList = Array();
  $titleIsValid = false;
  $authorIsValid = false;
  $descIsValid = false;
  global $asciiExpression;
  global $availabilityList;
  global $supplierList;
  global $currencyList;
  $index = 0;

 foreach($books as $book ) {
  $index++;
  if ( !is_null($book['isbn']) && !empty($book['isbn']) && (preg_match($asciiExpression,$book['isbn']) == 0 )){
       $isbnIsValid = true;
  } else { $errorList[] =  "Book No:$index-Isbn is not valid"; }

  if ( !is_null($book['in_stock']) && !empty($book['in_stock']) && (preg_match($asciiExpression,$book['in_stock']) == 0 ) 
       && array_key_exists($book['in_stock'], $availabilityList)){
       $availabilityIsValid = true;
  } else { $errorList[] =  "Book No:$index-Availability is not valid"; }

  if ( !is_null($book['title']) && !empty($book['title']) && (preg_match($asciiExpression,$book['title']) == 0 )){
       $titleIsValid = true;
  } else { $errorList[] =  "Book No:$index-Title is not valid"; }

  if ( !is_null($book['author']) && !empty($book['author']) && (preg_match($asciiExpression,$book['author']) == 0)){
       $authorIsValid = true;
  } else { $errorList[] =  "Book No:$index-Author is not valid"; }

  if ((preg_match($asciiExpression,$book['description']) == 0 )){
       $descIsValid = true;
  } else { $errorList[] =  "Book No:$index-Description is not valid"; }

  if ( !is_null($book['info_source']) && !empty($book['info_source']) && (preg_match($asciiExpression,$book['info_source']) == 0 ) 
       && in_array($book['info_source'], $supplierList)){
       $supplierIsValid = true;
  } else { $errorList[] =  "Book No:$index-Supplier is not valid"; }

  if ( !is_null($book['currency']) && !empty($book['currency']) && (preg_match($asciiExpression,$book['currency']) == 0 ) 
       && array_key_exists($book['currency'], $currencyList)){
       $currencyIsValid = true;
  } else { $errorList[] =  "Book No:$index-Currency is not valid"; }
 }
 return $errorList;
} 

/* This validate method is used for missing isbn to catalog conversion function 
** This returns a valid book if isbn and title are valid. 
** Makes the Author an empty string if it is invalid.
**
*/
function validMissingIsbnBook($book){
  global $asciiExpression;
  $isbnIsValid = false;
  $titleIsValid = false;
  $validBook = null;
  global $invalidMissingIsbnTitleList;
  global $invalidMissingIsbnAuthorList;

  if ( !is_null($book['isbn']) && !empty($book['isbn']) && (preg_match($asciiExpression,$book['isbn']) == 0 )){
       $isbnIsValid = true;
  } 

  if ( !is_null($book['title']) && !empty($book['title']) && (preg_match($asciiExpression,$book['title']) == 0 ) 
       && !in_array($book['title'], $invalidMissingIsbnTitleList)){
       $titleIsValid = true;
  } 

  if ( !is_null($book['author']) && !empty($book['author']) && (preg_match($asciiExpression,$book['author']) == 0) 
       && !in_array($book['author'], $invalidMissingIsbnAuthorList)){
       $authorIsValid = true;
  } else {
     $book['author']  = "";
  } 

  if ( $isbnIsValid && $titleIsValid) {
    return $book;
  } else {
   return null;
  }
} 

function validIgnoreIsbnBook($book){
  global $asciiExpression;
  $isbnIsValid = false;
  $titleIsValid = false;
  $validBook = null;
  global $invalidMissingIsbnTitleList;
  global $invalidMissingIsbnAuthorList;

  if ( !is_null($book['isbn']) && !empty($book['isbn']) && (preg_match($asciiExpression,$book['isbn']) == 0 )){
       $isbnIsValid = true;
  } 

  if ( !is_null($book['title']) && !empty($book['title']) && (preg_match($asciiExpression,$book['title']) == 0 ) 
       && !in_array($book['title'], $invalidMissingIsbnTitleList)){
       $titleIsValid = true;
  } 

  if ( !is_null($book['author']) && !empty($book['author']) && (preg_match($asciiExpression,$book['author']) == 0) 
       && !in_array($book['author'], $invalidMissingIsbnAuthorList)){
       $authorIsValid = true;
  } else {
     $book['author']  = "";
  } 

  if ( $isbnIsValid && $titleIsValid) {
    return $book;
  } else {
   return null;
  }
} 

function validSupplier($supplier){
  global $supplierList;
  return in_array($supplier, $supplierList);
}

function getBookDetails($db, $isbn) {
  $book = Array();
  $query = "select * from books where isbn = '$isbn'";

  try {
   $result = mysqli_query($db,$query);
   if (!$result) { 
     $book = null; 
   } else { 
       $book= mysqli_fetch_array($result);
   }
  } catch(exception $e) {
    $book = null;
  }
  // Conver the Bisac codes back to the subjects.
  if ( $book != null ) {
    $book['bisac_codes'] = getSubjectsFromBisacCodes($db, $book['bisac_codes']);
  }
  return $book; 
}

/* Reads the catalog file which is derived from the info_source column
** If $db is not null will replace the values in the db.
** If catalogFile is present then will replace the values in the catalog file also.
*/
function updateBookDetails($book, $columnsToBeReplaced, $db, $catalogFilename){
  global $FIELD_SEPARATOR;
  if ( empty($columnsToBeReplaced) || is_null($columnsToBeRepalced)) {
    return false;
  }

  if ( $db != null ) {
   $query = "update books set ";
   foreach($columnsToBeReplaced as $column ) {
    $query .= " $column=" . $book[$column];
   }
   try {
    $result = mysqli_query($db,$query);
    if (!$result) { return false; } else { return true; }
    mysqli_free_result($result);
   } catch ( exception $e ) {
     return false;
   }  
  }// Db is null

  if ( !is_null($catalogFilename) && file_exists($catalogFilename) && is_file($catalogFilename)){
    $catalogFile = fopen($catalogFilename, "r") or die ("Cannot open" . $catalogFilename . "\n");
    $catalogFileTmp = fopen($catalogFilename, "w") or die ("Cannot open" . $catalogFilenameTmp . "\n");
    while (!feof($catalogFile)){
     $tmpString = fgets($catalogFile);   
     if ( $tmpString == null ) { break; }
     $values = explode($FIELD_SEPARATOR, $tmpString);
     $isbnno = $values[0];
     if ( $book['isbn'] == $isbnno ) {
          fwrite($catalogFileTmp, bookStringInCatalogFormat($book)); 
     } else {
        fwrite($bisacFile, implode($FIELD_SEPARATOR, $values). "\n");
     }
    }
    
  } else {
   return false;
  }
}


function getBisacCodes($db, $subjects) {
 $bisac_codes = array();
 if ($subjects != null) {
   foreach ($subjects as $subject) {
     $topics = explode("/", $subject);
     $query = "select bisac_code from ek_bisac_category_map where ";
     $i = 1;
     $conjunction = "";
     foreach($topics as $topic) {
      $label = "level".$i++;
      $value = strtolower(trim($topic));
      $query = $query . $conjunction . $label . " = '" . $value . "'";
      $conjunction = " and ";
     }
     $result = mysqli_query($db, $query);
     if (($result) && (mysqli_num_rows($result) > 0)) {
       $row = mysqli_fetch_array($result);
       $bisac_codes[] = $row[0];
     }
   }
  }
  if (empty($bisac_codes)) {
     $bisac_codes[] = "ZZZ000000";
  }
  return implode(",", $bisac_codes);
}

function getSubjectsFromBisacCodes($db, $bisacCodesString){
     $subjectLine = "";
     $subjectResultArray = Array();

     if ( $bisacCodesString == null || empty($bisacCodesString)) {
       return "";
     }

     $bisacCodesArray = explode(",", $bisacCodesString);
     $query = "select * from ek_biasc_category_map where bisac_code in ( " ; 
     $count = 0;
     foreach ( $bisacCodesArray as $biascCode ) {
       $query .= (($count == 0 ) ? "'" : ",'" ) . $bisacCode . "'"; 
     }
     $query .= ")";
     $result = mysqli_query($db, $query);
     if (($result) && (mysqli_num_rows($result) > 0)) {
         $subjects = mysqli_fetch_assoc($result);
     }
     if ( $subjects != null && !empty($subjects) ) {
      foreach($subjects as $subject ) {
         $subjectResultArray[] = $subject["level1"] . (($subject["level2"] != "" ) ? $subject["level2"] : "") . (($subject["level3"] != "" ) ? $subject["level3"] : "");       
      }
      $subjectLine = implode(",", $subjectResultArray);
     } else {
      $subjectLine = "";
     }

    return $subjectLine;     
 
}

function addToIgnoreIsbns($db, $ignoreBook) {
  $errorList = Array();
  $query = "insert into reference.ignore_isbns (isbn, title, author, supplier ) values ( ". $ignoreBook['isbn'] . ",'" . $ignoreBook['title'] . "','" 
           . $ignoreBook['author'] . "','" . strtolower($ignoreBook['info_source']) . "')";
  try {
   $result = mysqli_query($db,$query);
   if (!$result) { 
     $errorList[]  = "Failed to add the book to the ignore isbn list"; 
   }
  } catch(exception $e) {
    $errorList[]  = "Exception while adding book to the ignore isbn list";
  }
  return $errorList; 

}

function removeFromIgnoreIsbns($db, $isbnList) {
  $errorList = Array();
  if ( $isbnList == null || empty($isbnList)) {
   return $errorList;
  }
  $query = "delete from reference.ignore_isbns where id in ( " . implode(",", $isbnList) . ")";
  try {
   $result = mysqli_query($db,$query);
   if (!$result) { 
     $errorList[]  = "Failed to remove isbns from the ignore isbns table"; 
   }
  } catch(exception $e) {
    $errorList[]  = "Exception while removing books from ignore isbn list";
  }
  return $errorList; 
}

function getIgnoreIsbns($db) {
  $ignoreIsbnList = Array();
  $query = "select id, isbn, title, author, supplier as info_source from reference.ignore_isbns";
  try {
   $result = mysqli_query($db,$query);
   if (!$result) { 
     $ignoreIsbnList = null; 
   } else { 
     while ($row = mysqli_fetch_assoc($result)) {
        $ignoreIsbnList[] = $row;
     }
   }
  } catch(exception $e) {
    $ignoreIsbnList = null;
  }
  if ( $ignoreIsbnList == null ) $ignoreIsbnList = Array();
  return $ignoreIsbnList; 
 
}

/* This is the standard file format in which tab delimited files will be uploaded
** The following columns are named differently in the TAB delimited file for user conviencen
** info_source as SUPPLIER
** list_price as PRICE
** in_stock as AVAILABILITY
** bisac_codes as SUBJECT 
** 
** The bisac codes and description are kept at the end for the ease of entering data in excel sheet 
** which is later converted into TAB delimited file 
*/
function getBookFromStandardUploadFormat($line){
  global $FIELD_SEPARATOR;
  global $availabilityList;

  $book = Array();
  $values = explode($FIELD_SEPARATOR, $line);
  $index =0;  
  $book['isbn'] = $values[$index++];
  $book['title'] = $values[$index++];
  // Convert the authors's to right format
  $book['author'] = $values[$index++];
  $book['info_source'] = strtoupper($values[$index++]);
  $book['publisher'] = $values[$index++];
  $book['imprint'] = $values[$index++];
  $book['list_price'] = $values[$index++];
  $book['currency'] = $values[$index++];
  // Convert availability from string to code.
  $book['in_stock'] = ""; 
  $tmpString = $values[$index++];
  foreach($availabilityList as $key=>$value ){
     if ( $value == $tmpString ) { $book['in_stock'] = $key; break; }
  }
  $book['publishing_date'] = $values[$index++];
  $book['delivery_period'] = $values[$index++];
  $book['binding'] = $values[$index++];
  $book['pages'] = $values[$index++];
  $book['language'] = $values[$index++];
  $book['weight'] = $values[$index++];
  $book['dimension'] = $values[$index++];
  $book['shipping_region'] = $values[$index++];
  $book['bisac_codes'] = $values[$index++];
  $book['description'] = $values[$index++];
  return $book;
}

function bookStringInCatalogFormat($book) {
   $catalogString = "";
   $catalogString = $book["isbn"] . "\t" . $book["title"] . "\t" . $book["author"] . "\t" . $book["binding"] . "\t";
   $catalogString .= $book["description"] . "\t" . $book["publishing_date"] . "\t" . $book["publisher"] . "\t" . $book["pages"] . "\t";
   $catalogString .= $book["language"] . "\t" . $book["weight"] . "\t" . $book["dimension"] . "\t" . $book["shipping_region"] . "\t" . $book["bisac_codes"] . "\n";
   return $catalogString;
}

function bookStringInStockFormat($book) {
   global $availabilityList;

   $stockString = "";
   $stockString =  $book["isbn"] . "\t". $book["list_price"] . "\t" . $book["currency"] . "\t" ;
   $stockString .= $availabilityList[$book["in_stock"]]. "\t" . strtolower($book["info_source"]) . "\t" . $book["title"] . "\t" . $book["author"] ."\t";
   $stockString .= $book["delivery_period"] . "\n";
   return $stockString;
}

/* Function to write to catalog file 
** Assumes that the file is open.
*/
function writeBookToCatalog($book, $catalogFile) {
   fwrite($catalogFile, bookStringInCatalogFormat($book));
}

function writeBooksToCatalog($books, $catalogFile) {
   foreach($books as $book) {
    writeBookToCatalog($book, $catalogFile);
   }
}


/* Function to write both stdout and file */
function logMessage($logFile, $outputString){
  print_r($outputString);
  fwrite($logFile, $outputString);
}

function initializeDatabase($config) {
  if (! $config) return NULL;

  $database_server = $config["database"]["server"];
  $database_user   = $config["database"]["user"];
  $database_psw    = $config["database"]["password"];
  $db_name          = $config["database"]["db_name"];
  $db  = NULL;
  try  {
    $db = mysqli_connect($database_server,$database_user,$database_psw,$db_name);
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

function initDatabase($config){

  if (! $config) return NULL;

  $database_server = $config["database"]["server"];
  $database_user   = $config["database"]["user"];
  $database_psw    = $config["database"]["password"];
  $ref_db          = $config["database"]["ref_db"];
  $db  = NULL;
  #print_r("Database server=" . $database_server . ":Database user=" . $database_user . "Database password=" . $database_psw . "\n");
  try  {
    $db = mysqli_connect($database_server,$database_user,$database_psw,$ref_db);
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

?>
