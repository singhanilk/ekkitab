<?php

/**
 * Recent Customer Reviews Block
 *
 * @category   Ekkitab
 * @package    Ekkitab_Review
 * @author     Ekkitab Core Team <anisha@ekkitab.com>
 */

class Ekkitab_Review_Block_Customer_Recent extends Mage_Review_Block_Customer_Recent
{
    public function __construct()
    {
        parent::__construct();
        $this->setTemplate('review/customer/list.phtml');

        $this->_collection = Mage::getModel('ekkitab_review/review')->getProductCollection();

        $this->_collection
            ->addStoreFilter(Mage::app()->getStore()->getId())
            ->addCustomerFilter(Mage::getSingleton('customer/session')->getCustomerId())
            ->setDateOrder()
            ->setPageSize(5)
            ->load()
            ->addReviewSummary();
    }

    public function getReviewLink()
    {
        return Mage::getUrl('ekkitab_review/customer/view/');
    }

    public function getProductLink()
    {
        return Mage::getUrl('ekkitab_catalog/product/view/');
    }

    public function getAllReviewsUrl()
    {
        return Mage::getUrl('ekkitab_review/customer');
    }

    public function getReviewUrl($id)
    {
        return Mage::getUrl('ekkitab_review/customer/view', array('id' => $id));
    }
}