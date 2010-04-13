<?php
$ekkitabhome = getenv("EKKITAB_HOME");
if (empty($ekkitabhome)) {
   echo "EKKITAB_HOME is not set. Cannot continue.\n";
   exit(1);
}
define ("EKKITAB_HOME", $ekkitabhome);
?>
