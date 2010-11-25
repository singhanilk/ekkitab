<?php
/**
 * 
 * Frontend  block
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
class Ekkitab_Institute_Block_Institute_View extends Mage_Core_Block_Template
{

    private $_wishlistHelperBlock;
    protected $_wishlistLoaded = false;
    protected $_wishlistCollection ;
   
    private $_institute;
    private $_orgId;

	protected function _prepareLayout()
    {
		if($this->getInstitute()){
			$title = $this->getInstitute()->getName();
			$ogTitle = $title; 
			$productUrl = $this->getInstitute()->getInstituteUrl();
			$imagetUrl = Mage::Helper('ekkitab_institute')->resize($this->getInstitute()->getImage(),'image',false,null, 200); 
			
			
			$desc = "Donate Books to $title.";

			if ($headBlock = $this->getLayout()->getBlock('head')) {
				$headBlock->setTitle("Donate Books to $title");
				$headBlock->setKeywords("");
				$headBlock->setDescription($desc);
				$headBlock->setOpenGraphTitle($ogTitle);
				$headBlock->setOpenGraphSiteName("Ekkitab.com");
				$headBlock->setOpenGraphImageUrl($imagetUrl);
				$headBlock->setOpenGraphProductUrl($this->getUrl($productUrl));
				$headBlock->setFacebookAdmin("ekkitab");
			}
			if ($breadcrumbs = $this->getLayout()->getBlock('breadcrumbs')){
				$breadcrumbs->addCrumb('home', array(
					'label'=>Mage::helper('ekkitab_institute')->__('Home'),
					'title'=>Mage::helper('ekkitab_institute')->__('Go to Home Page'),
					'link'=>Mage::getBaseUrl()
				));
	   
				$breadcrumbs->addCrumb('Members of the Ekkitab Network', array(
					'label'=>Mage::helper('ekkitab_institute')->__('Members of the Ekkitab Network'),
					'title'=>Mage::helper('ekkitab_institute')->__('Ekkitab Network List'),
					'link'=> '/ekkitab_institute/search/listAll'
				));
	   


				$title=htmlspecialchars_decode($title,ENT_QUOTES);
				$breadcrumbs->addCrumb($title, array(
					'label'=>$title,
					'title'=>$title,
					'link'=>''
				));

			}
		
		}
        return parent::_prepareLayout();
		
    }

	public function htmlspecialchars_decode($string,$style=ENT_COMPAT)
    {
        $translation = array_flip(get_html_translation_table(HTML_SPECIALCHARS,$style));
        if($style === ENT_QUOTES){ $translation['&#39;'] = '\''; }
        return strtr($string,$translation);
    }
	
	
	/**
     * Get popular of current store
     *
     */
    public function getInstitute()
    {
		if(is_null($this->_institute)){
			if (!Mage::registry('organizationId')) {
				//Mage::unregister('orgId');
				Mage::register('organizationId', Mage::helper('ekkitab_institute')->getInstituteId());
			}
			$this->_institute= Mage::getModel('ekkitab_institute/institute')->load(Mage::registry('organizationId'));
		}
		if($this->_institute->getId() > 0){
			return $this->_institute;
		} else {
			return null;
		}
	}


	public function getCustomer()
    {
        return Mage::getSingleton('customer/session')->getCustomer();
    }

	public function isUserAdmin()
    {
		if($this->_institute &&  $this->getCustomer() && $this->getCustomer()->getId()==$this->_institute->getAdminId() ){
			return true;
		} else{
			return false;
		}
    }

	public function getOrganizationWishlist()
    {
		if(!is_null($this->_institute) && is_null($this->_wishlistCollection)){
			if(!$this->_wishlistLoaded) {
				$wishlist = Mage::getModel('ekkitab_wishlist/wishlist')
						->loadByOrganization($this->_institute->getId(),$this->_institute->getAdminId(), true);
				$this->_wishlistCollection = $wishlist->getProductCollection();
				$this->_wishlistLoaded = true;
			}
		}
        return $this->_wishlistCollection;
    }

	public function isSaleable()
    {
		if(!is_null($this->_wishlistCollection)){
			foreach ($this->_wishlistCollection as $item) {
				if ($item->isSaleable()) {
					return true;
				}
			}
		}
		return false;
    }

    public function getItemAddToCartUrl($item,$orgId)
    {
        return $this->getUrl('ekkitab_checkout/cart/donationCart',array('item'=>$item->getWishlistItemId(),'org'=>$orgId));
    }

    public function getOrgWishlistActionUrl($orgId)
    {
        return $this->getUrl('ekkitab_wishlist/index/addOrgWishlist',array('orgId'=>$orgId));
    }

    public function getWishlistBrowseUrl($orgId)
    {
        $session = Mage::getSingleton('core/session');
		$session->setCurrentLinkedOrganization(array('current_linked_organization'=>$orgId));
		return $this->getUrl('home');
    }

    public function getMoveSelectedCartUrl()
    {
        return $this->getUrl('ekkitab_checkout/cart/moveSelectedToCart');
    }

    public function getRemoveSelectedWishlistUrl()
    {
        return $this->getUrl('ekkitab_wishlist/index/removeSelected');
    }

    public function getBackUrl()
    {
        if ($this->getRefererUrl()) {
            return $this->getRefererUrl();
        }
        return $this->getUrl('ekkitab_institute/search/listAll');
    }



}
