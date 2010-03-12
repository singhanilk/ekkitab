#!/bin/bash
if [ -z $EKKITAB_HOME ] ; then
    echo "EKKITAB_HOME is not set..."
    exit 1;
fi;
if [ $# -ne 3 ] ; then
    echo "Not enough arguments...."; echo "Usage: $0 <host> <user> <password>" 
    exit 1;
fi;
mysql -s -h $1 -u $2 -p$3 <<!
source $EKKITAB_HOME/db/loadbooks.sql;
!
