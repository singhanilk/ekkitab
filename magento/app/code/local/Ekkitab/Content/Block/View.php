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
class Ekkitab_Content_Block_View extends Mage_Core_Block_Template
{
   
    private $templatePrefix='content/';
    private $templateSuffix='.phtml';

	public function chooseTemplate()
    {
		Mage::log("Here in content Block.................");
		if (!Mage::registry('template_url')) {
			Mage::register('template_url', Mage::helper('ekkitab_content')->getTemplateUrl());
		}
		if (Mage::registry('template_url') && Mage::registry('template_url')!='' ) {
			Mage::log("Here in content Block.................template is ".$this->templatePrefix.trim(Mage::registry('template_url')).$this->templateSuffix);
			$this->setTemplate($this->templatePrefix.trim(Mage::registry('template_url')).$this->templateSuffix);
		}
		else {
		   $this->setTemplate($this->templatePrefix.$this->getDefaultTemplate());
        }
		Mage::log("Here in content Block.................template is ".$this->getTemplate());
    }

}
