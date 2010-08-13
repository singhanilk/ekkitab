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
            echo "Fatal: Configuration file missing or incorrect.\n";
            exit(1);
        }
        return $config;
    }

    function process($directory, $archivedir, $config) {

        global $files_processed;
        global $files_failed;
        global $files_ignored;

        static $currentplugin = "";

        if (!is_dir($directory))
            return;

        //echo "Processing directory: $directory\n";
        $count = 0;

        $dir = opendir($directory);
        if (! $dir) {
            echo "Warning: Failed to open source directory. $directory\n";
            return;
        }

        while ($file = readdir($dir)) {
            if (($file == ".") || ($file == ".."))
               continue;
            if (is_dir($directory."/".$file)) {
               process($directory."/".$file, $archivedir, $config); 
            }
            else {
               $extn = strtolower(substr($file, strlen($file) - 4, 4));
               $extn_html = strtolower(substr($file, strlen($file) - 5, 5));
               if ((strlen($file) > 4) && (($extn == ".xls") || ($extn == ".pdf") || ($extn_html == ".html"))) {
                   if ($extn == ".pdf") {
                        $shell_safe_file = escapeshellarg($file);
                        $pdf_file = "$directory/$shell_safe_file";
                        $command = 'pdftohtml -noframes ' . $pdf_file . '>/dev/null';
                        $returnvalue = -1;
                        $success = system($command, &$returnvalue);
                        if ($returnvalue != 0) { // failure
                            echo "[Prepare Stock] Could not convert $file to html for further processing.\n";
                            $files_failed++;
                            continue;
                        }
                        if ($archivedir != "") {
                            $outputdir = $archivedir . "/" . $plugin;
                            if (!file_exists($outputdir)) {
                                mkdir($outputdir, 0755, true);
                            }
                            $sourcefile = $directory . "/" . $file;
                            $targetfile = $outputdir . "/" . $file;
                            rename($sourcefile, $targetfile);
                         }
                         $file = substr($file, 0, strlen($file) - 4) . ".html";
                   }
                   $lower_directory = strtolower(basename($directory));
                   $plugin = str_replace(" ","",$lower_directory);
                   if ($config[$plugin]['concatfiles'] == 1) {
                        if (strcmp($currentplugin, $plugin)) { //first file to be processed in this directory
                            $filewritemode = ">";
                        }
                        else {
                            $filewritemode = ">>";
                        }
                   }
                   else {
                        $filewritemode = ">";
                   }
                   $currentplugin = $plugin;
                   $processorhome = $config['general']['processorhome'];
                   $outputdir = $config['general']['stocklistdir'];
                   if (isset($config[$plugin]['processor'])) {
                        $processor = $config[$plugin]['processor'];
                   }
                   else {
                        $processor = "";
                   }
                   if (($processor != "") && is_executable($processorhome . "/" . $processor)) {
                        // echo "Running... " . $processor . " on '" . $file . "'\n";
                        $outputfile = str_replace(".pl","", $processor) . "-stocklist.txt";
                        $commandline = $processorhome . "/" . $processor . " '" . $directory . "/" . $file . "' " . $filewritemode . "  " . $outputdir . "/" . $outputfile . " 2>/dev/null";
                        $success = system($commandline, &$returnvalue);
                        if ($returnvalue != 0) {
                             // echo "  ...failed.\n";
                             echo "[Prepare Stock] Processor $processor failed on file $file.\n";
                             $files_failed++;
                        }
                        else {
                             // echo "  ...passed.\n";
                             // move the processed file to archive
                             if ($archivedir != "") {
                                $outputdir = $archivedir . "/" . $plugin;
                                if (!file_exists($outputdir)) {
                                    mkdir($outputdir, 0755, true);
                                }
                                $sourcefile = $directory . "/" . $file;
                                $targetfile = $outputdir . "/" . $file;
                                rename($sourcefile, $targetfile);
                             }
                             $files_processed++;
                        }
                   }
                   else {
                        if ($processor == "") {
                            echo "[Prepare Stock] Processor for file $file in directory $directory is not available.\n";
                        }
                        else {
                            echo "[Prepare Stock] Processor $processor is not executable or could not be found.\n";
                        }
                        $files_failed++;
                   }
               }
               else {
                    echo "[Prepare Stock] [Warning] File $file is not a proper input file and is being ignored.\n";
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
    $archivedir = "";
    if (!isset($config['general']['archive'])) {
       echo "[Prepare Stock] No archive directory set. Will not archive files.\n";
    }
    else {
       $archivedir = $config['general']['archive'];
    }

    if ($argc > 1) {
       $startdir .= "/" . strtolower($argv[1]); 
    }

    if (!file_exists($startdir)) {
        echo "[Prepare Stock] [Fatal] Directory $startdir does not exist or is not readable. \n";
        exit(1);
    }

    process($startdir, $archivedir, $config); 
    
    echo "[Prepare Stock] Processed: $files_processed  Failed: $files_failed  Ignored: $files_ignored.\n";
    exit ($files_failed);
?>

