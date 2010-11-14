<?php
/**
 * Product controller
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

class Ekkitab_Catalog_ProductController extends Mage_Core_Controller_Front_Action
{
    
    private $_isbn;

	/**
     * Initialize requested product object
     *
     * @return Mage_Catalog_Model_Product
     */
    public function viewAction()
    {
		Mage::getSingleton('core/session')->setCurrentCategoryPath(array('current_category_path'=>''));
        Mage::getSingleton('core/session')->setCurrentQueryText(array('current_query_text'=>''));
		$productUrl  = (String) $this->getRequest()->getParam('book');
		
		//$this->_redirect('ekkitab_catalog/product/show/book/'.$productUrl);
		$this->_forward('show');
    }

    /**
     * Initialize requested product object
     *
     * @return Mage_Catalog_Model_Product
     */
    public function showAction()
    {
		$productUrl  = (String) $this->getRequest()->getParam('book');

		// insert the split function here.....and get the product Id
		if(strrpos($productUrl, "__")){
			$productIdStartIndex = strrpos($productUrl, "__")+2; 	 
		}else{
			$productIdStartIndex=0;
		}
		$productIdEndIndex = strpos($productUrl, ".html"); 	
		$productIdEndIndex = $productIdEndIndex - $productIdStartIndex;  //.html/	
		$productId = trim(urldecode(substr($productUrl,$productIdStartIndex,$productIdEndIndex)));
		if( $productId && $this->isIsbn($productId)){
			//this is isbn.....
			Mage::register('productId', $this->_isbn);
			$this->loadLayout();
			$this->renderLayout();
		}else {
			if (is_null($productId) || $productId =='') {
				$productId  = $this->getRequest()->getParam('id');
			}
			if (!is_numeric($productId)) {
				$this->_forward('noRoute');
			}
			else{
				Mage::register('productId', (int)$productId);
				$this->loadLayout();
				$this->renderLayout();
			}
		}
    }

    public function isIsbn($str)
    {
		$str=trim($str);
		if (preg_match("/^[0-9X\-_]+$/", $str)) {
			$str = preg_replace("/[-_]/", "", $str);
		}
		if(preg_match("/^[0-9X]*$/",$str)){
			if (strlen($str) == 12) {
				$this->_isbn =  '0'.$str;
				return true;
			}else if (strlen($str) == 10) {
				$this->_isbn = $this->isbn10to13($str);
				return true;
			}else if (strlen($str) == 13) {
				$this->_isbn = $str;
				return true;
			}else{
				return false;
			}
		}else {
			return false;
		}
		
    }

	public	function genchksum13($isbn) {
			$isbn = trim($isbn);
			if (strlen($isbn) != 12) {
				return -1;
			}
			$sum = 0;
			for ($i = 0; $i < 12; $i+=2) {
				$sum += ($isbn[$i] * 1);
				$sum += ($isbn[$i+1] * 3);
			}
			$sum = $sum % 10;
			$sum = 10 - $sum;
			return ($sum == 10 ? 0 : $sum);
		}

	public	function isbn10to13($isbn10) {
			$isbn13 = "";
			$isbn13 = substr("978" . $isbn10, 0, -1);
			$chksum =  $this->genchksum13($isbn13);
			$isbn13 = $isbn13.$chksum;
			return ($isbn13);
		}
}
