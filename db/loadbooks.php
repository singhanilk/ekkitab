<?php
error_reporting(E_ALL  & ~E_NOTICE);
ini_set("display_errors", 1); 

//  
//
// COPYRIGHT (C) 2009 Ekkitab Educational Services India Pvt. Ltd.  
// All Rights Reserved. All material contained in this file (including, but not 
// limited to, text, images, graphics, HTML, programming code and scripts) constitute 
// proprietary and confidential information protected by copyright laws, trade secret 
// and other laws. No part of this software may be copied, reproduced, modified 
// or distributed in any form or by any means, or stored in a database or retrieval 
// system without the prior written permission of Ekkitab Educational Services.
//
// @author Arun Kuppuswamy (arun@ekkitab.com)
// @version 1.0     Nov 26, 2009
// @version 1.1     Nov 28, 2009 (vijay@ekkitab.com)
// @version 1.2     Dec 07, 2009 (arun@ekkitab.com)
// @version 1.3     Dec 10, 2009 (arun@ekkitab.com)


// This script will load BookData from the Reference Database into Magento Production Database......

    include("loadbooks_config.php");
    include("magento_db_constants.php");
	
		
    $mysqlTime = 0;
    $mysqlTimeRefDb = 0;
    $failedBooks = 0;
    $targetdir = ".";
    $dbs = array();
    $filesuffixes = array();

    require_once(LOG4PHP_DIR . '/LoggerManager.php');

    // global logger
    $logger =& LoggerManager::getLogger("loadbooks");

   /** 
    * Log the error and terminate the program.
    * Optionally, will accept the query that failed.
    */
    function fatal($message, $query = "") {
        global $logger;
        global $dbs;
	    $logger->fatal("$message " . "[ $query ]" . "\n");
        mysqli_close($dbs[ekkitab_db]);
        mysqli_close($dbs[ref_db]);
        exit(1);
    }

   /** 
    * This function will log the error.
    * Optionally, will accept the query that failed.
    */
    function warn($message, $query = "") {
        global $logger;
	    $logger->error("$message " . "[ $query ]" . "\n");
    }

   /** 
    * Read and return the configuration data from file. 
    */
    function getConfig($file) {
	    $config	= parse_ini_file($file, true);
        if (! $config) {
            fatal("Configuration file missing or incorrect."); 
        }
        return $config;
    }

   /** 
    * Initialize ekkitab and reference databases.
    */
    function initDatabases($config) {

        if (! $config) 
            return NULL;

	    $database_server = $config[database][server];
	    $database_user   = $config[database][user];
	    $database_psw    = $config[database][password];
	    $ekkitab_db      = $config[database][ekkitab_db];
	    $ref_db		     = $config[database][ref_db];

        $dbm = NULL;
        $db  = NULL;
 
        try  {
	        $dbm	= mysqli_connect($database_server,$database_user,$database_psw,$ekkitab_db);
	        $db     = mysqli_connect($database_server,$database_user,$database_psw,$ref_db);
        }
        catch (exception $e) {
           fatal($e->getmessage());
        }

        return array(ekkitab_db => $dbm, ref_db => $db);
    }

   /** 
    * Get the sequence ids from ekkitab db for various tables. 
    * These sequences are used for inserts.
    */
    function getEntityIDs($dbm) {

        $entityIDs = array();
        $queries = array();
	    $queries[] = 'select max(entity_id) from catalog_product_entity';
	    $queries[] = 'select max(value_id) from catalog_product_entity_datetime';
	    $queries[] = 'select max(value_id) from catalog_product_entity_decimal';
	    $queries[] = 'select max(value_id) from catalog_product_entity_int';
	    $queries[] = 'select max(value_id) from catalog_product_entity_int';
	    $queries[] = 'select max(value_id) from catalog_product_entity_media_gallery';
	    $queries[] = 'select max(value_id) from catalog_product_entity_text';
	    $queries[] = 'select max(value_id) from catalog_product_entity_varchar';
	    $queries[] = 'select max(item_id) from cataloginventory_stock_item';
        $queries[] = 'select max(url_rewrite_id) from core_url_rewrite';

        $i = 0;

        try {
            foreach ($queries as $query) {
	            $result  = mysqli_query($dbm, $query);
                if (! $result)
                    throw new exception("Failed on query: $query");
	            $row	 = mysqli_fetch_array($result);
	            $entityIDs[$i++] = $row[0];
            }
        }
        catch(exception $e) {
            fatal($e->getmessage());
        }

        return incrementIds($entityIDs);
    }

   /** 
    * Return the db entity id for book with given ISBN number.  
    */
	function getBookId($isbn, $dbm) {
        $row_book = array();
        $id = NULL;

		if ($isbn != NULL) {
			$query = "select * from catalog_product_entity where sku = '$isbn'";
            try {
			    $result_book = mysqli_query($dbm,$query);
                if ($result_book) 
			        $row_book = mysqli_fetch_array($result_book);
            }
            catch (exception $e) {
                warn($e->getmessage());
            }
			if(!empty($row_book)) {
				$id = $row_book['entity_id'];
			}
		}
        return $id;
	} 

   /** 
    * Return books from the reference database for which the update flag is set.  
    * Max books returned is determined by $limit.
    */
    function getBooksFromRefDB($db, $limit) {
        global $logger;
        global $failedBooks;

		$query = "select * from books where books.new = 0 limit $failedBooks, $limit";
        //$logger->info("Query: $query");
        try {
		    $result = mysqli_query($db,$query);
        }
        catch(exception $e) {
            fatal($e->getmessage());
        }
        if (mysqli_num_rows($result) > 0)
            return $result;
        else
            return NULL;
    }

   /** 
    * Set the books update flag to 'updated' in the reference database.  
    */
    function updateRefDb($db, $isbn, $id) {
		$query = "update books set books.new = 1, books.product_id = $id where books.isbn = '$isbn'";
        try {
		    $books = mysqli_query($db,$query);
            if (! $books) 
                throw new exception("Failed to update reference db for book with ISBN: $isbn.");
        }
        catch(exception $e) {
            warn("Failed to set update flag in reference db." . $e->getmessage());
        }
    }
   /** 
    * Create and return an INSERT mysql query from arguments.  
    */
    function createInsertQuery($table, $columns, $values) {

        global $targetdir;
        global $filesuffixes;
        static $fhs = array();
        static $linecount = array();

        if ($table == null) {
            foreach($fhs as $key => $fh) {
                fclose($fh);
            }
            return;
        }

        if (empty($fhs[$table])) {
            if (empty($filesuffixes[$table]))
                $filesuffixes[$table] = 0;
            $filename =  $targetdir . "/" . "loaddata-".$table."-".$filesuffixes[$table].".txt";
            $fhs[$table] = fopen($filename, "w");
            if (! $fhs[$table]) {
                fatal("Could not open file: $filename");     
            }
            $filesuffixes[$table]++;
        }

        if (empty($linecount[$table]))
            $linecount[$table] = 0;

        $query = "";
        foreach ($values as $value) {
            foreach ($value as $item) {
                $query .= "$item\t";
            }
            $query = substr($query, 0, strrpos($query, "\t"));
            fprintf($fhs[$table], "%s\n", $query);
            $query = "";
            $linecount[$table]++;
        }
        if ($linecount[$table] > FILE_ROLLOVER_LIMIT) {
            $linecount[$table] = 0;
            fclose($fhs[$table]);
            $fhs[$table] = null;
        }
    }

   /** 
    * Create and return an UPDATE mysql query from arguments.  
    */
    function createUpdateQuery($table, $value, $setvalue, $where) {
        $query = "update $table set $value = '$setvalue' where ";
        foreach ($where as $field => $value) {
            $query .= "$field = $value and ";
        }
        $query = substr($query, 0, strrpos($query, "and"));
		return $query;
    }

   /** 
    * Set auto-commit mode for database.  
    */
    function prepareDb($db) {
        global $logger;
        //$queries[0] = "set autocommit = 0";
        $queries[0] = "set foreign_key_checks = 0";
        $queries[1] = "set unique_checks = 0";
        
        try {
            foreach ($queries as $query) {
	            $result = mysqli_query($db,$query);
                if (!$result)
                    throw new exception("Failed to issue prepare db commands. [$query]");
            }
        }
        catch(exception $e) {
            fatal($e->getmessage());
        }

    }

   /** 
    * Increment all entity ids.  
    */
    function incrementIds($entityIds) {
        foreach ($entityIds as $key => $value) {
            $entityIds[$key]++;
        }
        return $entityIds;
    }

   /** 
    * Prepare entity ids for next insert after a successful insert. 
    */
    function setIdsForNextInsert($entityIds) {
        $entityIds = incrementIds($entityIds);
        $entityIds[CPEDE] += 2;
        $entityIds[CPEIN] += 4;
        $entityIds[CPETX] += 4;
        $entityIds[CPEVC] += 23;
        $entityIds[URL]   += 4;
        return $entityIds;
    }

   /** 
    * Generate correct image path for thumbnails and images. 
    */
    function getImagePath($imagefile) {
        $firstchar = substr($imagefile, 0, 1);
        $secondchar = substr($imagefile, 1, 1);
        return ("/" . $firstchar . "/" . $secondchar . "/" . $imagefile);
    }

   /** 
    * Escape all the required characters for proper SQL syntax. 
    */
    function escape($str) {
        $pattern[0] = "/[~\\\\]*'/";
        #$pattern[1] = "/\(/";
        #$pattern[1] = "/\)/";
        $replace[0] = "\'";
        #$replace[1] = "\\\(";
        #$replace[1] = "\\\)";
        return(preg_replace($pattern, $replace, $str));
    }

   /**
     * Obtains the full category path for url rewrite.
     */
     function getCategoryFullPath($book_path){
         $parts = explode("\t", $book_path);
         $paths = explode("/", $parts[1]);
         $ids   = explode(",", $parts[0]);
         $ret   = array();

         for ($i = count($ids) - 1; $i >= 0; $i--) {
           $pathname = "";
           for ($j = 0; $j <= $i; $j++)
                $pathname = $pathname . ($j == 0 ? "" : "/") . $paths[$j];
           $ret[$ids[$i]] = $pathname;
         }
         return ($ret);
     }

   /** 
    * Generates all the INSERT sqls required to insert a new book.  
    */

    function generateInsertSQLs($entityIds, $book) {

        $queries = array();
	    $url_key = $book[TITLE] . "-" . $book[ISBN];
		$url_key = str_replace("'","",$url_key);
		$url_key = str_replace(" ","-",$url_key);

		//create categories_id entry

		$book_category_ids = $book[BISAC];
        $imagepath = getImagePath($book[IMAGE]);
        $thumbnailpath = getImagePath($book[THUMB]);
		
        $val_array = array();
        $val_array[] = array($entityIds[CPE], entity_type_id, attribute_set_id, $book[ISBN], $book_category_ids);

		$queries[] = createInsertQuery("catalog_product_entity", 
                                       "entity_id, entity_type_id, attribute_set_id, sku, category_ids", 
                                       $val_array);

		$book_pdate = $book[PDATE];

        $val_array = array();
        $val_array[] = array(entity_type_id, bo_pu_date_id, store_id, $entityIds[CPE], $book_pdate);

	    $queries[] = createInsertQuery("catalog_product_entity_datetime", 
                                       "entity_type_id, attribute_id, store_id, entity_id, value",
                                       $val_array);

        if (empty($book[PRICE])) {
            $book[PRICE] = 0.0;
        }
        if (empty($book[WEIGHT])) {
            $book[WEIGHT] = 0.0;
        }

		$discount_price = empty($book[DISCOUNT_PRICE]) ? 0.0 : $book[DISCOUNT_PRICE];

        $val_array   = array();
        $val_array[] = array(entity_type_id, price_id, store_id, $entityIds[CPE], $book[PRICE]);
        $val_array[] = array(entity_type_id, special_price_id,store_id,$entityIds[CPE],$discount_price);
        $val_array[] = array(entity_type_id, weight_id,store_id,$entityIds[CPE],$book[WEIGHT]);
        $queries[] = createInsertQuery("catalog_product_entity_decimal", 
                                       "entity_type_id, attribute_id, store_id, entity_id, value",
                                       $val_array);

        if (empty($book[PRODUCT_STATUS])) {
            $book[PRODUCT_STATUS] = 0;
        }
        if (empty($book[INT_SHIPPING])) {
            $book[INT_SHIPPING] = 0;
        }

        $val_array = array();
        $val_array[] = array(entity_type_id, status_id,store_id,$entityIds[CPE],$book[PRODUCT_STATUS]);
        $val_array[] = array(entity_type_id, tax_class_id,store_id,$entityIds[CPE],tax_class_value);    
        $val_array[] = array(entity_type_id,visibility_id,store_id,$entityIds[CPE],book_visibility_value);
        $val_array[] = array(entity_type_id, enable_googlecheckout_id,store_id,$entityIds[CPE],option_enable);
        $val_array[] = array(entity_type_id, bo_int_shipping_id,store_id,$entityIds[CPE],$book[INT_SHIPPING]);
        $queries[] = createInsertQuery("catalog_product_entity_int", 
                                       "entity_type_id, attribute_id, store_id, entity_id, value",
                                       $val_array);


        $val_array = array();
        $val_array[] = array(media_gallery_id, $entityIds[CPE],"$imagepath");
        $queries[] = createInsertQuery("catalog_product_entity_media_gallery", 
                                       "attribute_id, entity_id, value",
                                       $val_array);

        $val_array = array();
        $val_array[] = array($entityIds[CPEMG],store_id,media_position);    
        $queries[] = createInsertQuery("catalog_product_entity_media_gallery_value", 
                                       "value_id, store_id, position",
                                       $val_array);


        $bookpublisher = escape($book[PUBLISHER]);
        $val_array = array();
        $val_array[] = array(entity_type_id,bo_publisher_id,store_id,$entityIds[CPE],"$bookpublisher");
        $val_array[] = array(entity_type_id, descrption_id,store_id,$entityIds[CPE],"$book[DESCRIPTION]");
        $val_array[] = array(entity_type_id, short_descrption_id,store_id, $entityIds[CPE],"$book[DESCRIPTION]");
        $val_array[] = array(entity_type_id,meta_keyword_id,store_id,$entityIds[CPE],"''"); 
        $val_array[] = array(entity_type_id,custom_layout_update_id,store_id,$entityIds[CPE],"''");
        $queries[] = createInsertQuery("catalog_product_entity_text", 
                                       "entity_type_id, attribute_id, store_id, entity_id, value",
                                       $val_array);

        $booktitle = escape($book[TITLE]);
        $bookauthor = escape($book[AUTHOR]);
        $bookedition = escape($book[EDITION]);

        $val_array = array();
        $val_array[] = array(entity_type_id,name_id,store_id,$entityIds[CPE],$booktitle);
        $val_array[] = array(entity_type_id,meta_title_id,store_id,$entityIds[CPE],value_empty);
        $val_array[] = array(entity_type_id,meta_description_id,store_id,$entityIds[CPE],value_empty);
        $val_array[] = array(entity_type_id,url_key_id,store_id,$entityIds[CPE],$url_key);
        $val_array[] = array(entity_type_id,url_id,store_id,$entityIds[CPE],$url_key.".html");
        $val_array[] = array(entity_type_id,options_container,store_id,$entityIds[CPE],options_container_value);
        $val_array[] = array(entity_type_id,image_label_id,store_id,$entityIds[CPE],value_empty);
        $val_array[] = array(entity_type_id,small_image_label_id,store_id,$entityIds[CPE],value_empty);
        $val_array[] = array(entity_type_id,thumb_label_id,store_id,$entityIds[CPE],value_empty);
        $val_array[] = array(entity_type_id,gift_message_avialable_id,store_id,$entityIds[CPE],gift_message_value);
        $val_array[] = array(entity_type_id,bo_author_id,store_id,$entityIds[CPE],$bookauthor);
        $val_array[] = array(entity_type_id,bo_isbn_id,store_id,$entityIds[CPE],$book[ISBN]);
        $val_array[] = array(entity_type_id,bo_binding_id,store_id,$entityIds[CPE],$book[BINDING]);
        $val_array[] = array(entity_type_id,bo_isbn10_id,store_id,$entityIds[CPE],$book[ISBN10]);
        $val_array[] = array(entity_type_id,bo_language_id,store_id,$entityIds[CPE],$book[LANGUAGE]);
        $val_array[] = array(entity_type_id,bo_no_pg_id,store_id,$entityIds[CPE],$book[PAGES]);
        $val_array[] = array(entity_type_id,bo_dimension_id,store_id,$entityIds[CPE],$book[DIMENSION]);
        $val_array[] = array(entity_type_id,bo_illustrator_id,store_id,$entityIds[CPE],$book[ILLUSTRATOR]);
        $val_array[] = array(entity_type_id,bo_edition_id,store_id,$entityIds[CPE],$bookedition);
        $val_array[] = array(entity_type_id,bo_rating_id,store_id,$entityIds[CPE],$book[RATING]);
        $val_array[] = array(entity_type_id,bo_image_id,store_id,$entityIds[CPE], $imagepath);
        $val_array[] = array(entity_type_id,bo_small_image_id,store_id,$entityIds[CPE], $imagepath);
        $val_array[] = array(entity_type_id,bo_thumb_image_id,store_id,$entityIds[CPE], $thumbnailpath);
        $val_array[] = array(entity_type_id,bo_shipping_region_id,store_id,$entityIds[CPE], $book[SHIPPING_REGION]);
        $val_array[] = array(entity_type_id,bo_sourced_from,store_id,$entityIds[CPE], $book[SOURCED_FROM]);
        $queries[] = createInsertQuery("catalog_product_entity_varchar", 
                                       "entity_type_id, attribute_id, store_id, entity_id, value",
                                       $val_array);

        $val_array = array();
        $val_array[] = array(1,$entityIds[CPE],tax_class_id,tax_class_value);
		$queries[] = createInsertQuery("catalogindex_eav", 
                                       "store_id, entity_id, attribute_id, value",
                                       $val_array);


        $val_array = array();
        $val_array[] = array($entityIds[CPE],price_id,catalogindex_price_user_0, 
                             catalogindex_price_qty_value,$book[PRICE],tax_class_value,website_id);
        $val_array[] = array($entityIds[CPE],price_id,catalogindex_price_user_1,
                             catalogindex_price_qty_value,$book[PRICE],tax_class_value,website_id);
        $val_array[] = array($entityIds[CPE],price_id,catalogindex_price_user_2,
                             catalogindex_price_qty_value,$book[PRICE],tax_class_value,website_id);
        $val_array[] = array($entityIds[CPE],price_id,catalogindex_price_user_3,
                             catalogindex_price_qty_value,$book[PRICE],tax_class_value,website_id);
        $queries[] = createInsertQuery("catalogindex_price", 
                                       "entity_id, attribute_id, customer_group_id, qty, value, tax_class_id, website_id",
                                       $val_array);
   
        if (empty($book[QTY])) {
            $book[QTY] = 0;
        } 
        $val_array = array();
        $val_array[] = array($entityIds[CPE], stock_id, $book[QTY], use_config_backorders, $book[IN_STOCK]);
        $queries[] = createInsertQuery("cataloginventory_stock_item", 
                                       "product_id, stock_id, qty, use_config_backorders, is_in_stock",
                                       $val_array);

        $val_array = array();
        $val_array[] = array($entityIds[CPE],website_id,stock_id,$book[QTY],stock_status);
        $queries[] = createInsertQuery("cataloginventory_stock_status", 
                                       "product_id, website_id, stock_id, qty, stock_status",
                                       $val_array);

        $category_ids = explode(",", $book[BISAC]); 

        $val_array = array();
        foreach($category_ids as $id_value) {
		    $val_array[] = array($id_value,$entityIds[CPE]);
        }
		$queries[] = createInsertQuery("catalog_category_product", 
                                       "category_id, product_id",
                                       $val_array);

        $val_array = array();
        $val_array[] = array(root_category_value,$entityIds[CPE],0,catalogindex_eav_store_id, book_visibility_value);

        foreach($category_ids as $id_value) {
            $val_array[] = array($id_value,$entityIds[CPE],1,catalogindex_eav_store_id,book_visibility_value);
        }

        $queries[] = createInsertQuery("catalog_category_product_index", 
                                       "category_id, product_id, is_parent, store_id, visibility",
                                       $val_array);

        $val_array = array();
        $val_array[] = array($entityIds[CPE],catalogindex_eav_store_id,book_visibility_value);
        $queries[] = createInsertQuery("catalog_product_enabled_index", 
                                       "product_id, store_id, visibility",
                                       $val_array);


        $val_array = array();
        $val_array[] = array($entityIds[CPE],website_id);
        $queries[] = createInsertQuery("catalog_product_website", "product_id, website_id", $val_array);

		//Create the  dataindex for catalogsearch_fulltext 
		/* $search_data_index = escape($book[TITLE]) . " " . escape($books[AUTHOR]) . " " . $book[ISBN];
		
		$queries[] = createInsertQuery("catalogsearch_fulltext",
                                        array($entityIds[CPE],catalogindex_eav_store_id,"'$search_data_index'")); */

       //Create the url_rewrite
        $seed_url = $book[REWRITE_URL];
        $seed_url = substr($seed_url, 0, strrpos($seed_url, "."));
        $categoryPath = getCategoryFullPath($seed_url);

        $val_array = array();
        $val_array[] = array(catalogindex_eav_store_id,"\N",$entityIds[CPE],
                             "product/".$entityIds[CPE],"$url_key".".html",
                             "catalog/product/view/id/".$entityIds[CPE],"");

        foreach($categoryPath as $id => $path) {
               $val_array[] = array(catalogindex_eav_store_id,$id,$entityIds[CPE],
                              "product/".$entityIds[CPE]."/".$id,$path."/".$url_key.".html",
                              "catalog/product/view/id/".$entityIds[CPE]."/category/".$id,"");
        }
        $queries[] = createInsertQuery("core_url_rewrite", 
                                       "store_id, category_id, product_id, id_path, request_path, target_path, options",
                                       $val_array);
		return $queries;
    }
   /** 
    * Generates all the UPDATE sqls required to update a new book.  
    */
    function generateUpdateSQLs($id, $book) {

        $queries = array();

        $queries[] = createUpdateQuery("catalog_product_entity_decimal", "value",
                                        $book[PRICE], array(entity_id => $id, attribute_id => price_id));
		
		$discount_price = empty($book[DISCOUNT_PRICE]) ? 0.0 : $book[DISCOUNT_PRICE];

        $queries[] = createUpdateQuery("catalog_product_entity_decimal", "value", 
                                        $discount_price, array(entity_id => $id, attribute_id => special_price_id));

        $queries[] = createUpdateQuery("cataloginventory_stock_item", "is_in_stock", 
                                        $book[IN_STOCK], array(product_id => $id, stock_id => stock_id));
		
        return $queries;
    }

    /**
     * Writes out index information for each book to a file.
     */
     function writeIndexInformation($id, $author="", $title="", $image="", $url="") {
        static $fh = null;

        if ($fh == null) {
           $fh = fopen("search_data.txt", "w"); 
           if (!$fh) {
                fatal("Could not open index file for write: search_index_text.csv");
           }
        }

        if ($id < 0) {
            fclose($fh);
            return;
        }

        fprintf($fh, "%d\t%s\t%s\t%s\t%s\n", $id, $author, $title, $image, $url);
     } 

    /**
     *  Loads the written data files into the ekkitab db. 
     */
     function loadDataIntoEkkitabDb($db) {
        global $targetdir;
        global $logger;
        global $filesuffixes;

        prepareDb($db);
        $tablenames[0] = "catalog_product_entity";
        $logger->info("commencing data load...");
        $ekkitab_table_names = array();
        $ekkitab_table_names['catalog_product_entity'] = array('columns' => "entity_id, entity_type_id, attribute_set_id, sku, category_ids", 
                                                               'set' => "created_at = curdate(), updated_at = curdate()");
        $ekkitab_table_names['catalog_product_entity_datetime'] = array('columns' => "entity_type_id, attribute_id, store_id, entity_id, value");
        $ekkitab_table_names['catalog_product_entity_decimal'] = array('columns' => "entity_type_id, attribute_id, store_id, entity_id, value");
        $ekkitab_table_names['catalog_product_entity_int'] = array('columns' => "entity_type_id, attribute_id, store_id, entity_id, value");
        $ekkitab_table_names['catalog_product_entity_media_gallery'] = array('columns' => "attribute_id, entity_id, value");
        $ekkitab_table_names['catalog_product_entity_media_gallery_value'] = array('columns' => "value_id, store_id, position");
        $ekkitab_table_names['catalog_product_entity_text'] = array('columns' => "entity_type_id, attribute_id, store_id, entity_id, value");
        $ekkitab_table_names['catalog_product_entity_varchar'] = array('columns' => "entity_type_id, attribute_id, store_id, entity_id, value");
        $ekkitab_table_names['catalogindex_eav'] = array('columns' => "store_id, entity_id, attribute_id, value");
        $ekkitab_table_names['catalogindex_price'] = array('columns' => "entity_id, attribute_id, customer_group_id, qty, value, tax_class_id, website_id");
        $ekkitab_table_names['cataloginventory_stock_item'] = array('columns' => "product_id, stock_id, qty, use_config_backorders, is_in_stock");
        $ekkitab_table_names['cataloginventory_stock_status'] = array('columns' => "product_id, website_id, stock_id, qty, stock_status");
        $ekkitab_table_names['catalog_category_product'] = array('columns' => "category_id, product_id");
        $ekkitab_table_names['catalog_category_product_index'] = array('columns' => "category_id, product_id, is_parent, store_id, visibility");
        $ekkitab_table_names['catalog_product_enabled_index'] = array('columns' => "product_id, store_id, visibility");
        $ekkitab_table_names['catalog_product_website'] = array('columns' => "product_id, website_id");
        $ekkitab_table_names['core_url_rewrite'] = array('columns' => "store_id, category_id, product_id, id_path, request_path, target_path, options");

        $queries = array();
        $tables = array();

        foreach($ekkitab_table_names as $table => $value) {
            $columns = "";
            $set     = "";
            if (!empty($value['columns']))
                $columns = $value['columns'];
            if (!empty($value['set']))
                $set = $value['set'];
            for ($i =0; $i < $filesuffixes[$table]; $i++) { 
                $query = "load data local infile '" . $targetdir ."/loaddata-".$table."-".$i.".txt'" . " into table " . $table . " (" . $columns . ")";
                if (!empty($set))
                    $query = $query . " set ". $set. "";
                $queries[] = $query;
                $tables[]  = $table . "-" . $i;
            }
        }

        for ($i = 0; $i < count($queries); $i++) {
            $startTimer = (float) array_sum(explode(' ', microtime()));
			$result = mysqli_query($db, $queries[$i]);
            if (! $result) 
                 fatal("Failed load data.", $queries[$i]);
            $endTimer = (float) array_sum(explode(' ', microtime()));
            $elapsedtime += ($endTimer - $startTimer)/60;
            $logger->info("Loaded table: '".$tables[$i]."' in ".sprintf("%.2f", $elapsedtime)." minutes");
        }
     }

     function start1() {
        $val_array = array();
        $val_array[] = array(100,200, 300, 400,500,"'book name'");
        $val_array[] = array(900,800, 700, 600,500,"'another book name'");
        $queries[] = createInsertQuery("catalog_product_entity_varchar", $val_array);
        foreach ($queries as $query) {
            echo "$query\n";
        }
     }

    /**
     * Main function
     */
    function start($argc, $argv) {

        global $logger;
        global $mysqlTime;
        global $mysqlTimeRefDb;
        global $failedBooks;
        global $dbs;
        global $targetdir;
        $maxprocesscount = 5000000;

        for ($i = 1; $i < $argc; $i++) {
            if ($i == 1) {
                $maxprocesscount = $argv[$i];
                echo "Max books to process set to: $maxprocesscount\n";
            }
            if ($i == 2) {
                $targetdir = $argv[$i];
                echo "Target directory: $targetdir\n";
            }
        }
        $config = getConfig(LOADBOOKS_INI);
        $dbs = initDatabases($config);

        if ($dbs == NULL) 
            fatal("Failed to initialize databases");


        $entityIds = getEntityIDs($dbs[ekkitab_db]);

        $insertedBooks = 0;
        $updatedBooks = 0;
        $failedBooks = 0;
        $totalBooks = 0;
        $start = (float) array_sum(explode(' ', microtime()));
        $timer = array();

        $k = 0;
        while ($books = getBooksFromRefDB($dbs[ref_db], SELECT_LIMIT)) {
            while ($book = mysqli_fetch_array($books)) {

		        if(empty($book)) 
                    continue;

                //$id = getBookId($book[ISBN], $dbs[ekkitab_db]);
	            $queries = array();

                //$isInsert = ($id == 0) ? true : false;

                $totalBooks++;
                if ($totalBooks > $maxprocesscount)
                    break;

                $queries = generateInsertSQLs($entityIds, $book);

                updateRefDb($dbs[ref_db], $book[ISBN], $entityIds[CPE]);
                $insertedBooks++;
                $entityIds = setIdsForNextInsert($entityIds);

            }
            $logger->info("Processed $totalBooks books (Inserted: $insertedBooks)");
            if ($totalBooks > $maxprocesscount)
               break;
        }
        createInsertQuery(null, null, null); // to close file handles.
        loadDataIntoEkkitabDb($dbs[ekkitab_db]);
        mysqli_close($dbs[ekkitab_db]);
        mysqli_close($dbs[ref_db]);
    }
	
    $logger->info("Process started at " . date("d-M-Y G:i:sa"));
    $timer = (float) array_sum(explode(' ', microtime()));
    start($argc, $argv);
    $timer = (float) array_sum(explode(' ', microtime())) - $timer;
    $logger->info("Execute time: " . sprintf("%.2f", $timer/60) . " minutes.");
    $logger->info("Process ended at " . date("d-M-Y G:i:sa"));

?>
