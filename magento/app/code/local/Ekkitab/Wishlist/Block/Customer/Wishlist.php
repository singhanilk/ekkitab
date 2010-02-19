<?php
/**
 */


/**
 * Wishlist block customer items
 *
 * @category   Ekkitab
 * @package    Ekkitab_Wishlist
 * @author     Ekkitab Core Team <anisha@ekkitab.com>
 */
class Ekkitab_Wishlist_Block_Customer_Wishlist extends Mage_Wishlist_Block_Customer_Wishlist
{

    public function getWishlist()
    {
        if(!$this->_wishlistLoaded) {
            Mage::registry('wishlist')
                ->loadByCustomer(Mage::getSingleton('customer/session')->getCustomer());

            $collection = Mage::registry('wishlist')->getProductCollection();
                //->addAttributeToSelect(Mage::getSingleton('catalog/config')->getProductAttributes())
                //->addAttributeToFilter('store_id', array('in'=>Mage::registry('wishlist')->getSharedStoreIds()))
                //->addStoreFilter() commented off dummy filter setttings
            $this->_wishlistLoaded = true;
        }

        return Mage::registry('wishlist')->getProductCollection();
    }

}
