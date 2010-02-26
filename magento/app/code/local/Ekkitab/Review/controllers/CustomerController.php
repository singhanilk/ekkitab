<?php

/**
 * Customer reviews controller
 *
 * @category   Ekkitab
 * @package    Ekkitab_Review
 * @author     Ekkitab Core Team <anisha@ekkitab.com>
 */
require_once 'Mage/Review/controllers/CustomerController.php';

class Ekkitab_Review_CustomerController extends Mage_Review_CustomerController
{
    public function indexAction()
    {
        $this->loadLayout();
        $this->_initLayoutMessages('catalog/session');

        if ($navigationBlock = $this->getLayout()->getBlock('customer_account_navigation')) {
            $navigationBlock->setActive('review/customer');
        }
        if ($block = $this->getLayout()->getBlock('ekkitab_review_customer_list')) {
            $block->setRefererUrl($this->_getRefererUrl());
        }

        $this->getLayout()->getBlock('head')->setTitle($this->__('My Product Reviews'));

        $this->renderLayout();
    }

}