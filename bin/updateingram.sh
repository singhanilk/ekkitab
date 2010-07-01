#!/bin/bash
if [ -z $EKKITAB_HOME ] ; then
    echo "EKKITAB_HOME is not set..."
    exit 1;
fi;
logfile="$EKKITAB_HOME/logs/ingramimages.log"
rm -f $logfile;
( cd $EKKITAB_HOME/bin; ./getingramtitles.sh )
( cd $EKKITAB_HOME/bin; ./getingramstocklist.sh )
( cd $EKKITAB_HOME/bin; ./getingramannt.sh )
( cd $EKKITAB_HOME/bin; ./getingrampromo.sh )
( cd $EKKITAB_HOME/bin; ./getingramimages.sh $logfile )

