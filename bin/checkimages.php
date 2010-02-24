<?php
error_reporting(E_ALL  & ~E_NOTICE);
ini_set("display_errors", 1); 

  function getMaxBooks() {
    global $db;
	$query = "select max(id) from books";
    try {
	   $result = mysqli_query($db,$query);
    }
    catch(exception $e) {
       echo("Fatal (getMaxBooks): " . $e->getmessage() . "\n");
       exit(1);
    }
    if (mysqli_num_rows($result) > 0) {
       $row = mysqli_fetch_array($result);
       return ($row[0]);
    }
    else
       return 1;
  }

  function getImagePath($id) {
    global $db;
	$query = "select image from books where id = $id";
    try {
	   $result = mysqli_query($db,$query);
    }
    catch(exception $e) {
       echo("Fatal (getImagePath): " . $e->getmessage() . "\n");
       exit(1);
    }
    if (mysqli_num_rows($result) > 0) {
       $row = mysqli_fetch_array($result);
       return ($row[0]);
    }
    else
       return 0;
  }

  
  if ($argc < 5) {
     echo "No arguments.\n";
     echo "Usage: ".$argv[0]." <host> <user> <password> <magento directory>\n";
     exit(1);
  }

  $db = null;
 
  try  {
      $db = mysqli_connect($argv[1],$argv[2],$argv[3],"reference");
  }
  catch (exception $e) {
      echo("Fatal Error:" . $e->getmessage(). "\n");
      exit(1);
  }

  $min = 1;
  $max = getMaxBooks(); 

  $imagecount = array('present' => 0, 'missing' => 0);

  for ($i = $min; $i <= $max; $i++) {
       $image = getImagePath($i);
       $fullimagepath = $argv[4] . "/media/catalog/product/" . $image;
       if (file_exists($fullimagepath)) 
            $imagecount['present']++;
       else 
            $imagecount['missing']++;
       if (($i % 10000) == 0)
           echo "Processed $i books. Present [" . $imagecount['present'] . "] Missing [" . $imagecount['missing'] . "]\n";
  }

  echo "Images present: ".$imagecount['present']."\n";
  echo "Images missing: ".$imagecount['missing']."\n";
  echo "Percent of images missing: ".($imagecount['missing']/$max)*100 ."\n";

?>

