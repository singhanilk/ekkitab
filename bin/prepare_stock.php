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

// This script processes all excel stock files located in the target directory and
// creates the corresponding text files that can be processed by process_stock.php
// afterwards.

  ini_set(include_path, ${include_path}.PATH_SEPARATOR.EKKITAB_HOME."/"."config");
  include("ekkitab.php");

  /**
    * Read and return the configuration data from file.
    */
    function getConfig($file) {
        $config = parse_ini_file($file, true);
        if (! $config) {
            echo "Configuration file missing or incorrect.\n";
            exit(1);
        }
        return $config;
    }


    function process($directory, $config) {

        global $files_processed;
        global $files_failed;
        global $files_ignored;

        if (!is_dir($directory))
            return;

        echo "Processing directory: $directory\n";
        $count = 0;

        $dir = opendir($directory);
        if (! $dir) {
            echo "Failed to open source directory. $directory\n";
            return;
        }

		while ($file = readdir($dir)) {
		    if (($file == ".") || ($file == ".."))
			   continue;
			if (is_dir($directory."/".$file)) {
			   process($directory."/".$file, $config); 
			}
			else {
               if ((strlen($file) > 4) && (substr($file, strlen($file) - 4, 4) == ".xls")) {
                   $plugin = strtolower(basename($directory));
                   $processorhome = $config['general']['processorhome'];
                   $outputdir = $config['general']['outputdir'];
                   if (isset($config[$plugin])) {
                        $processor = $config[$plugin]['processor'];
                   }
                   else {
                        $processor = "";
                   }
                   if (is_executable($processorhome . "/" . $processor)) {
                        echo "Running... " . $processor . " on '" . $file . "'\n";
                        $outputfile = str_replace(".pl","", $processor) . "-stocklist.txt";
                        $commandline = $processorhome . "/" . $processor . " '" . $directory . "/" . $file . "' >  " . $outputdir . "/" . $outputfile;
                        $success = system($commandline, $returnvalue);
                        if ($returnvalue != 0) {
                             echo "  ...failed.\n";
                             $files_failed++;
                        }
                        else {
                             echo "  ...passed.\n";
                             $files_processed++;
                        }
                   }
                   else {
                        if ($processor == "") {
                            echo "Processor for file $file in directory $directory is not available.\n";
                        }
                        else {
                            echo "Processor $processor is not executable or could not be found.\n";
                        }
                   }
               }
               else {
                   echo "File $file is not an excel file and is being ignored.\n";
                   $files_ignored++;
               }
			}
		}
    }


    $files_processed = 0;
    $files_failed    = 0;
    $files_ignored   = 0;

    //get the location of the stock files from the config.

    $config = getConfig(STOCK_PROCESS_CONFIG_FILE);
    $startdir = $config['general']['home'];
    process($startdir, $config); 

	echo "Processed: $files_processed  Failed: $files_failed  Ignored: $files_ignored.\n";

?>
