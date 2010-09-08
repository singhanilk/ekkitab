<?php
/**
 * Review form block
 *
 * @category   Ekkitab
 * @package    Ekkitab_Review
 * @author      Ekkitab Core Team <anisha@ekkitab.com>
 */
class Ekkitab_Review_Block_Form extends Mage_Review_Block_Form
{


    private $_isbn;

	public function getProductInfo()
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
			$product = Mage::getModel('ekkitab_catalog/product')
				->setStoreId(Mage::app()->getStore()->getId())
				->load($productId,'isbn');
		}else {
			if (is_null($productId) || $productId =='') {
				$productId  = $this->getRequest()->getParam('id');
			}
			if (!is_numeric($productId)) {
				 return false;
			}
			else{
				$product = Mage::getModel('ekkitab_catalog/product')
					->setStoreId(Mage::app()->getStore()->getId())
					->load((int)$productId);
			}

		}
		return $product;
    }

    public function isIsbn($str)
    {
		$str=trim($str);
		if (preg_match("/^[0-9\-_]+$/", $str)) {
			$str = preg_replace("/[-_]/", "", $str);
		}
		if(preg_match("/^[0-9]*$/",$str)){
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

	public function getAction()
    {
		$productUrl  = (String) Mage::app()->getRequest()->getParam('book');

		$productIdStartIndex = strrpos($productUrl, "__")+2; 	  
		$productIdEndIndex = strpos($productUrl, ".html"); 	
		$productIdEndIndex = $productIdEndIndex - $productIdStartIndex;  //.html/	
		$productId = trim(urldecode(substr($productUrl,$productIdStartIndex,$productIdEndIndex)));
        return Mage::getUrl('ekkitab_review/product/post', array('id' => $productId));
    }

}
