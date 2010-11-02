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
	public function listAllAction()
    {
		$this->loadLayout();
		$this->_initLayoutMessages('checkout/session');
		$this->renderLayout();

    }


}
