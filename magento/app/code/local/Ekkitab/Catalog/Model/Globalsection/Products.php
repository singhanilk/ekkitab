<?php

/**
 * Globasection products model
 *
 * @category   Ekkitab
 * @package    Ekkitab_Catalog
 * @author      Ekkitab Core Team <anisha@ekkitab.com>
 */
class Ekkitab_Catalog_Model_Globalsection_Products extends Mage_Core_Model_Abstract
{

    /**
     * Initialize resource
     */
    protected function _construct()
    {
        $this->_init('ekkitab_catalog/globalsection_products');
    }

    /**
     * Retrieve linked product collection
     */
    public function getProductCollection()
    {
        $collection = Mage::getResourceModel('ekkitab_catalog/globalsection_products_collection');
        return $collection;
    }

}