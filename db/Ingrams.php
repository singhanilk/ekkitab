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
// @author Vijaya Raghavan (vijay@ekkitab.com)
// @version 1.0     Dec 17, 2009
//

// This script will import books into the reference database from a vendor file......

class Parser {
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

        function getBook($line) {
            $book = array();
            $book['isbn10'] = trim(substr($line, 0, 10));
            $book['title']  = $this->escape(trim(substr($line, 11, 149)));
            $edition = trim(substr($line, 191, 4));
            $edition = $edition . "  " . trim(substr($line, 195, 15));
            $book['edition'] = $this->escape($edition);
            $author = "";
            $illustrator = "";
            $role = trim(substr($line, 265,2));
            if ((!strcmp($role, "A")) || (!strcmp($role, "JA")) || (!strcmp($role, "AA")))
                $author = trim(substr($line, 225, 40));
            if (!strcmp($role, "I"))
                $illustrator = trim(substr($line, 225, 40));
            $role = trim(substr($line, 307,2));
            if ((!strcmp($role, "A")) || (!strcmp($role, "JA")) || (!strcmp($role, "AA")))
                $author = $author . " & ". trim(substr($line, 267, 40));
            if (!strcmp($role, "I"))
                $illustrator = $illustrator . " & " . trim(substr($line, 225, 40));
            $role = trim(substr($line, 349,2));
            if ((!strcmp($role, "A")) || (!strcmp($role, "JA")) || (!strcmp($role, "AA")))
                $author = $author . " & ". trim(substr($line, 309, 40));
            if (!strcmp($role, "I"))
                $illustrator = $illustrator . " & " . trim(substr($line, 225, 40));
            $illustrator = preg_replace("/^ & /", "", $illustrator);
            $book['illustrator'] = $illustrator;
            $book['author'] = $this->escape($author);
            $book['publisher'] = $this->escape(trim(substr($line, 351, 45)));
            $book['isbn13'] = trim(substr($line, 442, 17));
            $book['bisac'][0] = trim(substr($line, 463, 9));
            $book['bisac'][1] = trim(substr($line, 532, 9));
            $book['bisac'][2] = trim(substr($line, 601, 9));
            $book['pages'] = trim(substr($line, 787, 5));
            $book['weight'] = trim(substr($line, 797,  7)) / 1.6;
            $book['dimension'] = (trim(substr($line, 804, 5)) / 100)*2.54 . "x" . (trim(substr($line, 809, 5))/100)*2.54 . "x" . (trim(substr($line, 814, 5))/100)*2.54;
            $book['pubcode'] = trim(substr($line, 827,  4));
            $book['thumbnail'] = $book['isbn13'].".jpg";
            $book['image'] = $book['thumbnail'];
            return($book);
        }
}
?>
