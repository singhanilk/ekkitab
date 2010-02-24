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

}
