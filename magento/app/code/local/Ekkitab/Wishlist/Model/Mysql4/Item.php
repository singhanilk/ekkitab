<?php
/**
 */


/**
 * Wishlist item model resource
 *
 * @category   Ekkitab
 * @package    Ekkitab_Wishlist
 * @author     Ekkitab Core Team <anisha@ekkitab.com>
 */
class Ekkitab_Wishlist_Model_Mysql4_Item extends Mage_Wishlist_Model_Mysql4_Item
{


    protected function _construct()
    {
        $this->_init('ekkitab_wishlist/item', 'wishlist_item_id');
    }

	public function loadByProductIsbnWishlist(Ekkitab_Wishlist_Model_Item $item, $wishlistId, $productIsbn, array $sharedStores)
    {
        $select = $this->_getReadAdapter()->select()
            ->from(array('main_table'=>$this->getTable('item')))
            ->where('main_table.wishlist_id = ?',  $wishlistId)
            ->where('main_table.isbn = ?',  $productIsbn)
            ->where('main_table.store_id in (?)',  $sharedStores);

		if($_data = $this->_getReadAdapter()->fetchRow($select)) {
            $item->setData($_data);
        }

        return $item;
    }


}
