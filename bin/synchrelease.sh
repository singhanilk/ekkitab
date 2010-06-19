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

if (( $# > 0 )) ; then
  releasedir=$1
else
  echo "No release directory provided. Using the default."
  releasedir="$EKKITAB_HOME/release/app"
fi

read -p "You have specified - $releasedir - as the release directory. Ok to continue? (y/n) " ok
ok=`echo $ok | tr 'A-Z' 'a-z'`
if [ $ok == "y" ] ; then
    break;
else 
   echo "Fatal: No release directory to process."
   exit 1
fi

# First check if release directory exists. Create it if it does not.
if [ ! -d $releasedir ] ; then 
    echo "Fatal: Release directory not found."
    exit 1
fi


# Unzip the release
echo -n "Unzipping application files..."
( cd $EKKITAB_HOME;  unzip -q "$releasedir/release-*.zip" )
echo "done."

# If the magento directory does not exist, we have a problem.
magentodir="$EKKITAB_HOME/magento"
if [ ! -d $magentodir ] ; then
  echo "FATAL: Could not create magento directory. Cannot continue."
  exit 1;
fi

# Set up maintenance page
echo -n "Setting system to maintenance mode..."
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
rm -f $searchlib/lucene.jar 
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

echo "System update completed. Restarting services." 
sudo service tomcat6 start

#Removing maintenance page
echo -n "Taking system off maintenance mode..."
cp $magentodir/.htaccess.prod $magentodir/.htaccess
echo "done."
sudo service apache2 restart


