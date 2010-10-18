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
magentodir=$EKKITAB_HOME/magento

#if (( $# > 0 )) ; then
#  releasedir=$1
#else
#  echo "No release directory provided. Using the default."
#  releasedir="$EKKITAB_HOME/release/app"
#fi

#read -p "You have specified - $releasedir - as the release directory. Ok to continue? (y/n) " ok
#ok=`echo $ok | tr 'A-Z' 'a-z'`
#if [ $ok == "y" ] ; then
#    break;
#else 
#   echo "Fatal: No release directory to process."
#   exit 1
#fi

releasedir=`pwd`

# First check if release directory exists. Create it if it does not.
#if [ ! -d $releasedir ] ; then 
#    echo "Fatal: Release directory not found."
#    exit 1
#fi

# Unzip the release
echo -n "Unzipping application files..."
if ! ( cd $EKKITAB_HOME;  unzip -qo $releasedir/release-*.zip >/dev/null 2>&1 ) ; then
    echo "failed."
    echo "Fatal: Could not unzip application files."
    exit 1;
fi
echo "done."

# If the magento directory does not exist, we have a problem.
if [ ! -d $magentodir ] ; then
  echo "FATAL: Could not create magento directory. Cannot continue."
  exit 1;
fi

# Create directories that have not been included in the zip and set permissions on them correctly
logdir=$magentodir/var/log
if [ ! -d $logdir ] ; then
  echo -n "Creating logs directory..."
  mkdir -p $logdir;
  chmod a+rwx $logdir;
  echo "done."
fi
catalogdir=$magentodir/media/catalog
if [ ! -d $catalogdir ] ; then
  echo -n "Creating media/catalog directory..."
  mkdir -p $catalogdir;
  echo "done."
fi

# Create production site file marker.
touch $magentodir/productionsite

bindir=$EKKITAB_HOME/bin
# Set up maintenance page
echo -n "Setting system to maintenance mode..."
if [ -x $EKKITAB_HOME/bin/setdowntime.sh ] ; then
    ( cd $bindir; ./setdowntime.sh 10 )
else 
    ( cd $magentodir; cp maintenance.html.default maintenance.html )
fi
( cd $magentodir; cp ".htaccess.maintenance" ".htaccess" )
echo "done."

# Stop tomcat service
sudo service tomcat6 stop

# Setting logfile
if [ ! -d $EKKITAB_HOME/logs ] ; then
   echo -n "Creating logs directory..."
   mkdir $EKKITAB_HOME/logs
   chmod a+wx $EKKITAB_HOME/logs
   echo "done."
fi
logfile="$EKKITAB_HOME/logs/produpdate.log"

#Setting Tomcat locations
echo -n "Updating search related tomcat6 files..."
if [ x${TOMCAT_HOME} == "x" ] ; then
   tomcathome="/var/lib/tomcat6"
else
   tomcathome=$TOMCAT_HOME
fi
searchlib=$tomcathome/webapps/JavaBridge/WEB-INF/lib
classesdir=$tomcathome/webapps/JavaBridge/WEB-INF/classes

if [ ! -d $classesdir ] ; then
  mkdir $classesdir;
fi

( cd $releasedir; sudo cp ekkitabsearch.jar $searchlib/ekkitabsearch.jar ) 
sudo rm -f $searchlib/lucene.jar 
( 
   cd $releasedir/lib; for i in *.jar ; 
   do 
        f=${i%%-*};
        if [ $f == "lucene" ] || [ $f == "log4j" ]; then 
            if [ ! -f $searchlib/$i ] ; then 
                echo -n " [Added $i] "; 
                sudo cp $i $searchlib/$i
            fi 
        fi 
   done 
)
( 
   cd $releasedir; for i in *.properties ; 
   do 
      if [ ! -f $classesdir/$i ] ; then 
         echo -n " [Added $i] "; 
         sudo cp $i $classesdir/$i
      fi 
   done 
)

echo "done."

# Change admin access url 
echo -n "Resetting admin access url..."
( cd $magentodir/app/etc ; sed 's/<frontName><.*><\/frontName>/<frontName><!\[CDATA\[ek1671ad9591\]\]><\/frontName>/g' local.xml > local.xml.tmp && mv local.xml.tmp local.xml )
echo "done."

# Check if the global section sql files are present.
if [ ! -f $releasedir/ek_catalog_global_sections.sql ] || 
   [ ! -f $releasedir/ek_catalog_global_section_products.sql ] ; then
    echo "Fatal: Release directory does not contain data for global sections."
    exit 1;
fi
echo -n "Updating global sections..."
mysql -h $host -u $user -p$password ekkitab_books < $releasedir/ek_catalog_global_sections.sql >/dev/null 
mysql -h $host -u $user -p$password ekkitab_books < $releasedir/ek_catalog_global_section_products.sql >/dev/null 
echo "done."

# Copy the patch scripts to their correct place as well as the dbupdate script.
dbdir=$EKKITAB_HOME/db
if [ ! -d $dbdir/patches ] ; then
   mkdir $dbdir/patches;
fi
cp -r $releasedir/patches $dbdir
cp $releasedir/updatedb.sh $dbdir
cp $releasedir/checkdbversion.php $dbdir

# Run the db patch update
( cd $dbdir; ./updatedb.sh )

# Copy this script to the bin directory.
cp $releasedir/synchrelease.sh $bindir
# Copy other scripts to the bin directory.
cp $releasedir/getactivesessions.sh $bindir
cp $releasedir/checkreviews.sh $bindir
cp $releasedir/sendmail.php $bindir
cp $releasedir/setdowntime.sh $bindir
cp $releasedir/release_on_production $bindir
cp $releasedir/launch_release_on_production $bindir

sudo service tomcat6 start

#Removing maintenance page
echo -n "Taking system off maintenance mode..."
cp $magentodir/.htaccess.prod $magentodir/.htaccess
echo "done."
sudo service apache2 restart
echo "System update completed. All required services have been restarted." 

# Archive this release (for backup use)
# Create the archive directory if it does not exist.
echo -n "Archiving this release...."
archivedir=$EKKITAB_HOME/releasearchive
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
echo  "done."
