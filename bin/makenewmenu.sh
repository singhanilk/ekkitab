#!/bin/bash
if [ -z $EKKITAB_HOME ] ; then
    echo "EKKITAB_HOME is not set..."
    exit 1;
fi;
echo "generating menu ...."
(cd $EKKITAB_HOME/bin; php generatemenu.php -i ../data/menu.xml -o ../tmp)
echo "copying menu to production location ...."
(cd $EKKITAB_HOME/tmp; cp menuitems.php ../magento/app/design/frontend/default/ekkitab/template/catalog/leftlinks/menuitems.php)
