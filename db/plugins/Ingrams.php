<?php
require_once(dirname(__FILE__) . "/" . "BaseParser.php");
define (MIN_STOCK_LEVEL, 1);

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

        private $months = array("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec");

        function __construct($mode, $db, $logger, $discountmodel) {
            parent::__construct($mode, $db, $logger, $discountmodel);
        }

        function isBook($line) {

            $isbn = "";

            if ($this->mode & MODE_BASIC) {
                switch(substr($line, 412, 1)) {
                   case 'B':
                   case 'N':  $isbn = trim(substr($line, 442, 17));
                              break;
                   default:   break;
                }
                if (strcmp(strtoupper(substr($line, 834,3)), "ENG")){
                   $isbn = ""; 
                }
            }
            elseif ($this->mode & MODE_PRICE) {
                switch(substr($line,220,1)) {
                   case 'P':
                   case 'Q':
                   case 'R':  $isbn = substr($line,1,13);
                              break;
                   default:   break;
                }
            }
            elseif ($this->mode & (MODE_DESC | MODE_PROMO)) {
                $isbn  = substr($line,0,13);
            }
            return $isbn;
        }


        function getContributionPrefix($role) {
            $prefix = "";
            switch(trim($role)) {
                case "ec":
                case "ev":
                case "E":  
                        $prefix = ":e:";
                        break;
                case "I":  
                        $prefix = ":i:";
                        break;
                case "P":  
                        $prefix = ":p:";
                        break;
                case "TB":  
                case "T":  
                        $prefix = ":t:";
                        break;
                case "Y":  
                        $prefix = ":n:";
                        break;
                case "9":  
                case "8":  
                case "7":  
                case "6":  
                case "5":  
                case "4":  
                case "3":  
                case "2":  
                case "1":  
                case "0":  
                case "Z":  
                case "Y":  
                case "W":  
                case "V":  
                case "U":  
                case "TT":  
                case "S":  
                case "Q":  
                case "L":  
                case "K":  
                case "J":  
                case "H":  
                case "F":  
                case "ES":  
                case "D":  
                case "BI":  
                case "B":  
                        $prefix = ":c:";
                        break;
                default:    
                        break;
            }
            return $prefix;
        }
        
        function getBinding($code) {
            $binding = "";
            $code = strtoupper($code);
            switch($code) {
                case "AT": $binding = "Activity Book";
                           break;
                case "BA": 
                case "BD": $binding = "Cloth/Bath/Board";
                           break;
                case "BL": $binding = "Bonded Leather";
                           break;
                case "BX": $binding = "Boxed Set";
                           break;
                case "CB": 
                case "CT": $binding = "Coil/Cloth Textbook";
                           break;
                case "MS": 
                case "MU": 
                case "TY": 
                case "DL": $binding = "Book and Merchandise";
                           break;
                case "FB": 
                case "FF": $binding = "Fabric/Folded";
                           break;
                case "IL": $binding = "Imitation Leather";
                           break;
                case "LB": $binding = "Library Binding";
                           break;
                case "LE": $binding = "Leather";
                           break;
                case "LL": $binding = "Loose Leaf";
                           break;
                case "MM": 
                case "TP": $binding = "Paperback";
                           break;
                case "TC": $binding = "Hardcover";
                           break;
                case "PB": $binding = "Prebound";
                           break;
                case "PI": $binding = "Picture Book";
                           break;
                case "SP": $binding = "Spiral";
                           break;
                case "RL": $binding = "Reinforced Library";
                           break;
                case "RB": $binding = "RingBound";
                           break;
                case "PO": $binding = "Printed Paper over Board";
                           break;
                case "PT": $binding = "Paper Textbook";
                           break;
                default:   break;

            }
            return $binding;
        }

        function getBasic($line, $book, $db, $logger) {
            $book['isbn10'] = trim(substr($line, 0, 10));
            $book['title']  = stripslashes(trim(substr($line, 11, 149)));
            $edition = trim(substr($line, 191, 4));
            $edition = $edition . "  " . trim(substr($line, 195, 15));
            $book['edition'] = $this->escape($edition);
            $author = "";
            $illustrator = "";
            $role = trim(substr($line, 265,2));
            $author = stripslashes(trim(substr($line, 225, 40)));
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
            $binding = substr($line, 410, 2);
            $book['binding'] = $this->getBinding($binding);
            $book['bisac'][0] = trim(substr($line, 463, 9));
            $book['bisac'][1] = trim(substr($line, 532, 9));
            $book['bisac'][2] = trim(substr($line, 601, 9));
            $book['pages'] = trim(substr($line, 787, 5));
            $book['weight'] = trim(substr($line, 797,  7)) / 1.6;
            $book['dimension'] = (trim(substr($line, 804, 5)) / 100)*2.54 . "x" . (trim(substr($line, 809, 5))/100)*2.54 . "x" . (trim(substr($line, 814, 5))/100)*2.54;
            //$book['pubcode'] = trim(substr($line, 827,  4));
            $book['image'] = $book['isbn'].".jpg";
            $book['language'] = "English";    
            return($book);
        }

        function getPrice($line, $book, $db, $logger){
            
            $listprice    = substr($line,150,7)/100;
            $discount     = substr($line,165,3);
            
            //Extracting the Supplier Discount Info
            if (!strcmp($discount, "REG")){
                $discount = 40;
            }
            elseif (!strcmp($discount, "NET")){
                $discount = 0;
            }
            elseif (!strcmp($discount, "LOW")){
                $discount = 20;
            }
            else{
                $discount = str_replace("%", "", $discount);
            }

            // Add $3.00 to list price to recover shipping costs if we get zero discount from supplier. 
            if ($discount == 0) {
                $listprice += 3.00;
            }

            $currency = "USD";

            $book = array_merge($book, $this->getSellingPrice($currency, $listprice, $discount));

            //Extracting the Stock Info
            $stock = 0;
            $distCenterStk = array();
            $pos = 38;

            // Consider only the Tennessee Distribution Center.
            $distCenterStk[0] = substr($line,$pos,7) ;
            if ($distCenterStk[0] >= MIN_STOCK_LEVEL) {
                $stock = 1;
            }

            /*  Consider all Stock Distribution Centers.
            while($pos <= 60){
                $distCenterStk[] = substr($line,$pos,7) ;
                $pos = $pos + 7;
            }

            foreach($distCenterStk as $value){
                if($value > 0){
                    $stock = 1;
                        break;
                }
            }
            */
            

            //Extracting the Pub-Date
            $pubyear = substr($line,188,4) ;
            $pubmonth = (int)substr($line,192,2);
            if ($pubmonth > 0) {
                $nameofmonth = $this->months[$pubmonth - 1];
            }
            else {
                $nameofmonth = "Jan";  // Default if month is uncertain
            }
            $pubdate = $nameofmonth . "-" . $pubyear;
            //$book['list_price']            = $listprice;
            //$book['suppliers_discount'] = $discount;
            $book['currency']           = $currency ;
            $book['in_stock']           = $stock ;
            $book['publishing_date']    = $pubdate ;
            $book['info_source']        = "Ingrams";    
            $book['delivery_period']    = 14 ;
            $book['sourced_from']       = "US";
            $book['info_source']        = "Ingrams";    
            $book['shipping_region']    = 0;    
            return($book);
        }
        
        function getDesc($line, $book, $db, $logger) {
            $description  = substr($line,15);
            $description = str_replace("'", "", $description);
            if (strlen($description) > MAX_DESCRIPTION_LENGTH) {
                $description = substr($description, 0, MAX_DESCRIPTION_LENGTH - 4);
                $description .= " ...";
            }
            $book['description'] = $description;
                return($book);
        }

        function getPromo($line, $book, $db, $logger) {
            $length        = substr($line,13,5);
            $promo         = addslashes(substr($line,18,$length));
            if(preg_match('/[^(\x20-\x7f)]/',$promo)){
                $book = null; 
            }
            else{
                $book['promo'] = $promo;
            }
            return($book);
        }
}
?>
