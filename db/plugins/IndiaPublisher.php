<?php
define (REQUIRED_BASIC_FIELDS, 13);
define (REQUIRED_PRICE_FIELDS, 5);
define (LOCAL_DELIVERY_PERIOD, 3);
define (NON_LOCAL_SOURCING_COST, 40);

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
// @version 1.0     Dec 17, 2009
// @version 1.1     Feb 03, 2010 (arun@ekkitab.com)
//

// This script will import books into the reference database from a vendor file......


class Parser extends BaseParser {
        private $supplierparams;

        function __construct($mode, $db, $logger, $discountmodel) {
            parent::__construct($mode, $db, $logger, $discountmodel);
        }

        function getBisacCodes($db, $subjects) {
            $bisac_codes = array();
            if ($subjects != null) {
                foreach ($subjects as $subject) {
                    $topics = explode("/", $subject);
                    $query = "select bisac_code from ek_bisac_category_map where ";
                    $i = 1;
                    $conjunction = "";
                    foreach($topics as $topic) {
                        $label = "level".$i++;
                        $value = strtolower(trim($topic));
                        $query = $query . $conjunction . $label . " = '" . $value . "'";
                        $conjunction = " and ";
                    }
                    $result = mysqli_query($db, $query);
                    if (($result) && (mysqli_num_rows($result) > 0)) {
	                    $row = mysqli_fetch_array($result);
                        $bisac_codes[] = $row[0];
                    }
                }
            }
            if (empty($bisac_codes)) {
                if (strcmp($subjects[0], "--")) {
                    foreach($subjects as $subject) {
                      echo "( $subject ) ";
                    }
                    echo "\n";
                }
                $bisac_codes[] = "ZZZ000000";
            }
            return $bisac_codes;
        }

        function getDeliveryPeriod($db, $supplier, $publisher) {
            if (strlen($supplier) > 0) {
                $supplier = strtolower($supplier);
            }
            if (empty($this->supplierparams)) {
                $this->supplierparams = $this->initSupplierParams($db);
            }
            if (!strcmp($supplier, strtolower(UNKNOWN_INFO_SOURCE))) {
                foreach($this->supplierparams as $supplier => $pubs) {
                    foreach($pubs as $pub => $val) {
                        if (stripos("!".$publisher, $pub) == 1) {
                            return $this->supplierparams[$supplier][$pub]['days'];
                        }
                    }
                }
            }
            else {
                if (!empty($this->supplierparams[$supplier])) {
                    foreach($this->supplierparams[$supplier] as $pub => $val) {
                        if (stripos("!".$publisher, $pub) == 1) {
                            return $this->supplierparams[$supplier][$pub]['days'];
                        }
                    }
                } 
            }
            return null;
            /*
            if ((!empty($this->supplierparams[$supplier])) &&
                (!empty($this->supplierparams[$supplier][$publisher])))
                return $this->supplierparams[$supplier][$publisher]['days'];
            else 
                return null;
            */
        }
    
        function initSupplierParams($db) {
            $params = array();
            $query  = "select * from ek_supplier_params"; 
            $result = mysqli_query($db, $query);
            if (($result) && (mysqli_num_rows($result) > 0)) {
                while($row = mysqli_fetch_array($result)) {
                    $params[strtolower($row[1])][strtolower($row[2])]['discount'] = $row[3];
                    $params[strtolower($row[1])][strtolower($row[2])]['days'] = $row[4];
                }
            }
            else {
                throw new exception("Failed to get supplier params from the database");
            }
            return ($params);
        }

        function getSuppliersDiscount($db, $supplier, $publisher) {

            if (strlen($supplier) > 0) {
                $supplier = strtolower($supplier);
            }
            if (empty($this->supplierparams)) {
                $this->supplierparams = $this->initSupplierParams($db);
            }
            if (!strcmp($supplier, strtolower(UNKNOWN_INFO_SOURCE))) {
                foreach($this->supplierparams as $supplier => $pubs) {
                    foreach($pubs as $pub => $val) {
                        if (stripos("!".$publisher, $pub) == 1) {
                            return $this->supplierparams[$supplier][$pub]['discount'];
                        }
                    }
                }
            }
            else {
                if (!empty($this->supplierparams[$supplier])) {
                    foreach($this->supplierparams[$supplier] as $pub => $val) {
                        if (stripos("!".$publisher, $pub) == 1) {
                            return $this->supplierparams[$supplier][$pub]['discount'];
                        }
                    }
                } 
            }
            return null;
            /*
            if ((!empty($this->supplierparams[$supplier])) &&
                (!empty($this->supplierparams[$supplier][$publisher])))
                return $this->supplierparams[$supplier][$publisher]['discount'];
            else 
                return null;
            */
        }

        function isBook($line) {

            $isbn = "";

            if ($line[0] == '#')
                return $isbn;

            $fields = explode("\t", $line);

            if (($this->mode & MODE_BASIC) && (count($fields) != REQUIRED_BASIC_FIELDS)) {
                return $isbn;
            } 
            elseif (($this->mode &  MODE_PRICE) && (count($fields) < REQUIRED_PRICE_FIELDS)) {
                return $isbn;
            } 

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
            $book['author']          = $this->escape(trim($fields[2]));
            $book['binding']         = trim($fields[3]);
            $book['publishing_date'] = trim($fields[5]);
            $book['publisher']       = $this->escape(trim($fields[6]));
            $book['pages']           = trim($fields[7]);
            $book['language']        = trim($fields[8]);
            $book['weight']          = trim($fields[9]);
            $book['dimension']       = trim($fields[10]);
            $book['shipping_region'] = trim($fields[11]);
            $book['image']           = $book['isbn'].".jpg";

            $bisaccodes = array();
            //$bisaccodes[] = trim($fields[16]);
            //$book['bisac'] = $this->getBisacCodes($db, $bisaccodes);
            $bisaccodes = explode(",", trim($fields[12]));
            foreach($bisaccodes as $bisac) {
               $book['bisac'][] = trim($bisac);
            }


            return($book);
        }

		function getPrice($line, $book, $db, $logger){
            $fields = explode("\t", $line);

            $book['distributor'] = trim($fields[4]);
            switch (str_replace("\"", "", strtoupper(trim($fields[1])))) {
                case 'I'  : $book['currency'] = "INR";
                            break;
                case 'P'  : $book['currency'] = "BRI";
                            break;
                case 'U'  : $book['currency'] = "USD";
                            break;
                case 'C'  : $book['currency'] = "CAN";
                            break;
                case 'E'  : $book['currency'] = "EUR";
                            break;
                case 'S'  : $book['currency'] = "SGD";
                            break;
                case 'A'  : $book['currency'] = "AUD";
                            break;
                default:    $book['currency'] = "XXX";
                            throw new exception("Unknown currency for ISBN " . $book['isbn'] . " -> '" . str_replace("\"", "", strtoupper(trim($fields[1]))) . "'");
                            break;
            }
            $listprice = preg_replace("/[\",]/", "", trim($fields[2]));
			//$book['list_price'] = preg_replace("/[\",]/", "", trim($fields[2]));
			//$book['suppliers_discount'] = $this->getSuppliersDiscount($db, $book['distributor'], "Any");
			$suppliersdiscount = $this->getSuppliersDiscount($db, $book['distributor'], "Any");
            if ($suppliersdiscount == null) {
                throw new exception("No supplier discount data for " . $book['distributor']);
            }
            $book = array_merge($book, $this->getSellingPrice($book['currency'], $listprice, $suppliersdiscount)); 
            $availability = trim(str_replace("\"", "", $fields[3]));
            if (!strcmp(strtoupper($availability), "AVAILABLE")) {
			        $book['in_stock'] = 1;
            }elseif (!strcmp(strtoupper($availability), "PREORDER")) {
			        $book['in_stock'] = 2;
            } else {
			        $book['in_stock'] = 0;
            }
            if(count($fields) > REQUIRED_PRICE_FIELDS){
                $book['delivery_period'] = $fields[5];
            }
            else{
                $book['delivery_period'] = $this->getDeliveryPeriod($db, $book['distributor'], "Any");
            }
            if ($book['delivery_period'] == null) {
                throw new exception("No delivery period data for " . $book['distributor']);
            }

            // Alter discount based on location of book source.
            // Ensure that altered discount is at least 5%. If not, zero out discount.

            if ($book['delivery_period'] > LOCAL_DELIVERY_PERIOD) {
                $tmp = $book['discount_price'] + NON_LOCAL_SOURCING_COST;
                if ($tmp > $book['list_price']){
                    $tmp = $book['list_price'];
                }
                elseif ((($book['list_price'] - $tmp) / $book['list_price']) < 0.05){
                    $tmp = $book['list_price'];
                }
                $book['discount_price'] = $tmp;
            }
            $book['info_source']     = strtoupper($book['distributor']);	
            $book['sourced_from']    = "India";

            return $book;
        }
            
		function getDesc($line,$book, $db, $logger){
            $fields = explode("\t", $line);
			$description  = trim($fields[4]);
			$book['description'] = str_replace("'", "\'", $description);
            return $book;
        }


}
?>
