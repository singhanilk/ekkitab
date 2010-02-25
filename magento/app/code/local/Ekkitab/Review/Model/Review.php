<?php

/**
 * Review model
 *
 * @category   Ekkitab
 * @package    Ekkitab_Review
 * @author     Ekkitab Core Team <anisha@ekkitab.com>
 */
class Ekkitab_Review_Model_Review extends Mage_Review_Model_Review
{

    public function getProductCollection()
    {
        return Mage::getResourceModel('ekkitab_review/review_product_collection');
    }

    public function getReviewUrl()
    {
        return Mage::getUrl('ekkitab_review/product/view', array('id' => $this->getReviewId()));
    }

}