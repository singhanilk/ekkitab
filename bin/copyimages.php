<?php
error_reporting(E_ALL  & ~E_NOTICE);
ini_set("display_errors", 1); 
$EKKITAB_HOME=getenv("EKKITAB_HOME");
if (strlen($EKKITAB_HOME) == 0) {
    echo "EKKITAB_HOME is not defined...Exiting.\n";
    exit(1);
}
else {
    define(EKKITAB_HOME, $EKKITAB_HOME); 
}

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

  ini_set(include_path, ${include_path}.PATH_SEPARATOR.EKKITAB_HOME."/"."config");
  include("ekkitab.php");
  ini_set(include_path, ${include_path}.PATH_SEPARATOR.EKKITAB_HOME."/"."bin");
  include("imagehash.php");
  include("convertisbn.php");

  /**
   * Generate correct image path for thumbnails and images.
   */
   function getImagePath($imagefile){
         $firstchar = substr($imagefile, 0, 1);
         $secondchar = substr($imagefile, 1, 1);
         return ("/" . $firstchar . "/" . $secondchar);
   }

   function copyfiles($directory) {
        global $files_copied;
        global $files_failed;
        global $files_ignored;

        if (!is_dir($directory))
            return;

        echo "Copying files in directory: $directory\n";
        $count = 0;

        $dir = opendir($directory);
        if (! $dir) {
            echo "Failed to open source directory. $directory\n";
            return;
        }
		$pfile = $directory."/.processed";
		if(file_exists($pfile)){
			return;
		}
		else {
			while ($file = readdir($dir)) {
				if (($file == ".") || ($file == ".."))
					continue;
				if (is_dir($directory."/".$file)) {
					copyfiles($directory."/".$file); 
				}
				else {
					$newfile = str_replace(".JPG", ".jpg", $file);
					if ((strlen($newfile) > 4) && (substr($newfile, strlen($newfile) - 4, 4) == ".jpg")) {
                        $isbn = substr($newfile, 0, strpos($newfile, ".jpg"));
                        if (strlen($isbn) == 10) {
                            echo "converting $newfile\n";
                            $newfile = convertisbn($isbn) . ".jpg";
                        } 
                        if (strlen($newfile) == 17) { //13 isbn digits and 4 for the suffix
						    $imagePath = getHashedPath($newfile);
						    if (!is_dir(dirname(IMAGE_TARGET . "/" . $imagePath)))
							    mkdir(dirname(IMAGE_TARGET . "/" . $imagePath), 0755, true); 
						    $success = copy($directory . "/" . $file, IMAGE_TARGET . "/" . $imagePath);
						    if (! $success) {
							    $files_failed++;
						    }
						    else {
						        $files_copied++;
						    }
                        }
					}
					else 
						$files_ignored++;
					
				}
				
			}
			$pfile = $directory."/.processed";
			$fh = fopen($pfile,"w");
			fclose($fh);
			echo "Copied: $files_copied  Failed: $files_failed  Ignored: $files_ignored.\n";
		}
   }

  if ($argc < 2) {
      echo "Insufficient arguments. Exiting...\n";
      echo "Usage: $argv[0] <source image directory>\n";
      exit (1);
  }
  $files_copied = 0;
  $files_failed = 0;
  $files_ignored = 0;

  copyfiles($argv[1]);

?>

