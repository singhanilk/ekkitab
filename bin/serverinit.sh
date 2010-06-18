#!/bin/bash

currentdir=`pwd`

read -p "Please specify EKKITAB home directory: " EKKITAB_HOME 
export EKKITAB_HOME=$EKKITAB_HOME

if [ ! -d $EKKITAB_HOME ] ; then
  echo "Creating scm directory..."
  sudo mkdir $EKKITAB_HOME
  sudo chown -R ubuntu:ubuntu $EKKITAB_HOME 
fi

if [ -z $EKKITAB_HOME ] ; then
    echo "EKKITAB_HOME could not be set..."
    exit 1;
fi;

# Create the config directory
configdir=$EKKITAB_HOME/config
if [ ! -d  $configdir ] ; then
  echo "Creating configuration directory..."
  mkdir $configdir
fi

# Create the bin directory
bindir=$EKKITAB_HOME/bin
if [ ! -d  $bindir ] ; then
  echo "Creating bin directory..."
  mkdir $bindir
fi
# Create the logs directory and make it writable by all
logdir=$EKKITAB_HOME/logs
if [ ! -d  $logdir ] ; then
  echo "Creating logs directory..."
  mkdir $logdir
  chmod a+wx $logdir
fi
# Create the data directory
datadir=$EKKITAB_HOME/data
if [ ! -d  $datadir ] ; then
  echo "Creating data directory..."
  mkdir $datadir
fi
# Create the magento directory
magentodir=$EKKITAB_HOME/magento
if [ ! -d  $magentodir ] ; then
  echo "Creating magento directory..."
  mkdir $magentodir
fi

#Get database access credentials from argument list.
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
  echo "Database credentials not complete. "
  echo "Usage: $0 -u <user> -p <password> -h <host>"
  echo "Exiting..."
  exit 1
fi

home=`echo $EKKITAB_HOME | sed 's/\//\\\\\//g'`
# Check for missing files in release

if [ ! -f  ./db.sh ]                        || 
   [ ! -f  ./readdbconfig.pl ]              ||
   [ ! -f  ./JavaBridge.war ]               ||
   [ ! -f  ./log4j.properties ]             ||
   [ ! -f  ./search.properties ]            ||
   [ ! -f  ./my.cnf ]                       ||
   [ ! -f  ./000-default ]                  ||
   [ ! -f  ./synchrelease.sh ]              ||
   [ ! -f  ./synchcatalog.sh ]              ||
   [ ! -f  ./reset_ekkitab_books.sh ]       ||
   [ ! -f  ./reset_ekkitab_books.sql]       ||
   [ ! -f  ./backup.sh ]                    ||
   [ ! -f  ./create_ekkitab_db.sql ]        ||
   [ ! -f  ./ekkitab_books_categories.sql ] ||
   [ ! -f  ./init_ekkitab_books_db.sql ] ; then

   echo "FATAL: File missing in release directory. " 
   exit 1;
fi

# Create configuration

configfile="$configdir/ekkitab.ini"
rm -f $configfile
echo "Creating configuration file..."
echo "[database]" > $configfile
echo "server     = $host" >> $configfile 
echo "user       = $user" >> $configfile 
echo "password   = $pass" >> $configfile 
echo "ekkitab_db = ekkitab_books" >> $configfile 

# Set up Apache2 config
sudo service apache2 stop
apachedir=/etc/apache2
echo "Setting up apache2 configurations ....."

if [ ! -f  ./000-default ] ; then
  echo "File missing in current directory: 000-default";
  echo "Exiting..."
  exit 1;
fi

# Update and copy apache conf file to target.
cat ./000-default | sed "s/EKKITAB_HOME/$home/g" > ./000-default.local
sudo cp $apachedir/sites-enabled/000-default $apachedir/sites-enabled/000-default.saved
sudo cp ./000-default.local $apachedir/sites-enabled/000-default

# Add required apache mods.
apachemodsdir=$apachedir/mods-enabled
ARRAY=( "status.load" "status.conf" "setenvif.load" "setenvif.conf" "negotiation.load" "negotiation.conf" "mime.load" "mime.conf" "env.load" "dir.load" "dir.conf" "deflate.load" "deflate.conf" "autoindex.load" "autoindex.conf" "authz_user.load" "authz_default.load" "auth_basic.load" "alias.load" "alias.conf" "authz_host.load" "authz_groupfile.load" "authn_file.load" "cgi.load" "php5.load" "php5.conf" "rewrite.load" "expires.load" "cache.load" "disk_cache.load" "disk_cache.conf" "cgid.load" "cgid.conf" )
elements=${#ARRAY[@]}
for (( i=0; i<$elements;i++ )) ;
do
    file=${ARRAY[$i]}
    if [ ! -f $apachemodsdir/$file ] ; then
        echo "Setting up apache mod: $file"
        ( cd $apachemodsdir; sudo ln -s ../mods-available/$file $file ) 
    fi
done
sudo service apache2 start

# Set up Tomcat config
echo "Setting up tomcat6 configurations ....."

# Turning tomcat security off
tomcatdir=/var/lib/tomcat6
tomcatstartupfile=/etc/init.d/tomcat6
sed 's/TOMCAT6_SECURITY=yes/TOMCAT6_SECURITY=no/g' /etc/init.d/tomcat6 > ./tomcat6.local
sed 's/JAVA_OPTS="-Djava.awt.headless=true.*$/JAVA_OPTS="-Djava.awt.headless=true -Xms1024M -Xmx4096M"/g' ./tomcat6.local > ./tomcat6.local.tmp && mv ./tomcat6.local.tmp ./tomcat6.local

if [ ! -f  ./tomcat6.local ] ; then
  echo "Failed to generate tomcat6 startup file.";
  echo "Exiting..."
  exit 1;
fi
sudo cp $tomcatstartupfile $tomcatstartupfile.saved
sudo cp ./tomcat6.local $tomcatstartupfile

# Initializing JavaBridge
sudo cp ./JavaBridge.war $tomcatdir/webapps
sudo service tomcat6 start
echo "Starting tomcat to initialize JavaBridge webapp..."
sleep 20
sudo service tomcat6 stop
if [ ! -d  $tomcatdir/webapps/JavaBridge ] ; then
  echo "Failed to initialize JavaBridge webapp.";
  echo "Exiting..."
  exit 1;
fi

# Set up JavaBridge property files used by Search
sed "s/LOGFILE/$home\/logs\/search.log/" ./log4j.properties > ./log4j.properties.local
sed "s/EKKITAB_HOME/$home/" ./search.properties > ./search.properties.local
if [ ! -d $tomcatdir/webapps/JavaBridge/WEB-INF/classes ] ; then
   echo "Creating the JavaBridge classes directory..."
   sudo mkdir $tomcatdir/webapps/JavaBridge/WEB-INF/classes
fi
sudo cp ./log4j.properties.local  $tomcatdir/webapps/JavaBridge/WEB-INF/classes/log4j.properties
sudo cp ./search.properties.local  $tomcatdir/webapps/JavaBridge/WEB-INF/classes/search.properties

sudo service tomcat6 start

# Initialize mysql
echo "Initializing mysql..."
sudo mysqladmin -u $user -p$pass shutdown 
mysqldir=/etc/mysql
sudo cp $mysqldir/my.cnf $mysqldir/my.cnf.saved 
sudo cp ./my.cnf $mysqldir/my.cnf 
sed 's/\/var\/lib\/mysql/\/mnt3\/mysql/g' /etc/apparmor.d/usr.sbin.mysqld > ./usr.sbin.mysqld.local 

# Copy mysql data files over to the new location if target is empty
if [ ! -d /mnt3/mysql ] ; then
    sudo cp -r /var/lib/mysql /mnt3/mysql
fi

# Update apparmor  settings to reflect mysql cnf changes

sudo cp /etc/apparmor.d/usr.sbin.mysqld ./usr.sbin.mysqld.saved 
sudo cp ./usr.sbin.mysqld.local /etc/apparmor.d/usr.sbin.mysqld 
sudo /etc/init.d/apparmor reload

# Update /etc/fstab

# Create mount points first
mkdir -p $magentodir/var/cache
mkdir -p $magentodir/var/session

if ( ! grep magento /etc/fstab >/dev/null ) ; then
  sudo echo "tmpfs $EKKITAB_HOME/magento/var/cache/ tmpfs size=256,mode=0744 0 0" >> /etc/fstab
  sudo echo "tmpfs $EKKITAB_HOME/magento/var/session/ tmpfs size=64,mode=0744 0 0" >> /etc/fstab
fi
# Set up in memory file system for magento cache and session
sudo mount -t tmpfs -o size=256M,mode=0744 tmpfs "$EKKITAB_HOME/magento/var/cache/"
sudo mount -t tmpfs -o size=64M,mode=0744 tmpfs "$EKKITAB_HOME/magento/var/session/"

# Copy other files to the bin,data and db directory
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

# Remove all local files
rm *.local 
echo "Server Initialization completed. Commencing database initialization."
( cd $dbdir; ./reset_ekkitab_books.sh )
echo "Server is ready for ekkitab application and catalog updates."
