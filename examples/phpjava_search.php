<?php
//
// This is an example of how you can can access a running Java VM
// to execute a Java class and get and use the returned results in PHP.
// This is very rough coding and has no proper exception handling. Beware!

$db  = mysqli_connect("localhost", "root", "zen1000", "reference");
if (!$db) {
    echo "Could not connect to database.\n";
    exit(1);
}
function getBookDetails($id) {
    global $db;
    $query = "select author,title from books where id = '" . $id . "'"; 
    $result = mysqli_query($db, $query);
    if ($result && (mysqli_num_rows($result) > 0)) {
	   $book = mysqli_fetch_array($result);
       return $book;
    }
    else {
       return null;
    }
}

require_once("http://localhost:8080/JavaBridge/java/Java.inc");
do {
   $search = new java("com.ekkitab.search.BookSearch", "/var/www/scm/magento/search_index_dir");
   $query = readline("Search for? ");
   $query = $query == null ? "" : $query;
   $category = readline("Category? ");
   $category = $category == null ? "" : $category;
   $page = readline("Page? ");
   $page = $page == null ? "1" : $page;
   $pagenum = $page + 0;

   $start = (float) array_sum(explode(' ', microtime()));
   $page_sz = 15;
   echo "Search query: '".$query."'  category: '".$category."'  Page: '".$pagenum."'\n";
   $results = $search->searchBook($category, $query, $page_sz, $pagenum);
   $end = (float) array_sum(explode(' ', microtime()));
   $time = sprintf("%.1f", ($end - $start));
    
   if ($results) {
      $suggest = $results->getSuggestQuery();
      if (($suggest != null) && (strlen($suggest) > 0)) {
        echo "Your search query returned zero results.\n";
        echo "Did you mean: " . trim($suggest) . " instead?\n";
      }
      $hitcount = $results->getHitCount();
      $books = $results->getBookIds();
      if (!java_is_null($books)) {
        echo "Size of returned book list is: " . $books->size() . "\n";
        for ($i = 0; $i < java_cast($books->size(), "integer"); $i++) {
            $id = $books->get($i);
            $book = getBookDetails($id);
            echo "Author: " . $book['author'] . "\n";
            echo "Title: " . $book['title'] . "\n";
            echo "------------------------\n";
            if ($i >= 6) {
                break;
            }
        } 
      }
      $subcats = $results->getResultCategories();
      if (!java_is_null($subcats)) {
         $retsize = $subcats->size();
         echo "Size of Category List:[" . $retsize . "]\n"; 
         $keys = $subcats->keySet();
         foreach($keys as $key) { 
            $val = $subcats->get($key);
            echo "Category: $key [$val]\n";
         }
      }
      echo "Returned: $hitcount hits in $time seconds.\n";
   }
   else 
      echo "No results were returned. \n";
} while (($query = readline("Continue? ")) && (!strcmp(strtolower($query), "y")));
echo "Exiting...\n";

?> 
