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

	protected function _prepareLayout()
    {
		$title = $this->getProduct()->getName();
		if ($headBlock = $this->getLayout()->getBlock('head')) {
			$headBlock->setTitle($title." @ Ekkitab Educational Services");
			$headBlock->setKeywords($title." @ Ekkitab Educational Services");
			$headBlock->setDescription( $this->getProduct()->getDescription() );
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
				$searchText = $this->__("Search for '%s'", $queryText);
				
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
			$breadcrumbs->addCrumb($title, array(
				'label'=>$title,
				'title'=>$title,
				'link'=>''
			));

		}
		
        return parent::_prepareLayout();
		
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
				Mage::register('productId', Mage::helper('ekkitab_catalog/product')->getProductId());
			}
			$this->_product = Mage::getModel('ekkitab_catalog/product')->load(Mage::registry('productId'));
		}
		return $this->_product;
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


	
}
