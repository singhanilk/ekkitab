<?php

/**
 * Leave an empty string to use PHP's $_SERVER['DOCUMENT_ROOT'].
 *
 * On some servers, this value may be misconfigured or missing. If so, set this
 * to your full document root path with no trailing slash.
 * E.g. '/home/accountname/public_html' or 'c:\\xampp\\htdocs'
 *
 * If /min/ is directly inside your document root, just uncomment the
 * second line. The third line might work on some Apache servers.
 */
$min_documentRoot = '';
//$min_documentRoot = substr(__FILE__, 0, strlen(__FILE__) - 15);
//$min_documentRoot = $_SERVER['SUBDOMAIN_DOCUMENT_ROOT'];

// try to disable output_compression (may not have an effect)
ini_set('zlib.output_compression', '0');

// Minify Entry Point for Magento Extension FOOMAN Speedster
define('DS', '/');
define('PS', PATH_SEPARATOR);
define('BP', dirname(dirname(dirname(__FILE__))));


/**
 * Handle Multiple Stores - symlinked directories
 */

// Figure out if we are run from a subdirectory
$dir=explode("/lib/minify/m.php" , htmlentities($_SERVER['SCRIPT_NAME']));
if (strlen($dir[0])==0){
    // we are in webroot
    $min_symlinks=array('//' => BP);
}else{
    // we are in a subdirectory adjust symlink
    $rootdir= explode($dir[0] , BP);
    $min_symlinks=array('//' => $rootdir[0]);
}

// Prepends include_path. You could alternately do this via .htaccess or php.ini
set_include_path( BP.DS.'lib'.DS.'minify'.DS.'lib'. PS . get_include_path());

// Set $minifyCachePath to a PHP-writeable path to enable server-side caching
$minifyCachePath = BP.DS.'var'.DS.'cache'.DS.'minifycache';
// The Files controller only "knows" CSS, and JS files.
$serveExtensions = array('css', 'js');

// Serve
if (isset($_GET['f'])) {
    $filenames =  explode(",", $_GET['f']) ;
    $filenamePattern = '/[^\'"\\/\\\\]+\\.(?:'
        .implode('|', $serveExtensions).   ')$/';

    require 'Minify.php';

    if ($minifyCachePath) {
        Minify::setCache($minifyCachePath);
    }

    if ($min_documentRoot) {
        $_SERVER['DOCUMENT_ROOT'] = $min_documentRoot;
    } elseif (0 === stripos(PHP_OS, 'win')) {
        Minify::setDocRoot(); // IIS may need help
    }

    //on some apache installs this is needed
    if(array_key_exists('SUBDOMAIN_DOCUMENT_ROOT', $_SERVER)){
        $_SERVER['DOCUMENT_ROOT'] = $_SERVER['SUBDOMAIN_DOCUMENT_ROOT'];
    }

    //check if requested files exists and add to minify request
    $servefiles = array();
    foreach ($filenames as $filename) {
            if (preg_match($filenamePattern, $filename)
                && file_exists(BP .  $filename)) {
                //Minify can't handle the regex for the email addresses - change to file with less demanding regex for email validation
                //fixed in Magento 1.4 (keep this workaround in place until support for versions below 1.4 is removed)
                //$filename = str_replace("js".DS."prototype".DS."validation.js", "js".DS."prototype".DS."validation-4min.js", $filename);
                $filename = str_replace("js".DS."prototype".DS."validation.js", "js".DS."prototype".DS."validation-4min.js", $filename);
                $servefiles[]=BP . $filename;
            }
    }
    
    //options for minify request
    $serveOptions = array(
        'rewriteCssUris'=>true
        ,'files' => $servefiles
        ,'maxAge' => 31536000 // now + 1 yr
    );

    //include option for symlinks and merge with $serveOptions
    $min_serveOptions['minifierOptions']['text/css']['symlinks'] = $min_symlinks;
    $serveOptions=array_merge($serveOptions,$min_serveOptions);

    //and SERVE
    Minify::serve('Files', $serveOptions);
    exit();

}

header("HTTP/1.0 404 Not Found");
echo "HTTP/1.0 404 Not Found";
