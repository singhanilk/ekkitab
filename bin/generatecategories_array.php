<?php

function initXML($name) {
    return simplexml_load_file($name);
}

function addHeader($fh) {
   fprintf($fh, "%s\n", '/**');
   fprintf($fh, "%s\n", ' *');
   fprintf($fh, "%s\n", ' * categories.php');
   fprintf($fh, "%s\n", ' * generated on: ' . date('d-m-y:h-i a'));
   fprintf($fh, "%s\n", ' * COPYRIGHT (C) 2009-10 Ekkitab Educational Services India Pvt. Ltd.');
   fprintf($fh, "%s\n", ' * This is a generated file. Please do not edit. If you wish to change the contents');
   fprintf($fh, "%s\n", ' * please change the xml source and regenerate this file.');
   fprintf($fh, "%s\n", ' *');
   fprintf($fh, "%s\n", ' */');
}

if ($argc < 3) {
   echo "Usage: $argv[0] -i <Input XML file> [ -o <Output Directory> ]\n";
   exit(1);
}

$inputfile = "";
$outputdir = ".";

for ($i = 1; $i < $argc; $i+=2) {
    if ($argv[$i][0] == '-') {
        if (($i+1) >= $argc) {
            echo "Incomplete arguments. No value supplied for $i\n";
            exit(1);
        }
        switch($argv[$i][1]) {
            case 'i': $inputfile = $argv[$i+1];
                      break;
            case 'o': $outputdir = $argv[$i+1];
                      break;
            default:  break;
        }
    }
    else {
        echo "Unknown argument $i\n";
        exit(1);
    }
}

if (!strcmp($inputfile, "")) {
    echo "No input file provided....\n";
    exit(1);
} 

$xml = initXML($inputfile);

$htmlfile = $outputdir . "/" . "categories.php";

$fhtml = fopen($htmlfile, "w");
if (!$fhtml) {
    echo "Could not open file to create phtml output for menu.\n";
    exit(1);
}

fprintf($fhtml, "%s\n", '<?php');
addHeader($fhtml);
fprintf($fhtml, "\n");
$z = 0;
fprintf($fhtml, "%s\n", '$categories = array();');

foreach ($xml as $parentCategory) {
    if ($parentCategory['name']!="") {
		fprintf($fhtml, "%s\n", '$categories[\''.$z.'\']= "'.$parentCategory['name'] . '";');
		$z ++;
    }
}
fprintf($fhtml, "%s\n", '?>');
fclose($fhtml);

?>
