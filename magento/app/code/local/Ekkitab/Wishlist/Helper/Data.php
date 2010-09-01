<?php
/**
 *
 * @category   Ekkitab
 * @package    Ekkitab_Wishlist
 *
 */

/**
 * Base wishlist helper
 * @category   Ekkitab
 * @package    Ekkitab_Wishlist
 * @author     Ekkitab Core Team <anisha@ekkitab.com>
 */

class Ekkitab_Wishlist_Helper_Data extends Mage_Wishlist_Helper_Data 
{

	/**
     * Current Linked Organization

     *
     * @var int
     */
    protected $_custOrg;


	/**
     * Retrieve wishlist by logged in customer
     *
     * @return Mage_Wishlist_Model_Wishlist
     */
    public function getEkkitabWishlist()
    {
        if (is_null($this->_wishlist)) {
            $this->_wishlist = Mage::getModel('ekkitab_wishlist/wishlist')
				->loadByCustomer($this->_getCurrentCustomer());
        }
        return $this->_wishlist;
    }

	/**
     * Retrieve search query text
     *
     * @return string
     */
    public function getCurrentLinkedOrganization()
    {
        if (is_null($this->_custOrg)) {
			$orgArr = Mage::getSingleton('core/session')->getCurrentLinkedOrganization();
			if(is_array($orgArr) && count($orgArr) > 0 ){
				$this->_custOrg = $orgArr['current_linked_organization'];
			}else{
				$this->_custOrg = '';
			}
            if (isset($this->_custOrg)) {
                $this->_custOrg = (int)trim($this->_custOrg);
            } else {
                $this->_custOrg = 0;
            }
        }
        return $this->_custOrg;
    }

	/**
     * Retrieve wishlist items collection
     *
     * @return
     */
    public function getItemCollection()
    {
        if (is_null($this->_itemCollection)) {
            $this->_itemCollection = $this->getEkkitabWishlist()->getProductCollection();
        }
        return $this->_itemCollection;
    }

    /**
     * Retrieve wishlist item count
     *
     * @return int
     */
    public function getItemCount()
    {
        if ($this->_isCustomerLogIn() && is_null($this->_itemCount)) {
            $this->_itemCount = $this->getEkkitabWishlist()->getItemsCount();
        }
        elseif(is_null($this->_itemCount)) {
            $this->_itemCount = 0;
        }
        return $this->_itemCount;
    }

	public function getProductCollection()
    {
        if (is_null($this->_productCollection)) {
            $this->_productCollection = $this->getEkkitabWishlist()->getProductCollection();
        }
        return $this->_productCollection;
    }


     /**
     * Retrieve customer wishlist url
     *
     * @return string
     */
    public function getListUrl()
    {
        return $this->_getUrl('ekkitab_wishlist');
    }

   public function getSharingUrl()
    {

    }

    /**
     * Retrieve url for adding product to wishlist
     *
     * @param   mixed $product
     * @return  string
     */
    public function getAddUrl($item)
    {
        if ($item instanceof Mage_Catalog_Model_Product) {
            return $this->_getUrl('ekkitab_wishlist/index/add', array('product'=>$item->getId()));
        }
        if ($item instanceof Mage_Wishlist_Model_Item) {
            return $this->_getUrl('ekkitab_wishlist/index/add', array('product'=>$item->getProductId()));
        }
        return false;
    }

    /**
     * Retrieve url for adding item to shoping cart
     *
     * @param   Mage_Wishlist_Model_Item $item
     * @return  string
     */
    public function getAddToCartUrl($item)
    {
        return $this->_getUrl('ekkitab_wishlist/index/cart', array('item'=>$item->getWishlistItemId()));
    }

    /**
     * Retrieve url for adding item to shoping cart with b64 referer
     *
     * @param   Mage_Wishlist_Model_Item $item
     * @return  string
     */
    public function getAddToCartUrlBase64($item)
    {
        return $this->_getUrl('ekkitab_wishlist/index/cart', array(
            'item'=>$item->getWishlistItemId(),
            Mage_Core_Controller_Front_Action::PARAM_NAME_BASE64_URL => Mage::helper('core')->urlEncode(
               $this->_getUrl('*/*/*', array('_current'=>true))
            )
        ));
    }

}
