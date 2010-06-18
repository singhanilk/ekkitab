<?php

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
	global $insideitem, $tag, $title, $description, $isbn13, $isbn10, $author, $weeksOnList, $thisWeek;
		if ($name == "BOOK") {
		echo "\t<BOOK id=" . $isbn13. " title=". $title. " author=". $author. "/>\n";
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

$xml_parser = xml_parser_create();
xml_set_element_handler($xml_parser, "startElement", "endElement");
xml_set_character_data_handler($xml_parser, "characterData");
$fp = fopen("http://api.nytimes.com/svc/books/v2/lists.xml?list=trade-fiction-paperback&api-key=7445911964368f98ebf72c87c2d12913:19:60451432","rb")
	or die("Error reading RSS data.");
print "ISBN\tWeeks On List\tCurrent Rank\n"; 
echo "<SECTION title=\"New York Times BestSellers (Fiction)\" type=\"collection\" showall=\"yes\" highlight=\"5\" shuffle=\"yes\">\n";
while ($data = fread($fp, 3355443))
	xml_parse($xml_parser, $data, feof($fp))
		or die(sprintf("XML error: %s at line %d", 
			xml_error_string(xml_get_error_code($xml_parser)), 
			xml_get_current_line_number($xml_parser)));
echo "</SECTION>\n";                       
fclose($fp);
xml_parser_free($xml_parser);

?>