<?php

/**
 * Ekkitab Institute  Types model
 *
 * @author      Anisha 
 */
class Ekkitab_Institute_Model_Resource_Mysql4_Type_Collection extends Mage_Core_Model_Mysql4_Collection_Abstract
{
    protected function _construct()
    {
        $this->_init('ekkitab_institute/type');
    }


	public function setRealTypesFilter()
    {
        $this->addFieldToFilter('id', array('gt'=>0));
        return $this;
    }


    public function toOptionArray()
    {
        return parent::_toOptionArray('id', 'type');
    }
    public function toOptionHash()
    {
        return parent::_toOptionHash('id', 'type');
    }
}