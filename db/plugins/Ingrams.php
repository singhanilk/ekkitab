<?php
error_reporting(E_ALL  & ~E_NOTICE);
ini_set("display_errors", 1); 
include(EKKITAB_HOME . "/" . "db" . "/" . "importbooks_config.php");

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

        function __construct($mode) {
            $this->mode = $mode;
        }

        function isBook($line) {

            if ($this->mode & MODE_BASIC) {
                switch(substr($line, 412, 1)) {
                   case 'B':
                   case 'N':  return true;
                   default:   return false;
                }
            }
            if ($this->mode & MODE_PRICE) {
                switch(substr($line,217,1)) {
                   case 'P':
                   case 'Q':
                   case 'R':  return true;
                   default:   return false;
                }
            }
            if ($this->mode & MODE_DESC) {
                return true;
            }
            return false;
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
            $book['isbn10'] = trim(substr($line, 0, 10));
            $book['title']  = $this->escape(trim(substr($line, 11, 149)));
            $edition = trim(substr($line, 191, 4));
            $edition = $edition . "  " . trim(substr($line, 195, 15));
            $book['edition'] = $this->escape($edition);
            $author = "";
            $illustrator = "";
            $role = trim(substr($line, 265,2));
            if ((!strcmp($role, "A")) || (!strcmp($role, "JA")) || (!strcmp($role, "AA")) || (!strcmp($role, "E"))) {
                $author = substr($line, 225, 40);
                $author = $this->correctName($author);
            }
            if (!strcmp($role, "I")) {
                $illustrator = substr($line, 225, 40);
                $illustrator = $this->correctName($illustrator);
            }
            $role = trim(substr($line, 307,2));
            if ((!strcmp($role, "A")) || (!strcmp($role, "JA")) || (!strcmp($role, "AA")) || (!strcmp($role, "E"))) {
                $tmp = substr($line, 267, 40);
                $tmp = $this->correctName($tmp);
                $author = $author . " & ". $tmp;
            }
            if (!strcmp($role, "I")) {
                $tmp = substr($line, 267, 40);
                $tmp = $this->correctName($tmp);
                $illustrator = $illustrator . " & " . $tmp;
            }
            $role = trim(substr($line, 349,2));
            if ((!strcmp($role, "A")) || (!strcmp($role, "JA")) || (!strcmp($role, "AA")) || (!strcmp($role, "E"))) {
                $tmp = substr($line, 309, 40);
                $tmp = $this->correctName($tmp);
                $author = $author . " & ". $tmp;
            }
            if (!strcmp($role, "I")) {
                $tmp = substr($line, 309, 40);
                $tmp = $this->correctName($tmp);
                $illustrator = $illustrator . " & " . $tmp;
            }
            $illustrator = preg_replace("/^ & /", "", $illustrator);
            $author = preg_replace("/^ & /", "", $author);
            $book['illustrator'] = $illustrator;
            $book['author'] = $this->escape($author);
            $book['publisher'] = $this->escape(trim(substr($line, 351, 45)));
            $book['isbn'] = trim(substr($line, 442, 17));
            $binding = substr($line, 410, 2);
            if (substr($binding, 0, 1) == 'T')  {
                $q = substr($binding, 1, 1) ;
                if ($q == 'P') {
                    $book['binding'] = "paperback";
                }
                elseif ($q == 'C') {
                    $book['binding'] = "hardcover";
                }
                else 
                    $book['binding'] = "unknown";
            }
            $book['bisac'][0] = trim(substr($line, 463, 9));
            $book['bisac'][1] = trim(substr($line, 532, 9));
            $book['bisac'][2] = trim(substr($line, 601, 9));
            $book['pages'] = trim(substr($line, 787, 5));
            $book['weight'] = trim(substr($line, 797,  7)) / 1.6;
            $book['dimension'] = (trim(substr($line, 804, 5)) / 100)*2.54 . "x" . (trim(substr($line, 809, 5))/100)*2.54 . "x" . (trim(substr($line, 814, 5))/100)*2.54;
            //$book['pubcode'] = trim(substr($line, 827,  4));
            $book['image'] = $book['isbn'].".jpg";
            $book['sourced_from'] = "US";
			$book['delivery_period'] = 14 ;
            $book['info_source'] = "Ingrams";	
            $book['language'] = "English";	
            $book['shipping_region'] = 0;	
            return($book);
        }

		function getPrice($line, $book, $db, $logger){
            
			$isbn = substr($line,1,13);
			
			$listprice    = substr($line,150,6)/100;
			$discount     = substr($line,163,3);
			
			//Extracting the Supplier Discount Info
			if ($discount = 'REG'){
				$discount = 40;
			}
			elseif ($dicount = 'NET'){
				$discount = 0;
			}
			elseif ($discount = 'LOW'){
				$discount = 20;
			}
			else{
				$discount = str_replace("%", "", $discount);
			}
			
			//Extracting the Stock Info
			$stock = 0;
			$distCenterStk = array();
			$pos = 38;

			while($pos <= 60){
				$distCenterStk[] = substr($line,38,7) ;
				$pos = $pos + 7;
			}
			$distCenterStk[] = substr($line,87,7) ;

			foreach($distCenterStk as $value){
				if($value > 0){
					$stock = 1;
				}
			}
			
			if($discount == 0){
				$stock = 0;
			}

			//Extracting the Pub-Date
			$pubdate = substr($line,185,8) ;
						
			$book['list_price']		    = $listprice;
			$book['suppliers_discount'] = $discount;
			$book['currency']           = "USD" ;
			$book['in_stock']           = $stock ;
            $book['isbn']               = $isbn ;
			$book['publishing_date']    = $pubdate ;
            $book['info_source']        = "Ingrams";	
			return($book);
		}
		
		function getDesc($line, $book, $db, $logger) {
			$book['isbn']  = substr($line,0,13);
			$description  = substr($line,18);
			$description = str_replace("'", "", $description);
            if (strlen($description) > MAX_DESCRIPTION_LENGTH) {
                $description = substr($description, 0, MAX_DESCRIPTION_LENGTH - 4);
                $description .= " ...";
            }
		    $book['description'] = $description;
            return($book);
		}
}
?>