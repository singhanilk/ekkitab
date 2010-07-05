#!/bin/bash
if [ -z $EKKITAB_HOME ] ; then
    echo "EKKITAB_HOME is not set..."
    exit 1;
fi;
echo "Starting daily sync routine."
echo "Updating Ingram content..."
rundate=$(date +"%D-%T")
( cd $EKKITAB_HOME/bin ; ./updateingram.sh | php sendmail.php -s "Daily Sync Report: [$rundate] Update Ingram" vijay@ekkitab.com )
echo "Rsync'ing images with production server..."
rsync -av --exclude=cache/* /mnt3/magento-product-images/ prod:/mnt3/magento-product-images > /mnt2/scm/logs/rsync.log
echo "Updating prices..."
rundate=$(date +"%D-%T")
( cd $EKKITAB_HOME/bin ; ./updateprices.sh | php sendmail.php -s "Daily Sync Report: [$rundate] Update Prices" vijay@ekkitab.com )
echo "Resetting reference database..."
( cd $EKKITAB_HOME/db ; ./reset_refdb.sh ) 
echo "Initializing catalog..."
rundate=$(date +"%D-%T")
( cd $EKKITAB_HOME/db ; ./initcatalog.sh ../config/catalog.cfg -c | php ../sendmail.php -s "Daily Sync Report: [$rundate] Init Catalog - books" vijay@ekkitab.com ) 
echo "Initializing prices..."
rundate=$(date +"%D-%T")
( cd $EKKITAB_HOME/db ; ./initcatalog.sh ../config/catalog.cfg -p | php ../sendmail.php -s "Daily Sync Report: [$rundate] Init Catalog - prices" vijay@ekkitab.com ) 
echo "Indexing and updating production database..."
( cd $EKKITAB_HOME/db ; ./initcatalog.sh ../config/catalog.cfg -u ) 
echo "Completed daily sync routine."

