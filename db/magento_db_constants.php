<?php	

define (IMAGE_DIRECTORY_OFFSET, "/100k/");
define (CPE, 0);
define (CPEDT, 1);
define (CPEDE, 2);
define (CPEIN, 3);
define (CPEMG, 4);
define (CPETX, 5);
define (CPEVC, 6);
define (CISI, 7);

define (ISBN,'ISBN');
define (AUTHOR,'AUTHOR');
define (TITLE,'TITLE');
define (PRICE,'LIST_PRICE');
define (BINDING,'BINDING');
define (WEIGHT,'WEIGHT');
define (PAGES,'PAGES');
define (BISAC,'BISAC1');
define (BISAC2,'BISAC2');
define (BISAC3,'BISAC3');
define (PUBLISHER,'PUBLISHER');
define (PDATE,'PUBLISHING_DATE');
define (DESCRIPTION,'DESCRIPTION');
define (ISBN10,'ISBN10');
define (LANGUAGE,'LANGUAGE');
define (DISCOUNT,'DISCOUNT');
define (DELIVERY,'DELIVERY_PERIOD');
define (IMAGE,'IMAGE');
define (THUMB,'COVER_THUMB');
define (IN_STOCK,'IN_STOCK');
define (QTY,'QTY');
define (DIMENSION,'DIMENSION');
define (ILLUSTRATOR,'ILLUSTRATOR');
define (EDITION,'EDITION');
define (EDITORIAL_REVIEW,'EDITORIAL_REVIEW');
define (SHIPPING_REGION,'SHIPPING_REGION');
define (RATING,'RATING');
define (PRODUCT_STATUS,'PRODUCT_STATUS');
define (INT_SHIPPING,'INT_SHIPPING');
define (SOURCE,'INFO_SOURCE');

// constants used in the script

define (store_id,0);           //magento store id
define (entity_type_id ,4);    //magento entitiy type id
define (attribute_set_id,26);  //magento book attribute set id
define (has_options,0);	       //value for has_options
define (required_option,0);	   //value for required_options
define (option_enable,1);	   
define (option_disable,0);
define (gift_message_value,2);


// constants used for varchar table

define (name_id,56);			 				 // book title eav_attribute code
define (meta_title_id,67);	       				 // book meta title eav_attribute code
define (meta_description_id,69);   				 // book meta description eav_attribute code
define (bo_image_id, 70);		   				 // book image eav attribute code
define (bo_small_image_id,71);     				 // book small image eav attribute code
define (bo_thumb_image_id,72);     				 // book thumb image eav attribute code	
define (url_key_id,82); 		   				 // id of the url key used for product url 
define (url_id,83);	  			   				 // id of the url used for product url
define (options_container, 92);    				 // options container eav attribute code
define (image_label_id, 95); 	   				 // id of label for book image 
define (small_image_label_id, 96); 				 // id of label for small book image
define (thumb_label_id ,97);	   				 // id of label for thumb book image
define (gift_message_avialable_id ,469);		 // id of the gift_message_aviable
define (bo_author_id,496); 						 // book author eav attribute code
define (bo_isbn_id,497);	  					 // book isbn-13 eav attribute code
define (bo_binding_id,499);						 // book binding type eav attribute code
define (bo_isbn10_id,500); 						 // book isbn-13 eav attribute code
define (bo_language_id,503);					 // book language attribute code
define (bo_no_pg_id,504);						 // book no of pages eav attribute code
define (bo_dimension_id,505);					 // book dimension eav attribute code
define (bo_illustrator_id,506);					 // book illustrator eav attribute code
define (bo_edition_id,507);						 // book edition attribute code
define (bo_rating_id,509);						 // book rating attribute code
define (bo_shipping_region_id,511);				 // book shipping region attribute code
define (options_container_value,"container2");   // value of the option_container


// constants used for decimal
define (price_id,60);			// book price(listed price in IND) attribute code
define (special_price_id,61);	// book discounted price attribute code
define (weight_id,65);			// book Weight attribute code

// constants used for int
define (status_id,80);					// book status attribute code
define (tax_class_id,81);				// book tax class attribute code
define (visibility_id,85);				// book visibility attribute code
define (enable_googlecheckout_id,467);	// book enable google check out attribute code
define (bo_int_shipping_id,508);		// international shipping available attribute code

//constants used for text 
define (descrption_id,57);			// book description attribute code
define (short_descrption_id,58);	// book short description attribute code
define (meta_keyword_id,68);		// book meta keyword attribute code
define (custom_layout_update_id,89);// book custom layout update attribute code
define (bo_publisher_id,502);		// book publisher attribute code

//constants used for media gallery
define (media_gallery_id,73);
define (media_position,1);

//constant used for datetime
define (bo_pu_date_id,501);		// book publishing date eav attribute code

//constant used for catalog_category_product_index
define (book_visibility_value,4);

//constants used for catalogindex_eav
define (catalogindex_eav_store_id,1); // value for store attribute
define (tax_class_value,0);			  // Value for tax class id
define (website_id,1);				  // Value for website_id field

//constants used for  catalogindex_price
define (catalogindex_price_user_0,0);			// value for catalogindex_price_coustomer_group_id
define (catalogindex_price_user_1,1);			// value for catalogindex_price_coustomer_group_id
define (catalogindex_price_user_2,2);			// value for catalogindex_price_coustomer_group_id
define (catalogindex_price_user_3,3);			// value for catalogindex_price_coustomer_group_id
define (catalogindex_price_qty_value,0.0000);	// Value for catalogindex_price_qty 

//constants used for  catalogindex_stock_item
define (stock_id,1);							// value for stock_id
define (min_qty,0.0000);						// value for min_qty
define (use_config_min_qty,1);					// value for use_config_min_qty
define (is_qty_decimal,0);						// value for is_qty_decimal
define (backorders,0);							// value for backorders
define (use_config_backorders,0);				// value for use_config_backorders
define (min_sale_qty,1.0000);					// value for min_sale_qty
define (use_config_min_sale_qty,1);				// value for use_config_min_sale_qty
define (use_config_max_sale_qty,1);				// value for use_config_max_sale_qty
define (max_sale_qty,0.0000);					// value for max_sale_qty
define (is_in_stock,1);							// value for is_in_stock
define (use_config_notify_stock_qty,1);			// value for use_config_notify_stock_qty
define (manage_stock,1);						// value for manage_stock
define (use_config_manage_stock,1);				// value for use_config_manage_stock
define (stock_status_changed_automatically,0);	// value for stock_status_changed_automatically

//catalogindex_stock_status
define (stock_status,1);						// value for stock_status


//catalog_category_product_index
define (position,0);							// value for position
define (is_parent_0,0);							// value for is_parent_0
define (is_parent_1,1);							// value for is_parent_1
define (root_category_value,2);					// value for root_category_value
define (value_default,'default');				// constant for default string
define (value_empty,'');						// constant for empty string
