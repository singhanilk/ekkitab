<?php
/**
/**
 * Catalog Custom search helper
 * @category   Local/Ekkitab
 * @package    Ekkitab_CatalogSearch_Helper
 * @author Anisha (anisha@ekkitab.com)
 * @version 1.0 Dec 7, 2009
 * 
 * @package    Local_Ekkitab
 * @copyright  COPYRIGHT (C) 2009 Ekkitab Educational Services India Pvt. Ltd.
 * @license    All Rights Reserved. All material contained in this file (including, but not limited to, text, images, graphics, HTML, programming code and scripts) 
 * constitute proprietary and  * confidential information protected by copyright laws, trade secret and other laws. No part of this software may be copied, reproduced, modified or 
 * distributed in any form or by any means, or stored in a database or retrieval system without the prior written permission of Ekkitab Educational Services.
 * 
 */

class Ekkitab_CatalogSearch_Helper_Data extends Mage_CatalogSearch_Helper_Data
{

    const QUERY_PAGE_NO = 'p';
  
    const QUERY_CATEGORY_PATH = 'cp';
	
	/**
     * Page Number
     *
     * @var int
     */
    protected $_pageNo;


	/**
     * Page Number
     *
     * @var int
     */
    protected $_categoryPath;

	
	/**
     * Retrieve search query parameter name
     *
     * @return string
     */
    public function getPageNoVarName()
    {
        return self::QUERY_PAGE_NO;
    }
	
	
	/**
     * Retrieve search query parameter name
     *
     * @return string
     */
    public function getCategoryPath()
    {
        return self::QUERY_CATEGORY_PATH;
    }

	/**
     * Retrieve result page url
     *
     * @param   string $query
     * @return  string
     */
    public function getCustomSearchResultUrl($query = null)
    {
        return $this->_getUrl('ekkitab_catalogsearch/custom/result', array('_query' => array(
            self::QUERY_VAR_NAME => $query
        )));
    }

    /**
     * Retrieve result page url
     *
     * @param   string $query
     * @return  string
     */
    public function getCustomSearchResultByIndexUrl($query = null)
    {
        return $this->_getUrl('ekkitab_catalogsearch/custom/resultByIndex', array('_query' => array(
            self::QUERY_VAR_NAME => $query
        )));
    }


	/**
     * Retrieve search query text
     *
     * @return string
     */
    public function getCurrentPageNumber()
    {
        if (is_null($this->_pageNo)) {
            $this->_pageNo = $this->_getRequest()->getParam($this->getPageNoVarName());
            if (isset($this->_pageNo)) {
                $this->_pageNo = (int)trim($this->_pageNo);
            } else {
                $this->_pageNo = 1;
            }
        }
        return $this->_pageNo;
    }


    /**
     * Retrieve HTML escaped search query
     *
     * @return string
     */
    public function getEscapedQueryCategoryPath()
    {
        return $this->htmlEscape($this->getCurrentCategoryPath());
    }

	
	/**
     * Retrieve search query text
     *
     * @return string
     */
    public function getCurrentCategoryPath()
    {
		if (is_null($this->_categoryPath)) {
			$this->_categoryPath = $this->_getRequest()->getParam($this->getCategoryPath());
			//Mage::log("In helper ....before decoding....=> ".$this->_categoryPath);
			if ($this->_categoryPath === null) {
                $this->_categoryPath = '';
            } else {
                $this->_categoryPath = trim($this->_categoryPath);
               // $this->_categoryPath = urldecode(trim($this->_categoryPath));
				//Mage::log("In helper ....after  decoding....=> ".$this->_categoryPath);
				$this->_categoryPath = Mage::helper('core/string')->cleanString($this->_categoryPath);
				//Mage::log("In helper ....after cleaning ....=> ".$this->_categoryPath);
            }
		}
        return $this->_categoryPath;
    }

	/**
     * Schedule resize of the image
     * $width *or* $height can be null - in this case, lacking dimension will be calculated.
     *
     * @see Mage_Catalog_Model_Product_Image
     * @param int $width
     * @param int $height
     * @return Mage_Catalog_Helper_Image
     */
    public function resize($image, $attributeName,$keepFrame,$width, $height = null)
    {
        $imageModel = Mage::getModel('catalog/product_image');
        $imageModel->setDestinationSubdir($attributeName);
        $imageModel->setBaseFile($image);
        $imageModel->setWidth($width)->setHeight($height);
        $imageModel->setKeepFrame($keepFrame);
		try {
            if( $imageModel->isCached() ) {
                return $imageModel->getUrl();
            } else {
                $imageModel->resize();
                $url = $imageModel->saveFile()->getUrl();
            }
        } catch( Exception $e ) {
             $url = Mage::getDesign()->getSkinUrl($this->getPlaceholder($imageModel->getDestinationSubdir()));
        }
        return $url;
    }

	/**
     * Retrieve url for add product to cart
     *
     * @param   Mage_Catalog_Model_Product $product
     * @return  string
     */
    public function getCartUrl($productId,$continueShoppingUrl)
    {
        $params = array(
            Mage_Core_Controller_Front_Action::PARAM_NAME_URL_ENCODED => Mage::helper('core')->urlEncode($continueShoppingUrl),
            'product' => $productId
        );

        if ($this->_getRequest()->getRouteName() == 'checkout'
            && $this->_getRequest()->getControllerName() == 'cart') {
            $params['in_cart'] = 1;
        }

       return $this->_getUrl('checkout/cart/add', $params);
    }

    public function getPlaceholder($attr)
    {
		return ('images/catalog/product/placeholder/'.$attr.'.png');
	}
}
