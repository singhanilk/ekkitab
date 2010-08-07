#!/bin/bash
if [ -z $EKKITAB_HOME ] ; then
    echo "EKKITAB_HOME is not set..."
    exit 1;
fi;
. $EKKITAB_HOME/bin/db.sh 
echo "generating globalsection links...."
cd $EKKITAB_HOME/bin; 
php generate_globalsections.php -i ../data/globalsections.xml
echo "generated the sql file... updating the database...."
mysql -s -h $host -u $user -p$password <<!
source $EKKITAB_HOME/db/globalsections.sql;
!