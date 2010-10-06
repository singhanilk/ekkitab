#!/bin/bash
if [ -z $EKKITAB_HOME ] ; then
    echo "EKKITAB_HOME is not set..."
    exit 1;
fi;
tomail=""
while [ $# -gt 0 ] ; do 
    tomail="$tomail $1"
    shift
done 
if [ "$tomail" == "" ] ; then
    tomail=vijay@ekkitab.com # Default recipient
fi
tomail=`echo $tomail`

rundate=$(date +"%D-%T")
echo "[$rundate] Starting daily sync routine."
echo "[$rundate] Resetting reference database..."
( cd $EKKITAB_HOME/db ; ./reset_refdb.sh ) 
rundate=$(date +"%D-%T")
echo "[$rundate] Updating catalog..."
( cd $EKKITAB_HOME/db ; ./initcatalog.sh ../config/catalog.cfg -c | php ../bin/sendmail.php -s "Daily Sync Report: [$rundate] Init Catalog - books" $tomail ) 
rundate=$(date +"%D-%T")
echo "[$rundate] Running updating prices..."
( cd $EKKITAB_HOME/bin ; ./updateprices.sh | php sendmail.php -s "Daily Sync Report: [$rundate] Update Prices" $tomail )
rundate=$(date +"%D-%T")
echo "[$rundate] Updating catalog prices..."
( cd $EKKITAB_HOME/db ; ./initcatalog.sh ../config/catalog.cfg -p | php ../bin/sendmail.php -s "Daily Sync Report: [$rundate] Init Catalog - prices" $tomail ) 
rundate=$(date +"%D-%T")
echo "[$rundate] Indexing and updating production database..."
( cd $EKKITAB_HOME/db ; ./initcatalog.sh ../config/catalog.cfg -u ) 
rundate=$(date +"%D-%T")
echo "[$rundate] Updating global section product ids..."
( cd $EKKITAB_HOME/db ; php ./load_globalsection_books.php ../data/globalsection.ini )
# Restart Tomcat
sudo service tomcat6 stop
sleep 10
sudo service tomcat6 start
rundate=$(date +"%D-%T")
echo "[$rundate] Running smoke test on new catalog..."
( cd $EKKITAB_HOME/bin; php bookValidation.php )
success=$?
if (( $success > 0 )) ; then
    echo "Catalog validation failed. Will not continue."
    exit 1;
fi
# Release the new catalog
rundate=$(date +"%D-%T")
echo "[$rundate] Releasing new catalog to production.."
( cd $EKKITAB_HOME/bin; ./release catalog )
# Delete magento image cache on production server. 
ssh prod <<!
export EKKITAB_HOME=/mnt2/scm;
echo "Deleting image cache...";
rm -rf $EKKITAB_HOME/magento/media/catalog/product/cache/1/*
!
rundate=$(date +"%D-%T")
echo "[$rundate] Completed daily sync routine."


