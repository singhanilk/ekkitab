<?php
/**
 */

/**
 * Wishlist sidebar block
 *
 * @category   Ekkitab
 * @package    Ekkitab_Wishlist
 * @author     Ekkitab Core Team <anisha@ekkitab.com>
 */

class Ekkitab_Wishlist_Block_Customer_Sidebar extends Mage_Wishlist_Block_Customer_Sidebar
{

    public function getWishlist()
    {
        if(is_null($this->_wishlist)) {
            $this->_wishlist = Mage::getModel('ekkitab_wishlist/wishlist')
                ->loadByCustomer(Mage::getSingleton('customer/session')->getCustomer());

            $collection = $this->_wishlist->getProductCollection()
                //->addAttributeToSelect(Mage::getSingleton('catalog/config')->getProductAttributes())
                //->addAttributeToFilter('store_id', array('in'=>$this->_wishlist->getSharedStoreIds()))
                //->addStoreFilter() commented off dummy filter setttings
                //->addAttributeToSort('added_at', 'desc')
                ->setCurPage(1)
                ->setPageSize(3);
        }

        return $this->_wishlist;
    }

    protected function _toHtml()
    {
        if( sizeof($this->getWishlistItems()->getItems()) > 0 ){
            return parent::_toHtml();
        } else {
            return '';
        }
    }

    public function getAddToCartItemUrl($item)
    {
        return Mage::helper('ekkitab_wishlist')->getAddToCartUrlBase64($item);
    }
}
