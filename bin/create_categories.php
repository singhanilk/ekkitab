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
// @version 1.0     Dec 13, 2009
//

// This script will create category information in the ekkitab database. 

    include("create_categories_config.php");

    require_once(LOG4PHP_DIR . '/LoggerManager.php');

    // global logger
    $logger =& LoggerManager::getLogger("create_categories");

   /** 
    * Log the error and terminate the program.
    * Optionally, will accept the query that failed.
    */
    function fatal($message, $query = "") {
        global $logger;
	    $logger->fatal("$message " . "[ $query ]" . "\n");
        exit(1);
    }

   /** 
    * This function will log the error.
    * Optionally, will accept the query that failed.
    */
    function warn($message, $query = "") {
        global $logger;
	    $logger->error("$message " . "[ $query ]" . "\n");
    }

   /** 
    * Read and return the configuration data from file. 
    */
    function getConfig($file) {
	    $config	= parse_ini_file($file, true);
        if (! $config) {
            fatal("Configuration file missing or incorrect."); 
        }
        return $config;
    }

   /** 
    * Initialize the files to read from and write into. 
    */
    function initFiles($config) {
        if (! $config) 
            return NULL;

	    $input  = $config[files][categorydata];
	    $output = $config[files][categoryscript];

        echo "Input file is: $input\n";
        echo "Output file is: $output\n";

        $fh_in = fopen($input, "r"); 
        if (! $fh_in )
            fatal("Could not open input file: $input\n"); 
        $fh_out = fopen($output, "w"); 
        if (! $fh_out )
            fatal("Could not open output file: $output\n"); 

        return (array('in' => $fh_in, 'out' => $fh_out));
    }

   /** 
    * Initialize the files to read from and write into. 
    */
    function closeFiles($fhandles) {
        fclose($fhandles['in']);
        fclose($fhandles['out']);
    }


    function build_category_db($fh) {

        global $mastercodes;
        global $mastercats;

        if (! $fh)
            return;

        while ($line = fgets($fh)) {
            if (substr($line,0,1) == '#')  //comment
                continue;
            $line_array = explode ("%", rtrim($line));
            if (count($line_array) == 2) {
                $code = strtok($line_array[0], "\"");
                $fullcat = strtok($line_array[1], "\"");
                $cats = explode("/", $fullcat);
                $fullcat = "";
                $tmp = &$mastercats;
                for ($i = 0; $i < count($cats); $i++) {
                    $level = trim($cats[$i]);
                    $fullcat = $fullcat . ($i == 0 ? "" : "/") . $level;
                    if (! array_key_exists($level, $tmp)) {
                        $tmp[$level] = array();
                    }
                    $tmp = &$tmp[$level];
                }
                if (! array_key_exists($fullcat, $mastercodes) ) 
                    $mastercodes[$fullcat] = array($code => 0); 
            }
        }
    }

    function createInserts($name, $value, $level, $position, $parent, $id, $path, $fullcatname) {

        global $mastercodes;

        $tmpstatements = array();
        $statements = array();

        if (is_array($value) && (count($value) > 0)) {
            $childposition = 1;
            foreach($value as $key => $newvalue) {
               $tmpstatements = array_merge($tmpstatements,  
                                            createInserts($key, $newvalue, $level+1, 
                                                          $childposition++, $id, 
                                                          $id+1+count($tmpstatements), 
                                                          $path."/".$id, $fullcatname."/".$key));
            }
        }

        $statements[0] = "($id, 3, 3, $parent, curdate(), curdate(), " . 
                         "'" .$path . "/$id". "', " . $position . 
                         ", ".$level. ", " . count($tmpstatements) . "),\n" ;

        if (! array_key_exists($fullcatname, $mastercodes)) 
            $mastercodes[$fullcatname] = array("Internal" => $path."/".$id);
        else {
            $keys = array_keys($mastercodes[$fullcatname]);
            if (count($keys) == 1) {
                $mastercodes[$fullcatname][$keys[0]] = $path."/".$id;
            }
        }

        return (array_merge($statements, $tmpstatements));
    }

    function writeCatalogCategoryEntityStatements($fh) {

        global $mastercats;

        fputs($fh, "use `ekkitab_books`;\n");
    
        $header = "INSERT INTO `catalog_category_entity` " .
                  "(`entity_id`, `entity_type_id`, `attribute_set_id`, " .
                  "`parent_id`, `created_at`, `updated_at`, `path`, `position`, " .
                  "`level`, `children_count`) VALUES\n";

        $statements = array();

        foreach($mastercats as $key => $value) {
            $statements = array_merge($statements, createInserts($key, $value, 2, 1, 2, 3+count($statements), "1/2", $key));
        }

        $i = 0;

        foreach($statements as $statement) {
    
            if ($i%50 == 0) {
                if($i == 0) {
                    fputs($fh, $header);
                    $line = "(1, 3, 0, 0, curdate(), curdate(), '1', 1, 0, 1),\n";
                    fputs($fh, $line);
                    $line = "(2, 3, 3, 0, curdate(), curdate(), '1/2', 1, 1, ". count($statements). "),\n";
                    fputs($fh, $line);
                    fputs($fh, $statement);
                } 
                else {
                    $statement = substr($statement, 0, strrpos($statement, ","));
                    $statement = $statement . ";\n";
                    fputs($fh, $statement);
                    if ($i < (count($statements) - 1))
                        fputs($fh, $header);
                }
            }
            elseif ($i == (count($statements) - 1)) {
                $statement = substr($statement, 0, strrpos($statement, ","));
                $statement = $statement . ";\n";
                fputs($fh, $statement);
            }
            else 
                fputs($fh, $statement);
            $i++;
        }
        return (count($statements) + 2);
    }

    function writeRefDbStatements($fh) {

        global $mastercodes;

        fputs($fh, "use `reference` ;\n");

        $header = "INSERT INTO `ek_bisac_category_map` " .
                  "(`bisac_code`, `level1`, `level2`, `level3`, " .
                  "`level4`, `level5`, `level6`, `level7`, `category_id`, `rewrite_url`) VALUES\n";

        $mastercodes_copy = array();

        foreach($mastercodes as $fullpath => $val) {
            $keys = array_keys($val); 
            if (count($keys) != 1)
                echo "Internal Error!\n";
            if (strcmp($keys[0], "Internal")) {
                $mastercodes_copy[$fullpath] = $val;
            }
        }

        $i = 0;
        $pattern[0] = "/'/"; 
        $pattern[1] = "/#/"; 
        $pattern[2] = "/\W+/"; 
        $replace[0] = "";
        $replace[1] = "h#";
        $replace[2] = "-";

        foreach($mastercodes_copy as $fullpath => $val) {

            $cats = explode("/", $fullpath);
            $requestpath = "";
            for ($j=0; $j<count($cats); $j++) {
                $tmppath = strtolower(trim($cats[$j]));
                $tmppath = str_replace("'", "", $tmppath);
                $tmppath = preg_replace($pattern, $replace, $tmppath);
                $requestpath = $requestpath . ($j == 0 ? "" : "/") . $tmppath; 
                $cats[$j] = strtolower(trim($cats[$j])); 
                $cats[$j] = str_replace("'", "\'", $cats[$j]);
            }
            $requestpath = $requestpath . ".html";

            $keys = array_keys($val); 
            #if (count($keys) != 1)
            #    echo "Internal Error!\n";

            $catId = $val[$keys[0]]; 
            $catId = str_replace("1/2/", "", $catId);
            $catId = str_replace("/", ",", $catId);
            $catCode = $keys[0];
            #if (!strcmp($catCode, "Internal")) {
            #    $i++;
            #    continue;
            #}

            $line = "('".$catCode."', ";  
            for ($j=0; $j<count($cats); $j++) {
                $line = $line . "'". $cats[$j] . "', ";
            }
            for ($j = count($cats); $j<7; $j++) {
                $line = $line . "'', ";
            }
            $line = $line . "'$catId'" .","."'$requestpath'"."),\n";  

            if ($i%50 == 0) {
                if($i == 0) {
                    fputs($fh, $header);
                    fputs($fh, $line);
                } 
                else {
                    $line = substr($line, 0, strrpos($line, ","));
                    $line = $line . ";\n";
                    fputs($fh, $line);
                    if ($i < (count($mastercodes_copy) - 1))
                        fputs($fh, $header);
                }
            }
            elseif ($i == (count($mastercodes_copy) - 1)) {
                $line = substr($line, 0, strrpos($line, ","));
                $line = $line . ";\n";
                fputs($fh, $line);
            }
            else 
                fputs($fh, $line);

            $i++;
        }
    }

    function writeCatalogCategoryEntityIntStatements($fh, $maxId) {

        fputs($fh, "use `ekkitab_books` ;\n");

        $header = "INSERT INTO `catalog_category_entity_int` " .
                  "(`entity_type_id`, `attribute_id`, " .
                  "`store_id`, `entity_id`, `value`) VALUES\n";

        for ($i = 0; $i <= $maxId; $i++) {

            if ($i >= 2) {
                $line = "(3, 32, 0, " . $i . ", 1),\n";  
                $line = $line . "(3, 41, 0, " . $i . ", 1),\n";  
                $line = $line . "(3, 49, 0, " . $i . ", 1),\n";  
            }
            else 
                $line = "\n";

            if ($i%20 == 0) {
                if($i == 0) {
                    fputs($fh, $header);
                    fputs($fh, $line);
                } 
                else {
                    $line = substr($line, 0, strrpos($line, ","));
                    $line = $line . ";\n";
                    fputs($fh, $line);
                    if ($i != $maxId)
                        fputs($fh, $header);
                }
            }
            elseif ($i == $maxId) {
                $line = substr($line, 0, strrpos($line, ","));
                $line = $line . ";\n";
                fputs($fh, $line);
            }
            else 
                fputs($fh, $line);

        }
    }

    function writeCatalogCategoryEntityTextStatements($fh, $maxId) {

        fputs($fh, "use `ekkitab_books` ;\n");

        $header = "INSERT INTO `catalog_category_entity_text` " .
                  "(`entity_type_id`, `attribute_id`, " .
                  "`store_id`, `entity_id`, `value`) VALUES\n";

        for ($i = 0; $i <= $maxId; $i++) {

            if ($i >= 2) {
                $line = "(3, 34, 0, " . $i . ", ''),\n";  
                $line = $line . "(3, 37, 0, " . $i . ", ''),\n";  
                $line = $line . "(3, 38, 0, " . $i . ", ''),\n";  
                $line = $line . "(3, 53, 0, " . $i . ", ''),\n";  
                $line = $line . "(3, 98, 0, " . $i . ", ''),\n";  
            }
            else 
                $line = "\n";

            if ($i%15 == 0) {
                if($i == 0) {
                    fputs($fh, $header);
                    fputs($fh, $line);
                } 
                else {
                    $line = substr($line, 0, strrpos($line, ","));
                    $line = $line . ";\n";
                    fputs($fh, $line);
                    if ($i != $maxId)
                        fputs($fh, $header);
                }
            }
            elseif ($i == $maxId) {
                $line = substr($line, 0, strrpos($line, ","));
                $line = $line . ";\n";
                fputs($fh, $line);
            }
            else 
                fputs($fh, $line);

        }
    }

    function writeCatalogCategoryEntityVarcharStatements($fh) {

        global $mastercodes;

        fputs($fh, "use `ekkitab_books` ;\n");

        $header = "INSERT INTO `catalog_category_entity_varchar` " .
                  "(`entity_type_id`, `attribute_id`, " .
                  "`store_id`, `entity_id`, `value`) VALUES\n";

        $i = 0;

        $pattern[0] = "/'/"; 
        $pattern[1] = "/\W+/"; 
        $replace[0] = "";
        $replace[1] = "-";

        foreach($mastercodes as $fullpath => $val) {

            $keys = array_keys($val); 
            if (count($keys) != 1)
                echo "Internal Error!\n";
            if (strrpos($val[$keys[0]], "/") > 0)
                $catId = substr($val[$keys[0]], strrpos($val[$keys[0]], "/")+1);
            else 
                $catId = $val[$keys[0]]; 
            $cats = explode("/", $fullpath);
            $urlkey = "";
            $catname = ucwords(strtolower(trim($cats[count($cats) - 1]))); 
            $catname = str_replace("'", "", $catname);
            $urlkey = preg_replace($pattern, $replace, $catname);

            $line = "(3, 31, 0, " . $catId . ", '". $catname ."'),\n";  
            $line = $line . "(3, 33, 0, " . $catId . ", '" . $urlkey . "'),\n";  
            $line = $line . "(3, 36, 0, " . $catId . ", ''),\n";  
            $line = $line . "(3, 39, 0, " . $catId . ", 'PRODUCTS'),\n";  
            $line = $line . "(3, 48, 0, " . $catId . ", ''),\n";  
            $line = $line . "(3, 52, 0, " . $catId . ", ''),\n";  
            $line = $line . "(3, 47, 1, " . $catId . ", '" . $urlkey . ".html'),\n";  
            $line = $line . "(3, 47, 0, " . $catId . ", '" . $urlkey . ".html'),\n";  

            if ($i%15 == 0) {
                if($i == 0) {
                    fputs($fh, $header);
                    fputs ($fh, "(3, 31, 0, 1, 'Root Catalog'),\n");
                    fputs ($fh, "(3, 33, 1, 1, 'Root Catalog'),\n");
                    fputs ($fh, "(3, 33, 0, 1, 'root-catalog'),\n");
                    fputs ($fh, "(3, 31, 0, 2, 'Books'),\n");
                    fputs ($fh, "(3, 33, 0, 2, 'default-category'),\n");
                    fputs ($fh, "(3, 39, 0, 2, 'PRODUCTS'),\n");
                    fputs($fh, $line);
                } 
                else {
                    $line = substr($line, 0, strrpos($line, ","));
                    $line = $line . ";\n";
                    fputs($fh, $line);
                    if ($i < (count($mastercodes) - 1))
                        fputs($fh, $header);
                }
            }
            elseif ($i == (count($mastercodes) - 1)) {
                $line = substr($line, 0, strrpos($line, ","));
                $line = $line . ";\n";
                fputs($fh, $line);
            }
            else 
                fputs($fh, $line);

            $i++;

        }

    }

    function writeCoreUrlReWriteStatements($fh) {

        global $mastercodes;

        fputs($fh, "use `ekkitab_books` ;\n");

        $header = "INSERT INTO `core_url_rewrite` " .
                  "(`store_id`, `category_id`, " .
                  "`id_path`, `request_path`, " .
                  "`target_path`, `options`) VALUES\n";

        $i = 0;

        $pattern[0] = "/'/"; 
        $pattern[1] = "/#/"; 
        $pattern[2] = "/\W+/"; 
        $replace[0] = "";
        $replace[1] = "h#";
        $replace[2] = "-";

        foreach($mastercodes as $fullpath => $val) {

            $keys = array_keys($val); 
            if (count($keys) != 1)
                echo "Internal Error!\n";
            if (strrpos($val[$keys[0]], "/") > 0)
                $catId = substr($val[$keys[0]], strrpos($val[$keys[0]], "/")+1);
            else 
                $catId = $val[$keys[0]]; 
            $cats = explode("/", $fullpath);
            $requestpath = "";
            for ($z = 0; $z < count($cats); $z++) {
                $tmppath = strtolower(trim($cats[$z]));
                $tmppath = str_replace("'", "", $tmppath);
                $tmppath = preg_replace($pattern, $replace, $tmppath);
                $requestpath = $requestpath . ($z == 0 ? "" : "/") . $tmppath; 
            }
            $requestpath = $requestpath . ".html";
            $idpath = "category/".$catId;
            $targetpath = "catalog/category/view/id/".$catId;

            $line = "(1, " . $catId . ", '" . $idpath . "', '" . $requestpath . "', '" . $targetpath . "', ''),\n";  

            if ($i%50 == 0) {
                if($i == 0) {
                    fputs($fh, $header);
                    fputs($fh, $line);
                } 
                else {
                    $line = substr($line, 0, strrpos($line, ","));
                    $line = $line . ";\n";
                    fputs($fh, $line);
                    if ($i < (count($mastercodes) - 1))
                        fputs($fh, $header);
                }
            }
            elseif ($i == (count($mastercodes) - 1)) {
                $line = substr($line, 0, strrpos($line, ","));
                $line = $line . ";\n";
                fputs($fh, $line);
            }
            else 
                fputs($fh, $line);

            $i++;

        }

    }

    $mastercodes = array();
    $mastercats = array();

    $config = getConfig(CREATE_CATEGORIES_INI);

    $fhandles = array();
    $fhandles = initFiles($config);

    echo "Building catalog category db....";
    build_category_db($fhandles['in']);
    echo "done.\n";
    echo "Writing catalog category entity statements....";
    $maxId = writeCatalogCategoryEntityStatements($fhandles['out']);
    echo "done. Maximum id = $maxId\n";
    echo "Writing catalog category entity int attributes....";
    writeCatalogCategoryEntityIntStatements($fhandles['out'], $maxId);
    echo "done.\n";
    echo "Writing catalog category entity text attributes....";
    writeCatalogCategoryEntityTextStatements($fhandles['out'], $maxId);
    echo "done.\n";
    echo "Writing catalog category entity varchar attributes....";
    writeCatalogCategoryEntityVarcharStatements($fhandles['out']);
    echo "done.\n";
    echo "Writing core url rewrite statements....";
    writeCoreUrlReWriteStatements($fhandles['out']);
    echo "done.\n";
    echo "Writing reference database statements....";
    writeRefDbStatements($fhandles['out']);
    echo "done.\n";

    closeFiles($fhandles);    

?>
