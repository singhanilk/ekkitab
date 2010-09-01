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
     * Load wishlist by customer
     *
     * @param mixed $customer
     * @param bool $create Create wishlist if don't exists
     * @return Mage_Wishlist_Model_Wishlist
     */
    public function loadByCustomer($customer, $create = false)
    {
        if ($customer instanceof Mage_Customer_Model_Customer) {
            $customer = $customer->getId();
        }
		$organizationId= Mage::helper('ekkitab_wishlist')->getCurrentLinkedOrganization();
		$wishlistId =  $this->_getResource()->getWishListId($customer,$organizationId);
        if(!is_null($wishlistId) && $wishlistId >0 ){
		   $this->load($wishlistId);
		}
		if (!$this->getId() && $create) {
            $this->setCustomerId($customer);
            $this->setOrganizationId($organizationId);
            $this->setSharingCode($this->_getSharingRandomCode());
            $this->save();
        }

        return $this;
    }

	/**
     * Add new item to wishlist
     *
     * @param int $productId
     * @return Mage_Wishlist_Model_Item
     */
    public function addNewItem($productId)
    {
        $item = Mage::getModel('wishlist/item');
        $item->loadByProductWishlist($this->getId(), $productId, $this->getSharedStoreIds());
        $product = Mage::getModel('ekkitab_catalog/product')->load($productId);
		$productIsbn = $product->getIsbn();
        if (!$item->getId()) {
            $item->setProductId($productId)
                ->setIsbn($productIsbn)
                ->setWishlistId($this->getId())
                ->setAddedAt(now())
                ->setStoreId($this->getStore()->getId())
                ->save();
        }

        return $item;
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
