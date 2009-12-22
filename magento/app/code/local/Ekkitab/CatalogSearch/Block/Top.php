<?php
/**
 * 
 * Frontend Popular Search keywords block
 * @category   Local
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

class Ekkitab_CatalogSearch_Block_Top extends Mage_Core_Block_Template
{

    public function __construct()
    {
        $this->setTemplate('categorysearch/popular.phtml');
    }

    public function getTopSearches()
    {
    
		 return Mage::getModel('catalogsearch/query')
            ->getResourceCollection();
    }

   
}
