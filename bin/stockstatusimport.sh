#!/bin/bash
if [ -z $EKKITAB_HOME ] ; then
    echo "EKKITAB_HOME is not set..."
    exit 1;
fi;
rundate=$(date +"%D-%T")
z=`$EKKITAB_HOME/utils/autostockprocess.pl`
if [ ! "$z" == "" ] ; then
    ( cd $EKKITAB_HOME/bin ; echo "$z" | php sendmail.php -s "Stock Status Import Report: [$rundate]" vijay@ekkitab.com saran@ekkitab.com )
fi

