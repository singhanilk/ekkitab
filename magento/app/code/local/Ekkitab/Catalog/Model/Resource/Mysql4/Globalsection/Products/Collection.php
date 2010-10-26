<?php


/**
 * Globasection products colelction
 *
 * @category   Ekkitab
 * @package    Ekkitab_Catalog
 * @author      Ekkitab Core Team <anisha@ekkitab.com>
 */
class Ekkitab_Catalog_Model_Resource_Mysql4_Globalsection_Products_Collection
    extends Mage_Core_Model_Mysql4_Collection_Abstract
{
    protected $_section;
    protected $_globalSectionProductModel;

    protected function _construct()
    {
        $this->_init('ekkitab_catalog/globalsection_products');
    }

    
    /**
     * Initialize collection parent product and add limitation join
     *
     * @param   Ekkitab_Catalog_Model_Globalsection $product
     * @return  Ekkitab_Catalog_Model_Resource_Mysql4_Globalsection_Products_Collection
     */
    public function setSection($section)
    {
        $this->_section = $section;
        return $this;
    }

    /**
     * Retrieve collection base section object
     *
     * @return Ekkitab_Catalog_Model_Globalsection
     */
    public function getSection()
    {
        return $this->_section;
    }
    

    /**
     * Add section to filter
     *
     * @return Ekkitab_Catalog_Model_Globalsection
     */
    public function addSectionIdFilter()
    {
		$this->addFieldToFilter("section_id", $this->getSection()->getSectionId());
        return $this;
    }
    
    /**
     * Add section to filter
     *
     * @return Ekkitab_Catalog_Model_Globalsection
     */
    public function addProductIdFilter()
    {
		$this->getSelect()->join(array('book'=>$this->getTable('ekkitab_catalog/product')),'book.id = main_table.product_id and book.in_stock > 0', array('book.id'));
        return $this;
    }
    
    /**
     * Add section to filter
     *
     * @return Ekkitab_Catalog_Model_Globalsection
     */
    public function setLimit($limit)
    {
		$this->getSelect()->limit($limit);
        return $this;
    }
    
    /**
     * Add section to filter
     *
     * @return Ekkitab_Catalog_Model_Globalsection
     */
    public function setRandomOrder()
    {
		$this->getSelect()->order('rand()');
        return $this;
    }
    
    /**
     * Add section to filter
     *
     * @return Ekkitab_Catalog_Model_Globalsection
     */
    public function setOrderFilter($order)
    {
		$this->getSelect()->order($order);
        return $this;
    }
}