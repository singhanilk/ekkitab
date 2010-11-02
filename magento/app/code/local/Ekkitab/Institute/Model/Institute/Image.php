<?php

/**
 * Catalog product link model
 *
 * @category   Ekkitab
 * @package    Ekkitab_Institute
 * @author      Ekkitab Core Team 
 */
class Ekkitab_Institute_Model_Institute_Image extends Mage_Catalog_Model_Product_Image
{
   
    protected $_width;
    protected $_height;

    protected $_keepAspectRatio  = true;
    protected $_keepFrame        = true;
    protected $_keepTransparency = true;
    protected $_constrainOnly    = false;
    protected $_backgroundColor  = array(255, 255, 255);

    protected $_baseFile;
    protected $_newFile;
    protected $_processor;
    protected $_destinationSubdir;
    protected $_angle;
    protected $_watermarkPosition;
    protected $_watermarkWidth;
    protected $_watermarkHeigth;
    

	/**
     * Set filenames for base file and new file
     *
     * @param string $file
     * @return Mage_Catalog_Model_Product_Image
     */
    public function setBaseFile($file)
    {
        if (($file) && (0 !== strpos($file, '/', 0))) {
            $file = '/' . $file;
        }
        $baseDir = Mage::getBaseDir('media') . DIRECTORY_SEPARATOR . 'social_institutes';
		Mage::log("base dir is : $baseDir");
        if ('/no_selection' == $file) {
            $file = null;
        }
        if ($file) {
            if ((!file_exists($baseDir . $file)) || !$this->_checkMemory($baseDir . $file)) {
                $file = null;
            }
        }
        if (!$file) {
            // check if placeholder defined in config
            $isConfigPlaceholder = Mage::getStoreConfig("ekkitab/social_institutes/placeholder/{$this->getDestinationSubdir()}_placeholder");
			Mage::log("isConfigPlaceholder dir is : $isConfigPlaceholder");
            $configPlaceholder   = '/placeholder/' . $isConfigPlaceholder;
			Mage::log("configPlaceholder dir is : $configPlaceholder");
            if ($isConfigPlaceholder && file_exists($baseDir . $configPlaceholder)) {
                $file = $configPlaceholder;
            }
            else {
                // replace file with skin or default skin placeholder
                $skinBaseDir     = Mage::getDesign()->getSkinBaseDir();
                $skinPlaceholder = "/images/social_institutes/placeholder/{$this->getDestinationSubdir()}.png";
                $file = $skinPlaceholder;
                if (file_exists($skinBaseDir . $file)) {
                    $baseDir = $skinBaseDir;
                }
                else {
                    $baseDir = Mage::getDesign()->getSkinBaseDir(array('_theme' => 'default'));
                }
            }
        }

        $baseFile = $baseDir . $file;

        if ((!$file) || (!file_exists($baseFile))) {
            throw new Exception(Mage::helper('ekkitab_institute')->__('Image file not found'));
        }
        $this->_baseFile = $baseFile;

        // build new filename (most important params)
        $path = array(
            Mage::getBaseDir('media') . DIRECTORY_SEPARATOR . 'social_institutes',
            'cache',
            Mage::app()->getStore()->getId(),
            $path[] = $this->getDestinationSubdir()
        );
        if((!empty($this->_width)) || (!empty($this->_height)))
            $path[] = "{$this->_width}x{$this->_height}";
        // add misc params as a hash
        $path[] = md5(
            implode('_', array(
                ($this->_keepAspectRatio  ? '' : 'non') . 'proportional',
                ($this->_keepFrame        ? '' : 'no')  . 'frame',
                ($this->_keepTransparency ? '' : 'no')  . 'transparency',
                ($this->_constrainOnly ? 'do' : 'not')  . 'constrainonly',
                $this->_rgbToString($this->_backgroundColor),
                'angle' . $this->_angle
            ))
        );
        // append prepared filename
        $this->_newFile = implode('/', $path) . $file; // the $file contains heading slash

        return $this;
    }



    /**
     * @return Mage_Catalog_Model_Product_Image
     */
    public function setWatermark($file, $position=null, $size=null, $width=null, $heigth=null)
    {
        $filename = false;

        if( !$file ) {
            return $this;
        }

        $baseDir = Mage::getBaseDir('media') . DIRECTORY_SEPARATOR . 'social_institutes';

        if( file_exists($baseDir . '/watermark/stores/' . Mage::app()->getStore()->getId() . $file) ) {
            $filename = $baseDir . '/watermark/stores/' . Mage::app()->getStore()->getId() . $file;
        } elseif ( file_exists($baseDir . '/watermark/websites/' . Mage::app()->getWebsite()->getId() . $file) ) {
            $filename = $baseDir . '/watermark/websites/' . Mage::app()->getWebsite()->getId() . $file;
        } elseif ( file_exists($baseDir . '/watermark/default/' . $file) ) {
            $filename = $baseDir . '/watermark/default/' . $file;
        } elseif ( file_exists($baseDir . '/watermark/' . $file) ) {
            $filename = $baseDir . '/watermark/' . $file;
        } else {
            $baseDir = Mage::getDesign()->getSkinBaseDir();
            if( file_exists($baseDir . $file) ) {
                $filename = $baseDir . $file;
            }
        }

        if( $filename ) {
            $this->getImageProcessor()
                ->setWatermarkPosition( ($position) ? $position : $this->getWatermarkPosition() )
                ->setWatermarkWidth( ($width) ? $width : $this->getWatermarkWidth() )
                ->setWatermarkHeigth( ($heigth) ? $heigth : $this->getWatermarkHeigth() )
                ->watermark($filename);
        }

        return $this;
    }

    public function clearCache()
    {
        $directory = Mage::getBaseDir('media') . DS.'social_institutes'.DS.'cache'.DS;
        $io = new Varien_Io_File();
        $io->rmdir($directory, true);
    }

	    /**
     * Convert array of 3 items (decimal r, g, b) to string of their hex values
     *
     * @param array $rgbArray
     * @return string
     */
    private function _rgbToString($rgbArray)
    {
        $result = array();
        foreach ($rgbArray as $value) {
            if (null === $value) {
                $result[] = 'null';
            }
            else {
                $result[] = sprintf('%02s', dechex($value));
            }
        }
        return implode($result);
    }

}