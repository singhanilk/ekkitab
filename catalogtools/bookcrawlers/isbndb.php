<?php

global $ekkitabhome;

/* The xml which is returned  by ISBN by this call is as follows 

  <ISBNdb server_time="2010-07-05T19:55:29Z"> 
   <BookList total_results="1" page_size="10" page_number="1" shown_results="1"> 
     <BookData book_id="thief_of_time" isbn="0061031321" isbn13="9780061031328"> 
      <Title>Thief of time</Title> 
      <TitleLong>Thief of time: a novel of Discworld</TitleLong> 
      <AuthorsText>Terry Pratchett</AuthorsText> 
      <PublisherText publisher_id="harpertorch">New York, N.Y. : HarperTorch, [2002], c2001.</PublisherText> 
      <Details change_time="2009-04-27T14:46:45Z" price_time="2010-07-04T20:45:57Z" edition_info="(pbk.)" language="eng" physical_description_text="378 p. ; 18 cm." lcc_number="PR6066" dewey_decimal_normalized="823.914" dewey_decimal="823/.914" /> 
     </BookData> 
   </BookList> 
  </ISBNdb> 

*/

function formatAuthor($author) {

 if ( $author != null ) {
   if(stripos($author, ",") != false ){
     $names = explode(",", $author);
   } else {
     $names = explode(" ", $author);
   }
   return trim($names[1]) . "," . trim($names[0]);
 } else {
  return "";
 }
}

/**
 * Get a web file (HTML, XHTML, XML, image, etc.) from a URL.  Return an
 * array containing the header fields and content.
 */
function isbndb_getWebPage( $url ) {

    $options = array( 'http' => array(
        'user_agent'    => 'ekkitabspider',    // who am i
        'max_redirects' => 10,          // stop after 10 redirects
        'timeout'       => 120,         // timeout on response
    ) );

    try {
      $context = stream_context_create( $options );
      $page    = file_get_contents($url, false, $context );
    } catch ( exception $e ) {
      return null;
    }

    $result  = array( );
    if ( $page != false )
        $result['content'] = $page;
    else if ( !isset( $http_response_header ) )
        return null;    // Bad url, timeout

    // Save the header
    $result['header'] = $http_response_header;

    // Get the *last* HTTP status code
    $nLines = count( $http_response_header );
    for ( $i = $nLines-1; $i >= 0; $i-- )
    {
        $line = $http_response_header[$i];
        if ( strncasecmp( "HTTP", $line, 4 ) == 0 )
        {
            $response = explode( ' ', $line );
            $result['http_code'] = $response[1];
            break;
        }
    }
    return $result;
}

function isbndb_getDetails($config, $isbnno) {
  $isbndbURL = $config["isbndb"]["url"];
  $isbndbURL .= $isbnno;
  $books = Array();

  // Call the ISBNDB Api to get the result array.
  $webPageResult = isbndb_getWebPage($isbndbURL);
  /* Check if the content is there and then convert it into a DOM. 
  $xmlParser = xml_parser_create();
  xml_parse_into_struct($xmlParser, $webPageResult["content"], $resultArray, $index);
  xml_parser_free($xmlParser);
  print_r($resultArray);
  */
  $xmlObject = simplexml_load_string($webPageResult["content"]);
  if ( $xmlObject != null ) {
    $bookListCounter = 0; 
    while ( $xmlObject->BookList[$bookListCounter] != null ){
     $bookDataCounter = 0;
     while( $xmlObject->BookList[$bookListCounter]->BookData[$bookDataCounter] != null ){
	      $book = array();
        $book['isbn'] = (string)$xmlObject->BookList[$bookListCounter]->BookData[$bookDataCounter]['isbn13']; 
	      $book['title'] = (string)$xmlObject->BookList[$bookListCounter]->BookData[$bookDataCounter]->Title; 
	      $book['author'] = formatAuthor((string)$xmlObject->BookList[$bookListCounter]->BookData[$bookDataCounter]->AuthorsText); 
	      $book['binding'] = "";
	      $book['description'] = '';
	      $book['publishdate'] = '';
	      $book['publisher'] = '';
	      $book['pages'] = "";
	      $book['language'] = '';
	      $book['weight'] = "";
	      $book['dimension'] = "";
	      $book['shipregion'] = "";
	      $book['subject'] = '';
        $books[] = $book;
        $bookDataCounter++;
     } 
     $bookListCounter++; 
    }
  }
  return $books; 
}

/* 
** The main start function which will be called 
*/
function isbndb_start($argc, $argv) {
   global $ekkitabhome;

   $ekkitabhome = getenv("EKKITAB_HOME");
   if (empty($ekkitabhome)) {
    echo "EKKITAB_HOME is not set. Cannot continue.\n";
    exit(1);
   }

 	 if ($argc < 2) {
       echo "Usage: $argv[0] <isbn number>\n";
       exit(1);
    }
 	  $isbnno = $argv[1];          
    $config = parse_ini_file('updatecatalog.ini', true); 
  	try {
  		$books = isbndb_getDetails($config, $isbnno);
  	} catch (Exception $e) {
    	echo "Data fetch exception: " . $e->getMessage() . "\n";
	  	if (strpos($e->getMessage(), "API quota on volume feeds") > 0) {
	  		  echo "Detected quota limit reached. Exiting...\n";
      		exit(1);
    	}
      $books = array();
  	}
   return($books);
}

isbndb_start($argc, $argv);

?>

