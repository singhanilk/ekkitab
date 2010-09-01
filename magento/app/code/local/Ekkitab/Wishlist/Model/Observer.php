<?php
/**
 */

/**
 * Shopping cart operation observer
 *
 * @author      Magento Core Team <core@magentocommerce.com>
 */
class Ekkitab_Wishlist_Model_Observer extends Mage_Wishlist_Model_Observer
{
    /**
     * Get customer wishlist model instance
     *
     * @param   int $customerId
     * @return  Mage_Wishlist_Model_Wishlist || false
     */
    protected function _getWishlist($customerId)
    {
        if (!$customerId) {
            return false;
        }
        return Mage::getModel('ekkitab_wishlist/wishlist')->loadByCustomer($customerId, true);
    }

}