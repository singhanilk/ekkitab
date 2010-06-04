<?php
//
// This is an example of how you can can access a running Java VM
// to execute a Java class and get and use the returned results in PHP.
// This is very rough coding and has no proper exception handling. Beware!

require_once("http://localhost:8080/JavaBridge/java/Java.inc");
echo "Sequential Ekkitab Database query.\n";
do {
   $search = new java("com.ekkitab.search.BookSearch", "/var/www/scm/magento/search_index_dir");
   $page = readline("Page? ");
   $page = $page == null ? "1" : $page;
   $pagenum = $page + 0;
   $page_sz = 15;

   $start = (float) array_sum(explode(' ', microtime()));
   $results = $search->searchSequential($page_sz, $pagenum);
   $end = (float) array_sum(explode(' ', microtime()));
   $time = sprintf("%.1f", ($end - $start));
    
   if ($results) {
      $books = $results->getBookIds();
      if (!java_is_null($books)) {
        echo $books->size() . " books returned in $time sec.\n";
        echo "( ";
        for ($i = 0; $i < java_cast($books->size(), "integer"); $i++) {
            echo  $books->get($i) . " "; 
        }
        echo ")\n";
      }
   }
   else {
      echo "No books were returned.\n";
   }
} while (($query = readline("Continue? ")) && (!strcmp(strtolower($query), "y")));
echo "Exiting...\n";

?> 
