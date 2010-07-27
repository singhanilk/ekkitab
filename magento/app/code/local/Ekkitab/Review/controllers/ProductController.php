<?php

/**
 * Review controller
 *
 * @category   Ekkitab
 * @package    Ekkitab_Review
 * @author     Ekkitab Core Team <anisha@ekkitab.com>
 */
require_once 'Mage/Review/controllers/ProductController.php';

class Ekkitab_Review_ProductController extends Mage_Review_ProductController
{

    /**
     * Action list where need check enabled cookie
     *
     * @var array
     */
    protected $_cookieCheckActions = array('post');

    /**
     * Initialize and check product
     *
     * @return Mage_Catalog_Model_Product
     */
	protected function _initProduct()
    {
        Mage::dispatchEvent('review_controller_product_init_before', array('controller_action'=>$this));
        $productId  = trim($this->getRequest()->getParam('id'));
		Mage::log("Product id is : $productId");
		if($productId){
			if($this->isIsbn($productId)){
				//this is isbn.....
				$products = Mage::getModel('ekkitab_catalog/product')->getCollection()
							->addFieldToFilter('main_table.isbn',$productId);
				foreach($products as $prod){
					$product = $prod;
				}

			}else {
				$productId = (int) $productId;
				$product = Mage::getModel('ekkitab_catalog/product')
					->setStoreId(Mage::app()->getStore()->getId())
					->load($productId);
			}
		} else {
            return false;
        }

        /* @var $product Mage_Catalog_Model_Product */
        if (!$product->getId() || !$product->isVisibleInCatalog() || !$product->isVisibleInSiteVisibility()) {
            return false;
        }

        Mage::register('current_product', $product);
        Mage::register('product', $product);

        try {
            Mage::dispatchEvent('review_controller_product_init', array('product'=>$product));
            Mage::dispatchEvent('review_controller_product_init_after', array('product'=>$product, 'controller_action' => $this));
        } catch (Mage_Core_Exception $e) {
            Mage::logException($e);
            return false;
        }

        return $product;
    }


	/**
     * Retrieve search result count
     *
     * @return boolean
     */
    public function isIsbn($str)
    {
		$str=trim($str);
		if(preg_match("/^[0-9]*$/",$str)){
			if (strlen($str) == 12 || strlen($str) == 10 || strlen($str) == 13) {
				return true;
			}else{
				return false;
			}
		}else{
			return false;
		}
		
    }

	public function listAction()
    {
		if ($product = $this->_initProduct()) {
            Mage::register('productId', $product->getId());
            Mage::getModel('catalog/design')->applyDesign($product, Mage_Catalog_Model_Design::APPLY_FOR_PRODUCT);
            $this->_initProductLayout($product);

           // update breadcrumbs
            if ($breadcrumbsBlock = $this->getLayout()->getBlock('breadcrumbs')) {
                $breadcrumbsBlock->addCrumb('product', array(
                    'label'    => $product->getName(),
                    'link'     => $product->getProductUrl(),
                    'readonly' => true,
                ));
                $breadcrumbsBlock->addCrumb('reviews', array('label' => Mage::helper('review')->__('Product Reviews')));
            }

            $this->renderLayout();
        } elseif (!$this->getResponse()->isRedirect()) {
            $this->_forward('noRoute');
        }
    }

}
