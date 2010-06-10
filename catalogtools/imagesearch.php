<?php

/* imagesearch.php 
   Summary - Using Google Image javascript api to look for images on web. Gets the locations and dumps them into a file. 
   This particular php code has to be initiated from the browser. There are two entries which have to be modified to run it.
   a. The file containing the isbns with missing images
   b. The ouput file where the locations of the images have to be written.
   Uses imagesearch.html page as the template for getting the images.
*/

$missingimagesisbnfile = "missingimages.txt";
$imagelocationsfile ="imagelocations.txt";

# Read the missing images file.
function getNextIsbn($isbnFileHandle, $lastIsbn){
  $nextIsbn = "";
  $tmpString = "";

  if ( $lastIsbn == "" ){
     $nextIsbn = rtrim(fgets($isbnFileHandle));   
  } else {
   $tmpString = rtrim(fgets($isbnFileHandle));   
   while (!feof($isbnFileHandle)){ 
      if ( $tmpString == $lastIsbn){
       break;
      }else {
       $tmpString = rtrim(fgets($isbnFileHandle));   
      }
     }
    if ( feof($isbnFileHandle)){
      $nextIsbn = -1;
    } else {
      $nextIsbn = rtrim(fgets($isbnFileHandle));   
    }
   }
 return $nextIsbn;
}

function writeImageLocations($outputFileHandle, $isbn, $imagesrc){
 $outputStr = "";
 if ( !empty($imagesrc)){
   foreach ( $imagesrc as $src ){
    $outputStr .= $isbn . "\t" . $src . "\n";
   }
 } else {
  $outputStr = $isbn . "\tNOIMAGE\n";
 }
 fwrite($outputFileHandle, $outputStr);
}


function start() {
   global $missingimagesisbnfile;
   global $imagelocationsfile;

   $isbnFileHandle = fopen($missingimagesisbnfile, "r") or die ("Cannot open the file");
   $outputFileHandle = fopen($imagelocationsfile, "a+") or die ("Cannot open the file");

   $lastisbn = $_POST["lastisbn"];
  /* The main code starts here */
  /* Check if the lastISBN is passed which is -1 */
  if ( $lastisbn == "-1") {
    $outputString = "The end of the file has been reached";
  } else {
    # if lastisbn is "" that means that we need not store the image location.
    if ( !empty($lastisbn)){
      # Write the image locations to the file.
      # Get All the image tags.
      $imagesrc = $_POST["imagesrc"];
      writeImageLocations($outputFileHandle, $lastisbn, $imagesrc );
    } 
   # Read the image search html template.
   $htmlString = file_get_contents('imagesearch.html');
   #Get ISBN number from the file
   $isbnNo = getNextIsbn($isbnFileHandle, $lastisbn);
   #replace the ISBN number with a new ISBN number;
   $outputString = preg_replace("/ISBN/", $isbnNo, $htmlString);
 }
 fclose($isbnFileHandle);
 fclose($outputFileHandle);
 echo $outputString;
}

start();
?>

