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
class Ekkitab_CatalogSearch_CustomController extends Mage_Core_Controller_Front_Action
{

    public function resultAction()
    {
        $this->loadLayout();
        try {
			Mage::getSingleton('ekkitab_catalogsearch/custom')->addAuthorTitleFilters($this->getRequest()->getQuery());
        } catch (Mage_Core_Exception $e) {
            Mage::getSingleton('catalogsearch/session')->addError($e->getMessage());
            $this->_redirectError(Mage::getURL('*/*/'));
        }
        $this->_initLayoutMessages('catalog/session');
        $this->renderLayout();
    }

	public function resultByIndexAction()
    {
        $query = Mage::helper('ekkitab_catalogsearch')->getQuery();
        // @var $query Mage_CatalogSearch_Model_Query

        $query->setStoreId(Mage::app()->getStore()->getId());

        if ($query->getQueryText()) {
            if (Mage::helper('ekkitab_catalogsearch')->isMinQueryLength()) {
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

            Mage::helper('ekkitab_catalogsearch')->checkNotes();
            $this->loadLayout();
            $this->_initLayoutMessages('catalog/session');
            $this->_initLayoutMessages('checkout/session');
            $this->renderLayout();
            if (!Mage::helper('ekkitab_catalogsearch')->isMinQueryLength()) {
                $query->save();
            }
        }
        else {
            $this->_redirectReferer();
        }
		
    }

}
