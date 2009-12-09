<?php
/**
 * Catalogsearch Custom result Block
 * @category   Local/Ekkitab
 * @package    Ekkitab_CatalogSearch_Block_Custom
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

/**
 * Product search result block
 *
 * @category   Mage
 * @package    Mage_CatalogSearch
 * @module     Catalog
 */
class Ekkitab_CatalogSearch_Block_Custom_Result extends Mage_CatalogSearch_Block_Result
{

    protected function _prepareLayout()
    {
        $title = $this->__("Search results for: '%s'", $this->helper('ekkitab_catalogsearch')->getEscapedQueryText());

		if ($breadcrumbs = $this->getLayout()->getBlock('breadcrumbs')) {
            $breadcrumbs->addCrumb('home', array(
                'label'=>Mage::helper('catalogsearch')->__('Home'),
                'title'=>Mage::helper('catalogsearch')->__('Go to Home Page'),
                'link'=>Mage::getBaseUrl()
            ))->addCrumb('search', array(
                'label' => $title,
                'title' => $title
            ));
        }
        $this->getLayout()->getBlock('head')->setTitle($title);
        return parent::_prepareLayout();
    }

    public function setListOrders() {
        $category = Mage::getSingleton('catalog/layer')
            ->getCurrentCategory();
        /* @var $category Mage_Catalog_Model_Category */

        $availableOrders = $category->getAvailableSortByOptions();
        unset($availableOrders['position']);

        $this->getChild('search_result_list')
            ->setAvailableOrders($availableOrders);
    }

    public function setListModes() {
        $this->getChild('search_result_list')
            ->setModes(array(
                'grid' => Mage::helper('catalogsearch')->__('Grid'),
                'list' => Mage::helper('catalogsearch')->__('List'))
            );
    }

    public function setListCollection() {
        $this->getChild('search_result_list')
           ->setCollection($this->_getProductCollection());
    }

    protected function _getProductCollection(){
        return $this->getSearchModel()->getProductCollection();
    }

    public function getSearchModel()
    {
        return Mage::getSingleton('ekkitab_catalogsearch/custom');
    }

    public function getResultCount()
    {
        if (!$this->getData('result_count')) {
            $size = $this->getSearchModel()->getProductCollection()->getSize();
            $this->setResultCount($size);
        }
        return $this->getData('result_count');
    }

    public function getProductListHtml()
    {
        return $this->getChildHtml('search_result_list');
    }

    /**
     * Retrieve query model object
     *
     * @return Mage_CatalogSearch_Model_Query
     */
    protected function _getQuery()
    {
        return $this->helper('ekkitab_catalogsearch')->getQuery();
    }

	    /**
     * Retrieve No Result or Minimum query length Text
     *
     * @return string
     */
    public function getNoResultText()
    {
        if (Mage::helper('ekkitab_catalogsearch')->isMinQueryLength()) {
            return Mage::helper('ekkitab_catalogsearch')->__('Minimum Search query length is %s', $this->_getQuery()->getMinQueryLenght());
        }
        return $this->_getData('no_result_text');
    }

    /**
     * Retrieve Note messages
     *
     * @return array
     */
    public function getNoteMessages()
    {
        return Mage::helper('ekkitab_catalogsearch')->getNoteMessages();
    }

 
		
	//methods to retrieve books based on product Ids
	
	/**
     * Set Search Result collection
     *
     * @return Mage_CatalogSearch_Block_Result
    
    */
	
	/*
	public function setListCollection() {
		Mage::log(" In Ekkitab_CatalogSearch_Block_CustomResult .................. setListCollection()" );
        $this->getListBlock()
           ->setCollection($this->_getCustomProductCollection());
       return $this;
    }
   
    /**
     * Retrieve loaded category collection
     *
     * @return Mage_CatalogSearch_Model_Mysql4_Product_Collection
     */
	/*
    protected function _getCustomProductCollection()
    {
        $productIds = array("93","92","91","90","88","89","87","86","85","84","81","82","80","78","79","77","76","74","75","73","72","71","70","69","68","67","66","65","63","64","62");
		if (is_null($this->_productCollection)) {
			Mage::log(" In Ekkitab_CatalogSearch_Block_CustomResult .................. _productCollection is null" );
			$this->_productCollection = Mage::getModel('catalog/product')->getCollection()
				->addAttributeToSelect(Mage::getSingleton('catalog/config')->getProductAttributes())
				->addIdFilter($productIds);
			Mage::getSingleton('catalog/product_status')->addVisibleFilterToCollection($this->_productCollection);
			Mage::getSingleton('catalog/product_visibility')->addVisibleInSearchFilterToCollection($this->_productCollection);

		} else{
			Mage::log(" In Ekkitab_CatalogSearch_Block_CustomResult .................. _productCollection is not null" );
		}
        return $this->_productCollection;
    }

     */

    /**
     * Retrieve search result count
     *
     * @return string
     */
    /*
    public function getCustomResultCount()
    {
	   if (!$this->getData('custom_result_count')) {
		    Mage::log(" In Ekkitab_CatalogSearch_Block_CustomResult .... getResultCount mthod....custom_result_count is not available... so fetch" );
            $size = $this->_getCustomProductCollection()->getSize();
		    Mage::log(" In Ekkitab_CatalogSearch_Block_CustomResult .... getResultCount mthod....custom_result_count is : $size" );
            $this->_getQuery()->setNumResults($size);
            $this->setCustomResultCount($size);
        }
        return $this->getData('custom_result_count');
    }
	*/

}
