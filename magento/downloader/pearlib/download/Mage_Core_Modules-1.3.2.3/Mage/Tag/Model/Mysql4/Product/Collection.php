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
 * @package    Mage_Tag
 * @copyright  Copyright (c) 2009 Irubin Consulting Inc. DBA Varien (http://www.varien.com)
 * @license    http://opensource.org/licenses/osl-3.0.php  Open Software License (OSL 3.0)
 */


/**
 * Tagged Product(s) Collection
 *
 * @category   Mage
 * @package    Mage_Tag
 * @author     Magento Core Team <core@magentocommerce.com>
 */
class Mage_Tag_Model_Mysql4_Product_Collection extends Mage_Catalog_Model_Resource_Eav_Mysql4_Product_Collection
{
    /**
     * Customer Id Filter
     *
     * @var int
     */
    protected $_customerFilterId;

    /**
     * Tag Id Filter
     *
     * @var int
     */
    protected $_tagIdFilter;

    /**
     * Join Flags
     *
     * @var array
     */
    protected $_joinFlags = array();

    /**
     * Initialize collection select
     *
     * @return Mage_Tag_Model_Mysql4_Product_Collection
     */
    protected function _initSelect()
    {
        parent::_initSelect();

        $this->_joinFields();
        $this->getSelect()->group('e.entity_id');

        return $this;
    }

    /**
     * Set join flag
     *
     * @param string $table
     * @return Mage_Tag_Model_Mysql4_Product_Collection
     */
    public function setJoinFlag($table)
    {
        $this->_joinFlags[$table] = true;
        return $this;
    }

    /**
     * Retrieve join flag
     *
     * @param string $table
     * @return bool
     */
    public function getJoinFlag($table)
    {
        return isset($this->_joinFlags[$table]);
    }

    /**
     * Unset join flag
     *
     * @param string $table
     * @return Mage_Tag_Model_Mysql4_Product_Collection
     */
    public function unsetJoinFlag($table = null)
    {
        if (is_null($table)) {
            $this->_joinFlags = array();
        }
        elseif ($this->getJoinFlag($table)) {
            unset($this->_joinFlags[$table]);
        }

        return $this;
    }

    /**
     * Add tag visibility on stores
     *
     * @return Mage_Tag_Model_Mysql4_Product_Collection
     */
    public function addStoresVisibility()
    {
        $this->setJoinFlag('add_stores_after');
        return $this;
    }

    /**
     * Add tag visibility on stores process
     *
     * @return Mage_Tag_Model_Mysql4_Product_Collection
     */
    protected function _addStoresVisibility()
    {
        $tagIds = array();
        foreach ($this as $item) {
            $tagIds[] = $item->getTagId();
        }

        $tagsStores = array();
        if (sizeof($tagIds) > 0) {
            $select = $this->getConnection()->select()
                ->from($this->getTable('tag/summary'), array('store_id', 'tag_id'))
                ->where('tag_id IN(?)', $tagIds);
            $tagsRaw = $this->getConnection()->fetchAll($select);
            foreach ($tagsRaw as $tag) {
                if (!isset($tagsStores[$tag['tag_id']])) {
                    $tagsStores[$tag['tag_id']] = array();
                }

                $tagsStores[$tag['tag_id']][] = $tag['store_id'];
            }
        }

        foreach ($this as $item) {
            if (isset($tagsStores[$item->getTagId()])) {
                $item->setStores($tagsStores[$item->getTagId()]);
            }
            else {
                $item->setStores(array());
            }
        }

        return $this;
    }

    /**
     * Add group by tag
     *
     * @return Mage_Tag_Model_Mysql4_Product_Collection
     */
    public function addGroupByTag()
    {
        $this->getSelect()->group('relation.tag_relation_id');
        return $this;
    }

    /**
     * Set Customer filter
     *
     * @param int $customerId
     * @return Mage_Tag_Model_Mysql4_Product_Collection
     */
    public function addCustomerFilter($customerId)
    {
        $this->getSelect()
            ->where('relation.customer_id = ?', $customerId);
        $this->_customerFilterId = $customerId;
        return $this;
    }

    /**
     * Set tag filter
     *
     * @param int $tagId
     * @return Mage_Tag_Model_Mysql4_Product_Collection
     */
    public function addTagFilter($tagId)
    {
        $this->getSelect()->where('relation.tag_id = ?', $tagId);
        $this->setJoinFlag('distinct');
        return $this;
    }

    /**
     * Add tag status filter
     *
     * @param int $status
     * @return Mage_Tag_Model_Mysql4_Product_Collection
     */
    public function addStatusFilter($status)
    {
        $this->getSelect()->where('t.status = ?', $status);
        return $this;
    }

    /**
     * Set DESC order to collection
     *
     * @param string $dir
     * @return Mage_Tag_Model_Mysql4_Product_Collection
     */
    public function setDescOrder($dir = 'DESC')
    {
        $this->setOrder('relation.tag_relation_id', $dir);
        return $this;
    }

    /**
     * Add Popularity
     *
     * @param int $tagId
     * @param int $storeId
     * @return Mage_Tag_Model_Mysql4_Product_Collection
     */
    public function addPopularity($tagId, $storeId=null)
    {
        $tagRelationTable = $this->getTable('tag/relation');

        $condition = array(
            'prelation.product_id=e.entity_id'
        );
        if (!is_null($storeId)) {
            $condition[] = $this->getConnection()
                ->quoteInto('prelation.store_id=?', $storeId);
        }
        $condition = join(' AND ', $condition);

        $this->getSelect()
            ->joinLeft(
                array('prelation' => $tagRelationTable),
                $condition,
                array('popularity' => 'COUNT(DISTINCT prelation.tag_relation_id)'))
            ->where('prelation.tag_id = ?', $tagId);

        $this->_tagIdFilter = $tagId;
        $this->setJoinFlag('prelation');
        return $this;
    }

    /**
     * Add Popularity Filter
     *
     * @param mixed $condition
     * @return Mage_Tag_Model_Mysql4_Product_Collection
     */
    public function addPopularityFilter($condition)
    {
        $tagRelationTable = Mage::getSingleton('core/resource')
            ->getTableName('tag/relation');

        $select = $this->getConnection()->select()
            ->from($tagRelationTable, array('product_id', 'popularity' => 'COUNT(DISTINCT tag_relation_id)'))
            ->where('tag_id = ?', $this->_tagIdFilter)
            ->group('product_id')
            ->having($this->_getConditionSql('popularity', $condition));

        $prodIds = array();
        foreach ($this->getConnection()->fetchAll($select) as $item) {
            $prodIds[] = $item['product_id'];
        }

        if (sizeof($prodIds) > 0) {
            $this->getSelect()->where('e.entity_id IN(?)', $prodIds);
        }
        else {
            $this->getSelect()->where('e.entity_id IN(0)');
        }

        return $this;
    }

    /**
     * Set tag active filter to collection
     *
     * @return Mage_Tag_Model_Mysql4_Product_Collection
     */
    public function setActiveFilter()
    {
        $active = Mage_Tag_Model_Tag_Relation::STATUS_ACTIVE;
        $this->getSelect()->where('relation.active=?', $active);
        if ($this->getJoinFlag('prelation')) {
            $this->getSelect()->where('prelation.active=?', $active);
        }
        return $this;
    }

    /**
     * Add Product Tags
     *
     * @param int $storeId
     * @return Mage_Tag_Model_Mysql4_Product_Collection
     */
    public function addProductTags($storeId = null)
    {
        foreach ($this->getItems() as $item) {
            $tagsCollection = Mage::getModel('tag/tag')->getResourceCollection();

            if (!is_null($storeId)) {
                $tagsCollection->addStoreFilter($storeId);
            }

            $tagsCollection->addPopularity()
                ->addProductFilter($item->getEntityId())
                ->addCustomerFilter($this->_customerFilterId)
                ->setActiveFilter();

            $tagsCollection->load();
            $item->setProductTags($tagsCollection);
        }

        return $this;
    }

    /**
     * Join fields process
     *
     * @return Mage_Tag_Model_Mysql4_Product_Collection
     */
    protected function _joinFields()
    {
        $tagTable           = $this->getTable('tag/tag');
        $tagRelationTable   = $this->getTable('tag/relation');

        $this->addAttributeToSelect('name')
            ->addAttributeToSelect('price')
            ->addAttributeToSelect('small_image');

        $this->getSelect()
            ->join(array('relation' => $tagRelationTable), 'relation.product_id = e.entity_id')
            ->join(array('t' => $tagTable),
                't.tag_id = relation.tag_id',
                array('tag_id', 'name', 'tag_status' => 'status', 'tag_name' => 'name')
            );
        return $this;
    }

    /**
     * After load adding data
     *
     * @return Mage_Tag_Model_Mysql4_Product_Collection
     */
    protected function _afterLoad()
    {
        parent::_afterLoad();

        if ($this->getJoinFlag('add_stores_after')) {
            $this->_addStoresVisibility();
        }

        if (count($this) > 0) {
            Mage::dispatchEvent('tag_tag_product_collection_load_after', array(
                'collection' => $this
            ));
        }

        return $this;
    }

    /**
     * Render SQL for retrieve product count
     *
     * @return string
     */
    public function getSelectCountSql()
    {
        $countSelect = clone $this->getSelect();

        $countSelect->reset(Zend_Db_Select::COLUMNS);
        $countSelect->reset(Zend_Db_Select::ORDER);
        $countSelect->reset(Zend_Db_Select::LIMIT_COUNT);
        $countSelect->reset(Zend_Db_Select::LIMIT_OFFSET);
        $countSelect->reset(Zend_Db_Select::GROUP);

        if ($this->getJoinFlag('group_tag')) {
            $field = 'relation.tag_id';
        }
        else {
            $field = 'e.entity_id';
        }
        $expr = new Zend_Db_Expr('COUNT('
            . ($this->getJoinFlag('distinct') ? 'DISTINCT ' : '')
            . $field . ')');

        $countSelect->from(null, $expr);

        return $countSelect;
    }

    /**
     * Set attribute order
     *
     * @param string $attribute
     * @param string $dir
     * @return Mage_Tag_Model_Mysql4_Product_Collection
     */
    public function setOrder($attribute, $dir='desc')
    {
        if ($attribute == 'popularity') {
            $this->getSelect()->order($attribute . ' ' . $dir);
        }
        else {
            parent::setOrder($attribute, $dir);
        }
        return $this;
    }

    /**
     * Set Id Fieldname as Tag Relation Id
     *
     * @return Mage_Tag_Model_Mysql4_Product_Collection
     */
    public function setRelationId()
    {
        $this->_setIdFieldName('tag_relation_id');
        return $this;
    }
}
