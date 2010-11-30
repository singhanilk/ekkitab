<?php

/**
 * Wishlist shared items controllers
 *
 * @category   Ekkitab
 * @package    Ekkitab_Wishlist
 * @author     Ekkitab Core Team <anisha@ekkitab.com>
 */
require_once 'Mage/Wishlist/controllers/SharedController.php';

class Ekkitab_Wishlist_SharedController extends Mage_Wishlist_SharedController
{

    public function indexAction()
    {
        $code = (string) $this->getRequest()->getParam('code');
        if (empty($code)) {
            $this->_forward('noRoute');
            return;
        }
        $wishlist = Mage::getModel('ekkitab_wishlist/wishlist')->loadByCode($code);

        if ($wishlist->getCustomerId() && $wishlist->getCustomerId() == Mage::getSingleton('customer/session')->getCustomerId()) {
            $this->_redirectUrl(Mage::helper('ekkitab_wishlist')->getListUrl());
            return;
        }

        if(!$wishlist->getId()) {
            $this->_forward('noRoute');
            return;
        } else {
            Mage::register('shared_wishlist', $wishlist);
            $this->loadLayout();
            $this->_initLayoutMessages('wishlist/session');
            $this->renderLayout();
        }

    }

    public function allcartAction()
    {
        $code = (string) $this->getRequest()->getParam('code');
        if (empty($code)) {
            $this->_forward('noRoute');
            return;
        }

        $wishlist = Mage::getModel('wishlist/wishlist')->loadByCode($code);
        Mage::getSingleton('checkout/session')->setSharedWishlist($code);

        if (!$wishlist->getId()) {
            $this->_forward('noRoute');
            return;
        } else {
            $urls = false;
            foreach ($wishlist->getProductCollection() as $item) {
				$product = Mage::getModel('ekkitab_catalog/product')
					->load($item->getIsbn(),'isbn');
                try {
                    if ($product->isSalable()){
                        Mage::getSingleton('checkout/cart')->addProduct($product);
                    }
                }
                catch (Exception $e) {
                    $url = Mage::getSingleton('checkout/session')->getRedirectUrl(true);
                    if ($url){
                        $url = Mage::getModel('core/url')->getUrl("book/unable-to-add-to-wishlist-".$product->getIsbn().".html"
						,array('wishlist_next'=>1));

                        $urls[] = $url;
                        $messages[] = $e->getMessage();
                        $wishlistIds[] = $item->getId();
                    }
                }

                Mage::getSingleton('checkout/cart')->save();
            }
            if ($urls) {
                Mage::getSingleton('checkout/session')->addError(array_shift($messages));
                $this->getResponse()->setRedirect(array_shift($urls));

                Mage::getSingleton('checkout/session')->setWishlistPendingUrls($urls);
                Mage::getSingleton('checkout/session')->setWishlistPendingMessages($messages);
                Mage::getSingleton('checkout/session')->setWishlistIds($wishlistIds);
            } else {
                $this->_redirect('checkout/cart');
            }
        }
    }
}