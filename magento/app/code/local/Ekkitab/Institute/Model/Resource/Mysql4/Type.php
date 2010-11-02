<?php

/**
 * Ekkitab Institute  Types model
 *
 * @author      Anisha 
 */
class Ekkitab_Institute_Model_Resource_Mysql4_Type extends Mage_Core_Model_Mysql4_Abstract
{
    protected function _construct()
    {
        $this->_init('ekkitab_institute/institute_type', 'id');
    }
}