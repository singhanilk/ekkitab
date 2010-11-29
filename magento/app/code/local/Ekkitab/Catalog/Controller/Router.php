<?php

class Ekkitab_Catalog_Controller_Router extends Mage_Core_Controller_Varien_Router_Standard {

    public function match(Zend_Controller_Request_Http $request) {
    	
        $path = explode('/', trim($request->getPathInfo(), '/'));
        
        // Mage::log("In Custom Router: " . $request->getPathInfo());
                
        if (count($path) == 2) {
        	switch ($path[0]) {
        		case 'book':  			$module = "ekkitab_catalog";
        					  			$realModule = "Ekkitab_Catalog";
        					  			$controller = "product";
        					  			$action = "view";
        					  			break; 
        		case 'book-collection': $module = "ekkitab_catalog"; 
        								$realModule = "Ekkitab_Catalog";
        								$controller = "globalsection";
        								$action = "view";
        								$path[0] = "id";
        								break;
        		case 'book-category': 	$module = "ekkitab_catalog";
        							  	$realModule = "Ekkitab_Catalog";
        							  	$controller = "search";
        							  	$action = "index";
        							  	$path[0] = "category";
        							  	break;
        		case 'book-article': 	$module = "ekkitab_content";
        							 	$realModule = "Ekkitab_Content";
        							 	$controller = "index";
        							 	$action = "view";
        							 	$path[0] = "page";
        							 	break;
        		default: return false;
        	}	
        }
        else {
        	return false;
        }
        
        if (!$request->getModuleName()) {
        	// Mage::log("DEBUG>> Setting Module Name: $module");
        	$request->setModuleName($module);
        }
        
        if (!$request->getControllerName()) {
        	// Mage::log("DEBUG>> Setting Controller Name: $controller");
        	$request->setControllerName($controller);	
        }
        
        if (!$request->getActionName()) {
        	// Mage::log("DEBUG>> Setting Action Name: $action");
        	$request->setActionName($action);	
        }
        
        if (!$request->getControllerModule()) {
        	// Mage::log("DEBUG>> Setting Controller Module Name: $realModule");
        	$request->setControllerModule($realModule);	
        }
        
        $request->setParam($path[0], $path[1]);
        
    	return false;
    }
}

