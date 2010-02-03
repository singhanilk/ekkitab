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
// @version 1.0     Jan 19, 2010


// This function hashes an image file name to include two characters in the front.
// The first character will be between A-Z and the second will be the same as 
// the last character of the file name without the extension.
// This is used to distribute the image file over a series of directories because
// magento uses the first two characters to determine folder location and since
// most ISBNs have the same first two characters ie. 9 and 7, they all end up in
// the same directory if not rehashed using this function.

function gethash($file) {
    $sum = 0;
    $name = substr($file, 0, strrpos($file, "."));
    for ($i = 0; $i<(strlen($name)); $i++)  {
        $sum += substr($name,$i,$i+1) + 0;
    }
    return (chr(65 + $sum%26)) . substr($name,strlen($name)-1,1) . $file;
}
?>

