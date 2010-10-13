<?php
$imageDirectory = $argv[1];
if ($handle = opendir($imageDirectory)) {
    while (false !== ($file = readdir($handle))) {
        if ($file != "." && $file != "..") {
           $filename = $imageDirectory . "/". $file;
           if(is_file($filename)){
             $source = explode(".", $file);
             if($source[1] == "png" ) {
               $commandString = "convert " . escapeshellarg($filename) . " " . escapeshellarg($imageDirectory . "/" . trim($source[0]) . ".jpg");
               system($commandString);
             }
           } 
        }
    }
    closedir($handle);
}
?>
