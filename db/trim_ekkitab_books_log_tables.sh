#!/bin/bash
if [ -z $EKKITAB_HOME ] ; then
    echo "EKKITAB_HOME is not set..."
    exit 1;
fi;
. $EKKITAB_HOME/bin/db.sh 
echo "Trimming the ekkitab books log tables..."
mysql -s -h$host -u$user -p$password <<!
source $EKKITAB_HOME/db/trim_ekkitab_books_log_tables.sql;
!
