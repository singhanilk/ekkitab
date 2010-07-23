#!/bin/bash
if [ -z $EKKITAB_HOME ] ; then
    echo "EKKITAB_HOME is not set..."
    exit 1;
fi;
tomail=""
while [ $# -gt 0 ] ; do 
    tomail="$tomail $1"
    shift
done 
if [ "$tomail" == "" ] ; then
    tomail=vijay@ekkitab.com # Default recipient
fi
tomail=`echo $tomail`
rundate=$(date +"%D-%T")
z=`$EKKITAB_HOME/utils/autostockprocess.pl`
if [ ! "$z" == "" ] ; then
    ( cd $EKKITAB_HOME/bin ; echo "$z" | php sendmail.php -s "Stock Status Import Report: [$rundate]" $tomail )
fi

