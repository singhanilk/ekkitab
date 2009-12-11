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
		$query = "select * from books where books.new = 0 limit $limit";
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
        $entityIds[CPEDE] += 2;
        $entityIds[CPEIN] += 4;
        $entityIds[CPETX] += 4;
        $entityIds[CPEVC] += 23;
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

		//create categories_id entry

		$book_category_ids = $book[BISAC];
		if(!empty($book[BISAC2]))
		  $book_category_ids .= ",$book[BISAC2],";
		if(!empty($book[BISAC3]))
		  $book_category_ids .= ",$book[BISAC3]";
		
		$queries[] = createInsertQuery("catalog_product_entity",
                                        array($entityIds[CPE], entity_type_id, attribute_set_id, 
                                        "'simple'", "'$book[ISBN]'", "'$book_category_ids'",
			                            "curdate()", "curdate()", has_options, required_option));

		$book_pdate = $book[PDATE];
	    $queries[] = createInsertQuery("catalog_product_entity_datetime",
                                        array($entityIds[CPEDT], entity_type_id, bo_pu_date_id, store_id, $entityIds[CPE],"'$book_pdate'")); 


        $queries[] = createInsertQuery("catalog_product_entity_decimal",
                                       array($entityIds[CPEDE], entity_type_id, price_id, store_id, $entityIds[CPE], $book[PRICE]));

		//calculate the discount
		$discount_price = 0.00;
		$discount_price = $book[PRICE]-($book[PRICE]*($book[DISCOUNT]/100));

        $queries[] = createInsertQuery("catalog_product_entity_decimal",
                                       array($entityIds[CPEDE]+1,entity_type_id, special_price_id,store_id,$entityIds[CPE],$discount_price));    

		$queries[] = createInsertQuery("catalog_product_entity_decimal",
                                       array($entityIds[CPEDE]+2,entity_type_id, weight_id,store_id,$entityIds[CPE],$book[WEIGHT]));    


        $queries[] = createInsertQuery("catalog_product_entity_int",
                                       array($entityIds[CPEIN],entity_type_id, status_id,store_id,$entityIds[CPE],$book[PRODUCT_STATUS]));

        $queries[] = createInsertQuery("catalog_product_entity_int",
                                       array($entityIds[CPEIN]+1,entity_type_id, tax_class_id,store_id,$entityIds[CPE],tax_class_value));    

        $queries[] = createInsertQuery("catalog_product_entity_int",
                                       array($entityIds[CPEIN]+2,entity_type_id,visibility_id,store_id,$entityIds[CPE],book_visibility_value));

        $queries[] = createInsertQuery("catalog_product_entity_int",
                                       array($entityIds[CPEIN]+3,entity_type_id, enable_googlecheckout_id,store_id,$entityIds[CPE],option_enable));

        $queries[] = createInsertQuery("catalog_product_entity_int",
                                       array($entityIds[CPEIN]+4,entity_type_id, bo_int_shipping_id,store_id,$entityIds[CPE],$book[INT_SHIPPING]));


        $queries[] = createInsertQuery("catalog_product_entity_media_gallery",
                                       array($entityIds[CPEMG], media_gallery_id, $entityIds[CPE],"'$book[IMAGE]'"));

        $queries[] = createInsertQuery("catalog_product_entity_media_gallery_value",
                                       array($entityIds[CPEMG],store_id,"''",media_position,option_disable));    


        $queries[] = createInsertQuery("catalog_product_entity_text",
                                       array($entityIds[CPETX],entity_type_id,bo_publisher_id,store_id,$entityIds[CPE],"'$book[PUBLISHER]'"));

        $queries[] = createInsertQuery("catalog_product_entity_text",
                                       array($entityIds[CPETX]+1,entity_type_id, descrption_id,store_id,$entityIds[CPE],"'$book[DESCRIPTION]'"));

        $queries[] = createInsertQuery("catalog_product_entity_text",
                                       array($entityIds[CPETX]+2,entity_type_id, short_descrption_id,store_id, $entityIds[CPE],"'$book[DESCRIPTION]'"));

        $queries[] = createInsertQuery("catalog_product_entity_text",
                                       array($entityIds[CPETX]+3,entity_type_id,meta_keyword_id,store_id,$entityIds[CPE],"'".value_empty."'")); 

        $queries[] = createInsertQuery("catalog_product_entity_text",
                                       array($entityIds[CPETX]+4,entity_type_id,custom_layout_update_id,store_id,$entityIds[CPE],"'".value_empty."'"));

        $queries[] = createInsertQuery("catalog_product_entity_varchar",
                                       array($entityIds[CPEVC],entity_type_id,name_id,store_id,$entityIds[CPE],"'$book[TITLE]'"));

        $queries[] = createInsertQuery("catalog_product_entity_varchar",
                                       array($entityIds[CPEVC]+1,entity_type_id,meta_title_id,store_id,$entityIds[CPE],"'".value_empty."'"));

        $queries[] = createInsertQuery("catalog_product_entity_varchar",
                                       array($entityIds[CPEVC]+2,entity_type_id,meta_description_id,store_id,$entityIds[CPE],"'".value_empty."'"));

        $queries[] = createInsertQuery("catalog_product_entity_varchar",
                                        array($entityIds[CPEVC]+3,entity_type_id,url_key_id,store_id,$entityIds[CPE],"'$url_key'"));

        $queries[] = createInsertQuery("catalog_product_entity_varchar",
                                        array($entityIds[CPEVC]+4,entity_type_id,url_id,store_id,$entityIds[CPE],"'$url_key".".html'"));

        $queries[] = createInsertQuery("catalog_product_entity_varchar", 
                                        array($entityIds[CPEVC]+5,entity_type_id,options_container,store_id,$entityIds[CPE],
			                            "'".options_container_value."'"));

        $queries[] = createInsertQuery("catalog_product_entity_varchar",
                                        array($entityIds[CPEVC]+6,entity_type_id,image_label_id,store_id,$entityIds[CPE],"'".value_empty."'"));

        $queries[] = createInsertQuery("catalog_product_entity_varchar",
                                        array($entityIds[CPEVC]+7,entity_type_id,small_image_label_id,store_id,$entityIds[CPE],"'".value_empty."'"));

        $queries[] = createInsertQuery("catalog_product_entity_varchar",
                                        array($entityIds[CPEVC]+8,entity_type_id,thumb_label_id,store_id,$entityIds[CPE],"'".value_empty."'"));

        $queries[] = createInsertQuery("catalog_product_entity_varchar",
                                        array($entityIds[CPEVC]+9,entity_type_id,gift_message_avialable_id,store_id,
			                            $entityIds[CPE],gift_message_value));

        $queries[] = createInsertQuery("catalog_product_entity_varchar",
                                        array($entityIds[CPEVC]+10,entity_type_id,bo_author_id,store_id,$entityIds[CPE],"'$book[AUTHOR]'"));

        $queries[] = createInsertQuery("catalog_product_entity_varchar",
                                       array($entityIds[CPEVC]+11,entity_type_id,bo_isbn_id,store_id,$entityIds[CPE],"'$book[ISBN]'"));

        $queries[] = createInsertQuery("catalog_product_entity_varchar",
                                       array($entityIds[CPEVC]+12,entity_type_id,bo_binding_id,store_id,$entityIds[CPE],"'$book[BINDING]'"));

        $queries[] = createInsertQuery("catalog_product_entity_varchar",
                                       array($entityIds[CPEVC]+13,entity_type_id,bo_isbn10_id,store_id,$entityIds[CPE],"'$book[ISBN10]'"));

        $queries[] = createInsertQuery("catalog_product_entity_varchar",
                                       array($entityIds[CPEVC]+14,entity_type_id,bo_language_id,store_id,$entityIds[CPE],"'$book[LANGUAGE]'"));

        $queries[] = createInsertQuery("catalog_product_entity_varchar",
                                       array($entityIds[CPEVC]+15,entity_type_id,bo_no_pg_id,store_id,$entityIds[CPE],"'$book[PAGES]'"));

        $queries[] = createInsertQuery("catalog_product_entity_varchar",
                                       array($entityIds[CPEVC]+16,entity_type_id,bo_dimension_id,store_id,$entityIds[CPE],"'$book[DIMENSION]'"));

        $queries[] = createInsertQuery("catalog_product_entity_varchar",
                                       array($entityIds[CPEVC]+17,entity_type_id,bo_illustrator_id,store_id,$entityIds[CPE],"'$book[ILLUSTRATOR]'"));

        $queries[] = createInsertQuery("catalog_product_entity_varchar",
                                       array($entityIds[CPEVC]+18,entity_type_id,bo_edition_id,store_id,$entityIds[CPE],"'$book[EDITION]'"));

        $queries[] = createInsertQuery("catalog_product_entity_varchar",
                                       array($entityIds[CPEVC]+19,entity_type_id,bo_rating_id,store_id,$entityIds[CPE],"'$book[RATING]'"));

        $queries[] = createInsertQuery("catalog_product_entity_varchar",
                                       array($entityIds[CPEVC]+20,entity_type_id,bo_image_id,store_id,$entityIds[CPE],
                                       "'$book[IMAGE]'"));

        $queries[] = createInsertQuery("catalog_product_entity_varchar",
                                        array($entityIds[CPEVC]+21,entity_type_id,bo_small_image_id,store_id,$entityIds[CPE],
                                       "'$book[IMAGE]'"));

        $queries[] = createInsertQuery("catalog_product_entity_varchar",
                                        array($entityIds[CPEVC]+22,entity_type_id,bo_thumb_image_id,store_id,$entityIds[CPE],
                                       "'$book[THUMB]'"));

		$queries[] = createInsertQuery("catalog_product_entity_varchar",
                                        array($entityIds[CPEVC]+23,entity_type_id,bo_shipping_region_id,store_id,$entityIds[CPE],
                                       "'$book[SHIPPING_REGION]'"));

		$queries[] = createInsertQuery("catalogindex_eav",
                                       array(1,$entityIds[CPE],tax_class_id,tax_class_value));

        $queries[] = createInsertQuery("catalogindex_price",
                                       array($entityIds[CPE],price_id,catalogindex_price_user_0,
									   catalogindex_price_qty_value,$book[PRICE],tax_class_value,website_id));

        $queries[] = createInsertQuery("catalogindex_price",
									   array($entityIds[CPE],price_id,catalogindex_price_user_1,
									   catalogindex_price_qty_value,$book[PRICE],tax_class_value,website_id));

        $queries[] = createInsertQuery("catalogindex_price",
									   array($entityIds[CPE],price_id,catalogindex_price_user_2,
									   catalogindex_price_qty_value,$book[PRICE],tax_class_value,website_id));

        $queries[] = createInsertQuery("catalogindex_price",
										array($entityIds[CPE],price_id,catalogindex_price_user_3,
										catalogindex_price_qty_value,$book[PRICE],tax_class_value,website_id));

        $queries[] = createInsertQuery("cataloginventory_stock_item",
                                        array($entityIds[CISI],$entityIds[CPE],
                                        stock_id,$book[QTY],catalogindex_price_qty_value, use_config_min_qty,is_qty_decimal,
										backorders,use_config_backorders,min_sale_qty,use_config_min_sale_qty,max_sale_qty,
										use_config_max_sale_qty,is_in_stock,"'".value_default."'","'".value_default."'",use_config_notify_stock_qty,
										manage_stock,use_config_manage_stock,stock_status_changed_automatically));

        $queries[] = createInsertQuery("cataloginventory_stock_status",
                                        array($entityIds[CPE],website_id,stock_id,$book[QTY],stock_status));

        if(!empty($books[BISAC3])){
			$queries[] = createInsertQuery("catalog_category_product",
                                        array($book[BISAC3],$entityIds[CPE],position));
		}
		else if (!empty($books[BISAC2])){
				 $queries[] = createInsertQuery("catalog_category_product",
		                       array($book[BISAC2],$entityIds[CPE],position));
		}
		else {
		
		$queries[] = createInsertQuery("catalog_category_product",
                                        array($book[BISAC],$entityIds[CPE],position));
		}

        $queries[] = createInsertQuery("catalog_category_product_index",
                                        array(root_category_value,$entityIds[CPE],position,is_parent_0,catalogindex_eav_store_id,
										book_visibility_value));

        $queries[] = createInsertQuery("catalog_category_product_index",
                                        array($book[BISAC],$entityIds[CPE],position,is_parent_1,catalogindex_eav_store_id,book_visibility_value));
		if(!empty($book[BISAC2])){
			$queries[] = createInsertQuery("catalog_category_product_index",
                                        array($book[BISAC2],$entityIds[CPE],position,is_parent_1,catalogindex_eav_store_id,book_visibility_value));
		}

		if(!empty($book[BISAC3])){
			$queries[] = createInsertQuery("catalog_category_product_index",
                                        array($book[BISAC3],$entityIds[CPE],position,is_parent_1,catalogindex_eav_store_id,book_visibility_value));
		}

        $queries[] = createInsertQuery("catalog_product_enabled_index",
                                        array($entityIds[CPE],catalogindex_eav_store_id,book_visibility_value));

        $queries[] = createInsertQuery("catalog_product_website",
                                        array($entityIds[CPE],website_id));
		
		//Create the  dataindex for catalogsearch_fulltext 
		$search_data_index="$book[TITLE] $books[AUTHOR] $book[ISBN]";
		
		$queries[] = createInsertQuery("catalogsearch_fulltext",
                                        array($entityIds[CPE],catalogindex_eav_store_id,"'$search_data_index'"));
		
		return $queries;
    }
   /** 
    * Generates all the UPDATE sqls required to update a new book.  
    */
    function generateUpdateSQLs($id, $book) {

        $queries = array();

	    $url_key= $book[TITLE];
		$url_key = str_replace("'","",$url_key);
		$url_key = str_replace(" ","-",$url_key);

        $queries[] = createUpdateQuery("catalog_product_entity_datetime",
                                        $book[PDATE], array(entity_id => $id, attribute_id => bo_publisher_id));

        $queries[] = createUpdateQuery("catalog_product_entity_decimal",
                                        $book[PRICE], array(entity_id => $id, attribute_id => price_id));
		
		//calculate the discounted Price
		$discount_price = 0.00;
		$discount_price = $book[PRICE]-($book[PRICE]*($book[DISCOUNT]/100));

        $queries[] = createUpdateQuery("catalog_product_entity_decimal", 
                                        $discount_price, array(entity_id => $id, attribute_id => special_price_id));
		
		$queries[] = createUpdateQuery("catalog_product_entity_decimal", 
                                        $book[WEIGHT], array(entity_id => $id, attribute_id => weight_id));

	    $queries[] = createUpdateQuery("catalog_product_entity_int",
                                        option_enable, array(entity_id => $id, attribute_id => status_id));

	    $queries[] = createUpdateQuery("catalog_product_entity_int",
                                        tax_class_value, array(entity_id => $id, attribute_id => tax_class_id));

	    $queries[] = createUpdateQuery("catalog_product_entity_int", 
                                        book_visibility_value, array(entity_id => $id, attribute_id => visibility_id));

	    $queries[] = createUpdateQuery("catalog_product_entity_int",
                                        option_enable, array(entity_id => $id, attribute_id => enable_googlecheckout_id));

	    $queries[] = createUpdateQuery("catalog_product_entity_int", 
                                        option_enable, array(entity_id => $id, attribute_id => bo_int_shipping_id));

        $queries[] = createUpdateQuery("catalog_product_entity_media_gallery", 
                                        "$book[IMAGE]", 
                                        array(entity_id => $id, attribute_id => media_gallery_id));

        $queries[] = createUpdateQuery("catalog_product_entity_text", 
                                        "$book[PUBLISHER]", array(entity_id => $id, attribute_id => bo_publisher_id));

        $queries[] = createUpdateQuery("catalog_product_entity_text", 
                                        "$book[DESCRIPTION]", array(entity_id => $id, attribute_id => descrption_id));

        $queries[] = createUpdateQuery("catalog_product_entity_text", 
                                        "$book[DESCRIPTION]", array(entity_id => $id, attribute_id => short_descrption_id));

        $queries[] = createUpdateQuery("catalog_product_entity_text", 
                                       value_empty, array(entity_id => $id, attribute_id => meta_keyword_id));

        $queries[] = createUpdateQuery("catalog_product_entity_text", 
                                       value_empty, array(entity_id => $id, attribute_id => custom_layout_update_id));

        $queries[] = createUpdateQuery("catalog_product_entity_varchar",
                                        $book[TITLE], array(entity_id => $id, attribute_id => name_id));

        $queries[] = createUpdateQuery("catalog_product_entity_varchar",
                                        value_empty, array(entity_id => $id, attribute_id => meta_title_id));

        $queries[] = createUpdateQuery("catalog_product_entity_varchar",
                                        value_empty, array(entity_id => $id, attribute_id => meta_description_id));

        $queries[] = createUpdateQuery("catalog_product_entity_varchar", 
                                        $url_key, array(entity_id => $id, attribute_id => url_key_id));

        $queries[] = createUpdateQuery("catalog_product_entity_varchar", 
                                        $url_key.".html", array(entity_id => $id, attribute_id => url_id));
		
        $queries[] = createUpdateQuery("catalog_product_entity_varchar", 
                                        options_container_value, array(entity_id => $id, attribute_id => options_container));
					
        $queries[] = createUpdateQuery("catalog_product_entity_varchar", 
                                        value_empty, array(entity_id => $id, attribute_id => image_label_id));

        $queries[] = createUpdateQuery("catalog_product_entity_varchar", 
                                        value_empty, array(entity_id => $id, attribute_id => small_image_label_id));

        $queries[] = createUpdateQuery("catalog_product_entity_varchar", 
                                        value_empty, array(entity_id => $id, attribute_id => thumb_label_id));

        $queries[] = createUpdateQuery("catalog_product_entity_varchar", 
                                        gift_message_value, array(entity_id => $id, attribute_id => gift_message_avialable_id));

        $queries[] = createUpdateQuery("catalog_product_entity_varchar", 
                                        "$book[AUTHOR]", array(entity_id => $id, attribute_id => bo_author_id));

        $queries[] = createUpdateQuery("catalog_product_entity_varchar", 
                                        "$book[ISBN]", array(entity_id => $id, attribute_id => bo_isbn_id));

        $queries[] = createUpdateQuery("catalog_product_entity_varchar", 
                                        "$book[BINDING]", array(entity_id => $id, attribute_id => bo_binding_id));

        $queries[] = createUpdateQuery("catalog_product_entity_varchar", 
                                        "$book[ISBN10]", array(entity_id => $id, attribute_id => bo_isbn10_id));

        $queries[] = createUpdateQuery("catalog_product_entity_varchar", 
                                        "$book[LANGUAGE]", array(entity_id => $id, attribute_id => bo_language_id));

        $queries[] = createUpdateQuery("catalog_product_entity_varchar", 
                                        "$book[PAGES]", array(entity_id => $id, attribute_id => bo_no_pg_id));

        $queries[] = createUpdateQuery("catalog_product_entity_varchar", 
                                        "$book[DIMENSION]", array(entity_id => $id, attribute_id => bo_dimension_id));

        $queries[] = createUpdateQuery("catalog_product_entity_varchar", 
                                        "$book[ILLUSTRATOR]", array(entity_id => $id, attribute_id => bo_illustrator_id));

        $queries[] = createUpdateQuery("catalog_product_entity_varchar", 
                                        "$book[EDITION]", array(entity_id => $id, attribute_id => bo_edition_id));

        $queries[] = createUpdateQuery("catalog_product_entity_varchar", 
                                        "$book[RATING]", array(entity_id => $id, attribute_id => bo_rating_id));

        $queries[] = createUpdateQuery("catalog_product_entity_varchar", 
                                        "$book[IMAGE]", 
                                        array(entity_id => $id, attribute_id => bo_image_id));

        $queries[] = createUpdateQuery("catalog_product_entity_varchar", 
                                        "$book[IMAGE]", 
									    array(entity_id => $id,  attribute_id => bo_small_image_id));

        $queries[] = createUpdateQuery("catalog_product_entity_varchar", 
                                        "$book[THUMB]", 
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
                    $queries = generateUpdateSQLs($id, $book);
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
