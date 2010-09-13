<?php
/**
 * 
 * Frontend Popular Categories Colelction Resource Model
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
class Ekkitab_Catalog_Model_Resource_Mysql4_Product_Collection extends Mage_Core_Model_Mysql4_Collection_Abstract
{


    /**
     * Init collection and determine table names
     *
     */
    protected function _construct()
    {
        $this->_init('ekkitab_catalog/product');
    }

	public function setStoreId($id){
		//Mage::log("Called setStoreId");
		return $this;
	}
	
	public function addIdFilter($ids){
		//Mage::log("Called addIdFilter");
		$this->addFieldToFilter('main_table.id', array('in'=>$ids));
		return $this;
	}
	
	public function addSourcedFromFilter($sourcedFrom){
		//Mage::log("Called addIdFilter");
		$this->addFieldToFilter('main_table.sourced_from', array('eq'=>$sourcedFrom));
		return $this;
	}
	
	public function addStockFilter($status){
		//Mage::log("Called addStockFilter");
		$this->addFieldToFilter('main_table.in_stock', array('eq'=>$status));
		return $this;
	}
	
	public function addNotInIdFilter($id){
		//Mage::log("Called addIdFilter");
		$this->addFieldToFilter('main_table.id', array('nin'=>$id));
		return $this;
	}
	
	public function addIdRangeFilter($startId,$endId){
		$this->addFieldToFilter('main_table.id', array('gt'=>$startId));
		$this->addFieldToFilter('main_table.id', array('lt'=>$endId));
		return $this;
	}
	
	public function addAttributeToSelect($id){
		//Mage::log("Called addAttributeToSelect");
		return $this;
	}
	
	public function addOptionsToResult($id = null){
		//Mage::log("Called addOptionsToResult");
		return $this;
	}
	
	public function addStoreFilter($id = null){
		//Mage::log("Called addStoreFilter");
		return $this;
	}
	
	public function addUrlRewrite($id = null){
		//Mage::log("Called addUrlRewrite");
		return $this;
	}
	
	public function getStoreId(){
		//Mage::log("Called getStoreId");
		return 1;
	}
		
	public function setCustomOptions($data) {
		return $this;
	}

	/**
     * Add limit to filter
     *
     * @return Mage_Core_Model_Mysql4_Collection_Abstract
     */
    public function setLimit($limit)
    {
		if($limit >0){
			$this->getSelect()->limit($limit);
		}
        return $this;
    }

	
       /**
     * Set/Get attribute wrapper
     *
     * @param   string $method
     * @param   array $args
     * @return  mixed
     */
    public function __call($method, $args)
    {
		//Mage::log("Invalid method ".get_class($this)."::".$method."(".print_r($args,1).")");
        throw new Exception("Invalid method ".get_class($this)."::".$method."(".print_r($args,1).")");
    }

}
   