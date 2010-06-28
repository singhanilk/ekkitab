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
    size2=`ls -l $localfile | sed 's/ \+/ /g' | cut -d' ' -f5`
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
   echo "File $localtargetfile is uptodate"
else 
   echo "getting file $ftptargetfile ...."
   (cd $targetdir; wget -O $localtargetfile ftp://w20M0695:ees695@ftp1.ingrambook.com/titleswk/$ftptargetfile)
   if ( ! grep "$targetdir/$localtargetfile" $catalogfile >/dev/null 2>&1 ) ; then
        echo "-d Ingrams $targetdir/$localtargetfile" >> $catalogfile
   fi
fi
