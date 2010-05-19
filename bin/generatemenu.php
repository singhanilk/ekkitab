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

function printCollectionSection($fh, $z, $section, $books) {
   
    printSectionHeader($fh, $z, "collection", $section['header']); 
    fprintf($fh, "%s\n", '$sections[\''.$z.'\'][\'shuffle\'] = "'.$section['shuffle'] . '";');
    fprintf($fh, "%s\n", '$sections[\''.$z.'\'][\'showall\'] = "'.$section['showall'] . '";');
    fprintf($fh, "%s\n", '$sections[\''.$z.'\'][\'highlight\'] = '.$section['highlight'] . ";");
    fprintf($fh, "%s\n", '$books[\''.$z.'\'] = array();');
    for ($i=0; $i< count($books); $i++) {
        fprintf($fh, "%s\n", '$books[\''.$z.'\']['.$i.'] = array();');
        fprintf($fh, "%s\n", '$books[\''.$z.'\']['.$i.'][\'id\'] = '. "\"" .$books[$i]['id'] . "\";");
        fprintf($fh, "%s\n", '$books[\''.$z.'\']['.$i.'][\'title\'] = '. "\"" .$books[$i]['title'] . "\";");
        fprintf($fh, "%s\n", '$books[\''.$z.'\']['.$i.'][\'author\'] = '. "\"" .$books[$i]['author'] . "\";");
    }
}

function printSectionHeader($fh, $z, $type, $title) {
    fprintf($fh, "%s\n", '$sections[\''.$z.'\'] = array();');
    fprintf($fh, "%s\n", '$sections[\''.$z.'\'][\'header\'] = "'. $title . '";');
    fprintf($fh, "%s\n", '$sections[\''.$z.'\'][\'type\'] = "'. $type . '";');
}

function printCollectionLink($fh, $z, $name, $ids) {
   
    $key = strtolower(preg_replace('/\W+/', '_', $name));;

    fprintf($fh, "%s\n", '$sections[\''.$z.'\'][\'' . $key . '\'] = array();');
    fprintf($fh, "%s\n", '$sections[\''.$z.'\'][\'' . $key . '\'][\'name\'] = "'. $name . '";');
    fprintf($fh, "%s\n", '$sections[\''.$z.'\'][\'' . $key . '\'][\'url\'] = "ekkitab_catalog/leftlinks/view/details/' . $key . ".html\";");
    fprintf($fh, "%s\n", '$books[\''.$key.'\'] = array();');
    for ($i=0; $i< count($ids); $i++) {
        fprintf($fh, "%s\n", '$books[\''.$key.'\']['.$i.'] = '. "\"" .$ids[$i]. "\";");
    }
}

function printSearchLink($fh, $z, $name, $field) {
   
    $key = strtolower(preg_replace('/\W+/', '_', $name));;
    $url = "ekkitab_catalog/search/index/" . $field . "/" . $name;

    fprintf($fh, "%s\n", '$sections[\''.$z.'\'][\'' . $key . '\'] = array();');
    fprintf($fh, "%s\n", '$sections[\''.$z.'\'][\'' . $key . '\'][\'name\'] = "'. $name . '";');
    fprintf($fh, "%s\n", '$sections[\''.$z.'\'][\'' . $key . '\'][\'url\'] = "' . $url . '";');
}

function printUtilityFunctions($fh) {
   fprintf($fh, "%s\n", 'function getNumberOfSections() {');
   fprintf($fh, "%s\n", '   global $sections;');
   fprintf($fh, "%s\n", '   return count($sections);');
   fprintf($fh, "%s\n", '}');
   fprintf($fh, "%s\n", '');
   fprintf($fh, "%s\n", 'function getHeader($id) {');
   fprintf($fh, "%s\n", '   global $sections;');
   fprintf($fh, "%s\n", '   if (isset($sections[$id])) {');
   fprintf($fh, "%s\n", '       return $sections[$id][\'header\'];');
   fprintf($fh, "%s\n", '   }');
   fprintf($fh, "%s\n", '}');
   fprintf($fh, "%s\n", '');
   fprintf($fh, "%s\n", 'function getLinks($id) {');
   fprintf($fh, "%s\n", '   global $sections;');
   fprintf($fh, "%s\n", '   global $books;');
   fprintf($fh, "%s\n", '');
   fprintf($fh, "%s\n", '   $result = array();');
   fprintf($fh, "%s\n", '   if (!isset($sections[$id])) {');
   fprintf($fh, "%s\n", '       return $result;');
   fprintf($fh, "%s\n", '   }');
   fprintf($fh, "%s\n", '   if ($sections[$id][\'type\'] == "collection") {');
   fprintf($fh, "%s\n", '       if (!isset($books[$id])) {');
   fprintf($fh, "%s\n", '           return $result;');
   fprintf($fh, "%s\n", '       }');
   fprintf($fh, "%s\n", '       if ($sections[$id][\'shuffle\'] == "yes") {');
   fprintf($fh, "%s\n", '           shuffle($books[$id]);');
   fprintf($fh, "%s\n", '       }');
   fprintf($fh, "%s\n", '       for ($i=0; $i < $sections[$id][\'highlight\']; $i++) {');
   fprintf($fh, "%s\n", '           $link = array();');
   fprintf($fh, "%s\n", '           $url = strtolower(preg_replace("/\W+/", "_", $books[$id][$i][\'title\'])) . "__" . $books[$id][$i][\'id\'];');
   fprintf($fh, "%s\n", '           $name = $books[$id][$i][\'title\'] . " __by__ " . $books[$id][$i][\'author\'];');
   fprintf($fh, "%s\n", '           $link[\'name\'] = $name;');
   fprintf($fh, "%s\n", '           $link[\'url\'] = "ekkitab_catalog/product/view/book/" . $url . ".html";');
   fprintf($fh, "%s\n", '           $result[] = $link;');
   fprintf($fh, "%s\n", '       }');
   fprintf($fh, "%s\n", '       if ($sections[$id][\'showall\'] != "") {');
   fprintf($fh, "%s\n", '           $link = array();');
   fprintf($fh, "%s\n", '           $link[\'name\'] = "[". $sections[$id][\'showall\'] . "]";');
   fprintf($fh, "%s\n", '           $link[\'url\'] = "ekkitab_catalog/leftlinks/view/details/" . $id . ".html";');
   fprintf($fh, "%s\n", '           $result[] = $link;');
   fprintf($fh, "%s\n", '       }');
   fprintf($fh, "%s\n", '   }');
   fprintf($fh, "%s\n", '   elseif ($sections[$id][\'type\'] == "links") {');
   fprintf($fh, "%s\n", '       foreach($sections[$id] as $link) {');
   fprintf($fh, "%s\n", '           if (is_array($link)) {');
   fprintf($fh, "%s\n", '               $result[] = $link;     ');
   fprintf($fh, "%s\n", '           }');
   fprintf($fh, "%s\n", '       }');
   fprintf($fh, "%s\n", '   }');
   fprintf($fh, "%s\n", '   return $result;');
   fprintf($fh, "%s\n", ' }');
   fprintf($fh, "%s\n", '');
   fprintf($fh, "%s\n", ' function getBooksForKey($key) {');
   fprintf($fh, "%s\n", '   global $books;');
   fprintf($fh, "%s\n", '   $ids = array();');
   fprintf($fh, "%s\n", '   if (!isset($books[$key])) {');
   fprintf($fh, "%s\n", '       return $ids;');
   fprintf($fh, "%s\n", '   }');
   fprintf($fh, "%s\n", '   foreach($books[$key] as $book) {');
   fprintf($fh, "%s\n", '       if (is_array($book)) {');
   fprintf($fh, "%s\n", '           $ids[] = $book[\'id\'];');
   fprintf($fh, "%s\n", '       }');
   fprintf($fh, "%s\n", '       else {');
   fprintf($fh, "%s\n", '           $ids[] = $book;');
   fprintf($fh, "%s\n", '       }');
   fprintf($fh, "%s\n", '   }');
   fprintf($fh, "%s\n", '   return $ids;');
   fprintf($fh, "%s\n", ' }');
}

function printDebugCode($fh, $commented) {

   if ($commented) {
        fprintf($fh, "%s\n", '/*');
   }
   fprintf($fh, "%s\n", 'echo "The number of sections is: " . getNumberOfSections() . "\n";');
   fprintf($fh, "%s\n", '');
   fprintf($fh, "%s\n", '$c = getNumberOfSections();');
   fprintf($fh, "%s\n", '');
   fprintf($fh, "%s\n", '$keys = array_keys($sections);');
   fprintf($fh, "%s\n", 'foreach ($keys as $key) {');
   fprintf($fh, "%s\n", '   echo "Header: " . getHeader($key) . "\n"; ');
   fprintf($fh, "%s\n", '}');
   fprintf($fh, "%s\n", '');
   fprintf($fh, "%s\n", 'foreach ($keys as $key) {');
   fprintf($fh, "%s\n", '   $links = getLinks($key);');
   fprintf($fh, "%s\n", '   foreach($links as $link) {');
   fprintf($fh, "%s\n", '       echo "Link name: " . $link[\'name\'] . "\n";');
   fprintf($fh, "%s\n", '       echo "Link url: " . $link[\'url\'] . "\n";');
   fprintf($fh, "%s\n", '   }');
   fprintf($fh, "%s\n", '}');
   fprintf($fh, "%s\n", '');
   fprintf($fh, "%s\n", ' $ids = getBooksForKey("the_man_booker_prize");');
   fprintf($fh, "%s\n", ' echo "Book Ids for the Man Booker Prize \n";');
   fprintf($fh, "%s\n", ' foreach($ids as $id) {');
   fprintf($fh, "%s\n", '       echo "Book Id: " . $id . "\n";');
   fprintf($fh, "%s\n", ' }');
   fprintf($fh, "%s\n", '');
   fprintf($fh, "%s\n", ' $ids = getBooksForKey("new_york_times_bestsellers");');
   fprintf($fh, "%s\n", ' echo "Book Ids for the New York Times Bestsellers\n";');
   fprintf($fh, "%s\n", ' foreach($ids as $id) {');
   fprintf($fh, "%s\n", '       echo "Book Id: " . $id . "\n";');
   fprintf($fh, "%s\n", ' }');
   if ($commented) {
        fprintf($fh, "%s\n", '*/');
   }
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
fprintf($fhtml, "\n");

printUtilityFunctions($fhtml);

$z = 0;
fprintf($fhtml, "%s\n", '$sections = array();');
fprintf($fhtml, "%s\n", '$books = array();');

foreach ($xml as $section) {
    if ($section['type'] == "collection") {
        $shuffle = "no";
        $highlight = 0;
        $showall = "";
        
        if (isset($section['highlight'])) {
            $highlight = (int)$section['highlight'];
        }
        if (isset($section['showall'])) {
            $showall = $section['showall'];
        }
        if (isset($section['shuffle'])) {
            $shuffle = $section['shuffle'];
        }

        $phpbooks = array(); 
        $i = 0;
        foreach ($section as $book) {
            $phpbooks[$i]['id'] = $book['id'];
            $phpbooks[$i]['title'] = $book['title'];
            $phpbooks[$i]['author'] = $book['author'];
            $i++;
        }
        $phpsections = array();
        $phpsections['header'] = $section['title']; 
        $key = strtolower(preg_replace('/\W+/', '_', $section['title'])); 
        $phpsections['shuffle'] = $shuffle; 
        $phpsections['showall'] = $showall; 
        $phpsections['highlight'] = $highlight; 
        $phpsections['type'] = "collection"; 
        printCollectionSection($fhtml, $key, $phpsections, $phpbooks);
    }
    elseif ($section['type'] == "links") {
        $key = strtolower(preg_replace('/\W+/', '_', $section['title']));; 
        $ids = array();
        printSectionHeader($fhtml, $key, "links", $section['title']);
        foreach($section as $link) {
            if ($link['type'] == "collection") {
                $name = $link['name'];
                foreach ($link as $book) {
                    $ids[] = $book['id'];
                }
                printCollectionLink($fhtml, $key, $name, $ids);
            }
            elseif ($link['type'] == "search") {
                $name = (string)$link->SEARCH;
                $field = "";
                foreach ($link as $search) {
                   $field = $search['field'];
                }
                printSearchLink($fhtml, $key, $name, $field);
            }
        }
    }
}
printDebugCode($fhtml, true);
fprintf($fhtml, "%s\n", '?>');
fclose($fhtml);

?>
