<?php
/**
 * Catalog Custom search model
 * @category   Local/Ekkitab
 * @package    Ekkitab_CatalogSearch_Model_Mysql4_Custom
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

class Ekkitab_CatalogSearch_Model_Mysql4_Custom_Collection extends Mage_Catalog_Model_Resource_Eav_Mysql4_Product_Collection
{
    //this is the same as in advanced search. made no changes here.
	public function addFieldsToFilter($fields)
    {
        if ($fields) {
            /*$entityIds = null;*/
            $previousSelect = null;
            foreach ($fields as $table => $conditions) {
                foreach ($conditions as $attributeId => $conditionValue) {
                    $bindVarName = 'attribute_'.$attributeId;
                    $select = $this->getConnection()->select();
                    $select->from(array('t1' => $table), 'entity_id');
                    $conditionData = array();

                    if (is_array($conditionValue)) {
                        if (isset($conditionValue['in'])){
                            $conditionData[] = array('IN (?)', $conditionValue['in']);
                        }
                        elseif (isset($conditionValue['in_set'])) {
                            $conditionData[] = array('REGEXP \'(^|,)('.join('|', $conditionValue['in_set']).')(,|$)\'', $conditionValue['in_set']);
                        }
                        elseif (isset($conditionValue['like'])) {
                            $this->addBindParam($bindVarName, $conditionValue['like']);
                            $conditionData[] = 'LIKE :'.$bindVarName;
                        }
                        elseif (isset($conditionValue['from']) && isset($conditionValue['to'])) {
                            if ($conditionValue['from']) {
                                if (!is_numeric($conditionValue['from'])){
                                    $conditionValue['from'] = date("Y-m-d H:i:s", strtotime($conditionValue['from']));
                                }
                                $conditionData[] = array('>= ?', $conditionValue['from']);
                            }
                            if ($conditionValue['to']) {
                                if (!is_numeric($conditionValue['to'])){
                                    $conditionValue['to'] = date("Y-m-d H:i:s", strtotime($conditionValue['to']));
                                }
                                $conditionData[] = array('<= ?', $conditionValue['to']);
                            }
                        }
                    } else {
                        $conditionData[] = array('= ?', $conditionValue);
                    }

                    if (!is_numeric($attributeId)) {
                        foreach ($conditionData as $data) {
                            if (is_array($data)) {
                                $select->where('t1.'.$attributeId . ' ' . $data[0], $data[1]);
                            }
                            else {
                                $select->where('t1.'.$attributeId . ' ' . $data);
                            }
                        }
                    }
                    else {
                        $storeId = $this->getStoreId();
                        $select->joinLeft(
                            array('t2' => $table),
                            $this->getConnection()->quoteInto('t1.entity_id = t2.entity_id AND t1.attribute_id = t2.attribute_id AND t2.store_id=?', $storeId),
                            array()
                        );
                        $select->where('t1.store_id = ?', 0);
                        $select->where('t1.attribute_id = ?', $attributeId);

                        foreach ($conditionData as $data) {
                            if (is_array($data)) {
                                $select->where('IFNULL(t2.value, t1.value) ' . $data[0], $data[1]);
                            }
                            else {
                                $select->where('IFNULL(t2.value, t1.value) ' . $data);
                            }
                        }
                    }

                    if (!is_null($previousSelect)) {
                        $select->where('t1.entity_id IN(?)', new Zend_Db_Expr($previousSelect));
                    }
                    $previousSelect = $select;
                }

                /*if (!is_null($entityIds) && $entityIds) {
                    $select->where('t1.entity_id IN(?)', $entityIds);
                }
                elseif (!is_null($entityIds) && !$entityIds) {
                    continue;
                }

                $entityIds = array();
                $rowSet = $this->getConnection()->fetchAll($select);
                foreach ($rowSet as $row) {
                    $entityIds[] = $row['entity_id'];
                }*/
            }

            /*if ($entityIds) {
                $this->addFieldToFilter('entity_id', array('IN', $entityIds));
            }
            else {
                $this->addFieldToFilter('entity_id', 'IS NULL');
            }*/
            $this->addFieldToFilter('entity_id', array('in' => new Zend_Db_Expr($select)));
        }

        return $this;
    }
}