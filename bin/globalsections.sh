#!/bin/bash
if [ -z $EKKITAB_HOME ] ; then
    echo "EKKITAB_HOME is not set..."
    exit 1;
fi;
. $EKKITAB_HOME/bin/db.sh 
echo "Generating globalsection links..."
cd $EKKITAB_HOME/bin; 
sqlfile=/tmp/globalsections.sql
xmlfile=../data/globalsections.xml
php generate_globalsections.php -i $xmlfile -o $sqlfile 
if (( $? > 0 )) ; then
    echo "[Fatal] Could not generate sql file for global sections."
    exit 1;
fi
echo "Loading globalsection links..."
mysql -s -h $host -u $user -p$password <<!
source $sqlfile;
!
