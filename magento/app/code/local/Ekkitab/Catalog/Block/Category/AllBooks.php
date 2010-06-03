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
class Ekkitab_Catalog_Block_Category_AllBooks extends Mage_Core_Block_Template
{


	protected $_productCollection;
	protected $_productCollectionCount;
	protected $_pageSize = 15;
	protected $_pageNo;
	protected $_lastPageNo;
	protected $_displayPages = 5;

   protected function _prepareLayout()
    {
	   
		$title ='Full Catalog';
		
		if ($breadcrumbs = $this->getLayout()->getBlock('breadcrumbs')) {

			$breadcrumbs->addCrumb('home', array(
				'label'=>Mage::helper('catalogsearch')->__('Home'),
				'title'=>Mage::helper('catalogsearch')->__('Go to Home Page'),
				'link'=>Mage::getBaseUrl()
			));

			$breadcrumbs->addCrumb('allBooks', array(
				'label'=>Mage::helper('catalogsearch')->__('All Books'),
				'title'=>Mage::helper('catalogsearch')->__('All Books'),
				'link'=>''
			));
			$this->getLayout()->getBlock('head')->setTitle($title);
		}
		
        return parent::_prepareLayout();
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

		
	protected function getAllBooks() 
    {
		$books=null;
		$booksResult =NULL;
		$pageSize=$this->getPageSize();
		$currPageNo=$this->getCurrentPageNumber();
		$startId=($currPageNo-1)*$pageSize;
		$endId=($currPageNo*$pageSize)+1;
		$results = Mage::getModel('ekkitab_catalog/product')->getCollection()
					->addIdRangeFilter($startId,$endId);
		return $results;
    }
 
		
 
	public function getProductCollection(){

		//introduce the lucene search here.....
		if (is_null($this->_productCollection)) { 
			$this->_productCollection = $this->getAllBooks();
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
				$size = $results->count();
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
			$size =  Mage::getResourceSingleton('ekkitab_catalog/product')
					->getMaxBookId();
			$this->setTotalResultCount($size);
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
        return $this->getPagerUrl(array($this->helper('ekkitab_catalog')->getPageNoVarName()=>$page));
    }

    public function getSubCategorySearchUrl($categoryPath,$page)
    {
        return $this->getPagerUrl(array($this->helper('ekkitab_catalog')->getPageNoVarName()=>$page));
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


  }
