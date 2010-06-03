<?php
error_reporting(E_ALL  & ~E_NOTICE);
ini_set("display_errors", 1); 
include(EKKITAB_HOME . "/" . "config" . "/" . "ekkitab.php");
include(EKKITAB_HOME . "/" . "bin" . "/" . "convertisbn.php");
define (REQUIRED_BASIC_FIELDS, 13);
define (REQUIRED_PRICE_FIELDS, 4);

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

class Parser {
        private $mode;
        private $supplierparams;

        function __construct($mode) {
            $this->mode = $mode;
        }

        function isBook($line) {
            if ($line[0] == '#')
                return false;
            $fields = explode("\t", $line);
            if (($this->mode == MODE_BASIC) && (count($fields) != REQUIRED_BASIC_FIELDS)) {
                return false;
            } 
            elseif (($this->mode == MODE_PRICE) && (count($fields) != REQUIRED_PRICE_FIELDS)) {
                return false;
            } 
            return true;
        }

        /** 
          * Ensure that characters in a string are SQL safe. 
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

        function correctName($name) {
           $tmp = explode(",", $name);
           switch (count($tmp)) {
               case 1: $name = trim($name);
                       break;
               case 2: $name = trim($tmp[1]) . " " . trim($tmp[0]);
                       break;
               default: break;
           }
           return $name;
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

        function getBook($line, $book, $db, $logger) {
            if (!$this->isBook($line)) { 
                return null;
            }
            if ($this->mode & MODE_BASIC) { 
               $book = $this->getBasic($line, $book, $db, $logger);
               if ($book == null)
                  return null;
            }
            if ($this->mode & MODE_DESC) {
               $book = $this->getDesc($line, $book, $db, $logger);
               if ($book == null)
                  return null;
            }
            if ($this->mode & MODE_PRICE) {
               $book = $this->getPrice($line, $book, $db, $logger);
               if ($book == null)
                  return null;
            }
            return $book;
        }

        function getBasic($line, $book, $db, $logger) {
            $fields = explode("\t", $line);
            $isbn = trim($fields[0]);
            if (strlen($isbn) == 13) {
                $book['isbn']        = $isbn;
                $book['isbn10']      = convertisbn($isbn);
            }
            else {
                $book['isbn10']      = $isbn;
                $book['isbn']        = convertisbn($isbn);
            }
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
            $book['info_source']     = "Penguin India";	
            $book['sourced_from']    = "India";
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
            $book['isbn'] = str_replace("\"", "", trim($fields[0]));
            $book['distributor'] = "Penguin";
            switch (str_replace("\"", "", strtoupper(trim($fields[1])))) {
                case 'I'  : $book['currency'] = "INR";
                            break;
                case 'P'  : $book['currency'] = "BRI";
                            break;
                case 'U'  : $book['currency'] = "USD";
                            break;
                case 'C'  : $book['currency'] = "CAN";
                            break;
                default:    $book['currency'] = "XXX";
                            throw new exception("Unknown currency " . str_replace("\"", "", strtoupper(trim($fields[1]))));
                            break;
            }
			$book['list_price'] = str_replace("\"", "", trim($fields[2]));
			$book['suppliers_discount'] = $this->getSuppliersDiscount($db, $book['distributor'], "Any");
            if ($book['suppliers_discount'] == null) {
                throw new exception("No supplier discount data for " . $book['distributor']);
            }
            $availability = trim(str_replace("\"", "", $fields[3]));
            if (!strcmp(strtoupper($availability), "AVAILABLE")) {
			    $book['in_stock'] = 1;
            }
            else {
			    $book['in_stock'] = 0;
            }

            $book['delivery_period'] = $this->getDeliveryPeriod($db, $book['distributor'], "Any");
            if ($book['delivery_period'] == null) {
                throw new exception("No delivery period data for " . $book['distributor']);
            }

            return $book;
        }
            
		function getDesc($line,$book, $db, $logger){
            $fields = explode("\t", $line);
			$description  = trim($fields[4]);
			$book['description'] = str_replace("'", "\'", $description);
            $book['isbn'] = trim($fields[0]);
            return $book;
        }


}
?>
