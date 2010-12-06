<?php

class Ekkitab_Catalog_Controller_Router extends Mage_Core_Controller_Varien_Router_Standard {

    private function getISBN($path) {
        $pattern = "/^.*?([0-9X]{10,13}).*$/";
        return preg_replace($pattern, "$1", $path);
    }

    public function match(Zend_Controller_Request_Http $request) {
    	
        $path = explode('/', trim($request->getPathInfo(), '/'));
        
        // Mage::log("In Custom Router: " . $request->getPathInfo());
                
        if (count($path) == 1) {
        	switch ($path[0]) {
        		case 'institutes':			$module = "ekkitab_institute";
        							 		$realModule = "Ekkitab_Institute";
        							 		$controller = "search";
        							 		$action = "listAll";
        							 		break;
        		case 'my-institutes':		$module = "ekkitab_institute";
        							 		$realModule = "Ekkitab_Institute";
        							 		$controller = "search";
        							 		$action = "myinstitutes";
        							 		break;
        		case 'create-institute':	$module = "ekkitab_institute";
	        							 	$realModule = "Ekkitab_Institute";
	        							 	$controller = "account";
	        							 	$action = "create";
	        							 	break;
        		default: return false;
			}
		}
        elseif (count($path) == 2) {
        	switch ($path[0]) {
        		case 'book':  			$module = "ekkitab_catalog";
        					  			$realModule = "Ekkitab_Catalog";
        					  			$controller = "product";
        					  			$action = "view";
                                        $path[1] = $this->getISBN($path[1]);
        					  			break; 
        		case 'book-detail':  	$module = "ekkitab_catalog";
        					  			$realModule = "Ekkitab_Catalog";
        					  			$controller = "product";
        					  			$action = "show";
                                        $path[0] = "book";
                                        $path[1] = $this->getISBN($path[1]);
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
        		case 'book-author':		$module = "ekkitab_catalog";
        							 	$realModule = "Ekkitab_Catalog";
        							 	$controller = "search";
        							 	$action = "index";
        							 	$path[0] = "author";
        							 	break;
        		case 'books':			$module = "ekkitab_catalog";
        							 	$realModule = "Ekkitab_Catalog";
        							 	$controller = "search";
        							 	$action = "select";
        							 	break;
        		case 'view-institute':	$module = "ekkitab_institute";
										$realModule = "Ekkitab_Institute";
										$controller = "account";
										$action = "view";
        							 	$path[0] = "id";
        							 	break;
        		default: return false;
        	}	
			$request->setParam($path[0], $path[1]);
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
        
        
    	return false;
    }
}

