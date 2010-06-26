<?php
/**
 * Catalog Category search result Block
 * @category   Local/Ekkitab
 * @package    Ekkitab_Catalog_Block_Category
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
class Ekkitab_Catalog_Block_Category_SearchResult extends Mage_Core_Block_Template
{


//	protected $_productCollection = array();
	protected $_productCollection;
	protected $_productCollectionCount;
	protected $_columnCount = 4;
	protected $_pageSize = 15;
	protected $_pageNo;
	protected $_isbn;
	protected $_categoryPath;
	protected $_filterBy;
	protected $_queryText;
	protected $_lastPageNo;
	protected $_displayPages = 5;

	private static $_socketConn = 0;

    const XML_PATH_SEARCH_INDEX_FILE = 'global/search_index/path';
	const JAVA_BRIDGE_INC_FILE = 'global/java_inc/path';


   protected function _prepareLayout()
    {
	   
		$title ='';
		
		if ($breadcrumbs = $this->getLayout()->getBlock('breadcrumbs')) {

			$breadcrumbs->addCrumb('home', array(
				'label'=>Mage::helper('catalogsearch')->__('Home'),
				'title'=>Mage::helper('catalogsearch')->__('Go to Home Page'),
				'link'=>Mage::getBaseUrl()
			));
   
			$queryText =$this->helper('ekkitab_catalog')->getEscapedQueryText();
			$curr_cp =$this->getCurrentCategoryPath();
			$parentCatArr = array();
			if(isset($curr_cp) && strlen($curr_cp) > 0 ){
				$parentCatArr = explode("__",$curr_cp);
			}

		   if(isset($queryText) && strlen($queryText)>0){
				$link='';
				if(!is_null($parentCatArr) && sizeof($parentCatArr) > 0){
					$link=$this->getSubCategorySearchUrl('',1);
				}
				$title = $this->__("Search for '%s'", urldecode($queryText));
				
				$breadcrumbs->addCrumb('search', array(
					'label'=>$title,
					'title'=>$title,
					'link'=>$link
				));
				
			}

			// This code is to break the category path inot a parent child hierarchy... for breadcrumb display.
			if(!is_null($parentCatArr) && sizeof($parentCatArr) > 0){
				$parentCatPath = ''; // The parent category of the current Category
				$arrSize = sizeof($parentCatArr);
				for($i=0;$i < $arrSize ; $i++){
					$cat = $parentCatArr[$i];
					
					if(isset($parentCatPath) && strlen($parentCatPath) > 0 ){
						$parentCatPath =  $parentCatPath."__". $cat;
					}else{
						$parentCatPath =  $cat;
					}
					if($i < ($arrSize -1)){
						$parentCatUrl = $this->getSubCategorySearchUrl($parentCatPath,1);
					}else{
						$parentCatUrl = '';
					}

					$cat = ucwords($this->getDecodedString($cat));
					$breadcrumbs->addCrumb($cat, array(
						'label'=>$cat,
						'title'=>$cat,
						'link'=>$parentCatUrl
					));
				}
			}
			$this->getLayout()->getBlock('head')->setTitle($title);
		}
		
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
		$books=null;
		$booksResult =NULL;
		if (!($indexFilePathArray = Mage::getConfig()->getNode(self::XML_PATH_SEARCH_INDEX_FILE))) {
			$indexFilePath = 'search_index_dir';
		}else {
			$indexFilePath = (string) $indexFilePathArray[0];
		}
		$indexFilePath =  Mage::getRoot().DIRECTORY_SEPARATOR."..".DIRECTORY_SEPARATOR.$indexFilePath;
		if (!($javaIncFilePathArray = Mage::getConfig()->getNode(self::JAVA_BRIDGE_INC_FILE))) {
			$javaIncFile = 'Java.inc';
		}else {
			$javaIncFile = (string) $javaIncFilePathArray[0];
		}
		try{
			//$start1= (float)microtime(true);
			require($javaIncFile);
			$search = new java("com.ekkitab.search.BookSearch",$indexFilePath );
			//$start2= (float)microtime(true);
			
			$categoryPath = strtolower(str_replace('__', "/", $this->getCurrentCategoryPath())); // this is to parse the parents and child categories seperated by '__'
			// this is to filter the search by title / author / or both
			$filterBy = strlen($this->getFilterByText()) > 0 ?($this->getFilterByText().":"):""; 
			//this is to check if the query text is all numbers...then maybe its isbn... so append isbn: before the query text... 
			$query = urldecode($this->helper('ekkitab_catalog')->getEscapedQueryText());
			if($this->isIsbn($this->helper('ekkitab_catalog')->getEscapedQueryText())){
				$query = $this->_isbn;
				$filterBy = "isbn:"; 
			}
			//$start = (float) array_sum(explode(' ', microtime()));
			$results = $search->searchBook($this->getDecodedString($categoryPath),$filterBy.$query, $this->getPageSize(), $this->getCurrentPageNumber());
			//$start3= (float)microtime(true);

			/*$end = (float) array_sum(explode(' ', microtime()));
			$time = sprintf("%.5f", ($end - $start));
			$log = Mage::getModel('ekkitab_catalogsearch/log');
			$log->setCategory($this->getDecodedString($categoryPath));
			$log->setQuery($filterBy.$this->helper('ekkitab_catalog')->getEscapedQueryText());
			$log->setTimeTaken($time*1000);
			Mage::log($log);
			$log->save();*/

			$start = (float) array_sum(explode(' ', microtime()));
			if(!is_null($results)){
				$suggest = $results->getSuggestQuery();
  				$productIds = java_values($results->getBookIds());
				if(!is_null($productIds) && is_array($productIds) && count($productIds) > 0 ){
					$books = Mage::getModel('ekkitab_catalog/product')->getCollection()
					->addIdFilter($productIds);
				}
				$booksResult = array("books"=>$books,"hits"=>java_values($results->getHitCount()),"categories"=>$results->getResultCategories(),"suggest"=> $suggest,"other_suggestions"=>java_values($results->getSuggestOther()));
				$this->_productCollection = $booksResult;
			}else{
				$booksResult = array("books"=>null,"hits"=>null,"categories"=>null,"suggest"=>null);
			}
			$start4= (float)microtime(true);

		}
		catch(Exception $e)
		{
			Mage::logException($e);
			Mage::log($e->getMessage());
			Mage::log("OR Exception in SearchResult.php : Could not include Java.inc file @ http://localhost:8080/JavaBridge/java/Java.inc");
		}
		//Mage::getSingleton('core/session')->setBlockDebugTimer(array('block1'=>$start1,'block2'=>$start2,'block3'=>$start3,'block4'=>$start4));
		unset($search);
		return $booksResult;
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
				$bookList = $results["books"];
				if (!is_null($bookList)) {
					$size = $bookList->count();
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
			$results = $this->getProductCollection();
			if(!is_null($results)){
				$size = $results["hits"];
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
        return $this->getPagerUrl(array($this->helper('ekkitab_catalog')->getCategoryVarName()=>$this->getCurrentCategoryPath(),$this->helper('ekkitab_catalog')->getQueryParamName()=>urlencode(urldecode($this->helper('ekkitab_catalog')->getEscapedQueryText())),$this->helper('ekkitab_catalog')->getPageNoVarName()=>$page,$this->helper('ekkitab_catalog')->getQueryFilterName()=>$this->helper('ekkitab_catalog')->getQueryFilterByText()));
    }

    public function getSubCategorySearchUrl($categoryPath,$page)
    {
        return $this->getPagerUrl(array($this->helper('ekkitab_catalog')->getCategoryVarName()=>$categoryPath,$this->helper('ekkitab_catalog')->getQueryParamName()=>urlencode(urldecode($this->helper('ekkitab_catalog')->getEscapedQueryText())),$this->helper('ekkitab_catalog')->getPageNoVarName()=>$page,$this->helper('ekkitab_catalog')->getQueryFilterName()=>$this->helper('ekkitab_catalog')->getQueryFilterByText()));
    }

	 public function getPagerUrl($params=array(),$queryParams=null)
    {
		$url = '*/*/*/';
		if(is_array($params)){
			foreach ($params as $param => $value) {
               if(isset($value) && strlen($value) > 0){
				  $url  = $url.$param."/".$value."/";
			   }
            }
        }
        $urlParams = array();
       // $urlParams['_current']  = true;
       // $urlParams['_query']    = $queryParams;
		$url = $this->getUrl($url,$urlParams);
        return $url;
    }


	/**
     * Retrieve search result count
     *
     * @return string
     */
    public function getCurrentPageNumber()
    {
		if(is_null($this->_pageNo)){
			$this->_pageNo = $this->helper('ekkitab_catalog')->getCurrentPageNumber();
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
			$this->_categoryPath = $this->helper('ekkitab_catalog')->getEscapedQueryCategoryPath();
		}
		return $this->_categoryPath;
    }

	/**
     * Retrieve search result count
     *
     * @return string
     */
    public function getFilterByText()
    {
		if(is_null($this->_filterBy)){
			$this->_filterBy = $this->helper('ekkitab_catalog')->getQueryFilterByText();
		}
		return $this->_filterBy;
    }

	/**
     * Retrieve search result count
     *
     * @return string
     */
    public function getDecodedString($str)
    {
		return urldecode($str);
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
			if (strlen($str) == 12) {
				$this->_isbn =  '0'.$str;
				return true;
			}else if (strlen($str) == 10) {
				$this->_isbn = $this->isbn10to13($str);
				return true;
			}else if (strlen($str) == 13) {
				$this->_isbn = $str;
				return true;
			}else{
				return false;
			}
		}else{
			return false;
		}
		
    }

	public	function genchksum13($isbn) {
			$isbn = trim($isbn);
			if (strlen($isbn) != 12) {
				return -1;
			}
			$sum = 0;
			for ($i = 0; $i < 12; $i+=2) {
				$sum += ($isbn[$i] * 1);
				$sum += ($isbn[$i+1] * 3);
			}
			$sum = $sum % 10;
			$sum = 10 - $sum;
			return ($sum == 10 ? 0 : $sum);
		}

	public	function isbn10to13($isbn10) {
			$isbn13 = "";
			$isbn13 = substr("978" . $isbn10, 0, -1);
			$chksum =  $this->genchksum13($isbn13);
			$isbn13 = $isbn13.$chksum;
			return ($isbn13);
		}

	/**
     * Retrieve search result count
     *
     * @return string
     */
    public function getQueryText()
    {
		if(is_null($this->_queryText)){
			$this->_queryText = $this->helper('ekkitab_catalog')->getEscapedQueryText();
		}
		return $this->_queryText;
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

	public function getDonateBlurbHtml()
    {
        return $this->getChildHtml('donate_book_blurb');
    }

    /**
     * Retrieve query model object
     *
     * @return Mage_CatalogSearch_Model_Query
     */
    protected function _getQuery()
    {
        return $this->helper('ekkitab_catalog')->getQuery();
    }

	    /**
     * Retrieve No Result or Minimum query length Text
     *
     * @return string
     */
    public function getNoResultText()
    {
        if (Mage::helper('ekkitab_catalog')->isMinQueryLength()) {
            return Mage::helper('ekkitab_catalog')->__('Minimum Search query length is %s', $this->_getQuery()->getMinQueryLenght());
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
        return Mage::helper('ekkitab_catalog')->getNoteMessages();
    }

	  /**
     * Enter description here...
     *
     * @param Mage_Catalog_Model_Product $product
     * @return string
     */
    public function getAddToWishlistUrl($productId)
    {
        return $this->getUrl('ekkitab_wishlist/index/add',array('product'=>$productId));
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
        return $this->helper('ekkitab_catalog')->getCartUrl($productId,$this->helper('core/url')->getCurrentUrl());
    }

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


  
	/**
     * Retrieve loaded category collection
     *
     * @return Mage_CatalogSearch_Model_Mysql4_Product_Collection
    */
   
    protected function getProducts()
    {
		if (is_null($this->_productCollection)) {
			$productIds = $this->helper('ekkitab_catalog')->getSearchResultsIds();
			$this->_productCollection = Mage::getModel('ekkitab_catalog/product')->getCollection()
				->addIdFilter($productIds);
		} 
        return $this->_productCollection;
    }
    
}
