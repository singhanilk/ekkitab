<?php
/**
 * Magento
 *
 * NOTICE OF LICENSE
 *
 * This source file is subject to the Open Software License (OSL 3.0)
 * that is bundled with this package in the file LICENSE.txt.
 * It is also available through the world-wide-web at this URL:
 * http://opensource.org/licenses/osl-3.0.php
 * If you did not receive a copy of the license and are unable to
 * obtain it through the world-wide-web, please send an email
 * to license@magentocommerce.com so we can send you a copy immediately.
 *
 * DISCLAIMER
 *
 * Do not edit or add to this file if you wish to upgrade Magento to newer
 * versions in the future. If you wish to customize Magento for your
 * needs please refer to http://www.magentocommerce.com for more information.
 *
 * @category   Mage
 * @package    Mage_Checkout
 * @copyright  Copyright (c) 2008 Irubin Consulting Inc. DBA Varien (http://www.varien.com)
 * @license    http://opensource.org/licenses/osl-3.0.php  Open Software License (OSL 3.0)
 */

/**
 * Multishipping cart link
 *
 * @category   Mage
 * @package    Mage_Checkout
 * @author      Magento Core Team <core@magentocommerce.com>
 */
class Mage_Checkout_Block_Multishipping_Link extends Mage_Core_Block_Template
{
    public function getCheckoutUrl()
    {
        return $this->getUrl('checkout/multishipping', array('_secure'=>true));
    }

    public function getQuote()
    {
        return Mage::getSingleton('checkout/session')->getQuote();
    }

    public function _toHtml()
    {
        if (!Mage::helper('checkout')->isMultishippingCheckoutAvailable()){
            return '';
        }

        return parent::_toHtml();
    }

	public function hasMultipleAddressDelivery()
    {
        $quote = $this->getQuote();
		if($quote->hasDonationItems()){
			$donationItems = $quote->getAllDonationItems();
			if(sizeof($quote->getAllItems()) == sizeof($donationItems) ){
				$orgId = 0;
				foreach ($donationItems as $item){
					if(!($orgId==0 || $orgId==$item->getOrganizationId())){
						return true;
					}
					$orgId = $item->getOrganizationId();
				}
				return false;
			}else{
				return true;
			}
		}else{
			return false;
		}
    }

}
