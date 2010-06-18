#!/bin/bash
if [ -z $EKKITAB_HOME ] ; then
    echo "EKKITAB_HOME is not set..."
    exit 1;
fi;

# First check if db credentials are available.
if [ ! -f $EKKITAB_HOME/bin/db.sh ] ; then 
    echo "Database credential not available. Cannot continue."
    exit 1
fi

. $EKKITAB_HOME/bin/db.sh

if (( $# > 0 )) ; then
  releasedir=$1
else
  echo "No release directory provided. Using $EKKITAB_HOME/release/update"
  releasedir="$EKKITAB_HOME/release/catalog"
fi
  
# First check if release directory exists. Create it if it does not.
if [ ! -d $releasedir ] ; then 
    echo "FATAL: Release directory not available. Cannot continue."
    exit 1
fi
# Next check if magento directory is available.
magentodir="$EKKITAB_HOME/magento"
if [ ! -d $magentodir ] ; then
  echo "FATAL: Magento directory does not exist...Cannot continue."
  exit 1;
fi

#Setting up maintenance page
echo "Setting system to maintenance mode."
( cd $magentodir; cp ".htaccess.maintenance" .htaccess )

#First stop tomcat service
echo "Stopping tomcat6 service"
sudo service tomcat6 stop

# Setting logfile
if [ ! -d $EKKITAB_HOME/logs ] ; then
   echo "Creating logs directory"
   mkdir $EKKITAB_HOME/logs
   chmod a+wx $EKKITAB_HOME/logs
fi
logfile="$EKKITAB_HOME/logs/produpdate.log"

#Setting Tomcat locations

echo "Updating books..."
mysql -h $host -u $user -p$password ekkitab_books < $releasedir/books.sql > $logfile 

rm -rf $magentodir/search_index_dir
rm -rf $magentodir/search_index_dir_spell_author
rm -rf $magentodir/search_index_dir_spell_title
rm -f $magentodir/categories.xml

cp -r $releasedir/search_index_dir $magentodir 
cp -r $releasedir/search_index_dir_spell_author $magentodir
cp -r $releasedir/search_index_dir_spell_title $magentodir
cp $releasedir/categories.xml $magentodir

echo "Restarting services..." 

echo "Starting tomcat6 service"
sudo service tomcat6 start

#Removing maintenance page
echo "Taking system off maintenance mode."
cp $magentodir/.htaccess.prod $magentodir/.htaccess

#echo "Restarting apache2 service"
#sudo service apache2 restart

echo "Catalog update completed." 


