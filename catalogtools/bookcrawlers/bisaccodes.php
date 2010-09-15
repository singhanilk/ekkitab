<?php

/* Catalog file output 
**  #ISBN  TITLE   AUTHOR  BINDING DESCRIPTION PUBLISH-DATE    PUBLISHER   PAGES   LANGUAGE    WEIGHT  DIMENSION   SHIP-REGION SUBJECT
** Whatever information that is fetched through the API is written out to a file in tab separated format.
*/

/* The field separator is a tab */
$FIELD_SEPARATOR = "\t";
$ISBN_INDEX = 0;
$SUBJECT_INDEX = 12;
$database_server     = 'localhost';
$database_user       = 'root';
$database_password   = 'root';
$ekkitab_db = 'ekkitab_books';
$ref_db     = 'reference';
$db = NULL;
$GENERIC_BISAC_CODE='ZZZ000000';

function initDatabase(){
  global $database_server; 
  global $database_user; 
  global $database_password; 
  global $ekkitab_db; 
  global $ref_db; 
  global $db;

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
}

function closeDatabase(){
   global $db;

   mysqli_commit($db);
   mysqli_close($db);
}

/* Google specific Bisac Codes function 
** The subject is expected to be an array with topics separated with 
** The subject is expected to be an array with topics separated with 
** Returns the bisac codes separated with a comma.
*/
function getBisacCodes($subjects) {
 global $db;
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
     /*
     if (strcmp($subjects[0], "--")) {
       foreach($subjects as $subject) {
         echo "( $subject ) ";
       }
       echo "\n";
     }
     */
     $bisac_codes[] = "ZZZ000000";
  }
  return implode(",", $bisac_codes);
}

/** Writes all the not found bisac codes into the reference database */
function writeNotMappedSubjectsToDatabase($isbnNotFoundBisacMap){
  global $db;

  if ( !is_null($isbnNotFoundBisacMap) and !empty($isbnNotFoundBisacMap)){
    foreach($isbnNotFoundBisacMap as $key => $value ){
     $value = trim($value);
     $query = "insert into missing_bisac_codes (isbn, subject ) values ( $key, '$value' );";
     try {
       $result = mysqli_query($db, $query);
     } catch (exception $e) { fatal($e->getmessage()); }
  }
 } 
}

function bisaccodes_start($argc, $argv) {
   global $FIELD_SEPARATOR;
   global $ISBN_INDEX;
   global $SUBJECT_INDEX;
   global $GENERIC_BISAC_CODE;
   $bisacCodesNotFound = Array();
   $generatedBisacCode = "";
   $uniqueISBN = Array();
   $isbnNotFoundBisacMap = Array();

     if ($argc < 3) {
       echo "Usage: $argv[0] <file with just subjects no bisac code> <output file name>\n";
       exit(1);
    }
    $nonBisacFileName = $argv[1];
    $nonBisacFile = fopen($nonBisacFileName, "r") or die ("Cannot open" . $nonBisacFileName . "\n");
    $bisacFileName = $argv[2];
    $bisacFile = fopen($bisacFileName, "w") or die ("Cannot open" . $bisacFileName . "\n");
    $db = initDatabase();
    while (!feof($nonBisacFile)){ 
     $tmpString = fgets($nonBisacFile);   
     if ( $tmpString == null ) { break; }
     /* The file may or may not contain the author */
     $values = explode($FIELD_SEPARATOR, $tmpString);
     $subjectString = $values[$SUBJECT_INDEX];
     $isbnno = $values[$ISBN_INDEX];
     if(is_null($subjectString) or empty($subjectString)) {
       $generatedBisacCode = $GENERIC_BISAC_CODE;
     } else {
     $subjects = array();
     $subjects[] = $values[$SUBJECT_INDEX];
     $generatedBisacCode =  getBisacCodes($subjects);
     if($generatedBisacCode == $GENERIC_BISAC_CODE ){
          if(!in_array($subjects[0], $bisacCodesNotFound)){
           $bisacCodesNotFound[] = $subjects[0];
           $isbnNotFoundBisacMap[$isbnno] = $subjects[0];
          }        
       } 
     }
     $values[$SUBJECT_INDEX] = $generatedBisacCode;
     // Create a list of unique isbns, so the duplicated are removed when we write back.
     if(!in_array($values[$ISBN_INDEX],$uniqueISBN)){
        $uniqueISBN[] = $values[$ISBN_INDEX];
        fwrite($bisacFile, implode($FIELD_SEPARATOR, $values). "\n");
     }
    }
    // Print all the unique subjects which have been found.
    // print(implode("\n",$bisacCodesNotFound));
    writeNotMappedSubjectsToDatabase($isbnNotFoundBisacMap);
    fclose($nonBisacFile);
    fclose($bisacFile);
    closeDatabase();
}

bisaccodes_start($argc, $argv);

?>
