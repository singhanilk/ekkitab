<?php
/**
 * PayPal Standard Checkout Module
 *
 * @category   Local/Ekkitab
 * @package    Ekkitab_Paypal
 * @author Anisha (anisha@ekkitab.com)
 * @version 1.0 Dec 7, 2009
 *
 * 
 * @package    Local_Ekkitab
 * @copyright  COPYRIGHT (C) 2009 Ekkitab Educational Services India Pvt. Ltd.
 * @license    All Rights Reserved. All material contained in this file (including, but not limited to, text, images, graphics, HTML, programming code and scripts) 
 * constitute proprietary and  * confidential information protected by copyright laws, trade secret and other laws. No part of this software may be copied, reproduced, modified or 
 * distributed in any form or by any means, or stored in a database or retrieval system without the prior written permission of Ekkitab Educational Services.
 * 
 */


class Ekkitab_Paypal_Model_Standard extends Mage_Paypal_Model_Standard
{
    //added INR so that Paypal comes as an option in the payment methods..... 
	protected $_allowCurrencyCode = array('AUD', 'CAD', 'CZK', 'DKK', 'EUR', 'HKD', 'HUF', 'ILS', 'JPY', 'MXN', 'NOK', 'NZD', 'PLN', 'GBP', 'SGD', 'SEK', 'CHF', 'USD','INR');

public function getStandardCheckoutFormFields()
    {
        if ($this->getQuote()->getIsVirtual()) {
            $a = $this->getQuote()->getBillingAddress();
            $b = $this->getQuote()->getShippingAddress();
        } else {
            $a = $this->getQuote()->getShippingAddress();
            $b = $this->getQuote()->getBillingAddress();
        }
        /*tweak version
          init currency conversion
          if currency is not the same as base currency, set convert boolean to true 
        */
         //getQuoteCurrencyCode
        $currency_code = $this->getQuote()->getBaseCurrencyCode();
        //we validate currency before sending paypal so following code is obsolete
		//Mage::log("In getStandardCheckoutFormFields... currency_code >> $currency_code");
		
		//Anisha: Removed the comments in the following block from the core module...
		//... so that the amount can be converted to USD before sending it to the paypal site..

		//if currency code is INR ( since INR is the only currency added in the alloCurrencyCode and not allowed by Paypal) , convert INR to UDS and use USD as default
		//Mage::log("In getStandardCheckoutFormFields... currency_code >> $currency_code");
        if ($currency_code=='INR') {
            $storeCurrency = Mage::getSingleton('directory/currency')
                ->load($this->getQuote()->getStoreCurrencyCode());
				//Mage::log("In getStandardCheckoutFormFields... storeCurrency >> $storeCurrency");
            $currency_code='USD';
        }
		$bConvert = $currency_code != $this->getQuote()->getBaseCurrencyCode();
		//Mage::log("In getStandardCheckoutFormFields... bConvert >> $bConvert");
 
        $sArr = array(
            'charset'           => self::DATA_CHARSET,
            'business'          => Mage::getStoreConfig('paypal/wps/business_account'),
            'return'            => Mage::getUrl('paypal/standard/success',array('_secure' => true)),
            'cancel_return'     => Mage::getUrl('paypal/standard/cancel',array('_secure' => false)),
            'notify_url'        => Mage::getUrl('paypal/standard/ipn'),
            'invoice'           => $this->getCheckout()->getLastRealOrderId(),
            'currency_code'     => $currency_code,
            'address_override'  => 0, // overriding this property to 0 from 1 
            'first_name'        => $a->getFirstname(),
            'last_name'         => $a->getLastname(),
            'address1'          => $a->getStreet(1),
            'address2'          => $a->getStreet(2),
            'city'              => $a->getCity(),
            'state'             => $a->getRegionCode(),
            'country'           => $a->getCountry(),
            'zip'               => $a->getPostcode(),
            'bn'                => 'Varien_Cart_WPS_US'
        );
 
        $logoUrl = Mage::getStoreConfig('paypal/wps/logo_url');
        if($logoUrl){
             $sArr = array_merge($sArr, array(
                  'cpp_header_image' => $logoUrl
             ));
        }
 
        if($this->getConfigData('payment_action')==self::PAYMENT_TYPE_AUTH){
             $sArr = array_merge($sArr, array(
                  'paymentaction' => 'authorization'
             ));
        }
 
        $transaciton_type = $this->getConfigData('transaction_type');
        /*
        O=aggregate cart amount to paypal
        I=individual items to paypal
        */
        if ($transaciton_type=='O') {
            $businessName = Mage::getStoreConfig('paypal/wps/business_name');
            $storeName = Mage::getStoreConfig('store/system/name');
            $amount = ($a->getBaseSubtotal()+$b->getBaseSubtotal())-($a->getBaseDiscountAmount()+$b->getBaseDiscountAmount());
            //convert the amount to the current currency
            if ($bConvert) {
                $amount = $storeCurrency->convert($amount, $currency_code);
            }
			//Mage::log("In getStandardCheckoutFormFields... amount >> $amount");

            $sArr = array_merge($sArr, array(
                    'cmd'           => '_ext-enter',
                    'redirect_cmd'  => '_xclick',
                    'item_name'     => $businessName ? $businessName : $storeName,
                    'amount'        => sprintf('%.2f', $amount),
                ));
            $_shippingTax = $this->getQuote()->getShippingAddress()->getBaseTaxAmount();
            $_billingTax = $this->getQuote()->getBillingAddress()->getBaseTaxAmount();
            $tax = $_shippingTax + $_billingTax;
            //convert the amount to the current currency
            if ($bConvert) {
                $tax = $storeCurrency->convert($tax, $currency_code);
            }
			//Mage::log("In getStandardCheckoutFormFields... tax >> $tax");
            $tax = sprintf('%.2f', $tax);
            if ($tax>0) {
                  $sArr = array_merge($sArr, array(
                        'tax' => $tax
                  ));
            }
 
        } else {
            $sArr = array_merge($sArr, array(
                'cmd'       => '_cart',
                'upload'       => '1',
            ));
            $items = $this->getQuote()->getAllItems();
            if ($items) {
                $i = 1;
                foreach($items as $item){
                    if ($item->getParentItem()) {
                        continue;
                    }
                    //echo "<pre>"; print_r($item->getData()); echo"</pre>";
                    $amount = ($item->getBaseCalculationPrice() - $item->getBaseDiscountAmount());
                    if ($bConvert) {
                        $amount = $storeCurrency->convert($amount, $currency_code);
                    }
					//Mage::log("In getStandardCheckoutFormFields... amount >> $amount");
                    
					$sArr = array_merge($sArr, array(
                        'item_name_'.$i      => $item->getName(),
                        'item_number_'.$i      => $item->getSku(),
                        'quantity_'.$i      => $item->getQty(),
                        'amount_'.$i      => sprintf('%.2f', $amount),
                    ));
                    $tax = $item->getBaseTaxAmount();
                    if($tax>0){
                        //convert the amount to the current currency
                        if ($bConvert) {
                            $tax = $storeCurrency->convert($tax, $currency_code);
                        }
						Mage::log("In getStandardCheckoutFormFields... tax >> $tax");
                        $sArr = array_merge($sArr, array(
                        'tax_'.$i      => sprintf('%.2f',$tax/$item->getQty()),
                        ));
                    }
                    $i++;
                }
           }
        }
 
        $totalArr = $a->getTotals();
        $shipping = $this->getQuote()->getShippingAddress()->getBaseShippingAmount();
        if ($shipping>0 && !$this->getQuote()->getIsVirtual()) {
          //convert the amount to the current currency
          if ($bConvert) {
              $shipping = $storeCurrency->convert($shipping, $currency_code);
          }
          $shipping = sprintf('%.2f', $shipping);
         
          if ($transaciton_type=='O') {
              $sArr = array_merge($sArr, array(
                    'shipping' => $shipping
              ));
          } else {
              $shippingTax = $this->getQuote()->getShippingAddress()->getBaseShippingTaxAmount();
              //convert the amount to the current currency
              if ($bConvert) {
                  $shippingTax = $storeCurrency->convert($shippingTax, $currency_code);
              }
              $sArr = array_merge($sArr, array(
                    'item_name_'.$i   => $totalArr['shipping']->getTitle(),
                    'quantity_'.$i    => 1,
                    'amount_'.$i      => sprintf('%.2f',$shipping),
                    'tax_'.$i         => sprintf('%.2f',$shippingTax),
              ));
              $i++;
          }
        }
 
        $sReq = '';
        $sReqDebug = '';
        $rArr = array();
 
 
        foreach ($sArr as $k=>$v) {
            /*
            replacing & char with and. otherwise it will break the post
            */
            $value =  str_replace("&","and",$v);
            $rArr[$k] =  $value;
            $sReq .= '&'.$k.'='.$value;
            $sReqDebug .= '&'.$k.'=';
            if (in_array($k, $this->_debugReplacePrivateDataKeys)) {
                $sReqDebug .= '***';
            } else  {
                $sReqDebug .= $value;
            }
           
        }
 
        if ($this->getDebug() && $sReq) {
            $sReq = substr($sReq, 1);
            $debug = Mage::getModel('paypal/api_debug')
                    ->setApiEndpoint($this->getPaypalUrl())
                    ->setRequestBody($sReq)
                    ->save();
        }
        return $rArr;
    }
	
	/*public function getStandardCheckoutFormFields()
    {
        if ($this->getQuote()->getIsVirtual()) {
            $a = $this->getQuote()->getBillingAddress();
            $b = $this->getQuote()->getShippingAddress();
        } else {
            $a = $this->getQuote()->getShippingAddress();
            $b = $this->getQuote()->getBillingAddress();
        }
        //getQuoteCurrencyCode
        $currency_code = $this->getQuote()->getBaseCurrencyCode();
        //we validate currency before sending paypal so following code is obsolete
        Mage::log("In getStandardCheckoutFormFields... Paypal........." );
		
		//Anisha: Removed the comments in the following block from the core module...
		//... so that the amount can be converted to USD before sending it to the paypal site..

		//if currency code is INR ( since INR is the only currency added in the alloCurrencyCode and not allowed by Paypal) , convert INR to UDS and use USD as default
		Mage::log("In getStandardCheckoutFormFields... currency_code >> $currency_code");
        if ($currency_code=='INR') {
            $storeCurrency = Mage::getSingleton('directory/currency')
                ->load($this->getQuote()->getStoreCurrencyCode());
			Mage::log("In getStandardCheckoutFormFields... getCurrencyCode >> ".$storeCurrency->getCurrencyCode() );
			//Mage::log("In getStandardCheckoutFormFields... Amount before conversion >> $amount");
           // $amount = $storeCurrency->convert($amount, 'USD');
			//Mage::log("In getStandardCheckoutFormFields... Amount after conversion >> $amount");
            $currency_code='USD';
        }

        $sArr = array(
            'charset'           => self::DATA_CHARSET,
            'business'          => Mage::getStoreConfig('paypal/wps/business_account'),
            'return'            => Mage::getUrl('paypal/standard/success',array('_secure' => true)),
            'cancel_return'     => Mage::getUrl('paypal/standard/cancel',array('_secure' => false)),
            'notify_url'        => Mage::getUrl('paypal/standard/ipn'),
            'invoice'           => $this->getCheckout()->getLastRealOrderId(),
            'currency_code'     => $currency_code,
            'address_override'  => 0, // overriding this property to 0 from 1 
            'first_name'        => $a->getFirstname(),
            'last_name'         => $a->getLastname(),
            'address1'          => $a->getStreet(1),
            'address2'          => $a->getStreet(2),
            'city'              => $a->getCity(),
            'state'             => $a->getRegionCode(),
            'country'           => $a->getCountry(),
            'zip'               => $a->getPostcode(),
            'bn'                => 'Varien_Cart_WPS_US'
        );

        $logoUrl = Mage::getStoreConfig('paypal/wps/logo_url');
        if($logoUrl){
             $sArr = array_merge($sArr, array(
                  'cpp_header_image' => $logoUrl
             ));
        }

        if($this->getConfigData('payment_action')==self::PAYMENT_TYPE_AUTH){
             $sArr = array_merge($sArr, array(
                  'paymentaction' => 'authorization'
             ));
        }

        $transaciton_type = $this->getConfigData('transaction_type');
        
        //O=aggregate cart amount to paypal
        // I=individual items to paypal
       
        if ($transaciton_type=='O') {
            $businessName = Mage::getStoreConfig('paypal/wps/business_name');
            $storeName = Mage::getStoreConfig('store/system/name');
            $amount = ($a->getBaseSubtotal()+$b->getBaseSubtotal())-($a->getBaseDiscountAmount()+$b->getBaseDiscountAmount());
			
			//Anisha: added this code to convert amount from INR to USD
			Mage::log("In getStandardCheckoutFormFields... Amount before conversion >> $amount");
            $amount = $storeCurrency->convert($amount, 'USD');
			Mage::log("In getStandardCheckoutFormFields... Amount after conversion >> $amount");
            //
			$sArr = array_merge($sArr, array(
                    'cmd'           => '_ext-enter',
                    'redirect_cmd'  => '_xclick',
                    'item_name'     => $businessName ? $businessName : $storeName,
                    'amount'        => sprintf('%.2f', $amount),
                ));
            $_shippingTax = $this->getQuote()->getShippingAddress()->getBaseTaxAmount();
			Mage::log("In getStandardCheckoutFormFields...  _shippingTax >> $_shippingTax");
            $_billingTax = $this->getQuote()->getBillingAddress()->getBaseTaxAmount();
			Mage::log("In getStandardCheckoutFormFields...  _billingTax >> $_billingTax");
            $tax = sprintf('%.2f', $_shippingTax + $_billingTax);
			Mage::log("In getStandardCheckoutFormFields...  tax >> $tax");
            if ($tax>0) {
                  $sArr = array_merge($sArr, array(
                        'tax' => $tax
                  ));
            }

        } else {
            $sArr = array_merge($sArr, array(
                'cmd'       => '_cart',
                'upload'       => '1',
            ));
            $items = $this->getQuote()->getAllItems();
            if ($items) {
                $i = 1;
                foreach($items as $item){
                    if ($item->getParentItem()) {
                        continue;
                    }
                    //echo "<pre>"; print_r($item->getData()); echo"</pre>";
					$amount =sprintf('%.2f', ($item->getBaseCalculationPrice() - $item->getBaseDiscountAmount()));
                    
					//Anisha: added this code to convert amount from INR to USD
					Mage::log("In getStandardCheckoutFormFields... Amount before conversion >> $amount");
					$amount = $storeCurrency->convert($amount, 'USD');
					Mage::log("In getStandardCheckoutFormFields... Amount after conversion >> $amount");
					//
					$sArr = array_merge($sArr, array(
                        'item_name_'.$i      => $item->getName(),
                        'item_number_'.$i      => $item->getSku(),
                        'quantity_'.$i      => $item->getQty(),
                        'amount_'.$i      => $amount,
                    ));
                   
					Mage::log("In getStandardCheckoutFormFields...  item->getBaseTaxAmount() >>".$item->getBaseTaxAmount());
					Mage::log("In getStandardCheckoutFormFields...  item->getQty() >>".$item->getQty());
					Mage::log("In getStandardCheckoutFormFields...  tax >>".sprintf('%.2f',$item->getBaseTaxAmount()/$item->getQty()));
					if($item->getBaseTaxAmount()>0){
                        $sArr = array_merge($sArr, array(
                        'tax_'.$i      => sprintf('%.2f',$item->getBaseTaxAmount()/$item->getQty()),
                        ));
                    }
                    $i++;
                }
           }
        }

        $totalArr = $a->getTotals();
        $shipping = sprintf('%.2f', $this->getQuote()->getShippingAddress()->getBaseShippingAmount());
        if ($shipping>0 && !$this->getQuote()->getIsVirtual()) {
          if ($transaciton_type=='O') {
			Mage::log("In getStandardCheckoutFormFields...  shipping >> $shipping");
              $sArr = array_merge($sArr, array(
                    'shipping' => $shipping
              ));
          } else {
              $shippingTax = $this->getQuote()->getShippingAddress()->getBaseShippingTaxAmount();
			  Mage::log("In getStandardCheckoutFormFields...  shipping >> $shipping");
			  Mage::log("In getStandardCheckoutFormFields...  shippingTax >> $shippingTax");
              $sArr = array_merge($sArr, array(
                    'item_name_'.$i   => $totalArr['shipping']->getTitle(),
                    'quantity_'.$i    => 1,
                    'amount_'.$i      => sprintf('%.2f',$shipping),
                    'tax_'.$i         => sprintf('%.2f',$shippingTax),
              ));
              $i++;
          }
        }

        $sReq = '';
        $sReqDebug = '';
        $rArr = array();


        foreach ($sArr as $k=>$v) {
            
            //replacing & char with and. otherwise it will break the post
            
            $value =  str_replace("&","and",$v);
            $rArr[$k] =  $value;
            $sReq .= '&'.$k.'='.$value;
            $sReqDebug .= '&'.$k.'=';
            if (in_array($k, $this->_debugReplacePrivateDataKeys)) {
                $sReqDebug .= '***';
            } else  {
                $sReqDebug .= $value;
            }
        }

        if ($this->getDebug() && $sReq) {
            $sReq = substr($sReq, 1);
            $debug = Mage::getModel('paypal/api_debug')
                    ->setApiEndpoint($this->getPaypalUrl())
                    ->setRequestBody($sReq)
                    ->save();
        }
        return $rArr;
    }*/

}
