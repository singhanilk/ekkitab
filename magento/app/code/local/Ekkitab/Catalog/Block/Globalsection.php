<?php
/**
 * 
 * Frontend Global Sections block
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
class Ekkitab_Catalog_Block_Globalsection extends Mage_Core_Block_Template
{


	/**
     * Get popular catagories of current store
     *
     */
    public function getAllItems()
    {
		$sections = Mage::getModel('ekkitab_catalog/globalsection')->getCollection()
			->addActiveDateFilter();
		return $sections;
	}
	
	/**
     * Get popular catagories of current store
     *
     */
    public function getHomePageSections()
    {
		$sections = Mage::getModel('ekkitab_catalog/globalsection')->getCollection()
			->addHomePageFilter();
		return $sections;
	}
	

}