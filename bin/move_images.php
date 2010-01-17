<?php

 
//  
//
// COPYRIGHT (C) 2009 Ekkitab Educational Services India Pvt. Ltd.  
// All Rights Reserved. All material contained in this file (including, but not 
// limited to, text, images, graphics, HTML, programming code and scripts) constitute 
// proprietary and confidential information protected by copyright laws, trade secret 
// and other laws. No part of this software may be copied, reproduced, modified 
// or distributed in any form or by any means, or stored in a database or retrieval 
// system without the prior written permission of Ekkitab Educational Services.
//
// @author Arun Kuppuswamy (arun@ekkitab.com)
// @version 1.0     Jan 15, 2010




// This Script will copy the images of those books the are present ekkitab database to appropriate media folder.....

    define ("tgdir","../magento/media/catalog/product");
    define ("srcdir","../images");
    define ("SELECT_LIMIT", 5000);

    include("move_images_config.php");
    require_once(LOG4PHP_DIR . '/LoggerManager.php');

    // global logger
    $logger =& LoggerManager::getLogger("loadbooks");

    $dbs = array();

   /** 
    * Log the error and terminate the program.
    * Optionally, will accept the query that failed.
    */
    function fatal($message, $query = "") {
        global $logger;
        global $dbs;
	    $logger->fatal("$message " . "[ $query ]" . "\n");
        mysqli_close($dbs['ref_db']);
        exit(1);
    }

   /** 
    * Read and return the configuration data from file. 
    */
    function getConfig($file) {
       $config   = parse_ini_file($file, true);
        if (!$config) {
            fatal("Configuration file missing or incorrect."); 
        }
        return $config;
    }


   /** 
    * Initialize ekkitab and reference databases.
    */
    function initDatabases($config) {

        if (! $config) 
            return NULL;

       $database_server = $config[database][server];
       $database_user   = $config[database][user];
       $database_psw    = $config[database][password];
       $ekkitab_db      = $config[database][ekkitab_db];
       $ref_db          = $config[database][ref_db];

       $db  = NULL;

       $db     = mysqli_connect($database_server,$database_user,$database_psw,$ref_db);
       return array( ref_db => $db);
   }

   /** 
    * Return books from the reference database for which the update flag is set.  
    * Max books returned is determined by $limit.
    */
   function getBooksFromRefDB($db, $limit, $from){
      $query = "select * from books where books.new = 1 limit $from, $limit";
      $result = mysqli_query($db,$query);
      if ($result && (mysqli_num_rows($result) > 0))
         return $result;
      else
         return NULL;
    }
   
   /** 
   * Generate correct image path for thumbnails and images. 
   */
   function getImagePath($imagefile){
         $firstchar = substr($imagefile, 0, 1);
         $secondchar = substr($imagefile, 1, 1);
           return ("/" . $firstchar . "/" . $secondchar);
    }

   /** 
    * Set the books update flag to 'updated' in the reference database.  
    */
   
   function updateRefDb($db, $isbn) {
      $query = "update books set books.new = 2 where books.isbn = '$isbn'";
      $books = mysqli_query($db,$query);
      if (!$books) {
         fatal("Could not update reference database.", $query);
      }
    }
      
   /** 
    * Main function.  
    */
    function start(){

      global $dbs;
      global $logger;

      $config = getConfig(MOVE_IMAGES_INI);
      $dbs = initDatabases($config);
         
      $from  = 0;
      $books_processed = 0;
      $files_copied    = 0;
      $timer = 0;
      $start = (float) array_sum(explode(' ', microtime()));

      while ($books = getBooksFromRefDB($dbs['ref_db'], SELECT_LIMIT, $from)) {
         while ($book = mysqli_fetch_array($books)) {
             $imagefile = $book['IMAGE'];
             $tgPath = getImagePath($imagefile);
             if (!is_dir(tgdir . $tgPath)) 
                mkdir(tgdir . $tgPath, 755, true);
             $tgPath  = tgdir.$tgPath."/".$imagefile;
             $srcPath = srcdir."/".$imagefile;
             if(file_exists($srcPath)){
                copy($srcPath,$tgPath);
                updateRefDb($dbs['ref_db'], $book['ISBN']);
                $files_copied++;
             }
             $books_processed++;
         }
         $timer += (float)array_sum(explode(' ', microtime())) - $start;
         $from = $from + SELECT_LIMIT; 
         $logger->info("Processed $books_processed books. Copied $files_copied image files. In " . sprintf("%.2f", $timer/60) . "minutes.");
      }
      mysqli_close($dbs['ref_db']);
    } 

    $logger->info("Process started at " . date("d-M-Y G:i:sa"));
    start();
    $logger->info("Process ended at " . date("d-M-Y G:i:sa"));

?>
