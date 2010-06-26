#!/bin/bash
# Get the Ekkitab Home Directory. Confirm with user.
while (true) ; do
    read -p "Please specify Ekkitab home directory: " EKKITAB_HOME 
    read -p "You have specified $EKKITAB_HOME as the Ekkitab home directory. Ok to continue? (y/n) " ok
    ok=`echo $ok | tr 'A-Z' 'a-z'`
    if [ $ok == "y" ] ; then
        break;
    elif [ $ok != "n" ] ; then 
        echo "Ambiguous reply...Exiting"
        break; 
    fi
done

if [ -z $EKKITAB_HOME ] ; then
    echo "Fatal: EKKITAB_HOME is not set..."
    exit 1;
fi;

export EKKITAB_HOME=$EKKITAB_HOME

# First check if db credentials are available.
if [ ! -f $EKKITAB_HOME/bin/db.sh ] ; then 
    echo "Fatal: Database credentials not available. Cannot continue."
    exit 1
fi

. $EKKITAB_HOME/bin/db.sh
releasedir=`pwd`

magentodir="$EKKITAB_HOME/magento"
if [ ! -d $magentodir ] ; then
  echo "Fatal: Magento directory does not exist...Cannot continue."
  exit 1;
fi

# Setting up maintenance page
echo -n "Setting system to maintenance mode..."
( cd $magentodir; cp ".htaccess.maintenance" .htaccess )
echo "done."

# First stop tomcat service
sudo service tomcat6 stop

# Setting logfile
if [ ! -d $EKKITAB_HOME/logs ] ; then
   echo -n "Creating logs directory..."
   mkdir $EKKITAB_HOME/logs
   chmod a+wx $EKKITAB_HOME/logs
   echo "done."
fi
logfile="$EKKITAB_HOME/logs/catalogsynch.log"

#echo -n "Unzipping books data..."
#( cd $releasedir; unzip -qo books.zip )
#echo "done."

# Check if books.sql is present.
if [ ! -f $releasedir/books.sql ] ; then
    echo "Fatal: Unzip of books data seems to have failed."
    exit 1;
fi

echo -n "Updating books table [logging at $logfile] ..."
mysql -h $host -u $user -p$password ekkitab_books < $releasedir/books.sql > $logfile 
echo "done."

# Check if the global section sql files are present.
if [ ! -f $releasedir/ek_catalog_global_sections.sql ] || 
   [ ! -f $releasedir/ek_catalog_global_section_products.sql ] ; then
    echo "Fatal: Release directory does not contain data for global sections."
    exit 1;
fi
echo -n "Updating global sections [logging at $logfile] ..."
mysql -h $host -u $user -p$password ekkitab_books < $releasedir/ek_catalog_global_sections.sql >> $logfile 
mysql -h $host -u $user -p$password ekkitab_books < $releasedir/ek_catalog_global_section_products.sql >> $logfile 
echo "done."

# Removing existing indexes.
echo -n "Removing existing index files..."
rm -rf $magentodir/search_index_dir
rm -rf $magentodir/search_index_dir_spell_author
rm -rf $magentodir/search_index_dir_spell_title
rm -f $magentodir/categories.xml
echo "done."

echo -n "Copying new index files..."
cp -r $releasedir/search_index_dir $magentodir 
cp -r $releasedir/search_index_dir_spell_author $magentodir
cp -r $releasedir/search_index_dir_spell_title $magentodir
cp $releasedir/categories.xml $magentodir
echo "done."

# Copy this script to the bin directory.
bindir=$EKKITAB_HOME/bin
cp $releasedir/synchcatalog.sh $bindir

sudo service tomcat6 start

# Removing maintenance page
echo "Taking system off maintenance mode..."
cp $magentodir/.htaccess.prod $magentodir/.htaccess
echo "done."

#echo "Restarting apache2 service"
#sudo service apache2 restart

echo "Catalog update completed." 


