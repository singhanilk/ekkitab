<?php
/**
/**
 * Catalog Custom search helper
 * @category   Local/Ekkitab
 * @package    Ekkitab_CatalogSearch_Helper
 * @author Anisha (anisha@ekkitab.com)
 * @version 1.0 Dec 7, 2009
 * 
 * @package    Local_Ekkitab
 * @copyright  COPYRIGHT (C) 2009 Ekkitab Educational Services India Pvt. Ltd.
 * @license    All Rights Reserved. All material contained in this file (including, but not limited to, text, images, graphics, HTML, programming code and scripts) 
 * constitute proprietary and  * confidential information protected by copyright laws, trade secret and other laws. No part of this software may be copied, reproduced, modified or 
 * distributed in any form or by any means, or stored in a database or retrieval system without the prior written permission of Ekkitab Educational Services.
 * 
 */

class Ekkitab_Catalog_Helper_Product_Data extends Mage_Core_Helper_Abstract
{

	
	/**
     * Page Number
     *
     * @var int
     */
    protected $_productId;



	/**
     * Retrieve search query text
     *
     * @return string
     */
    public function getProductId()	
    {
        if (is_null($this->_productId)) {
			$productUrl  = (String) $this->getRequest()->getParam('book');

			$productIdStartIndex = strrpos($productUrl, "__")+2; 	  
			$productIdEndIndex = strpos($productUrl, ".html"); 	
			$productIdEndIndex = $productIdEndIndex - $productIdStartIndex;  //.html/	
			$this->_productId = (int) substr($productUrl,$productIdStartIndex,$productIdEndIndex);
        }
        return $this->_productId;
    }

}