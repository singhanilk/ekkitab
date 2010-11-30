<?php
/**
 */

/**
 * Customers collection
 *
 * @category   Mage
 * @package    Ekkitab_Institute
 * @author      Magento Core Team <core@magentocommerce.com>
 */
class Ekkitab_Institute_Model_Resource_Mysql4_Institute_Collection extends Mage_Core_Model_Mysql4_Collection_Abstract
{
    protected function _construct()
    {
        $this->_init('ekkitab_institute/institute');
    }

	public function addAuthenticateFilter(){
		$this->addFieldToFilter('is_valid','1');
		return $this;
	}

	public function addAttributesToSelect($arr){
		$this->getSelect()->from(null, $arr);
		return $this;
	}

	public function addIdFilter($ids){
		//Mage::log("Called addIdFilter");
		$this->addFieldToFilter('main_table.id', array('in'=>$ids));
		return $this;
	}

	public function addAdminIdFilter($ids){
		//Mage::log("Called addIdFilter");
		$this->addFieldToFilter('main_table.admin_id', array('in'=>$ids));
		return $this;
	}

	public function addSearchFilter($query){
        $this->getSelect()->reset(Zend_Db_Select::FROM)->distinct(true)
            ->from(
                array('main_table' => $this->getTable('institute')),
                array()
            )
            ->where('name LIKE ? OR street LIKE ? OR state LIKE ? OR city LIKE ?', '%'.$query.'%');
		return $this;
	}

	    /**
     * Add section to filter
     *
     * @return Ekkitab_Catalog_Model_Globalsection
     */
    public function addInstituteTypeFilter()
    {
		$this->getSelect()->join(array('institute_type'=>$this->getTable('ekkitab_institute/institute_type')),'institute_type.id = main_table.type_id');
        return $this;
    }


    /**
     * Add section to filter
     *
     * @return Ekkitab_Catalog_Model_Globalsection
     */
    public function addAdminFilter()
    {
		$this->getSelect()->join(array('customer'=>$this->getTable('customer/cutomer')),'customer.entity_id = main_table.admin_id ');
        return $this;
    }

}