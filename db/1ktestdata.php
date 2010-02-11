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
	function escape($str) {
            $pattern[0] = "/[~\\\\]*'/";
            #$pattern[1] = "/\(/"; 
            #$pattern[1] = "/\)/"; 
            $replace[0] = "\'";
            #$replace[1] = "\\\(";
            #$replace[1] = "\\\)";
            return(preg_replace($pattern, $replace, $str));
	}

	function getBook($line) {
            $book = array();
			$line = trim($line);
			$data = explode("~",$line);
			$book['title']          = $this->escape(trim($data[0]));
			$book['author']         = $this->escape(trim($data[1]));
			$book['isbn13']         = $this->escape(trim($data[2]));
			$book['binding']        = $this->escape(trim($data[3]));
			$book['publisher']      = $this->escape(trim($data[6]));
			$book['pages']          = $data[7];
			$book['weight']         = 0;
			$book['dimension']      = '';
			$book['edition']        = $data[13];
			$book['sourced_from']   = $data[12];
			$book['bisac'][0]       = $data[14];
			$book['thumbnail']      = $this->escape(trim($data[2]));
			$book['image']          = $this->escape(trim($data[2]));
			$book['isbn']           = "";
			return($book);
	}

	function getStockPrice($line){
		    $book = array();
		    $line = trim($line);
		    $data = explode("~",$line);
			$book['LIST_PRICE']         = $data[8];
			$book['SUPPLIERS_DISCOUNT'] = 30;
			$book['SUPPLIERS_PRICE']    = $data[10];
			$book['CURRENCY']           = "'$data[11]'";
			$book['PUBLISHING_DATE']    = "'$data[5]'";
			$book['ISBN']			    = $data[2];
			$book['IN_STOCK']           = 1;
			$book['DELIVERY_PERIOD']    = 14;

			return($book);
	}

    function getBookDescription($line,$type){
			$book = array();
		    $line = trim($line);
		    $data = explode("~",$line);
			$description = $this->escape(trim($data[4]));
			$book['DESCRIPTION'] = "'$description'";
			$book['ISBN']    	 = $data[2];

			
			return($book);

	}

}




?>
