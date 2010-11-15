<?php
/**
 * Content Index controller
 *
 * @category   Ekkitab
 * @package    Ekkitab_Content
 * @author Anisha (anisha@ekkitab.com)
 * @version 1.0 Feb 10, 2010
 * 
 * @package    Local_Ekkitab
 * @copyright  COPYRIGHT (C) 2009 Ekkitab Educational Services India Pvt. Ltd.
 * @license    All Rights Reserved. All material contained in this file (including, but not limited to, text, images, graphics, HTML, programming code and scripts) 
 * constitute proprietary and  * confidential information protected by copyright laws, trade secret and other laws. No part of this software may be copied, reproduced, modified or 
 * distributed in any form or by any means, or stored in a database or retrieval system without the prior written permission of Ekkitab Educational Services.
 */

class Ekkitab_Content_IndexController extends Mage_Core_Controller_Front_Action
{
    
    private $_isbn;

	/**
     * Initialize requested product object
     *
     * @return Mage_Catalog_Model_Product
     */
    public function viewAction()
    {
		$contentUrl  = trim((String) $this->getRequest()->getParam('page'));
		// insert the split function here.....and get the product Id
		if(strrpos($contentUrl, "/")){
			$contentStartIndex = strrpos($contentUrl, "/")+1; 	 
		}else{
			$contentStartIndex=0;
		}
		$contentEndIndex = strpos($contentUrl, ".html"); 	
		$contentEndIndex = $contentEndIndex - $contentStartIndex; 
		$templateUrl = trim(urldecode(substr($contentUrl,$contentStartIndex,$contentEndIndex)));
		if($templateUrl && count($templateUrl) > 0 ){
			Mage::register('template_url', $templateUrl);
			$this->loadLayout();
			$this->renderLayout();
		}else {
			$this->_forward('noRoute');

		}
    }

	/**
     * Initialize requested product object
     *
     * @return Mage_Catalog_Model_Product
     */
    public function overleafAction()
    {
		$contentUrl  = trim((String) $this->getRequest()->getParam('product'));
		// insert the split function here.....and get the product Id
		if(strrpos($contentUrl, "/")){
			$contentStartIndex = strrpos($contentUrl, "/")+1; 	 
		}else{
			$contentStartIndex=0;
		}
		$contentEndIndex = strpos($contentUrl, ".html"); 	
		$contentEndIndex = $contentEndIndex - $contentStartIndex; 
		$templateUrl = trim(urldecode(substr($contentUrl,$contentStartIndex,$contentEndIndex)));
		if($templateUrl && count($templateUrl) > 0 ){
			Mage::register('template_url', $templateUrl);
			$this->loadLayout();
			$this->renderLayout();
		}else {
			$this->_forward('noRoute');

		}
    }

}
