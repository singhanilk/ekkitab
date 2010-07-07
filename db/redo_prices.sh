#!/bin/bash
if [ -z $EKKITAB_HOME ] ; then
    echo "EKKITAB_HOME is not set..."
    exit 1;
fi;
. $EKKITAB_HOME/bin/db.sh 
( cd $EKKITAB_HOME/db; ./initcatalog.sh ../config/catalog.cfg -p )
( cd $EKKITAB_HOME/db; ./loadbooks.sh )
