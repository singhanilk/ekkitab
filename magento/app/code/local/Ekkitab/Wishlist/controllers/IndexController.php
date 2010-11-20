<?php
/**
 */


/**
 * Wishlist front controller
 *
 * @category   Ekkitab
 * @package    Ekkitab_Wishlist
 * @author     Ekkitab Core Team <anisha@ekkitab.com>
 */

require_once 'Mage/Wishlist/controllers/IndexController.php';

function trim_value(&$value) 
{ 
	$value = trim($value); 
}

function isIsbn(&$str)
{
	$str=trim($str);
	if (preg_match("/^[0-9X\-_]+$/", $str)) {
		$str = preg_replace("/[-_]/", "", $str);
	}
	if(preg_match("/^[0-9X]*$/",$str)){
		if (strlen($str) == 12) {
			$str =  '0'.$str;
			return true;
		}else if (strlen($str) == 10) {
			$str = $this->isbn10to13($str);
			return true;
		}else if (strlen($str) == 13) {
			return true;
		}else{
			return false;
		}
	}else {
		return false;
	}
	
}

class Ekkitab_Wishlist_IndexController extends Mage_Wishlist_IndexController
{


    /**
     * Retrieve wishlist object
     *
     * @return Mage_Wishlist_Model_Wishlist
     */
    protected function _getWishlist()
    {
        try {
            $wishlist = Mage::getModel('ekkitab_wishlist/wishlist')
                ->loadByCustomer(Mage::getSingleton('customer/session')->getCustomer(), true);
            Mage::register('wishlist', $wishlist);
        }
        catch (Exception $e) {
            Mage::getSingleton('wishlist/session')->addError($this->__('Cannot create wishlist'));
            return false;
        }
        return $wishlist;
    }



    /**
     * Retrieve wishlist object
     *
     * @return Mage_Wishlist_Model_Wishlist
     */
    protected function _getOrgWishlist($orgId)
    {
        try {
           $cust = Mage::getSingleton('customer/session')->getCustomer();
		   if($cust && $cust->getId() > 0 ){
			   $wishlist = Mage::getModel('ekkitab_wishlist/wishlist')
					->loadByOrganization($orgId,$cust->getId(), true);
				Mage::register('wishlist', $wishlist);
		   }else{
			   Mage::getSingleton('wishlist/session')->addError($this->__('Cannot create wishlist'));
	            return false;
		   }
        }
        catch (Exception $e) {
            Mage::getSingleton('wishlist/session')->addError($this->__('Cannot create wishlist'));
            return false;
        }
        return $wishlist;
    }


	
	/**
     * Adding new item
     */
    public function addAction()
    {
        $session = Mage::getSingleton('customer/session');
        $wishlist = $this->_getWishlist();
        if (!$wishlist) {
            $this->_redirect('*/');
            return;
        }

        $productId = (int) $this->getRequest()->getParam('product');
        if (!$productId) {
            $this->_redirect('*/');
            return;
        }

        $product = Mage::getModel('ekkitab_catalog/product')->load($productId);
		if (!$product->getId() || !$product->isVisibleInCatalog()) {
            $session->addError($this->__('Cannot specify product'));
            $this->_redirect('*/');
            return;
        }

        try {
            $wishlist->addNewItem($product->getId());
            Mage::dispatchEvent('wishlist_add_product', array('wishlist'=>$wishlist, 'product'=>$product));

            if ($referer = $session->getBeforeWishlistUrl()) {
                $session->setBeforeWishlistUrl(null);
            }
            else {
                $referer = $this->_getRefererUrl();
            }
            $message = $this->__('%1$s was successfully added to your wishlist. Click <a href="%2$s">here</a> to continue shopping', $product->getName(), $referer);
            $session->addSuccess($message);
        }
        catch (Mage_Core_Exception $e) {
            $session->addError($this->__('There was an error while adding item to wishlist: %s', $e->getMessage()));
        }
        catch (Exception $e) {
            $session->addError($this->__('There was an error while adding item to wishlist.'));
        }
        $this->_redirect('*');
    }


	/**
     * Adding new item
     */
    public function addOrgWishlistAction()
    {
        $session = Mage::getSingleton('customer/session');
        $orgId = (int) $this->getRequest()->getParam('orgId');
        $notSalableNames    = array(); // Out of stock products message
		

		if($orgId && $orgId > 0){
			$wishlist = $this->_getOrgWishlist($orgId);
			if (!$wishlist) {
				$this->_redirectReferer();
				return;
			}

			$productIsbns = $this->getRequest()->getParam('wishlist_isbns');
			if (!$productIsbns || $productIsbns=='' || strlen(trim($productIsbns)) ==0 ) {
				$this->_redirectReferer();
				return;
			}
			$isbns= explode(",",trim($productIsbns));
			$isbns= array_filter($isbns,'isIsbn');
			array_walk($isbns, 'trim_value');
			$status	=array("1","2");
			if(!is_null($isbns) && is_array($isbns) && count($isbns) > 0  ){
				$books = Mage::getModel('ekkitab_catalog/product')->getCollection()
					->addIsbnFilter($isbns)
					->addStockFilter($status)
					->addIsbnOrderFilter($isbns);
				
				if(!is_null($books) && $books->count() > 0  ){
					foreach ($books as $product) {
						if ($product->getId()) {
							try {
								$wishlist->addNewItem($product->getId());
								Mage::dispatchEvent('wishlist_add_product', array('wishlist'=>$wishlist, 'product'=>$product));
							}
							catch (Mage_Core_Exception $e) {
								$session->addError($this->__("There was an error while adding book to Institute's wishlist: %s", $e->getMessage()));
							}
							catch (Exception $e) {
								$session->addError($this->__("There was an error while adding book to Institute's wishlist."));
							}
						}
					}
					$message = $this->__("Successfully added book(s) to your Institute's wishlist.");
					$session->addSuccess($message);

				}else{
					$session->addError($this->__("Cannot add to your Institute's wishlist. Book(s) requested are either not available with us,invalid or are out of stock."));
				}
			}else{
				$session->addError($this->__("Cannot add to Institute's wishlist. Book(s) information is not valid/available."));
			}
		}else{
			$session->addError($this->__("Cannot add Institute's wishlist. Institute information not available."));
		}
		$this->_redirectReferer();
    }



    /**
     * Add wishlist item to shopping cart
     */
    public function cartAction()
    {
        $wishlist   = $this->_getWishlist();
        $id         = (int) $this->getRequest()->getParam('item');
        $item       = Mage::getModel('wishlist/item')->load($id);

        if($item->getWishlistId()==$wishlist->getId()) {
			$product = Mage::getModel('ekkitab_catalog/product')->load($item->getIsbn(),'isbn')->setQty(1);
            try {
                $quote = Mage::getSingleton('checkout/cart')
                   ->addProduct($product)
                   ->save();
                $item->delete();
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
     * Add all items to shoping cart
     *
     */
    public function allOrgCartAction() {
        $messages           = array();
        $urls               = array();
        $wishlistIds        = array();
        $notSalableNames    = array(); // Out of stock products message

        $wishlist           = $this->_getWishlist();
        $wishlist->getItemCollection()->load();

        foreach ($wishlist->getItemCollection() as $item) {
			$product = Mage::getModel('ekkitab_catalog/product')
                    ->load($item->getIsbn(),'isbn')
                    ->setQty(1);
            try {
                if ($product->isSalable()) {
                    Mage::getSingleton('checkout/cart')->addProduct($product);
                    $item->delete();
                }
                else {
                    $notSalableNames[] = $product->getName();
                }
            } catch(Exception $e) {
                $url = Mage::getSingleton('checkout/session')
                    ->getRedirectUrl(true);
                if ($url) {
                    $url = Mage::getModel('core/url')->getUrl("ekkitab_catalog/product/view/book/unable-to-add-to__wishlist__".$product->getIsbn().".html");
                    $urls[]         = $url;
                    $messages[]     = $e->getMessage();
                    $wishlistIds[]  = $item->getId();
                } else {
                    $item->delete();
                }
            }
            Mage::getSingleton('checkout/cart')->save();
        }

        if (count($notSalableNames) > 0) {
            Mage::getSingleton('checkout/session')
                ->addNotice($this->__('This product(s) is currently out of stock:'));
            array_map(array(Mage::getSingleton('checkout/session'), 'addNotice'), $notSalableNames);
        }

        if ($urls) {
            Mage::getSingleton('checkout/session')->addError(array_shift($messages));
            $this->getResponse()->setRedirect(array_shift($urls));

            Mage::getSingleton('checkout/session')->setWishlistPendingUrls($urls);
            Mage::getSingleton('checkout/session')->setWishlistPendingMessages($messages);
            Mage::getSingleton('checkout/session')->setWishlistIds($wishlistIds);
        }
        else {
            $this->_redirect('checkout/cart');
        }
    }

    /**
     * Add all items to shoping cart
     *
     */
    public function allcartAction() {
        $messages           = array();
        $urls               = array();
        $wishlistIds        = array();
        $notSalableNames    = array(); // Out of stock products message

        $wishlist           = $this->_getWishlist();
        $wishlist->getItemCollection()->load();

        foreach ($wishlist->getItemCollection() as $item) {
			$product = Mage::getModel('ekkitab_catalog/product')
                    ->load($item->getIsbn(),'isbn')
                    ->setQty(1);
            try {
                if ($product->isSalable()) {
                    Mage::getSingleton('checkout/cart')->addProduct($product);
                    $item->delete();
                }
                else {
                    $notSalableNames[] = $product->getName();
                }
            } catch(Exception $e) {
                $url = Mage::getSingleton('checkout/session')
                    ->getRedirectUrl(true);
                if ($url) {
                    $url = Mage::getModel('core/url')->getUrl("ekkitab_catalog/product/view/book/unable-to-add-to__wishlist__".$product->getIsbn().".html");
                    $urls[]         = $url;
                    $messages[]     = $e->getMessage();
                    $wishlistIds[]  = $item->getId();
                } else {
                    $item->delete();
                }
            }
            Mage::getSingleton('checkout/cart')->save();
        }

        if (count($notSalableNames) > 0) {
            Mage::getSingleton('checkout/session')
                ->addNotice($this->__('This product(s) is currently out of stock:'));
            array_map(array(Mage::getSingleton('checkout/session'), 'addNotice'), $notSalableNames);
        }

        if ($urls) {
            Mage::getSingleton('checkout/session')->addError(array_shift($messages));
            $this->getResponse()->setRedirect(array_shift($urls));

            Mage::getSingleton('checkout/session')->setWishlistPendingUrls($urls);
            Mage::getSingleton('checkout/session')->setWishlistPendingMessages($messages);
            Mage::getSingleton('checkout/session')->setWishlistIds($wishlistIds);
        }
        else {
            $this->_redirect('checkout/cart');
        }
    }

	public function sendAction()
    {
        if (!$this->_validateFormKey()) {
            return $this->_redirect('*/*/');
        }

        $emails = explode(',', $this->getRequest()->getPost('emails'));
        $message= nl2br(htmlspecialchars((string) $this->getRequest()->getPost('message')));
        $error  = false;
        if (empty($emails)) {
            $error = $this->__('Email address can\'t be empty.');
        }
        else {
            foreach ($emails as $index => $email) {
                $email = trim($email);
                if (!Zend_Validate::is($email, 'EmailAddress')) {
                    $error = $this->__('You input not valid email address.');
                    break;
                }
                $emails[$index] = $email;
            }
        }
        if ($error) {
            Mage::getSingleton('wishlist/session')->addError($error);
            Mage::getSingleton('wishlist/session')->setSharingForm($this->getRequest()->getPost());
            $this->_redirect('*/*/share');
            return;
        }

        $translate = Mage::getSingleton('core/translate');
        /* @var $translate Mage_Core_Model_Translate */
        $translate->setTranslateInline(false);

        try {
            $customer = Mage::getSingleton('customer/session')->getCustomer();
            $wishlist = $this->_getWishlist();

            /*if share rss added rss feed to email template*/
            if ($this->getRequest()->getParam('rss_url')) {
                $rss_url = $this->getLayout()->createBlock('ekkitab_wishlist/share_email_rss')->toHtml();
                $message .=$rss_url;
            }
            $wishlistBlock = $this->getLayout()->createBlock('ekkitab_wishlist/share_email_items')->toHtml();

            $emails = array_unique($emails);
            $emailModel = Mage::getModel('core/email_template');

            foreach($emails as $email) {
                $emailModel->sendTransactional(
                    Mage::getStoreConfig('wishlist/email/email_template'),
                    Mage::getStoreConfig('wishlist/email/email_identity'),
                    $email,
                    null,
                    array(
                        'customer'      => $customer,
                        'salable'       => $wishlist->isSalable() ? 'yes' : '',
                        'items'         => &$wishlistBlock,
                        'addAllLink'    => Mage::getUrl('*/shared/allcart',array('code'=>$wishlist->getSharingCode())),
                        'viewOnSiteLink'=> Mage::getUrl('*/shared/index',array('code'=>$wishlist->getSharingCode())),
                        'message'       => $message
                    ));
            }

            $wishlist->setShared(1);
            $wishlist->save();

            $translate->setTranslateInline(true);

            Mage::dispatchEvent('wishlist_share', array('wishlist'=>$wishlist));
            Mage::getSingleton('customer/session')->addSuccess(
                $this->__('Your Wishlist was successfully shared')
            );
            $this->_redirect('*/*');
        }
        catch (Exception $e) {
            $translate->setTranslateInline(true);

            Mage::getSingleton('wishlist/session')->addError($e->getMessage());
            Mage::getSingleton('wishlist/session')->setSharingForm($this->getRequest()->getPost());
            $this->_redirect('*/*/share');
        }
    }


}
