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
  releasedir="$EKKITAB_HOME/release/app"
fi
  
# First check if release directory exists. Create it if it does not.
if [ ! -d $releasedir ] ; then 
    echo "Release directory not available. Cannot continue."
    exit 1
fi

# Next check if magento directory is available.
magentodir="$EKKITAB_HOME/magento"

# Unzip the release
( cd $EKKITAB_HOME;  unzip -q "$releasedir/release-*.zip" )

# If the magento directory does not exist, we have a problem.
if [ ! -d $magentodir ] ; then
  echo "FATAL: Could not create magento directory. Cannot continue."
  exit 1;
fi

# Set up maintenance page
echo "Setting system to maintenance mode."
( cd $magentodir; cp ".htaccess.maintenance" ".htaccess" )

# Stop tomcat service
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

echo "Updating search related files.."
( cd $releasedir; sudo cp ekkitabsearch.jar $searchlib/ekkitabsearch.jar ) 
echo "Deleting old lucene jar file that came with JavaBridge distribution..."
rm -f $searchlib/lucene.jar 
echo "Copying missing libraries to tomcat location ..."
( 
   cd $releasedir/lib; for i in *.jar ; 
   do 
        f=${i%%-*};
        if [ $f == "lucene" ] || [ $f == "log4j" ]; then 
            if [ ! -f $searchlib/$i ] ; then 
                echo "Copying $i to Tomcat JavaBridge library."; 
                sudo cp $i $searchlib/$i
            fi 
        fi 
   done 
)
( 
   cd $releasedir; for i in *.properties ; 
   do 
      if [ ! -f $classesdir/$i ] ; then 
         echo "Copying $i to classes directory."; 
         sudo cp $i $classesdir/$i
      fi 
   done 
)

echo "System update completed. Restarting services" 

echo "Starting tomcat6 service"
sudo service tomcat6 start
#Removing maintenance page
echo "Taking system off maintenance mode."
cp $magentodir/.htaccess.prod $magentodir/.htaccess
echo "Restarting apache2 service"
sudo service apache2 restart


