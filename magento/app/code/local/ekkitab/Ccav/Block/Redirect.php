<?php

class Ekkitab_Ccav_Block_Redirect extends Mage_Core_Block_Abstract
{
    protected function _toHtml()
    {
    
        Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n") ;
    
        $ccav = Mage::getModel('ccav/ccav');
        
        

        $form = new Varien_Data_Form();
        $form->setAction($ccav->getCcavUrl())
            ->setId('ccav_checkout')
            ->setName('ccav_checkout')
            ->setMethod('POST')
            ->setUseContainer(true);
            
            
            
        foreach ($ccav->getStandardCheckoutFormFields() as $field=>$value) {
            $form->addField($field, 'hidden', array('name'=>$field, 'value'=>$value));
        }
        
        
        $html = '<html><body>';
 //       $html.= $this->__('You will be redirected to CCavenue in a few seconds.');
        $html.= $this->__(' ');
        
        $html.= $form->toHtml();
        $html.= '<script type="text/javascript">document.getElementById("ccav_checkout").submit();</script>';
        $html.= '</body></html>';

       Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n".print_r($html,true)) ;
       
       
        
        return $html;
    }
}