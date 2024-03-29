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
(cd $EKKITAB_HOME/db; ./reset_ekkitab_books.sh)
(cd $EKKITAB_HOME/db; mysql -h $host -u $user -p$password ekkitab_books < version.sql)
(cd $EKKITAB_HOME/db; ./reset_refdb.sh)
