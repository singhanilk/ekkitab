<?php
/**
 * 
 * Frontend Popular Categories block
 * @category   Local/Ekkitab
 * @author Anisha (anisha@ekkitab.com)
 * @version 1.0 Nov 17, 2009
 * 
 * @package    Local_Ekkitab
 * @copyright  COPYRIGHT (C) 2009 Ekkitab Educational Services India Pvt. Ltd.
 * @license    All Rights Reserved. All material contained in this file (including, but not limited to, text, images, graphics, HTML, programming code and scripts) 
 * constitute proprietary and  * confidential information protected by copyright laws, trade secret and other laws. No part of this software may be copied, reproduced, modified or 
 * distributed in any form or by any means, or stored in a database or retrieval system without the prior written permission of Ekkitab Educational Services.
 * 
 * 
 */
class Ekkitab_Catalog_Block_Product_Bestsellers extends Mage_Core_Block_Template
{

    /**
     * Bestseller Product Ids
     *
     * @var array
     */
    protected $_bestSellersIds;


    /**
     * Set productIds to variable
     *
     * @param Varien_Data_Collection $collection
     * 
     */
    public function setBestSellerProductIds($productIds = array())
    {
		$this->_bestSellersIds = $productIds;
    }

	/**
     * Get popular catagories of current store
     *
     */
    public function getBestsellers()
    {
		$bestSellers = Mage::getModel('ekkitab_catalog/product_bestsellers')->getCollection();
		$i=0;
		$productIds=array();
		foreach($bestSellers as  $product){
			$productIds[$i++] = $product->getProductId();
		}
		$this->setBestSellerProductIds($productIds);

		$bestSellersColelction = Mage::getModel('ekkitab_catalog/product')->getCollection()
				->addIdFilter($productIds);
		return $bestSellersColelction;
	}
	
	/**
     * Get popular catagories of current store
     *
     */
    public function getBestSellerProductIds()
    {
		if(is_null($this->_bestSellersIds)){
			$bestSellers = Mage::getModel('ekkitab_catalog/product_bestsellers')->getCollection();
			$i=0;
			$productIds=array();
			foreach($bestSellers as  $product){
				$productIds[$i++] = $product->getProductId();
			}
			$this->setBestSellerProductIds($productIds);
		}
		return $this->_bestSellersIds;
		
	}
}
