<?php
/**
 */

/**
 * Institute search controller
 *
 * @category   Ekkitab
 * @package    Ekkitab_Institute
 * @author     Ekkitab Team 
 */
class Ekkitab_Institute_SearchController extends Mage_Core_Controller_Front_Action
{
    public function preDispatchMyInstitutes()
    {
        if (!Mage::getSingleton('customer/session')->authenticate($this)) {
            $this->setFlag('', 'no-dispatch', true);
            Mage::getSingleton('customer/session')->setBeforeMyInstitutesUrl('my-institutes');
        }
    }

	public function listAllAction()
    {
		$this->loadLayout();
		$this->_initLayoutMessages('checkout/session');
		$this->renderLayout();

    }

	public function indexAction()
    {
		$queryText = trim($this->getRequest()->getParam(Mage::helper('ekkitab_institute')->getQueryParamName()));
		if (is_null($queryText) || $queryText === null || $queryText=='') {
			$this->_redirect('institutes');
		}else{
			$this->loadLayout();
			$this->_initLayoutMessages('checkout/session');
			$this->renderLayout();
		}

    }

	public function myInstitutesAction()
    {
		$this->preDispatchMyInstitutes();
		$this->loadLayout();
		$this->_initLayoutMessages('checkout/session');
		$this->renderLayout();

    }


}
