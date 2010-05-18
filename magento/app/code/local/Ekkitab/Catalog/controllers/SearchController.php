<?php
/**
 * Catalog category search controller
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
class Ekkitab_Catalog_SearchController extends Mage_Core_Controller_Front_Action
{

	public function indexAction()
    {
		$categoryPath = Mage::helper('ekkitab_catalog')->getCurrentCategoryPath();
		// @var $query Mage_CatalogSearch_Model_Query
		$queryText = Mage::helper('ekkitab_catalog')->getQueryText();
		//$start=(float)microtime(true);
		
		if(!($queryText) || strlen($queryText) <= 0){
			$queryText = Mage::helper('ekkitab_catalog')->getAuthorQueryText();
		}
		if ((isset($categoryPath) && strlen($categoryPath) > 0 ) || strlen($queryText) > 0 ) {
			if (strlen($categoryPath) > 0 ) {
                Mage::getSingleton('core/session')->setCurrentCategoryPath(array('current_category_path'=>$categoryPath));
			}else{
                Mage::getSingleton('core/session')->setCurrentCategoryPath(array('current_category_path'=>''));
			}
			if (strlen($queryText) > 0 ) {
                Mage::getSingleton('core/session')->setCurrentQueryText(array('current_query_text'=>$queryText));
				$query = Mage::helper('ekkitab_catalog')->getQuery();
				$query->setStoreId(Mage::app()->getStore()->getId());

				if (Mage::helper('ekkitab_catalog')->isMinQueryLength()) {
					$query->setId(0)
						->setIsActive(1)
						->setIsProcessed(1);
				}
				else {
					if ($query->getId()) {
						$query->setPopularity($query->getPopularity()+1);
					}
					else {
						$query->setPopularity(1);
					}

					if ($query->getRedirect()){
						$query->save();
						$this->getResponse()->setRedirect($query->getRedirect());
						return;
					}
					else {
						$query->prepare();
					}
				}

				Mage::helper('ekkitab_catalog')->checkNotes();
			}else{
                Mage::getSingleton('core/session')->setCurrentQueryText(array('current_query_text'=>''));
			}
			if( isset($categoryPath) && strlen($categoryPath) > 0  && $categoryPath=='allcategories' ){
				$this->_redirect('ekkitab_catalog/category/viewAll');
			}else{
				$this->loadLayout();
				$this->_initLayoutMessages('catalog/session');
				$this->_initLayoutMessages('checkout/session');
				$this->renderLayout();
				if (!Mage::helper('ekkitab_catalog')->isMinQueryLength()) {
					$query->save();
				}
			}
			//$end=(float)microtime(true);
			//$blockTimerArr= Mage::getSingleton('core/session')->getBlockDebugTimer();
			//$phtmlTimerArr= Mage::getSingleton('core/session')->getPhtmlDebugTimer();
			//Mage::log("Debug Times From controller to start of block: ".sprintf("%.5f", (float)($blockTimerArr['block1']-$start))." : to initialization of java class : ".sprintf("%.5f", (float)($blockTimerArr['block2']-$start))." : to searching of book :  ".sprintf("%.5f", (float)($blockTimerArr['block3']-$start))." : to fetch books :".sprintf("%.5f", (float)($blockTimerArr['block4']-$start))." : to start phtml rendering : ".sprintf("%.5f", (float)($phtmlTimerArr['start']-$start))." : to finish rendering : ".sprintf("%.5f", (float)($phtmlTimerArr['end']-$start))." : total time :".sprintf("%.5f", (float)($end-$start)));
		}
        else {
            $this->_forward('noRoute');
        }

    }


}
