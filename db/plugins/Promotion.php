<?php
require_once(dirname(__FILE__) . "/" . "BaseParser.php");

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
// @author Vijaya Raghavan (vijay@ekkitab.com)
// @version 1.0     Nov 14, 2010
//

// This script will import promos into the reference database from a vendor file......


class Parser extends BaseParser {
        private $supplierparams;

        function __construct($mode, $db, $logger, $discountmodel) {
            parent::__construct($mode, $db, $logger, $discountmodel);
        }

        function isBook($line) {

            $isbn = "";

            if ($line[0] == '#')
                return $isbn;

            $fields = explode("\t", $line);

            $isbn = trim($fields[0]); 

            if (!preg_match("/^[0-9X]+$/", $isbn)) {
                $isbn = "";
                return $isbn;
            }

            if (strlen($isbn) != 13) {
                if (strlen($isbn) == 10) {
                    $isbn = convertisbn($isbn);
                }
                else {
                    $isbn = "";
                }
            } 
            return $isbn;
        }

        function getBasic($line, $book, $db, $logger) {
            $fields = explode("\t", $line);

            $book['isbn10']          = convertisbn($book['isbn']);
            $book['title']           = $this->escape(trim($fields[1]));
            $book['author']          = "";
            $book['binding']         = "";
            $book['publishing_date'] = "";
            $book['publisher']       = $this->escape(trim($fields[2]));
            $book['pages']           = "";
            $book['language']        = "";
            $book['weight']          = "";
            $book['dimension']       = "";
            $book['shipping_region'] = "1";
            $book['image']           = $book['isbn'].".jpg";
            $book['bisac'][]         = "ZZZ000000";
            return($book);
        }

		function getPrice($line, $book, $db, $logger){
            $fields = explode("\t", $line);

            $book['distributor'] = trim($fields[3]);
            $book['currency'] = "INR";
            $book['list_price'] = preg_replace("/[\",]/", "", trim($fields[4]));
            $book['suppliers_price'] = preg_replace("/[\",]/", "", trim($fields[6]));
            $book['discount_price'] = preg_replace("/[\",]/", "", trim($fields[5]));
            $book['suppliers_discount'] = preg_replace("/[\",]/", "", trim($fields[7]));
            $book['in_stock'] = 1;
            $book['delivery_period'] = preg_replace("/[\",]/", "", trim($fields[8]));
            $book['info_source']     = strtoupper($book['distributor']);	
            $book['sourced_from']    = "India";

            return $book;
        }
            
		function getDesc($line,$book, $db, $logger){
			$book['description'] = "";
            return $book;
        }


}
?>
