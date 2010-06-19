#!/bin/bash

# Save some useful operating values.
currentdir=`pwd`
me=`id -un`
mygroup=`id -gn`

# Get database access credentials from argument list.
host=""
user=""
pass=""
sethost=0;  
setpass=0;  
setuser=0;  

if (( $# > 0 )) ; then
  for i in `seq 1 $#`;
  do 
    arg=${!i}
    if (( $sethost > 0 )) ; then
      host=$arg;
      sethost=0;
      continue;
    elif (( $setpass > 0 )) ; then
      pass=$arg;
      setpass=0;
      continue;
    elif (( $setuser > 0 )) ; then
      user=$arg;
      setuser=0;
      continue;
    fi
    case $arg in
        "-h" ) 
            sethost=1 ;;
        "-u" )
            setuser=1 ;;
        "-p" )
            setpass=1 ;;
    esac
  done
fi

if [[ ("$host" == "") || ("$pass" == "") || ("$user" == "") ]] ; then
  echo "FATAL: Database credentials not complete. "
  echo "Usage: $0 -u <user> -p <password> -h <host>"
  exit 1
fi

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

export EKKITAB_HOME=$EKKITAB_HOME

# Get the Mysql Data Directory. Confirm with user.
while (true) ; do
    read -p "Please specify directory to hold Mysql database: " MYSQL_DIR 
    read -p "You have specified $MYSQL_DIR as the Mysql data directory. Ok to continue? (y/n) " ok
    ok=`echo $ok | tr 'A-Z' 'a-z'`
    if [ $ok == "y" ] ; then
        break;
    elif [ $ok != "n" ] ; then 
        echo "Ambiguous reply...Exiting"
        break; 
    fi
done


# Create the Ekkitab Home Directory if it does not exist.
# Change ownership to the identity running this script. 
if [ ! -d $EKKITAB_HOME ] ; then
  echo -n "Creating scm directory..."
  sudo mkdir $EKKITAB_HOME
  sudo chown -R $me:$mygroup $EKKITAB_HOME 
  echo  "done."
fi
if [ -z $EKKITAB_HOME ] ; then
    echo "FATAL: EKKITAB_HOME could not be set..."
    exit 1;
fi;

# Create the config directory
configdir=$EKKITAB_HOME/config
if [ ! -d  $configdir ] ; then
  echo -n "Creating configuration directory..."
  mkdir $configdir
  echo  "done."
fi

# Create the bin directory
bindir=$EKKITAB_HOME/bin
if [ ! -d  $bindir ] ; then
  echo -n "Creating bin directory..."
  mkdir $bindir
  echo  "done."
fi

# Create the logs directory and make it writable by all
logdir=$EKKITAB_HOME/logs
if [ ! -d  $logdir ] ; then
  echo -n "Creating logs directory..."
  mkdir $logdir
  chmod a+wx $logdir
  echo  "done."
fi

# Create the data directory
datadir=$EKKITAB_HOME/data
if [ ! -d  $datadir ] ; then
  echo -n "Creating data directory..."
  mkdir $datadir
  echo  "done."
fi

# Create the magento directory
magentodir=$EKKITAB_HOME/magento
if [ ! -d  $magentodir ] ; then
  echo -n "Creating magento directory..."
  mkdir $magentodir
  echo  "done."
fi

# Create the db directory
dbdir=$EKKITAB_HOME/db
if [ ! -d  $dbdir ] ; then
  echo -n "Creating db directory..."
  mkdir $dbdir
  echo  "done."
fi

# Create home variable for use in sed commands. Forward slash escaped.
home=`echo $EKKITAB_HOME | sed 's/\//\\\\\//g'`

# Check for missing files in release
# If new files are required to be checked add them to this array

REQ_FILES=( "db.sh" "readdbconfig.pl" "JavaBridge.war" "log4j.properties" "search.properties" "my.cnf" "000-default" "synchrelease.sh" "synchcatalog.sh" "reset_ekkitab_books.sh" "reset_ekkitab_books.sql" "backup.sh" "create_ekkitab_db.sql" "ekkitab_books_categories.sql" "init_ekkitab_books_db.sql" )
filecount=${#REQ_FILES[@]}

for ((i=0; i < $filecount; i++)) ; do
   if [ ! -f ${REQ_FILES[$i]} ] ; then
      echo "FATAL: Required file - ${REQ_FILES[$i]} - is missing in this release directory. "
      exit 1;
   fi
done
   
# Create configuration
echo -n "Creating configuration file for use by other scripts..."

configfile="$configdir/ekkitab.ini"
rm -f $configfile
echo "Creating configuration file..."
echo "[database]" > $configfile
echo "server     = $host" >> $configfile 
echo "user       = $user" >> $configfile 
echo "password   = $pass" >> $configfile 
echo "ekkitab_db = ekkitab_books" >> $configfile 
echo  "done."

# Set up Apache2 config
echo "Starting apache2 configuration."
sudo service apache2 stop
apachedir=/etc/apache2
targetfile=$apachedir/sites-enabled/000-default 
savefile=$apachedir/sites-enabled/000-default.saved
localfile=./000-default.local

# Update and copy apache conf file to target.
echo -n "Updating apache2 httpd configuration..."
cat ./000-default | sed "s/EKKITAB_HOME/$home/g" > $localfile 
if [ ! -f $savefile ] ; then
    sudo cp $targetfile $savefile 
fi
sudo cp $localfile $targetfile 
echo "done."

echo -n "Updating apache2 with required mods..."
# Add required apache mods.
apachemodsdir=$apachedir/mods-enabled
ARRAY=( "status.load" "status.conf" "setenvif.load" "setenvif.conf" "negotiation.load" "negotiation.conf" "mime.load" "mime.conf" "env.load" "dir.load" "dir.conf" "deflate.load" "deflate.conf" "autoindex.load" "autoindex.conf" "authz_user.load" "authz_default.load" "auth_basic.load" "alias.load" "alias.conf" "authz_host.load" "authz_groupfile.load" "authn_file.load" "cgi.load" "php5.load" "php5.conf" "rewrite.load" "expires.load" "cache.load" "disk_cache.load" "disk_cache.conf" "cgid.load" "cgid.conf" )
elements=${#ARRAY[@]}
for (( i=0; i<$elements;i++ )) ;
do
    file=${ARRAY[$i]}
    if [ ! -f $apachemodsdir/$file ] ; then
        echo -n " [ $file ] "
        ( cd $apachemodsdir; sudo ln -s ../mods-available/$file $file ) 
    fi
done
echo "done."
sudo service apache2 start

# Set up Tomcat config
echo "Starting tomcat6 configuration."
sudo service tomcat6 stop

# Turning tomcat security off
echo -n "Turning tomcat6 security OFF..."
tomcatstartupfile=/etc/init.d/tomcat6
tomcatstartupsavefile=/etc/init.d/tomcat6.saved
tomcatstartuplocalfile=./tomcat6.local
sed 's/TOMCAT6_SECURITY=yes/TOMCAT6_SECURITY=no/g' $tomcatstartupfile > $tomcatstartuplocalfile 
sed 's/JAVA_OPTS="-Djava.awt.headless=true.*$/JAVA_OPTS="-Djava.awt.headless=true -Xms1024M -Xmx4096M"/g' $tomcatstartuplocalfile > $tomcatstartuplocalfile.tmp && mv $tomcatstartuplocalfile.tmp $tomcatstartuplocalfile 

if [ ! -f  $tomcatstartuplocalfile ] ; then
  echo "FATAL: Failed to generate tomcat6 startup file.";
  exit 1;
fi
if [ ! -f $tomcatstartupsavefile ] ; then
    sudo cp $tomcatstartupfile $tomcatstartupsavefile
fi
sudo cp $tomcatstartuplocalfile $tomcatstartupfile
echo "done."

sudo service tomcat6 start
# Initializing JavaBridge
echo -n "Initializing JavaBridge webapp..."
tomcatdir=/var/lib/tomcat6
webappdir=$tomcatdir/webapps
javabridgedir=$webappdir/JavaBridge
if [ ! -d  $javabridgedir ] ; then
    sudo cp ./JavaBridge.war $webappdir
    # Try 5 times to verify that the JavaBridge directory was set up.
    for ((i=0; i<5; i++)) ; do 
        if [ ! -d  $javabridgedir ] ; then
            echo -n " ... "
            sleep 5; # Perhaps the directory has not been expanded yet.
        else 
            break;
        fi
    done
    # Check again!
    if [ ! -d  $javabridgedir ] ; then
        echo "FATAL: Failed to setup JavaBridge webapp correctly.";
        exit 1;
    fi
fi
echo "done."

# Set up JavaBridge property files used by Search
echo -n "Copying Ekkitab files to JavaBridge webapp locations..."
locallog4jfile=./log4j.properties.local
localsearchfile=./search.properties.local
classesdir=$javabridgedir/WEB-INF/classes

sed "s/LOGFILE/$home\/logs\/search.log/" ./log4j.properties > $locallog4jfile 
sed "s/EKKITAB_HOME/$home/" ./search.properties > $localsearchfile 
if [ ! -d $classesdir ] ; then
   sudo mkdir $classesdir
fi
sudo cp $locallog4jfile  $classesdir/log4j.properties
sudo cp $localsearchfile $classesdir/search.properties
echo "done."

# Initialize mysql
echo "Starting mysql configuration."
sudo mysqladmin -u $user -p$pass shutdown 

echo -n "Updating mysql config file..."
mysqldir=/etc/mysql
targetfile=$mysqldir/my.cnf
savefile=$targetfile.saved
localfile=./my.cnf.local

if [ ! -f $savefile ] ; then
    sudo cp $targetfile $savefile 
fi

# Create mysqldatadir variable for use in sed commands. Forward slash escaped.
mysqldatadir=`echo $MYSQL_DIR | sed 's/\//\\\\\//g'`

sed "s/EKKITAB_DB/$mysqldatadir/" $targetfile > $localfile 
sudo cp $localfile $targetfile 
echo "done."

echo -n "Updating mysql data directory..."
# Copy mysql data files over to the new location if target is empty
oldmysqldatadir=/var/lib/mysql
if [ ! -d $MYSQL_DIR ] ; then
    sudo cp -r $oldmysqldatadir $MYSQL_DIR 
fi
echo "done."

# Update apparmor  settings to reflect mysql cnf changes
echo -n "Updating apparmor files to correspond to mysql config changes..."
targetfile=/etc/apparmor.d/usr.sbin.mysqld
localfile=./usr.sbin.mysqld.local
savefile=$targetfile.saved

sed "s/\/var\/lib\/mysql/$mysqldatadir/g" $targetfile > $localfile 

if [ ! -f $savefile ] ; then
    sudo cp $targetfile $savefile 
fi
sudo cp $localfile $targetfile 
echo "done."

sudo /etc/init.d/apparmor reload

( cd /etc/init.d ; sudo ./mysql start )

# Update /etc/fstab
echo "Starting fstab configuration."

echo -n "Updating /etc/fstab with tmpfs file systems for cache and session..."
# Create mount points first
mkdir -p $magentodir/var/cache
mkdir -p $magentodir/var/session
targetfile=/etc/fstab
localfile=./fstab.local
savefile=$targetfile.saved

if ( ! grep magento $targetfile >/dev/null ) ; then
  sudo rm -f $localfile # Just in case there is a remnant file from a past run.
  cat $targetfile > $localfile 
  echo "tmpfs $EKKITAB_HOME/magento/var/cache/ tmpfs size=256,mode=0744 0 0" >> $localfile 
  echo "tmpfs $EKKITAB_HOME/magento/var/session/ tmpfs size=64,mode=0744 0 0" >> $localfile 
  if [ ! -f $savefile ] ; then
    sudo cp $targetfile $savefile
  fi
  sudo cp $localfile $targetfile 
fi
echo "done."

# Set up in memory file system for magento cache and session
echo -n "Setting up in-memory file systems for cache and session..."
sudo mount -t tmpfs -o size=256M,mode=0744 tmpfs "$EKKITAB_HOME/magento/var/cache/"
sudo mount -t tmpfs -o size=64M,mode=0744 tmpfs "$EKKITAB_HOME/magento/var/session/"
echo "done."

# Copy other files to the bin,data and db directory
echo "Starting Ekkitab setup."
echo -n "Copying files to correct locations..."
releasedir=.
cp $releasedir/synchrelease.sh $bindir
cp $releasedir/synchcatalog.sh $bindir
cp $releasedir/db.sh $bindir
cp $releasedir/readdbconfig.pl $bindir
cp $releasedir/reset_ekkitab_books.sh $dbdir
cp $releasedir/reset_ekkitab_books.sql $dbdir
cp $releasedir/backup.sh $dbdir
cp $releasedir/create_ekkitab_db.sql $dbdir
cp $releasedir/ekkitab_books_categories.sql $datadir
cp $releasedir/init_ekkitab_books_db.sql $dbdir
echo "done."

# Remove all local files
rm *.local 

echo "Server Initialization completed. Commencing Ekkitab database initialization."
( cd $dbdir; ./reset_ekkitab_books.sh )
echo "Server is ready for ekkitab application and catalog updates."
