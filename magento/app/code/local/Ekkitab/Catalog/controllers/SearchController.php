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
		
		
		if ((isset($categoryPath) && strlen($categoryPath) > 0 ) || strlen($queryText) > 0 ) {
			if (strlen($queryText) > 0 ) {
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
				if (!Mage::helper('ekkitab_catalog')->isMinQueryLength()) {
					$query->save();
				}
			}
			$this->loadLayout();
			$this->_initLayoutMessages('catalog/session');
			$this->_initLayoutMessages('checkout/session');
			$this->renderLayout();


		}
        else {
            $this->_redirectReferer();
        }

    }

	/*public function resultAction()
    {
        $this->loadLayout();
        try {
			Mage::getSingleton('ekkitab_catalogsearch/custom')->addAuthorTitleFilters($this->getRequest()->getQuery());
        } catch (Mage_Core_Exception $e) {
            Mage::getSingleton('catalogsearch/session')->addError($e->getMessage());
            $this->_redirectError(Mage::getURL('*'.'/*'.'/'));
        }
        $this->_initLayoutMessages('catalog/session');
        $this->renderLayout();
    }*/

}
