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
    public function getAllItems($randomize=true,$count=0)
    {
		$sections = Mage::getModel('ekkitab_catalog/globalsection')->getCollection()
			->addActiveDateFilter()
			->setLimit($count)
			->setRandomOrder($randomize);
		return $sections;
	}
	
	/**
     * Get popular catagories of current store
     *
     */
    public function isHomeDisplayAllowed($sectionId)
    {
		if($sectionId > 0 ){
			$section =  Mage::getModel('ekkitab_catalog/globalsection')->load($sectionId);
			if($section && $section->getId() > 0 ){
				return $section->getIsHomepageDisplay();
			}else { 
				return false;
			}
		}else { 
			return false;
		}
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
		if(is_null($this->_homeSection)){
			$sectionId =-1;
			$sectionArr = Mage::getSingleton('core/session')->getHomePageGlobalSection();
			if(is_array($sectionArr) && count($sectionArr) > 0 ){
				$sectionId	= $sectionArr['section_id'];
			}

			if(!is_null($sectionId) && $sectionId > 0 && $this->isHomeDisplayAllowed($sectionId)   ){
				$this->_homeSection= Mage::getModel('ekkitab_catalog/globalsection')->load($sectionId);

				//hardcoding this to independence day section for now.... 
			//	$this->_homeSection= Mage::getModel('ekkitab_catalog/globalsection')->load(6);
			} 
			else{
				$sections = Mage::getModel('ekkitab_catalog/globalsection')->getCollection()
										->addHomePageFilter();
				if(!is_null($sections)){
					foreach($sections as $section){
						$sectionArr[]=$section;
					}
						
					if(!is_null($sectionArr) && shuffle($sectionArr)){
						$this->_homeSection=$sectionArr[0];
						if(!is_null($this->_homeSection) && $this->_homeSection->getId()>0){
							Mage::getSingleton('core/session')->setHomePageGlobalSection(array('section_id'=>$this->_homeSection->getId()));
						}else{
							$this->_homeSection= Mage::getModel('ekkitab_catalog/globalsection')->load(1);
						}
					}
				}else{
					$this->_homeSection= Mage::getModel('ekkitab_catalog/globalsection')->load(1);
				}
			}
			if(is_null($this->_homeSection)){
					$this->_homeSection= Mage::getModel('ekkitab_catalog/globalsection')->load(1);
			}
		}
		return $this->_homeSection;
	}
	

}
