<?php

class Mage_AdvancedSmtp_Model_Config_Source_Ssl
{
    public function toOptionArray()
    {
        return array(
            array('value'=>0, 'label'=>'No'),
            array('value'=>1, 'label'=>'Yes (tls)'),
						array('value'=>2, 'label'=>'Yes (ssl)')
        );
    }
}