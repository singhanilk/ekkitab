<?php
/**
 * Catalog Custom search model
 * @category   Local/Ekkitab
 * @package    Ekkitab_CatalogSearch_Model
 * @author Anisha (anisha@ekkitab.com)
 * @version 1.0 Dec 7, 2009
 * 
 * @package    Local_Ekkitab
 * @copyright  COPYRIGHT (C) 2009 Ekkitab Educational Services India Pvt. Ltd.
 * @license    All Rights Reserved. All material contained in this file (including, but not limited to, text, images, graphics, HTML, programming code and scripts) 
 * constitute proprietary and  * confidential information protected by copyright laws, trade secret and other laws. No part of this software may be copied, reproduced, modified or 
 * distributed in any form or by any means, or stored in a database or retrieval system without the prior written permission of Ekkitab Educational Services.
 * 
 */

class Ekkitab_CatalogSearch_Model_Custom extends Varien_Object
{
    /**
     * User friendly search criteria list
     *
     * @var array
     */
   
	private $_searchCriterias = array(); //right now not sure what and where this variable is used.

    public function getAttributes($attributeCode)
    {
        $attributes = $this->getData('attributes');
        if (is_null($attributes)) {
            $product = Mage::getModel('catalog/product');
            $attributes = Mage::getResourceModel('eav/entity_attribute_collection')
                ->setEntityTypeFilter($product->getResource()->getTypeId())
				->setCodeFilter($attributeCode)
                ->load();
            foreach ($attributes as $attribute) {
                $attribute->setEntity($product->getResource());
            }
            $this->setData('attributes', $attributes);
        }
        return $attributes;
    }

    /**
     * Add advanced search filters to product collection
     *
     * @param   array $values
     * @return  Mage_CatalogSearch_Model_Advanced
     */
    public function addAuthorTitleFilters($values)
    {

       $allConditions = array();
       if (isset($values[Mage::helper('ekkitab_catalogsearch')->getQueryParamName()])) {
		   
		   $value=$values[Mage::helper('ekkitab_catalogsearch')->getQueryParamName()];
			if (isset($values["searchBy"]))
			{
				$attributeCode=$values["searchBy"];
				//ideally this will be only one attribute..for now let it be an array.
				$attributes = $this->getAttributes($attributeCode);
				foreach ($attributes as $attribute) {
					
					$condition = false;
					
					if (strlen($value)>0) {
						if (in_array($attribute->getBackend()->getType(), array('varchar', 'text'))) {
							$condition = array('like'=>'%'.$value.'%');
						} elseif ($attribute->getFrontendInput() == 'boolean') {
							$condition = array('in' => array('0','1'));
						} else {
							$condition = $value;
						}
					}
					if (false !== $condition) {
						
						$this->_addSearchCriteria($attribute, $value);
						$table = $attribute->getBackend()->getTable();
						$attributeId = $attribute->getId();
						if ($attribute->getBackendType() == 'static'){
							$attributeId = $attribute->getAttributeCode();
							$condition = array('like'=>"%{$condition}%");
						}
						$allConditions[$table][$attributeId] = $condition;
					}
				}
			}	
			
		}
		if ($allConditions) {
            $this->getProductCollection()->addFieldsToFilter($allConditions);
        }
        return $this;
    }

    /**
     * Add data about search criteria to object state
     *
     * @param   Mage_Eav_Model_Entity_Attribute $attribute
     * @param   mixed $value
     * @return  Mage_CatalogSearch_Model_Custom
     */
    protected function _addSearchCriteria($attribute, $value)
    {
        $name = $attribute->getFrontend()->getLabel();

        if (is_array($value) && (isset($value['from']) || isset($value['to']))){
            if (isset($value['currency'])) {
                $currencyModel = Mage::getModel('directory/currency')->load($value['currency']);
                $from = $currencyModel->format($value['from'], array(), false);
                $to = $currencyModel->format($value['to'], array(), false);
            } else {
                $currencyModel = null;
            }

            if (strlen($value['from']) > 0 && strlen($value['to']) > 0) {
                // -
                $value = sprintf('%s - %s', ($currencyModel ? $from : $value['from']), ($currencyModel ? $to : $value['to']));
            } elseif (strlen($value['from']) > 0) {
                // and more
                $value = Mage::helper('catalogsearch')->__('%s and greater', ($currencyModel ? $from : $value['from']));
            } elseif (strlen($value['to']) > 0) {
                // to
                $value = Mage::helper('catalogsearch')->__('up to %s', ($currencyModel ? $to : $value['to']));
            }
        }

        if (($attribute->getFrontendInput() == 'select' || $attribute->getFrontendInput() == 'multiselect') && is_array($value)) {
            foreach ($value as $k=>$v){
                $value[$k] = $attribute->getSource()->getOptionText($v);

                if (is_array($value[$k]))
                    $value[$k] = $value[$k]['label'];
            }
            $value = implode(', ', $value);
        } else if ($attribute->getFrontendInput() == 'select' || $attribute->getFrontendInput() == 'multiselect') {
            $value = $attribute->getSource()->getOptionText($value);
            if (is_array($value))
                $value = $value['label'];
        } else if ($attribute->getFrontendInput() == 'boolean') {
            $value = $value == 1
                ? Mage::helper('catalogsearch')->__('Yes')
                : Mage::helper('catalogsearch')->__('No');
        }

        $this->_searchCriterias[] = array('name'=>$name, 'value'=>$value);
        return $this;
    }

    public function getSearchCriterias()
    {
        return $this->_searchCriterias;
    }

    public function getProductCollection(){
        if (is_null($this->_productCollection)) {
            $this->_productCollection = Mage::getResourceModel('ekkitab_catalogsearch/custom_collection')
                ->addAttributeToSelect(Mage::getSingleton('catalog/config')->getProductAttributes())
                ->addMinimalPrice()
                ->addTaxPercents()
                ->addStoreFilter();
                Mage::getSingleton('catalog/product_status')->addVisibleFilterToCollection($this->_productCollection);
                Mage::getSingleton('catalog/product_visibility')->addVisibleInSearchFilterToCollection($this->_productCollection);
        }
        return $this->_productCollection;
    }
}
