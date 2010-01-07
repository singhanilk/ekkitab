<?php
   error_reporting(E_ALL  & ~E_NOTICE);

   if ($argc <= 1) {
      echo "No Search data file provided.... Exiting.\n";
      echo "Usage: ".$argv[0]." <search data file> [ <Zend lib> ] [ <search index location> ]\n"; 
      exit(1);
   }
   else {
      $searchfile = $argv[1];
   }

   if ($argc <= 2) {
      echo "No Zend Search library specified. Proceeding anyway...\n";
      $basedir = "/tmp";
   }
   else {
      $zendlib = $argv[2];
      ini_set(include_path, ${include_path}.":".$zendlib);
      if ($argc == 4) {
           $basedir = $argv[3];
      }
      else {
           $basedir = "/tmp";
      }
   }

   require_once 'Zend/Search/Lucene.php';
   require_once 'Zend/Search/Lucene/Interface.php';
   include 'magento_db_constants.php';

   function addDocumentToIndex($data) {

      static $index;
      global $basedir;

      if ($index && ($data == null)) {
         $index->commit();
         return $index->count();
      }

      if ($index == null) {
         $index = Zend_Search_Lucene::create("$basedir"."/"."ekkitab_search_index");
      }    
      
      $doc = new Zend_Search_Lucene_Document();
      $doc->addField(Zend_Search_Lucene_Field::unIndexed('entityId',  $data[0]));
      $doc->addField(Zend_Search_Lucene_Field::Text('author',  $data[1]));
      $doc->addField(Zend_Search_Lucene_Field::Text('title',  $data[2]));
      $doc->addField(Zend_Search_Lucene_Field::UnIndexed('image',  $data[3]));
      $doc->addField(Zend_Search_Lucene_Field::UnIndexed('url',  $data[4]));
    
      $index->addDocument($doc);
      return 0;
   }

   function queryIndex($query) {

      static $index;
      global $basedir;

      if ($index == null) {
         $index = new Zend_Search_Lucene("$basedir"."/"."ekkitab_search_index");
      }    
    
      $query = Zend_Search_Lucene_Search_QueryParser::parse($query);
      $hits = $index->find($query);

      return $hits;
   }

   $i = 1;
   $start = (float) array_sum(explode(' ', microtime()));
   $fh = fopen($searchfile, "r");
   while ($line = fgets($fh)) {
      $data = explode("\t", $line);
      if (count($data) == 5) {
        addDocumentToIndex($data);
      }
      else
        echo "Bad Data!\n"; 

      if ($i++%1000 == 0) {
        $end = (float) array_sum(explode(' ', microtime()));
        echo $i. " documents indexed in ". sprintf("%.4f", ($end - $start)) . " seconds.\n";
      }
   }
   $docs = addDocumentToIndex(null);

   $end = (float) array_sum(explode(' ', microtime()));
   echo "Indexing completed. " . $docs." documents indexed in ". sprintf("%.4f", ($end - $start)) . " seconds.\n";

   while ($query = readline("What do you want to search for? ")) {

        $hits = queryIndex($query);
        echo "Search for '".$query."' returned " .count($hits). " hits\n";
        foreach ($hits as $hit) {
            echo "Author: " . $hit->author . "\n";
            echo "Title: " . $hit->title . "\n";
            echo "Image: " . $hit->image . "\n";
            echo "Url: " . $hit->url . "\n";
        }
    }

?>   
