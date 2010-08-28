<?php
error_reporting(E_ALL  & ~E_NOTICE);
ini_set("display_errors", 1); 
include(EKKITAB_HOME . "/" . "config" . "/" . "ekkitab.php");
include(EKKITAB_HOME . "/" . "bin" . "/" . "convertisbn.php");

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
//

// This is the base parser class. 

class BaseParser  {
        protected $mode;
        private $discountmodel;
        private $db;
        private $logger;
        private $currencyrates;
         

        function __construct($mode, $db, $logger, $discountmodel) {
            $this->mode = $mode;
            $this->discountmodel = $discountmodel;
            $this->db = $db;
            $this->logger = $logger;
            $this->currencyrates = $this->getCurrencyConversionRates($db);
        }
    
        function fatal($message, $query = "") {
	        throw new exception("$message " . (strlen($query) > 0 ? "[ $query ]" . "\n" : ""));
        }

        function warn($message, $query = "") {
	        $this->logger->error("$message " . (strlen($query) > 0 ? "[ $query ]" . "\n" : ""));
        }

        function debug($message, $query = "") {
	        $this->logger->debug("$message " . (strlen($query) > 0 ? "[ $query ]" . "\n" : ""));
        }

        function info($message, $query = "") {
	        $this->logger->info("$message " . (strlen($query) > 0 ? "[ $query ]" . "\n" : ""));
        }

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
    
        function getCurrencyConversionRates($db) {
            $currencyrates = array();
            $query    = "select * from ek_currency_conversion"; 
            try {
                $result = mysqli_query($db, $query);
                if (($result) && (mysqli_num_rows($result) > 0)) {
                    while($row = mysqli_fetch_array($result)) {
                        $type = strtoupper($row[1]);
                        $currencyrates[$type] = $row[2];
                    }
                }
                else {
                    throw new exception("Failed to get currency data from database");
                }
            }
            catch(exception $e) {
               $this->fatal($e->getmessage());
            }
            return ($currencyrates);
        }

        function getBook($line) {

            $isbn = $this->isBook($line);

            if ($isbn == "") { 
                return null;
            }

            $book = array();
            $book['isbn'] = $isbn;

            if ($this->mode & MODE_BASIC) { 
               $book = $this->getBasic($line, $book, $this->db, $this->logger);
               if ($book == null)
                  return null;
            }
            if ($this->mode & MODE_DESC) {
               $book = $this->getDesc($line, $book, $this->db, $this->logger);
               if ($book == null)
                  return null;
            }
            if ($this->mode & MODE_PRICE) {
               $book = $this->getPrice($line, $book, $this->db, $this->logger);
               if ($book == null)
                  return null;
            }
	        if ($this->mode & MODE_PROMO){
               $book = $this->getPromo($line, $book, $this->db, $this->logger);
               if ($book == null)
                  return null;
	        }
            return $book;
        }

        function getSellingPrice($currency, $listprice, $suppliersdiscount) {

            $conv_rate = $this->currencyrates[strtoupper($currency)];
            if (empty($conv_rate)) {
                 $this->fatal("No currency conversion rate available for " . $currency);
            }
            $originallistprice = $listprice;
            $listprice = round($listprice * $conv_rate);

            $discountlevel = null;
            if ((count($this->discountmodel) == 1) && (!strcmp(strtoupper($this->discountmodel[0]['level']), "ANY"))) {
                $discountlevel = $this->discountmodel[0];
            }
            else {
                foreach ($this->discountmodel as $level) {
                    if ($level['level'] == $suppliersdiscount) {
                        $discountlevel = $level;
                        break;
                    }
                    elseif ($level['level'] > $suppliersdiscount) {
                        break;
                    }
                    $discountlevel = $level;
                }
            }

            $offer = array();
            $offer['min'] = 0;
            $offer['max'] = 0;
            $price['min'] = 0;
            $price['max'] = 0;

            if ($discountlevel != null) {
                foreach ($discountlevel['ranges'] as $range) {
                    if (($listprice > $range['min']) && ($listprice <= $range['max'])) {
                       $offer['min'] = $range['discountmin']; 
                       $offer['max'] = $range['discountmax']; 
                       $price['min'] = $range['min']; 
                       $price['max'] = $range['max']; 
                    }
                }
            }
            $pricerange = $price['max'] - $price['min'];
            if ($pricerange > 0) {
                $fraction = ($listprice - $price['min'])/$pricerange;
            }
            else {
                $fraction = 0;
            }
            $ourdiscount = $offer['min'] + ($fraction * ($offer['max'] - $offer['min']));


            $suppliersprice = round($listprice * ((100 - $suppliersdiscount)/100));
            $ourprice = round($listprice * ((100 - $ourdiscount)/100));

            $result = array();
            $result['list_price'] = $listprice;
            $result['suppliers_price'] = $suppliersprice;
            $result['discount_price'] = $ourprice;
            $result['suppliers_discount'] = $suppliersdiscount;

            // echo "List Price: $originallistprice --  Discount: $ourdiscount -- Discount Price: $ourprice  -- Suppliers Discount: $suppliersdiscount\n";

            return $result;
        }
}
?>
