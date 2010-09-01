<?php
/**
 */


/**
 * Wishlist model resource
 *
 *
 * @category   Ekkitab
 * @package    Ekkitab_Wishlist
 * @author     Ekkitab Core Team <anisha@ekkitab.com>
 */
class Ekkitab_Wishlist_Model_Mysql4_Wishlist extends Mage_Wishlist_Model_Mysql4_Wishlist
{

    public function getWishListId($custId,$orgId=0){
		$select = $this->_getReadAdapter()->select();
        $select->from($this->getTable('ekkitab_wishlist/wishlist'), 'wishlist_id')
            ->where('customer_id = ?', $custId)
            ->where('organization_id = ?', $orgId);
		$wishlistId = (int)$this->_getReadAdapter()->fetchOne($select);
		return $wishlistId;
	}

    public function fetchItemsCount(Mage_Wishlist_Model_Wishlist $wishlist)
    {
        if (is_null($this->_itemsCount)) {
            $collection = $wishlist->getProductCollection()
                //->addAttributeToFilter('store_id', array('in'=>$wishlist->getSharedStoreIds()))
                ->addStoreFilter();

           // Mage::getSingleton('catalog/product_status')->addVisibleFilterToCollection($collection);
           // Mage::getSingleton('catalog/product_visibility')->addVisibleInSiteFilterToCollection($collection);

            $this->_itemsCount = $collection->getSize();
        }

        return $this->_itemsCount;
    }

}
