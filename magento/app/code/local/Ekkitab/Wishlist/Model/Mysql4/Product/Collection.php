<?php
/**
 */


/**
 * Wishlist Product collection
 *
 * @category   Ekkitab
 * @package    Ekkitab_Wishlist
 * @author     Ekkitab Core Team <anisha@ekkitab.com>
 */
class Ekkitab_Wishlist_Model_Mysql4_Product_Collection  extends Ekkitab_Catalog_Model_Resource_Mysql4_Product_Collection
{

   public function addWishlistFilter(Mage_Wishlist_Model_Wishlist    $wishlist)
    {
        $wishListId= $wishlist->getId();
       // $storeIds= $wishlist->getSharedStoreIds();
		$this->join("wishlist_item","main_table.isbn=wishlist_item.isbn AND wishlist_id ='{$wishListId}'");
        return $this;
    }

	/**
     * Add wishlist sort order
     *
     * @param string $att
     * @param string $dir
     * @return Mage_Wishlist_Model_Mysql4_Product_Collection
     */
    public function addWishListSortOrder($attribute = 'added_at', $dir = 'desc')
    {
        $this->setOrder($attribute, $dir);
        return $this;
    }

    /**
     * Add store data (days in wishlist)
     *
     * @return Mage_Wishlist_Model_Mysql4_Product_Collection
     */
    public function addStoreData()
    {
        return $this;
    }

    /**
     * Rewrite retrieve attribute field name for wishlist attributes
     *
     * @param string $attributeCode
     * @return Mage_Wishlist_Model_Mysql4_Product_Collection
     */
    protected function _getAttributeFieldName($attributeCode)
    {
        return $attributeCode;
    }
}
