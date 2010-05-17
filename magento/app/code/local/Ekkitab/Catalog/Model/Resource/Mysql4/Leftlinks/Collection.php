<?php
/**
 * 
 * Frontend Leftlinks  Colelction Resource Model
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
class Ekkitab_Catalog_Model_Resource_Mysql4_Leftlinks_Collection extends Mage_Core_Model_Mysql4_Collection_Abstract
{


    /**
     * Init collection and determine table names
     *
     */
    protected function _construct()
    {
        $this->_init('ekkitab_catalog/leftlinks');
    }

	public function addOrderByFilter(){
		$this->getSelect()->order('trim(lower(header_id))');
		return $this;
	}

	public function joinLinkHeaderData(){
		$this->getSelect()
			->join( array('ek_leftlink_header'=>$this->getTable('ekkitab_catalog/leftlink_header')),
			'main_table.header_id = ek_leftlink_header.id',
			array('header'));
		return $this;
	}

	public function leftJoinLinkQueryData(){
		$this->getSelect()
			->joinLeft( array('ek_leftlink_query'=>$this->getTable('ekkitab_catalog/leftlink_query')),
			'main_table.id = ek_leftlink_query.link_id',
			array('ek_leftlink_query.*'));
		return $this;
	}

}
   