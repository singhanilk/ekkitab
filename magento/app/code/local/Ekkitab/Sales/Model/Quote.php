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
 * @package    Mage_Sales
 * @copyright  Copyright (c) 2008 Irubin Consulting Inc. DBA Varien (http://www.varien.com)
 * @license    http://opensource.org/licenses/osl-3.0.php  Open Software License (OSL 3.0)
 */

/**
 * Quote model
 *
 * Supported events:
 *  sales_quote_load_after
 *  sales_quote_save_before
 *  sales_quote_save_after
 *  sales_quote_delete_before
 *  sales_quote_delete_after
 *
 * @author      Magento Core Team <core@magentocommerce.com>
 */
class Ekkitab_Sales_Model_Quote extends Mage_Sales_Model_Quote
{

    /**
     * Adding catalog product object data to quote
     *
     * @param   Mage_Catalog_Model_Product $product
     * @return  Mage_Sales_Model_Quote_Item
     */
    protected function _addCatalogProduct(Mage_Catalog_Model_Product $product, $qty=1)
    {

        $item = $this->getItemByProduct($product);
       
		if (!$item) {
            Mage::log("in _addCatalogProduct ................item is not there... so setting quote..");
			$item = Mage::getModel('ekkitab_sales/quote_item');
            $item->setQuote($this);
            Mage::log("in _addCatalogProduct ................".$item->getId());
        }

        /**
         * We can't modify existing child items
         */
        if ($item->getId() && $product->getParentProductId()) {
            return $item;
        }

        $item->setOptions($product->getCustomOptions())
            ->setProduct($product);
        
		Mage::log("in _addCatalogProduct ................ after calling item.setproduct()".$item->getId());
		
        $this->addItem($item);
        Mage::log("in _addCatalogProduct ................item is added");
        Mage::log("in _addCatalogProduct .................".$item->getId());

        return $item;
    }

   
}
