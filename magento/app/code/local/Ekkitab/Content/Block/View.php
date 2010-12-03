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
		if (!Mage::registry('template_url')) {
			Mage::register('template_url', Mage::helper('ekkitab_content')->getTemplateUrl());
		}
		if (Mage::registry('template_url') && Mage::registry('template_url')!='' ) {
			$this->setTemplate($this->templatePrefix.trim(Mage::registry('template_url')).$this->templateSuffix);
		}
		else {
		   $this->setTemplate($this->templatePrefix.$this->getDefaultTemplate());
        }
    }

	public function chooseOverleafTemplate()
    {
		if (!Mage::registry('template_url')) {
			Mage::register('template_url', Mage::helper('ekkitab_content')->getOverleafTemplateUrl());
		}
		if (Mage::registry('template_url') && Mage::registry('template_url')!='' ) {
			$this->setTemplate($this->templatePrefix.trim(Mage::registry('template_url')).$this->templateSuffix);
		}
		else {
		   $this->setTemplate($this->templatePrefix.$this->getDefaultTemplate());
        }
    }

	public function getHashedPath($isbn) {
		$sum = 0;
		for ($i = 0; $i<(strlen($isbn)); $i++)  {
			$sum += substr($isbn,$i,$i+1) + 0;
		}
		return ("I" . $sum%100 . "/" . "J" . substr($isbn,strlen($isbn)-2,2) . "/" . $isbn.".jpg");
	}

	public function getProductUrl($bookUrl)
	{
		$urlPrefix='book/';
		$bookUrl = urlencode(preg_replace('#[^A-Za-z0-9\_]+#', '-', $bookUrl));
		//this is to remove '-' from end of title string if any
		if(substr($bookUrl,-1,1)=='-'){
			$url = substr($bookUrl,0,-1);
		}
		
		$url=strtolower($urlPrefix.$bookUrl.".html");
		return $url;
	}

	public function getSearchUrl($fileName)
	{
		$urlPrefix="books/";
		$url=$urlPrefix.$fileName.".html";
		return $url;
	}

	public function getThisPagetUrl($fileName='')
	{
		$urlPrefix='book-article/';
		if($fileName!=''){
			$url=$urlPrefix.$fileName.".html";
		}else{
			$url=$urlPrefix.Mage::registry('template_url').".html";
		}
		return $url;
	}



}
