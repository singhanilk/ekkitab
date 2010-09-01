<?php
/**
 */


/**
 * Wishlist item collection
 *
 * @category   Ekkitab
 * @package    Ekkitab_Wishlist
 * @author     Ekkitab Core Team <anisha@ekkitab.com>
 */
class Ekkitab_Wishlist_Model_Mysql4_Item_Collection extends Ekkitab_Catalog_Model_Resource_Mysql4_Product_Collection
{

    public function _construct()
    {
        $this->_init('ekkitab_wishlist/item', 'ekkitab_catalog/product');
    }

    public function useProductItem()
    {
        $this->setObject(Mage::getModel('ekkitab_catalog/product'));
        return $this;
    }

   public function addWishlistFilter(Mage_Wishlist_Model_Wishlist    $wishlist)
    {
		$wishListId= $wishlist->getId();
		$this->join("wishlist_item","main_table.isbn=wishlist_item.isbn AND wishlist_id ='{$wishListId}'");
        return $this;
    }
	public function addStoreData()
    {
        return $this;
    }

    protected function _getAttributeFieldName($attributeCode)
    {
        return $attributeCode;
    }

}
