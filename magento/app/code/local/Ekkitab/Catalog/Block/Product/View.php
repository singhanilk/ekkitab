<?php
/**
 * 
 * Frontend  block
 * @category   Local/Ekkitab
 * @author Anisha (anisha@ekkitab.com)
 * @version 1.0 Nov 17, 2009
 * 
 * @package    Local_Ekkitab
 * @copyright  COPYRIGHT (C) 2009 Ekkitab Educational Services India Pvt. Ltd.
 * @license    All Rights Reserved. All material contained in this file (including, but not limited to, text, images, graphics, HTML, programming code and scripts) 
 * constitute proprietary and  * confidential information protected by copyright laws, trade secret and other laws. No part of this software may be copied, reproduced, modified or 
 * distributed in any form or by any means, or stored in a database or retrieval system without the prior written permission of Ekkitab Educational Services.
 * 
 * 
 */
class Ekkitab_Catalog_Block_Product_View extends Mage_Core_Block_Template
{

    private $_reviewsHelperBlock;
   
    private $_product;
    private $_isbn;
    private $_productPromo;

    const XML_PATH_SEARCH_INDEX_FILE = 'global/search_index/path';
	const JAVA_BRIDGE_INC_FILE = 'global/java_inc/path';

	protected function _prepareLayout()
    {
		if($this->getProduct()){
			$isbn = $this->getProduct()->getIsbn();
			$isbn10 = $this->getProduct()->getIsbn10();
			$price = $this->getProduct()->getDiscountPrice();
			$authorArr= $this->getProduct()->getAuthor();
			$author = !is_null($authorArr['a']) ? " by ".$authorArr['a'] :"";
			$shippingTimeMin = (int)$this->getProduct()->getDeliveryPeriod();
			$shippingTimeMax = round($shippingTimeMin + (.5 * $shippingTimeMin) );
			$shippingTime = ( $shippingTimeMin > 0 && $shippingTimeMax > 0 ) ? "Delivers in ".$shippingTimeMin." - ".$shippingTimeMax." business days":"";
			$title = $this->getProduct()->getTitle();
			$ogTitle = $title.$author; 
			$productUrl = $this->getProduct()->getProductUrl();
			$imagetUrl = Mage::Helper('ekkitab_catalog')->resize($this->getProduct()->getImage(),'image',false,null, 200); 
			
			
			$desc = "Buy ".$title."(".$isbn.")".$author." at Rs.".$price.". ".$shippingTime."- Ekkitab.com";

			if ($headBlock = $this->getLayout()->getBlock('head')) {
				$headBlock->setTitle($title.$author." | ".$isbn." | Buy ".$title." online India | ");
				$headBlock->setKeywords($title.$author." at Ekkitab, Buy online ". $title.$author." at Ekkitab, ".$isbn.", ".$isbn10);
				$headBlock->setDescription($desc);
				$headBlock->setOpenGraphTitle($ogTitle);
				$headBlock->setOpenGraphSiteName("Ekkitab.com");
				//$headBlock->setOpenGraphType("book");
				$headBlock->setOpenGraphImageUrl($imagetUrl);
				$headBlock->setOpenGraphProductUrl($this->getUrl($productUrl));
				$headBlock->setFacebookAdmin("ekkitab");
			}
			if ($breadcrumbs = $this->getLayout()->getBlock('breadcrumbs')){
				$breadcrumbs->addCrumb('home', array(
					'label'=>Mage::helper('ekkitab_catalog')->__('Home'),
					'title'=>Mage::helper('ekkitab_catalog')->__('Go to Home Page'),
					'link'=>Mage::getBaseUrl()
				));
	   
				$queryTextArr = Mage::getSingleton('core/session')->getCurrentQueryText();
				if(is_array($queryTextArr) && count($queryTextArr) > 0 ){
					$queryText	= $queryTextArr['current_query_text'];
				}else{
					$queryText ='';
				}
				$curr_cp_arr = Mage::getSingleton('core/session')->getCurrentCategoryPath();
				if(is_array($curr_cp_arr) && count($curr_cp_arr) > 0 ){
					$curr_cp= $curr_cp_arr['current_category_path'];
				}else{
					$curr_cp='';
				}
				
				$parentCatArr = array();
				if(isset($curr_cp) && strlen($curr_cp) > 0 ){
					$parentCatArr = explode("__",$curr_cp);
				}

			   if(isset($queryText) && strlen($queryText)>0){
					$link=$this->getPagerUrl(array($this->helper('ekkitab_catalog')->getCategoryVarName()=>'',$this->helper('ekkitab_catalog')->getPageNoVarName()=>1),array($this->helper('ekkitab_catalog')->getQueryParamName()=>$queryText));
					$searchText = $this->__("Search for '%s'", urldecode($queryText));
					
					$breadcrumbs->addCrumb('search', array(
						'label'=>$searchText,
						'title'=>$searchText,
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
						$parentCatUrl = $this->getPagerUrl(array($this->helper('ekkitab_catalog')->getCategoryVarName()=>$parentCatPath,$this->helper('ekkitab_catalog')->getPageNoVarName()=>1),array($this->helper('ekkitab_catalog')->getQueryParamName()=>$queryText));
						$cat = ucwords(urldecode($cat));
						$breadcrumbs->addCrumb($cat, array(
							'label'=>$cat,
							'title'=>$cat,
							'link'=>$parentCatUrl
						));
					}
				}
		
				$title=htmlspecialchars_decode($title,ENT_QUOTES);
				$breadcrumbs->addCrumb($title, array(
					'label'=>$title,
					'title'=>$title,
					'link'=>''
				));

			}
		
		}

		Mage::getSingleton('core/session')->setCurrentQueryText('');
		Mage::getSingleton('core/session')->setCurrentCategoryPath('');
        return parent::_prepareLayout();
		
    }

	public function htmlspecialchars_decode($string,$style=ENT_COMPAT)
    {
        $translation = array_flip(get_html_translation_table(HTML_SPECIALCHARS,$style));
        if($style === ENT_QUOTES){ $translation['&#39;'] = '\''; }
        return strtr($string,$translation);
    }
	
	public function getPagerUrl($params=array(),$queryParams=array())
    {
		$url = 'ekkitab_catalog/search/index/';
		if(is_array($params)){
			foreach ($params as $param => $value) {
               if(isset($value) && strlen($value) > 0){
				  $url  = $url.$param."/".$value."/";
			   }
            }
        }
        $urlParams = array();
        $urlParams['_current']  = true;
        $urlParams['_query']    = $queryParams;
		$url = $this->getUrl($url,$urlParams);
        return $url;
    }
	
	/**
     * Get popular of current store
     *
     */
    public function getProduct()
    {
		if(is_null($this->_product)){
			if (!Mage::registry('productId')) {
				//Mage::unregister('productId');
				Mage::register('productId', Mage::helper('ekkitab_catalog/product_data')->getProductId());
			}
			if($this->isIsbn(Mage::registry('productId'))){
				$isbn = $this->_isbn;
				$this->_product= Mage::getModel('ekkitab_catalog/product')->load($isbn,'isbn');
			}else{
				$this->_product = Mage::getModel('ekkitab_catalog/product')->load(Mage::registry('productId'));
			}
		}
		if($this->_product->getId() > 0){
			return $this->_product;
		} else {
			return null;
		}
	}

	protected function getIndianBooks() 
    {
		$indexFilePathArray;
		$javaIncFilePathArray;
		$indexFilePath;
		$javaIncFile;
		$books=null;
		$book=$this->getProduct();
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
			require($javaIncFile);
			$search = new java("com.ekkitab.search.BookSearch",$indexFilePath );

			$authorArr=$book->getAuthor();
			$author = $authorArr['a'] ;

			$title=$book->getTitle();
			$results = $search->lookup($author, $title);

			if(!is_null($results)){
  				$productIds = java_values($results->getBookIds());
				if(!is_null($productIds) && is_array($productIds) && count($productIds) > 0 ){
					$books = Mage::getModel('ekkitab_catalog/product')->getCollection()
					->addIdFilter($productIds)
					->addNotInIdFilter($book->getId());
				}
			}

		}
		catch(Exception $e)
		{
			Mage::logException($e);
			Mage::log($e->getMessage());
			Mage::log("OR Exception in Product View.php : Could not include Java.inc file @ http://localhost:8080/JavaBridge/java/Java.inc");
		}
		unset($search);
		return $books;
    }

	
	/**
     * Get product reviews summary
     *
     * @param Mage_Catalog_Model_Product $product
     * @param bool $templateType
     * @param bool $displayIfNoReviews
     * @return string
     */
    public function getPromoContent()
    {
        $product = $this->getProduct();
		if(is_null($this->_productPromo)){
			$this->_productPromo = Mage::getModel('ekkitab_catalog/product_promo')->getCollection()
					->addFieldToFilter('main_table.isbn',$product->getIsbn());
		}
		return $this->_productPromo;
		
    }


	/**
     * Get product reviews summary
     *
     * @param Mage_Catalog_Model_Product $product
     * @param bool $templateType
     * @param bool $displayIfNoReviews
     * @return string
     */
    public function getReviewsSummaryHtml(Ekkitab_Catalog_Model_Product $product, $templateType = false, $displayIfNoReviews = false)
    {
        $this->_initReviewsHelperBlock();
        return $this->_reviewsHelperBlock->getSummaryHtml($product, $templateType, $displayIfNoReviews);
    }


    /**
     * Add/replace reviews summary template by type
     *
     * @param string $type
     * @param string $template
     */
    public function addReviewSummaryTemplate($type, $template)
    {
        $this->_initReviewsHelperBlock();
        $this->_reviewsHelperBlock->addTemplate($type, $template);
    }

    /**
     * Create reviews summary helper block once
     *
     */
    protected function _initReviewsHelperBlock()
    {
        if (!$this->_reviewsHelperBlock) {
            $this->_reviewsHelperBlock = $this->getLayout()->createBlock('review/helper');
        }
    }


	/**
     * Retrieve search result count
     *
     * @return boolean
     */
    public function isIsbn($str)
    {
		$str=trim($str);
		if (preg_match("/^[0-9\-_]+$/", $str)) {
			$str = preg_replace("/[-_]/", "", $str);
		}
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
		}else {
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
}
