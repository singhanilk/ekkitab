<?php
/**
 */


/**
 * Wishlist block shared items
 *
 * @category   Ekkitab
 * @package    Ekkitab_Wishlist
 * @author     Ekkitab Core Team <anisha@ekkitab.com>
 */
class Ekkitab_Wishlist_Block_Share_Wishlist extends Mage_Wishlist_Block_Share_Wishlist
{


    public function getWishlist()
    {
        if(is_null($this->_collection)) {
            $this->_collection = Mage::registry('shared_wishlist')->getProductCollection()
               // ->addAttributeToSelect('name')
                //->addAttributeToSelect('price')
               // ->addAttributeToSelect('special_price')
                //->addAttributeToSelect('special_from_date')
                //->addAttributeToSelect('special_to_date')
                //->addAttributeToSelect('image')
                //->addAttributeToSelect('small_image')
                //->addAttributeToSelect('thumbnail')
                //->addAttributeToFilter('store_id', array('in'=>Mage::registry('shared_wishlist')->getSharedStoreIds()))
                ->addStoreFilter();

           // Mage::getSingleton('catalog/product_status')->addVisibleFilterToCollection($this->_collection);
           // Mage::getSingleton('catalog/product_visibility')->addVisibleInSiteFilterToCollection($this->_collection);
        }
        return $this->_collection;
    }
}
