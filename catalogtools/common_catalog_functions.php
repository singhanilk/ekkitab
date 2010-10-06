<?php
/** This file contains all the common catalog functions */

# The standard field separator for our catalog.
$FIELD_SEPARATOR = "\t";

/* BISAC VARIABLES */
$GENERIC_BISAC_CODE='ZZZ000000';

/* DEFAULT VALUES FOR A BOOK */
$defaultCatalogValues = array (
"LANGUAGE" => "English",
"SUBJECT" => "ZZZ000000",
);

#columns in the excel sheet.
$columnList = array("ISBN","PRICE","CURRENCY","AVAILABILITY","IMPRINT","DELIVERY-DATE","TITLE","AUTHOR","BINDING", 
                 "DESCRIPTION", "PUBLISH-DATE","PUBLISHER","PAGES","LANGUAGE","WEIGHT","DIMENSION","SHIP-REGION", 
                 "SUBJECT", "SUPPLIER");
# valid currency 
$currencyList = array("I" => "Rs", "U" => "USD", "P" => "Pound", "S" => "SD" );
# valid availability 
$availabilityList = array("Available" => "Available", "Not Available" => "Not Available", "Preorder" => "Preorder");
# valid binding
$bindingList = array("Paperback" => "Paperback", "Hardcover" => "Hardcover", "Hardback" => "Hardback");
# valid Language
$languageList = array("English" => "English");
# The valid suppliers as of now. This is taken from /mnt4/publisherdata/
$supplierList = array (
"amit" => "amit",
"bookworldenterprises" => "bookworldenterprises",
"cambridge" => "cambridge",
"cinnamonteal" => "cinnamonteal",
"dolphin" => "dolphin",
"eurokids" => "eurokids",
"hachette" => "hachette",
"harpercollins" => "harpercollins",
"harvard" => "harvard",
"indiabooks" => "indiabooks",
"jaico" => "jaico",
"mediastar" => "mediastar",
"newindiabooksource" => "newindiabooksource",
"orientblackswan" => "orientblackswan",
"oxford" => "oxford",
"panmacmillan" => "panmacmillan",
"paragonbooks" => "paragonbooks",
"penguin" => "penguin",
"popularprakasham" => "popularprakasham",
"prakash" => "praksah",
"prism" => "prism",
"randomhouse" => "randomhouse",
"researchpress" => "researchpress",
"rupa" => "rupa",
"sage" => "sage",
"schand" => "schand",
"tatamcgrawhill"=>"tatamcgrawhill",
"tbh"=>"tbh",
"ubs"=>"ubs",
"vinayaka" => "vinayaka",
"viva" => "viva",
"westland" => "westland",
"wiley" => "wiley",
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
     $book[$key] = $value;
    }   
  }
  return $book;
}

/* Checks for validity of the book passed. Returns true or false. 
1. ISBN present
2. Title present
3. Author present
4. Description present.
*/
function validBooks($books){
  $errorList = Array();
  $asciiExpression = '/(?:[^\x00-\x7F])/';
  $titleIsValid = false;
  $authorIsValid = false;
  $descIsValid = false;
  $errorString = "";
  global $availabilityList;
  global $supplierList;

 foreach($books as $book ) {
  $errorString = "";
  if ( !is_null($book['ISBN']) && !empty($book['ISBN']) && (preg_match($asciiExpression,$book['ISBN']) == 0 )){
       $isbnIsValid = true;
  } else { $errorString .=  "ISBN is not valid\n"; }

  if ( !is_null($book['AVAILABILITY']) && !empty($book['AVAILABILITY']) && (preg_match($asciiExpression,$book['AVAILABILITY']) == 0 ) 
       && in_array($book['AVAILABILITY'], $availabilityList)){
       $availabilityIsValid = true;
  } else { $errorString .=  "Availability is not valid\n"; }

  if ( !is_null($book['TITLE']) && !empty($book['TITLE']) && (preg_match($asciiExpression,$book['TITLE']) == 0 )){
       $titleIsValid = true;
  } else { $errorString .=  "Title is not valid\n"; }

  if ( !is_null($book['AUTHOR']) && !empty($book['AUTHOR']) && (preg_match($asciiExpression,$book['AUTHOR']) == 0)){
       $authorIsValid = true;
  } else { $errorString .=  "Author is not valid\n"; }

  if ((preg_match($asciiExpression,$book['DESCRIPTION']) == 0 )){
       $descIsValid = true;
  } else { $errorString .=  "Description is not valid\n"; }

  if ( !is_null($book['SUPPLIER']) && !empty($book['SUPPLIER']) && (preg_match($asciiExpression,$book['SUPPLIER']) == 0 ) 
       && in_array($book['SUPPLIER'], $supplierList)){
       $supplierIsValid = true;
  } else { $errorString .=  "Supplier is not valid\n"; }

  if ( $errorString != "" ) { 
    $errorString = "Error:ISBN=" . $book['ISBN']. ":Title=" . $book['TITLE']. ":Author=".$book['AUTHOR']. "\n" . $errorString; 
    $errorList[] = $errorString;
  }
 }
 return $errorList;
} 

/* This validate method is used for missing isbn to catalog conversion function 
** This returns a valid book if isbn and title are valid. 
** Makes the Author an empty string if it is invalid.
**
*/
function validMissingIsbnBook($book){
  $asciiExpression = '/(?:[^\x00-\x7F])/';
  $isbnIsValid = false;
  $titleIsValid = false;
  $validBook = null;
  global $invalidMissingIsbnTitleList;
  global $invalidMissingIsbnAuthorList;

  if ( !is_null($book['ISBN']) && !empty($book['ISBN']) && (preg_match($asciiExpression,$book['ISBN']) == 0 )){
       $isbnIsValid = true;
  } 

  if ( !is_null($book['TITLE']) && !empty($book['TITLE']) && (preg_match($asciiExpression,$book['TITLE']) == 0 ) 
       && !in_array($book['TITLE'], $invalidMissingIsbnTitleList)){
       $titleIsValid = true;
  } 

  if ( !is_null($book['AUTHOR']) && !empty($book['AUTHOR']) && (preg_match($asciiExpression,$book['AUTHOR']) == 0) 
       && !in_array($book['AUTHOR'], $invalidMissingIsbnAuthorList)){
       $authorIsValid = true;
  } else {
     $book['AUTHOR']  = "";
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

function getBookDetails($isbn) {
  global $db;
  $book = Array();
  $query = "select ISBN, TITLE, AUTHOR from books where isbn = '$isbn'";

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

  return $book; 
}

/* Function to write to catalog file 
** Assumes that the file is open.
*/
function writeBookToCatalog($book, $catalogFile) {
   $catalogString = "";
   $catalogString = $book["ISBN"] . "\t" . $book["TITLE"] . "\t" . $book["AUTHOR"] . "\t" . $book["BINDING"] . "\t";
   $catalogString .= $book["DESCRIPTION"] . "\t" . $book["PUBLISH-DATE"] . "\t" . $book["PUBLISHER"] . "\t" . $book["PAGES"] . "\t";
   $catalogString .= $book["LANGUAGE"] . "\t" . $book["WEIGHT"] . "\t" . $book["DIMENSION"] . "\t" . $book["SHIP-REGION"] . "\t" . $book["SUBJECT"] . "\n";
   fwrite($catalogFile, $catalogString);
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
