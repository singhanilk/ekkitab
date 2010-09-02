<?php

/* Please NOTE the names of the function have to be prefixed with the file name.
 * The file name is defined as a process step in the updatecatalog.ini
 * To run this file as it is please comment out the last line 
*/

function ingram_getBooks($bookIds, $db){
  $books = null; 

  if ( $bookIds == null ) {
    return $books;
  }

  # The catalog row
  #ISBN  TITLE   AUTHOR  BINDING DESCRIPTION PUBLISH-DATE    PUBLISHER   PAGES   LANGUAGE    WEIGHT  DIMENSION   SHIP-REGION SUBJECT
  $bookQuery = " select id,isbn, isbn10, title,author, binding, description, " .
               " publishing_date, publisher, pages, language, weight, dimension, shipping_region, bisac_codes as subject from books " .
               " where id in ( " . implode(",", $bookIds) . " )";
  #print_r($bookQuery);
  
  $bookResult = mysqli_query($db,$bookQuery);
  if ( $bookResult == FALSE ){
   return $books;
  }
  $books = Array();
  while($row  = mysqli_fetch_object($bookResult)) {
       $tmpArray['isbn'] = $row->isbn;
	     $tmpArray['title'] = $row->title;
	     $tmpArray['author'] = $row->author;
	     $tmpArray['binding'] = $row->binding;
	     $tmpArray['description'] = $row->description;
	     $tmpArray['publishdate'] = $row->publishing_date;
	     $tmpArray['publisher'] = $row->publisher;
	     $tmpArray['pages'] = $row->pages;
	     $tmpArray['language'] = $row->language;
	     $tmpArray['weight'] = $row->weight;
	     $tmpArray['dimension'] = $row->dimension;
	     $tmpArray['shipregion'] = $row->shipping_region;
	     $tmpArray['subject'] = $row->subject;
       $books[] = $tmpArray;
  } 
  /* Check the database for the book and then get the details out */
  return $books;
}

function ingram_searchIndex($isbnno, $title, $author, $javabridgeIncludePath, $luceneIndexPath){
  $bookIds =null;

  require_once($javabridgeIncludePath);

  try {
  $search = new java("com.ekkitab.search.BookSearch", $luceneIndexPath);
  $results = $search->lookup($author, $title);
  if ($results) {
    $resultBookIds = $results->getBookIds();
    if (!java_is_null($resultBookIds)) {
        for ($i = 0; $i < java_cast($resultBookIds->size(), "integer"); $i++) {
            $bookIds[] = java_cast($resultBookIds->get($i), "integer"); 
        }
    }
   } else {
      print_r("No books were returned\n");
      $bookIds = null;
  }
 } catch ( exception $e ){
      print_r($e->getmessage());
      $bookIds = null;
 }
  #print_r($bookIds);
  return $bookIds;
}

function ingram_getDetails($config, $isbnno, $title, $author, $db){

	$javabridgeIncludePath = $config['javabridge']['include_path'];
  $luceneIndexPath = $config['lucene_index']['index_path'];

  $start = (float) array_sum(explode(' ', microtime()));
  $bookIds = ingram_searchIndex($isbnno, $title, $author, $javabridgeIncludePath, $luceneIndexPath);
  $end = (float) array_sum(explode(' ', microtime()));
  $time = sprintf("%.1f", ($end - $start));

  $books = ingram_getBooks($bookIds,$db); 
  return $books;
}


function ingram_start($argc, $argv) {
  if ($argc < 4) {
   print_r("Usage: $argv[0] <i> <author> <title>\n");
   exit(1);
  }

  $isbnno = $argv[1];
  $title =  $argv[2];
  $author = $argv[3];

  $config = parse_ini_file('updatecatalog.ini', true); 
  $db = initDatabase($config);
  return ingram_getDetails($config, $isbnno, $title, $author, $db);
}

//ingram_start($argc, $argv);

?> 
