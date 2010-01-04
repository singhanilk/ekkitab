<?php
/**
/**
 * Catalog Custom search helper
 * @category   Local/Ekkitab
 * @package    Ekkitab_CatalogSearch_Helper
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

class Ekkitab_CatalogSearch_Helper_Data extends Mage_CatalogSearch_Helper_Data
{


    /**
     * Retrieve result page url
     *
     * @param   string $query
     * @return  string
     */
    public function getCustomSearchResultUrl($query = null)
    {
        return $this->_getUrl('ekkitab_catalogsearch/custom/result', array('_query' => array(
            self::QUERY_VAR_NAME => $query
        )));
    }

    /**
     * Schedule resize of the image
     * $width *or* $height can be null - in this case, lacking dimension will be calculated.
     *
     * @see Mage_Catalog_Model_Product_Image
     * @param int $width
     * @param int $height
     * @return Mage_Catalog_Helper_Image
     */
    public function resize($image, $attributeName,$keepFrame,$width, $height = null)
    {
        $imageModel = Mage::getModel('catalog/product_image');
        $imageModel->setDestinationSubdir($attributeName);
        $imageModel->setBaseFile($image);
        $imageModel->setWidth($width)->setHeight($height);
        $imageModel->setKeepFrame($keepFrame);
		try {
            if( $imageModel->isCached() ) {
                return $imageModel->getUrl();
            } else {
                $imageModel->resize();
                $url = $imageModel->saveFile()->getUrl();
            }
        } catch( Exception $e ) {
            $url = Mage::getDesign()->getSkinUrl($this->getPlaceholder());
        }
        return $url;
    }


}
