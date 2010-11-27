<?php
/**
 * Magento
 *
 * NOTICE OF LICENSE
 *
 * This source file is subject to the Open Software License (OSL 3.0)
 * that is bundled with this package in the file LICENSE.txt.
 * It is also available through the world-wide-web at this URL:
 * http://opensource.org/licenses/osl-3.0.php
 * If you did not receive a copy of the license and are unable to
 * obtain it through the world-wide-web, please send an email
 * to license@magentocommerce.com so we can send you a copy immediately.
 *
 * DISCLAIMER
 *
 * Do not edit or add to this file if you wish to upgrade Magento to newer
 * versions in the future. If you wish to customize Magento for your
 * needs please refer to http://www.magentocommerce.com for more information.
 *
 * @category   Mage
 * @package    Ekkitab_Institute
 * @copyright  Copyright (c) 2008 Irubin Consulting Inc. DBA Varien (http://www.varien.com)
 * @license    http://opensource.org/licenses/osl-3.0.php  Open Software License (OSL 3.0)
 */

/**
 * Customer edit form block
 *
 * @category   Mage
 * @package    Ekkitab_Institute
 * @author      Magento Core Team <core@magentocommerce.com>
 */
class Ekkitab_Institute_Block_Form_Edit extends Mage_Core_Block_Template
{

    private $_institute;

    protected function _prepareLayout()
    {
		if ($headBlock = $this->getLayout()->getBlock('head')) {
			$headBlock->setTitle(Mage::helper('ekkitab_institute')->__("Edit Institute Account"));
			$headBlock->setOpenGraphSiteName("Ekkitab.com");
			$headBlock->setFacebookAdmin("ekkitab");
		}
		if ($breadcrumbs = $this->getLayout()->getBlock('breadcrumbs')){
			$breadcrumbs->addCrumb('home', array(
				'label'=>Mage::helper('ekkitab_institute')->__('Home'),
				'title'=>Mage::helper('ekkitab_institute')->__('Go to Home Page'),
				'link'=>Mage::getBaseUrl()
			));
			$breadcrumbs->addCrumb('myInstitutes', array(
				'label'=>Mage::helper('ekkitab_institute')->__('Manage Institutes'),
				'title'=>Mage::helper('ekkitab_institute')->__('Manage Institutes'),
				'link'=>$this->getUrl('ekkitab_institute/search/myInstitutes')
			));
			$breadcrumbs->addCrumb('Edit Institute', array(
				'label'=>Mage::helper('ekkitab_institute')->__('Edit Institute'),
				'title'=>Mage::helper('ekkitab_institute')->__('Edit Institute'),
				'link'=>''
			));
		}
        return parent::_prepareLayout();
		
    }

	public function getInstitute()
    {
		if(is_null($this->_institute)){
			if (!Mage::registry('instituteId')) {
				//Mage::unregister('productId');
				Mage::register('instituteId', Mage::helper('ekkitab_institute')->getInstituteId());
			}
			$this->_institute = Mage::getModel('ekkitab_institute/institute')->load(Mage::registry('instituteId'));
		}
		if($this->_institute->getId() > 0){
			return $this->_institute;
		} else {
			return null;
		}
    }

	public function getInstituteTypeHtmlSelect($defValue=null)
    {
       
		Varien_Profiler::start('TEST: '.__METHOD__);
		if (is_null($defValue)) {
			$defValue = $this->getInstitute()->getTypeId();
		}
		$options = Mage::helper('ekkitab_institute')->getTypes()->toOptionArray();
		$html = $this->getLayout()->createBlock('core/html_select')
            ->setName('type_id')
            ->setTitle(Mage::helper('core')->__('Institute Type'))
            ->setId('type')
            ->setClass('required-entry validate-select')
            ->setValue($defValue)
            ->setOptions(array_merge(array(array('value'=>'','label'=>'Please select your institute type')),$options))
            ->getHtml();
        Varien_Profiler::start('TEST: '.__METHOD__);
        return $html;
    }




}
