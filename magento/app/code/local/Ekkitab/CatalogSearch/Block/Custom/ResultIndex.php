<?php
/**
 * Catalogsearch Custom result Block
 * @category   Local/Ekkitab
 * @package    Ekkitab_CatalogSearch_Block_Custom
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

/**
 * Product search result block
 *
 * @category   Mage
 * @package    Mage_CatalogSearch
 * @module     Catalog
 */
class Ekkitab_CatalogSearch_Block_Custom_ResultIndex extends Mage_Core_Block_Template
{


//	protected $_productCollection = array();
	protected $_productCollection;
	protected $_productCollectionCount;
	protected $_columnCount = 4;
	protected $_pageSize = 15;
	protected $_pageNo;
	protected $_categoryPath;
	protected $_lastPageNo;
	protected $_displayPages = 7;

	private static $_socketConn = 0;

    const XML_PATH_SEARCH_INDEX_FILE = 'global/search_index/path';
	const JAVA_BRIDGE_INC_FILE = 'global/java_inc/path';


   protected function _prepareLayout()
    {
        $title = $this->__("Search results for '%s'", $this->helper('ekkitab_catalogsearch')->getEscapedQueryText());

		if ($breadcrumbs = $this->getLayout()->getBlock('breadcrumbs')) {
            $breadcrumbs->addCrumb('home', array(
                'label'=>Mage::helper('catalogsearch')->__('Home'),
                'title'=>Mage::helper('catalogsearch')->__('Go to Home Page'),
                'link'=>Mage::getBaseUrl()
            ))->addCrumb('search', array(
                'label' => $title,
                'title' => $title
            ));
        }
        $this->getLayout()->getBlock('head')->setTitle($title);
        return parent::_prepareLayout();
    }

	public function setColumnCount($count)
    {
        if (intval($count) > 0) {
            $this->_columnCount = intval($count);
        }
        return $this;
    }

    public function getColumnCount()
    {
        return $this->_columnCount;
    }

	public function setPageSize($count)
    {
        if (intval($count) > 0) {
            $this->_pageSize = intval($count);
        }
        return $this;
    }

    public function getPageSize()
    {
        return $this->_pageSize;
    }

    public function getPageNo()
    {
        return $this->_pageNo;
    }

	protected function getSearchResults() 
    {
		$indexFilePathArray;
		$javaIncFilePathArray;
		$indexFilePath;
		$javaIncFile;
		$results;
		if (!($indexFilePathArray = Mage::getConfig()->getNode(self::XML_PATH_SEARCH_INDEX_FILE))) {
			$indexFilePath = 'search_index_dir';
		}else {
			$indexFilePath = (string) $indexFilePathArray[0];
		}
		$indexFilePath =  Mage::getRoot().DIRECTORY_SEPARATOR."..".DIRECTORY_SEPARATOR.$indexFilePath;
		if (!($javaIncFilePathArray = Mage::getConfig()->getNode(self::JAVA_BRIDGE_INC_FILE))) {
			$javaIncFile = 'http://localhost:8080/JavaBridge/java/Java.inc';
		}else {
			$javaIncFile = (string) $javaIncFilePathArray[0];
		}
		try{
			require_once($javaIncFile);
			$search = new java("BookSearch",$indexFilePath );
			$results = $search->searchBook(urldecode($this->helper('ekkitab_catalogsearch')->getCurrentCategoryPath()),$this->helper('ekkitab_catalogsearch')->getEscapedQueryText(), $this->getPageSize(), $this->getCurrentPageNumber());
		}
		catch(Exception $e)
		{
			$results =NULL;
			Mage::log("Exception in ResultIndex.php : Could not include Java.inc file @ http://localhost:8080/JavaBridge/java/Java.inc");
		}
		return $results;
    }
 
		
	public function getProductCollection(){

		//introduce the lucene search here.....
		if (is_null($this->_productCollection)) { 
			$this->_productCollection = $this->getSearchResults();
		}
		return $this->_productCollection;
    }
	
	/**
     * Retrieve search result count
     *
     * @return string
     */
    public function getResultCount()
    {
	   $size =0;
	   if (!$this->getData('result_count')) {
			$results = $this->getProductCollection();
			if(!is_null($results)){
				$bookList = $results->get("books");
				if (!java_is_null($bookList)) {
					$size = java_values($bookList->size());
				}
			}
			$this->setResultCount($size);
        }
        return $this->getData('result_count');
    }



	/**
     * Retrieve search result count
     *
     * @return string
     */
    public function getTotalResultCount()
    {
	   if (!$this->getData('total_result_count')) {
            if($this->getProductCollection()){
				$results = $this->_productCollection;
				//$authorCount=java_values($results->get("hitcount-author"));
				//$titleCount=java_values($results->get("hitcount-title"));
				//$size = max($authorCount,$titleCount);
				$size = java_values($results->get("hits"));
			}else{
				$size = 0;
			}
			$this->setTotalResultCount($size);
			$this->_getQuery()->setNumResults($size);
        }
        return $this->getData('total_result_count');
    }

	/**
     * Retrieve search result count
     *
     * @return string
     */
    public function getLastPageNumber()
    {
		if(is_null($this->_lastPageNo)){
			$this->_lastPageNo = ceil((int)$this->getTotalResultCount() / $this->_pageSize);
		}
		return $this->_lastPageNo;
    }

    public function isFirstPage()
    {
        return $this->getCurrentPageNumber() == 1;
    }

	public function isPageCurrent($page)
    {
        return $page == $this->getCurrentPageNumber();
    }
	
    public function isLastPage()
    {
        return $this->getCurrentPageNumber() >= $this->getLastPageNumber();
    }

    public function getFirstPageUrl()
    {
        return $this->getPageUrl(1);
    }

    public function getPreviousPageUrl()
    {
        return $this->getPageUrl($this->getCurrentPageNumber()-1);
    }

    public function getNextPageUrl()
    {
        return $this->getPageUrl($this->getCurrentPageNumber()+1);
    }

    public function getLastPageUrl()
    {
        return $this->getPageUrl($this->getLastPageNumber());
    }

    public function getPageUrl($page)
    {
        return $this->getPagerUrl(array($this->helper('ekkitab_catalogsearch')->getCategoryPath()=>$this->helper('ekkitab_catalogsearch')->getEscapedQueryCategoryPath(),$this->helper('ekkitab_catalogsearch')->getPageNoVarName()=>$page));
    }

    public function getSubCategorySearchUrl($categoryPath,$page)
    {
        return $this->getPagerUrl(array($this->helper('ekkitab_catalogsearch')->getCategoryPath()=>$categoryPath,$this->helper('ekkitab_catalogsearch')->getPageNoVarName()=>$page));
    }

	 public function getPagerUrl($params=array())
    {
        $urlParams = array();
        $urlParams['_current']  = true;
        $urlParams['_escape']   = true;
        $urlParams['_use_rewrite']   = true;
        $urlParams['_query']    = $params;
        return $this->getUrl('*/*/*', $urlParams);
    }
	/**
     * Retrieve search result count
     *
     * @return string
     */
    public function getCurrentPageNumber()
    {
		if(is_null($this->_pageNo)){
			$this->_pageNo = $this->helper('ekkitab_catalogsearch')->getCurrentPageNumber();
		}
		return $this->_pageNo;
    }

	/**
     * Retrieve search result count
     *
     * @return string
     */
    public function getCurrentCategoryPath()
    {
		if(is_null($this->_categoryPath)){
			$this->_categoryPath = $this->helper('ekkitab_catalogsearch')->getEscapedQueryCategoryPath();
		}
		return $this->_categoryPath;
    }

    public function getFirstNum()
    {
        return $this->getPageSize()*($this->getCurrentPageNumber()-1)+1;
    }

    public function getLastNum()
    {
        $collection = $this->getCollection();
        return $this->getPageSize()*($this->getCurrentPageNumber()-1)+$this->getResultCount();
    }

    public function getTotalNum()
    {
        return $this->getTotalResultCount();
    }
	
	public function getPages()
    {
        $pages = array();

        if ($this->getLastPageNumber() <= $this->_displayPages) {
            $pages = range(1,$this->getLastPageNumber());
        }
        else {
            $half = ceil($this->_displayPages / 2);
            if ($this->_pageNo >= $half && $this->_pageNo <= $this->getLastPageNumber() - $half) {
                $start  = ($this->_pageNo - $half) + 1;
                $finish = ($start + $this->_displayPages) - 1;
            }
            elseif ($this->_pageNo < $half) {
                $start  = 1;
                $finish = $this->_displayPages;
            }
            elseif ($this->_pageNo > ($this->getLastPageNumber() - $half)) {
                $finish = $this->getLastPageNumber();
                $start  = $finish - $this->_displayPages + 1;
            }

            $pages = range($start, $finish);
        }
        return $pages;

    }

	public function getProductListHtml()
    {
        return $this->getChildHtml('search_result_list');
    }

    /**
     * Retrieve query model object
     *
     * @return Mage_CatalogSearch_Model_Query
     */
    protected function _getQuery()
    {
        return $this->helper('ekkitab_catalogsearch')->getQuery();
    }

	    /**
     * Retrieve No Result or Minimum query length Text
     *
     * @return string
     */
    public function getNoResultText()
    {
        if (Mage::helper('ekkitab_catalogsearch')->isMinQueryLength()) {
            return Mage::helper('ekkitab_catalogsearch')->__('Minimum Search query length is %s', $this->_getQuery()->getMinQueryLenght());
        }
        return $this->_getData('no_result_text');
    }

    /**
     * Retrieve Note messages
     *
     * @return array
     */
    public function getNoteMessages()
    {
        return Mage::helper('ekkitab_catalogsearch')->getNoteMessages();
    }

	  /**
     * Enter description here...
     *
     * @param Mage_Catalog_Model_Product $product
     * @return string
     */
    public function getAddToWishlistUrl($productId)
    {
        return $this->getUrl('wishlist/index/add',array('product'=>$productId));
    }

    /**
     * Retrieve url for add product to cart
     * Will return product view page URL if product has required options
     *
     * @param Mage_Catalog_Model_Product $product
     * @param array $additional
     * @return string
     */
    public function getAddToCartUrl($productId)
    {
        return $this->helper('ekkitab_catalogsearch')->getCartUrl($productId,$this->helper('core/url')->getCurrentUrl());
    }

	/**
     * Get parameters used for build add product to compare list urls
     *
     * @param   Mage_Catalog_Model_Product $product
     * @return  array
    protected function _getUrlParams($product)
    {
        return ;
    }
     */

    /**
     * Retrieve url for adding product to conpare list
     *
     * @param   Mage_Catalog_Model_Product $product
     * @return  string
     */
    public function getAddToCompareUrl($productId)
    {
        return $this->getUrl('catalog/product_compare/add', array('product' => $productId,Mage_Core_Controller_Front_Action::PARAM_NAME_URL_ENCODED => $this->helper('core/url')->getEncodedUrl()));
    }


  
    
	protected function getSearchResultsIds() 
    {
       $indexFilePathArray;
       $indexFilePath;
	   if (!($indexFilePathArray = Mage::getConfig()->getNode(self::XML_PATH_SEARCH_INDEX_FILE))) {
			$indexFilePath = 'search_index';
	   }else {
			$indexFilePath = (string) $indexFilePathArray[0];

	   }
	   $index = new Zend_Search_Lucene($indexFilePath);
       $query = $this->helper('ekkitab_catalogsearch')->getEscapedQueryText();
       $query = Zend_Search_Lucene_Search_QueryParser::parse($query);
       $hits = $index->find($query);
       $books = array();
	   $count=0;
       foreach ($hits as $hit) {
          $books[$count++] = $hit->entityId; 
       }
       return $books;
    }
 


	protected function getSearchResults_old() 
    {
		$indexFilePathArray;
		$indexFilePath;
		if (!($indexFilePathArray = Mage::getConfig()->getNode(self::XML_PATH_SEARCH_INDEX_FILE))) {
			$indexFilePath = 'search_index';
		}else {
			$indexFilePath = (string) $indexFilePathArray[0];

		}
		$index = new Zend_Search_Lucene($indexFilePath);
		$query = $this->helper('ekkitab_catalogsearch')->getEscapedQueryText();
		$query = Zend_Search_Lucene_Search_QueryParser::parse($query);
		$hits = $index->find($query);
		$books = array();
		foreach ($hits as $hit) {
		  $books[] = array(
						"Id" => $hit->entityId,
						"ProductUrl" => $hit->url,
						"Title" => $hit->title,
						"Price" => "0.0",
						"Author" => $hit->author,
						"Image" => $hit->image,
						"ImageLabel" => $hit->image_label 
					 ); 
		}
		return $books; 
	}
 
  /* 
  
  
	/**
	* Retrieve search result count
	*
	* @return string
	public function getResultCount()
	{
	   if (!$this->getData('result_count')) {
			$size = $this->getProductCollection()->getSize();
			$this->_getQuery()->setNumResults($size);
			$this->setResultCount($size);
		}
		return $this->getData('result_count');
	}


	public function setListOrders() {
        $category = Mage::getSingleton('catalog/layer')
            ->getCurrentCategory();
        // @var $category Mage_Catalog_Model_Category 

        $availableOrders = $category->getAvailableSortByOptions();
        unset($availableOrders['position']);

        $this->getChild('search_result_list')
            ->setAvailableOrders($availableOrders);
    }
    public function setListModes() {
        $this->getChild('search_result_list')
            ->setModes(array(
                'grid' => Mage::helper('catalogsearch')->__('Grid'),
                'list' => Mage::helper('catalogsearch')->__('List'))
            );
    }
*/

    /**
     * Retrieve search list toolbar block
     *
     * @return Mage_Catalog_Block_Product_List
    public function getListBlock()
    {
        return $this->getChild('search_result_list');
    }

     */
	/**
     * Set Search Result collection
     *
     * @return Mage_CatalogSearch_Block_Result
     
    public function setListCollection() {
        $this->getListBlock()
           ->setCollection($this->getProductCollection());
       return $this;
    }
*/

}
