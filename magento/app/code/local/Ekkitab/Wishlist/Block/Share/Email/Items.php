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
class Ekkitab_Wishlist_Block_Share_Email_Items extends Mage_Wishlist_Block_Share_Email_Items
{

    public function getWishlist()
    {
        if(!$this->_wishlistLoaded) {
            Mage::registry('wishlist')
                ->loadByCustomer(Mage::getSingleton('customer/session')->getCustomer());
            Mage::registry('wishlist')->getProductCollection()
                //->addAttributeToSelect('url_key')
                //->addAttributeToSelect('name')
                //->addAttributeToSelect('price')
                //->addAttributeToSelect('image')
                //->addAttributeToSelect('small_image')
                //->addAttributeToFilter('store_id', array('in'=>Mage::registry('wishlist')->getSharedStoreIds()))
                ->addStoreFilter();
           // Mage::getSingleton('catalog/product_visibility') ->addVisibleInSiteFilterToCollection(Mage::registry('wishlist')->getProductCollection());
           Mage::registry('wishlist')->getProductCollection()->load();

            $this->_wishlistLoaded = true;
        }

        return Mage::registry('wishlist')->getProductCollection();
    }

}
