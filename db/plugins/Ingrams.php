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
                   case 'N':  break;
                   default:   return false;
                }
                if (strcmp(strtoupper(substr($line, 834,3)), "ENG")){
                   return false;
                }
                return true;
            }
            if ($this->mode & MODE_PRICE) {
                switch(substr($line,220,1)) {
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
        function getContributionPrefix($role) {
            $prefix = "";
            switch($role) {
                case "ec":
                case "ev":
                case "E ":  
                        $prefix = ":e:";
                        break;
                case "I ":  
                        $prefix = ":i:";
                        break;
                case "P ":  
                        $prefix = ":p:";
                        break;
                case "TB":  
                case "T ":  
                        $prefix = ":t:";
                        break;
                case "Y ":  
                        $prefix = ":n:";
                        break;
                case "9 ":  
                case "8 ":  
                case "7 ":  
                case "6 ":  
                case "5 ":  
                case "4 ":  
                case "3 ":  
                case "2 ":  
                case "1 ":  
                case "0 ":  
                case "Z ":  
                case "Y ":  
                case "W ":  
                case "V ":  
                case "U ":  
                case "TT":  
                case "S ":  
                case "Q ":  
                case "L ":  
                case "K ":  
                case "J ":  
                case "H ":  
                case "F ":  
                case "ES":  
                case "D ":  
                case "BI":  
                case "B ":  
                        $prefix = ":c:";
                        break;
                default:    
                        break;
            }
            return $prefix;
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
            $author = trim(substr($line, 225, 40));
            if (strlen($author) > 0) {
                $cprefix = $this->getContributionPrefix($role);
                $author = $cprefix . $this->correctName($author);
            }
            $role = trim(substr($line, 307,2));
            $tmp = trim(substr($line, 267, 40));
            if (strlen($tmp) > 0) {
                $cprefix = $this->getContributionPrefix($role);
                $tmp = $cprefix . $this->correctName($tmp);
                $author = $author . " & ". $tmp;
            }
            $role = trim(substr($line, 349,2));
            $tmp = trim(substr($line, 309, 40));
            if (strlen($tmp) > 0) {
                $cprefix = $this->getContributionPrefix($role);
                $tmp = $cprefix . $this->correctName($tmp);
                $author = $author . " & ". $tmp;
            }
            $author = preg_replace("/^ & /", "", $author);
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
			
			$listprice    = substr($line,150,7)/100;
			$discount     = substr($line,165,3);
			
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
				$distCenterStk[] = substr($line,$pos,7) ;
				$pos = $pos + 7;
			}
			//$distCenterStk[] = substr($line,87,7) ;

			foreach($distCenterStk as $value){
				if($value > 0){
					$stock = 1;
                    break;
				}
			}
			
			//if($discount == 0){
		    //		$stock = 0;
		    //	}

			//Extracting the Pub-Date
			$pubdate = substr($line,188,8) ;
						
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
			$description  = substr($line,15);
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
