<?php
/**
/**
 * Catalog Custom search helper
 * @category   Local/Ekkitab
 * @package    Ekkitab_CatalogSearch_Helper
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

class Ekkitab_Content_Helper_Data extends Mage_Core_Helper_Abstract
{

	/**
     * Page Number
     *
     * @var int
     */
    protected $_templateUrl;

	public function getTemplateUrl()
    {
		$contentUrl  = (String) $this->getRequest()->getParam('page');

		// insert the split function here.....and get the product Id
		if(strrpos($contentUrl, "/")){
			$contentStartIndex = strrpos($contentUrl, "/")+1; 	 
		}else{
			$contentStartIndex=0;
		}
		$contentEndIndex = strpos($contentUrl, ".html"); 	
		$contentEndIndex = $contentEndIndex - $contentStartIndex; 
		$this->_templateUrl = trim(urldecode(substr($contentUrl,$contentStartIndex,$contentEndIndex)));
		return $this->_templateUrl;
    }


}
