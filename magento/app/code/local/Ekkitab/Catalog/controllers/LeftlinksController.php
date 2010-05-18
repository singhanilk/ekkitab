<?php
/**
 * Catalog Custom search controller
 * @category   Local/Ekkitab
 * @package    Ekkitab_CatalogSearch
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
class Ekkitab_Catalog_LeftlinksController extends Mage_Core_Controller_Front_Action
{

	public function viewAction()
	{
		//Mage::dispatchEvent('catalog_controller_product_init_before', array('controller_action'=>$this));
		$linkUrl  = (String) $this->getRequest()->getParam('details');

		// insert the split function here.....and get the link Id
		$linkIdStartIndex = strrpos($linkUrl, DIRECTORY_SEPARATOR); 	  
		$linkIdEndIndex = strpos($linkUrl, ".html"); 	
		$linkIdEndIndex = $linkIdEndIndex - $linkIdStartIndex;  //.html/	
		//$linkId = (int) substr($linkUrl,$linkIdStartIndex,$linkIdEndIndex);
		$key = substr($linkUrl,$linkIdStartIndex,$linkIdEndIndex);

		if ( is_null($key) || strlen($key) <=0 ) {
			$this->_forward('noRoute');
		} else {
			Mage::register('link_key',$key);
			$this->loadLayout();
			$this->renderLayout();
		}
	}

	public function viewOldAction()
    {
		//Mage::dispatchEvent('catalog_controller_product_init_before', array('controller_action'=>$this));
		$linkUrl  = (String) $this->getRequest()->getParam('details');

		// insert the split function here.....and get the link Id
		$linkIdStartIndex = strrpos($linkUrl, "__")+2; 	  
		$linkIdEndIndex = strpos($linkUrl, ".html"); 	
		$linkIdEndIndex = $linkIdEndIndex - $linkIdStartIndex;  //.html/	
		$linkId = (int) substr($linkUrl,$linkIdStartIndex,$linkIdEndIndex);

		if (!(is_int($linkId) && $linkId > 0) ) {
			$this->_forward('noRoute');
		} else{
			Mage::register('linkId', $linkId);
			$links = Mage::getModel('ekkitab_catalog/leftlinks')->getCollection()
				->joinLinkHeaderData()
				->leftJoinLinkQueryData()
				->addFieldToFilter('main_table.id',Mage::registry('linkId'))
				->load();
		
			if(!is_null($links)){
				foreach($links as $link){
					$bookIsbns = $link->getRelatedBookIds();
					$templatePath = $link->getTemplatePath();
					if(!is_null($bookIsbns) && strlen(trim($bookIsbns)) > 0 ){
						$bookIsbnArr = explode(',',$bookIsbns);
						//$count = count($bookIsbnArr);
						//if($count ==1){
						//	$productId=$bookIsbnArr[0];
						//	$this->_redirect('ekkitab_catalog/product/view/isbn/'.$link->getCaption()."__".$productId.".html");
						//}else{
							Mage::register('related_book_ids',$bookIsbnArr);
							Mage::register('templatePath',$templatePath);
							Mage::register('link',$link);
							$this->loadLayout();
							$this->renderLayout();
						//}
					} else{
						$hdrCaption = $link->getHeader()." ".$link->getCaption();
						$query = $link->getSearchKeyword();
						$queryParamName = Mage::helper('ekkitab_catalog')->getQueryParamName();

						$category = $link->getSearchCategory();
						$categoryParamName = Mage::helper('ekkitab_catalog')->getCategoryVarName();

						$filterBy = $link->getSearchFilter();
						$filterByParamName = Mage::helper('ekkitab_catalog')->getQueryFilterName();
						
						$templatePath = $link->getTemplatePath();

						$paramArr= array('_secure'=>true,$queryParamName=>urlencode($query), $categoryParamName=>$category , $filterByParamName=> $filterBy);
						$this->_redirect('ekkitab_catalog/search/index',$paramArr);
					}
				}
			}else{
				$this->_forward('noRoute');
			}
		}
    }


}
