<?php

function initXML($name) {
    return simplexml_load_file($name);
}

function addHeader($fh) {
   fprintf($fh, "%s\n", '/**');
   fprintf($fh, "%s\n", ' *');
   fprintf($fh, "%s\n", ' * menuitems.php');
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

$inifile  = $outputdir . "/" . "leftmenu.ini";
$htmlfile = $outputdir . "/" . "menuitems.php";

//$fh = fopen($inifile, "w");
//if (!$fh) {
//    echo "Could not open file to create menu properties.\n";
//    exit(1);
//}

$fhtml = fopen($htmlfile, "w");
if (!$fhtml) {
    echo "Could not open file to create phtml output for menu.\n";
    exit(1);
}

fprintf($fhtml, "%s\n", '<?php');
addHeader($fhtml);
fprintf($fhtml, "%s\n", '$sections = array();');
fprintf($fhtml, "%s\n", '$collections = array();');
fprintf($fhtml, "\n");

$collections = "";
$z = 0;
foreach ($xml as $section) {
    fprintf($fhtml, "%s\n", '$sections['.$z.'][\'header\'] = ' . "\"" . $section['title'] . "\";");
    fprintf($fhtml, "\n");
    foreach ($section as $link) {
        fprintf($fhtml, "%s\n", '$sections['.$z.'][\'link\'][] = ' .  "\"" . $link['name'] . "\";");

        if (!strcmp($link['type'],"collection")) {
            $key = strtolower(preg_replace('/\W+/', '_', $link['name']));
            $ids = "";
            $k = 0;
            $collections .= sprintf("%s\n", '$collections[\'' . $key . '\'] = array();');
            foreach ($link as $id) {
                $collections .= sprintf("%s\n", '$collections[\'' . $key . '\'][' . $k . '] = ' . "\"" . $id  . "\";");
                $k++;
                //$ids .= (string)$id . ",";
            }
            $collections .= sprintf("\n");
            //$ids = preg_replace('/,$/', '', $ids);
            //fprintf($fh, "%s=%s\n", $key, $ids);
            fprintf($fhtml, "%s\n", '$sections['.$z.'][\'url\'][] = ' . "\"" . 'ekkitab_catalog/leftlinks/view/details/' . $key .".html\";");
        }
        elseif (!strcmp($link['type'], "search")) {
            $name = (string)$link->SEARCH;
            $field = "";
            foreach ($link as $search) {
                $field = $search['field'];
            }
            if (!strcmp($field, "author")) {
                fprintf($fhtml, "%s\n", '$sections['.$z.'][\'url\'][] = ' .  "\"" . '/ekkitab_catalog/search/index/author/' . $name . "\";");
            }
            elseif (!strcmp($field, "category")) {
                fprintf($fhtml, "%s\n", '$sections['.$z.'][\'url\'][] = ' .  "\"" . '/ekkitab_catalog/search/index/category/' . $name . "\";");
            }
        }
        fprintf($fhtml, "\n");
    }
    $z++;
    fprintf($fhtml, "\n");
}
fprintf($fhtml, "%s\n", $collections);

//fclose($fh);
// add debug
fprintf($fhtml, "%s\n", '/*');
fprintf($fhtml, "%s\n", 'foreach ($sections as $section) {');
fprintf($fhtml, "   %s\n", 'echo ">>> " . $section[\'header\'] . "\n";');
fprintf($fhtml, "   %s\n", 'for ($i=0; $i < count($section[\'link\']); $i++) {');
fprintf($fhtml, "       %s\n",'echo "  >>> " . $section[\'link\'][$i] . "\n";');
fprintf($fhtml, "       %s\n",'echo "  >>> " . $section[\'url\'][$i] . "\n";');
fprintf($fhtml, "   %s\n",'}');
fprintf($fhtml, "%s\n", '}');
fprintf($fhtml, "%s\n", '*/');

fprintf($fhtml, "%s\n", '?>');
fclose($fhtml);

?>
