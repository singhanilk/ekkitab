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

echo "Starting daily sync routine."
echo "Updating Ingram content..."
rundate=$(date +"%D-%T")
( cd $EKKITAB_HOME/bin ; ./updateingram.sh | php sendmail.php -s "Daily Sync Report: [$rundate] Update Ingram" $tomail )
echo "Rsync'ing images with production server..."
rsync -av --exclude=cache/* /mnt3/magento-product-images/ prod:/mnt3/magento-product-images > /mnt2/scm/logs/rsync.log
echo "Updating prices..."
rundate=$(date +"%D-%T")
( cd $EKKITAB_HOME/bin ; ./updateprices.sh | php sendmail.php -s "Daily Sync Report: [$rundate] Update Prices" $tomail )
echo "Resetting reference database..."
( cd $EKKITAB_HOME/db ; ./reset_refdb.sh ) 
echo "Initializing catalog..."
rundate=$(date +"%D-%T")
( cd $EKKITAB_HOME/db ; ./initcatalog.sh ../config/catalog.cfg -c | php ../bin/sendmail.php -s "Daily Sync Report: [$rundate] Init Catalog - books" $tomail ) 
echo "Initializing prices..."
rundate=$(date +"%D-%T")
( cd $EKKITAB_HOME/db ; ./initcatalog.sh ../config/catalog.cfg -p | php ../bin/sendmail.php -s "Daily Sync Report: [$rundate] Init Catalog - prices" $tomail ) 
echo "Indexing and updating production database..."
( cd $EKKITAB_HOME/db ; ./initcatalog.sh ../config/catalog.cfg -u ) 
# Restart Tomcat
sudo service tomcat6 stop
sleep 10
sudo service tomcat6 start
echo "Running smoke test on new catalog..."
( cd $EKKITAB_HOME/bin; php bookValidation.php )
success=$?
if (( $success > 0 )) ; then
    echo "Catalog validation failed. Will not continue."
    exit 1;
fi
echo "Creating release..."
( cd $EKKITAB_HOME/bin; ./gencatalog.sh )
echo "Ensuring catalog transfer location on production server is empty..."
ssh prod <<!
cd /tmp
rm -rf catalog
exit
!
echo "Transferring new catalog to production server..."
( cd $EKKITAB_HOME/release; scp -r catalog prod:/tmp ) 
#echo "Deploying new catalog on production server..."
#ssh prod <<!
#export EKKITAB_HOME=/mnt2/scm;
#activesessions=`$EKKITAB_HOME/bin/getactivesessions.sh`;
#tries=0;
#MAXTRIES=30;
#while (( \$activesessions > 2 )) && (( \$tries < \$MAXTRIES )) ; do
#(( tries++ ));
#echo "Sleeping. \$activesessions sessions are active."
#sleep 60;
#activesessions=`$EKKITAB_HOME/bin/getactivesessions.sh`;
#done;
#if (( \$activesessions <= 2 )) ; then
#cd /tmp/catalog;
#./synchcatalog.sh;
#php $EKKITAB_HOME/bin/samplesearch.php
#fi;
#echo "Deleting image cache...";
#rm -rf $EKKITAB_HOME/magento/media/catalog/product/cache/1/*
#exit \$activesessions;
#!
if (( $? <= 2 )) ; then
    echo "Completed daily sync routine. New catalog pushed into production." 
else
    echo "Production system has active sessions. New catalog transferred but NOT pushed to production." 
fi


