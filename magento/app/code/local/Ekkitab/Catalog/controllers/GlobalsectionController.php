<?php
/**
 * Globalsection controller
 *
 * @category   Ekkitab
 * @package    Ekkitab_Catalog
 * @author Anisha (anisha@ekkitab.com)
 * @version 1.0 Feb 10, 2010
 * 
 * @package    Local_Ekkitab
 * @copyright  COPYRIGHT (C) 2009 Ekkitab Educational Services India Pvt. Ltd.
 * @license    All Rights Reserved. All material contained in this file (including, but not limited to, text, images, graphics, HTML, programming code and scripts) 
 * constitute proprietary and  * confidential information protected by copyright laws, trade secret and other laws. No part of this software may be copied, reproduced, modified or 
 * distributed in any form or by any means, or stored in a database or retrieval system without the prior written permission of Ekkitab Educational Services.
 */

class Ekkitab_Catalog_GlobalsectionController extends Mage_Core_Controller_Front_Action
{
    /**
     * Initialize requested product object
     *
     * @return Mage_Catalog_Model_Product
     */
    public function viewAction()
    {
//		$sectionId  = (int) $this->getRequest()->getParam('id');
		$sectionId  = $this->getRequest()->getParam('id');

		//if (!(is_int($sectionId) && $sectionId > 0 )) {
		//	$this->_forward('noRoute');
		//}

		Mage::register('sectionId', $sectionId);
		$this->loadLayout();
		$this->renderLayout();
    }

}
