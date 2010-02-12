<?php
//
// This is an example of how you can can access a running Java VM
// to execute a Java class and get and use the returned results in PHP.
// This is very rough coding and has no proper exception handling. Beware!

require_once("http://localhost:8080/JavaBridge/java/Java.inc");
do {
   $search = new java("BookSearch", "/var/www/scm/magento/search_index_dir");
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
      $hitcount = $results->get("hits");
      $books = $results->get("books");
      if (!java_is_null($books)) {
        $sz = java_values($books->size());
        $iter = $books->iterator();
        for ($i=0; $i<$sz; $i++) {
            $book = $books->get($i);
            $author = $book->get("author");
            $title = $book->get("title");
            $image = $book->get("image");
            $url = $book->get("url");
            $id = $book->get("entityId");
            $price = $book->get("listprice");
            $discountprice = $book->get("discountprice");
            $description = $book->get("shortdesc");
            $isbn = $book->get("isbn");
            $binding = $book->get("binding");
            $language = $book->get("language");
            $instock = $book->get("instock");
            $delivertime = $book->get("delivertime");
            echo "Author: $author\n";
            echo "Title: $title\n";
            echo "Id: $id\n";
            echo "ISBN: $isbn\n";
            echo "------------------------\n";
        } 
        $subcats = $results->get("counts");
        if (!java_is_null($subcats)) {
            $retsize = $subcats->size();
            echo "Size of Category List:[" . $retsize . "]\n"; 
            $keys = $subcats->keySet();
            foreach($keys as $key) { 
                $val = $subcats->get($key);
                echo "Category: $key [$val]\n";
            }
        }
      }
      echo "Returned: $hitcount hits in $time seconds.\n";
   }
   else 
      echo "No results were returned. \n";
} while ($query = readline("Continue? ")) 

?> 
