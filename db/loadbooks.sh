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
mysql -s -h $host -u $user -p$password <<!
source $EKKITAB_HOME/db/loadbooks.sql;
!
