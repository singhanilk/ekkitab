#!/bin/bash

checkfilesizes() {
    remotefile=$3;
    localfile=$1/$2;
    tmpfile=.getingramannt
    ftp ftp1.ingrambook.com > $tmpfile <<!
        passive
        binary
        cd titleswk
        ls $remotefile
        quit
!
    size1=`cat $tmpfile | sed 's/ \+/ /g' | cut -d' ' -f5`
    size1=`echo $size1`
    if [ -f $localfile ] ; then
        size2=`ls -l $localfile | sed 's/ \+/ /g' | cut -d' ' -f5`
    else
        size2=0
    fi
    rm $tmpfile
    if [ "$size1" == "$size2" ] ; then
       return 0;
    else 
       return 1;
    fi
}

datestr=`date +%B%Y`
targetdir="/mnt4/publisherdata/Ingram"
localtargetfile="antingrm-13-$datestr.txt"
ftptargetfile="antingrm-13.txt"
catalogfile="/mnt2/scm/config/catalog.cfg"

checkfilesizes $targetdir $localtargetfile $ftptargetfile
if (( $? == 0 )) ; then
   echo "[Get Annotations] File $localtargetfile is uptodate"
else 
   echo -n "[Get Annotations] Getting file $ftptargetfile ...."
   if (cd $targetdir; wget -O $localtargetfile ftp://w20M0695:ees695@ftp1.ingrambook.com/titleswk/$ftptargetfile >/dev/null 2>&1) ; then
       echo "done."
       if ( ! grep "$targetdir/$localtargetfile" $catalogfile >/dev/null 2>&1 ) ; then
            echo "-d Ingrams $targetdir/$localtargetfile" >> $catalogfile
            echo "[Get Annotations] Updated catalog file with entry for $localtargetfile."
       fi
   else
       echo "failed."
   fi
fi
echo "[Get Annotations] Completed."
