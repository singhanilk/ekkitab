<?php
include "convertisbn.php";

function start($argc, $argv) {
   if ( $argc < 4 ){
     echo "Usage extractimages <Image locations text file>  <Image output directory name > <Temporary directory while processing >\n";
     echo $argc;
     exit();
   }
   
   $imageLocationFile = fopen($argv[1], "r") or die ("Cannot open the file");
   $outputdirname = $argv[2];
   $tmpdirname = $argv[3];
   $tmpfilelistname = "tmpfilelist";
   $lastisbn = "";
   $i = 0; 
   $counter = 0; 
   $nooffilestocopy = 2;
   $totallinesprocessed=0;
   $noofimagesmoved=0;
   $outputdirs = array("0", "1", "2", "3", "4");
   $logfile=fopen("extractimages.log", "a+") or die("Cannot open the file");

   /* Create the numbered directories under the output directory */
   foreach ( $outputdirs as $dir ){
    if ( !file_exists ( $outputdirname . "/" . $dir )) {
      mkdir($outputdirname . "/" . $dir );  
    }
   }

   while (!feof($imageLocationFile)){ 
    $totallinesprocessed++;
    $tmpString = rtrim(fgets($imageLocationFile));   
    $values = explode("	", $tmpString);   
    $isbnno = $values[0];
    $location = $values[1];

    if ( $lastisbn == ""){
     $i = 0;
    } elseif ( $lastisbn != $isbnno){
      $counter=0;
     // Check the tmpdir and list the files in order of size.
     system("ls -S1 ". $tmpdirname . " > " . $tmpfilelistname);
     $tmpfilelistnamehandle = fopen($tmpfilelistname, "r") or die("Cannot open the file");
     while (!feof($tmpfilelistnamehandle)){ 
       if ( $counter > $nooffilestocopy - 1 ) {
          break;
       }
       $imagefile = rtrim(fgets($tmpfilelistnamehandle));   
       if ( $imagefile != "" ){
         $moveisbnno = explode("_", $imagefile);   
         $dirno = explode(".", $moveisbnno[1]);
         system("mv ". $tmpdirname . "/" . $imagefile . " " . $outputdirname . "/" . $dirno[0] . "/". $moveisbnno[0] . ".jpg" );
         $noofimagesmoved++;
       }
      $counter++;
     }
     fclose($tmpfilelistnamehandle);
     system("rm " . $tmpdirname . "/* >/dev/null 2>&1");
     $i = 0;
    } else {
     $i++;
    }
    if(strlen($isbnno) < 12){
        $newisbnno = isbn10to13($isbnno);
    } else {
        $newisbnno = $isbnno;
    }
    $outputFileName = $tmpdirname . "/" . $newisbnno . "_" . $i . ".jpg" ;
    if ( $location != "NOIMAGE"){
      $command = "wget " . $location . " -O " . $outputFileName . " >/dev/null 2>&1";
      system($command);
    }
   $lastisbn = $isbnno;
   echo "Processed ISBN--" . $lastisbn . "\n";
   } // End of while loop
 system("rm " . $tmpfilelistname );
 fclose($imageLocationFile);
 $outputstring= "File Processed=" . $imageLocationFile . ": No of lines processed=" . $totallinesprocessed . ": No of images moved=" . $noofimagesmoved . "\n"; 
 fwrite($logfile, $outputstring);
 fclose($logfile);
}

start($argc, $argv);
?>
