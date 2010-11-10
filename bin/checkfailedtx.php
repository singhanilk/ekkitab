<?php
error_reporting(E_ALL  & ~E_NOTICE);
ini_set("display_errors", 1); 
$EKKITAB_HOME=getenv("EKKITAB_HOME");
if (strlen($EKKITAB_HOME) == 0) {
    echo "EKKITAB_HOME is not defined...Exiting.\n";
    exit(1);
}
else {
    define(EKKITAB_HOME, $EKKITAB_HOME); 
}
define("CONFIG_FILE", "ekkitab.ini");
define("CHECK_INTERVAL", 1);
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
// @version 1.0     Nov 03, 2010
//

// This script will check on all failed transactions for the period specified and
// will send email to the respective users...

    ini_set(include_path, ${include_path}.PATH_SEPARATOR.EKKITAB_HOME."/"."config");
   
    $config  = parse_ini_file(CONFIG_FILE, true);
    if (! $config) {
        echo "[Fatal] Configuration file missing or incorrect.\n";
	exit (1);
    }
 
    $dbserver  = $config[database][server];
    $dbuser    = $config[database][user];
    $dbpsw     = $config[database][password];
    $ekkitabdb = $config[database][ekkitab_db];

    $db = null;

    try  {
       $db     = mysqli_connect($dbserver,$dbuser,$dbpsw,$ekkitabdb);
    }
    catch (exception $e) {
       echo "[Fatal] Db Error." . $e->getmessage() . "\n";
       exit(1);
    }

    if (! $db) {
       echo "[Fatal] Database connection failed.\n";
       exit (1);
    }

    $query = "select qa.email,qa.firstname,qa.lastname,qi.name from sales_order so, sales_order_int oi, sales_flat_quote_item qi, sales_order_varchar ov,`sales_flat_quote_address` qa  where so.entity_id = oi.entity_id and so.entity_id = ov.entity_id and so.updated_at >= (now() -interval " . CHECK_INTERVAL . " day) and qa.quote_id = oi.value and oi.attribute_id=118 and ov.attribute_id=106 and qa.address_type='billing' and qi.quote_id = oi.value and qa.email not in (select qa.email from sales_order so, sales_order_int oi, sales_order_varchar ov,`sales_flat_quote_address` qa  where so.entity_id = oi.entity_id and so.entity_id = ov.entity_id and so.updated_at >= (now() -interval " . CHECK_INTERVAL . " day) and qa.quote_id = oi.value and oi.attribute_id=118 and ov.attribute_id=106 and qa.address_type='billing' and ov.value in ('processing', 'complete'))";

    try {
       $result = mysqli_query($db, $query);
       if (($result) && (mysqli_num_rows($result) > 0)) {
          while ($row = mysqli_fetch_array($result)) {
              $email = $row['email'];
              $firstname = ucwords($row['firstname']);
              $lastname = ucfirst($row['lastname']);
	      $title = preg_replace("/\&#([0-9a-f]+);/e", "chr('\\1')", $row['name']);
	      echo "$email\t$firstname $lastname\t$title\n";
          }
       }
    }
    catch(exception $e) {
       echo "[Fatal] Db Error." . $e->getmessage() . "\n";
       exit(1);
    }
    mysqli_close($db);

?>
