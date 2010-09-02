<?php

/* Catalog file output 
**  #ISBN  TITLE   AUTHOR  BINDING DESCRIPTION PUBLISH-DATE    PUBLISHER   PAGES   LANGUAGE    WEIGHT  DIMENSION   SHIP-REGION SUBJECT
** Whatever information that is fetched through the API is written out to a file in tab separated format.
*/

/* The field separator is a tab */
$FIELD_SEPARATOR = '	';
$ISBN_INDEX = 12;
$SUBJECT_INDEX = 12;
$database_server     = 'localhost';
$database_user       = 'root';
$database_password   = 'root';
$ekkitab_db = 'ekkitab_books';
$ref_db     = 'reference';
$db = NULL;
$GENERIC_BISAC_CODE='ZZZ000000';

/* 
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
 
function cleancatalog_start($argc, $argv) {

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
     $tmpString = rtrim(fgets($nonBisacFile));   
     if ( $tmpString == null ) { break; }
     /* The file may or may not contain the author */
     $values = explode($FIELD_SEPARATOR, $tmpString);
     $subjectString = $values[$SUBJECT_INDEX];
     if(is_null($subjectString) or empty($subjectString)) {
       $generatedBisacCode = $GENERIC_BISAC_CODE;
     } else {
     $subjects = array();
     $subjects[] = $values[$SUBJECT_INDEX];
     $generatedBisacCode =  getBisacCodes($subjects);
     if($generatedBisacCode == $GENERIC_BISAC_CODE ){
          if(!in_array($subjects[0], $bisacCodesNotFound)){
           $bisacCodesNotFound[] = $subjects[0];
          }        
       } 
     }
     $values[$SUBJECT_INDEX] = $generatedBisacCode;
     if(!in_array($values[$ISBN_INDEX],$uniqueISBN)){
        $uniqueISBN[] = $values[0];
        fwrite($bisacFile, implode($FIELD_SEPARATOR, $values). "\n");
     }
    }
    // Print all the unique subjects which have been found.
    print(implode("\n",$bisacCodesNotFound));
    fclose($nonBisacFile);
    fclose($bisacFile);
}

cleancatalog_start($argc, $argv);

?>

