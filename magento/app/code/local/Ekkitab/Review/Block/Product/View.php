<?php

/**
 * Product Reviews Page
 *
 * @category   Ekkitab
 * @package    Ekkitab_Review
 * @author     Ekkitab Core Team <anisha@ekkitab.com>
 */
class Ekkitab_Review_Block_Product_View extends Ekkitab_Catalog_Block_Product_View
{
    protected $_reviewsCollection;

    protected function _toHtml()
    {
        $this->getProduct()->setShortDescription(null);

        return parent::_toHtml();
    }

    public function getReviewsCollection()
    {
        if (null === $this->_reviewsCollection) {
			$this->_reviewsCollection = Mage::getModel('ekkitab_review/review')->getCollection()
                ->addStoreFilter(Mage::app()->getStore()->getId())
                ->addStatusFilter('approved')
				->addEntityIsbnFilter('product', $this->getProduct()->getIsbn())
                ->setDateOrder();
        }
        return $this->_reviewsCollection;
    }

    /**
     * Force product view page behave like without options
     *
     * @return false
     */
    public function hasOptions()
    {
        return false;
    }
}