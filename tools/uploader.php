<?php
set_include_path(get_include_path() . PATH_SEPARATOR . "/var/www/scm/magento/lib/Varien");
include("Image.php");
include("Image/Adapter.php");
include "Image/Adapter/Abstract.php";
include("Image/Adapter/Gd2.php");

$html = "<html> <head> </head> <body> <table border='1'> <tr> <td>Resized Image</td> <td><img src='%s' alt='%s'></td> </tr> </table> </body> </html>";

function resize($width,$height,$srcFile,$targetFile) {
    $processor = new Varien_Image($srcFile);
    $processor->keepAspectRatio(true);
    $processor->keepFrame(false);
    $processor->keepTransparency(true);
    $processor->constrainOnly(true);
    $processor->resize($width, $height);
    $processor->save($targetFile);
}

$target_path = "/var/www/scm/images/kannada/";
$resized_images_dir = "/var/www/scm/images/kannada/resized/";
$html_resized_dir = "/scm/images/kannada/resized/";
$filename = basename($_FILES['uploadedfile']['name']);
$target_path = $target_path . $filename; 
if(move_uploaded_file($_FILES['uploadedfile']['tmp_name'], $target_path)) {
    resize(null, 200, $target_path, $resized_images_dir . $filename); 
    if (file_exists($resized_images_dir . $filename)) {
        $tmp = sprintf($html, $html_resized_dir . $filename, "resized image $filename");
        echo ($tmp);
    }
} else{
    echo "<b>There was an error uploading the file, please try again!</b>";
}

?>
