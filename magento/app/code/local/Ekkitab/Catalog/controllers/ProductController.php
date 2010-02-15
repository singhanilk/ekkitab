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

require_once 'Mage/Catalog/controllers/ProductController.php';

class Ekkitab_Catalog_ProductController extends Mage_Catalog_ProductController
{
    /**
     * Initialize requested product object
     *
     * @return Mage_Catalog_Model_Product
     */
    protected function _initProduct()
    {
		Mage::dispatchEvent('catalog_controller_product_init_before', array('controller_action'=>$this));
		$productUrl  = (String) $this->getRequest()->getParam('book');

		// insert the split function here.....and get the product Id
		$productIdStartIndex = strrpos($productUrl, "__")+2; 	  
		$productIdEndIndex = strpos($productUrl, ".html"); 	
		$productIdEndIndex = $productIdEndIndex - $productIdStartIndex;  //.html/	
		$productId = (int) substr($productUrl,$productIdStartIndex,$productIdEndIndex);

	   if (is_int($productId) && $productId > 0 ) {

			$product = Mage::getModel('catalog/product')
				->setStoreId(Mage::app()->getStore()->getId())
				->load($productId);

			if (!Mage::helper('catalog/product')->canShow($product)) {
				return false;
			}
			if (!in_array(Mage::app()->getStore()->getWebsiteId(), $product->getWebsiteIds())) {
				return false;
			}

			$category = null;
			if ($categoryId = Mage::getSingleton('catalog/session')->getLastVisitedCategoryId()) {
				if ($product->canBeShowInCategory($categoryId)) {
					$category = Mage::getModel('catalog/category')->load($categoryId);
					$product->setCategory($category);
					Mage::register('current_category', $category);
				}
			}


			Mage::register('current_product', $product);
			Mage::register('product', $product);

			try {
				Mage::dispatchEvent('catalog_controller_product_init', array('product'=>$product));
				Mage::dispatchEvent('catalog_controller_product_init_after', array('product'=>$product, 'controller_action' => $this));
			} catch (Mage_Core_Exception $e) {
				Mage::logException($e);
				return false;
			}

			return $product;
	   }else{
		   return false;
	   }
    }

}
