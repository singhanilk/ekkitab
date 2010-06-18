<?php
/**
 * Product controller
 *
 * @category   Ekkitab
 * @package    Ekkitab_Catalog
 * @author Anisha (anisha@ekkitab.com)
 * @version 1.0 Feb 10, 2010
 * 
 * @package    Local_Ekkitab
 * @copyright  COPYRIGHT (C) 2009 Ekkitab Educational Services India Pvt. Ltd.
 * @license    All Rights Reserved. All material contained in this file (including, but not limited to, text, images, graphics, HTML, programming code and scripts) 
 * constitute proprietary and  * confidential information protected by copyright laws, trade secret and other laws. No part of this software may be copied, reproduced, modified or 
 * distributed in any form or by any means, or stored in a database or retrieval system without the prior written permission of Ekkitab Educational Services.
 */

class Ekkitab_Catalog_ProductController extends Mage_Core_Controller_Front_Action
{
    /**
     * Initialize requested product object
     *
     * @return Mage_Catalog_Model_Product
     */
    public function viewAction()
    {
		Mage::getSingleton('core/session')->setCurrentCategoryPath(array('current_category_path'=>''));
        Mage::getSingleton('core/session')->setCurrentQueryText(array('current_query_text'=>''));
		
		$this->_forward('show');
    }

    /**
     * Initialize requested product object
     *
     * @return Mage_Catalog_Model_Product
     */
    public function showAction()
    {
		$productUrl  = (String) $this->getRequest()->getParam('book');

		// insert the split function here.....and get the product Id
		$productIdStartIndex = strrpos($productUrl, "__")+2; 	  
		$productIdEndIndex = strpos($productUrl, ".html"); 	
		$productIdEndIndex = $productIdEndIndex - $productIdStartIndex;  //.html/	
		$productId = trim(urldecode(substr($productUrl,$productIdStartIndex,$productIdEndIndex)));

		
		if( $productId && $this->isIsbn($productId)){
			//this is isbn.....
			Mage::register('productId', $productId);
			$this->loadLayout();
			$this->renderLayout();
		}else {
			$productId = (int) $productId;
			if (!$productId || $productId <= 0) {
				$productId  = (int) $this->getRequest()->getParam('id');
			}
			if (!$productId || $productId <= 0) {
				$this->_forward('noRoute');
			}
			else{
				Mage::register('productId', (int)$productId);
				$this->loadLayout();
				$this->renderLayout();
			}
		}
    }

	/**
     * Retrieve search result count
     *
     * @return boolean
     */
    public function isIsbn($str)
    {
		$str=trim($str);
		if(preg_match("/^[0-9]*$/",$str)){
			if (strlen($str) == 12 || strlen($str) == 10 || strlen($str) == 13) {
				return true;
			}else{
				return false;
			}
		}else{
			return false;
		}
		
    }


}
