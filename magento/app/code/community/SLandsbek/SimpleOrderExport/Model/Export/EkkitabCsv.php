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
 * Exports orders to csv file. If an order contains multiple ordered items, each item gets
 * added on a separate row.
 * 
 * @author Stefan Landsbek (slandsbek@gmail.com)
 */
class SLandsbek_SimpleOrderExport_Model_Export_EkkitabCsv extends SLandsbek_SimpleOrderExport_Model_Export_Abstract
{
    const ENCLOSURE = '"';
    const DELIMITER = ',';

    /**
     * Concrete implementation of abstract method to export given orders to csv file in var/export.
     *
     * @param $orders List of orders of type Mage_Sales_Model_Order or order ids to export.
     * @return String The name of the written csv file in var/export
     */
    public function exportOrders($orders) 
    {
        $fileName = 'order_export_'.date("Ymd_His").'.csv';
        $fp = fopen(Mage::getBaseDir('export').'/'.$fileName, 'w');

        $this->writeHeadRow($fp);
        foreach ($orders as $order) {
            $order = Mage::getModel('sales/order')->load($order);
            $this->writeOrder($order, $fp);
        }

        fclose($fp);

        return $fileName;
    }

    /**
	 * Writes the head row with the column names in the csv file.
	 * 
	 * @param $fp The file handle of the csv file
	 */
    protected function writeHeadRow($fp) 
    {
        fputcsv($fp, $this->getHeadRowValues(), self::DELIMITER, self::ENCLOSURE);
    }

    /**
	 * Writes the row(s) for the given order in the csv file.
	 * A row is added to the csv file for each ordered item. 
	 * 
	 * @param Mage_Sales_Model_Order $order The order to write csv of
	 * @param $fp The file handle of the csv file
	 */
    protected function writeOrder($order, $fp) 
    {
        $common = $this->getCommonOrderValues($order);

        $orderItems = $order->getItemsCollection();
        $itemInc = 0;
        foreach ($orderItems as $item)
        {
            if (!$item->isDummy()) {
                $record = array_merge(array($itemInc+1), $common, $this->getOrderItemValues($item, $order, ++$itemInc));
                fputcsv($fp, $record, self::DELIMITER, self::ENCLOSURE);
            }
        }
    }

    /**
	 * Returns the head column names.
	 * 
	 * @return Array The array containing all column names
	 */
    protected function getHeadRowValues() 
    {
        return array(
            'Sl No',
            'Order Date',
            'Order Id',
            'Customer Name',
            'Address 1',
            'Address 2',
            'City',
            'State',
            'Pincode',
            'Country',
            'Contact Number',
          
            'Payment Mode',
			'Transaction Status',
            'Order Subtotal',
            'Shipping Mode',
            'Order Grand Total',
            'Total Order Qty',

			'Title',
			'Author',
            'ISBN',
            'Binding',
            'Publisher',
    		'Market Price',
            'Supplier Price',
            'Discount Price',
            'Qty',
			'Distributors',
			'Distributors(With Stock)',
			'Commited Shipping Period'
    	);
    }

    /**
	 * Returns the values which are identical for each row of the given order. These are
	 * all the values which are not item specific: order data, shipping address, billing
	 * address and order totals.
	 * 
	 * @param Mage_Sales_Model_Order $order The order to get values from
	 * @return Array The array containing the non item specific values
	 */
    protected function getCommonOrderValues($order) 
    {
        $shippingAddress = !$order->getIsVirtual() ? $order->getShippingAddress() : null;
        $billingAddress = $order->getBillingAddress();
        
        return array(
			Mage::helper('core')->formatDate($order->getCreatedAt(), 'medium', true),
			$order->getRealOrderId(),
      
			$shippingAddress ? $shippingAddress->getName() : '',
            $shippingAddress ? $shippingAddress->getData("company") : '',
            $shippingAddress ? $shippingAddress->getData("street") : '',
            $shippingAddress ? $shippingAddress->getData("city") : '',
            $shippingAddress ? $shippingAddress->getRegion() : '',
            $shippingAddress ? $shippingAddress->getData("postcode") : '',
            $shippingAddress ? $shippingAddress->getCountryModel()->getName() : '',
            $shippingAddress ? $shippingAddress->getData("telephone") : '',
           
            $this->getPaymentMethod($order),
			$order->getStatus(),
   			$this->formatPrice($order->getData('subtotal'), $order),
            $this->getShippingMethod($order),
            $this->formatPrice($order->getData('grand_total'), $order),
            $this->getTotalQtyItemsOrdered($order),
        );
    }

    /**
	 * Returns the item specific values.
	 * 
	 * @param Mage_Sales_Model_Order_Item $item The item to get values from
	 * @param Mage_Sales_Model_Order $order The order the item belongs to
	 * @return Array The array containing the item specific values
	 */
    protected function getOrderItemValues($item, $order, $itemInc=1) 
    {
		$product = $item->getProduct();
		$authorArr = $product->getAuthor();
		$author = $authorArr['a'] ;
		$isbn=$this->getItemSku($item);
		$binding = ucwords($product->getBinding());
		$supPrice = $product->getSuppliersPrice() ;
		$listPrice =$product->getListPrice() ;
		$discPrice = $product->getDiscountPrice();
		$publisher = $product->getPublisher();
		$shippingTimeMin = (int)$product->getDeliveryPeriod();
		$shippingTimeMax = round($shippingTimeMin + (.5 * $shippingTimeMin) );
		$shippingTime = ( $shippingTimeMin > 0 && $shippingTimeMax > 0 ) ? "Delivers in ".$shippingTimeMin." - ".$shippingTimeMax." days":"";
		$availDist="";
		$distributors="";
		if(strtolower(trim($product->getSourcedFrom()))!=='us'){
			$distributorsList = Mage::getModel('ekkitab_catalog/product_stockStatus')->getDistributorsStatus($isbn);
			foreach($distributorsList as  $dist){
				$distributors.= $dist->getDistributor().";";
				if($dist->getInStock()){
					$availDist.= $dist->getDistributor().";";
				}
			}
		}else{
			$distributors='Imported';
			$availDist='Imported';
		}
		if($availDist==''){
			$availDist="Not Available with any distributor.";
		}
		return array(
            $item->getName(),
            $author,
            $isbn,
			$binding,
			$publisher,
			$this->formatPrice($listPrice, $order),
			$this->formatPrice($supPrice, $order),
			$this->formatPrice($discPrice, $order),
            $item->getQtyToShip(),
			$distributors,
			$availDist,
			$shippingTime
        );
    }
}
?>