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
 * @package    Ekkitab_Ccav
 * @copyright  Copyright (c) 2008 Irubin Consulting Inc. DBA Varien (http://www.varien.com)
 * 			   Copyright (c) 2009 Ekkitab Educational Services India Pvt. Ltd.  
 * 
 * @license    http://opensource.org/licenses/osl-3.0.php  Open Software License (OSL 3.0)
 */


/**
 * Ekkitab Standard Checkout Controller
 *
 * @category   Ekkitab
 * @package    Ekkitab_Ccav
 * @author     Magento Core Team <core@magentocommerce.com>, Ekkitab
 */
class Ekkitab_Ccav_StandardController extends Mage_Core_Controller_Front_Action
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

    protected function _expireAjax()  // What does this do?
    {
        if (!Mage::getSingleton('checkout/session')->getQuote()->hasItems()) {
            $this->getResponse()->setHeader('HTTP/1.1','403 Session Expired');
            exit;
        }
    }

    /**
     * Get singleton with Ccav strandard order transaction information
     *
     * @return Mage_Ccav_Model_Ccav
     */
    public function getStandard()
    {
        return Mage::getSingleton('ccav/ccav');
    }

    /**
     * When a customer chooses CCav on Checkout/Payment page
     *
     */
    public function redirectAction()
    {
    
       Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n") ;  
    
        $session = Mage::getSingleton('checkout/session');
 //       $session->setPaypalStandardQuoteId($session->getQuoteId());  // How does this work ?
        $this->getResponse()->setBody($this->getLayout()->createBlock('ccav/redirect')->toHtml());
        $session->unsQuoteId();
        
        Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n") ;
        
    }

    /**
     * When a customer cancel payment from paypal. WE WILL NOT USE IT SO, WE WILL REMOVE IT.
     */
    
  /*  
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

        //we are calling getPaypalStandardQuoteId with true parameter, the session object will reset the session if parameter is true.
        //so we don't need to manually unset the session
        //$session->unsPaypalStandardQuoteId();

        //need to save quote as active again if the user click on cacanl payment from paypal
        //Mage::getSingleton('checkout/session')->getQuote()->setIsActive(true)->save();
        //and then redirect to checkout one page
        $this->_redirect('checkout/cart');
    }
    
   */ 

   

    /**
     * when paypal returns via ipn
     * cannot have any output here
     * validate IPN data
     * if data is valid need to update the database that the user has
     */
    
    /* When CCAvenue returns after the user chooses to return to the website.
     * How will we take care of the case where user does not return to web page ?
     * In those cases, we need to check CCavenue website and go from pending_ccav
     * to authorised_ccav state.
     * 
     *  */
    public function ccavresponseAction()
    
    {
       Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n") ; 

      
    // to do testing, afterwards we will remove the next line
    
//      $this->getStandard()->ccavPostResponse() ;   //delete it later
      
//	    $this->_redirect('checkout/onepage/success', array('_secure'=>true));
       
         
       
       
    if (!$this->getRequest()->isPost()) {
           Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n") ;  
    
            $this->_redirect('');
            return;
        }

        if($this->getStandard()->getDebug()){
            $debug = Mage::getModel('ccav/api_debug')
                ->setApiEndpoint($this->getStandard()->getCcavUrl())
                ->setResponseBody(print_r($this->getRequest()->getPost(),1))
                ->save();
        }
       Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n") ;  
       
     
    // to do testing, afterwards we will remove the next line
       
   //     $this->_redirect('checkout/onepage/success', array('_secure'=>true));
        
  
        $this->getStandard()->setBillFormData($this->getRequest()->getPost());  // what this does ??
        
  			if  ( $this->getStandard()->ccavPostResponse()) { //
  					$this->_redirect('checkout/onepage/success', array('_secure'=>true));
  			}
  			else {
  			 		$this->_redirect('checkout/onepage/failure', array('_secure'=>true));
  			
  			};
    }
    
}
