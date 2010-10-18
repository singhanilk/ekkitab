#!/bin/bash
# Get the Ekkitab Home Directory. Confirm with user.
if [ -z $EKKITAB_HOME ] ; then
    while (true) ; do
        read -p "Please specify Ekkitab home directory: " EKKITAB_HOME 
        read -p "You have specified $EKKITAB_HOME as the Ekkitab home directory. Ok to continue? (y/n) " ok
        ok=`echo $ok | tr 'A-Z' 'a-z'`
        if [ $ok == "y" ] ; then
            break;
        elif [ $ok != "n" ] ; then 
            echo "Ambiguous reply...Exiting"
            unset EKKITAB_HOME
            break; 
        fi
    done
fi

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

bindir=$EKKITAB_HOME/bin

# Setting up maintenance page
#echo -n "Setting system to maintenance mode..."
#( cd $bindir; ./setdowntime.sh 30 )
#( cd $magentodir; cp ".htaccess.maintenance" .htaccess )
#echo "done."

# Setting logfile
if [ ! -d $EKKITAB_HOME/logs ] ; then
   echo -n "Creating logs directory..."
   mkdir $EKKITAB_HOME/logs
   chmod a+wx $EKKITAB_HOME/logs
   echo "done."
fi
logfile="$EKKITAB_HOME/logs/catalogsynch.log"
rm -rf $logfile;

DBTABLES=( "books" "book_availability" "books_promo" )
tablecount=${#DBTABLES[@]}

for ((i=0; i < $tablecount; i++)) ; do
   table=${DBTABLES[$i]};
   if [ ! -f $releasedir/$table.txt ] ; then
      echo "FATAL: Required file - $releasedir/$table.txt - is missing. "
      exit 1;
   fi
   echo -n "Updating table $table...[logging at $logfile]...";
   starttime=`date +%s`
   query="drop table if exists new$table";
   mysql -h $host -u $user -p$password ekkitab_books -e "$query" >> $logfile 2>&1;
   if (( $? > 0 )); then
        echo "Mysql query '$query' failed. Stopping execution of release.";
        exit 1;
   fi
   query="create table new$table like $table";
   mysql -h $host -u $user -p$password ekkitab_books -e "$query" >> $logfile 2>&1;
   if (( $? > 0 )); then
        echo "Mysql query '$query' failed. Stopping execution of release.";
        exit 1;
   fi
   query="load data local infile '$releasedir/$table.txt' into table new$table";
   mysql -h $host -u $user -p$password ekkitab_books -e "$query" >> $logfile 2>&1;
   if (( $? > 0 )); then
        echo "Mysql query '$query' failed. Stopping execution of release.";
        exit 1;
   fi
   query="drop table if exists old$table";
   mysql -h $host -u $user -p$password ekkitab_books -e "$query" >> $logfile 2>&1;
   if (( $? > 0 )); then
        echo "Mysql query '$query' failed. Stopping execution of release.";
        exit 1;
   fi
   query="rename table $table to old$table, new$table to $table"
   mysql -h $host -u $user -p$password ekkitab_books -e "$query" >> $logfile 2>&1;
   if (( $? > 0 )); then
        echo "Mysql query '$query' failed. Stopping execution of release.";
        exit 1;
   fi
   query="drop table if exists old$table";
   mysql -h $host -u $user -p$password ekkitab_books -e "$query" >> $logfile 2>&1;
   if (( $? > 0 )); then
        echo "Mysql query $query failed. Stopping execution of release.";
        exit 1;
   fi
   finishtime=`date +%s`
   seconds=$(expr $finishtime - $starttime);
   echo "done. [$seconds seconds]";
done

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
cp $releasedir/synchcatalog.sh $bindir
# Copy sample search script to the bin directory.
cp $releasedir/samplesearch.php $bindir

# Stop and start tomcat service
sudo service tomcat6 stop
sleep 5;
sudo service tomcat6 start

# Removing maintenance page
#echo -n "Taking system off maintenance mode..."
#cp $magentodir/.htaccess.prod $magentodir/.htaccess
#echo "done."

#echo "Restarting apache2 service"
#sudo service apache2 restart

# Archive this catalog update (for backup use)
# Create the archive directory if it does not exist.
echo -n "Archiving this release..."
archivedir=$EKKITAB_HOME/catalogarchive
if [ ! -d  $archivedir ] ; then
  echo -n "Creating archive directory..."
  mkdir $archivedir
  echo  "done."
fi
fileindex=`date +%d`
fileindex=`echo $fileindex | sed 's/^0//'`
let fileindex=$fileindex%7
target=`basename $releasedir`.$fileindex
rm -rf $archivedir/$target
cp -r $releasedir $archivedir/$target


echo "Catalog update completed." 


