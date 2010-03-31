<?php
/**
 * Globasection products resource model
 *
 * @category   Ekkitab
 * @package    Ekkitab_Catalog
 * @author      Ekkitab Core Team <anisha@ekkitab.com>
 */
class Ekkitab_Catalog_Model_Resource_Mysql4_Globalsection_Products extends Mage_Core_Model_Mysql4_Abstract
{
    protected function  _construct()
    {
        $this->_init('ekkitab_catalog/globalsection_products', 'id');
    }

	/**
     * Retrieve Required children ids
     * Return grouped array, ex array(
     *   group => array(ids)
     * )
     *
     * @param int $parentId
     * @return array
    public function getChildrenIds($sectionId)
    {
        $childrenIds = array();
        $select = $this->_getReadAdapter()->select()
            ->from(array('l' => $this->getMainTable()), array('section_id', 'product_id'))
            ->where('section_id=?', $sectionId)
        }

        foreach ($this->_getReadAdapter()->fetchAll($select) as $row) {
            $childrenIds[] = $row['product_id'];
        }

        return $childrenIds;
    }
     */

}