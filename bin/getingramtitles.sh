#!/bin/bash

checkfilesizes() {
    remotefile=$2;
    localfile=$1/$2;
    tmpfile=.getingramtitles
    ftp ftp1.ingrambook.com > $tmpfile <<!
        passive
        binary
        cd titleswk
        ls $remotefile
        quit
!
    size1=`cat $tmpfile | sed 's/ \+/ /g' | cut -d' ' -f5`
    size1=`echo $size1`
    size2=`ls -l $localfile | sed 's/ \+/ /g' | cut -d' ' -f5`
    rm $tmpfile
    if [ "$size1" == "$size2" ] ; then
       return 0;
    else 
       return 1;
    fi
}

targetdir="/mnt4/publisherdata/Ingram"
targetfile="ttlingv2.zip"
datafile="ttlingv2.txt"
checkfilesizes $targetdir $datafile
if (( $? == 0 )) ; then
   echo "[Get Titles] File $datafile is uptodate"
else 
   echo -n "[Get Titles] Getting file $targetfile..."
   if (cd $targetdir; wget -O $targetfile ftp://w20M0695:ees695@ftp1.ingrambook.com/titleswk/$targetfile >/dev/null 2>&1) ; then
        echo "done."
   else
        echo "failed."
   fi
   echo -n "[Get Titles] Unzipping file $targetfile..."
   (cd $targetdir; rm -f $datafile; unzip $targetfile >/dev/null 2>&1; chmod a+r $datafile)
   echo "done."
fi
echo "[Get Titles] Completed."



