#!/bin/bash
if [ -z $EKKITAB_HOME ] ; then
    echo "EKKITAB_HOME is not set..."
    exit 1;
fi;
. $EKKITAB_HOME/bin/db.sh 
#if [ $# -ne 3 ] ; then
#    echo "Not enough arguments...."; echo "Usage: $0 <host> <user> <password>" 
#    exit 1;
#fi;
# Run the delta scripts if called with updatedelta
if [ "$1" == "updatedelta" ] ; then
if [ -f $EKKITAB_HOME/release/catalogupdate/catalogupdate.sql ] ; then
mysql -s -h $host -u $user -p$password <<!
use ekkitab_books;
source $EKKITAB_HOME/release/catalogupdate/catalogupdate.sql;
!

fi
else 
mysql -s -h $host -u $user -p$password <<!
source $EKKITAB_HOME/db/loadbooks.sql;
!
fi
