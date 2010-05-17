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
class Ekkitab_Catalog_Block_Leftlinks_View extends Mage_Core_Block_Template
{

    private $_link;
    private $_relatedBooks;
    private $_templatePath;

    public function chooseTemplate()
    {
		$this->_templatePath = Mage::registry('templatePath');
		$this->_link =Mage::registry('link');
		
		if(!is_null($this->_templatePath) && strlen(trim($this->_templatePath)) > 0 ){
			$this->setTemplate($this->_templatePath);
		}
		else {
		   $this->setTemplate($this->getDefaultTemplate());
        }
    }

    public function getLinkDetails()
    {
		if(is_null($this->_link) ){
			$this->_link = Mage::registry('link');
		}
		return $this->_link;
    }

    public function getLinkBooks()
    {
		$productIsbns = Mage::registry('related_book_ids');
		if(!is_null($productIsbns) && is_array($productIsbns) && count($productIsbns) > 0 ){
			$condition = array('in'=>$productIsbns);
			$this->_relatedBooks = Mage::getModel('ekkitab_catalog/product')->getCollection()
									->addFieldToFilter('main_table.isbn',$condition);
		}
		return $this->_relatedBooks;
	}


}
