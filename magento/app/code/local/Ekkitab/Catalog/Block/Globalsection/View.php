<?php
/**
 * 
 * Frontend  block
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
class Ekkitab_Catalog_Block_Globalsection_View extends Mage_Core_Block_Template
{

    private $_globalsection;

    public function chooseTemplate()
    {
		if(is_null($this->_globalsection)){
           $this->_globalsection = $this->getGlobalsection();
		}
		if($this->_globalsection && $this->_globalsection->getId() && strlen($this->_globalsection->getTemplatePath()) > 0 ){
		   $this->setTemplate($this->_globalsection->getTemplatePath());
        }
		else {
		   $this->setTemplate($this->getDefaultTemplate());
        }
    }

	/**
     * Get popular of current store
     *
     */
    public function getGlobalsection()
    {
		if(is_null($this->_globalsection)){
			if (!Mage::registry('sectionId')) {
				Mage::register('sectionId', Mage::helper('ekkitab_catalog/globalsection')->getSectionId());
			}
			$this->_globalsection = Mage::getModel('ekkitab_catalog/globalsection')->load(Mage::registry('sectionId'));
		}
		return $this->_globalsection;
	}


}
