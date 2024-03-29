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

/**
     * Using for multiple shipping address
     *
     * @return bool
     */
    public function canUseForMultishipping()
    {
        return true;
    }
    
    //added INR so that Paypal comes as an option in the payment methods..... 
	protected $_allowCurrencyCode = array('AUD', 'CAD', 'CZK', 'DKK', 'EUR', 'HKD', 'HUF', 'ILS', 'JPY', 'MXN', 'NOK', 'NZD', 'PLN', 'GBP', 'SGD', 'SEK', 'CHF', 'USD','INR');

public function getStandardCheckoutFormFields()
    {
    
//**********Ekkitab******
// Commented these lines and added the next two lines
       /* if ($this->getQuote()->getIsVirtual()) {
            $a = $this->getQuote()->getBillingAddress();
            $b = $this->getQuote()->getShippingAddress();
        } else {
            $a = $this->getQuote()->getShippingAddress();
            $b = $this->getQuote()->getBillingAddress();
        }*/
    
    		$a = $this->getQuote()->getBillingAddress();
            $b = $this->getQuote()->getShippingAddress();
            
//****Ekkitab*****************
    
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
 //           'invoice'           => $this->getCheckout()->getLastRealOrderId(),
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
		
		//************Ekkitab*******************************
		//brought this code outside so can be used globally
		if ($this->getQuote()->getIsMultiShipping()){
			 $Merchant_Param="M" ; 
			  Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."Mage_Checkout_Model_Type_Multishipping\n") ;
		}
		else {
			  $Merchant_Param="S" ; 
			  Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."Mage_Checkout_Model_Type_Onepage\n") ;
		}
   
        /*
        O=aggregate cart amount to paypal
        I=individual items to paypal
        */
        if ($transaciton_type=='O') {
            $businessName = Mage::getStoreConfig('paypal/wps/business_name');
            $storeName = Mage::getStoreConfig('store/system/name');
            
		  //************Ekkitab*******************************
		  // $amount = ($a->getBaseSubtotal()+$b->getBaseSubtotal())-($a->getBaseDiscountAmount()+$b->getBaseDiscountAmount());
  
       		$total_amount = 0 ;
       		$mOrderList = "" ;
				
			if ($Merchant_Param=="S") { // OnestepCheckout Order
				 $Order_Id =  $this->getCheckout()->getLastRealOrderId();  // for single shipment order 
				 $order = Mage::getModel('sales/order');
				 $order->loadByIncrementId($Order_Id);  
				// $total_amount = $order->getGrandTotal();
				 $total_amount = $order->getSubtotal();
				 $mOrderList = $Order_Id ;
				 Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."Single Address Checkout..total amount is :".$total_amount."\n") ;
			} else {  // it is "M" : Multishipping order
				$Order_Ids    =  Mage::getSingleton('core/session')->getOrderIds();   // for mltiple shipment orders
				$Order_Id = end($Order_Ids);
				$j = 0 ;
				foreach( $Order_Ids as $key => $orid) {
							  $order = Mage::getModel('sales/order');
							  $order->loadByIncrementId($orid);  
							  //$total_amount = $total_amount + $order->getGrandTotal() ;
							  $total_amount = $total_amount + $order->getSubtotal() ;
							  If ($j++)
							 	 $mOrderList = $mOrderList."|".$orid ;
							  else
							     $mOrderList = $orid ;						     
//							  $mOrderList = $mOrderList."|".$orid ;
							  
      	  
	  			}

				Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n".print_r($Order_Ids,true)) ;
				Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__." \n".print_r($total_amount,true)) ;
				Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."Multiple Address Checkout..total amount is :".$total_amount."\n") ;
			
			}
			Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__." mOrderList \n".print_r($mOrderList,true)) ;
			$amount = $total_amount ;
	  	
			//***********Ekkitab************************
			//convert the amount to the current currency
            if ($bConvert) {
                 $amount = $storeCurrency->convert($amount, $currency_code);
            }
	  	

            $sArr = array_merge($sArr, array(
                    'cmd'           => '_ext-enter',
                    'redirect_cmd'  => '_xclick',
                    'item_name'     => $businessName ? $businessName : $storeName,
                    'amount'        => sprintf('%.2f', $amount),
                    'invoice'      => $Order_Id,
                    'custom'       => $mOrderList,  // added by aks
                ));
			//***********Ekkitab************************
			//Not altering this code now, because we don;t have tax...
			//but incase tax is applied this needs to be altered to handle multiple shipping and single address shipping

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
			//***********Ekkitab************************
			//Not altering this code now, because we don;t do individual item billing..
			//but incase we choose to do so this needs to be altered to handle multiple shipping and single address shipping

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
       
		//***********Ekkitab************************
		//Code altered to handle multiple shipping...commenting the following line of code..
		//$shipping = $this->getQuote()->getShippingAddress()->getBaseShippingAmount();
		$shipping = 0;
		if ($Merchant_Param=="S") { // OnestepCheckout Order
			 $Order_Id =  $this->getCheckout()->getLastRealOrderId();  // for single shipment order 
			 $order = Mage::getModel('sales/order');
			 $order->loadByIncrementId($Order_Id);  
			 $shipping = $order->getShippingAmount();
			 Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."Single Address Checkout..shipping amount is :".$shipping."\n") ;
		} else {  // it is "M" : Multishipping order
			$Order_Ids    =  Mage::getSingleton('core/session')->getOrderIds();   // for mltiple shipment orders
			$Order_Id = end($Order_Ids);
			foreach( $Order_Ids as $key => $orid) {
				$order = Mage::getModel('sales/order');
				$order->loadByIncrementId($orid);  
				$shipping =$shipping+$order->getShippingAmount();
			}

			Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n".print_r($Order_Ids,true)) ;
			Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__." \n".print_r($total_amount,true)) ;
			Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."Multiple Address Checkout..shipping amount is :".$shipping."\n") ;
		
		}
			

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
			
			//***********Ekkitab************************
			//Not altering this code now, because we don;t do individual item billing..
			//but incase we choose to do so this needs to be altered to handle multiple shipping and single address shipping


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
    
     public function ipnPostSubmit()
    {
    
                
        $sReq = '';
        $sReqDebug = '';
        foreach($this->getIpnFormData() as $k=>$v) {
            $sReq .= '&'.$k.'='.urlencode(stripslashes($v));
            $sReqDebug .= '&'.$k.'=';

        }
        //append ipn commdn
        $sReq .= "&cmd=_notify-validate";
        $sReq = substr($sReq, 1);

        if ($this->getDebug()) {
            $debug = Mage::getModel('paypal/api_debug')
                    ->setApiEndpoint($this->getPaypalUrl())
                    ->setRequestBody($sReq)
                    ->save();
        }
        $http = new Varien_Http_Adapter_Curl();
        $http->write(Zend_Http_Client::POST,$this->getPaypalUrl(), '1.1', array(), $sReq);
        $response = $http->read();
        $response = preg_split('/^\r?$/m', $response, 2);
        $response = trim($response[1]);
        if ($this->getDebug()) {
            $debug->setResponseBody($response)->save();
        }

         //when verified need to convert order into invoice
        $id = $this->getIpnFormData('invoice');   
        $mOrderList = $this->getIpnFormData('custom');
        
        Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__." Invoice: was used in single order situation \n".print_r($mOrderList,true)) ;
 	  	Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__." mOrderList: \n".print_r($mOrderList,true)) ;

 	 
 //       $mordids = array() ;
//       $msg_arr1 = $this->strgetcsv($msg,"|") ; did not work for me, that is why this loop
  /*      
        $i = 0 ; 
    	$tok = strtok($mOrderList,"|");
    	while ($tok != false) {
    	   $mordids[$i++] = $tok ; 
    	   $tok = strtok("|"); 
    	}
   */
        // above was working, but the explode is better than above loop   
    	
    	$mordids = explode ("|", $mOrderList) ;
    	
        
        Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__." PayPal returned Order Ids\n".print_r($mordids,true)) ;
        
        
        
      foreach($mordids as $key => $id ) {
          	                Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n".print_r($id,true)) ;
            
          	                
        
        $order = Mage::getModel('sales/order');
        $order->loadByIncrementId($id);

        if ($response=='VERIFIED') {
            if (!$order->getId()) {
                /*
                * need to have logic when there is no order with the order id from paypal
                */

            } else {
                          //I HAVE CHANGED THIS to ! as the return amount is in dollar whereas the amount stored is in RS
                if (!($this->getIpnFormData('mc_gross')!=$order->getBaseGrandTotal())) {
                    //when grand total does not equal, need to have some logic to take care
                    $order->addStatusToHistory(
                        $order->getStatus(),//continue setting current order status
                        Mage::helper('paypal')->__('Order total amount does not match paypal gross total amount')
                    );
                    $order->save();
                } else {
                    /*
                    //quote id
                    $quote_id = $order->getQuoteId();
                    //the customer close the browser or going back after submitting payment
                    //so the quote is still in session and need to clear the session
                    //and send email
                    if ($this->getQuote() && $this->getQuote()->getId()==$quote_id) {
                        $this->getCheckout()->clear();
                        $order->sendNewOrderEmail();
                    }
                    */

                    // get from config order status to be set
                    $newOrderStatus = $this->getConfigData('order_status', $order->getStoreId());
                    if (empty($newOrderStatus)) {
                        $newOrderStatus = $order->getStatus();
                    }

                    /*
                    if payer_status=verified ==> transaction in sale mode
                    if transactin in sale mode, we need to create an invoice
                    otherwise transaction in authorization mode
                    */
                    if ($this->getIpnFormData('payment_status') == 'Completed') {
                       if (!$order->canInvoice()) {
                           //when order cannot create invoice, need to have some logic to take care
                           $order->addStatusToHistory(
                                $order->getStatus(), // keep order status/state
                                Mage::helper('paypal')->__('Error in creating an invoice', true),
                                $notified = true
                           );

                       } else {
                           //need to save transaction id
                           $order->getPayment()->setTransactionId($this->getIpnFormData('txn_id'));
                           //need to convert from order into invoice
                           $invoice = $order->prepareInvoice();
                           $invoice->register()->pay();
                           Mage::getModel('core/resource_transaction')
                               ->addObject($invoice)
                               ->addObject($invoice->getOrder())
                               ->save();
                           $order->setState(
                               Mage_Sales_Model_Order::STATE_COMPLETE, true,
                               Mage::helper('paypal')->__('Invoice #%s created', $invoice->getIncrementId()),
                               $notified = true
                           );
                       }
                    } else {
                        $order->setState(
                            Mage_Sales_Model_Order::STATE_PROCESSING, $newOrderStatus,
                            Mage::helper('paypal')->__('Received IPN verification'),
                            $notified = true
                        );
                    }

                    $ipnCustomerNotified = true;
                    if (!$order->getPaypalIpnCustomerNotified()) {
                        $ipnCustomerNotified = false;
                        $order->setPaypalIpnCustomerNotified(1);
                    }

                    $order->save();

                    if (!$ipnCustomerNotified) {
                        $order->sendNewOrderEmail();
                    }

                }//else amount the same and there is order obj
                //there are status added to order
            }
        }else{
            /*
            Canceled_Reversal
            Completed
            Denied
            Expired
            Failed
            Pending
            Processed
            Refunded
            Reversed
            Voided
            */
            $payment_status= $this->getIpnFormData('payment_status');
            $comment = $payment_status;
            if ($payment_status == 'Pending') {
                $comment .= ' - ' . $this->getIpnFormData('pending_reason');
            } elseif ( ($payment_status == 'Reversed') || ($payment_status == 'Refunded') ) {
                $comment .= ' - ' . $this->getIpnFormData('reason_code');
            }
            //response error
            if (!$order->getId()) {
                /*
                * need to have logic when there is no order with the order id from paypal
                */
            } else {
                $order->addStatusToHistory(
                    $order->getStatus(),//continue setting current order status
                    Mage::helper('paypal')->__('Paypal IPN Invalid %s.', $comment)
                );
                $order->save();
            }
        }
      } // end of for
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
