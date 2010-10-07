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
echo "[$rundate] Updating Ingram content..."
( cd $EKKITAB_HOME/bin ; ./updateingram.sh | php sendmail.php -s "Daily Ingram Refresh Report: [$rundate]" $tomail )
echo "[$rundate] Rsync'ing images with production server..."
rsync -azv --delete --exclude=cache/* /mnt3/magento-product-images/ prod:/mnt3/magento-product-images > /mnt2/scm/logs/rsync.log
