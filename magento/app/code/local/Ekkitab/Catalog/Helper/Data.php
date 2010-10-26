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

class Ekkitab_Catalog_Helper_Data extends Mage_CatalogSearch_Helper_Data
{

    const QUERY_PAGE_NO = 'p';
  
    const CATALOG_SLOT_NO = 's';
  
    const QUERY_CATEGORY_PATH = 'category';

    const QUERY_FILTER_NAME = 'filterby';
    
	const QUERY_AUTHOR_NAME = 'author';
	
	protected $_repArr= array(" & ", "&");

    protected $_searchIncludeTemplateUrl;

	/**
     * Page Number

     *
     * @var int
     */
    protected $_pageNo;

	/**
     * Slot Number

     *
     * @var int
     */
    protected $_slotNo;


	/**
     * Page Number
     *
     * @var int
     */
    protected $_categoryPath;

	
	/**
     * Page Number
     *
     * @var int
     */
    protected $_filterBy;

	
	/**
     * Retrieve search query parameter name
     *
     * @return string
     */
    public function getQueryFilterName()
    {
        return self::QUERY_FILTER_NAME;
    }
	
	
	/**
     * Retrieve search query parameter name
     *
     * @return string
     */
    public function getAuthorQueryName()
    {
        return self::QUERY_AUTHOR_NAME;
    }
	
	
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
    public function getSlotNoVarName()
    {
        return self::CATALOG_SLOT_NO;
    }
	
	
	/**
     * Retrieve search query parameter name
     *
     * @return string
     */
    public function getCategoryVarName()
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
        return $this->_getUrl('ekkitab_catalog/custom/result', array('_query' => array(
            self::QUERY_VAR_NAME => $query
        )));
    }

	/**
     * Retrieve result page url
     *
     * @param   string $query
     * @return  string
     */
    public function getFullCatalogUrl()
    {
        return $this->_getUrl('all-books', array());
    }

    /**
     * Retrieve result page url
     *
     * @param   string $query
     * @return  string
     */
    public function getLeftLinkUrl($urlprefix, $params=null)
    {
		$urlprefix = 'ekkitab_catalog/'.$urlprefix;
		$url='';
		if(!is_null($params) && is_array($params)){
			foreach ($params as $param => $value) {
               if(isset($value) && strlen($value) > 0){
				  $url  = $url.$param."/".$value."/";
			   }
            }
        }  
		if(isset($url) && strlen($url) > 0){
			$url= $urlprefix."/".$url;
		}else{
			$url= $urlprefix;
		}
		$url = $this->_getUrl($url);
        return $url;
    }


    /**
     * Retrieve result page url
     *
     * @param   string $query
     * @return  string
     */
    public function getSearchResultByIndexUrl($query = null,$params=null)
    {
		$urlprefix = 'ekkitab_catalog/search/index';
		$url='';
		if(!is_null($params) && is_array($params)){
			foreach ($params as $param => $value) {
               if(isset($value) && strlen($value) > 0){
				  $url  = $url.$param."/".$value."/";
			   }
            }
        }  
		if(isset($url) && strlen($url) > 0){
			$url= $urlprefix."/".$url;
		}else{
			$url= $urlprefix;
		}
        $urlParams = array();
        $urlParams['_current']  = true;
        $urlParams['_query']    = array(self::QUERY_VAR_NAME =>$query);
		$url = $this->_getUrl($url,$urlParams);
        return $url;
    }


    /**
     * Retrieve result page url
     *
     * @param   string $query
     * @return  string
     */
    public function getFormSearchResultByIndexUrl($query = null)
    {
		return $this->_getUrl('ekkitab_catalog/search/index', array('_query' => array(
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
     * Retrieve search query text
     *
     * @return string
     */
    public function getCurrentSlotNumber()
    {
        if (is_null($this->_slotNo)) {
            $this->_slotNo = $this->_getRequest()->getParam($this->getSlotNoVarName());
			if (isset($this->_slotNo)) {
                $this->_slotNo = (int)trim($this->_slotNo);
            } else {
                $this->_slotNo = 1;
            }
        }
        return $this->_slotNo;
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
     * Retrieve HTML escaped search query
     *
     * @return string
     */
    public function getQueryFilterByText()
    {
		if (is_null($this->_filterBy)) {
			$this->_filterBy = $this->_getRequest()->getParam($this->getQueryFilterName());
			if ($this->_filterBy === null) {
                $this->_filterBy = '';
            } else {
				$this->_filterBy = Mage::helper('core/string')->cleanString(trim($this->_filterBy));
            }
		}
        return $this->htmlEscape($this->_filterBy);
    }

    /**
     * Retrieve HTML escaped search query
     *
     * @return string
     */
    public function setQueryFilterByText($filterBy)
    {
		$this->_filterBy = $filterBy;
    }

    /**
     * Retrieve search query text
     *
     * @return string
     */
    public function getAuthorQueryText()
    {
        if (is_null($this->_queryText) || strlen($this->_queryText) <=0 ) {
            $this->_queryText = urldecode($this->_getRequest()->getParam($this->getAuthorQueryName()));
			if ($this->_queryText === null) {
                $this->_queryText = '';
            } else {
				$this->_queryText = Mage::helper('core/string')->cleanString(trim($this->_queryText));
				$this->setQueryFilterByText('author');
            }
        }
        return $this->_queryText;
    }

    /**
     * Retrieve HTML escaped search query
     * @param string
     * @return string
     */
    public function getEncodedString($url)
    {
		//this code was to remove special characters and replace it with url compatible characters... now not neccessary. taken care in lucene search itself
		//$url  = str_replace($this->_repArr, "_", $url);
		//$url = preg_replace('#[^A-Za-z0-9\_]+#', '-', $url);
		
		//this is to remove - from end of string
		//if(substr($url,-1,1)=='-'){
		//	$url = substr($url,0,-1);
		//}
		return(urlencode($url));
	}

    /**
     * Retrieve HTML escaped search query
     * @param string ,string ,int
     * @return string
     */
    public function getProductUrl($author,$title,$isbn,$urlPrefix=null)
    {
		if(is_null($urlPrefix) || $urlPrefix=='' ){
			$urlPrefix='ekkitab_catalog/product/view/book/';
		}
		$url='';
		if(isset($author) && strlen(trim($author)) > 0)
		{
			$author = urlencode(preg_replace('#[^A-Za-z0-9\_]+#', '-', $author));
			//this is to remove '-' from end of string if any
			if(substr($author,-1,1)=='-'){
				$author = substr($author,0,-1);
			}
			$url=$author."__";
		}

		$url=$url.$title;
		$url = urlencode(preg_replace('#[^A-Za-z0-9\_]+#', '-', $url));
		//this is to remove '-' from end of title string if any
		if(substr($url,-1,1)=='-'){
			$url = substr($url,0,-1);
		}
		
		$url=$urlPrefix.$url."__".$isbn.".html";
		return $url;
	}

	
    /**
     * Retrieve HTML escaped search query
     * @param string ,string ,int
     * @return string
     */
    public function getSearchResultProductUrl($author,$title,$isbn)
    {
		$urlPrefix='ekkitab_catalog/product/show/book/';
		return $this->getProductUrl($author,$title,$isbn,$urlPrefix);
	}

	
	/**
     * Retrieve search query text
     *
     * @return string
     */
    public function getCurrentCategoryPath()
    {
		if (is_null($this->_categoryPath)) {
			$this->_categoryPath = $this->_getRequest()->getParam($this->getCategoryVarName());
			if ($this->_categoryPath === null) {
                $this->_categoryPath = '';
            } else {
				$this->_categoryPath = Mage::helper('core/string')->cleanString(trim($this->_categoryPath));
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
     * Retrieve url for adding product to wishlist
     *
     * @param   mixed $product
     * @return  string
     */
    public function getWishListAddUrl($productId)
    {
        return $this->_getUrl('ekkitab_wishlist/index/add', array('product'=>$productId));
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

       return $this->_getUrl('ekkitab_checkout/cart/add', $params);
    }

    public function getPlaceholder($attr)
    {
		return ('images/catalog/product/placeholder/'.$attr.'.png');
	}

		/**
     * Retrieve result page url
     *
     * @param   string $query
     * @return  string
     */
    public function getGlobalSectionViewUrl($sectionId)
    {
        return $this->_getUrl('ekkitab_catalog/globalsection/view/', array('id'=>$sectionId));
    }

	public function getSearchCriteriaTemplateUrl()
    {

		$tempUrl  = trim((String) $this->_getRequest()->getParam('books'));
		// insert the split function here.....and get the product Id
		if(strrpos($tempUrl, "/")){
			$startIndex = strrpos($tempUrl, "/")+1; 	 
		}else{
			$startIndex=0;
		}
		$endIndex = strpos($tempUrl, ".html"); 	
		$endIndex = $endIndex - $startIndex; 
		$this->_searchIncludeTemplateUrl  = trim(urldecode(substr($tempUrl,$startIndex,$endIndex)));
		return $this->_searchIncludeTemplateUrl;
    }


}
