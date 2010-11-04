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
 * One page checkout status
 *
 * @author      Magento Core Team <core@magentocommerce.com>
 */
class Mage_Checkout_Block_Onepage_Shipping extends Mage_Checkout_Block_Onepage_Abstract
{
    protected function _construct()
    {
        $this->getCheckout()->setStepData('shipping', array(
            'label'     => Mage::helper('checkout')->__('Shipping Information'),
            'is_show'   => $this->isShow()
        ));

        parent::_construct();
    }

    public function getMethod()
    {
        return $this->getQuote()->getCheckoutMethod();
    }

    public function getOrganizationAddressHtml($type)
    {
		$quoteId =$this->getQuote()->getId();
	 
		$donationItems = Mage::getModel('sales/quote_item')->getCollection()
			 ->setQuote($this->getQuote())
			 ->setIsDonationFilter();
		
		$instituteIds = array() ;
		foreach ($donationItems as $item) {
			$instituteIds[] = $item->getOrganizationId();
		}
		
		if($instituteIds && count($instituteIds) > 0 ){
			$institutes = Mage::getModel('ekkitab_institute/institute')->getCollection()
			 ->addIdFilter($instituteIds);
			
			$instituteEmailIds = array() ;
			foreach ($institutes as $org) {
				$instituteEmailIds[] = $org->getEmail();
			}
			if($instituteEmailIds && count($instituteEmailIds) > 0 ){
				foreach ($instituteEmailIds as $email) {
					$customer = Mage::getModel('customer/customer')
						->setStore(Mage::app()->getStore())
						->loadByEmail($email);
					$addresses= $customer->getAddresses();
					if($addresses){
						foreach ($addresses as $address) {
							$options[] = array(
								'value'=>$address->getId(),
								'label'=>$address->format('oneline')
							);
						}
					}
				}
			}
		}

		if($options && count($options) == 1){
			$addressId = $options[0]['value'];
			$address = $options[0]['label'];
			$outputText = $address.'<input type="hidden" name="'.$type.'_address_id" id="'.$type.'-address-select" value="'.$addressId.'" />';
			return $outputText;

		}else{
			$select = $this->getLayout()->createBlock('core/html_select')
			->setName($type.'_address_id')
			->setId($type.'-address-select')
			->setClass('address-select')
			->setExtraParams('onchange="'.$type.'.newAddress(!this.value)"')
			->setValue($addressId)
			->setOptions($options);
			$select->addOption('', Mage::helper('checkout')->__('New Address'));
			return $select->getHtml();
		}
	}
	
	public function getAddressesHtmlSelect($type)
    {
        if ($this->isCustomerLoggedIn()) {
            $options = array();
          	/* Moving this code down because customer address needs to be loaded only if there are no items to be donated to school.
			foreach ($this->getCustomer()->getAddresses() as $address) {
                $options[] = array(
                    'value'=>$address->getId(),
                    'label'=>$address->format('oneline')
                );
            }
			*/
			$quoteId =$this->getQuote()->getId();
         
			$donationItems = Mage::getModel('sales/quote_item')->getCollection()
				 ->setQuote($this->getQuote())
				 ->setIsDonationFilter();
			
			$instituteIds = array() ;
			foreach ($donationItems as $item) {
				$instituteIds[] = $item->getOrganizationId();
            }
			
			if($instituteIds && count($instituteIds) > 0 ){
				$institutes = Mage::getModel('ekkitab_institute/institute')->getCollection()
				 ->addIdFilter($instituteIds);
				
				$instituteEmailIds = array() ;
				foreach ($institutes as $org) {
					$instituteEmailIds[] = $org->getEmail();
				}
				if($instituteEmailIds && count($instituteEmailIds) > 0 ){
					foreach ($instituteEmailIds as $email) {
						$customer = Mage::getModel('customer/customer')
							->setStore(Mage::app()->getStore())
							->loadByEmail($email);
						$addresses= $customer->getAddresses();
						if($addresses){
							foreach ($addresses as $address) {
								$options[] = array(
									'value'=>$address->getId(),
									'label'=>$address->format('oneline')
								);
							}
						}

					}
				}
			}else{
				  foreach ($this->getCustomer()->getAddresses() as $address) {
					$options[] = array(
						'value'=>$address->getId(),
						'label'=>$address->format('oneline')
					);
				}
			}
			$addressId = $this->getAddress()->getId();
            if (empty($addressId)) {
                if ($type=='billing') {
                    $address = $this->getCustomer()->getPrimaryBillingAddress();
                } else {
                    $address = $this->getCustomer()->getPrimaryShippingAddress();
                }
                if ($address) {
                    $addressId = $address->getId();
                }
            }

            $select = $this->getLayout()->createBlock('core/html_select')
                ->setName($type.'_address_id')
                ->setId($type.'-address-select')
                ->setClass('address-select')
                ->setExtraParams('onchange="'.$type.'.newAddress(!this.value)"')
                ->setValue($addressId)
                ->setOptions($options);

            $select->addOption('', Mage::helper('checkout')->__('New Address'));

            return $select->getHtml();
        }
        return '';
    }


    public function getAddress()
    {
        if (!$this->isCustomerLoggedIn()) {
            return $this->getQuote()->getShippingAddress();
        } else {
            return Mage::getModel('sales/quote_address');
        }
    }

    /**
     * Retrieve is allow and show block
     *
     * @return bool
     */
    public function isShow()
    {
        return !$this->getQuote()->isVirtual();
    }
    /**
     * Retrieve is allow and show block
     *
     * @return bool
     */
    public function hasDonationItems()
    {
        return $this->getQuote()->hasDonationItems();
    }
}