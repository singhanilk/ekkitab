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
 * Customer account controller
 *
 * @category   Mage
 * @package    Ekkitab_Institute
 * @author      Magento Core Team <core@magentocommerce.com>
 */
class Ekkitab_Institute_AccountController extends Mage_Core_Controller_Front_Action
{


   
   /**
     * View product action
     */
    public function viewAction()
    {
		$orgId  = (int) $this->getRequest()->getParam('id');

		if (!(is_int($orgId) && $orgId > 0 )) {
			$this->_forward('noRoute');
		}

		Mage::register('organizationId', $orgId);
		$this->loadLayout();
		$this->renderLayout();

    }


    /**
     * Default customer account page
     */
    public function indexAction()
    {
        $this->loadLayout();
        $this->_initLayoutMessages('customer/session');
        $this->_initLayoutMessages('catalog/session');

        $this->getLayout()->getBlock('content')->append(
            $this->getLayout()->createBlock('customer/account_dashboard')
        );
        $this->getLayout()->getBlock('head')->setTitle($this->__('My Account'));
        $this->renderLayout();
    }

    /**
     * Retrieve customer session model object
     *
     * @return Mage_Customer_Model_Session
     */
    protected function _getSession()
    {
        return Mage::getSingleton('core/session');
    }

	
    /**
     * Retrieve customer session model object
     *
     * @return Mage_Customer_Model_Session
     */
    protected function _getCustomerSession()
    {
        return Mage::getSingleton('customer/session');
    }

	
	/**
     * Customer register form page
     */
    public function createAction()
    {
        $this->loadLayout();
        $this->renderLayout();
    }

    /**
     * Create customer account action
     */
    public function createPostAction()
    {
        if ($this->getRequest()->isPost()) {
			$errors = array();
			
			//instantiate institute Object.
			$institute = Mage::getModel('ekkitab_institute/institute')->setId(null);
            $useAsAdmin = $this->getRequest()->getParam('use_as_admin');

			$postArray =array();
			//load all institute details from form.
			foreach (Mage::getConfig()->getFieldset('institute_account') as $code=>$node) {
                if ($node->is('create') && ($value = $this->getRequest()->getParam($code)) !== null) {
                  //  Mage::log("Setting Data for $code as : $value");
					$institute->setData($code, $value);
                }
            }

			$instituteName	= $institute->getData('name');
			$institutePostcode	= $institute->getData('postcode');
			if(!is_null($instituteName) && $instituteName!='' && !is_null($institutePostcode) && $institutePostcode!='' ){

				// create shool email with the name and postcode.
				$email = strtolower(trim(trim(substr(str_replace(" ","",$instituteName),0,10))."_".trim($institutePostcode)."@ekkitab.com"));
				$password = strtolower(trim(trim(substr(str_replace(" ","",$instituteName),0,10))."_".trim($institutePostcode)));
				$lastSpaceIndex = strrpos($instituteName, ' ');
				if($lastSpaceIndex > 0){
					$firstname = trim(substr($instituteName,0,$lastSpaceIndex));
					$lastname = trim(substr($instituteName,$lastSpaceIndex,strlen($instituteName)-$lastSpaceIndex));
				}else{
					$firstname = trim($instituteName);
					$lastname = "School";
				}
				
				//check if institute with this email exists... if yes then exit.
				$instituteCust = Mage::getModel('customer/customer')
					->setStore(Mage::app()->getStore())
					->loadByEmail($email);
				if ($instituteCust && $instituteCust->getId() > 0) {
					$this->_getSession()->addError($this->__("Institute with name '$instituteName' and in postcode '$institutePostcode' already exists in the network."));
					//throw new Exception('This Institute already exists.');
				}
				else{
					//else... 
					try{
						//check if exister user wants to be admin..validate username and passowrd...
						if($useAsAdmin && $useAsAdmin!='' && strtolower($useAsAdmin) =='y'){
							$username = $institute->getData('admin_email');
							$password = $institute->getData('admin_password');
							if (!empty($username) && !empty($password) && $this->validateLoginForm($username,$password)) {
								$admin =  Mage::getModel('customer/customer')
								->setStore(Mage::app()->getStore())
								->loadByEmail($username);
								$admin->setData('password',$password);
							}else{
								$postArray['use_as_admin'] = "y"; 
								$admin=null;
							}

						} else{
							//check if admin already exists.... 
							$admin =  Mage::getModel('customer/customer')
								->setStore(Mage::app()->getStore())
								->loadByEmail($institute->getData('admin_email'));

							if($admin && $admin->getId() > 0){
								$postArray['use_as_admin'] = "y"; 
								$this->_getSession()->addError($this->__("Customer with email '".$admin->getData('email')."' already exists. If you wish to add this user as the school's administrator, please provide the username and password and press continue."));
								$admin = null;
							}
							else{
								//create admin with the admin details provided in the form.
								$admin = Mage::getModel('customer/customer')->setId(null);
								$admin->setData('email',$institute->getData('admin_email'));
								$admin->setData('firstname',$institute->getData('admin_firstname'));
								$admin->setData('lastname',$institute->getData('admin_lastname'));
								$admin->setData('password',$institute->getData('admin_password'));
								$admin->setData('confirmation',$institute->getData('admin_confirmation'));
								$admin->getGroupId();

								//Mage::log("Addding the admin..");
								$this->addCustomerEntity($admin,array());
								$admin =  Mage::getModel('customer/customer')
									->setStore(Mage::app()->getStore())
									->loadByEmail($admin->getData('email'));
								$admin->setData('firstname',$institute->getData('admin_firstname'));
								$admin->setData('lastname',$institute->getData('admin_lastname'));
								$admin->setData('password',$institute->getData('admin_password'));
								//Mage::log("Added the admin... id is:".$admin->getId());

							}
						}

						if($admin && $admin->getId() > 0){
							$institute->setData('admin_id', $admin->getId());

							//Then... create customer_entity with the generated EmailId 
							$schoolCustomer = Mage::getModel('customer/customer')->setId(null);
							$schoolCustomer->setData('email',$email);
							$schoolCustomer->setData('firstname',$firstname);
							$schoolCustomer->setData('lastname',$lastname);
							$schoolCustomer->setData('password',$password);
							$schoolCustomer->setData('confirmation',$password);
							$schoolCustomer->getGroupId();
						
							// Set the address for this customer 
							//Mage::log($this->getRequest()->getPost());
							$address = Mage::getModel('customer/address')
									->setData($this->getRequest()->getPost())
									->setData('firstname',$firstname)
									->setData('lastname',$lastname)
									->setIsDefaultBilling(0)
									->setIsDefaultShipping(0)
									->setId(null);
							
							$schoolCustomer->addAddress($address);

							$errors = $address->validate();
							if (!is_array($errors)) {
								$errors = array();
							}
							try{
								//Mage::log("Addding the school customer....");
								$this->addCustomerEntity($schoolCustomer,$errors);
								//Mage::log("Added the school customer....");
								$schoolCustomer =  Mage::getModel('customer/customer')
									->setStore(Mage::app()->getStore())
									->loadByEmail($schoolCustomer->getData('email'));
								
								if($schoolCustomer && $schoolCustomer->getId() > 0 ){

									//and set this in the above institute model.

									// Get the file details from the post variables.
									$imageName= strtolower(trim(trim(substr(str_replace(" ","",$instituteName),0,10))."_".trim($institutePostcode)));
									$imageNameExtArr= explode(".",$_FILES['image']['name']);
									if( $imageNameExtArr && count($imageNameExtArr) >1 ){
									   $imageNameExt= ".".$imageNameExtArr[1];
									}else{
									   $imageNameExt=".jpg";
									}
									$imageName =$imageName.$imageNameExt ;
									$baseDir = Mage::getBaseDir('media') . DIRECTORY_SEPARATOR . 'social_institutes';
									$uploadedFileName = $baseDir . DIRECTORY_SEPARATOR . $imageName;
									$uploadedTmpFileName = $_FILES['image']['tmp_name'];
									move_uploaded_file($uploadedTmpFileName, $uploadedFileName);

									$institute->setImage($imageName);
									$institute->setEmail($email);
									$institute->setIsValid(0);
									try{
										$institute->save();

										if ($admin->isConfirmationRequired()) {
											$admin->sendNewAccountEmail('confirmation', $this->_getSession()->getBeforeAuthUrl());
											$this->_getSession()->addSuccess($this->__('Account confirmation is required. Please, check your e-mail for confirmation link. To resend confirmation email please <a href="%s">click here</a>.',
												Mage::helper('customer')->getEmailConfirmationUrl($admin->getEmail())
											));
											$this->_redirectSuccess(Mage::getUrl('customer/account/index', array('_secure'=>true)));
											return;
										}
										else {
											$this->_getCustomerSession()->setCustomerAsLoggedIn($admin);
											$url = $this->_welcomeCustomer($admin);
											$this->_redirectSuccess($url);
											return;
										}
									}
									catch (Mage_Core_Exception $e) {
										//$schoolCustomer->delete();
										//Mage::getModel('customer/customer')->delete($schoolCustomer);
										$this->_getSession()->addError($e->getMessage())
											->setInstituteFormData($this->getRequest()->getPost());
									}
									catch (Exception $e) {
										//$schoolCustomer->delete();
										//Mage::getModel('customer/customer')->delete($schoolCustomer);
										$this->_getSession()->setInstituteFormData($this->getRequest()->getPost())
											->addException($e, $this->__('Can\'t save institute. Error while saving the School Customer.'));
									}
								}else {
									//Mage::getModel('customer/customer')->delete($admin);
									//$admin->delete();
									$this->_getSession()->addError($this->__('Invalid School data. Unable to save institute.'));
								}
							}
							catch (Mage_Core_Exception $e) {
								$this->_getSession()->addError($e->getMessage())
									->setInstituteFormData($this->getRequest()->getPost());
							}
							catch (Exception $e) {
								$this->_getSession()->setInstituteFormData($this->getRequest()->getPost())
									->addException($e, $this->__('Can\'t save institute. Error while saving the School Customer.'));
							}
						}else{
							$this->_getSession()->addError($this->__('Invalid Insitute data. Administrator information is not available/valid.'));
						}
					}
					catch (Mage_Core_Exception $e) {
						$this->_getSession()->addError($e->getMessage())
							->setInstituteFormData($this->getRequest()->getPost());
					}
					catch (Exception $e) {
						$this->_getSession()->setInstituteFormData($this->getRequest()->getPost())
							->addException($e, $this->__('Can\'t save institute'));
					}
				}
			}else {
				$this->_getSession()->addError($this->__('Invalid Insitute data. Institute Name and Institute Postcode not available.'));
			}
        }
		//Mage::log(array_merge($this->getRequest()->getPost(),$postArray));
		$this->_getSession()->setInstituteFormData(array_merge($this->getRequest()->getPost(),$postArray));
        $this->_redirectError(Mage::getUrl('*/*/create', array('_secure'=>true)));
    }

    /**
     * Add welcome message and send new account email.
     * Returns success URL
     *
     * @param Mage_Customer_Model_Customer $customer
     * @param bool $isJustConfirmed
     * @return string
     */
    protected function _welcomeCustomer(Mage_Customer_Model_Customer $admin, $isJustConfirmed = false)
    {
        $this->_getCustomerSession()->addSuccess($this->__('Thank you for registering with %s', Mage::app()->getStore()->getName()));

        $admin->sendNewAccountEmail($isJustConfirmed ? 'confirmed' : 'registered_institute');

        $successUrl = Mage::getUrl('ekkitab_institute/search/myInstitutes/', array('_secure'=>true));
        //if ($this->_getCustomerSession()->getBeforeAuthUrl()) {
       //     $successUrl = $this->_getCustomerSession()->getBeforeAuthUrl(true);
        //}
        return $successUrl;
    }


	private function addCustomerEntity($customer,$errors){
		$validationCustomer = $customer->validate();
		if (is_array($validationCustomer)) {
			$errors = array_merge($validationCustomer, $errors);
		}
		$validationResult = count($errors) == 0;

		if (true === $validationResult) {
			$customer->save();
		} else {
			$this->_getSession()->setInstituteFormData($this->getRequest()->getPost());
			if (is_array($errors)) {
				foreach ($errors as $errorMessage) {
					$this->_getSession()->addError($errorMessage);
				}
			}
			else {
				$this->_getSession()->addError($this->__('Invalid Insitute data'));
			}
		}
		return ;
	}

	private function validateLoginForm($username,$password){
		try {
			$customer = Mage::getModel('customer/customer')
						->setWebsiteId(Mage::app()->getStore()->getWebsiteId());

			if($customer->authenticate($username, $password)){
				return true;
			} 
			return false;
		}
		catch (Exception $e) {
			switch ($e->getCode()) {
				case Mage_Customer_Model_Customer::EXCEPTION_EMAIL_NOT_CONFIRMED:
					$message = Mage::helper('customer')->__('This account is not confirmed. <a href="%s">Click here</a> to resend confirmation email.',
						Mage::helper('customer')->getEmailConfirmationUrl($login['username'])
					);
					break;
				case Mage_Customer_Model_Customer::EXCEPTION_INVALID_EMAIL_OR_PASSWORD:
					$message = $e->getMessage();
					break;
				default:
					$message = $e->getMessage();
			}
			$this->_getSession()->addError($message);
		}
		return false;
	}
}
