<?php
// This is not a generic script! It has been written for very specific input and in order to generate
// very specific output.
// This script takes, as input, a file which contains book data. One line per book and ISBN in field 3. 
// It then uses the googlebooks API to search for this book and extract information.
// GoogleBooks API has a quote on how many times the API can be used in one session. So on a large input
// file, this will reach the "API Quote Exceeded" error frequently. The script when re-invoked determines
// the last successful ISBN processed and continues from there.
// Whatever information that is fetched through the API is written out to a file in tab separated format.


require_once 'Zend/Loader.php';

global $ekkitabhome;
Zend_Loader::loadClass('Zend_Gdata_Books');

function printArray($elements, $separator = ",") {
	$result = '';
	foreach ($elements as $element) {
		if (!empty($result)) $result = $result.$separator;
			$result = $result.$element;
		}
	return $result;
}

/* Google specific Bisac Codes function 
** The subject is expected to be an array with topics separated with 
** The subject is expected to be an array with topics separated with 
** Returns the bisac codes separated with a comma.
*/
function googlebooks_getBisacCodes($db, $subjects) {
 $bisac_codes = array();
 if ($subjects != null) {
   foreach ($subjects as $subject) {
     $topics = explode("/", $subject);
     $query = "select bisac_code from ek_bisac_category_map where ";
     $i = 1;
     $conjunction = "";
     foreach($topics as $topic) {
      $label = "level".$i++;
      $value = strtolower(trim($topic));
      $query = $query . $conjunction . $label . " = '" . $value . "'";
      $conjunction = " and ";
     }
     $result = mysqli_query($db, $query);
     if (($result) && (mysqli_num_rows($result) > 0)) {
       $row = mysqli_fetch_array($result);
       $bisac_codes[] = $row[0];
     }
   }
  }
  if (empty($bisac_codes)) {
     /*
     if (strcmp($subjects[0], "--")) {
       foreach($subjects as $subject) {
         echo "( $subject ) ";
       }
       echo "\n";
     }
     */
     $bisac_codes[] = "ZZZ000000";
  }
  return implode(",", $bisac_codes);
}
 
/* Function which gets the book in the catalog format.
*  The catalog row is as follows
*  0			1				2				3				4						5								6						7				8						9				10					11					12
*  #ISBN  TITLE   AUTHOR  BINDING DESCRIPTION PUBLISH-DATE    PUBLISHER   PAGES   LANGUAGE    WEIGHT  DIMENSION   SHIP-REGION SUBJECT
*/
function googlebooks_getBook($db, $isbnno, $entry) {
	$book = array();
  $tmpString = '';

  /*
  print("GOOGLE ENTRY STARTS ** TITLE\n");
  print_r(printArray($entry->getTitles()));
  print("\nAUTHOR\n");
  print_r(printArray($entry->getCreators()));
  print("\nDESCRIPTION\n");
  print_r(printArray($entry->getDescriptions()));
  print("\nPUBLISHDATE\n");
  print_r(printArray($entry->getDates()));
  print("\nPUBLISHER\n");
  print_r(printArray($entry->getPublishers()));
  print("\nANNOTATION\n");
  print_r(printArray($entry->getAnnotationLink()));
  print("\nLANGUAGES\n");
  print_r(printArray($entry->getLanguages()));
  print("\nCOMMENTS\n");
  print_r($entry->getComments());
  print("\nEMBEDDABILITY\n");
  print_r(printArray($entry->getEmbeddability()));
  print("\nFORMATS\n");
  print_r(printArray($entry->getFormats()));
  print("\nIDENTIFIERS\n");
  print_r(printArray($entry->getIdentifiers()));
  print("\nINFOlINK\n");
  print_r(printArray($entry->getInfoLink()));
  print("\nVIEWABILITY\n");
  print_r(printArray($entry->getViewability()));
  print("\nSUBJECT\n");
  print_r(printArray($entry->getSubjects()));
  print("\nGOOGLE ENTRY ENDS\n");
  */ 

  $book['isbn'] = $isbnno;
	$book['title'] = htmlspecialchars_decode(printArray($entry->getTitles()), ENT_QUOTES);
	$book['author'] = htmlspecialchars_decode(printArray($entry->getCreators(), "&"), ENT_QUOTES);
	$book['binding'] = "";
	$book['description'] = htmlspecialchars_decode(printArray($entry->getDescriptions()), ENT_QUOTES);
	$book['publishdate'] = printArray($entry->getDates());
	$book['publisher'] = htmlspecialchars_decode(printArray($entry->getPublishers()), ENT_QUOTES);
	$book['pages'] = "";
	$tmString = printArray($entry->getLanguages());
  if ( $tmpString == 'en') {
   $tmpString = 'English';
  }
	$book['language'] = $tmpString;
	$book['weight'] = "";
	$book['dimension'] = "";
	$book['shipregion'] = "";
  // The subject should be changed to bisac code.
  $tmpSubject = Array();
  $tmpSubject[] = htmlspecialchars_decode(printArray($entry->getSubjects(), ":"), ENT_QUOTES);
	$book['subject'] = googlebooks_getBisacCodes($db, $tmpSubject);
  /* The following fields are obtained from google which are not being used for catalog now.
	$book['format'] = printArray($entry->getFormats());
	$book['listprice'] = 0;
	$book['currency'] = 0;
	$book['source']  = "India";
	$book['infosource'] = "";
	$book['indianpublisher'] = "";
	if ($thumbnailLink = $entry->getThumbnailLink()) {
		$thumbnail = $thumbnailLink->href;
	} else {
		$thumbnail = "";
	}
	$book['image'] = $thumbnail;
	$preview = $entry->getPreviewLink()->href;
  */
	return $book;
}

function getVolumeIds($feed) {
	$ids = array();
	foreach ($feed as $entry) {
		$volumeId = $entry->getVolumeId();
		if ($volumeId != null) {
				$ids[] = $volumeId;
		}
	}
	return $ids;
}

function googlebooks_getDetails($db,$isbnno) {
  $books = Array();
  try {
	  $gbooks = new Zend_Gdata_Books();
	  $query = $gbooks->newVolumeQuery("http://www.google.com/books/feeds/volumes");
	  $query->setQuery($isbnno);
	  $query->setStartIndex(1);
	  $query->setMaxResults(10);
	  $query->setMinViewability("none");
	  $feed = $gbooks->getVolumeFeed($query);
	  $ids = getVolumeIds($feed);
	  $books = array();
	  foreach($ids as $id) {
		  $entry = $gbooks->getVolumeEntry($id);
		  $book = googlebooks_getBook($db,$isbnno, $entry);
		  $books[] = $book;
	  }
  } catch ( exception $e ){
    $books = Array();
  }
	return $books;
}

function googlebooks_start($argc, $argv) {
   global $ekkitabhome;

   error_reporting(E_ALL  & ~E_NOTICE);
   ini_set("display_errors", 1); 

   $ekkitabhome = getenv("EKKITAB_HOME");
   if (empty($ekkitabhome)) {
    echo "EKKITAB_HOME is not set. Cannot continue.\n";
    exit(1);
   }
 	 if ($argc < 4) {
       echo "Usage: $argv[0] <isbn number> <title> <author>\n";
       exit(1);
    }
 	  $isbnno = $argv[1];          
    $config = parse_ini_file('updatecatalog.ini', true); 
    $db = initDatabase($config);
  	try {
  		$books = googlebooks_getDetails($db,$isbnno);
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

//googlebooks_start($argc, $argv);

?>

