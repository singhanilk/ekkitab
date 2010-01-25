<?php
//
// This is an example of how you can can access a running Java VM
// to execute a Java class and get and use the returned results in PHP.
// This is very rough coding and has no proper exception handling. Beware!

require_once("http://localhost:8080/JavaBridge/java/Java.inc");
$search = new java("BookSearch", "/var/www/scm/magento/search_index_dir");
while ($query = readline("What do you want to search for? ")) {
        $start = (float) array_sum(explode(' ', microtime()));
        $page_sz = 10;
        $page = 1;
        $results = $search->searchBook($query, $page_sz, $page);
        $end = (float) array_sum(explode(' ', microtime()));
        $time = sprintf("%.1f", ($end - $start));
        if ($results) {
            $authors = $results->get("hitcount-author");
            $titles = $results->get("hitcount-title");
            echo "Returned: $authors hits in author field and $titles hits in titles field, in $time seconds.\n";
            $books = $results->get("books");
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
                echo "Author: $author\n";
                echo "Title: $title\n";
                echo "Url: $url\n";
                echo "Image: $image\n";
                echo "List Price: $price\n";
                echo "Discounted Price: $discountprice\n";
                echo "Id: $id\n";
                echo "------------------------\n";
            } 
        }
        else 
            echo "No results were returned. \n";
}

?> 
