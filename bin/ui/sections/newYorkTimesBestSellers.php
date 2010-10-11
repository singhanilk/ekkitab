<?php
/* The following are the list names for the New York Time Best Sellers which can be used for.
   This following xml result is obtained from the following call
   http://api.nytimes.com/svc/books/v2/lists/names.xml?api-key=7445911964368f98ebf72c87c2d12913:19:60451432
   Date : 11/Oct/2010 - Prasad Potula

<result_set>
<status>OK</status>
<copyright>Copyright (c) 2010 The New York Times Company.  All Rights Reserved.</copyright>
<num_results>14</num_results>
 <results>
   <result><list_name>Hardcover Fiction</list_name></result>
   <result><list_name>Hardcover Nonfiction</list_name></result>
   <result><list_name>Hardcover Advice</list_name></result>
   <result><list_name>Paperback Nonfiction</list_name></result>
   <result><list_name>Paperback Advice</list_name></result>
   <result><list_name>Trade Fiction Paperback</list_name></result>
   <result><list_name>Picture Books</list_name></result>
   <result><list_name>Chapter Books</list_name></result>
   <result><list_name>Paperback Books</list_name></result>
   <result><list_name>Series Books</list_name></result>
   <result><list_name>Mass Market Paperback</list_name></result>
   <result><list_name>Hardcover Graphic Books</list_name></result>
   <result><list_name>Paperback Graphic Books</list_name></result>
   <result><list_name>Manga</list_name></result></results>
</result_set>

*/ 

/* New York Base List API url */
$baseListUrl = "http://api.nytimes.com/svc/books/v2/lists.xml?list=";
$apiKey =  "api-key=7445911964368f98ebf72c87c2d12913:19:60451432";
/* Output is in xml format or ini format */
$outputType = "xml";
$insideitem = false;
$tag = "";
$title = "";
$description = "";
$isbn10 = "";
$isbn13 = "";
$author = "";
$weeksOnList = "";
$thisWeek = "";
$count = 0;

function startElement($parser, $name, $attrs) {
	global $insideitem, $tag, $title, $description, $isbn13, $isbn10, $author, $weeksOnList, $thisWeek;
	if ($insideitem) {
		$tag = $name;
	} elseif ($name == "BOOK") {
		$insideitem = true;
	}
}

function endElement($parser, $name) {
	global $insideitem, $tag, $title, $description, $isbn13, $isbn10, $author, $weeksOnList, $thisWeek, $outputType;
		if ($name == "BOOK") {
    if ( $outputType == "ini" ) {
      echo $isbn13. "=0" . "\t". $title . "\t" . $author . "\n";
    } else {
		  echo "\t<BOOK id=" . $isbn13. " title=". $title. " author=". $author. "/>\n";
    }
		$title = "";
		$description = "";
		$isbn10 = "";
		$isbn13 = "";
		$author = "";
		$weeksOnList = "";
		$thisWeek = "";
		$insideitem = false;
	}
}

function characterData($parser, $data) {
	global $insideitem, $tag, $isbn10, $isbn13, $description, $author, $title, $weeksOnList, $thisWeek;
	if ($insideitem) {
	switch ($tag) {
		case "ISBN10":
		$isbn10 = $data;
		break;
		case "ISBN13":
		$isbn13 = $data;
		break;
		case "TITLE":
		$title = $data;
		break;
		case "AUTHOR":
		$author = $data;
		break;
		case "DESCRIPTION":
		$description = $data;
		break;
		case "WEEKS_ON_LIST":
		$weeksOnList = $data;
		break;
		case "RANK":
		$thisWeek = $data;
		break;
	}
	}
}

/* Main function for New York Times Best Sellers */
function ny_start($argc, $argv) {
   global $baseListUrl;
   global $apiKey;
   global $outputType;

   $list_names = Array();

   if ( $argc < 3 ){
     echo "Usage newYorkTimesBestSellers category(fiction|nonfiction|both) output_type (ini|xml) ( Note Management books are not part of this automated api ) \n";
     exit();
   }

  $category = $argv[1];
  $outputType = $argv[2];

  /* Set up the categories. Have to map to the New York Times categories */
  if ( $category == "fiction") {
    $list_names[]= "hardcover-fiction";
    $list_names[]= "trade-fiction-paperback";
  } elseif ( $category == "nonfiction" ) { 
    $list_names[]= "hardcover-nonfiction";
    $list_names[]= "paperback-nonfiction";
  } elseif ( $category == "both" ) {
    $list_names[]= "hardcover-fiction";
    $list_names[]= "trade-fiction-paperback";
    $list_names[]= "hardcover-nonfiction";
    $list_names[]= "paperback-nonfiction";
  }

  foreach($list_names as $list ) {
    // Create the parser.

    $xml_parser = xml_parser_create();
    xml_set_element_handler($xml_parser, "startElement", "endElement");
    xml_set_character_data_handler($xml_parser, "characterData");

    $url = $baseListUrl . "$list" . "&" . $apiKey;
    $fp = fopen($url, "rb") or die("Error reading RSS data.");
    if ( $outputType == "xml" ) {
     print "ISBN\tWeeks On List\tCurrent Rank\n"; 
     echo "<SECTION title=\"New York Times BestSellers ($list)\" type=\"collection\" showall=\"yes\" highlight=\"5\" shuffle=\"yes\">\n";
    }
    while ($data = fread($fp, 3355443)) {
	    xml_parse($xml_parser, $data, feof($fp)) 
      or die(sprintf("XML error: %s at line %d", 
			 xml_error_string(xml_get_error_code($xml_parser)), 
			 xml_get_current_line_number($xml_parser)));
     }
    if ( $outputType == "xml" ) {
     echo "</SECTION>\n";                       
    }
    // Free
    fclose($fp);
    xml_parser_free($xml_parser);
  }
}
ny_start($argc, $argv );

?>
