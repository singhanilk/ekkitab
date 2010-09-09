<?php
/*
	Module to update the catalog with missing isbns which we obtain from stock list
	Author - Prasad Potula 
	Date   - 10/June/2010
	Description 
  1. First check the file in ingram database which is local. Dependence is on tomcat 
  2. Check in isbn db 
  3. Check in library of congress
  4. Check in the individual publishers site
  Input
		Missing ISBN's stock list file. Name should be publisher_*.txt
  Output 
   Updates the catalog
   Creates a log file with details of isbn stages.
  Dependencies
   Configuration file updatecatalog.ini

The catalog row is as follows
  #ISBN  TITLE   AUTHOR  BINDING DESCRIPTION PUBLISH-DATE    PUBLISHER   PAGES   LANGUAGE    WEIGHT  DIMENSION   SHIP-REGION SUBJECT
*/

require "convertisbn.php";
require_once("common_utils.php");
require_once("simple_html_dom.php");

# The field separator is a tab
$EKKITAB_HOME= getenv("EKKITAB_HOME");
$FIELD_SEPARATOR = '	';
$INCLUDE_PATH= "$EKKITAB_HOME/tools/ZendGdata-1.10.2/library:$EKKITAB_HOME/bin:.";
$logFile;

/* Function to write to catalog file */
function writeBooksToCatalog($books, $catalogFile) {
   $catalogString = "";

   /* Right now break after the first book. */
   foreach($books as $book) {
    $catalogString = $book["isbn"] . "\t" . $book["title"] . "\t" . $book["author"] . "\t" . $book["binding"] . "\t";
    $catalogString .= $book["description"] . "\t" . $book["publishdate"] . "\t" . $book["publisher"] . "\t" . $book["pages"] . "\t";
    $catalogString .= $book["language"] . "\t" . $book["weight"] . "\t" . $book["dimension"] . "\t" . $book["shipregion"] . "\t" . $book["subject"] . "\n";
    fwrite($catalogFile, $catalogString);
    break;
   }
}

/* Checks for validity of the books passed and returns only the valid ones. The rules for checking book validity are 
1. ISBN present
2. Title present
3. Author present
4. Description present.
*/
function validBooks($books){
  global $logFile;
  $validBooks = null;
  $asciiExpression = '/(?:[^\x00-\x7F])/';
  $titleIsValid = false;
  $authorIsValid = false;
  $descIsValid = false;
  // Check for each book
  foreach($books as $book ){
    //logMessage($logFile, "validBooks:Book=" . print_r($book));
    if ( !is_null($book['title']) && !empty($book['title']) && (preg_match($asciiExpression,$book['title']) == 0 )){
       $titleIsValid = true;
    }
    if ( !is_null($book['author']) && !empty($book['author']) && (preg_match($asciiExpression,$book['author']) == 0)){
       $authorIsValid = true;
    }
    if ( !is_null($book['description']) && !empty($book['description']) && (preg_match($asciiExpression,$book['description']) == 0 )){
       $descIsValid = true;
    }

    if ($titleIsValid && $authorIsValid){
     $validBooks[] = $book;
    }
  } 
  return $validBooks;
}


/* Main function for catalogs */
function updatecatalog_start($argc, $argv) {
   global $FIELD_SEPARATOR;
   global $INCLUDE_PATH;
   global $logFile;

   $counter = 0;

   if ( $argc < 2 ){
     echo "Usage updatecatalog <Missing ISBN's file> \n";
     exit();
   }

   // Parse the ini file for the values.
   $configArray = parse_ini_file("updatecatalog.ini", true); 
   count(($configArray["process_steps"]));
   $missingISBNFileName = $argv[1];
   // Start Time
   $dateSuffix = date("YmdHi");
   $logFile=fopen($configArray["log_file"]["location"] . "/updatecatalog-" . $dateSuffix . ".log" , "a+") or die("Cannot open the log file\n");
   
   $missingISBNFile = fopen($missingISBNFileName, "r") or die ("Cannot open" . $missingISBNFileName . "\n");
   $totalLinesProcessed = 0;
   $noOfISBNFound = 0;
   $noOfInvalidBooks = 0;
   $bookFound = false;
   /* Map to record how many hits have been made by each step */
   $processStepHits = Array();
   /* Map to store all the file handles for separate catalog files */
   $processStepsCatalogFileHandles = Array();
   $outputstring = "File being processed=" . $missingISBNFileName . "\n";
   logMessage($logFile, $outputstring);

   while (!feof($missingISBNFile)){ 
    $tmpString = rtrim(fgets($missingISBNFile));   
    if ( $tmpString == null ) {
      break;
    }
    $bookFound = false;
    /* The file may or may not contain the author */
    $values = explode($FIELD_SEPARATOR, $tmpString);
    $valuesize = count($values);
    $isbnno = $values[0];
    if(strlen($isbnno) < 12){
        $newisbnno = isbn10to13($isbnno);
    } else {
        $newisbnno = $isbnno;
    }
    if ( $valuesize == 2 ) {
      $title = $values[1];
    } else {
      $title = "";
    }
    if ( $valuesize == 3 ) {
    $author = $values[2];
    } else {
     $author = "";
    }
    $counter=0;
    while ( $counter < count($configArray["process_steps"])){
      $processStep = $configArray["process_steps"][$counter];
      if ( $processStep != null ){
       /* Store the number of hits per process step */
       if(!array_key_exists($processStep, $processStepHits)){
         $processStepHits[$processStep] = 0;
       }
       /* Get the respective file handles */
       if(!array_key_exists($processStep,$processStepsCatalogFileHandles)){
          $missingISBNFileInfo =  pathinfo($missingISBNFileName);
          $missingISBNFileNameArray =  explode("-", $missingISBNFileInfo['filename']);
          $missingISBNJustFileName =  $missingISBNFileNameArray[0];
         //$catalogFileName = $configArray["catalog_file_location"]["location"] . "/" . $processStep . "_catalog_" . $dateSuffix . ".txt";
         $catalogFileName = $configArray["catalog_file_location"]["location"] . "/" . $missingISBNJustFileName . "-" .$processStep . "-catalog" . ".txt";
         $processStepsCatalogFileHandles[$processStep] = fopen($catalogFileName, "w+") or die ("Cannot open" . $catalogFileName . "\n");
       }
       $catalogFileHandle = $processStepsCatalogFileHandles[$processStep];

       if ( $processStep != "publishers") {
         $scriptFile = $processStep . ".php";
       } else {
         $scriptFile = "";
       }

       /* Run the specific script */
       if ( $scriptFile != null ) {
        require_once($scriptFile);
        $outputstring = "Process Step=". $processStep . ":Processing ISBN=" . $newisbnno;
        $books = call_user_func($processStep . "_start",  4, array($scriptFile, $newisbnno, $title, $author));
        // Check the validity of the books
        if($books != null ) {
         $validBooks = validBooks($books);
         $noOfInvalidBooks = $noOfInvalidBooks + (count($books)-count($validBooks));
        } else {
         $validBooks = null;
        }
        if(!is_null($validBooks) && !empty($validBooks)) {
         $processStepHits["$processStep"]++;
         $bookFound = true;
         writeBooksToCatalog($validBooks, $catalogFileHandle);
         $outputstring .= ":FOUND\n";
        } else {
         $outputstring .= ":NOTFOUND\n";
        }
        logMessage($logFile, $outputstring);
       } 
      }
     $counter++;
    }
    if ( $bookFound ) {
     $noOfISBNFound++;
    }
    // Get the process steps and then execute the individual scripts to find the isbn
    $totalLinesProcessed++; 
    sleep(1);
   } // End of while loop

  $outputstring= "Process Steps Details Totals\n";
  $outputstring  .= print_r($processStepHits, true);
  logMessage($logFile, $outputstring);
  $outputstring= "Total No of lines processed=" . $totalLinesProcessed . ": No of isbns found=" . $noOfISBNFound . ":No of invalid books found=" . $noOfInvalidBooks . "\n"; 
  logMessage($logFile, $outputstring);
  /* Close all the open files */
  fclose($missingISBNFile);
  foreach($processStepsCatalogFileHandles as $fileHandle) {
   fclose($fileHandle);
  }
  fclose($logFile);
}

updatecatalog_start($argc, $argv);

?>
