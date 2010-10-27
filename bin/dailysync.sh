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

outfilename=`date +%d%b%Y`;
outfilename=/tmp/dailysync_$outfilename.txt
rm -f $outfilename;
rundate=$(date +"%D")
echo "Daily Synchronization of Catalog - $rundate" >>$outfilename

function pecho {
    echo $* >>$outfilename
}

rundate=$(date +"%D-%T")
pecho "[$rundate] Resetting reference database..."
( cd $EKKITAB_HOME/db ; ./reset_refdb.sh >>$outfilename 2>&1 ) 
rundate=$(date +"%D-%T")
pecho "[$rundate] Updating catalog..."
( cd $EKKITAB_HOME/db ; ./initcatalog.sh ../config/catalog.cfg -c >>$outfilename 2>&1 ) 
rundate=$(date +"%D-%T")
pecho "[$rundate] Running updating prices..."
( cd $EKKITAB_HOME/bin ; ./updateprices.sh >>$outfilename 2>&1 )
rundate=$(date +"%D-%T")
pecho "[$rundate] Resetting price and stock..."
( cd $EKKITAB_HOME/db ; ./reset_refdb_price_stock.sh >>$outfilename 2>&1 )
rundate=$(date +"%D-%T")
pecho "[$rundate] Updating catalog prices..."
( cd $EKKITAB_HOME/db ; ./initcatalog.sh ../config/catalog.cfg -p >>$outfilename 2>&1 ) 
rundate=$(date +"%D-%T")
pecho "[$rundate] Indexing and updating production database..."
( cd $EKKITAB_HOME/db ; ./initcatalog.sh ../config/catalog.cfg -u >>$outfilename 2>&1 ) 
rundate=$(date +"%D-%T")
pecho "[$rundate] Updating global section product ids..."
( cd $EKKITAB_HOME/db ; php ./load_globalsection_books.php ../data/globalsection.ini >>$outfilename 2>&1 )
# Restart Tomcat
sudo service tomcat6 stop >>$outfilename 2>&1
sleep 10
sudo service tomcat6 start >>$outfilename 2>&1
rundate=$(date +"%D-%T")
pecho "[$rundate] Running smoke test on new catalog..."
( cd $EKKITAB_HOME/bin; php bookValidation.php >>$outfilename 2>&1 )
success=$?
if (( $success > 0 )) ; then
    pecho "Catalog validation failed. Will not continue."
    exit 1;
fi
# Release the new catalog
rundate=$(date +"%D-%T")
pecho "[$rundate] Releasing new catalog to production.."
( cd $EKKITAB_HOME/bin; ./release catalog $tomail >>$outfilename 2>&1 )
rundate=$(date +"%D-%T")
pecho "[$rundate] Completed daily sync routine."
rundate=$(date +"%D")
cat $outfilename | php $EKKITAB_HOME/bin/sendmail.php -s "Daily Sync Summary for $rundate" $tomail 
