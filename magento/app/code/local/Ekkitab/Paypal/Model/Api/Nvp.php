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
 * NVP API wrappers model
 * 
 * Overwriting the AddressOverride property 'ADDROVERRIDE' to 0 from 1
 *
 */


class Ekkitab_Paypal_Model_Api_Nvp extends Mage_Paypal_Model_Api_Nvp
{
    

    /**
     * SetExpressCheckout API call
     *
     * An express checkout transaction starts with a token, that
     * identifies to PayPal your transaction
     * In this example, when the script sees a token, the script
     * knows that the buyer has already authorized payment through
     * paypal.  If no token was found, the action is to send the buyer
     * to PayPal to first authorize payment
     */
    public function callSetExpressCheckout()
    {
        //------------------------------------------------------------------------------------------------------------------------------------
        // Construct the parameter string that describes the SetExpressCheckout API call

        $nvpArr = array(
            'PAYMENTACTION' => $this->getPaymentType(),
            'AMT'           => $this->getAmount(),
            'CURRENCYCODE'  => $this->getCurrencyCode(),
            'RETURNURL'     => $this->getReturnUrl(),
            'CANCELURL'     => $this->getCancelUrl(),
            'INVNUM'        => $this->getInvNum()
        );

        if ($this->getPageStyle()) {
            $nvpArr = array_merge($nvpArr, array(
                'PAGESTYLE' => $this->getPageStyle()
            ));
        }

        $this->setUserAction(self::USER_ACTION_CONTINUE);

        // for mark SetExpressCheckout API call
        if ($a = $this->getShippingAddress()) {
            $nvpArr = array_merge($nvpArr, array(
                'ADDROVERRIDE'      => 0,
                'SHIPTONAME'        => $a->getName(),
                'SHIPTOSTREET'      => $a->getStreet(1),
                'SHIPTOSTREET2'     => $a->getStreet(2),
                'SHIPTOCITY'        => $a->getCity(),
                'SHIPTOSTATE'       => $a->getRegionCode(),
                'SHIPTOCOUNTRYCODE' => $a->getCountry(),
                'SHIPTOZIP'         => $a->getPostcode(),
                'PHONENUM'          => $a->getTelephone(),
            ));
            $this->setUserAction(self::USER_ACTION_COMMIT);
        }

        //'---------------------------------------------------------------------------------------------------------------
        //' Make the API call to PayPal
        //' If the API call succeded, then redirect the buyer to PayPal to begin to authorize payment.
        //' If an error occured, show the resulting errors
        //'---------------------------------------------------------------------------------------------------------------
        $resArr = $this->call('SetExpressCheckout', $nvpArr);

        if (false===$resArr) {
            return false;
        }

        $this->setToken($resArr['TOKEN']);
        $this->setRedirectUrl($this->getPaypalUrl());
        return $resArr;
    }

 }
