<?php
/**
 * Ekkitab
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
 * @category   Ekkitab
 * @package    Ekkitab_CCav
 * @copyright  Copyright (c) 2008 Irubin Consulting Inc. DBA Varien (http://www.varien.com)
 * 			   Copyright (c) 2009 Ekkitab Educational Services India Pvt. Ltd.  
 * @license    http://opensource.org/licenses/osl-3.0.php  Open Software License (OSL 3.0)
 */

/**
 *
 * CCav Checkout Module
 *
 * @author     Ekkitab
 */
class Ekkitab_Ccav_Model_Ccav extends Mage_Payment_Model_Method_Abstract
{
    //changing the payment to different from cc payment type and paypal payment type
    const PAYMENT_TYPE_AUTH = 'AUTHORIZATION';
    const PAYMENT_TYPE_SALE = 'SALE';

    const DATA_CHARSET = 'utf-8';

  //aks  protected $_code  = 'paypal_standard';
  //aks protected $_formBlockType = 'paypal/standard_form';
  //aks   protected $_allowCurrencyCode = array('AUD', 'CAD', 'CZK', 'DKK', 'EUR', 'HKD', 'HUF', 'ILS', 'JPY', 'MXN', 'NOK', 'NZD', 'PLN', 'GBP', 'SGD', 'SEK', 'CHF', 'USD');
    protected $_code  = 'ccav';
    protected $_formBlockType = 'ccav/form';
    protected $_allowCurrencyCode = array('INR');  // Allowed currency code for charging the credit card
    
       //copied from CCAvenue libfuncs.php3
    
	public function getchecksum($MerchantId,$Amount,$OrderId ,$URL,$WorkingKey)
	{
		$str ="$MerchantId|$OrderId|$Amount|$URL|$WorkingKey";
		$adler = 1;
		$adler = $this->adler32($adler,$str);
			
		return $adler;
	}
       //copied from CCAvenue libfuncs.php3
	
	public function verifychecksum($MerchantId,$OrderId,$Amount,$AuthDesc,$CheckSum,$WorkingKey)
	{
		$str = "$MerchantId|$OrderId|$Amount|$AuthDesc|$WorkingKey";
		$adler = 1;
		$adler = $this->adler32($adler,$str);
	
		if($adler == $CheckSum)
			return "true" ;
		else
			return "false" ;
	}

	public function adler32($adler , $str)
	{
		$BASE =  65521 ;

		$s1 = $adler & 0xffff ;
		$s2 = ($adler >> 16) & 0xffff;
		for($i = 0 ; $i < strlen($str) ; $i++)
		{
			$s1 = ($s1 + Ord($str[$i])) % $BASE ;
			$s2 = ($s2 + $s1) % $BASE ;
				//echo "s1 : $s1 <BR> s2 : $s2 <BR>";

		}
		return $this->leftshift($s2 , 16) + $s1;
	}
       //copied from CCAvenue libfuncs.php3
	
	public function leftshift($str , $num)
	{

		$str = DecBin($str);

		for( $i = 0 ; $i < (64 - strlen($str)) ; $i++)
			$str = "0".$str ;

		for($i = 0 ; $i < $num ; $i++) 
		{
			$str = $str."0";
			$str = substr($str , 1 ) ;
			//echo "str : $str <BR>";
		}
		return $this->cdec($str) ;
	}
       //copied from CCAvenue libfuncs.php3
	
	public function cdec($num)
	{
    	$dec = 0 ;
		for ($n = 0 ; $n < strlen($num) ; $n++)
		{
	 	  $temp = $num[$n] ;
	   	  $dec =  $dec + $temp*pow(2 , strlen($num) - $n - 1);
		}

		return $dec;
	}
    
    
    /**
     * Check method for processing with base currency
     *  If the currency code is not in the array, this option will not show up in payment method during checkout.
     * @param string $currencyCode
     * @return boolean
     */
    public function canUseForCurrency($currencyCode)
    {
         if (!in_array($currencyCode, $this->_allowCurrencyCode)) {
            return false;
         }
        else 
          return true;
    }

    /**
     * Fields that should be replaced in debug with '***'
     * This is used in Paypal, but not in CCav. We have to figure out how it works
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
        return Mage::getSingleton('ccav/session');
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
    public function canUseInternal()  // What is its significance ?
    {
        return false;
    }

    /**
     * Using for multiple shipping address
     *
     * @return bool
     */
    public function canUseForMultishipping()  // What is its significance ?
    {
        return true;
    }

    public function createFormBlock($name)
    {
    Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n") ;
    
        $block = $this->getLayout()->createBlock('ccav/form', $name)
            ->setMethod('ccav')  //??
            ->setPayment($this->getPayment())
            ->setTemplate('ccav/form.phtml');

        return $block;
    }

    /*validate the currency code is avaialable to use for CCav or not*/ 
    public function validate()  // What is its significance ? From where it is being called ?
    {
        parent::validate();
        $currency_code = $this->getQuote()->getBaseCurrencyCode();
        if (!in_array($currency_code,$this->_allowCurrencyCode)) {
            Mage::throwException(Mage::helper('ccav')->__('Selected currency code ('.$currency_code.') is not compatible with CCav'));
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
    
        return Mage::getUrl('ccav/standard/redirect', array('_secure' => true));
    }

    public function getStandardCheckoutFormFields()
    {
    Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n") ;
    
    /*
        if ($this->getQuote()->getIsVirtual()) {  // don't understand this "aksingh"
            $a = $this->getQuote()->getBillingAddress();
            $b = $this->getQuote()->getShippingAddress();
        } else {
            $a = $this->getQuote()->getShippingAddress();
            $b = $this->getQuote()->getBillingAddress();
        }
        
        */
    
   		    $a = $this->getQuote()->getBillingAddress();
            $b = $this->getQuote()->getShippingAddress();
            
            
        //getQuoteCurrencyCode
        $currency_code = $this->getQuote()->getBaseCurrencyCode();
       
        
            
            //copied from Checkout.php3
            
            
//	Merchant_Id  available at "Generate Working Key" of "Settings & Options" 
	$Merchant_Id =Mage::getStoreConfig('ccav/wps/merchant_id');	
    $Amount = "" ;//your script should substitute the amount in the quotes provided here
	$Order_Id = "" ;//your script should substitute the order description in the quotes provided here
//	$Redirect_Url = "http://www.xyz.com/xyz.asp" ;//your redirect URL where your customer will be redirected after authorisation from CCAvenue
    $Redirect_Url = Mage::getStoreConfig('ccav/wps/return_url') ;
//put in the 32 bit alphanumeric key in the quotes provided here.Please note that get this key ,login to your CCAvenue merchant account and visit the "Generate Working Key" section at the "Settings & Options" page. 
	$WorkingKey = Mage::getStoreConfig('ccav/wps/checksum_key') ;
    
    $a_first_name = $a->getFirstname() ;
    $a_last_name  = $a->getLastname();
    $a_address1  = $a->getStreet(1);
    $a_address2  = $a->getStreet(2);
    
    $b_first_name = $b->getFirstname() ;
    $b_last_name  = $b->getLastname();
    $b_address1  = $b->getStreet(1);
    $b_address2  = $b->getStreet(2);
    
    // Check wether these is enough for street data or we need getStreet(3) and getStreet (4)
      

	$billing_cust_name=$a_first_name." ".$a_last_name;
	$billing_cust_address=$a_address1." ".$a_address2;
	$billing_cust_state=$a->getRegion();
//  $billing_cust_country=$a->getCountry();
    $billing_cust_country = Mage::getModel('directory/country')->load($a->getCountry())->getName();
    
    
	
	$billing_cust_tel=$a->getTelephone();
    $billing_cust_tel=str_replace(" ","",$billing_cust_tel);
	
	$billing_cust_email=$a->getEmail();
	$delivery_cust_name=$b_first_name." ".$b_last_name;
	$delivery_cust_address=$b_address1." ".$b_address2;
	$delivery_cust_state = $b->getRegion();
//	$delivery_cust_country = $b->getCountry();
	$delivery_cust_country = Mage::getModel('directory/country')->load($b->getCountry())->getName();

	
	$delivery_cust_tel= $b->getTelephone();
	$delivery_cust_tel=str_replace(" ","",$delivery_cust_tel);
	
	$delivery_cust_notes="hello";  // this is optional,
	$Merchant_Param="" ;     // this is optional, you can fill up with any value
	$billing_city = $a->getCity();
	$billing_zip = $a->getPostcode();
	$delivery_city = $b->getCity();
	$delivery_zip = $b->getPostcode();

	$Order_Id =  $this->getCheckout()->getLastRealOrderId();
	
	//upto here from checkuot.php3

        $sArr = array(
     //       'charset'           => self::DATA_CHARSET,
     //       'business'          => Mage::getStoreConfig('paypal/wps/business_account'),
     //         'Checksum'			=> $Checksum,
     //       'merchant_url'		=> Mage::getStoreConfig('ccav/wps/merchant_url'),
     //      'return'            => Mage::getUrl('ccav/standard/success',array('_secure' => true)), 
      //      'cancel_return'     => Mage::getUrl('ccav/standard/cancel',array('_secure' => false)),  //??
      //      'notify_url'        => Mage::getUrl('ccav/standard/ipn'),  //??
      //           'currency_code'     => $currency_code,
 	//           'address_override'  => 1,
      
               'Redirect_Url'		   => $Redirect_Url,  
          	   'Merchant_Id'           => $Merchant_Id,             
               'Order_Id'              => $Order_Id, 
        	   'billing_cust_name'     => $billing_cust_name,
			   'billing_cust_address'  => $billing_cust_address,
			   'billing_cust_state'    => $billing_cust_state,
        	   'billing_cust_country'  => $billing_cust_country,
			   'billing_cust_tel'      => $billing_cust_tel,
			   'billing_cust_email'    => $billing_cust_email,
			   'delivery_cust_name'    => $delivery_cust_name,
			   'delivery_cust_address' => $delivery_cust_address,
			   'delivery_cust_state'   => $delivery_cust_state,
			   'delivery_cust_country' => $delivery_cust_country,
			   'delivery_cust_tel'     => $delivery_cust_tel,
			   'delivery_cust_notes'   => $delivery_cust_notes,
			   'Merchant_Param'        => $Merchant_Param,
		       'billing_cust_city'     => $billing_city,
			   'billing_zip_code'      => $billing_zip,
			   'delivery_cust_city'    => $delivery_city,
			   'delivery_zip_code'     => $delivery_zip
        
            
            
        );
        

        
        
        // After testing the interface, we should hardcode them, it may be too risky to keep them as parameters
        
          $merchanturl = Mage::getStoreConfig('ccav/wps/merchant_url') ;
        
        
        
        /*

        $logoUrl = Mage::getStoreConfig('ccav/wps/logo_url');
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
       
 
            $businessName = Mage::getStoreConfig('ccav/wps/business_name');
            $storeName = Mage::getStoreConfig('store/system/name');
            $amount = ($a->getBaseSubtotal()+$b->getBaseSubtotal())-($a->getBaseDiscountAmount()+$b->getBaseDiscountAmount());

  
            $_shippingTax = $this->getQuote()->getShippingAddress()->getBaseTaxAmount();
            $_billingTax = $this->getQuote()->getBillingAddress()->getBaseTaxAmount();
            $tax = sprintf('%.2f', $_shippingTax + $_billingTax);
    

        $totalArr = $a->getTotals();
        $shipping = sprintf('%.2f', $this->getQuote()->getShippingAddress()->getBaseShippingAmount());

        
        $grand_total = $amount + $shipping + $tax ;
        
        $Checksum = $this->getcheckSum($Merchant_Id,$grand_total,$Order_Id ,$Redirect_Url,$WorkingKey);
        
        Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."Order Id\n".print_r($Order_Id,true)) ;
        Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."WorkingKey\n".print_r($WorkingKey,true)) ;
    Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."Redirect_Url\n".print_r($Redirect_Url,true)) ;
    Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."Amount\n".print_r($grand_total,true)) ;
    Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."CheckSum\n".print_r($Checksum,true)) ;
    
    
        
        $sArr = array_merge($sArr, array(
                    'Amount' => $grand_total,
                    'Checksum' => $Checksum
                ));
        
        $sReq = '';
        $sReqDebug = '';
        $rArr = array();


        foreach ($sArr as $k=>$v) {
            
           // replacing & char with and. otherwise it will break the post
            
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
            $debug = Mage::getModel('ccav/api_debug')
                    ->setApiEndpoint($this->getCcavUrl())
                    ->setRequestBody($sReq)
                    ->save();
        }
        
        
        Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n".print_r($rArr,true)) ;
        
        return $rArr;
    }

    public function getCcavUrl()
    {
    
 //        if (Mage::getStoreConfig('ccav/wps/sandbox_flag')==1) {
 //            $url='https://www.sandbox.paypal.com/cgi-bin/webscr';
     //    } else {
 //            $url='https://www.paypal.com/cgi-bin/webscr';
     //        $url='https://www.ccavenue.com/shopzone/cc_details.jsp';
             
  //       }
             $url = Mage::getStoreConfig('ccav/wps/merchant_url') ;
             
        	 return $url;
    }

    public function getDebug()
    {
        return Mage::getStoreConfig('ccav/wps/debug_flag');
    }


//  was public function ipnPostSubmit()in Paypal

    public function ccavPostResponse()
    
    {
    
    Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n") ;
    

    
 //   $WorkingKey = "" ; //put in the 32 bit working key in the quotes provided here
 	$WorkingKey = Mage::getStoreConfig('ccav/wps/checksum_key') ;
 		
	
	
 	$Amount= $_REQUEST['Amount'];
	$Merchant_Id= $_REQUEST['Merchant_Id'];
	
	$Order_Id= $_REQUEST['Order_Id'];
	$Merchant_Param= $_REQUEST['Merchant_Param'];
	$Checksum= $_REQUEST['Checksum'];
	$AuthDesc=$_REQUEST['AuthDesc'];
	
	$billing_cust_tel=$_REQUEST['billing_cust_tel'];
	
	    Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."billing_cust_tel\n".print_r($billing_cust_tel,true)) ;
	
 
	
		
    $Checksumcalc = $this->verifychecksum($Merchant_Id,$Order_Id,$Amount,$AuthDesc,$Checksum,$WorkingKey);
    
    Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."CheckSumCalc\n".print_r($Checksumcalc,true)) ;
    


	if($Checksumcalc=="true" && $AuthDesc=="Y")
	{
	//	echo "<br>Thank you for shopping with us. Your credit card has been charged and your transaction is successful. We will be shipping your order to you soon.";
        Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."Thank you for shopping with us. Your credit card has been charged and your transaction is successful. We will be shipping your order to you soon.\n") ;
		
		//Here you need to put in the routines for a successful 
		//transaction such as sending an email to customer,
		//setting database status, informing logistics etc etc
	}
	else if($Checksumcalc=="true" && $AuthDesc=="B")
	{
	//	echo "<br>Thank you for shopping with us.We will keep you posted regarding the status of your order through e-mail";
	
		    Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."Thank you for shopping with us.We will keep you posted regarding the status of your order through e-mail\n") ;
	
		
		//Here you need to put in the routines/e-mail for a  "Batch Processing" order
		//This is only if payment for this transaction has been made by an American Express Card
		//since American Express authorisation status is available only after 5-6 hours by mail from ccavenue and at the "View Pending Orders"
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
   
 

       
      	  $order = Mage::getModel('sales/order');
      	  $order->loadByIncrementId($Order_Id);  // we  the order with this id

      	  $msg = "$Merchant_Id|$Order_Id|$Amount|$AuthDesc|$WorkingKey|$Merchant_Param";
      	  
 
            if (!$order->getId()) {     //  If the above load of order does not happen i.e wrong order id from ccav
                /*
                * need to have logic when there is no order with the order id from CCav
                */
            
                Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n") ;
                return false ;
            

            } else {

          	  if ($this->getDebug() && $msg) {
          		//	  $sReq = substr($sReq, 1);
         			   $debug = Mage::getModel('ccav/api_debug')
            	        ->setApiEndpoint($this->getCcavUrl())
            	        ->setResponseBody($msg)
             	       ->save();
      		  }
 //       		  if ($Amount !=$order->getBaseGrandTotal()) {
      		  
      		  if ($Checksumcalc == true && $AuthDesc == "N") {
                    //It is an an error in paymemt
                     Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n") ;

//                   Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n".print_r($Order->getStatus(),true)) ;
                     
                  
                     //We have to differentiate here between Order declined or an American Express Order
                     
                    $order->addStatusToHistory(
                        $order->getStatus(),//continue setting current order status
                         Mage::helper('ccav')->__('Order Declined')
                        
                    );
                    
                    $order->save();
                    return false ;
                  
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
                
                    
                       
                           //need to convert from order into invoice
                    $invoice = $order->prepareInvoice();
                    $invoice->register()->pay();
                    
                    Mage::getModel('core/resource_transaction')
                            ->addObject($invoice)
                            ->addObject($invoice->getOrder())
                            ->save();
                            
                           $order->setState(
                               Mage_Sales_Model_Order::STATE_PROCESSING, true,
                               Mage::helper('ccav')->__('Invoice #%s created', $invoice->getIncrementId()),
                               $notified = true
                           );
                       
           
                       
                    $order->save();

                    $order->sendNewOrderEmail();  // should we send an email now ?
                    $this->sendsms($billing_cust_tel,$Order_Id);
                 
					return true ;
               }//
                // it may be a JCB Card or rare american expresss charges that is autorized after a delay
                // 
                
                elseif (($Checksumcalc == true) && ($AuthDesc == "B")) {
                
              
                
                Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."JCB Or delayed Authorized\n") ;
                
                    
                       
                           //need to convert from order into invoice
                           
                   /* $invoice = $order->prepareInvoice();
                    $invoice->register()->pay();
                    
                    Mage::getModel('core/resource_transaction')
                            ->addObject($invoice)
                            ->addObject($invoice->getOrder())
                            ->save();
                            
                           $order->setState(
                               Mage_Sales_Model_Order::STATE_PROCESSING, true,
                               Mage::helper('ccav')->__('Invoice #%s created', $invoice->getIncrementId()),
                               $notified = true
                           );
                       */
       
        //           Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n".print_r($r_txnrefid,true)) ;
        //           Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n".print_r($order->getpayment()->getTransactionID(),true)) ;
        
                 $order->addStatusToHistory(
                        $order->getStatus(),//continue setting current order status
  //                      Mage::helper('paypal')->__('Order total amount does not match paypal gross total amount')
                         Mage::helper('ccav')->__('Order JCB or American Express Delayed')
                        
                    );
                    $order->save();
                    return true ;
                   

               } else { // sercurity error
               
                 Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n") ;
                  
                   //we have to figure out how to say in Order that it is declined
                     
                    $order->addStatusToHistory(
                        $order->getStatus(),//continue setting current order status
                         Mage::helper('ccav')->__('Security Error')
                        
                    );
                    $order->save();
                    return false ;
                 }
            
               
            }
    }
    
 
        
 

    public function isInitializeNeeded()
    {
        return true;
    }

    public function initialize($paymentAction, $stateObject)
    {
    
    Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n") ;
    
    	$paymGateway = Mage::getStoreConfig('payment/ccav/title') ;   
  	    Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n".print_r($paymGateway,true)) ;
  	    
        $state = Mage_Sales_Model_Order::STATE_PENDING_PAYMENT;
        $stateObject->setState($state);
        $stateObject->setStatus("pending_ccav");  
        $stateObject->setIsNotified(false);
        
    Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__.":".print_r($stateObject->getStatus(),true)."\n") ;
        
    }

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
 
}
/*
<form method="post" action="https://www.ccavenue.com/shopzone/cc_details.jsp">
	<input type=hidden name=Merchant_Id value="<?php echo $Merchant_Id; ?>">
	<input type=hidden name=Amount value="<?php echo $Amount; ?>">
	<input type=hidden name=Order_Id value="<?php echo $Order_Id; ?>">
	<input type=hidden name=Redirect_Url value="<?php echo $Redirect_Url; ?>">
	<input type=hidden name=Checksum value="<?php echo $Checksum; ?>">
	<input type="hidden" name="billing_cust_name" value="<?php echo $billing_cust_name; ?>"> 
	<input type="hidden" name="billing_cust_address" value="<?php echo $billing_cust_address; ?>"> 
	<input type="hidden" name="billing_cust_country" value="<?php echo $billing_cust_country; ?>"> 
	<input type="hidden" name="billing_cust_state" value="<?php echo $billing_cust_state; ?>"> 
	<input type="hidden" name="billing_zip" value="<?php echo $billing_zip; ?>"> 
	<input type="hidden" name="billing_cust_tel" value="<?php echo $billing_cust_tel; ?>"> 
	<input type="hidden" name="billing_cust_email" value="<?php echo $billing_cust_email; ?>"> 
	<input type="hidden" name="delivery_cust_name" value="<?php echo $delivery_cust_name; ?>"> 
	<input type="hidden" name="delivery_cust_address" value="<?php echo $delivery_cust_address; ?>"> 
	<input type="hidden" name="delivery_cust_country" value="<?php echo $delivery_cust_country; ?>"> 
	<input type="hidden" name="delivery_cust_state" value="<?php echo $delivery_cust_state; ?>"> 
	<input type="hidden" name="delivery_cust_tel" value="<?php echo $delivery_cust_tel; ?>"> 
	<input type="hidden" name="delivery_cust_notes" value="<?php echo $delivery_cust_notes; ?>"> 
	<input type="hidden" name="Merchant_Param" value="<?php echo $Merchant_Param; ?>"> 
	<input type="hidden" name="billing_cust_city" value="<?php echo $billing_city; ?>"> 
	<input type="hidden" name="billing_zip_code" value="<?php echo $billing_zip; ?>"> 
	<input type="hidden" name="delivery_cust_city" value="<?php echo $delivery_city; ?>"> 
	<input type="hidden" name="delivery_zip_code" value="<?php echo $delivery_zip; ?>"> 
	<INPUT TYPE="submit" value="submit">
	*/
