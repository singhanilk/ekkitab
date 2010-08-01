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
class Ekkitab_Catalog_Model_Resource_Mysql4_Globalsection_Collection extends Mage_Core_Model_Mysql4_Collection_Abstract
{


    /**
     * Init collection and determine table names
     *
     */
    protected function _construct()
    {
        $this->_init('ekkitab_catalog/globalsection');
    }

	
	public function addIdFilter($ids){
		$this->addFieldToFilter('main_table.section_id', array('in'=>$ids));
		return $this;
	}
	
	public function addActiveDateFilter(){
        $todayDate  = Mage::app()->getLocale()->date()->toString(Varien_Date::DATETIME_INTERNAL_FORMAT);
		$this->addFieldToFilter('active_from_date', array('date'=>true, 'to'=> $todayDate), 'left');
		$this->addFieldToFilter('active_to_date', array('date'=>true, 'from'=> $todayDate), 'left');
           // ->addFieldToFilter(array(array('attribute'=>'active_to_date', 'date'=>true, 'from'=>$todayDate),array('attribute'=>'active_to_date', 'is' => new Zend_Db_Expr('null'))), '', 'left');
		return $this;
	}
	
    /**
     * Add randomness to filter
     *
     * @return Ekkitab_Catalog_Model_Resource_Mysql4_Globalsection_Collection
     */
    public function setRandomOrder()
    {
		$this->getSelect()->order('rand()');
        return $this;
    }
   
	/**
     * Add section to filter
     *
     * @return Ekkitab_Catalog_Model_Resource_Mysql4_Globalsection_Collection
     */
    public function setLimit($limit)
    {
		if($limit >0){
			$this->getSelect()->limit($limit);
		}
        return $this;
    }
    

	public function addHomePageFilter(){
		$this->addFieldToFilter('is_homepage_display', '1');
		return $this;
	}
	
}
   