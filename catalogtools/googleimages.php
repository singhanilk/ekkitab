<?php

global $ekkitabhome;

/**
 * Get a web file (HTML, XHTML, XML, image, etc.) from a URL.  Return an
 * array containing the header fields and content.
 */
function googleimages_getWebPage( $url ) { 
    $options = array( 'http' => array(
        'user_agent'    => 'random',    // who am i
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

/* 
** The main start function which will be called 
*/
function googleimages_start($argc, $argv) {
   global $ekkitabhome;

   $ekkitabhome = getenv("EKKITAB_HOME");
   if (empty($ekkitabhome)) {
    echo "EKKITAB_HOME is not set. Cannot continue.\n";
    exit(1);

   }
   if ( $argc < 3 ){
     echo "Usage googleimages <Image locations text file>  <Image output directory name >\n";
     exit();
   }
   
   $imageLocationFile = fopen($argv[1], "r") or die ("Cannot open the file");
   $outputdirname = $argv[2];

    while (!feof($imageLocationFile)){ 
     $isbnno = rtrim(fgets($imageLocationFile));   
     if(is_null($isbnno) or empty($isbnno)){
       break; 
     }
     /* Obtain the search result page first */
     $htmlString = googleimages_getWebPage("http://www.google.com/search?tbs=bks:1&tbo=1&q=".$isbnno."&btnG=Search+Books");
     /* Get the URL for Book Overview */
     //$matchCount = preg_match('/<a href="http:\/\/books.google.com\/books.*" class=fl>Book overview/',$htmlString['content'], $matches);
     $matchCount = preg_match('/<table class=ts><tr><td class=bkst><a href.*><img/',$htmlString['content'], $matches);
     $tokens = explode('"', $matches[0]);
     $sizeOfTokens=count($tokens);
     //print_r($tokens);
     /* Obtain the Book Overview Page */
     $htmlString = googleimages_getWebPage($tokens[$sizeOfTokens-2]);
     /* Get the URL for the front cover */
     preg_match('/<div class="bookcover">.*summary-frontcover/',$htmlString['content'], $matches);
     $tokens = explode('"', $matches[0]);
     $imageIndex = 0;
     foreach($tokens as $token) {
       if(stripos($token, "img src")){
         break;
       }
       $imageIndex++;
     }
     /* Get the image */
     if(!stripos($tokens[$imageIndex+1], "no_cover_thumb")) {
       $htmlString = googleimages_getWebPage($tokens[$imageIndex+1]);
       $imageData = $htmlString['content'];
       $imageFile = fopen($outputdirname. "/". $isbnno . ".jpg", "w");
       fwrite($imageFile, $htmlString['content']);
       fclose($imageFile);
     }
    }
   fclose($imageLocationFile);
}
  

googleimages_start($argc, $argv);
?>

