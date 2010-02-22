<?php
/**
 */


/**
 * Wishlist item model
 *
 *
 * @category   Ekkitab
 * @package    Ekkitab_Wishlist
 * @author     Ekkitab Core Team <anisha@ekkitab.com>
 */
class Ekkitab_Wishlist_Model_Item extends Mage_Wishlist_Model_Item
{

    protected function _construct()
    {
        $this->_init('ekkitab_wishlist/item');
    }

}
