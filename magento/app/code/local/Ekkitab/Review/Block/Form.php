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


    public function getProductInfo()
    {
		$productUrl  = (String) $this->getRequest()->getParam('book');

		$productIdStartIndex = strrpos($productUrl, "__")+2; 	  
		$productIdEndIndex = strpos($productUrl, ".html"); 	
		$productIdEndIndex = $productIdEndIndex - $productIdStartIndex;  //.html/	
		$productId = trim(urldecode(substr($productUrl,$productIdStartIndex,$productIdEndIndex)));

		if( $productId && $this->isIsbn($productId)){
			//this is isbn.....
			$product = Mage::getModel('ekkitab_catalog/product')
				->setStoreId(Mage::app()->getStore()->getId())
				->load($productId,'isbn');
		}else {
			$productId = (int) $productId;
			if (!$productId || $productId <= 0) {
				$productId  = (int) $this->getRequest()->getParam('id');
			}
			if (!$productId || $productId <= 0) {
				 return false;
			}
			else{
				$product = Mage::getModel('ekkitab_catalog/product')
					->setStoreId(Mage::app()->getStore()->getId())
					->load($productId);
			}
		}
		return $product;
    }

	/**
     * Retrieve search result count
     *
     * @return boolean
     */
    public function isIsbn($str)
    {
		$str=trim($str);
		if(preg_match("/^[0-9]*$/",$str)){
			if (strlen($str) == 12 || strlen($str) == 10 || strlen($str) == 13) {
				return true;
			}else{
				return false;
			}
		}else{
			return false;
		}
		
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
