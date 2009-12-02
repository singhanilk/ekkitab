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
 * @package    Mage_Catalog
 * @copyright  Copyright (c) 2009 Irubin Consulting Inc. DBA Varien (http://www.varien.com)
 * @license    http://opensource.org/licenses/osl-3.0.php  Open Software License (OSL 3.0)
 */

/**
 * Catalog category model
 *
 * @category   Mage
 * @package    Mage_Catalog
 * @author     Magento Core Team <core@magentocommerce.com>
 */
class Mage_Catalog_Model_Resource_Eav_Mysql4_Category extends Mage_Catalog_Model_Resource_Eav_Mysql4_Abstract
{
    /**
     * Category tree object
     *
     * @var Varien_Data_Tree_Db
     */
    protected $_tree;

    /**
     * Catalog products table name
     *
     * @var string
     */
    protected $_categoryProductTable;

    /**
     * Id of 'is_active' category attribute
     *
     * @var int
     */
    protected $_isActiveAttributeId = null;

    /**
     * Store id
     *
     * @var int
     */
    protected $_storeId = null;

    /**
     * Class constructor
     */
    public function __construct()
    {
        $resource = Mage::getSingleton('core/resource');
        $this->setType('catalog_category')
            ->setConnection(
                $resource->getConnection('catalog_read'),
                $resource->getConnection('catalog_write')
            );
        $this->_categoryProductTable = $this->getTable('catalog/category_product');
    }

    /**
     * Set store Id
     *
     * @param integer $storeId
     * @return Mage_Catalog_Model_Resource_Eav_Mysql4_Category
     */
    public function setStoreId($storeId)
    {
        $this->_storeId = $storeId;
        return $this;
    }

    /**
     * Return store id
     *
     * @return integer
     */
    public function getStoreId()
    {
        if (is_null($this->_storeId)) {
            return Mage::app()->getStore()->getId();
        }
        return $this->_storeId;
    }

    /**
     * Retrieve category tree object
     *
     * @return Varien_Data_Tree_Db
     */
    protected function _getTree()
    {
        if (!$this->_tree) {
            $this->_tree = Mage::getResourceModel('catalog/category_tree')
                ->load();
        }
        return $this->_tree;
    }

    /**
     * Process category data before delete
     * update children count for parent category
     * delete child categories
     *
     * @param   Varien_Object $object
     * @return  Mage_Catalog_Model_Resource_Eav_Mysql4_Category
     */
    protected function _beforeDelete(Varien_Object $object)
    {
        parent::_beforeDelete($object);

        /**
         * Update children count for all parent categories
         */
        $parentIds = $object->getParentIds();
        $childDecrease = $object->getChildrenCount() + 1; // +1 is itself
        $this->_getWriteAdapter()->update(
            $this->getEntityTable(),
            array('children_count'=>new Zend_Db_Expr('`children_count`-'.$childDecrease)),
            $this->_getWriteAdapter()->quoteInto('entity_id IN(?)', $parentIds)
        );

        /**
         * Recursion use a lot of memmory, that why we run one request for delete children
         */
        /*if ($child = $this->_getTree()->getNodeById($object->getId())) {
            $children = $child->getChildren();
            foreach ($children as $child) {
                $childObject = Mage::getModel('catalog/category')->load($child->getId())->delete();
            }
        }*/

        $select = $this->_getWriteAdapter()->select()
            ->from($this->getEntityTable(), array('entity_id'))
            ->where($this->_getWriteAdapter()->quoteInto('`path` LIKE ?', $object->getPath().'/%'));

        $childrenIds = $this->_getWriteAdapter()->fetchCol($select);

        if (!empty($childrenIds)) {
            $this->_getWriteAdapter()->delete(
                $this->getEntityTable(),
                $this->_getWriteAdapter()->quoteInto('entity_id IN (?)', $childrenIds)
            );
        }

        /**
         * Add deleted children ids to object
         * This data can be used in after delete event
         */
        $object->setDeletedChildrenIds($childrenIds);
        return $this;
    }

    /**
     * Process category data before saving
     * prepare path and increment children count for parent categories
     *
     * @param   Varien_Object $object
     * @return  Mage_Catalog_Model_Resource_Eav_Mysql4_Category
     */
    protected function _beforeSave(Varien_Object $object)
    {
        parent::_beforeSave($object);

        if (!$object->getId()) {
            $object->setPosition($this->_getMaxPosition($object->getPath()) + 1);
            $path  = explode('/', $object->getPath());
            $level = count($path);
            $object->setLevel($level);
            if ($level) {
                $object->setParentId($path[$level - 1]);
            }
            $object->setPath($object->getPath() . '/');

            $toUpdateChild = explode('/',$object->getPath());

            $this->_getWriteAdapter()->update(
                $this->getEntityTable(),
                array('children_count'=>new Zend_Db_Expr('`children_count`+1')),
                $this->_getWriteAdapter()->quoteInto('entity_id IN(?)', $toUpdateChild)
            );

        }
        return $this;
    }

    /**
     * Process category data after save category object
     * save related products ids and update path value
     *
     * @param   Varien_Object $object
     * @return  Mage_Catalog_Model_Resource_Eav_Mysql4_Category
     */
    protected function _afterSave(Varien_Object $object)
    {
        /**
         * Add identifier for new category
         */
        if (substr($object->getPath(), -1) == '/') {
            $object->setPath($object->getPath() . $object->getId());
            $this->_savePath($object);
        }

        $this->_saveCategoryProducts($object);
        return parent::_afterSave($object);
    }

    /**
     * Update path field
     *
     * @param   Mage_Catalog_Model_Category $object
     * @return  Mage_Catalog_Model_Resource_Eav_Mysql4_Category
     */
    protected function _savePath($object)
    {
        if ($object->getId()) {
            $this->_getWriteAdapter()->update(
                $this->getEntityTable(),
                array('path'=>$object->getPath()),
                $this->_getWriteAdapter()->quoteInto('entity_id=?', $object->getId())
            );
        }
        return $this;
    }

    protected function _getMaxPosition($path)
    {
        $select = $this->getReadConnection()->select();
        $select->from($this->getTable('catalog/category'), 'MAX(position)');
        $select->where('path ?', new Zend_Db_Expr("regexp '{$path}/[0-9]+\$'"));

        $result = 0;
        try {
            $result = (int) $this->getReadConnection()->fetchOne($select);
        } catch (Exception $e) {

        }
        return $result;
    }

    /**
     * Save category products
     *
     * @param Mage_Catalog_Model_Category $category
     * @return Mage_Catalog_Model_Resource_Eav_Mysql4_Category
     */
    protected function _saveCategoryProducts($category)
    {
        $category->setIsChangedProductList(false);

        /**
         * new category-product relationships
         */
        $products = $category->getPostedProducts();
        /**
         * Example re-save category
         */
        if (is_null($products)) {
            return $this;
        }

        /**
         * old category-product relationships
         */
        $oldProducts = $category->getProductsPosition();

        $insert = array_diff_key($products, $oldProducts);
        $delete = array_diff_key($oldProducts, $products);
        /**
         * Find product ids which are presented in both arrays
         */
        $update = array_intersect_key($products, $oldProducts);
        /**
         * Use for update just products with changed position
         */
        $update = array_diff_assoc($update, $oldProducts);

        $productTable = $this->getTable('catalog/product');
        $productUpdateSql = sprintf('UPDATE `%s` AS `e` SET `category_ids`=(SELECT
            GROUP_CONCAT(`category_id`) FROM `%s` AS `cp` WHERE `cp`.`product_id`=`e`.`entity_id`)
            WHERE `e`.`entity_id` IN(?)', $productTable, $this->_categoryProductTable);

        /**
         * Delete products from category
         *
         */
        if (!empty($delete)) {
            $deleteIds = array_keys($delete);
            $this->_getWriteAdapter()->delete($this->_categoryProductTable,
                $this->_getWriteAdapter()->quoteInto('product_id in(?)', $deleteIds) .
                $this->_getWriteAdapter()->quoteInto(' AND category_id=?', $category->getId())
            );

            $sql = $this->_getWriteAdapter()->quoteInto($productUpdateSql, $deleteIds);
            $this->_getWriteAdapter()->query($sql);
        }

        /**
         * Add products to category
         *
         */
        if (!empty($insert)) {
            $insertSql = array();
            foreach ($insert as $k => $v) {
                $insertSql[] = '('.(int)$category->getId().','.(int)$k.','.(int)$v.')';
            }
            $sql = sprintf(
                'INSERT INTO `%s` (`category_id`,`product_id`,`position`) VALUES%s',
                $this->_categoryProductTable,
                join(',', $insertSql)
            );
            $this->_getWriteAdapter()->query($sql);

            $insertIds = array_keys($insert);
            $sql = $this->_getWriteAdapter()->quoteInto($productUpdateSql, $insertIds);
            $this->_getWriteAdapter()->query($sql);
        }

        /**
         * Update product positions in category
         *
         */
        if (!empty($update)) {
            foreach ($update as $k => $v) {
                $cond   = array(
                    $this->_getWriteAdapter()->quoteInto('category_id=?', (int)$category->getId()),
                    $this->_getWriteAdapter()->quoteInto('product_id=?', (int)$k)
                );
                $where  = join(' AND ', $cond);
                $bind   = array(
                    'position' => (int)$v
                );
                $this->_getWriteAdapter()->update($this->_categoryProductTable, $bind, $where);
            }
        }

        if (!empty($insert) || !empty($delete)) {
            $productIds = array_unique(array_merge(array_keys($insert), array_keys($delete)));
            Mage::dispatchEvent('catalog_category_change_products', array(
                'category'      => $category,
                'product_ids'   => $productIds
            ));
        }

        if (!empty($insert) || !empty($update) || !empty($delete)) {
            $category->setIsChangedProductList(true);
            $categoryIds = explode('/', $category->getPath());
            $this->refreshProductIndex($categoryIds);
        }

        return $this;
    }

    /**
     * Get store identifiers where category is presented
     *
     * @param   Mage_Catalog_Model_Category $category
     * @return  array
     */
    public function getStoreIds($category)
    {
        if (!$category->getId()) {
            return array();
        }

        $nodePath = $this->_getTree()
            ->getNodeById($category->getId())
                ->getPath();

        $nodes = array();
        foreach ($nodePath as $node) {
            $nodes[] = $node->getId();
        }

        $stores = array();
        $storeCollection = Mage::getModel('core/store')->getCollection()->loadByCategoryIds($nodes);
        foreach ($storeCollection as $store) {
            $stores[$store->getId()] = $store->getId();
        }

        $entityStoreId = $category->getStoreId();
        if (!in_array($entityStoreId, $stores)) {
            array_unshift($stores, $entityStoreId);
        }
        if (!in_array(0, $stores)) {
            array_unshift($stores, 0);
        }
        return $stores;
    }

    /**
     * Get positions of associated to category products
     *
     * @param   Mage_Catalog_Model_Category $category
     * @return  array
     */
    public function getProductsPosition($category)
    {
        $select = $this->_getWriteAdapter()->select()
            ->from($this->_categoryProductTable, array('product_id', 'position'))
            ->where('category_id=?', $category->getId());
        $positions = $this->_getWriteAdapter()->fetchPairs($select);
        return $positions;
    }

    /**
     * Get chlden categories count
     *
     * @param   int $categoryId
     * @return  int
     */
    public function getChildrenCount($categoryId)
    {
        $select = $this->_getReadAdapter()->select()
            ->from($this->getEntityTable(), 'children_count')
            ->where('entity_id=?', $categoryId);

        $child = $this->_getReadAdapter()->fetchOne($select);

        return $child;
    }

    /**
     * Move category to another parent
     *
     * @param   int $categoryId
     * @param   int $newParentId
     * @return  Mage_Catalog_Model_Resource_Eav_Mysql4_Category
     */
    public function move($categoryId, $newParentId)
    {
        $category  = Mage::getModel('catalog/category')->load($categoryId);
        $oldParent = $category->getParentCategory();
        $newParent = Mage::getModel('catalog/category')->load($newParentId);

        $childrenCount = $this->getChildrenCount($category->getId()) + 1;

        // update children count of new parents
        $parentIds = explode('/', $newParent->getPath());
        $this->_getWriteAdapter()->update(
            $this->getEntityTable(),
            array('children_count' => new Zend_Db_Expr("`children_count` + {$childrenCount}")),
            $this->_getWriteAdapter()->quoteInto('entity_id IN (?)', $parentIds)
        );

        // update children count of old parents
          $parentIds = explode('/', $oldParent->getPath());
          $this->_getWriteAdapter()->update(
            $this->getEntityTable(),
            array('children_count' => new Zend_Db_Expr("`children_count` - {$childrenCount}")),
            $this->_getWriteAdapter()->quoteInto('entity_id IN (?)', $parentIds)
        );

        // update parent id
        $this->_getWriteAdapter()->query("UPDATE
            {$this->getEntityTable()} SET parent_id = {$newParent->getId()}
            WHERE entity_id = {$categoryId}");

        return $this;
    }

    /**
     * Check if category id exist
     *
     * @param   int $id
     * @return  bool
     */
    public function checkId($id)
    {
        $select = $this->_getReadAdapter()->select()
            ->from($this->getEntityTable(), 'entity_id')
            ->where('entity_id=?', $id);
        return $this->_getReadAdapter()->fetchOne($select);
    }

    /**
     * Check array of category identifiers
     *
     * @param   array $ids
     * @return  array
     */
    public function verifyIds(array $ids)
    {
        $validIds = array();
        $select = $this->_getWriteAdapter()->select()
            ->from($this->getEntityTable(), 'entity_id')
            ->where('entity_id IN(?)', $ids);
        $query = $this->_getWriteAdapter()->query($select);
        while ($row = $query->fetch()) {
            $validIds[] = $row['entity_id'];
        }
        return $validIds;
    }

    /**
     * Get count of active/not active children categories
     *
     * @param   Mage_Catalog_Model_Category $category
     * @param   bool $isActiveFlag
     * @return  int
     */
    public function getChildrenAmount($category, $isActiveFlag = true)
    {
        $storeId = Mage::app()->getStore()->getId();
        $attributeId = $this->_getIsActiveAttributeId();
        $table = Mage::getSingleton('core/resource')->getTableName('catalog/category') . '_int';

        $select = $this->_getReadAdapter()->select()
            ->from(array('m'=>$this->getEntityTable()), array('COUNT(m.entity_id)'))
            ->joinLeft(
                array('d'=>$table),
                "d.attribute_id = '{$attributeId}' AND d.store_id = 0 AND d.entity_id = m.entity_id",
                array()
            )
            ->joinLeft(
                array('c'=>$table),
                "c.attribute_id = '{$attributeId}' AND c.store_id = '{$storeId}' AND c.entity_id = m.entity_id",
                array()
            )
            ->where('m.path like ?', $category->getPath() . '/%')
            ->where('(IFNULL(c.value, d.value) = ?)', $isActiveFlag);

        return $this->_getReadAdapter()->fetchOne($select);
    }

    /**
     * Get "is_active" attribute identifier
     *
     * @return int
     */
    protected function _getIsActiveAttributeId()
    {
        if (is_null($this->_isActiveAttributeId)) {
            $select = $this->_getReadAdapter()->select()
                ->from(array('a'=>$this->getTable('eav/attribute')), array('attribute_id'))
                ->join(array('t'=>$this->getTable('eav/entity_type')), 'a.entity_type_id = t.entity_type_id')
                ->where('entity_type_code = ?', 'catalog_category')
                ->where('attribute_code = ?', 'is_active');

            $this->_isActiveAttributeId = $this->_getReadAdapter()->fetchOne($select);
        }
        return $this->_isActiveAttributeId;
    }

    /**
     * Refresh Category Product Index for Store Root Catgory
     *
     * @param array|int $productIds
     * @param array|int $storeIds
     * @return Mage_Catalog_Model_Resource_Eav_Mysql4_Category
     */
    protected function _refreshRootCategoryProductIndex($productIds = array(), $storeIds = array())
    {
        if (is_numeric($storeIds)) {
            $storeIds = array($storeIds);
        }
        elseif (!is_array($storeIds) || empty($storeIds)) {
            $storeIds = array();
            foreach (Mage::app()->getStores() as $store) {
                $storeIds[] = $store->getId();
            }
        }

        /**
         * Prepare visibility and status attributes information
         */
        $status             = Mage::getSingleton('eav/config')->getAttribute('catalog_product', 'status');
        $visibility         = Mage::getSingleton('eav/config')->getAttribute('catalog_product', 'visibility');
        $statusTable        = $status->getBackend()->getTable();
        $visibilityTable    = $visibility->getBackend()->getTable();

        $indexTable         = $this->getTable('catalog/category_product_index');

        foreach ($storeIds as $storeId) {
            $store = Mage::app()->getStore($storeId);
            $categoryId = $store->getRootCategoryId();

            $select = $this->_getWriteAdapter()->select()
                ->from(array('e' => $this->getTable('catalog/product')), null)
                ->joinLeft(
                    array('i' => $indexTable),
                    'e.entity_id=i.product_id AND i.category_id=' . (int)$categoryId
                        . ' AND i.store_id=' . (int) $storeId,
                    array())
                ->joinInner(
                    array('pw' => $this->getTable('catalog/product_website')),
                    'e.entity_id=pw.product_id AND pw.website_id=' . (int)$store->getWebsiteId(),
                    array())
                ->join(
                    array('t_v_default' => $visibilityTable),
                    't_v_default.entity_id=e.entity_id'
                        . ' AND t_v_default.attribute_id=' . (int)$visibility->getAttributeId()
                        . ' AND t_v_default.store_id=0',
                    array())
                ->joinLeft(
                    array('t_v' => $visibilityTable),
                    't_v.entity_id=e.entity_id'
                        . ' AND t_v.attribute_id=' . (int)$visibility->getAttributeId()
                        . ' AND t_v.store_id='. (int)$storeId,
                    array())
                ->join(
                    array('t_s_default' => $statusTable),
                    't_s_default.entity_id=e.entity_id'
                        . ' AND t_s_default.attribute_id=' . (int)$status->getAttributeId()
                        . ' AND t_s_default.store_id=0',
                    array())
                ->joinLeft(
                    array('t_s' => $statusTable),
                    't_s.entity_id=e.entity_id'
                        . ' AND t_s.attribute_id=' . (int)$status->getAttributeId()
                        . ' AND t_s.store_id='. (int)$storeId,
                    array())
                ->where('i.product_id IS NULL')
                ->where('IFNULL(t_s.value, t_s_default.value)=?', Mage_Catalog_Model_Product_Status::STATUS_ENABLED);

            $select->columns(new Zend_Db_Expr($categoryId));
            $select->columns('e.entity_id');
            $select->columns(new Zend_Db_Expr(0));
            $select->columns(new Zend_Db_Expr(0));
            $select->columns(new Zend_Db_Expr($storeId));
            $select->columns(new Zend_Db_Expr('IFNULL(t_v.value, t_v_default.value)'));

            if (!empty($productIds)) {
                $select->where('e.entity_id IN(?)', $productIds);
            }

            $this->_getWriteAdapter()->query($select->insertFromSelect($indexTable));
        }
        return $this;
    }

    /**
     * Rebuild associated products index
     *
     * @param   array $categoryIds
     * @return  Mage_Catalog_Model_Resource_Eav_Mysql4_Category
     */
    public function refreshProductIndex($categoryIds = array(), $productIds = array(), $storeIds = array())
    {
        /**
         * Prepare visibility and status attributes information
         */
        $statusAttribute        = Mage::getSingleton('eav/config')->getAttribute('catalog_product', 'status');
        $visibilityAttribute    = Mage::getSingleton('eav/config')->getAttribute('catalog_product', 'visibility');
        $statusAttributeId      = $statusAttribute->getId();
        $visibilityAttributeId  = $visibilityAttribute->getId();
        $statusTable            = $statusAttribute->getBackend()->getTable();
        $visibilityTable        = $visibilityAttribute->getBackend()->getTable();

        /**
         * Select categories data
         */
        $select = $this->_getReadAdapter()->select()
            ->from($this->getTable('catalog/category'))
            ->order('level')
            ->order('path');

        if (is_array($categoryIds) && !empty($categoryIds)) {
            $select->where('entity_id IN (?)', $categoryIds);
        } elseif (is_numeric($categoryIds)) {
            $select->where('entity_id=?', $categoryIds);
        }

        $categories = $this->_getWriteAdapter()->fetchAll($select);

        $storesCondition = '';
        if (!empty($storeIds)) {
            $storesCondition = $this->_getWriteAdapter()->quoteInto(
                ' AND s.store_id IN (?)', $storeIds
            );
        }

        /**
         * Get information about stores root categories
         */
        $stores = $this->_getWriteAdapter()->fetchAll("
            SELECT
                s.store_id, s.website_id, c.path AS root_path
            FROM
                {$this->getTable('core/store')} AS s,
                {$this->getTable('core/store_group')} AS sg,
                {$this->getTable('catalog/category')} AS c
            WHERE
                sg.group_id=s.group_id
                AND c.entity_id=sg.root_category_id
                {$storesCondition}
        ");

        $indexTable = $this->getTable('catalog/category_product_index');

        foreach ($stores as $storeData) {
            $storeId    = $storeData['store_id'];
            $websiteId  = $storeData['website_id'];
            $rootPath   = $storeData['root_path'];

            $productCondition = '';
            if (!empty($productIds)) {
                $productCondition = $this->_getWriteAdapter()->quoteInto(
                    ' AND product_id IN (?)', $productIds
                );
            }
            $insProductCondition = str_replace('product_id', 'cp.product_id', $productCondition);

            foreach ($categories as $category) {
                $categoryId = $category['entity_id'];
                $path       = $category['path'];

                $this->_getWriteAdapter()->delete(
                    $indexTable,
                    'category_id='.$categoryId. ' AND store_id='.$storeId.$productCondition
                );

                if (strpos($path.'/', $rootPath.'/') === false) {
                    continue;
                }

                $query = "INSERT INTO {$indexTable}
                    (`category_id`, `product_id`, `position`, `is_parent`, `store_id`, `visibility`)
                SELECT
                    {$categoryId},
                    cp.product_id,
                    cp.position,
                    MAX({$categoryId}=cp.category_id) as is_parent,
                    {$storeId},
                    IFNULL(t_v.value, t_v_default.value)
                FROM
                    {$this->getTable('catalog/category_product')} AS cp
                INNER JOIN {$this->getTable('catalog/product_website')} AS pw
                    ON pw.product_id=cp.product_id AND pw.website_id={$websiteId}
                INNER JOIN {$visibilityTable} AS `t_v_default`
                    ON (t_v_default.entity_id = cp.product_id)
                        AND (t_v_default.attribute_id='{$visibilityAttributeId}')
                        AND t_v_default.store_id=0
                LEFT JOIN {$visibilityTable} AS `t_v`
                    ON (t_v.entity_id = cp.product_id)
                        AND (t_v.attribute_id='{$visibilityAttributeId}')
                        AND (t_v.store_id='{$storeId}')
                INNER JOIN {$statusTable} AS `t_s_default`
                    ON (t_s_default.entity_id = cp.product_id)
                        AND (t_s_default.attribute_id='{$statusAttributeId}')
                        AND t_s_default.store_id=0
                LEFT JOIN {$statusTable} AS `t_s`
                    ON (t_s.entity_id = cp.product_id)
                        AND (t_s.attribute_id='{$statusAttributeId}')
                        AND (t_s.store_id='{$storeId}')
                WHERE category_id IN(
                    SELECT entity_id FROM {$this->getTable('catalog/category')}
                    WHERE entity_id = {$category['entity_id']} OR path LIKE '{$path}/%')
                    AND (IFNULL(t_s.value, t_s_default.value)=".Mage_Catalog_Model_Product_Status::STATUS_ENABLED.")
                    {$insProductCondition}
                GROUP BY product_id
                ORDER BY is_parent desc";

                $this->_getWriteAdapter()->query($query);
            }

            $this->_refreshRootCategoryProductIndex($productIds, array($storeId));
        }
        return $this;
    }

    public function findWhereAttributeIs($entityIdsFilter, $attribute, $expectedValue)
    {
        $select = $this->_getReadAdapter()->select()
            ->from($attribute->getBackend()->getTable(), array('entity_id'))
            ->where('attribute_id = ?', $attribute->getId())
            ->where('value = ?', $expectedValue)
            ->where('entity_id in (?)', $entityIdsFilter);

        return $this->_getReadAdapter()->fetchCol($select);
    }

    /**
     * Get products count in category
     *
     * @param unknown_type $category
     * @return unknown
     */
    public function getProductCount($category)
    {
        $productTable =Mage::getSingleton('core/resource')->getTableName('catalog/category_product');

        $select =  $this->getReadConnection()->select();
        $select->from(
            array('main_table'=>$productTable),
            array(new Zend_Db_Expr('COUNT(main_table.product_id)'))
        )
        ->where('main_table.category_id = ?', $category->getId())
        ->group('main_table.category_id');

        $counts =$this->getReadConnection()->fetchOne($select);

        return intval($counts);
    }








    /**
     * Deprecated since 1.1.7
     *
     * @param Varien_Object $object
     * @return Mage_Catalog_Model_Resource_Eav_Mysql4_Category
     */
    protected function _saveCountChidren($object)
    {
        $chidren = $object->getChildren();
        if (strlen($chidren)>0) {
            $chidrenCount = count(explode(',', $chidren));
        } else {
            $chidrenCount = 0;
        }
        $this->_getWriteAdapter()->update($this->getEntityTable(),
            array('children_count'=>$chidrenCount),
            $this->_getWriteAdapter()->quoteInto('entity_id=?', $object->getId())
        );

        return $this;
    }

    /**
     * Deprecated
     *
     * @param Varien_Object $object
     * @return unknown
     */
    protected function _saveInStores(Varien_Object $object)
    {
        if (!$object->getMultistoreSaveFlag()) {
            $stores = $object->getStoreIds();
            foreach ($stores as $storeId) {
                if ($object->getStoreId() != $storeId) {
                    $newObject = clone $object;
                    $newObject->setStoreId($storeId)
                       ->setMultistoreSaveFlag(true)
                       ->save();
                }
            }
        }
        return $this;
    }

    /**
     * Deprecated
     */
    protected function _updateCategoryPath($category, $path)
    {
        return $this;
        if ($category->getNotUpdateDepends()) {
            return $this;
        }
        foreach ($path as $pathItem) {
            if ($pathItem->getId()>1 && $category->getId() != $pathItem->getId()) {
                $category = Mage::getModel('catalog/category')
                    ->load($pathItem->getId())
                    ->save();
            }
        }
        return $this;
    }

    /**
     * Retrieve categories
     *
     * @param integer $parent
     * @param integer $recursionLevel
     * @param boolean|string $sorted
     * @param boolean $asCollection
     * @param boolean $toLoad
     * @return Varien_Data_Tree_Node_Collection|Mage_Catalog_Model_Resource_Eav_Mysql4_Category_Collection
     */
    public function getCategories($parent, $recursionLevel = 0, $sorted=false, $asCollection=false, $toLoad=true)
    {
        $tree = Mage::getResourceModel('catalog/category_tree');
        /** @var $tree Mage_Catalog_Model_Resource_Eav_Mysql4_Category_Tree */
        $nodes = $tree->loadNode($parent)
            ->loadChildren($recursionLevel)
            ->getChildren();

        $tree->addCollectionData(null, $sorted, $parent, $toLoad, true);

        if ($asCollection) {
            return $tree->getCollection();
        }
        return $nodes;
    }

    /**
     * Return parent categories of category
     *
     * @param Mage_Catalog_Model_Category $category
     * @return array
     */
    public function getParentCategories($category)
    {
        $pathIds = array_reverse(explode(',', $category->getPathInStore()));
        $categories = Mage::getResourceModel('catalog/category_collection')
            ->setStore(Mage::app()->getStore())
            ->addAttributeToSelect('name')
            ->addAttributeToSelect('url_key')
            ->addFieldToFilter('entity_id', array('in'=>$pathIds))
            ->addFieldToFilter('is_active', 1)
            ->load()
            ->getItems();
        return $categories;
    }

    /**
     * Enter description here...
     *
     * @param Mage_Catalog_Model_Category $category
     * @return unknown
     */
    public function getChildrenCategories($category)
    {
        $collection = $category->getCollection();
        /* @var $collection Mage_Catalog_Model_Resource_Eav_Mysql4_Category_Collection */
        $collection->addAttributeToSelect('url_key')
            ->addAttributeToSelect('name')
            ->addAttributeToSelect('all_children')
            ->addAttributeToSelect('is_anchor')
            ->addAttributeToFilter('is_active', 1)
            ->addIdFilter($category->getChildren())
            ->setOrder('position', 'ASC')
            ->joinUrlRewrite()
            ->load();
        return $collection;
    }

    /**
     * Return children ids of category
     *
     * @param Mage_Catalog_Model_Category $category
     * @param boolean $recursive
     * @return array
     */
    public function getChildren($category, $recursive = true)
    {
        $attributeId = $this->_getIsActiveAttributeId();
        $select = $this->_getReadAdapter()->select()
            ->from(array('m' => $this->getEntityTable()), 'entity_id')
            ->joinLeft(
                array('d' => $this->getEntityTable() . '_int'),
                "d.attribute_id = '{$attributeId}' AND d.store_id = 0 AND d.entity_id = m.entity_id",
                array()
            )
            ->joinLeft(
                array('c' => $this->getEntityTable() . '_int'),
                "c.attribute_id = '{$attributeId}' AND c.store_id = '{$category->getStoreId()}' AND c.entity_id = m.entity_id",
                array()
            )
            ->where('(IFNULL(c.value, d.value) = ?)', '1')
            ->where('path LIKE ?', "{$category->getPath()}/%");
        if (!$recursive) {
            $select->where('level <= ?', $category->getLevel() + 1);
        }
        $_categories = $this->_getReadAdapter()->fetchAll($select);
        $categoriesIds = array();
        foreach ($_categories as $_category) {
            $categoriesIds[] = $_category['entity_id'];
        }

        return $categoriesIds;

//        $this->_getTree()->load();
//        return $this->_getTree()->getChildren($category->getId(), false);
    }

    /**
     * Return all children ids of category (with category id)
     *
     * @param Mage_Catalog_Model_Category $category
     * @return array
     */
    public function getAllChildren($category)
    {
        $children = $this->getChildren($category);
        $myId = array($category->getId());
        $children = array_merge($myId, $children);

        return $children;

//        $this->_getTree()->load();
//        $children = $this->_getTree()->getChildren($category->getId());
//
//        $myId = array($category->getId());
//        if (is_array($children)) {
//            $children = array_merge($myId, $children);
//        } else {
//            $children = $myId;
//        }
//
//        return $children;
    }

    /**
     * Check is category in list of store categories
     *
     * @param Mage_Catalog_Model_Category $category
     * @return boolean
     */
    public function isInRootCategoryList($category)
    {
        $innerSelect = $this->_getReadAdapter()->select()
            ->from($this->getEntityTable(), new Zend_Db_Expr("CONCAT(path, '/%')"))
            ->where('entity_id = ?', Mage::app()->getStore()->getRootCategoryId());
        $select = $this->_getReadAdapter()->select()
            ->from($this->getEntityTable(), 'entity_id')
            ->where('entity_id = ?', $category->getId())
            ->where(new Zend_Db_Expr("path LIKE ({$innerSelect->__toString()})"));
        return (bool) $this->_getReadAdapter()->fetchOne($select);

//        $tree = $this->_getTree();
//        $tree->load();
//        $children = $tree->getChildren(Mage::app()->getStore()->getRootCategoryId(), true);
//        if (!in_array($category->getId(), $children)) {
//            return false;
//        }
//        return true;
    }

    /**
     * Check category is forbidden to delete.
     *
     * If category is root and assigned to store group return false
     *
     * @param integer $categoryId
     * @return boolean
     */
    public function isForbiddenToDelete($categoryId)
    {
        $select = $this->_getReadAdapter()->select()
            ->from($this->getTable('core/store_group'), array('group_id'))
            ->where('root_category_id = ?', $categoryId);
        if ($this->_getReadAdapter()->fetchOne($select)) {
            return true;
        }
        return false;
    }
}