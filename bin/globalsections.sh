#!/bin/bash
if [ -z $EKKITAB_HOME ] ; then
    echo "EKKITAB_HOME is not set..."
    exit 1;
fi;
. $EKKITAB_HOME/bin/db.sh 
echo "generating globalsection links...."
(cd $EKKITAB_HOME/bin; php generate_globalsections.php -i ../data/globalsections.xml )
(cd $EKKITAB_HOME/db;)
mysql -u $user -p$password -h $host ekkitab_books < globalsections.sql