<?php

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

?>
