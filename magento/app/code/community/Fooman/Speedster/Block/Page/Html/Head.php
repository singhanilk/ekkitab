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
 * @category   Mage
 * @copyright  Copyright (c) 2008 Irubin Consulting Inc. DBA Varien (http://www.varien.com) (original implementation)
 * @copyright  Copyright (c) 2008 FOOMAN (http://www.fooman.co.nz) (use of Minify Library)
 * @license    http://opensource.org/licenses/osl-3.0.php  Open Software License (OSL 3.0)
 */

/**
 * Html page block
 *
 * @package  Fooman_Speedster
 * @author     FOOMAN (http://www.fooman.co.nz)
 */
set_include_path( BP.DS.'lib'.DS.'minify'.DS.'lib'. PS . get_include_path());
require  'Minify'. DS .'BuildSpeedster.php';

class Fooman_Speedster_Block_Page_Html_Head extends Mage_Page_Block_Html_Head
{

    public function getCssJsHtml()
    {
        // Figure out if we are run from a subdirectory
        //$dir=explode("index.php" , htmlentities($_SERVER['SCRIPT_NAME']));
        //$webroot=$dir[0];
        $webroot="/";

        $lines = array();

        $baseJs = Mage::getBaseUrl('js');
        $baseJsFast = Mage::getBaseUrl('web').'minify/';
        $html = '';
        //$html = "<!--".BP."-->\n";
        $script = '<script type="text/javascript" src="%s" %s></script>';
        $stylesheet = '<link type="text/css" rel="stylesheet" href="%s" %s />';
        $alternate = '<link rel="alternate" type="%s" href="%s" %s />';

        foreach ($this->_data['items'] as $item) {
            if (!is_null($item['cond']) && !$this->getData($item['cond'])) {
                continue;
            }
            $if = !empty($item['if']) ? $item['if'] : '';
            switch ($item['type']) {
                case 'js':
                    $lines[$if]['script'][] = "/".$webroot."js/".$item['name'];
                    break;

                case 'js_css':
                    $lines[$if]['other'][] = sprintf($stylesheet, $baseJs.$item['name'], $item['params']);
                    break;

                case 'skin_js':
                    $chunks=explode('/skin', $this->getSkinUrl($item['name']),2);
                    $lines[$if]['script'][] = "/".$webroot."skin".$chunks[1];
                    break;

                case 'skin_css':
                    if($item['params']== 'media="all"'){
                        $chunks=explode('/skin', $this->getSkinUrl($item['name']),2);
                        $lines[$if]['stylesheet'][] = "/".$webroot."skin".$chunks[1];
                    } else {
                        $lines[$if]['other'][] = sprintf($stylesheet, $this->getSkinUrl($item['name']), $item['params']);
                    }
                    break;

                case 'rss':
                    $lines[$if]['other'][] = sprintf($alternate, 'application/rss+xml'/*'text/xml' for IE?*/, $item['name'], $item['params']);
                    break;

                case 'link_rel':
                    $lines[$if]['other'][] = sprintf('<link %s href="%s" />', $item['params'], $item['name']);
                    break;

            }
        }

        foreach ($lines as $if=>$items) {
            if (!empty($if)) {
                $html .= '<!--[if '.$if.']>'."\n";
            }
            if (!empty($items['stylesheet'])) {
               $cssBuild = new Minify_Build_Speedster($items['stylesheet'],BP);
                foreach ($this->getChunkedItems($items['stylesheet'], $baseJsFast.$cssBuild->getLastModified()) as $item) {
                    $html .= sprintf($stylesheet, $item, 'media="all"')."\n";
                }
            }
            if (!empty($items['script'])) {
                $jsBuild = new Minify_Build_Speedster($items['script'],BP);
                foreach ($this->getChunkedItems($items['script'], $baseJsFast.$jsBuild->getLastModified()) as $item) {
                    $html .= sprintf($script, $item, '')."\n";
                }
            }
            if (!empty($items['other'])) {
                $html .= join("\n", $items['other'])."\n";
            }
            if (!empty($if)) {
                $html .= '<![endif]-->'."\n";
            }
        }

        return $html;
    }

    public function getChunkedItems($items, $prefix='', $maxLen=450)
    {
        $chunks = array();
        $chunk = $prefix;


        foreach ($items as $i=>$item) {
            if (strlen($chunk.','.$item)>$maxLen) {
                $chunks[] = $chunk;
                $chunk = $prefix;
            }
            //this is the first item
            if ($chunk === $prefix) {
                $chunk .= substr($item,1); //remove first slash, only needed to create double slash for minify shortcut to document root
            } else {
                $chunk .= ','. substr($item,1); //remove first slash, only needed to create double slash for minify shortcut to document root
            }
        }

        $chunks[] = $chunk;
        return $chunks;
    }


}
