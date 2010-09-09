#!/bin/bash
if [ -z $EKKITAB_HOME ] ; then
    echo "EKKITAB_HOME is not set..."
    exit 1;
fi;
. $EKKITAB_HOME/bin/db.sh

outputdir=$EKKITAB_HOME/blog_backup

if [ ! -d $outputdir ] ; then
    mkdir -p $outputdir;
fi

fileindex=`date +%d`
fileindex=`echo $fileindex | sed 's/^0//'`
let fileindex=$fileindex%5

outputfile=$outputdir/blog.sql.$fileindex

startbackuptime=$(date +"%D [%T]")

mysqldump -u $user -p$password -h $host blog > $outputfile

endbackuptime=$(date +"%D [%T]")
echo "Started: $startbackuptime, Finished: $endbackuptime, Index: $fileindex" > $outputdir/lastbackupdatetime.txt

