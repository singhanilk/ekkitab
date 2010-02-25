<?php
/**
 * Customer Reviews list block
 *
 * @category   Ekkitab
 * @package    Ekkitab_Review
 * @author     Ekkitab Core Team <anisha@ekkitab.com>
 */
class Ekkitab_Review_Block_Customer_List extends Mage_Review_Block_Customer_List
{

    protected function _construct()
    {
		$this->_collection = Mage::getModel('ekkitab_review/review')->getCollection();
        $this->_collection
            ->addStoreFilter(Mage::app()->getStore()->getId())
            ->addCustomerFilter(Mage::getSingleton('customer/session')->getCustomerId())
            ->setDateOrder();
    }


    public function getReviewLink()
    {
        return Mage::getUrl('ekkitab_review/customer/view/');
    }

    public function getProductLink()
    {
        return Mage::getUrl('ekkitab_catalog/product/view/');
    }

}