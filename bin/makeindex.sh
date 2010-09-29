#!/bin/bash
if [ -z $EKKITAB_HOME ] ; then
    echo "EKKITAB_HOME is not set..."
    exit 1;
fi;
. $EKKITAB_HOME/bin/db.sh 
deltafile=$EKKITAB_HOME/release/catalogupdate/catalogupdate.txt
if [ "$1" == "updatedelta" ]; then
    if [ -f $deltafile ] ; then 
        echo "Updating Book Index...."
        ( cd $EKKITAB_HOME/bin; ./update_index.sh $deltafile )
    fi
elif [ "$1" == "update" ]; then
    echo "Creating Book Index...."
    ( cd $EKKITAB_HOME/bin; ./create_index.sh )
fi
