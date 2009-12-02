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
 * @package    Mage_Core
 * @copyright  Copyright (c) 2008 Irubin Consulting Inc. DBA Varien (http://www.varien.com)
 * @license    http://opensource.org/licenses/osl-3.0.php  Open Software License (OSL 3.0)
 */


/**
 * Core configuration class
 *
 * @category    Mage
 * @package     Mage_Core
 * @author      Magento Core Team <core@magentocommerce.com>
 */
class Mage_Core_Model_Config extends Mage_Core_Model_Config_Base
{
    const CACHE_TAG         = 'CONFIG';

    /**
     * Flag which allow use cache logic
     *
     * @var bool
     */
    protected $_useCache = false;

    /**
     * Instructions for spitting config cache
     * array(
     *      $sectionName => $recursionLevel
     * )
     * Recursion level provide availability cache subnodes separatly
     *
     * @var array
     */
    protected $_cacheSections = array(
        'admin'     => 0,
        'adminhtml' => 0,
        'crontab'   => 0,
        'install'   => 0,
        'stores'    => 1,
        'websites'  => 0
    );

    /**
     * Loaded Configuration by cached sections
     *
     * @var array
     */
    protected $_cacheLoadedSections = array();

    /**
     * Configuration options
     *
     * @var Mage_Core_Model_Config_Options
     */
    protected $_options;

    /**
     * Storage for generated class names
     *
     * @var array
     */
    protected $_classNameCache = array();

    /**
     * Storage for generated block class names
     *
     * @var unknown_type
     */
    protected $_blockClassNameCache = array();

    /**
     * Storage of validated secure urls
     *
     * @var array
     */
    protected $_secureUrlCache = array();

    /**
     * System environment server variables
     *
     * @var array
     */
    protected $_distroServerVars;

    /**
     * Array which is using for replace placeholders of server variables
     *
     * @var array
     */
    protected $_substServerVars;

    /**
     * Resource model
     * Used for operations with DB
     *
     * @var Mage_Core_Model_Mysql4_Config
     */
    protected $_resourceModel;

    /**
     * Configuration for events by area
     *
     * @var array
     */
    protected $_eventAreas;

    /**
     * Flag cache for existing or already created directories
     *
     * @var array
     */
    protected $_dirExists = array();

    /**
     * Flach which allow using cache for config initialization
     *
     * @var bool
     */
    protected $_allowCacheForInit = true;

    /**
     * Property used during cache save process
     *
     * @var array
     */
    protected $_cachePartsForSave = array();

    /**
     * Depricated properties
     *
     * @deprecated
     */
    protected $_baseDirCache = array();
    protected $_customEtcDir = null;

    /**
     * Flag which allow to use modules from local code pool
     *
     * @var bool
     */
    protected $_canUseLocalModules = null;

    /**
     * Class construct
     *
     * @param mixed $sourceData
     */
    public function __construct($sourceData=null)
    {
        $this->setCacheId('config_global');
        $this->_options = new Mage_Core_Model_Config_Options();
        parent::__construct($sourceData);
    }

    /**
     * Get config resource model
     *
     * @return Mage_Core_Store_Mysql4_Config
     */
    public function getResourceModel()
    {
        if (is_null($this->_resourceModel)) {
            $this->_resourceModel = Mage::getResourceModel('core/config');
        }
        return $this->_resourceModel;
    }

    /**
     * Get configuration options object
     *
     * @return Mage_Core_Model_Config_Options
     */
    public function getOptions()
    {
        return $this->_options;
    }

    /**
     * Initialization of core configuration
     *
     * @return Mage_Core_Model_Config
     */
    public function init($options=array())
    {
        $this->setCacheChecksum(null);
        $this->_cacheLoadedSections = array();
        if (is_array($options)) {
            $this->getOptions()->addData($options);
        }

        $etcDir = $this->getOptions()->getEtcDir();

        $localConfigLoaded  = $this->loadFile($etcDir.DS.'local.xml');

        if (Mage::isInstalled()) {
            if ($this->_canUseCacheForInit()) {
                Varien_Profiler::start('mage::app::init::config::load_cache');
                $loaded = $this->loadCache();
                Varien_Profiler::stop('mage::app::init::config::load_cache');
                if ($loaded) {
                    $this->_useCache = true;
                    return $this;
                }
            }
        }

        /**
         * Load base configuration data
         */
        $configFile = $etcDir.DS.'config.xml';
        $this->loadFile($configFile);
        $this->_loadDeclaredModules();

        /**
         * Load modules configuration data
         */
        Varien_Profiler::start('config/load-modules');
        $this->loadModulesConfiguration('config.xml', $this);
        Varien_Profiler::stop('config/load-modules');

        /**
         * Load local configuration data
         */
        Varien_Profiler::start('config/load-local');

        $mergeConfig = new Mage_Core_Model_Config_Base();
        $configFile  = $etcDir.DS.'local.xml';
        if (is_readable($configFile)) {
            $mergeConfig->loadFile($configFile);
            $this->extend($mergeConfig);
        }

        Varien_Profiler::stop('config/load-local');

        $this->applyExtends();

        /**
         * Load configuration from DB
         */
        if ($localConfigLoaded) {
            Varien_Profiler::start('dbUpdates');
            Mage_Core_Model_Resource_Setup::applyAllUpdates();
            Varien_Profiler::stop('dbUpdates');

            Varien_Profiler::start('config/load-db');
            $dbConf = $this->getResourceModel();
            $dbConf->loadToXml($this);
            Varien_Profiler::stop('config/load-db');
        }

        if (Mage::app()->useCache('config')) {
            $this->saveCache(array(self::CACHE_TAG));
        }

        return $this;
    }

    /**
     * Reinitialize configuration
     *
     * @param   array $options
     * @return  Mage_Core_Model_Config
     */
    public function reinit($options = array())
    {
        $this->_allowCacheForInit = false;
        $this->_useCache = false;
        return $this->init($options);
    }

    /**
     * Check local modules enable/disable flag
     * If local modules are disbled remove local modules path from include dirs
     *
     * return true if local modules enabled and false if disabled
     *
     * @return bool
     */
    protected function _canUseLocalModules()
    {
        if ($this->_canUseLocalModules !== null) {
            return $this->_canUseLocalModules;
        }

        $disableLocalModules = (string)$this->getNode('global/disable_local_modules');
        if (!empty($disableLocalModules)) {
            $disableLocalModules = (('true' === $disableLocalModules) || ('1' === $disableLocalModules));
        } else {
            $disableLocalModules = false;
        }

        if ($disableLocalModules) {
            set_include_path(
                // excluded '/app/code/local'
                BP . DS . 'app' . DS . 'code' . DS . 'community' . PS .
                BP . DS . 'app' . DS . 'code' . DS . 'core' . PS .
                BP . DS . 'lib' . PS .
                Mage::registry('original_include_path')
            );
        }
        $this->_canUseLocalModules = !$disableLocalModules;
        return $this->_canUseLocalModules;
    }

    /**
     * Check if cache can be used for config initialization
     *
     * @return bool
     */
    protected function _canUseCacheForInit()
    {
        return Mage::app()->useCache('config') && $this->_allowCacheForInit && !$this->_loadCache($this->_getCacheLockId());
    }

    /**
     * Retrieve cache object
     *
     * @return Zend_Cache_Frontend_File
     */
    public function getCache()
    {
        return Mage::app()->getCache();
    }

    /**
     * Get lock flag cache identifier
     *
     * @return string
     */
    protected function _getCacheLockId()
    {
        return $this->getCacheId().'.lock';
    }

    /**
     * Save configuration cache
     *
     * @param   array $tags cache tags
     * @return  Mage_Core_Model_Config
     */
    public function saveCache($tags=array())
    {
        $cacheLockId = $this->_getCacheLockId();
        if ($this->_loadCache($cacheLockId)) {
            return $this;
        }

        if (!empty($this->_cacheSections)) {
            $xml = clone $this->_xml;
            foreach ($this->_cacheSections as $sectionName => $level) {
                $this->_saveSectionCache($this->getCacheId(), $sectionName, $xml, $level, $tags);
                unset($xml->$sectionName);
            }
            $this->_cachePartsForSave[$this->getCacheId()] = $xml->asNiceXml('', false);
        } else {
            return parent::saveCache($tags);
        }

        $this->_saveCache(time(), $cacheLockId, array(), 60);
        $this->removeCache();
        foreach ($this->_cachePartsForSave as $cacheId => $cacheData) {
            $this->_saveCache($cacheData, $cacheId, $tags, $this->getCacheLifetime());
        }
        unset($this->_cachePartsForSave);
        $this->_removeCache($cacheLockId);
        return $this;
    }

    /**
     * Save cache of specified
     *
     * @param   string $idPrefix cache id prefix
     * @param   string $sectionName
     * @param   Varien_Simplexml_Element $source
     * @param   int $recursionLevel
     * @return  Mage_Core_Model_Config
     */
    protected function _saveSectionCache($idPrefix, $sectionName, $source, $recursionLevel=0, $tags=array())
    {
        if ($source && $source->$sectionName) {
            $cacheId = $idPrefix . '_' . $sectionName;
            if ($recursionLevel > 0) {
                foreach ($source->$sectionName->children() as $subSectionName => $node) {
                    $this->_saveSectionCache($cacheId, $subSectionName, $source->$sectionName, $recursionLevel-1, $tags);
                }
            }
            $this->_cachePartsForSave[$cacheId] = $source->$sectionName->asNiceXml('', false);
        }
        return $this;
    }

    /**
     * Load config section cached data
     *
     * @param   string $sectionName
     * @return  Varien_Simplexml_Element
     */
    protected function _loadSectionCache($sectionName)
    {
        $cacheId = $this->getCacheId() . '_' . $sectionName;
        $xmlString = $this->_loadCache($cacheId);

        /**
         * If we can't load section cache (problems with cache storage)
         */
        if (!$xmlString) {
            $this->_useCache = false;
            $this->reinit($this->_options);
            return false;
        } else {
            $xml = simplexml_load_string($xmlString, $this->_elementClass);
            return $xml;
        }
    }

    /**
     * Load cached data by identifier
     *
     * @param   string $id
     * @return  string
     */
    protected function _loadCache($id)
    {
        return Mage::app()->loadCache($id);
    }

    /**
     * Save cache data
     *
     * @param   string $data
     * @param   string $id
     * @param   array $tags
     * @param   false|int $lifetime
     * @return  Mage_Core_Model_Config
     */
    protected function _saveCache($data, $id, $tags=array(), $lifetime=false)
    {
        return Mage::app()->saveCache($data, $id, $tags, $lifetime);
    }

    /**
     * Clear cache data by id
     *
     * @param   string $id
     * @return  Mage_Core_Model_Config
     */
    protected function _removeCache($id)
    {
        return Mage::app()->removeCache($id);
    }

    /**
     * Remove configuration cache
     *
     * @return Mage_Core_Model_Config
     */
    public function removeCache()
    {
        Mage::app()->cleanCache(array(self::CACHE_TAG));
        return parent::removeCache();
    }

    /**
     * Configuration cache clean process
     *
     * @return Mage_Core_Model_Config
     */
    public function cleanCache()
    {
        return $this->reinit();
    }

    /**
     * Get node value from cached section data
     *
     * @param   array $path
     * @return  Mage_Core_Model_Config
     */
    public function getSectionNode($path)
    {
        $section    = $path[0];
        $recursion  = $this->_cacheSections[$section];
        $sectioPath = array_slice($path, 0, $recursion+1);
        $path       = array_slice($path, $recursion+1);
        $sectionKey = implode('_', $sectioPath);

        if (!isset($this->_cacheLoadedSections[$sectionKey])) {
            Varien_Profiler::start('mage::app::init::config::section::'.$sectionKey);
            $this->_cacheLoadedSections[$sectionKey] = $this->_loadSectionCache($sectionKey);
            Varien_Profiler::stop('mage::app::init::config::section::'.$sectionKey);
        }

        if ($this->_cacheLoadedSections[$sectionKey] === false) {
            return false;
        }
        return $this->_cacheLoadedSections[$sectionKey]->descend($path);
    }

    /**
     * Returns node found by the $path and scope info
     *
     * @param   string $path
     * @param   string $scope
     * @param   string $scopeCode
     * @return Mage_Core_Model_Config_Element
     */
    public function getNode($path=null, $scope='', $scopeCode=null)
    {
        if ($scope !== '') {
            if (('store' === $scope) || ('website' === $scope)) {
                $scope .= 's';
            }
            if (('default' !== $scope) && is_int($scopeCode)) {
                if ('stores' == $scope) {
                    $scopeCode = Mage::app()->getStore($scopeCode)->getCode();
                } elseif ('websites' == $scope) {
                    $scopeCode = Mage::app()->getWebsite($scopeCode)->getCode();
                } else {
                    Mage::throwException(Mage::helper('core')->__('Unknown scope "%s"', $scope));
                }
            }
            $path = $scope . ($scopeCode ? '/' . $scopeCode : '' ) . (empty($path) ? '' : '/' . $path);
        }

        /**
         * Check path cache loading
         */
        if ($this->_useCache && ($path !== null)) {
            $path   = explode('/', $path);
            $section= $path[0];
            if (isset($this->_cacheSections[$section])) {
                $res = $this->getSectionNode($path);
                if ($res !== false) {
                    return $res;
                }
            }
        }
        return parent::getNode($path);
    }

    /**
     * Retrive Declared Module file list
     *
     * @return array
     */
    protected function _getDeclaredModuleFiles()
    {
        $etcDir = $this->getOptions()->getEtcDir();
        $moduleFiles = glob($etcDir . DS . 'modules' . DS . '*.xml');

        if (!$moduleFiles) {
            return false;
        }

        $collectModuleFiles = array(
            'base'   => array(),
            'mage'   => array(),
            'custom' => array()
        );

        foreach ($moduleFiles as $v) {
            $name = explode(DIRECTORY_SEPARATOR, $v);
            $name = substr($name[count($name) - 1], 0, -4);

            if ($name == 'Mage_All') {
                $collectModuleFiles['base'][] = $v;
            }
            elseif (substr($name, 0, 5) == 'Mage_') {
                $collectModuleFiles['mage'][] = $v;
            }
            else {
                $collectModuleFiles['custom'][] = $v;
            }
        }

        return array_merge(
            $collectModuleFiles['base'],
            $collectModuleFiles['mage'],
            $collectModuleFiles['custom']
        );
    }

    /**
     * Load declared modules configuration
     *
     * @param   null $mergeConfig depricated
     * @return  Mage_Core_Model_Config
     */
    protected function _loadDeclaredModules($mergeConfig = null)
    {
        $moduleFiles = $this->_getDeclaredModuleFiles();
        if (!$moduleFiles) {
            return ;
        }

        Varien_Profiler::start('config/load-modules-declaration');

        $unsortedConfig = new Mage_Core_Model_Config_Base();
        $unsortedConfig->loadString('<config/>');
        $fileConfig = new Mage_Core_Model_Config_Base();

        // load modules declarations
        foreach ($moduleFiles as $file) {
            $fileConfig->loadFile($file);
            $unsortedConfig->extend($fileConfig);
        }

        $moduleDepends = array();
        foreach ($unsortedConfig->getNode('modules')->children() as $moduleName => $moduleNode) {
            $depends = array();
            if ($moduleNode->depends) {
                foreach ($moduleNode->depends->children() as $depend) {
                    $depends[$depend->getName()] = true;
                }
            }
            $moduleDepends[$moduleName] = array(
                'module'    => $moduleName,
                'depends'   => $depends,
                'active'    => ('true' === (string)$moduleNode->active ? true : false),
            );
        }

        // check and sort module dependens
        $moduleDepends = $this->_sortModuleDepends($moduleDepends);

        // create sorted config
        $sortedConfig = new Mage_Core_Model_Config_Base();
        $sortedConfig->loadString('<config><modules/></config>');

        foreach ($unsortedConfig->getNode()->children() as $nodeName => $node) {
            if ($nodeName != 'modules') {
                $sortedConfig->getNode()->appendChild($node);
            }
        }

        foreach ($moduleDepends as $moduleProp) {
            $node = $unsortedConfig->getNode('modules/'.$moduleProp['module']);
            $sortedConfig->getNode('modules')->appendChild($node);
        }

        $this->extend($sortedConfig);

        Varien_Profiler::stop('config/load-modules-declaration');
        return $this;
    }

    /**
     * Sort modules and check depends
     *
     * @param array $modules
     * @return array
     */
    protected function _sortModuleDepends($modules)
    {
        foreach ($modules as $moduleName => $moduleProps) {
            $depends = $moduleProps['depends'];
            foreach ($moduleProps['depends'] as $depend => $true) {
                if ($moduleProps['active'] && ((!isset($modules[$depend])) || empty($modules[$depend]['active']))) {
                    Mage::throwException(Mage::helper('core')->__('Module "%1$s" requires module "%2$s"', $moduleName, $depend));
                }
                $depends = array_merge($depends, $modules[$depend]['depends']);
            }
            $modules[$moduleName]['depends'] = $depends;
        }
        $modules = array_values($modules);

        $size = count($modules) - 1;
        for ($i = $size; $i >= 0; $i--) {
            for ($j = $size; $i < $j; $j--) {
                if (isset($modules[$i]['depends'][$modules[$j]['module']])) {
                    $value       = $modules[$i];
                    $modules[$i] = $modules[$j];
                    $modules[$j] = $value;
                }
            }
        }

        $definedModules = array();
        foreach ($modules as $moduleProp) {
            foreach ($moduleProp['depends'] as $dependModule => $true) {
                if (!isset($definedModules[$dependModule])) {
                    Mage::throwException(
                        Mage::helper('core')->__('Module "%1$s" can not be depended from "%2$s"', $moduleProp['module'], $dependModule)
                    );
                }
            }
            $definedModules[$moduleProp['module']] = true;
        }

        return $modules;
    }

    /**
     * Iterate all active modules "etc" folders and combine data from
     * specidied xml file name to one object
     *
     * @param   string $fileName
     * @param   null|Mage_Core_Model_Config_Base $mergeToObject
     * @return  Mage_Core_Model_Config_Base
     */
    public function loadModulesConfiguration($fileName, $mergeToObject = null, $mergeModel=null)
    {
        $disableLocalModules    = !$this->_canUseLocalModules();

        if ($mergeToObject === null) {
            $mergeToObject = new Mage_Core_Model_Config_Base();
            $mergeToObject->loadString('<config/>');
        }
        if ($mergeModel === null) {
            $mergeModel = new Mage_Core_Model_Config_Base();
        }
        $modules = $this->getNode('modules')->children();
        foreach ($modules as $modName=>$module) {
            if ($module->is('active')) {
                if ($disableLocalModules && ('local' === (string)$module->codePool)) {
                    continue;
                }
                $configFile = $this->getModuleDir('etc', $modName).DS.$fileName;
                if ($mergeModel->loadFile($configFile)) {
                    $mergeToObject->extend($mergeModel, true);
                }
            }
        }
        return $mergeToObject;
    }

    /**
     * Retrieve temporary directory path
     *
     * @return string
     */
    public function getTempVarDir()
    {
        return $this->getOptions()->getVarDir();
    }

    /**
     * Get default server variables values
     *
     * @return array
     */
    public function getDistroServerVars()
    {
        if (!$this->_distroServerVars) {

            if (isset($_SERVER['SCRIPT_NAME']) && isset($_SERVER['HTTP_HOST'])) {
                $secure = (!empty($_SERVER['HTTPS']) && ($_SERVER['HTTPS']!='off')) || $_SERVER['SERVER_PORT']=='443';
                $scheme = ($secure ? 'https' : 'http') . '://' ;

                $hostArr = explode(':', $_SERVER['HTTP_HOST']);
                $host = $hostArr[0];
                $port = isset($hostArr[1]) && (!$secure && $hostArr[1]!=80 || $secure && $hostArr[1]!=443) ? ':'.$hostArr[1] : '';
                $path = Mage::app()->getRequest()->getBasePath();

                $baseUrl = $scheme.$host.$port.rtrim($path, '/').'/';
            } else {
                $baseUrl = 'http://localhost/';
            }

            $options = $this->getOptions();
            $this->_distroServerVars = array(
                'root_dir'  => $options->getBaseDir(),
                'app_dir'   => $options->getAppDir(),
                'var_dir'   => $options->getVarDir(),
                'base_url'  => $baseUrl,
            );

            foreach ($this->_distroServerVars as $k=>$v) {
                $this->_substServerVars['{{'.$k.'}}'] = $v;
            }
        }
        return $this->_distroServerVars;
    }

    public function substDistroServerVars($data)
    {
        $this->getDistroServerVars();
        return str_replace(
            array_keys($this->_substServerVars),
            array_values($this->_substServerVars),
            $data
        );
    }

    /**
     * Get module config node
     *
     * @param string $moduleName
     * @return Varien_Simplexml_Object
     */
    function getModuleConfig($moduleName='')
    {
        $modules = $this->getNode('modules');
        if (''===$moduleName) {
            return $modules;
        } else {
            return $modules->$moduleName;
        }
    }

    /**
     * Get module setup class instance.
     *
     * Defaults to Mage_Core_Setup
     *
     * @param string|Varien_Simplexml_Object $module
     * @return object
     */
    function getModuleSetup($module='')
    {
        $className = 'Mage_Core_Setup';
        if (''!==$module) {
            if (is_string($module)) {
                $module = $this->getModuleConfig($module);
            }
            if (isset($module->setup)) {
                $moduleClassName = $module->setup->getClassName();
                if (!empty($moduleClassName)) {
                    $className = $moduleClassName;
                }
            }
        }
        return new $className($module);
    }

    /**
     * Get base filesystem directory. depends on $type
     *
     * If $moduleName is specified retrieves specific value for the module.
     *
     * @deprecated in favor of Mage_Core_Model_Config_Options
     * @todo get global dir config
     * @param string $type
     * @return string
     */
    public function getBaseDir($type='base')
    {
        return $this->getOptions()->getDir($type);
    }

    /**
     * Get temporary data directory name
     *
     * @param   string $path
     * @param   string $type
     * @return  string
     */
    public function getVarDir($path=null, $type='var')
    {
        $dir = Mage::getBaseDir($type).($path!==null ? DS.$path : '');
        if (!$this->createDirIfNotExists($dir)) {
            return false;
        }
        return $dir;
    }

    public function createDirIfNotExists($dir)
    {
        return $this->getOptions()->createDirIfNotExists($dir);
    }

    /**
     * Get module directory by directory type
     *
     * @param   string $type
     * @param   string $moduleName
     * @return  string
     */
    public function getModuleDir($type, $moduleName)
    {
        $codePool = (string)$this->getModuleConfig($moduleName)->codePool;
        $dir = $this->getOptions()->getCodeDir().DS.$codePool.DS.uc_words($moduleName, DS);

        switch ($type) {
            case 'etc':
                $dir .= DS.'etc';
                break;

            case 'controllers':
                $dir .= DS.'controllers';
                break;

            case 'sql':
                $dir .= DS.'sql';
                break;

            case 'locale':
                $dir .= DS.'locale';
                break;
        }

        $dir = str_replace('/', DS, $dir);
        return $dir;
    }

    /**
     * Load event observers for an area (front, admin)
     *
     * @param   string $area
     * @return  boolean
     */
    public function loadEventObservers($area)
    {
        $events = $this->getNode("$area/events");
        if ($events) {
            $events = $events->children();
        }
        else {
            return false;
        }

        foreach ($events as $event) {
            $eventName = $event->getName();
            $observers = $event->observers->children();
            foreach ($observers as $observer) {
                switch ((string)$observer->type) {
                    case 'singleton':
                        $callback = array(
                            Mage::getSingleton((string)$observer->class),
                            (string)$observer->method
                        );
                        break;
                    case 'object':
                    case 'model':
                        $callback = array(
                            Mage::getModel((string)$observer->class),
                            (string)$observer->method
                        );
                        break;
                    default:
                        $callback = array($observer->getClassName(), (string)$observer->method);
                        break;
                }

                $args = (array)$observer->args;
                $observerClass = $observer->observer_class ? (string)$observer->observer_class : '';
                Mage::addObserver($eventName, $callback, $args, $observer->getName(), $observerClass);
            }
        }
        return true;
    }

    /**
     * Get standard path variables.
     *
     * To be used in blocks, templates, etc.
     *
     * @param array|string $args Module name if string
     * @return array
     */
    public function getPathVars($args=null)
    {
        $path = array();

        $path['baseUrl'] = Mage::getBaseUrl();
        $path['baseSecureUrl'] = Mage::getBaseUrl('link', true);

        return $path;
    }

    /**
     * Retrieve class name by class group
     *
     * @param   string $groupType currently supported model, block, helper
     * @param   string $classId slash separated class identifier, ex. group/class
     * @param   string $groupRootNode optional config path for group config
     * @return  string
     */
    public function getGroupedClassName($groupType, $classId, $groupRootNode=null)
    {
        if (empty($groupRootNode)) {
            $groupRootNode = 'global/'.$groupType.'s';
        }

        $classArr = explode('/', trim($classId));
        $group = $classArr[0];
        $class = !empty($classArr[1]) ? $classArr[1] : null;

        if (isset($this->_classNameCache[$groupRootNode][$group][$class])) {
            return $this->_classNameCache[$groupRootNode][$group][$class];
        }

        //$config = $this->getNode($groupRootNode.'/'.$group);
        $config = $this->_xml->global->{$groupType.'s'}->{$group};

        if (isset($config->rewrite->$class)) {
            $className = (string)$config->rewrite->$class;
        } else {
            if (!empty($config)) {
                $className = $config->getClassName();
            }
            if (empty($className)) {
                $className = 'mage_'.$group.'_'.$groupType;
            }
            if (!empty($class)) {
                $className .= '_'.$class;
            }
            $className = uc_words($className);
        }

        $this->_classNameCache[$groupRootNode][$group][$class] = $className;
        return $className;
    }

    /**
     * Retrieve block class name
     *
     * @param   string $blockType
     * @return  string
     */
    public function getBlockClassName($blockType)
    {
        if (strpos($blockType, '/')===false) {
            return $blockType;
        }
        return $this->getGroupedClassName('block', $blockType);
    }

    /**
     * Retrieve helper class name
     *
     * @param   string $name
     * @return  string
     */
    public function getHelperClassName($helperName)
    {
        if (strpos($helperName, '/')===false) {
            $helperName .= '/data';
        }
        return $this->getGroupedClassName('helper', $helperName);
    }

    /**
     * Retrieve modele class name
     *
     * @param   sting $modelClass
     * @return  string
     */
    public function getModelClassName($modelClass)
    {
        $modelClass = trim($modelClass);
        if (strpos($modelClass, '/')===false) {
            return $modelClass;
        }
        return $this->getGroupedClassName('model', $modelClass);
    }

    /**
     * Get model class instance.
     *
     * Example:
     * $config->getModelInstance('catalog/product')
     *
     * Will instantiate Mage_Catalog_Model_Mysql4_Product
     *
     * @param string $modelClass
     * @param array|object $constructArguments
     * @return Mage_Core_Model_Abstract
     */
    public function getModelInstance($modelClass='', $constructArguments=array())
    {
        $className = $this->getModelClassName($modelClass);
        if (class_exists($className)) {
            Varien_Profiler::start('CORE::create_object_of::'.$className);
            $obj = new $className($constructArguments);
            Varien_Profiler::stop('CORE::create_object_of::'.$className);
            return $obj;
        } else {
            #throw Mage::exception('Mage_Core', Mage::helper('core')->__('Model class does not exist: %s', $modelClass));
            return false;
        }
    }

    public function getNodeClassInstance($path)
    {
        $config = Mage::getConfig()->getNode($path);
        if (!$config) {
            return false;
        } else {
            $className = $config->getClassName();
            return new $className();
        }
    }

    /**
     * Get resource model object by alias
     *
     * @param   string $modelClass
     * @param   array $constructArguments
     * @return  object
     */
    public function getResourceModelInstance($modelClass='', $constructArguments=array())
    {
        $factoryName = $this->_getResourceModelFactoryClassName($modelClass);
        if (!$factoryName) {
            return false;
        }
        return $this->getModelInstance($factoryName, $constructArguments);
    }

    /**
     * Get resource configuration for resource name
     *
     * @param string $name
     * @return Varien_Simplexml_Object
     */
    public function getResourceConfig($name)
    {
        return $this->_xml->global->resources->{$name};
    }

    /**
     * Get connection configuration
     *
     * @param   string $name
     * @return  Varien_Simplexml_Element
     */
    public function getResourceConnectionConfig($name)
    {
        $config = $this->getResourceConfig($name);
        if ($config) {
            $conn = $config->connection;
            if (!empty($conn->use)) {
                return $this->getResourceConnectionConfig((string)$conn->use);
            } else {
                return $conn;
            }
        }
        return false;
    }

    /**
     * Retrieve resource type configuration for resource name
     *
     * @param string $type
     * @return Varien_Simplexml_Object
     */
    public function getResourceTypeConfig($type)
    {
        return $this->_xml->global->resource->connection->types->{$type};
    }

    /**
     * Retrieve store Ids for $path with checking
     *
     * if empty $allowValues then retrieve all stores values
     *
     * return array($storeId=>$pathValue)
     *
     * @param   string $path
     * @param   array  $allowValues
     * @return  array
     */
    public function getStoresConfigByPath($path, $allowValues = array(), $useAsKey = 'id')
    {
        $storeValues = array();
        $stores = $this->getNode('stores');
        foreach ($stores->children() as $code => $store) {
            switch ($useAsKey) {
                case 'id':
                    $key = (int) $store->descend('system/store/id');
                    break;

                case 'code':
                    $key = $code;
                    break;

                case 'name':
                    $key = (string) $store->descend('system/store/name');
            }
            if ($key === false) {
                continue;
            }

            $pathValue = (string) $store->descend($path);

            if (empty($allowValues)) {
                $storeValues[$key] = $pathValue;
            }
            elseif(in_array($pathValue, $allowValues)) {
                $storeValues[$key] = $pathValue;
            }
        }
        return $storeValues;
    }

    /**
     * Check security requirements for url
     *
     * @param   string $url
     * @return  bool
     */
    public function shouldUrlBeSecure($url)
    {
        if (!isset($this->_secureUrlCache[$url])) {
            $this->_secureUrlCache[$url] = false;
            $secureUrls = $this->getNode('frontend/secure_url');
            foreach ($secureUrls->children() as $match) {
                if (strpos($url, (string)$match)===0) {
                    $this->_secureUrlCache[$url] = true;
                    break;
                }
            }
        }

        return $this->_secureUrlCache[$url];
    }

    /**
     * Get DB table names prefix
     *
     * @return string
     */
    public function getTablePrefix()
    {
        return $this->_xml->global->resources->db->table_prefix;
    }

    /**
     * Get events configuration
     *
     * @param   string $area event area
     * @param   string $eventName event name
     * @return  Mage_Core_Model_Config_Element
     */
    public function getEventConfig($area, $eventName)
    {
        //return $this->getNode($area)->events->{$eventName};
        if (!isset($this->_eventAreas[$area])) {
            $this->_eventAreas[$area] = $this->getNode($area)->events;
        }
        return $this->_eventAreas[$area]->{$eventName};
    }

    /**
     * Save config value to DB
     *
     * @param string $path
     * @param string $value
     * @param string $scope
     * @param int $scopeId
     * @return Mage_Core_Store_Config
     */
    public function saveConfig($path, $value, $scope = 'default', $scopeId = 0)
    {
        $resource = $this->getResourceModel();
        $resource->saveConfig(rtrim($path, '/'), $value, $scope, $scopeId);

        return $this;
    }

    /**
     * Delete config value from DB
     *
     * @param   string $path
     * @param   string $scope
     * @param   int $scopeId
     * @return  Mage_Core_Model_Config
     */
    public function deleteConfig($path, $scope = 'default', $scopeId = 0)
    {
        $resource = $this->getResourceModel();
        $resource->deleteConfig(rtrim($path, '/'), $scope, $scopeId);

        return $this;
    }

    /**
     * Get fieldset from configuration
     *
     * @param string $name fieldset name
     * @param string $root fieldset area, could be 'admin'
     * @return null|array
     */
    public function getFieldset($name, $root = 'global')
    {
        $rootNode = $this->getNode($root.'/fieldsets');
        if (!$rootNode) {
            return null;
        }
        return $rootNode->$name ? $rootNode->$name->children() : null;
    }

    /**
     * Get factory class name for for a resource
     *
     * @param string $modelClass
     * @return string|false
     */
    protected function _getResourceModelFactoryClassName($modelClass)
    {
        $classArr = explode('/', $modelClass);

        $resourceModel = false;

        if (!isset($this->_xml->global->models->{$classArr[0]})) {
            return false;
        }

        $module = $this->_xml->global->models->{$classArr[0]};

        if ((count($classArr)==2)
            && isset($module->{$classArr[1]}->resourceModel)
            && $resourceInfo = $module->{$classArr[1]}->resourceModel) {
            $resourceModel = (string) $resourceInfo;
        }
        elseif (isset($module->resourceModel) && $resourceInfo = $module->resourceModel) {
            $resourceModel = (string) $resourceInfo;
        }

        if (!$resourceModel) {
            return false;
        }
        return $resourceModel . '/' . $classArr[1];
    }

    /**
     * Get a resource model class name
     *
     * @param string $modelClass
     * @return string|false
     */
    public function getResourceModelClassName($modelClass)
    {
        $factoryName = $this->_getResourceModelFactoryClassName($modelClass);
        if ($factoryName) {
            return $this->getModelClassName($factoryName);
        }
        return false;
    }
}
