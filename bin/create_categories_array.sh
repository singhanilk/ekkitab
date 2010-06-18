#!/bin/bash
if [ -z $EKKITAB_HOME ] ; then
    echo "EKKITAB_HOME is not set..."
    exit 1;
fi;
echo "generating categories array ...."
(cd $EKKITAB_HOME/bin; php generatecategories_array.php -i ../magento/categories.xml -o ../tmp)
echo "copying categories to production location ...."
(cd $EKKITAB_HOME/tmp; cp categories.php ../magento/app/design/frontend/default/ekkitab/template/catalog/category/categories.php)
