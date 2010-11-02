<?php
/**
 * Magento
 *
 * NOTICE OF LICENSE
 *
 * This source file is subject to the Open Software License (OSL 3.0)
 * that is bundled with this package in the file LICENSE.txt.
 * It is also available through the world-wide-web at this URL:
 * http://opensource.org/licenses/osl-3.0.php
 * If you did not receive a copy of the license and are unable to
 * obtain it through the world-wide-web, please send an email
 * to license@magentocommerce.com so we can send you a copy immediately.
 *
 * DISCLAIMER
 *
 * Do not edit or add to this file if you wish to upgrade Magento to newer
 * versions in the future. If you wish to customize Magento for your
 * needs please refer to http://www.magentocommerce.com for more information.
 *
 * @category   Mage
 * @package    Ekkitab_Institute
 * @copyright  Copyright (c) 2008 Irubin Consulting Inc. DBA Varien (http://www.varien.com)
 * @license    http://opensource.org/licenses/osl-3.0.php  Open Software License (OSL 3.0)
 */

/**
 * Customer login block
 *
 * @category   Mage
 * @package    Ekkitab_Institute
 * @author      Magento Core Team <core@magentocommerce.com>
 */
class Ekkitab_Institute_Block_Institute extends Mage_Core_Block_Template
{
	protected $_pageSize = 15;
	protected $_pageNo;
	protected $_lastPageNo;
	protected $_displayPages = 5;
	protected $_instituteCollection;
	protected $__instituteCollectionCount;
	
	protected function _prepareLayout()
    {
	   
		$title ='All Institutes';
		
		if ($breadcrumbs = $this->getLayout()->getBlock('breadcrumbs')) {

			$breadcrumbs->addCrumb('home', array(
				'label'=>Mage::helper('catalogsearch')->__('Home'),
				'title'=>Mage::helper('catalogsearch')->__('Go to Home Page'),
				'link'=>Mage::getBaseUrl()
			));
   
			$this->getLayout()->getBlock('head')->setTitle($title);
		}
		
        return parent::_prepareLayout();
    }

	public function setPageSize($count)
    {
        if (intval($count) > 0) {
            $this->_pageSize = intval($count);
        }
        return $this;
    }

    public function getPageSize()
    {
        return $this->_pageSize;
    }

    public function getPageNo()
    {
        return $this->_pageNo;
    }

	protected function getAllInstitutes() 
    {
		$institutes = Mage::getModel('ekkitab_institute/institute')->getCollection()
			->addAuthenticateFilter();
		
		if($this->getCurrentPageNumber() > 0){
			$institutes->setCurPage($this->getCurrentPageNumber());
		}
		if($this->getPageSize() && $this->getPageSize() > 0 ){
			$institutes->setPageSize($this->getPageSize());
			//$collection->setLimit($limit);
		}
		return $institutes;
    }
 
		
	public function getInstituteCollection(){

		//introduce the lucene search here.....
		if (is_null($this->_instituteCollection)) { 
			$this->_instituteCollection =Mage::getModel('ekkitab_institute/institute')->getCollection()->addAuthenticateFilter();
		}
		return $this->_instituteCollection;
    }
	
	/**
     * Retrieve search result count
     *
     * @return string
     */
    public function getResultCount()
    {
	   $size =0;
	   if (!$this->getData('result_count')) {
            $size = $this->getInstituteCollection()->getSize();
            $this->setResultCount($size);
        }
        return $this->getData('result_count');
    }



	/**
     * Retrieve search result count
     *
     * @return string
     */
    public function getLastPageNumber()
    {
		if(is_null($this->_lastPageNo)){
			$this->_lastPageNo = ceil((int)$this->getResultCount() / $this->_pageSize);
		}
		return $this->_lastPageNo;
    }

    public function isFirstPage()
    {
        return $this->getCurrentPageNumber() == 1;
    }

	public function isPageCurrent($page)
    {
        return $page == $this->getCurrentPageNumber();
    }
	
    public function isLastPage()
    {
        return $this->getCurrentPageNumber() >= $this->getLastPageNumber();
    }

    public function getFirstPageUrl()
    {
        return $this->getPageUrl(1);
    }

    public function getPreviousPageUrl()
    {
        return $this->getPageUrl($this->getCurrentPageNumber()-1);
    }

    public function getNextPageUrl()
    {
        return $this->getPageUrl($this->getCurrentPageNumber()+1);
    }

    public function getLastPageUrl()
    {
        return $this->getPageUrl($this->getLastPageNumber());
    }

    public function getPageUrl($page)
    {
        Mage::log($this->helper('ekkitab_institute')->getPageNoVarName()." value is : ".$page);
		return $this->getPagerUrl(array($this->helper('ekkitab_institute')->getPageNoVarName()=>$page));
    }

	 public function getPagerUrl($params=array(),$queryParams=null)
    {
		$url = '*/*/*/';
		if(is_array($params)){
			foreach ($params as $param => $value) {
               if(isset($value) && strlen($value) > 0){
				  $url  = $url.$param."/".$value."/";
			   }
            }
        }
        $urlParams = array();
       // $urlParams['_current']  = true;
       // $urlParams['_query']    = $queryParams;
		$url = $this->getUrl($url,$urlParams);
        return $url;
    }


	/**
     * Retrieve search result count
     *
     * @return string
     */
    public function getCurrentPageNumber()
    {
		if(is_null($this->_pageNo)){
			$this->_pageNo = $this->helper('ekkitab_institute')->getCurrentPageNumber();
		}
		return $this->_pageNo;
    }


    public function getFirstNum()
    {
        return $this->getPageSize()*($this->getCurrentPageNumber()-1)+1;
    }

    public function getLastNum()
    {
        $collection = $this->getCollection();
        return $this->getPageSize()*($this->getCurrentPageNumber()-1)+$this->getResultCount();
    }

	public function getPages()
    {
        $pages = array();

        if ($this->getLastPageNumber() <= $this->_displayPages) {
            $pages = range(1,$this->getLastPageNumber());
        }
        else {
            $half = ceil($this->_displayPages / 2);
            if ($this->_pageNo >= $half && $this->_pageNo <= $this->getLastPageNumber() - $half) {
                $start  = ($this->_pageNo - $half) + 1;
                $finish = ($start + $this->_displayPages) - 1;
            }
            elseif ($this->_pageNo < $half) {
                $start  = 1;
                $finish = $this->_displayPages;
            }
            elseif ($this->_pageNo > ($this->getLastPageNumber() - $half)) {
                $finish = $this->getLastPageNumber();
                $start  = $finish - $this->_displayPages + 1;
            }

            $pages = range($start, $finish);
        }
        return $pages;

    }

}