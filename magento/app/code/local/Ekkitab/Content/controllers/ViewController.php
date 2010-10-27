<?php
/**
 * Content View controller
 *
 * @category   Ekkitab
 * @package    Ekkitab_Content
 * @author Anisha (anisha@ekkitab.com)
 * @version 1.0 Feb 10, 2010
 * 
 * @package    Local_Ekkitab
 * @copyright  COPYRIGHT (C) 2009 Ekkitab Educational Services India Pvt. Ltd.
 * @license    All Rights Reserved. All material contained in this file (including, but not limited to, text, images, graphics, HTML, programming code and scripts) 
 * constitute proprietary and  * confidential information protected by copyright laws, trade secret and other laws. No part of this software may be copied, reproduced, modified or 
 * distributed in any form or by any means, or stored in a database or retrieval system without the prior written permission of Ekkitab Educational Services.
 */

class Ekkitab_Content_ViewController extends Mage_Core_Controller_Front_Action
{
    
    private $_isbn;

	/**
     * Initialize requested product object
     *
     * @return Mage_Catalog_Model_Product
     */
    public function allarticlesAction()
    {
		$this->loadLayout();
		$this->renderLayout();
    }

}
