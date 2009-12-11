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
 * @category   Billdesk
 * @package    Ekkitab_Billdesk
 * @copyright  Copyright (c) 2008 Irubin Consulting Inc. DBA Varien (http://www.varien.com)
 * @license    http://opensource.org/licenses/osl-3.0.php  Open Software License (OSL 3.0)
 */

/**
 *
 * Billdesk Checkout Module
 *
 * @author     Ekkitab
 */
class Ekkitab_Billdesk_Model_Billdesk extends Mage_Payment_Model_Method_Abstract
{
    //changing the payment to different from cc payment type and paypal payment type
    const PAYMENT_TYPE_AUTH = 'AUTHORIZATION';
    const PAYMENT_TYPE_SALE = 'SALE';

    const DATA_CHARSET = 'utf-8';

  //aks  protected $_code  = 'paypal_standard';
  //aks protected $_formBlockType = 'paypal/standard_form';
  //aks   protected $_allowCurrencyCode = array('AUD', 'CAD', 'CZK', 'DKK', 'EUR', 'HKD', 'HUF', 'ILS', 'JPY', 'MXN', 'NOK', 'NZD', 'PLN', 'GBP', 'SGD', 'SEK', 'CHF', 'USD');
    protected $_code  = 'billdesk';
    protected $_formBlockType = 'billdesk/form';
    protected $_allowCurrencyCode = array('INR','USD');
    
    /**
     * Check method for processing with base currency
     *
     * @param string $currencyCode
     * @return boolean
     */
    public function canUseForCurrency($currencyCode)
    {
       /*aks  if (!in_array($currencyCode, $this->_allowCurrencyCode)) {
            return false;
        }*/
        return true;
    }

    /**
     * Fields that should be replaced in debug with '***'
     *
     * @var array
     */
    protected $_debugReplacePrivateDataKeys = array('business');

     /**
     * Get paypal session namespace
     *
     * @return Mage_Paypal_Model_Session
     */
    public function getSession()
    {
        return Mage::getSingleton('billdesk/session');
    }

    /**
     * Get checkout session namespace
     *
     * @return Mage_Checkout_Model_Session
     */
    public function getCheckout()
    {
        return Mage::getSingleton('checkout/session');
    }

    /**
     * Get current quote
     *
     * @return Mage_Sales_Model_Quote
     */
    public function getQuote()
    {
        return $this->getCheckout()->getQuote();
    }

    /**
     * Using internal pages for input payment data
     *
     * @return bool
     */
    public function canUseInternal()
    {
        return false;
    }

    /**
     * Using for multiple shipping address
     *
     * @return bool
     */
    public function canUseForMultishipping()
    {
        return false;
    }

    public function createFormBlock($name)
    {
    Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n") ;
    
        $block = $this->getLayout()->createBlock('billdesk/form', $name)
            ->setMethod('billdesk')  //??
            ->setPayment($this->getPayment())
            ->setTemplate('billdesk/form.phtml');

        return $block;
    }

    /*validate the currency code is avaialable to use for paypal or not*/
    public function validate()
    {
        parent::validate();
        $currency_code = $this->getQuote()->getBaseCurrencyCode();
        if (!in_array($currency_code,$this->_allowCurrencyCode)) {
            Mage::throwException(Mage::helper('billdesk')->__('Selected currency code ('.$currency_code.') is not compatible with PayPal'));
        }
        return $this;
    }

    public function onOrderValidate(Mage_Sales_Model_Order_Payment $payment)
    {
       return $this;
    }

    public function onInvoiceCreate(Mage_Sales_Model_Invoice_Payment $payment)
    {

    }

    public function canCapture()
    {
        return false;
    }

    public function getOrderPlaceRedirectUrl()
    {
    
        Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n") ;
    
        return Mage::getUrl('billdesk/standard/redirect', array('_secure' => true));
    }

    public function getStandardCheckoutFormFields()
    {
    Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n") ;
    
        if ($this->getQuote()->getIsVirtual()) {
            $a = $this->getQuote()->getBillingAddress();
            $b = $this->getQuote()->getShippingAddress();
        } else {
            $a = $this->getQuote()->getShippingAddress();
            $b = $this->getQuote()->getBillingAddress();
        }
        //getQuoteCurrencyCode
        $currency_code = $this->getQuote()->getBaseCurrencyCode();
       
        
            Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n") ;
   /*     

        $sArr = array(
            'charset'           => self::DATA_CHARSET,
            'business'          => Mage::getStoreConfig('paypal/wps/business_account'),
            'merchant_id'       => Mage::getStoreConfig('billdesk/wps/merchant_id'),          
            'checksum'			=> Mage::getStoreConfig('billdesk/wps/checksum_key'),
            'merchant_url'		=> Mage::getStoreConfig('billdesk/wps/merchant_url'),
            'return_url'		=> Mage::getStoreConfig('billdesk/wps/return_url'),
            'return'            => Mage::getUrl('billdesk/standard/success',array('_secure' => true)), 
            'cancel_return'     => Mage::getUrl('billdesk/standard/cancel',array('_secure' => false)),  //??
            'notify_url'        => Mage::getUrl('billdesk/standard/ipn'),  //??
            'invoice'           => $this->getCheckout()->getLastRealOrderId(),
            'currency_code'     => $currency_code,
            'address_override'  => 1,
            'customer_id'		=> $a->getCustomerId(),
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
        
    */
 	$sArr = array(
            
            'RU'                => Mage::getUrl('billdesk/standard/success',array('_secure' => true)), 
            'txtAdditionalInfo1'  => $this->getCheckout()->getLastRealOrderId(),  // Invoice
            'txtCustomerId'		=> $a->getCustomerId(),
            'txtAdditionalInfo2'        => $a->getFirstname(),
            'txtAdditionalInfo3'         => $a->getLastname(),
            'txtAdditionalInfo4'          => $a->getStreet(1),
           'txtAdditionalInfo5'          => $a->getStreet(2),
 //           'txtAdditionalInfo5'              => $a->getCity(),
 //           'txtAdditionalInfo2'             => $a->getRegionCode(),
            'txtAdditionalInfo6'           => $a->getCountry(),
            'txtAdditionalInfo7'               => $a->getPostcode()
 
        );
        
        
        // After testing the interface, we should hardcode them, it may be too risky to keep them as parameters
        
        $checksumkey = Mage::getStoreConfig('billdesk/wps/checksum_key') ;
        $merchanturl = Mage::getStoreConfig('billdesk/wps/merchant_url') ;
        $returnurl = Mage::getStoreConfig('billdesk/wps/return_url') ;
        
                Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n".print_r($checksumkey,true)) ;
                Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n".print_r($merchanturl,true)) ;
                Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n".print_r($returnurl,true)) ;
                
        
          
                        
                
        
        
        
        /*

        $logoUrl = Mage::getStoreConfig('billdesk/wps/logo_url');
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
        */
        
    Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n") ;
        
 //      	     $transaciton_type = $this->getConfigData('transaction_type');
       
 
            $businessName = Mage::getStoreConfig('billdesk/wps/business_name');
            $storeName = Mage::getStoreConfig('store/system/name');
            $amount = ($a->getBaseSubtotal()+$b->getBaseSubtotal())-($a->getBaseDiscountAmount()+$b->getBaseDiscountAmount());

  
            $_shippingTax = $this->getQuote()->getShippingAddress()->getBaseTaxAmount();
            $_billingTax = $this->getQuote()->getBillingAddress()->getBaseTaxAmount();
            $tax = sprintf('%.2f', $_shippingTax + $_billingTax);
    

        $totalArr = $a->getTotals();
        $shipping = sprintf('%.2f', $this->getQuote()->getShippingAddress()->getBaseShippingAmount());

 
        
        $grand_total = $amount + $shipping + $tax ;
        
        $sArr = array_merge($sArr, array(
                    'txtTxnAmount' => $grand_total
                ));
        
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
            $debug = Mage::getModel('billdesk/api_debug')
                    ->setApiEndpoint($this->getBilldeskUrl())
                    ->setRequestBody($sReq)
                    ->save();
        }

        Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n".print_r($rArr,true)) ;
        
        return $rArr;
    }

    public function getBilldeskUrl()
    {
         if (Mage::getStoreConfig('billdesk/wps/sandbox_flag')==1) {
             $url='https://www.sandbox.paypal.com/cgi-bin/webscr';
         } else {
             $url='https://www.paypal.com/cgi-bin/webscr';
         }
         return $url;
    }

    public function getDebug()
    {
        return Mage::getStoreConfig('billdesk/wps/debug_flag');
    }


//  public function ipnPostSubmit()

    public function billdeskPostResponse()
    
    {
    
    Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n") ;
   
 
    //UNCOMMENT the next line
   //     $msg = $this->getBillFormData('msg') ; 
        
    $msg = "M123456|00002|123456788|bankrefno|21.00|SBI|22270726|NA|INR|NA|NA|NANA|12-12-06  |0300|NA|AXPIY|100000003|NA|NA|NA|NA|NA|NA|NA|NA|NA|123456789" ;

        $checksumkey = Mage::getStoreConfig('billdesk/wps/checksum_key') ;
      //      if (!($this->billChecksum($msg))) {
          if (($this->billChecksum($msg,$checksumkey))) { //change it back to above one
        
               return false ; 
        }
        
        
 //       $msg_arr = str_getcsv($msg,"|") ; in php 3.0
 //       $msg_arr[] = $this->strgetcsv($msg,"|") ;
        
        $msg_arr = array() ;
//        $msg_arr1 = $this->strgetcsv($msg,"|") ;
        
                
        
  
         $i = 0 ; 
    	$tok = strtok($msg,"|");
    	while ($tok != false) {
    	   $msg_arr[$i++] = $tok ; 
    	   $tok = strtok("|"); 
    	}
        
            Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n") ;
        
        
    Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n".print_r($msg_arr,true)) ;
        
        
        $r_authstatus = $msg_arr[13] ;
        
        if ($r_authstatus != "0300") {
            Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n".print_r($r_authstatus,true)) ;
        
        
        	return false ;
        }
    Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n".print_r($r_authstatus,true)) ;
        
        $r_merchantid = $msg_arr[0] ;
        $r_customerid = $msg_arr[1] ;
        $r_txnrefid   = $msg_arr[2] ;
        $r_txnamount  = $msg_arr[4];
        $r_id    = $msg_arr[16] ;    // some id which order.php uses, stored in txtAdditionalInfo1
        
       Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n".print_r($r_txnamount,true)) ;
       Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n".print_r($r_id,true)) ;
  
        
          
               
 //      return false ;
       
      	  $order = Mage::getModel('sales/order');
      	  $order->loadByIncrementId($r_id);  // we  the order with this id

 
            if (!$order->getId()) {     //  If the above load of order does not happen i.e wrong order id from Billdesk
                /*
                * need to have logic when there is no order with the order id from billdesk
                */
            
                Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n") ;
                return false ;
            

            } else {

          	  if ($this->getDebug() && $msg) {
          		//	  $sReq = substr($sReq, 1);
         			   $debug = Mage::getModel('billdesk/api_debug')
            	        ->setApiEndpoint($this->getBilldeskUrl())
            	        ->setResponseBody($msg)
             	       ->save();
      		  }
                if ($r_txnamount!=$order->getBaseGrandTotal()) {
                    //when grand total does not equal, need to have some logic to take care
                     Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n") ;
                
                    $order->addStatusToHistory(
                        $order->getStatus(),//continue setting current order status
  //                      Mage::helper('paypal')->__('Order total amount does not match paypal gross total amount')
                         Mage::helper('billdesk')->__('Order total amount does not match billdesk gross total amount')
                        
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
                
                
                Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n") ;
                

                    // get from config order status to be set
            /*        $newOrderStatus = $this->getConfigData('order_status', $order->getStoreId());
                    if (empty($newOrderStatus)) {
                        $newOrderStatus = $order->getStatus();
                    }
                    
             */

                   
                    //need to save transaction id

                    $order->getPayment()->setTransactionId($r_txnrefid);  // where this gets stored in DB
                    $order->getPayment()->setLastTransId($r_txnrefid);  // where this gets stored in DB
                    $order->getPayment()->setCcTransId($r_txnrefid);  // where this gets stored in DB
                    
                    
                       
                           //need to convert from order into invoice
                    $invoice = $order->prepareInvoice();
                    $invoice->register()->pay();
                    
                    Mage::getModel('core/resource_transaction')
                            ->addObject($invoice)
                            ->addObject($invoice->getOrder())
                            ->save();
                            
                           $order->setState(
                               Mage_Sales_Model_Order::STATE_PROCESSING, true,
                               Mage::helper('billdesk')->__('Invoice #%s created', $invoice->getIncrementId()),
                               $notified = true
                           );
                       
       /*aks             } else {
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
             */
                   Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n".print_r($r_txnrefid,true)) ;
                   Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n".print_r($order->getpayment()->getTransactionID(),true)) ;
                   
                       
                    $order->save();

                /*    if (!$ipnCustomerNotified) { */
                      $order->sendNewOrderEmail();  // should we send an email now ?
                  //  }

               }//else amount the same and there is order obj
                //there are status added to order
            }
    }
    
 
        
 
  //  }
    
    
    public function billChecksum($msg,$checksumkey)
    {
    
        Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n".print_r($msg,true)) ;
    
        $lastbar = strrpos($msg,"|");
        
        $msgWithoutChkSum = substr($msg,0,$lastbar) ;
        $msgWithChkSum = $msgWithoutChkSum."|".$checksumkey ;
        $chksumFromBilldesk = substr($msg, $lastbar+1,strlen($msg)) ;
        
        Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n".print_r($msgWithoutChkSum,true)) ;
        Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n".print_r($msgWithChkSum,true)) ;
        
        $calChksum = crc32($msgWithChkSum) ;
        
        Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n".print_r($calChksum,true)) ;
        Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n".print_r($chksumFromBilldesk,true)) ;
        
        
        if ($calChksum != $chksumFromBilldesk) {
        	return false ;
        }

        return true ;
    }
    
    public function strgetcsv($msg)
    {
                Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n") ;
    
        $i = 0 ; $array_tok = array() ;
    	$tok = strtok($msg,"|");
    	while ($tok != false) {
    	   $array_tok[$i++] = $tok ; 
    	   $tok = strtok("|"); 
    	}
    	        Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n".print_r($array_tok,true)) ;
    	
     	return $array_tok ;
    
    
    }
    

    public function isInitializeNeeded()
    {
        return true;
    }

    public function initialize($paymentAction, $stateObject)
    {
    
    Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n") ;
    
        $state = Mage_Sales_Model_Order::STATE_PENDING_PAYMENT;
        $stateObject->setState($state);
        $stateObject->setStatus("pending_billdesk");  
        $stateObject->setIsNotified(false);
        
         Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__.":".print_r($stateObject->getStatus(),true)."\n") ;
        
    }
}
