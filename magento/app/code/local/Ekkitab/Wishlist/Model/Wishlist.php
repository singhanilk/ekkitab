<?php
/**
 */


/**
 * Wishlist model
 *
 *
 * @category   Ekkitab
 * @package    Ekkitab_Wishlist
 * @author     Ekkitab Core Team <anisha@ekkitab.com>
 */
class Ekkitab_Wishlist_Model_Wishlist extends Mage_Wishlist_Model_Wishlist
{

    /**
     * Initialize resource model
     *
     */
    protected function _construct()
    {
        $this->_init('ekkitab_wishlist/wishlist');
    }


    /**
     * Retrieve wishlist item collection
     *
     * @return Mage_Wishlist_Model_Mysql4_Item_Collection
     */
    public function getItemCollection()
    {
        if(is_null($this->_itemCollection)) {
            $this->_itemCollection =  Mage::getResourceModel('ekkitab_wishlist/item_collection')
                ->setStoreId($this->getStore()->getId())
                ->addWishlistFilter($this);
        }

        return $this->_itemCollection;
    }
	
	/**
     * Retrieve Product collection
     *
     * @return Mage_Wishlist_Model_Mysql4_Product_Collection
     */
    public function getProductCollection()
    {
        $collection = $this->getData('product_collection');
        if (is_null($collection)) {
            $collection = Mage::getResourceModel('ekkitab_wishlist/product_collection')
                ->setStoreId($this->getStore()->getId())
                ->addWishlistFilter($this)
                ->addWishListSortOrder();
            $this->setData('product_collection', $collection);
        }
        return $collection;
    }

    /**
     * Retrieve wishlist items count
     *
     * @return int
     */
    public function getItemsCount()
    {
        return $this->_getResource()->fetchItemsCount($this);
    }

}
