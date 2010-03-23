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
// @author Arun Kuppuswamy (Arun@ekkitab.com)
// @version 1.0     Feb 05, 2010
//

// This script will import books into the reference database from a Test file......

class Parser {
    private $mode;

    function __construct($mode) {
       $this->mode = $mode;
    }

    function isBook($line) {
       return true;
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
			$line = trim($line);
			$data = explode("~",$line);
			$book['title']          = $this->escape(trim($data[0]));
			$book['author']         = $this->escape(trim($data[1]));
			$book['isbn']           = $this->escape(trim($data[2]));
			$book['binding']        = $this->escape(trim($data[3]));
			$book['publisher']      = $this->escape(trim($data[6]));
			$book['pages']          = $data[7];
			$book['weight']         = 0;
			$book['dimension']      = '';
			$book['edition']        = $data[13];
			$book['sourced_from']   = $data[12];
			$book['bisac'][0]       = $data[14];
			$book['image']          = $this->escape(trim($data[2]));
			$book['isbn']           = "";
			$book['delivery_period']= 14;
            $book['info_source']    = "1ktestdata";	
            $book['language']       = "English";	
            $book['shipping_region']= 0;	
			return($book);
	}

	function getPrice($line, $book, $db, $logger){
		    $line = trim($line);
		    $data = explode("~",$line);
			$book['list_price']         = $data[8];
			$book['suppliers_discount'] = 0;
			$book['suppliers_price']    = $data[10];
			$book['currency']           = $data[11];
			$book['publishing_date']    = $data[5];
			$book['isbn']			    = $data[2];
			$book['in_stock']           = 1;
            $book['info_source']        = "1ktestdata";	
			return($book);
	}

    function getDesc($line,$book, $db, $logger){
		    $line = trim($line);
		    $data = explode("~",$line);
			$description = $this->escape(trim($data[4]));
			$book['description'] = $description;
			$book['isbn']    	 = $data[2];
			return($book);
	}

}




?>
