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
 * @package    Mage_Paypal
 * @copyright  Copyright (c) 2008 Irubin Consulting Inc. DBA Varien (http://www.varien.com)
 * @license    http://opensource.org/licenses/osl-3.0.php  Open Software License (OSL 3.0)
 */


/**
 * Paypal Standard Checkout Controller
 *
 * @category   Mage
 * @package    Mage_Paypal
 * @author      Magento Core Team <core@magentocommerce.com>
 */

require_once 'Mage/Paypal/controllers/StandardController.php';

class Ekkitab_Paypal_StandardController extends Mage_Paypal_StandardController 
{
    
   
    /**
     * when paypal returns
     * The order information at this point is in POST
     * variables.  However, you don't want to "process" the order until you
     * get validation from the IPN.
     */
    public function  successAction()
    {
        $session = Mage::getSingleton('checkout/session');
        $session->setQuoteId($session->getPaypalStandardQuoteId(true));
        /**
         * set the quote as inactive after back from paypal
         * 
         * 
         */
        
 //         Mage::getSingleton('checkout/session')->getQuote()->setIsActive(false)->save();
          
          if (Mage::getSingleton('checkout/session')->getQuote()->getIsMultiShipping()){
                
                    $Merchant_Param="M" ; 
                    Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."AKS _Checkout_Model_Type_Multishipping\n") ;
                      
    				$Order_Ids    =  Mage::getSingleton('core/session')->getOrderIds();
	                Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."Multiship Returned from Paypal\n".print_r($Order_Ids,true)) ;
	                
          }
          else {
                      $Merchant_Param="S" ; 
                      Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."Akse_Checkout_Model_Type_Onepage\n") ;
                      
                      $Order_Id=  Mage::getSingleton('checkout/session')->getQuote()->getLastRealOrderId();  // for single shipment order 
                      Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."Singleship Returned from Paypal\n".print_r($Order_Id,true)) ;
                      
                      
       	 }
    
        Mage::getSingleton('checkout/session')->getQuote()->setIsActive(false)->save();

        //Mage::getSingleton('checkout/session')->unsQuoteId();
        
      if ($Merchant_PARAM="S")
        	$this->_redirect('checkout/onepage/success', array('_secure'=>true));
      else
       		$this->_redirect('checkout/multishipping/success');
        
    }
    
    
    
    /**
     * When a customer cancel payment from paypal.
     */
    public function cancelAction()
    {
        $session = Mage::getSingleton('checkout/session');
        $session->setQuoteId($session->getPaypalStandardQuoteId(true));

        // cancel order
     /*   if ($session->getLastRealOrderId()) {
            $order = Mage::getModel('sales/order')->loadByIncrementId($session->getLastRealOrderId());
            if ($order->getId()) {
                $order->cancel()->save();
            }
        }
        */
 
          if (Mage::getSingleton('checkout/session')->getQuote()->getIsMultiShipping()){
                
                    $Merchant_Param="M" ; 
                    Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."AKS _Checkout_Model_Type_Multishipping\n") ;
                      
    				$Order_Ids    =  Mage::getSingleton('core/session')->getOrderIds();
	                Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."Multiship Returned from Paypal\n".print_r($Order_Ids,true)) ;
	                
          }
          else {
                      $Merchant_Param="S" ; 
                      Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."Akse_Checkout_Model_Type_Onepage\n") ;
                      
                      $Order_Id=  Mage::getSingleton('checkout/session')->getQuote()->getLastRealOrderId();  // for single shipment order 
                      Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."Singleship Returned from Paypal\n".print_r($Order_Id,true)) ;
                      $Order_Ids[] = $Order_Id ;
                      
                      
       	 }
       	  foreach($Order_Ids as $key => $orid ) {
          	                Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n".print_r($orid,true)) ;
         	 $Order_Id = $orid ;
      	 	 $order = Mage::getModel('sales/order');
      	 	 $order->loadByIncrementId($Order_Id);  // 
       	 	 if ($order->getId()) {
                $order->cancel()->save();
            }
      	 	 
       	  }
    
        /*we are calling getPaypalStandardQuoteId with true parameter, the session object will reset the session if parameter is true.
        so we don't need to manually unset the session*/
        //$session->unsPaypalStandardQuoteId();

        //need to save quote as active again if the user click on cacanl payment from paypal
        //Mage::getSingleton('checkout/session')->getQuote()->setIsActive(true)->save();
        //and then redirect to checkout one page
        $this->_redirect('checkout/cart');
    }
    

      
}

