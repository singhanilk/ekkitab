<?php
/**
 * Review helper
 *
 * @category   Ekkitab
 * @package    Ekkitab_Review
 * @author      Ekkitab Core Team <anisha@ekkitab.com>
 */
class Ekkitab_Review_Block_Helper extends Mage_Review_Block_Helper
{
   
	public function getReviewsUrl()
	{
	    return Mage::getUrl('ekkitab_review/product/list', array(
	       'id'        => $this->getProduct()->getId(),
	       'category'  => $this->getProduct()->getCategoryId()
	    ));
	}
}