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
 * Customer register form block
 *
 * @author      Magento Core Team <core@magentocommerce.com>
 */
class Ekkitab_Institute_Block_Form_Register extends Mage_Directory_Block_Data
{
    protected function _prepareLayout()
    {
		if ($headBlock = $this->getLayout()->getBlock('head')) {
			$headBlock->setTitle(Mage::helper('ekkitab_institute')->__("Create New Institute Account"));
			$headBlock->setOpenGraphSiteName("Ekkitab.com");
			$headBlock->setFacebookAdmin("ekkitab");
		}
		if ($breadcrumbs = $this->getLayout()->getBlock('breadcrumbs')){
			$breadcrumbs->addCrumb('home', array(
				'label'=>Mage::helper('ekkitab_institute')->__('Home'),
				'title'=>Mage::helper('ekkitab_institute')->__('Go to Home Page'),
				'link'=>Mage::getBaseUrl()
			));
			$breadcrumbs->addCrumb('Create Institute', array(
				'label'=>Mage::helper('ekkitab_institute')->__('Create Institute'),
				'title'=>Mage::helper('ekkitab_institute')->__('Create Institute'),
				'link'=>''
			));
		}
        return parent::_prepareLayout();
		
    }


    /**
     * Retrieve form posting url
     *
     * @return string
     */
    public function getPostActionUrl()
    {
        return $this->helper('ekkitab_institute')->getRegisterPostUrl();
    }

    /**
     * Retrieve back url
     *
     * @return string
     */
    public function getBackUrl()
    {
        $url = $this->getData('back_url');
        if (is_null($url)) {
            //$url = Mage::Helper()->getUrl('home');
        }
        return $url;
    }

    /**
     * Retrieve form data
     *
     * @return Varien_Object
     */
    public function getFormData()
    {
        $data = $this->getData('form_data');
        if (is_null($data)) {
            $data = new Varien_Object(Mage::getSingleton('core/session')->getInstituteFormData(true));
            $this->setData('form_data', $data);
        }
        return $data;
    }

    /**
     * Retrieve customer country identifier
     *
     * @return int
     */
    public function getCountryId()
    {
        if ($countryId = $this->getFormData()->getCountryId()) {
            return $countryId;
        }
        return parent::getCountryId();
    }

	public function getTypeId()
    {
		return $this->getFormData()->getTypeId();
    }


    public function getInstituteTypeHtmlSelect($defValue=null)
    {
        Varien_Profiler::start('TEST: '.__METHOD__);
		if (is_null($defValue)) {
			$defValue = $this->getTypeId();
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

    /**
     * Retrieve customer region identifier
     *
     * @return int
     */
    public function getRegion()
    {
        if ($region = $this->getFormData()->getRegion()) {
            return $region;
        }
        elseif ($region = $this->getFormData()->getRegionId()) {
            return $region;
        }
        return null;
    }

}