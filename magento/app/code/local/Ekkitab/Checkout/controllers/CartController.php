<?php
/**
 * Magento
 *
 * NOTICE OF LICENSE
 *
 * This source file is subject to the Open Software License (OSL 3.0)
 * that is bundled with this package in the file LICENSE.txt.
 * It is also available through the world-wide-web at this URL:
 * http://opensource.org/licenses/osl-3.0.php
 * If you did not receive a copy of the license and are unable to
 * obtain it through the world-wide-web, please send an email
 * to license@magentocommerce.com so we can send you a copy immediately.
 *
 * DISCLAIMER
 *
 * Do not edit or add to this file if you wish to upgrade Magento to newer
 * versions in the future. If you wish to customize Magento for your
 * needs please refer to http://www.magentocommerce.com for more information.
 *
 * @category   Mage
 * @package    Mage_Checkout
 * @copyright  Copyright (c) 2008 Irubin Consulting Inc. DBA Varien (http://www.varien.com)
 * @license    http://opensource.org/licenses/osl-3.0.php  Open Software License (OSL 3.0)
 */

/**
 * Shopping cart controller
 */

require_once 'Mage/Checkout/controllers/CartController.php';

class Ekkitab_Checkout_CartController extends Mage_Checkout_CartController
{
   

    /**
     * Initialize product instance from request data
     *
     * @return Mage_Catalog_Model_Product || false
     */
    protected function _initProduct()
    {
        $productId = (int) $this->getRequest()->getParam('product');
        if ($productId) {
            $product = Mage::getModel('ekkitab_catalog/product')
                ->load($productId);
            if ($product->getId()) {
                return $product;
            }
        }
        return false;
    }

	    /**
     * Add wishlist item to shopping cart
     */
    public function moveSelectedToCartAction()
    {
        $orgId      = (int) $this->getRequest()->getParam('org');
        if($orgId && $orgId > 0){
			$cartData = $this->getRequest()->getParam('cart');
			if (is_array($cartData)) {
				/**
				 * Collect product ids marked for move to cart
				 */
				foreach ($cartData as $itemId => $itemInfo) {
					if (!empty($itemInfo['wishlist'])) {
						$item = Mage::getModel('wishlist/item')->load($itemId);
						if ($item){
							$product = Mage::getModel('ekkitab_catalog/product')->load($item->getIsbn(),'isbn')->setQty(1);
							
							$product->setIsDonation(1);
							$product->setOrgId($orgId);
			
							try {
								$quote = Mage::getSingleton('checkout/cart')
								   ->addProduct($product)
								   ->save();
							}
							catch(Exception $e) {
								Mage::getSingleton('checkout/session')->addError($e->getMessage());
								$url = Mage::getSingleton('checkout/session')->getRedirectUrl(true);
								if ($url) {
									$url = Mage::getModel('core/url')->getUrl("ekkitab_catalog/product/view/book/unable-to-add-to__wishlist__".$product->getId().".html"
									,array('wishlist_next'=>1));
									Mage::getSingleton('checkout/session')->setSingleWishlistId($item->getId());
									$this->getResponse()->setRedirect($url);
								}
								else {
									$this->_redirect('*/*/');
								}
								return;
							}
						}
					}
				}
			}
		}else{
			$this->_redirect('*/*/');
		}

        if (Mage::getStoreConfig('checkout/cart/redirect_to_cart')) {
            $this->_redirect('checkout/cart');
        } else {
            if ($this->getRequest()->getParam(self::PARAM_NAME_BASE64_URL)) {
                $this->getResponse()->setRedirect(
                    Mage::helper('core')->urlDecode($this->getRequest()->getParam(self::PARAM_NAME_BASE64_URL))
                );
            } else {
                $this->_redirect('*/*/');
            }
        }
    }
	    /**
     * Add wishlist item to shopping cart
     */
    public function donationCartAction()
    {
        $id         = (int) $this->getRequest()->getParam('item');
        $item       = Mage::getModel('wishlist/item')->load($id);
        $orgId      = (int) $this->getRequest()->getParam('org');

		$product = Mage::getModel('ekkitab_catalog/product')->load($item->getIsbn(),'isbn')->setQty(1);
        if($orgId && $orgId > 0){
			$product->setIsDonation(1);
			$product->setOrgId($orgId);
			
			try {
				$quote = Mage::getSingleton('checkout/cart')
				   ->addProduct($product)
				   ->save();
			}
			catch(Exception $e) {
				Mage::getSingleton('checkout/session')->addError($e->getMessage());
				$url = Mage::getSingleton('checkout/session')->getRedirectUrl(true);
				if ($url) {
					$url = Mage::getModel('core/url')->getUrl("ekkitab_catalog/product/view/book/unable-to-add-to__wishlist__".$product->getId().".html"
					,array('wishlist_next'=>1));
					Mage::getSingleton('checkout/session')->setSingleWishlistId($item->getId());
					$this->getResponse()->setRedirect($url);
				}
				else {
					$this->_redirect('*/*/');
				}
				return;
			}
		}else{
			$this->_redirect('*/*/');
		}

        if (Mage::getStoreConfig('checkout/cart/redirect_to_cart')) {
            $this->_redirect('checkout/cart');
        } else {
            if ($this->getRequest()->getParam(self::PARAM_NAME_BASE64_URL)) {
                $this->getResponse()->setRedirect(
                    Mage::helper('core')->urlDecode($this->getRequest()->getParam(self::PARAM_NAME_BASE64_URL))
                );
            } else {
                $this->_redirect('*/*/');
            }
        }
    }
}
