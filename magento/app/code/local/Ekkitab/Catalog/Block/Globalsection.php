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


    private $_homeSection =null;

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
	
    public function _prepareLayout()
    {
		//$this->setDefaultTemplate('catalog/globalsection/home_page.phtml');
		if(is_null($this->_homeSection)){
           $this->_homeSection = $this->getHomePageSection(true,1);
		}

		if($this->_homeSection && $this->_homeSection->getId() && trim($this->_homeSection->getHomepageTemplatePath())!="" ){
		   $this->setTemplate($this->_homeSection->getHomepageTemplatePath());
        }
		//else {
		//   $this->setTemplate($this->getTemplate());
       // }
    }

	/**
     * Get popular catagories of current store
     *
     */
    public function getHomePageSection($randomize=true,$count=1)
    {
		$sectionArr;
		if(is_null($this->_homeSection)){
			$sections = Mage::getModel('ekkitab_catalog/globalsection')->getCollection()
									->addHomePageFilter();
			if(!is_null($sections)){
				foreach($sections as $section){
					$sectionArr[]=$section;
				}
					
				if(shuffle($sectionArr)){
					$this->_homeSection=$sectionArr[0];
				}
			}
		}
		return $this->_homeSection;
	}
	

}
