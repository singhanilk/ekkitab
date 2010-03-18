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
class Ekkitab_Billdesk_StandardController extends Mage_Core_Controller_Front_Action
{
    
    /**
     * Order instance
     */
    protected $_order;

    /**
     *  Get order
     *
     *  @return	  Mage_Sales_Model_Order
     */
    public function getOrder()
    {
        if ($this->_order == null) {  // IT DOES NOT MAKE SENSE
        }
        return $this->_order;
    }

    protected function _expireAjax()
    {
        if (!Mage::getSingleton('checkout/session')->getQuote()->hasItems()) {
            $this->getResponse()->setHeader('HTTP/1.1','403 Session Expired');
            exit;
        }
    }

    /**
     * Get singleton with paypal strandard order transaction information
     *
     * @return Mage_Paypal_Model_Standard
     */
    public function getStandard()
    {
        return Mage::getSingleton('billdesk/billdesk');
    }

    /**
     * When a customer chooses Paypal on Checkout/Payment page
     *
     */
    public function redirectAction()
    {
    
       Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n") ;  
    
        $session = Mage::getSingleton('checkout/session');
        $session->setPaypalStandardQuoteId($session->getQuoteId());
        $this->getResponse()->setBody($this->getLayout()->createBlock('billdesk/redirect')->toHtml());
        $session->unsQuoteId();
        
        Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n") ;
        
    }

    /**
     * When a customer cancel payment from paypal.
     */
    public function cancelAction()
    {
        $session = Mage::getSingleton('checkout/session');
        $session->setQuoteId($session->getPaypalStandardQuoteId(true));

        // cancel order
        if ($session->getLastRealOrderId()) {
            $order = Mage::getModel('sales/order')->loadByIncrementId($session->getLastRealOrderId());
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

   

    /**
     * when paypal returns via ipn
     * cannot have any output here
     * validate IPN data
     * if data is valid need to update the database that the user has
     */
    public function successAction()
    
    {
       Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n") ;  
    
    // to do testing, we will remove the next line
    
      $this->getStandard()->billdeskPostResponse() ;   //delete it later
       
       
    if (!$this->getRequest()->isPost()) {
           Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n") ;  
    
            $this->_redirect('');
            return;
        }

        if($this->getStandard()->getDebug()){
            $debug = Mage::getModel('bildesk/api_debug')
                ->setApiEndpoint($this->getStandard()->getBilldeskUrl())
                ->setResponseBody(print_r($this->getRequest()->getPost(),1))
                ->save();
        }
       Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n") ;  
       
     
        
        $this->_redirect('checkout/onepage/success', array('_secure'=>true));
        
  
        $this->getStandard()->setBillFormData($this->getRequest()->getPost());
        
  			if  ( $this->getStandard()->billdeskPostResponse()) { //
  					$this->_redirect('checkout/onepage/success', array('_secure'=>true));
  			}
  			else {
  			 		$this->_redirect('checkout/onepage/failure', array('_secure'=>true));
  			
  			};
    }
    
}
