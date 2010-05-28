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
 * Paypal data helper
 */
class Ekkitab_Ccav_Helper_Data extends Mage_Core_Helper_Abstract
{

 public function sendsms($recepientno,$Order_Id)
    {
    $recepientno =  preg_replace('/[^0-9]/','',$recepientno);
    	
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
public function sendsms1($recepientno,$Order_Id)
    {
    Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__." $recepientno | $Order_Id ") ;
    	
    $recepientno =  preg_replace('/[^0-9]/','',$recepientno);
    	
    $user="anil@ekkitab.com:meritos1959";
    $senderID="EKKITAB1";
    $msgtxt="Thank you for shopping with EkKitab. Your Order Id $Order_Id has been shipped";
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
}
 

	



