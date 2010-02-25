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
        $product = Mage::getModel('ekkitab_catalog/product');
		$productUrl  = (String) $this->getRequest()->getParam('book');

		$productIdStartIndex = strrpos($productUrl, "__")+2; 	  
		$productIdEndIndex = strpos($productUrl, ".html"); 	
		$productIdEndIndex = $productIdEndIndex - $productIdStartIndex;  //.html/	
		$productId = (int) substr($productUrl,$productIdStartIndex,$productIdEndIndex);

        return $product->load($productId);
    }

    public function getAction()
    {
		$productUrl  = (String) Mage::app()->getRequest()->getParam('book');

		$productIdStartIndex = strrpos($productUrl, "__")+2; 	  
		$productIdEndIndex = strpos($productUrl, ".html"); 	
		$productIdEndIndex = $productIdEndIndex - $productIdStartIndex;  //.html/	
		$productId = (int) substr($productUrl,$productIdStartIndex,$productIdEndIndex);
        return Mage::getUrl('ekkitab_review/product/post', array('id' => $productId));
    }

}
