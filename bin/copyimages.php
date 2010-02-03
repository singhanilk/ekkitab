<?php
error_reporting(E_ALL  & ~E_NOTICE);
ini_set("display_errors", 1); 

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
// @author Vijaya Raghavan (vijay@ekkitab.com)
// @version 1.0     Jan 19, 2010


// This function copies all the images in a directory (given on the command line) 
// to the final location specified in the config file. This is usually the
// magento image location.
// the same directory if not rehashed using this function.

  include("copyimages_config.php");
  ini_set(include_path, ${include_path}.":".EKKITAB_HOME."/"."bin");
  include("imagehash.php");

  /**
   * Generate correct image path for thumbnails and images.
   */
   function getImagePath($imagefile){
         $firstchar = substr($imagefile, 0, 1);
         $secondchar = substr($imagefile, 1, 1);
         return ("/" . $firstchar . "/" . $secondchar);
   }

  if ($argc < 2) {
      echo "Insufficient arguments. Exiting...\n";
      echo "Usage: $argv[0] <source image directory>\n";
      exit (1);
  }
  $dir = opendir($argv[1]);
  if (! $dir) {
      echo "Failed to open source directory. $argv[1]\n";
  }
  $sourcedir = $argv[1];
  $files_copied = 0;
  $files_failed = 0;
  while ($file = readdir($dir)) {
      if (($file == ".") || ($file == ".."))
          continue;
      $newfile = gethash($file);
      $imagePath = getImagePath($newfile);
      if (!is_dir(IMAGE_TARGET . $imagePath))
          mkdir(IMAGE_TARGET . $imagePath, 755, true); 
      $success = copy($sourcedir . "/" . $file, IMAGE_TARGET . $imagePath . "/" . $newfile);
      if (! $success) {
        $files_failed++;
      }
      else {
        $files_copied++;
      }
      if (($files_copied%1000) == 0)
         echo "Copied $files_copied files to the target location. [$files_failed] failed.\n";
  }
?>

