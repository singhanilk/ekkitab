<?php
/**
 */


/**
 * Customer Data Helper
 *
 */
class Ekkitab_Institute_Helper_Data extends Mage_Core_Helper_Abstract
{
    const QUERY_PAGE_NO = 'p';


    /*
     * @var int
     */
    protected $_pageNo;


	/**
     * Query param name for last url visited
     */
    const REFERER_QUERY_PARAM_NAME = 'referer';

    /**
     * Institute types collection
     *
     * @var Ekkitab_Institute_Model_Resource_Mysql4_Types_Collection
     */
    protected $_types;
	
	/**
     * Organization/institute Id
     *
     * @var int
     */
    protected $_orgId;

	/**
     * Current Linked Organization

     *
     * @var int
     */
    protected $_custOrg;

	/**
     * Retrieve search query text
     *
     * @return string
     */
    public function getCurrentPageNumber()
    {
        if (is_null($this->_pageNo)) {
            $this->_pageNo = $this->_getRequest()->getParam($this->getPageNoVarName());
            if (isset($this->_pageNo)) {
                $this->_pageNo = (int)trim($this->_pageNo);
            } else {
                $this->_pageNo = 1;
            }
        }
        return $this->_pageNo;
    }

	/**
     * Retrieve search query parameter name
     *
     * @return string
     */
    public function getPageNoVarName()
    {
        return self::QUERY_PAGE_NO;
    }

    /**
     * Retrieve customer groups collection
     *
     * @return Ekkitab_Institute_Model_Entity_Group_Collection
     */
    public function getTypes()
    {
   
        if (empty($this->_types)) {
            $this->_types = Mage::getModel('ekkitab_institute/type')->getResourceCollection()
                ->setRealTypesFilter()
                ->load();
        }
        return $this->_types;
    }

    /**
     * Retrieve customer register form url
     *
     * @return string
     */
    public function getRegisterUrl()
    {
        return $this->_getUrl('ekkitab_institute/account/create');
    }

    /**
     * Retrieve customer register form url
     *
     * @return string
     */
    public function getViewLink()
    {
        return $this->_getUrl('ekkitab_institute/account/view');
    }

    /**
     * Retrieve customer register form post url
     *
     * @return string
     */
    public function getRegisterPostUrl()
    {
        return $this->_getUrl('ekkitab_institute/account/createpost');
    }

    /**
     * Retrieve customer register form post url
     *
     * @return string
     */
    public function getEditUrl($id)
    {
        return $this->_getUrl('ekkitab_institute/account/edit',array("id"=>$id));
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
        $imageModel = Mage::getModel('ekkitab_institute/institute_image');
		if($imageModel){
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
				 $url = Mage::getDesign()->getSkinUrl($this->getPlaceholder($imageModel->getDestinationSubdir()));
			}
			return $url;
		}else{
			return null;
		}
    }

	/**
     * Retrieve search query text
     *
     * @return string
     */
    public function getInstituteId()	
    {
        if (is_null($this->_orgId)) {
			$_orgId  = (int) $this->_getRequest()->getParam('id');
        }
        return $this->_orgId;
    }


	/**
     * Retrieve search query text
     *
     * @return string
     */
    public function getInstituteName($id)	
    {
		if($id && $id > 0){
			$_institute= Mage::getModel('ekkitab_institute/institute')->load($id);
			return $_institute->getName();
		}
		else {
			return null;
		}
    }

	public function getCustomer()
    {
        return Mage::getSingleton('customer/session')->getCustomer();
    }


	/**
     * Retrieve search query text
     *
     * @return string
     */
	
	 public function isCustOrgAdmin() {
		$orgId = $this->getCurrentLinkedOrganization();
		if($orgId > 0){
			$_institute= Mage::getModel('ekkitab_institute/institute')->load($orgId);
			if($_institute &&  $this->getCustomer() && $this->getCustomer()->getId()==$_institute->getAdminId() ){
				return true;
			} else{
				return false;
			}
		} else {
			return false;
        }
    }
	
	/**
     * Retrieve organization set in session
     *
     * @return string
     */
    public function getCurrentLinkedOrganization()
    {
        if (is_null($this->_custOrg)) {
			$orgArr = Mage::getSingleton('core/session')->getCurrentLinkedOrganization();
			if(is_array($orgArr) && count($orgArr) > 0 ){
				$this->_custOrg = $orgArr['current_linked_organization'];
			}else{
				$this->_custOrg = '';
			}
            if (isset($this->_custOrg)) {
                $this->_custOrg = (int)trim($this->_custOrg);
            } else {
                $this->_custOrg = 0;
            }
        }
        return $this->_custOrg;
    }

}
