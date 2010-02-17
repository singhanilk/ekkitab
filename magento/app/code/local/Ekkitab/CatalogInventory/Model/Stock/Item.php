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
 * @package    Mage_CatalogInvemtory
 * @copyright  Copyright (c) 2009 Irubin Consulting Inc. DBA Varien (http://www.varien.com)
 * @license    http://opensource.org/licenses/osl-3.0.php  Open Software License (OSL 3.0)
 */


/**
 * Catalog Inventory Stock Model
 *
 * @category   Mage
 * @package    Mage_CatalogInvemtory
 * @author     Magento Core Team <core@magentocommerce.com>
 */
class Ekkitab_CatalogInventory_Model_Stock_Item extends Mage_CatalogInventory_Model_Stock_Item
{

    /**
     * Initialize resource model
     *
     */
    protected function _construct()
    {
        $this->_init('cataloginventory/stock_item');
    }


    /**
     * Checking quote item quantity
     *
     * @param mixed $qty quantity of this item (item qty x parent item qty)
     * @param mixed $summaryQty quantity of this product in whole shopping cart which should be checked for stock availability
     * @param mixed $origQty original qty of item (not multiplied on parent item qty)
     * @return Varien_Object
     */
    public function checkQuoteItemQty($qty, $summaryQty, $origQty = 0)
    {
        $result = new Varien_Object();
        $result->setHasError(false);
        $result->setItemIsQtyDecimal(0);
        $result->setHasQtyOptionUpdate(1);
        $result->setOrigQty(intval($origQty));
        
        return $result;        
    }
}
