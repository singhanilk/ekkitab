<?php
/**
 * Catalog Custom search controller
 * @category   Local/Ekkitab
 * @package    Ekkitab_CatalogSearch
 * @author Anisha (anisha@ekkitab.com)
 * @version 1.0 Dec 7, 2009
 * 
 * @package    Local_Ekkitab
 * @copyright  COPYRIGHT (C) 2009 Ekkitab Educational Services India Pvt. Ltd.
 * @license    All Rights Reserved. All material contained in this file (including, but not limited to, text, images, graphics, HTML, programming code and scripts) 
 * constitute proprietary and  * confidential information protected by copyright laws, trade secret and other laws. No part of this software may be copied, reproduced, modified or 
 * distributed in any form or by any means, or stored in a database or retrieval system without the prior written permission of Ekkitab Educational Services.
 * 
 */
class Ekkitab_Catalog_AuthorController extends Mage_Core_Controller_Front_Action
{

    public function viewAllAction()
    {
        $this->loadLayout();
        $this->renderLayout();
    }
}
