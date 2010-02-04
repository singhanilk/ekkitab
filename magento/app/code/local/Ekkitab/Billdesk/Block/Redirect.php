<?php

class Ekkitab_Billdesk_Block_Redirect extends Mage_Core_Block_Abstract
{
    protected function _toHtml()
    {
    
        Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n") ;
    
        $billdesk = Mage::getModel('billdesk/billdesk');
        
        

        $form = new Varien_Data_Form();
        $form->setAction($billdesk->getBilldeskUrl())
            ->setId('billdesk_checkout')
            ->setName('billdesk_checkout')
            ->setMethod('POST')
            ->setUseContainer(true);
            
            
            
        foreach ($billdesk->getStandardCheckoutFormFields() as $field=>$value) {
            $form->addField($field, 'hidden', array('name'=>$field, 'value'=>$value));
        }
        
        
        $html = '<html><body>';
        $html.= $this->__('You will be redirected to Billdesk in a few seconds.');
        $html.= $form->toHtml();
        $html.= '<script type="text/javascript">document.getElementById("billdesk_checkout").submit();</script>';
        $html.= '</body></html>';

       Mage::log("/n".__FILE__."(".__LINE__.")".__METHOD__."\n".print_r($html,true)) ;
       
       
        
        return $html;
    }
}