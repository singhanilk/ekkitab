#!/bin/bash
if [ -z $EKKITAB_HOME ] ; then
    echo "EKKITAB_HOME is not set..."
    exit 1;
fi;
echo "Initializing databases..."
( cd $EKKITAB_HOME/db; ./initdatabases.sh )
echo "Initializing catalog and search indexes..."
( cd $EKKITAB_HOME/db; ./initcatalog.sh ../config/catalog.cfg )
echo "Building Java Search Component..."
( cd $EKKITAB_HOME/bin; ./initsearch.sh )
echo "Updating Global Sections..."
( cd $EKKITAB_HOME/db; php load_globalsection_books.php ../data/globalsection.ini )
echo "Building Left Hand Menu..."
( cd $EKKITAB_HOME/bin; ./makenewmenu.sh )

