<?php
/**
 * Magento ArtsOnIt Advanced Smtp
 *
 * @category   ArtsOnIt
 * @package    Mage_AdvanceSmtp
 * @copyright  Copyright (c) 2008 ArtsOn.IT(http://www.ArtsOn.it)
 * @author     Calore Luca Erico (l.calore@ArtsOn.it)
 */

class Mage_Advancedsmtp_Helper_Data extends Mage_Core_Helper_Abstract
{
	public function getTransport()
    {
   $config = array(
			'port' => Mage::getStoreConfig('advancedsmtp/settings/port')
		);
		$config_auth = Mage::getStoreConfig('advancedsmtp/settings/auth');
		if ($config_auth != 'none')
		{
			$config['auth'] = $config_auth;
			$config['username'] = Mage::getStoreConfig('advancedsmtp/settings/username');
			$config['password'] = Mage::getStoreConfig('advancedsmtp/settings/password');
		}
		if (Mage::getStoreConfig('advancedsmtp/settings/ssl')!= 0)
		{
			$config['ssl'] = (Mage::getStoreConfig('advancedsmtp/settings/ssl') == 1) ? 'tls' :'ssl';
		}
		$transport = new Zend_Mail_Transport_Smtp(Mage::getStoreConfig('advancedsmtp/settings/host'), $config);
		return $transport;
    }
}

