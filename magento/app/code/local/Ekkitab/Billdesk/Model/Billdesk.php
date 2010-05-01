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
    protected $_allowCurrencyCode = array('INR');
    
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
        return true;
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
  			    $session_id   =  Mage::getSingleton('core/session')->getSessionId();   // for mltiple shipment orders
    	  		Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__." SESSION ID : \n".print_r($session_id,true));
    	  		
    
    /*
        if ($this->getQuote()->getIsVirtual()) {
            $a = $this->getQuote()->getBillingAddress();
            $b = $this->getQuote()->getShippingAddress();
        } else {
            $a = $this->getQuote()->getShippingAddress();
            $b = $this->getQuote()->getBillingAddress();
        }
        
        */
    
     	if ($this->getQuote()->getIsMultiShipping()){
                     $Merchant_Param="M" ; 
                      Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."Mage_Checkout_Model_Type_Multishipping\n") ;
          }
          else {
                      $Merchant_Param="S" ; 
                      Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."Mage_Checkout_Model_Type_Onepage\n") ;
       	 }
       	 
    	$total_amount = 0 ;
	
        if ($Merchant_Param=="S") { // OnestepCheckout Order
     		 $Order_Id =  $this->getCheckout()->getLastRealOrderId();  // for single shipment order 
	  	   	 $order = Mage::getModel('sales/order');
     	     $order->loadByIncrementId($Order_Id);  
             $total_amount = $order->getGrandTotal();

             Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."Single Address Checkout\n".print_r($total_amount,true)) ;
                  
	  	} else {  // it is "M" : Multishipping order
	  		$Order_Ids    =  Mage::getSingleton('core/session')->getOrderIds();   // for mltiple shipment orders
	  		$Order_Id = end($Order_Ids);
	  	     	 
	  		foreach( $Order_Ids as $key => $orid) {
	  	 				  $order = Mage::getModel('sales/order');
     			 		  $order->loadByIncrementId($orid);  
     					  $total_amount = $total_amount + $order->getGrandTotal() ;
      	  
	  	         }

	  	     Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n".print_r($Order_Ids,true)) ;
	  	     Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."Multiple Address Checkout\n".print_r($total_amount,true)) ;
	  	
	  	}
	
    
    
        
        $a = $this->getQuote()->getBillingAddress();
        $b = $this->getQuote()->getShippingAddress();
            
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
            
            // After testing the interface, we should hardcode them, it may be too risky to keep them as parameters
        
        $checksumkey = Mage::getStoreConfig('billdesk/wps/checksum_key') ;
        $merchanturl = Mage::getStoreConfig('billdesk/wps/merchant_url') ;
        $returnurl = Mage::getStoreConfig('billdesk/wps/return_url') ;
        
                Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n".print_r($checksumkey,true)) ;
                Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n".print_r($merchanturl,true)) ;
                Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n".print_r($returnurl,true)) ;
                
                
 	$sArr = array(
            
   //         'RU'                => Mage::getUrl('billdesk/standard/success',array('_secure' => true)), 
  //          'txtAdditionalInfo1'  => $this->getCheckout()->getLastRealOrderId(),  // Invoice
  //          'txtCustomerId'		=> $a->getCustomerId(),
 //           'txtCustomerId'		=> $a->getCustomerId(),
             'RU'                => $returnurl, 
 	
 //	          'txtCustomerID'  => $this->getCheckout()->getLastRealOrderId(),  // Invoice
  	          'txtCustomerID'  => $Order_Id,  // Invoice
 	
 //            'txtAdditionalInfo1'  => $this->getCheckout()->getLastRealOrderId(),  // Invoice
 	
 	
 	
            'txtAdditionalInfo1'        => $a->getFirstname()." ".$a->getLastname(),
 //           'txtAdditionalInfo3'         => $a->getLastname(),
            'txtAdditionalInfo2'          => $a->getStreet(1)." ".$a->getstreet(2),
 //          'txtAdditionalInfo5'          => $a->getStreet(2),
 //           'txtAdditionalInfo5'              => $a->getCity(),
           'txtAdditionalInfo3'             => $a->getRegionCode(),
            'txtAdditionalInfo4'           => $a->getCountry(),
            'txtAdditionalInfo5'               => $a->getPostcode(),
 //          'txtAdditionalInfo6'               => $a->getTelephone(),
            'txtAdditionalInfo6'               =>  preg_replace('/[^0-9]/','', $a->getTelephone()),
 	
 	        'txtAdditionalInfo7'               => $a->getEmail()
 	
 	
 
        );
        
        
        
        
        
                
        
          
                        
                
        
        
        
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
        
        $amount = $total_amount ;

 
        
        $grand_total = $amount + $shipping + $tax ;
        
        $sArr = array_merge($sArr, array(
             'txtTxnAmount' => $grand_total
  //                          'txtTxnAmount' => "2.00"
        
                ));
        
        $sReq = '';
        $sReqDebug = '';
        $rArr = array();


        foreach ($sArr as $k=>$v) {
            /*
            replacing & char with and. otherwise it will break the post
            */
        
            $value = str_replace("&","and",$v);  // this was there from paypal do, we need it ?
            $value = preg_replace("/\<|\>|\%|\;|\,|\"|\^|\`/"," ", $value); // as per Bill pay
       
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
 				$url = Mage::getStoreConfig('billdesk/wps/merchant_url') ; 
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
    		$session_id    =  Mage::getSingleton('core/session')->getSessionId();   // for mltiple shipment orders
    	  	Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__." SESSION ID : \n".print_r($session_id,true));
    	  		
    
     	  $msg = $_REQUEST['msg'];
    
          Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n".print_r($msg,true)) ;
     	
    
          if ($this->getQuote()->getIsMultiShipping()){
                     $Merchant_Param="M" ; 
                      Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."Billdesk_Model_Type_Multishipping\n") ;
          }
          else {
                      $Merchant_Param="S" ; 
                      Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."Billdesk_Model_Type_Onepage\n") ;
       	 }
       
   
 
    //UNCOMMENT the next line
  //    $msg = $this->getBillFormData('msg') ; 

   //   Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n".print_r($msg,true)) ;
      
   // $msg = "M123456|00002|123456788|bankrefno|21.00|SBI|22270726|NA|INR|NA|NA|NA|NA|12-12-06  |0300|NA|AXPIY|100000003|NA|NA|NA|NA|NA|NA|NA|NA|NA|123456789" ;

        $checksumkey = Mage::getStoreConfig('billdesk/wps/checksum_key') ;
        
       
        
        
 //       $msg_arr = str_getcsv($msg,"|") ; in php 3.0
 //       $msg_arr[] = $this->strgetcsv($msg,"|") ;
        
        $msg_arr = array() ;
//        $msg_arr1 = $this->strgetcsv($msg,"|") ;
        
                
        
  
     /*    $i = 0 ; 
    	$tok = strtok($msg,"|");
    	while ($tok != false) {
	    	   $msg_arr[$i++] = $tok ; 
    	   $tok = strtok("|"); 
    	}
    	
    	*/
    	
    	$msg_arr = explode ("|", $msg) ;
        
            Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n") ;
        
        
    Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n".print_r($msg_arr,true)) ;
    
    //    $msgwochecksum = substr($msg,0,strrpos($msg,"|")) ;

  //      Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__." Msgwithout checksum \n".print_r($msgwochecksum,true)) ;
        
          $r_checksum = $msg_arr[25]  ;
    
    
     $Checksumcalc = $this->billChecksum($msg,$checksumkey,$r_checksum); // this takes care of checking the message without checksum

     /*
      $r_checksum = $msg_arr[25]  ;
      
          if (($Checksumcalc != $r_checksum)) { 
          
                  Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__." checksum as in msg\n".print_r($msgwochecksum,true)) ;
                  Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__." checksum as in msg\n".print_r($r_checksum,true)) ;
                  
          
        
			    Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__." Checksum Security Error. Illegal access detected\n");
            }
            	
     */
        
        
        $r_authstatus = $msg_arr[14] ;
        
        
        if ($r_authstatus == "0300") {
            Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n".print_r($r_authstatus,true)) ;
              $AuthDesc="Y" ;
        }
        elseif  ($r_authstatus == "0399") {
               $AuthDesc="N" ; //The transaction has been declined, cancel the transaction
        }
        elseif  ($r_authstatus == "NA") {
               $AuthDesc="N" ; // Invalid Input at Billdesk, Cancel the transaction
        }elseif  ($r_authstatus == "0002") {
               $AuthDesc="N" ; //Billdesk is waiting for response from the Bank, cancel the transaction
        }elseif  ($r_authstatus == "0001") {
               $AuthDesc="N" ; //Error at billdesk, cancel the transaction
        }
        else {
                 $AuthDesc="N" ; //Assume Error at billdesk, cancel the transaction
        
        }
        
        
    Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n".print_r($r_authstatus,true)) ;
        
        $r_merchantid = $msg_arr[0] ;
        $r_orderid    = $msg_arr[1] ;
        $r_txnrefid   = $msg_arr[2] ;
        $r_txnamount  = $msg_arr[4];
        $r_cname = $msg_arr[16] ;
        $r_telno = $msg_arr[21] ;
        
       Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n".print_r($r_txnamount,true)) ;
       Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n".print_r($r_orderid,true)) ;
       Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n".print_r($r_cname,true)) ;
       Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n".print_r($r_telno,true)) ;
       
  
	if($Checksumcalc=="true" && $AuthDesc=="Y")
	{
	//	echo "<br>Thank you for shopping with us. Your credit card has been charged and your transaction is successful. We will be shipping your order to you soon.";
        Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."Thank you for shopping with us. Your credit card has been charged and your transaction is successful. We will be shipping your order to you soon.\n") ;
		
		//Here you need to put in the routines for a successful 
		//transaction such as sending an email to customer,
		//setting database status, informing logistics etc etc
	}
	
	else if($Checksumcalc=="true" && $AuthDesc=="N")
	{
	//	echo "<br>Thank you for shopping with us.However,the transaction has been declined.";
	//	return false ;
		
				    Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."Thank you for shopping with us.However,the transaction has been declined.\n") ;
		
		
		//Here you need to put in the routines for a failed
		//transaction such as sending an email to customer
		//setting database status etc etc
	}
	else
	{
	//	echo "<br>Security Error. Illegal access detected";
	//	return false;
	
			    Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."Security Error. Illegal access detected\n");
	
		
		//Here you need to simply ignore this and dont need
		//to perform any operation in this condition
	}
         
          
               
 //      return false ;
 
      if ($Merchant_Param == "M") {
    
    		$Order_Ids    =  Mage::getSingleton('core/session')->getOrderIds();
    
	         Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."Multiship Returned from Billdesk\n".print_r($Order_Ids,true)) ;
	         
	          if (empty($Order_Ids)) {
	         	         Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."LOGICERROR Multiship Returned from Billdesk empty OrderIds in session\n") ;
	         }
	         
	                
    }
    else {
  //        $Order_Ids[] = $Order_Id ;  // will not use the Order Id from CCav but from LastOrder_ID
  //          $x = $this->getCheckout()->getLastOrderId(); 
    
           $x = $this->getCheckout()->getLastRealOrderId(); 
    
            if ($x != $r_orderid ) { // This should never happen, but I have seen it happening once in blue moon, keep a watch on it
                      	    Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."LOGICERROR \n".print_r($x,true)) ;
            }
          
            $Order_Ids[] = $r_orderid  ;  // will take the orderid returned from billdesk from Billdesk rather than last Real Order id
          
          	Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."Order_Id from LastRealOredrId \n".print_r($x,true)) ;
          	    
          	    // we have to find out if these values are same, than use one of them or continue using both of them
          	    
    }
    
    if (empty($Order_Ids)) {
	       $flag = false ;
    } else {
     foreach($Order_Ids as $key => $orid ) {
          	                Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n".print_r($orid,true)) ;
       
      	  $order = Mage::getModel('sales/order');
      	  $order->loadByIncrementId($orid);  // we  the order with this id

 
            if (!$order->getId()) {     //  If the above load of order does not happen i.e wrong order id from Billdesk
                /*
                * need to have logic when there is no order with the order id from billdesk
                */
            
                Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n") ;
 //               return false ;
                $flag = false ;
            

            } else {

          	 	 if ($this->getDebug() && $msg) {
          		//	  $sReq = substr($sReq, 1);
         			   $debug = Mage::getModel('billdesk/api_debug')
            	        ->setApiEndpoint($this->getBilldeskUrl())
            	        ->setResponseBody($msg)
             	       ->save();
      		 	 }
      		  
      		  	 if ($Checksumcalc == true && $AuthDesc == "N") {
      		  
                     Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n") ;
                     
                
                    $order->addStatusToHistory(
   //                     $order->getStatus(),//continue setting current order status
   //                    Mage::helper('paypal')->__('Order total amount does not match paypal gross total amount')
                           "declined_billdesk",//continue setting current order status
                        
                         Mage::helper('billdesk')->__('Order declined')
                        
                    );
                    $order->save();
                    $flag = false ;
                    
                
                } elseif (($Checksumcalc == true) && ($AuthDesc == "Y"))  {
                                
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
  //                  $invoice = $order->prepareInvoice();
  //                  $invoice->register()->pay();
                    
   //                 Mage::getModel('core/resource_transaction')
   //                         ->addObject($invoice)
  //                          ->addObject($invoice->getOrder())
 //                           ->save();
                            
                           $order->setState(
                               Mage_Sales_Model_Order::STATE_PROCESSING, true,
                               Mage::helper('billdesk')->__('Order #%s created', $orid),
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
                   Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."Before Order Save\n".print_r($order->getpayment()->getTransactionID(),true)) ;
                   
                       
                    $order->save();
                    
                    Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."After Order Save\n") ;
                    

                /*    if (!$ipnCustomerNotified) { */
                      $order->sendNewOrderEmail();  // should we send an email now ?
                      
                       Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."After Send Mail\n") ;
                      
                      
                      $this->sendsms($r_telno,$orid);
                      
                       Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."After sending SMS\n") ;
                      
                  //  }

               //else amount the same and there is order obj
                //there are status added to order
                                     $flag = true ;
                      
            } else { // sercurity error
               
                 Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n") ;
                  
                   //we have to figure out how to say in Order that it is declined
                     
                    $order->addStatusToHistory(
     //                   $order->getStatus(),//continue setting current order status
                                "declined_billdesk",//continue setting current order status
                    
                         Mage::helper('billdesk')->__('Security Error')
                        
                    );
                    $order->save();
                   // return false ;
                     $flag = false ;
                 }
            }
     }// end of For
    }// end of if
     
     
              Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n".print_r($flag,true)) ;
                      	                
                      	                
               if ($Merchant_Param == "M") {
                    if ($flag)  {
                      	  $flag = 1 ;  // Multishipment success
                      	    
                     } else {
                      	   $flag = 2 ; // Multishipment failure
                     }
               } else {
                      if ($flag) {
              			  $flag = 3 ;   // slingle checkout success
  						} else{
  					      $flag = 4 ;  // single checkout failure
                      	                                                	      
                       }
               }
    
            Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n".print_r($flag,true)) ;
               
            return $flag ;
    }
    
 
        
 
  //  }
    
    
    public function billChecksum($msg,$checksumkey, $rchksum)
    {
    
        Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n".print_r($msg,true)) ;
    
        $lastbar = strrpos($msg,"|");
        
        $msgWithoutChkSum = substr($msg,0,$lastbar) ;
         $msgWithChkSumkey = $msgWithoutChkSum."|".$checksumkey ;
//      $chksumFromBilldesk = substr($msg, $lastbar+1,strlen($msg)) ;
        
        Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__." MesgWithoutChecksum\n".print_r($msgWithoutChkSum,true)) ;
        Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n".print_r($msgWithChkSumkey,true)) ;
        
        $calChksum = crc32($msgWithChkSumkey) ;
        
        Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__." Calculated Checksum \n".print_r($calChksum,true)) ;
        Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__." Checksum from Billdesk \n".print_r($rchksum,true)) ;
        
        
        if ($calChksum != $rchksum) {
        	return false ;
        }

        return true ;
    }
 /*   
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
 */
 /*   
     public function sendsms($recepientno,$Order_Id)
    {
    $ch = curl_init();
    $user="anil@ekkitab.com:meritos1959";
    $senderID="EKKITAB1";
    $msgtxt="Thank you for shopping with EkKitab. Your Order Id is $Order_Id";
    $state="4" ;
  	curl_setopt($ch,CURLOPT_URL,  "http://api.mVaayoo.com/mvaayooapi/MessageCompose") ;
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
	curl_setopt($ch, CURLOPT_POST, 1);
	curl_setopt($ch, CURLOPT_POSTFIELDS, "user=$user&senderID=$senderID&receipientno=$recepientno&msgtxt=$msgtxt&state=$state");
	
	$buffer = curl_exec($ch);
	if(empty ($buffer))
	{ 
	  	    Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."Buffer is empty\n".print_r($buffer,true)) ;
	
    }
	else
	{ 
		     Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n".print_r($buffer,true)) ;
	}
	
	curl_close($ch);
    }
    */
    
public function sendsms($recepientno,$Order_Id)
    {

    $user="anil@ekkitab.com:meritos1959";
    $senderID="EKKITAB1";
    $msgtxt="Thank you for shopping with EkKitab. Your Order Id is $Order_Id";
    $filen ="/var/log/ekkitab/sms/sms".$Order_Id ;
    $msg = $recepientno."|".$msgtxt ;
    if ( file_put_contents($filen, $msg )== FALSE)
	{ 
	  	    Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."can't write sms to $filen: ".print_r($msg,true)) ;
	
    }
	else
	{ 
		     Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__." $filen: \n".print_r($msg,true)) ;
	}
	

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
