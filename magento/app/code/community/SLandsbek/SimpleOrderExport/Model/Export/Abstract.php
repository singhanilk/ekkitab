<?php
/**
 * NOTICE OF LICENSE
 *
 * The MIT License
 *
 * Copyright (c) 2009 Stefan Landsbek (slandsbek@gmail.com)
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 * @package    SLandsbek_SimpleOrderExport
 * @copyright  Copyright (c) 2009 Stefan Landsbek (slandsbek@gmail.com)
 * @license    http://opensource.org/licenses/mit-license.php  The MIT License
 */

/**
 * Abstract class to define the interface to export orders and offering helper methods to
 * retrieve data from orders and order items.
 * 
 * @author Stefan Landsbek (slandsbek@gmail.com)
 */
abstract class SLandsbek_SimpleOrderExport_Model_Export_Abstract extends Mage_Core_Model_Abstract
{
    /**
     * Definition of abstract method to export orders to a file in a specific format in var/export.
     *
     * @param $orders List of orders of type Mage_Sales_Model_Order or order ids to export.
     * @return String The name of the written file in var/export
     */
    abstract public function exportOrders($orders);

    /**
     * Returns the name of the website, store and store view the order was placed in.
     *
     * @param Mage_Sales_Model_Order $order The order to return info from
     * @return String The name of the website, store and store view the order was placed in
     */
    protected function getStoreName($order) 
    {
        $storeId = $order->getStoreId();
        if (is_null($storeId)) {
            return $this->getOrder()->getStoreName();
        }
        $store = Mage::app()->getStore($storeId);
        $name = array(
        $store->getWebsite()->getName(),
        $store->getGroup()->getName(),
        $store->getName()
        );
        return implode(', ', $name);
    }

    /**
     * Returns the payment method of the given order.
     *
     * @param Mage_Sales_Model_Order $order The order to return info from
     * @return String The name of the payment method
     */
    protected function getPaymentMethod($order)
    {
        return $order->getPayment()->getMethod();
    }
    
    /**
     * Returns the shipping method of the given order.
     *
     * @param Mage_Sales_Model_Order $order The order to return info from
     * @return String The name of the shipping method
     */
    protected function getShippingMethod($order)
    {
        if (!$order->getIsVirtual() && $order->getShippingMethod()) {
            return $order->getShippingMethod();
        }
        return '';
    }
    
    /**
     * Returns the total quantity of ordered items of the given order.
     *
     * @param Mage_Sales_Model_Order $order The order to return info from
     * @return int The total quantity of ordered items
     */
    protected function getTotalQtyItemsOrdered($order) {
        $qty = 0;
        $orderedItems = $order->getItemsCollection();
        foreach ($orderedItems as $item)
        {
            if (!$item->isDummy()) {
                $qty += (int)$item->getQtyOrdered();
            }
        }
        return $qty;
    }

    /**
     * Returns the sku of the given item dependant on the product type.
     *
     * @param Mage_Sales_Model_Order_Item $item The item to return info from
     * @return String The sku
     */
    protected function getItemSku($item)
    {
        if ($item->getProductType() == Mage_Catalog_Model_Product_Type::TYPE_CONFIGURABLE) {
            return $item->getProductOptionByCode('simple_sku');
        }
        return $item->getSku();
    }

    /**
     * Returns the options of the given item separated by comma(s) like this:
     * option1: value1, option2: value2
     *
     * @param Mage_Sales_Model_Order_Item $item The item to return info from
     * @return String The item options
     */
    protected function getItemOptions($item)
    {
        $options = '';
        if ($orderOptions = $this->getItemOrderOptions($item)) {
            foreach ($orderOptions as $_option) {
                if (strlen($options) > 0) {
                    $options .= ', ';
                }
                $options .= $_option['label'].': '.$_option['value'];
            }
        }
        return $options;
    }

    /**
     * Returns all the product options of the given item including additional_options and
     * attributes_info.
     *
     * @param Mage_Sales_Model_Order_Item $item The item to return info from
     * @return Array The item options
     */
    protected function getItemOrderOptions($item)
    {
        $result = array();
        if ($options = $item->getProductOptions()) {
            if (isset($options['options'])) {
                $result = array_merge($result, $options['options']);
            }
            if (isset($options['additional_options'])) {
                $result = array_merge($result, $options['additional_options']);
            }
            if (!empty($options['attributes_info'])) {
                $result = array_merge($options['attributes_info'], $result);
            }
        }
        return $result;
    }

    /**
     * Calculates and returns the grand total of an item including tax and excluding
     * discount.
     *
     * @param Mage_Sales_Model_Order_Item $item The item to return info from
     * @return Float The grand total
     */
    protected function getItemTotal($item) 
    {
        return $item->getRowTotal() - $item->getDiscountAmount() + $item->getTaxAmount() + $item->getWeeeTaxAppliedRowAmount();
    }

    /**
     * Formats a price by adding the currency symbol and formatting the number 
     * depending on the current locale.
     *
     * @param Float $price The price to format
     * @param Mage_Sales_Model_Order $formatter The order to format the price by implementing the method formatPriceTxt($price)
     * @return String The formatted price
     */
    protected function formatPrice($price, $formatter) 
    {
        return $formatter->formatPriceTxt($price);
    }
}
?>