<?php
/**
 */


/**
 * Links block
 *
 * @category   Ekkitab
 * @package    Ekkitab_Wishlist
 * @author     Ekkitab Core Team <anisha@ekkitab.com>
 */
class Ekkitab_Wishlist_Block_Links extends Mage_Core_Block_Template
{
    /**
     * Add link on wishlist page in parent block
     *
     * @return Mage_Wishlist_Block_Links
     */
    public function addWishlistLink()
    {
        $parentBlock = $this->getParentBlock();
        if ($parentBlock && $this->helper('ekkitab_wishlist')->isAllow()) {
            $count = $this->helper('ekkitab_wishlist')->getItemCount();
            if( $count > 1 ) {
                $text = $this->__('My Wishlist (%d items)', $count);
            } elseif( $count == 1 ) {
                $text = $this->__('My Wishlist (%d item)', $count);
            } else {
                $text = $this->__('My Wishlist');
            }
            $parentBlock->addLink($text, 'ekkitab_wishlist', $text, true, array(), 30, null, 'class="top-link-wishlist"');
        }
        return $this;
    }
}