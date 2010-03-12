<?php
/**
 * 
 * Frontend Popular Categories Resource Model
 * @category   Local/Ekkitab
 * @author Anisha (anisha@ekkitab.com)
 * @version 1.0 Nov 17, 2009
 * 
 * @package    Local_Ekkitab
 * @copyright  COPYRIGHT (C) 2009 Ekkitab Educational Services India Pvt. Ltd.
 * @license    All Rights Reserved. All material contained in this file (including, but not limited to, text, images, graphics, HTML, programming code and scripts) 
 * constitute proprietary and  * confidential information protected by copyright laws, trade secret and other laws. No part of this software may be copied, reproduced, modified or 
 * distributed in any form or by any means, or stored in a database or retrieval system without the prior written permission of Ekkitab Educational Services.
 * 
 * 
 */

class Ekkitab_Catalog_Model_Resource_Mysql4_Product extends Mage_Core_Model_Mysql4_Abstract
{
    protected function _construct()
    {
		$this->_init('ekkitab_catalog/product','id');
    }

    /**
     * Substract product from all quotes quantities
     *
     * @param Mage_Catalog_Model_Product $product
     */
    public function getAllDistinctAuthors()
    {
		//CREATE OR REPLACE View ek_catalog_authors as SELECT SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(author,'&',-1),'*',1),'.',1) as author FROM books UNION SELECT SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(author,'&',1),'*',1),'.',1) as author FROM books
		//$query= $this->_getReadAdapter()->query(" SELECT DISTINCT(author) FROM ek_catalog_authors where author<>'' order by lower(trim(author))");
		//$query= $this->_getReadAdapter()->query("SELECT DISTINCT(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(author,'&',-1),'*',1),'.',1)) as author FROM books UNION SELECT DISTINCT(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(author,'&',1),'*',1),'.',1)) as author FROM books order by lower(trim(author)) ");
		$query= $this->_getReadAdapter()->query("SELECT DISTINCT(trim(author)) as author FROM books order by lower(trim(author)) ");
		while ($row = $query->fetch()) {
			//$data[] = $row['author'];
			$authArray = explode('&',$row['author']);
			foreach($authArray as $auth){
				$data[] = trim(preg_replace('#[^A-Za-z0-9\,\ \.]+#', ' ', $auth));
			}
        }
		$result = array_unique($data);
		sort($result);
        return $result;
    }
}