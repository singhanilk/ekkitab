<?php

class Mage_AdvancedSmtp_Model_Config_Source_Auth
{
    public function toOptionArray()
    {
        return array(
            array('value'=>'none', 'label'=>'None'),
            array('value'=>'plain', 'label'=>'Plain'),
			array('value'=>'login', 'label'=>'Login'),
			array('value'=>'crammd5', 'label'=>'CRAM-MD5'),
        );
    }
}