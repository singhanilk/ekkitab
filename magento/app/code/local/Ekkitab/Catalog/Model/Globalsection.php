<?php
/**
 * Catalog Globalsection model
 *
 * @category   Ekkitab
 * @package    Ekkitab_Catalog
 * @author      Ekkitab Core Team <anisha@ekkitab.com>
 */
class Ekkitab_Catalog_Model_Globalsection extends Mage_Core_Model_Abstract
{
    const CACHE_TAG              = 'catalog_globalsection';
    protected $_cacheTag         = 'catalog_globalsection';
    protected $_eventPrefix      = 'catalog_globalsection';
    protected $_eventObject      = 'globalsection';
    protected $_canAffectOptions = false;

    /**
     * Product link instance
     *
     * @var Mage_Catalog_Model_Product_Link
     */
    protected $_sectionProductInstance;


	/**
     * Initialize resources
     */
    protected function _construct()
    {
        $this->_init('ekkitab_catalog/globalsection');
    }


/*******************************************************************************
 ** Linked products 
 */
    /**
     * Retrieve array of related roducts
     *
     * @return array
     */
    public function getSectionProducts($random=false,$pageNo=0,$limit=0)
    {
		$products = array();
		$collection = $this->getSectionProductCollection($random,$pageNo,$limit);
		foreach ($collection as $product) {
			$products[] = $product->getProductId();
		}
		$sectionProducts = Mage::getModel('ekkitab_catalog/product')->getCollection()
			->addIdFilter($products);
        return $sectionProducts;
    }

    /**
     * Retrieve related products identifiers
     *
     * @return array
     */
    public function getSectionProductIds()
    {
        if (!$this->hasSectionProductIds()) {
            $ids = array();
            foreach ($this->getSectionProducts() as $product) {
                $ids[] = $product->getProductId();
            }
            $this->setSectionProductIds($ids);
        }
        return $this->getData('section_product_ids');
    }


    /**
     * Retrieve collection related product
     */
    public function getSectionProductCollection($random=false,$pageNo,$limit=0)
    {
        $collection = $this->getSectionProductInstance()
			->getProductCollection()
			->setSection($this)
			->addSectionIdFilter();
		if($pageNo > 0){
			$collection->setCurPage($pageNo);
		}
		if($random){
			$collection->setRandomOrder();
		}	
		if($limit && $limit > 0 ){
			$collection->setPageSize($limit);
			//$collection->setLimit($limit);
		}
        return $collection;
    }

    /**
     * Retrieve link instance
     *
     * @return  Mage_Catalog_Model_Product_Link
     */
    public function getSectionProductInstance()
    {
        if (!$this->_sectionProductInstance) {
            $this->_sectionProductInstance = Mage::getSingleton('ekkitab_catalog/globalsection_products');
        }
        return $this->_sectionProductInstance;
    }

}
