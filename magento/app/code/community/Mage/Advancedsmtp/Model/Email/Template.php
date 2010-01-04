<?php
/**
 * Magento ArtsOnIt Advanced Smtp
 *
 * @category   ArtsOnIt
 * @package    Mage_AdvanceSmtp
 * @copyright  Copyright (c) 2008 ArtsOn.IT(http://www.ArtsOn.it)
 * @author     Calore Luca Erico (l.calore@ArtsOn.it)
 */
class Mage_Advancedsmtp_Model_Email_Template extends Mage_Core_Model_Email_Template
{
    public function send($email, $name=null, array $variables = array())
    {
		if (!Mage::getStoreConfig('advancedsmtp/settings/enabled'))
		{
			return parent::send($email, $name, $variables);
		}
        if(!$this->isValidForSend()) {
            return false;
        }

        if (is_null($name)) {
            $name = substr($email, 0, strpos($email, '@'));
        }

        $variables['email'] = $email;
        $variables['name'] = $name;

        $mail = $this->getMail();
        if (is_array($email)) {
            foreach ($email as $emailOne) {
            	$mail->addTo($emailOne, $name);
            }
        }
        else {
            $mail->addTo($email, $name);
        }

        $this->setUseAbsoluteLinks(true);
        $text = $this->getProcessedTemplate($variables, true);

        if($this->isPlain()) {
            $mail->setBodyText($text);
        } else {
            $mail->setBodyHTML($text);
        }

        $mail->setSubject($this->getProcessedTemplateSubject($variables));
        $mail->setFrom($this->getSenderEmail(), $this->getSenderName());
		
		$transport = Mage::helper('advancedsmtp')->getTransport();
		try {
            $mail->send($transport); // Zend_Mail warning..
            $this->_mail = null;
        }
        catch (Exception $e) {
            return false;
        }
        return true;
    }
}