#!/bin/bash
if [ -z $EKKITAB_HOME ] ; then
    echo "EKKITAB_HOME is not set..."
    exit 1;
fi;
if [ $# -ne 3 ] ; then
    echo "Not enough arguments...."; echo "Usage: $0 <host> <user> <password>" 
    exit 1;
fi;
echo "Backing up customer and order data..."
$EKKITAB_HOME/db/backup.sh $1 $2 $3
echo "Resetting database and restoring backed up data..."
mysql -s -h $1 -u $2 -p$3 <<!
source $EKKITAB_HOME/db/reset_ekkitab_books.sql;
source $EKKITAB_HOME/data/backup.sql;
!
