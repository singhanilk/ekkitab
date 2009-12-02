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
//

// This script will load BookData from the Reference Database into Magento Production Database......

    include("loadbooks_config.php");
    include("magento_db_constants.php");

    define("SELECT_LIMIT", 1000);
    $mysqlTime = 0;
    $mysqlTimeRefDb = 0;

    require_once(LOG4PHP_DIR . '/LoggerManager.php');

    // global logger
    $logger =& LoggerManager::getLogger("loadbooks");

   /** 
    * Log the error and terminate the program.
    * Optionally, will accept the query that failed.
    */
    function fatal($message, $query = "") {
        global $logger;
	    $logger->fatal("$message " . "[ $query ]" . "\n");
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
	        $dbm	= mysqli_connect($database_serve,$database_user,$database_psw,$ekkitab_db);
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
	    $queries[] = 'select max(value_id) from catalog_product_entity_media_gallery';
	    $queries[] = 'select max(value_id) from catalog_product_entity_text';
	    $queries[] = 'select max(value_id) from catalog_product_entity_varchar';
	    $queries[] = 'select max(item_id) from cataloginventory_stock_item';

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
        static $from = 0;
        //if ($from >= 1000)
         //   return NULL;
		$query = "select * from books where books.new = 0 limit $from,$limit";
        //$logger->info("Query: $query");
        try {
		    $books = mysqli_query($db,$query);
        }
        catch(exception $e) {
            fatal($e->getmessage());
        }
        $from += $limit;
        return $books;
    }

   /** 
    * Set the books update flag to 'updated' in the reference database.  
    */
    function updateRefDb($db, $isbn) {
		$query = "update books set books.new = 1 where books.isbn = '$isbn'";
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
    function createInsertQuery($table, $values) {
        $query = "insert into $table values( ";
        foreach ($values as $value) {
            $query .= "$value, ";
        }
        $query = substr($query, 0, strrpos($query, ","));
        $query .= ")";
        return $query;
    }

   /** 
    * Create and return an UPDATE mysql query from arguments.  
    */
    function createUpdateQuery($table, $setvalue, $where) {
        $query = "update $table set value = '$setvalue' where ";
        foreach ($where as $field => $value) {
            $query .= "$field = $value and ";
        }
        $query = substr($query, 0, strrpos($query, "and"));
        return $query;
    }

   /** 
    * Set auto-commit mode for database.  
    */
    function setAutoCommit($db, $mode = true) {
        global $logger;
        $query = "set autocommit = " . ($mode ? "1" : "0");
        //$logger->info("Autocommit: $query");
        try {
	        $result = mysqli_query($db,$query);
            if (!$result)
                throw new exception("Failed to set requested autocommit mode. [$query]");
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
        $entityIds[CPEDE] += 1;
        $entityIds[CPEIN] += 4;
        $entityIds[CPETX] += 4;
        $entityIds[CPEVC] += 22;
        return $entityIds;
    }

   /** 
    * Generates all the INSERT sqls required to insert a new book.  
    */
    function generateInsertSQLs($entityIds, $book) {

        $queries = array();
	    $url_key = $book[TITLE];
		$url_key = str_replace("'","",$url_key);
		$url_key = str_replace(" ","-",$url_key);

        $queries[] = createInsertQuery("catalog_product_entity",
                                        array($entityIds[CPE], entity_type_id, attribute_set_id, 
                                        "'simple'", "'$book[ISBN]'", "'$book[BISAC]'", "curdate()", "curdate()", 0, 0));

	    $queries[] = createInsertQuery("catalog_product_entity_datetime",
                                        array($entityIds[CPEDT], entity_type_id, bo_pu_date_id, store_id, $entityIds[CPE], "'$book[PDATE]'")); 


        $queries[] = createInsertQuery("catalog_product_entity_decimal",
                                       array($entityIds[CPEDE], entity_type_id, price_id, store_id, $entityIds[CPE], $book[PRICE]));

        $queries[] = createInsertQuery("catalog_product_entity_decimal",
                                       array($entityIds[CPEDE]+1,entity_type_id, special_price_id,store_id,$entityIds[CPE],$book[WEIGHT]));    


        $queries[] = createInsertQuery("catalog_product_entity_int",
                                       array($entityIds[CPEIN],entity_type_id, status_id,store_id,$entityIds[CPE],1));

        $queries[] = createInsertQuery("catalog_product_entity_int",
                                       array($entityIds[CPEIN]+1,entity_type_id, tax_class_id,store_id,$entityIds[CPE],0));    

        $queries[] = createInsertQuery("catalog_product_entity_int",
                                       array($entityIds[CPEIN]+2,entity_type_id,visibility_id,store_id,$entityIds[CPE],4));

        $queries[] = createInsertQuery("catalog_product_entity_int",
                                       array($entityIds[CPEIN]+3,entity_type_id, enable_googlecheckout_id,store_id,$entityIds[CPE],1));

        $queries[] = createInsertQuery("catalog_product_entity_int",
                                       array($entityIds[CPEIN]+4,entity_type_id, bo_int_shipping_id,store_id,$entityIds[CPE],0));


        $queries[] = createInsertQuery("catalog_product_entity_media_gallery",
                                       array($entityIds[CPEMG], media_gallery_id, $entityIds[CPE],"'".IMAGE_DIRECTORY_OFFSET.$book[ISBN].".jpg'"));

        $queries[] = createInsertQuery("catalog_product_entity_media_gallery_value",
                                       array($entityIds[CPEMG],0,"''",1,0));    


        $queries[] = createInsertQuery("catalog_product_entity_text",
                                       array($entityIds[CPETX],entity_type_id,bo_publisher_id,store_id,$entityIds[CPE],"'peng'"));

        $queries[] = createInsertQuery("catalog_product_entity_text",
                                       array($entityIds[CPETX]+1,entity_type_id, descrption_id,store_id,$entityIds[CPE],"'$book[TITLE]'"));

        $queries[] = createInsertQuery("catalog_product_entity_text",
                                       array($entityIds[CPETX]+2,entity_type_id, short_descrption_id,store_id, $entityIds[CPE],"'$book[TITLE]'"));

        $queries[] = createInsertQuery("catalog_product_entity_text",
                                       array($entityIds[CPETX]+3,entity_type_id,meta_keyword_id,store_id,$entityIds[CPE],"''")); 

        $queries[] = createInsertQuery("catalog_product_entity_text",
                                       array($entityIds[CPETX]+4,entity_type_id,custom_layout_update_id,store_id,$entityIds[CPE],"''"));

        $queries[] = createInsertQuery("catalog_product_entity_varchar",
                                       array($entityIds[CPEVC],entity_type_id,name_id,store_id,$entityIds[CPE],"'$book[TITLE]'"));

        $queries[] = createInsertQuery("catalog_product_entity_varchar",
                                       array($entityIds[CPEVC]+1,entity_type_id,meta_title_id,store_id,$entityIds[CPE],"''"));

        $queries[] = createInsertQuery("catalog_product_entity_varchar",
                                       array($entityIds[CPEVC]+2,entity_type_id,meta_description_id,store_id,$entityIds[CPE],"''"));

        $queries[] = createInsertQuery("catalog_product_entity_varchar",
                                        array($entityIds[CPEVC]+3,entity_type_id,url_key_id,store_id,$entityIds[CPE],"'$url_key'"));

        $queries[] = createInsertQuery("catalog_product_entity_varchar",
                                        array($entityIds[CPEVC]+4,entity_type_id,url_id,store_id,$entityIds[CPE],"'$url_key".".html'"));

        $queries[] = createInsertQuery("catalog_product_entity_varchar", 
                                        array($entityIds[CPEVC]+5,entity_type_id,options_container,store_id,$entityIds[CPE],"'container2'"));

        $queries[] = createInsertQuery("catalog_product_entity_varchar",
                                        array($entityIds[CPEVC]+6,entity_type_id,image_label_id,store_id,$entityIds[CPE],"''"));

        $queries[] = createInsertQuery("catalog_product_entity_varchar",
                                        array($entityIds[CPEVC]+7,entity_type_id,small_image_label_id,store_id,$entityIds[CPE],"''"));

        $queries[] = createInsertQuery("catalog_product_entity_varchar",
                                        array($entityIds[CPEVC]+8,entity_type_id,thumb_label_id,store_id,$entityIds[CPE],"''"));

        $queries[] = createInsertQuery("catalog_product_entity_varchar",
                                        array($entityIds[CPEVC]+9,entity_type_id,gift_message_avialable_id,store_id,$entityIds[CPE],2));

        $queries[] = createInsertQuery("catalog_product_entity_varchar",
                                        array($entityIds[CPEVC]+10,entity_type_id,bo_author_id,store_id,$entityIds[CPE],"'$book[AUTHOR]'"));

        $queries[] = createInsertQuery("catalog_product_entity_varchar",
                                       array($entityIds[CPEVC]+11,entity_type_id,bo_isbn_id,store_id,$entityIds[CPE],"'$book[ISBN]'"));

        $queries[] = createInsertQuery("catalog_product_entity_varchar",
                                       array($entityIds[CPEVC]+12,entity_type_id,bo_binding_id,store_id,$entityIds[CPE],"'$book[BINDING]'"));

        $queries[] = createInsertQuery("catalog_product_entity_varchar",
                                       array($entityIds[CPEVC]+13,entity_type_id,bo_isbn10_id,store_id,$entityIds[CPE],"'$book[ISBN]'"));

        $queries[] = createInsertQuery("catalog_product_entity_varchar",
                                       array($entityIds[CPEVC]+14,entity_type_id,bo_language_id,store_id,$entityIds[CPE],"'English'"));

        $queries[] = createInsertQuery("catalog_product_entity_varchar",
                                       array($entityIds[CPEVC]+15,entity_type_id,bo_no_pg_id,store_id,$entityIds[CPE],334));

        $queries[] = createInsertQuery("catalog_product_entity_varchar",
                                       array($entityIds[CPEVC]+16,entity_type_id,bo_dimension_id,store_id,$entityIds[CPE],"''"));

        $queries[] = createInsertQuery("catalog_product_entity_varchar",
                                       array($entityIds[CPEVC]+17,entity_type_id,bo_illustrator_id,store_id,$entityIds[CPE],"''"));

        $queries[] = createInsertQuery("catalog_product_entity_varchar",
                                       array($entityIds[CPEVC]+18,entity_type_id,bo_edition_id,store_id,$entityIds[CPE],"''"));

        $queries[] = createInsertQuery("catalog_product_entity_varchar",
                                       array($entityIds[CPEVC]+19,entity_type_id,bo_rating_id,store_id,$entityIds[CPE],"'3.5/5'"));

        $queries[] = createInsertQuery("catalog_product_entity_varchar",
                                       array($entityIds[CPEVC]+20,entity_type_id,bo_image_id,store_id,$entityIds[CPE],
                                       "'".IMAGE_DIRECTORY_OFFSET.$book[ISBN].".jpg'"));

        $queries[] = createInsertQuery("catalog_product_entity_varchar",
                                        array($entityIds[CPEVC]+21,entity_type_id,bo_small_image_id,store_id,$entityIds[CPE],
                                       "'".IMAGE_DIRECTORY_OFFSET.$book[ISBN].".jpg'"));

        $queries[] = createInsertQuery("catalog_product_entity_varchar",
                                        array($entityIds[CPEVC]+22,entity_type_id,bo_thumb_image_id,store_id,$entityIds[CPE],
                                       "'".IMAGE_DIRECTORY_OFFSET.$book[ISBN].".jpg'"));

        $queries[] = createInsertQuery("catalogindex_eav",
                                       array(1,$entityIds[CPE],tax_class_id,0));

        $queries[] = createInsertQuery("catalogindex_price",
                                       array($entityIds[CPE],price_id,0,0.0000,$book[PRICE],0,1));

        $queries[] = createInsertQuery("catalogindex_price",
									   array($entityIds[CPE],price_id,1,0.0000,$book[PRICE],0,1));

        $queries[] = createInsertQuery("catalogindex_price",
									   array($entityIds[CPE],price_id,2,0.0000,$book[PRICE],0,1));

        $queries[] = createInsertQuery("catalogindex_price",
										array($entityIds[CPE],price_id,3,0.0000,$book[PRICE],0,1));

        $queries[] = createInsertQuery("cataloginventory_stock_item",
                                        array($entityIds[CISI],$entityIds[CPE],
                                        1,10.0000,0.0000, 1,0,0,1,1.0000, 1,0.0000,1,1,"'default'", "'default'",1,0,1,0));

        $queries[] = createInsertQuery("cataloginventory_stock_status",
                                        array($entityIds[CPE],1,1,10.0000,1));

        $queries[] = createInsertQuery("catalog_category_product",
                                        array("'$book[BISAC]'",$entityIds[CPE],0));

        $queries[] = createInsertQuery("catalog_category_product_index",
                                        array(2,$entityIds[CPE],0,0,1,book_visibility_value));

        $queries[] = createInsertQuery("catalog_category_product_index",
                                        array("'$book[BISAC]'",$entityIds[CPE],0,1,1,book_visibility_value));

        $queries[] = createInsertQuery("catalog_product_enabled_index",
                                        array($entityIds[CPE],1,4));

        $queries[] = createInsertQuery("catalog_product_website",
                                        array($entityIds[CPE],1));


        return $queries;
    }

   /** 
    * Generates all the UPDATE sqls required to update a new book.  
    */
    function generateUpdateQLs($id, $book) {
        $queries = array();

	    $url_key= $book[TITLE];
		$url_key = str_replace("'","",$url_key);
		$url_key = str_replace(" ","-",$url_key);

        $queries[] = createUpdateQuery("catalog_product_entity_datetime",
                                        $book[PDATE], array(entity_id => $id, attribute_id => bo_publisher_id));

        $queries[] = createUpdateQuery("catalog_product_entity_decimal",
                                        $book[PRICE], array(entity_id => $id, attribute_id => price_id));

        $queries[] = createUpdateQuery("catalog_product_entity_decimal", 
                                        $book[PRICE], array(entity_id => $id, attribute_id => special_price_id));

	    $queries[] = createUpdateQuery("catalog_product_entity_int",
                                        1, array(entity_id => $id, attribute_id => status_id));

	    $queries[] = createUpdateQuery("catalog_product_entity_int",
                                        0, array(entity_id => $id, attribute_id => tax_class_id));

	    $queries[] = createUpdateQuery("catalog_product_entity_int", 
                                        4, array(entity_id => $id, attribute_id => visibility_id));

	    $queries[] = createUpdateQuery("catalog_product_entity_int",
                                        1, array(entity_id => $id, attribute_id => enable_googlecheckout_id));

	    $queries[] = createUpdateQuery("catalog_product_entity_int", 
                                        1, array(entity_id => $id, attribute_id => bo_int_shipping_id));

        $queries[] = createUpdateQuery("catalog_product_entity_media_gallery", 
                                        IMAGE_DIRECTORY_OFFSET.$book[ISBN].".jpg", 
                                        array(entity_id => $id, attribute_id => media_gallery_id));

        $queries[] = createUpdateQuery("catalog_product_entity_text", 
                                        $book[PUBLISHER], array(entity_id => $id, attribute_id => bo_publisher_id));

        $queries[] = createUpdateQuery("catalog_product_entity_text", 
                                        $book[TITLE], array(entity_id => $id, attribute_id => descrption_id));

        $queries[] = createUpdateQuery("catalog_product_entity_text", 
                                        $book[TITLE], array(entity_id => $id, attribute_id => short_descrption_id));

        $queries[] = createUpdateQuery("catalog_product_entity_text", 
                                       "", array(entity_id => $id, attribute_id => meta_keyword_id));

        $queries[] = createUpdateQuery("catalog_product_entity_text", 
                                       "", array(entity_id => $id, attribute_id => custom_layout_update_id));

        $queries[] = createUpdateQuery("catalog_product_entity_varchar",
                                        $book[TITLE], array(entity_id => $id, attribute_id => name_id));

        $queries[] = createUpdateQuery("catalog_product_entity_varchar",
                                        "", array(entity_id => $id, attribute_id => meta_title_id));

        $queries[] = createUpdateQuery("catalog_product_entity_varchar",
                                        "", array(entity_id => $id, attribute_id => meta_description_id));

        $queries[] = createUpdateQuery("catalog_product_entity_varchar", 
                                        $url_key, array(entity_id => $id, attribute_id => url_key_id));

        $queries[] = createUpdateQuery("catalog_product_entity_varchar", 
                                        $url_key.".html", array(entity_id => $id, attribute_id => url_id));

        $queries[] = createUpdateQuery("catalog_product_entity_varchar", 
                                        "container2", array(entity_id => $id, attribute_id => options_container));

        $queries[] = createUpdateQuery("catalog_product_entity_varchar", 
                                        "", array(entity_id => $id, attribute_id => image_label_id));

        $queries[] = createUpdateQuery("catalog_product_entity_varchar", 
                                        "", array(entity_id => $id, attribute_id => small_image_label_id));

        $queries[] = createUpdateQuery("catalog_product_entity_varchar", 
                                        "", array(entity_id => $id, attribute_id => thumb_label_id));

        $queries[] = createUpdateQuery("catalog_product_entity_varchar", 
                                        2, array(entity_id => $id, attribute_id => gift_message_avialable_id));

        $queries[] = createUpdateQuery("catalog_product_entity_varchar", 
                                        $book[AUTHOR], array(entity_id => $id, attribute_id => bo_author_id));

        $queries[] = createUpdateQuery("catalog_product_entity_varchar", 
                                        $book[ISBN], array(entity_id => $id, attribute_id => bo_isbn_id));

        $queries[] = createUpdateQuery("catalog_product_entity_varchar", 
                                        "hard", array(entity_id => $id, attribute_id => bo_binding_id));

        $queries[] = createUpdateQuery("catalog_product_entity_varchar", 
                                        $book[ISBN], array(entity_id => $id, attribute_id => bo_isbn10_id));

        $queries[] = createUpdateQuery("catalog_product_entity_varchar", 
                                        "English", array(entity_id => $id, attribute_id => bo_language_id));

        $queries[] = createUpdateQuery("catalog_product_entity_varchar", 
                                        334, array(entity_id => $id, attribute_id => bo_no_pg_id));

        $queries[] = createUpdateQuery("catalog_product_entity_varchar", 
                                        "", array(entity_id => $id, attribute_id => bo_dimension_id));

        $queries[] = createUpdateQuery("catalog_product_entity_varchar", 
                                        "", array(entity_id => $id, attribute_id => bo_illustrator_id));

        $queries[] = createUpdateQuery("catalog_product_entity_varchar", 
                                        "", array(entity_id => $id, attribute_id => bo_edition_id));

        $queries[] = createUpdateQuery("catalog_product_entity_varchar", 
                                        "4/5", array(entity_id => $id, attribute_id => bo_rating_id));

        $queries[] = createUpdateQuery("catalog_product_entity_varchar", 
                                        IMAGE_DIRECTORY_OFFSET.$book[ISBN].".jpg", 
                                        array(entity_id => $id, attribute_id => bo_image_id));

        $queries[] = createUpdateQuery("catalog_product_entity_varchar", 
                                        IMAGE_DIRECTORY_OFFSET.$book[ISBN].".jpg", 
									    array(entity_id => $id,  attribute_id => bo_small_image_id));

        $queries[] = createUpdateQuery("catalog_product_entity_varchar", 
                                        IMAGE_DIRECTORY_OFFSET.$book[ISBN].".jpg", 
                                        array(entity_id => $id, attribute_id => bo_thumb_image_id));

        return $queries;
    }
    /**
     * Main function
     */
    function start() {

        global $logger;
        global $mysqlTime;
        global $mysqlTimeRefDb;
        $config = getConfig(LOADBOOKS_INI);
        $dbs = initDatabases($config);

        if ($dbs == NULL) 
            fatal("Failed to initialize databases");

        setAutoCommit($dbs[ekkitab_db], false);

        $entityIds = getEntityIDs($dbs[ekkitab_db]);

        $insertedBooks = 0;
        $updatedBooks = 0;
        $failedBooks = 0;
        $totalBooks = 0;
        $start = (float) array_sum(explode(' ', microtime()));

        while ($books = getBooksFromRefDB($dbs[ref_db], SELECT_LIMIT)) {
            while ($book = mysqli_fetch_array($books)) {
        
		        if(empty($book)) 
                    continue;

                $id = getBookId($book[ISBN], $dbs[ekkitab_db]);
	            $queries = array();

                $isInsert = ($id == 0) ? true : false;

                // $logger->info(($isInsert ? "Inserting " : "Updating ") . " book " . ++$totalBooks . "...");
                $totalBooks++;

		        if (($id == NULL) || ($id == 0)) {
                    $queries = generateInsertSQLs($entityIds, $book);
	            }
                else {
                    $queries = generateUpdateQLs($id, $book);
	            }

                try {
                    //$longQuery = "";
                    $startZ = (float) array_sum(explode(' ', microtime()));
	                foreach ($queries as $query)  {
			            $result = mysqli_query($dbs[ekkitab_db], $query);
                        if (! $result) 
                            throw new exception("Failed to commit book to ekkitab database. [$query]");
                        //$longQuery .= "$query;";
	                }
                    //$longQuery .= "commit; ";
                    //$logger->info("Query: $longQuery");
                    //$startZ = (float) array_sum(explode(' ', microtime()));
			        //$result = mysqli_multi_query($dbs[ekkitab_db], $longQuery);
                    //$endZ = (float) array_sum(explode(' ', microtime()));
                    //$mysqlTime += ($endZ - $startZ);
                    //if (! $result) 
                       //throw new exception("Failed to commit book to ekkitab database. ");
                    $result = mysqli_query($dbs[ekkitab_db], "commit");
                    if (! $result) 
                        throw new exception("Failed to commit on ekkitab database.");
                    $endZ = (float) array_sum(explode(' ', microtime()));
                    $mysqlTime += ($endZ - $startZ);
                    $startY = (float) array_sum(explode(' ', microtime()));
                    updateRefDb($dbs[ref_db], $book[ISBN]);
                    $endY = (float) array_sum(explode(' ', microtime()));
                    $mysqlTimeRefDb += ($endY - $startY);
                    if ($isInsert) { 
                        $insertedBooks++;
                        $entityIds = setIdsForNextInsert($entityIds);
                    }
                    else 
                        $updatedBooks++;
                }
                catch(exception $e) {
                    warn($e->getmessage());
                    warn("Book with ISBN number $book[ISBN] did not get saved in the Ekkitab database.");
                    $failedBooks++;
                    $result = mysqli_query($dbs[ekkitab_db], "rollback");
                    if (! $result) 
                        warn("Failed to rollback on ekkitab database.");
                }
                //$logger->info("Finished: $book[ISBN] " . ($isInsert ? "inserted." : "updated."));
            }
            $end = (float) array_sum(explode(' ', microtime()));
            $logger->info("Processed $totalBooks books (Inserted: $insertedBooks, Updated: $updatedBooks, Failed: $failedBooks) in " . sprintf("%.4f", ($end - $start)) . " seconds.");
        }
        //$logger->info("Books inserted: $insertedBooks. Books updated: $updatedBooks. Failed: $failedBooks");
    }

    $logger->info("Process started at " . date("d-M-Y G:i:sa"));
    start();
    $logger->info("Process ended at " . date("d-M-Y G:i:sa"));
    //$logger->info("Processing time: " . sprintf("%.4f", ($end - $start)) . " seconds.");
    $logger->info("MySQL Processing time: " . sprintf("%.4f", $mysqlTime) . " seconds.");
    $logger->info("MySQL Processing time in RefDb: " . sprintf("%.4f", $mysqlTimeRefDb) . " seconds.");

?>
