#!/bin/bash
checkfilesizes() {
    remotefile=$3;
    localfile=$1/$2;
    tmpfile=.getingramannt
    ftp ftp1.ingrambook.com > $tmpfile <<!
        passive
        binary
        cd PubDescripi
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
localtargetfile="ingmmthy-13-$datestr.zip"
ftptargetfile="ingmmthy-13.zip"
filename="INGMMTHY-13.TXT"
savedfilename=${filename%.*}-$datestr.txt
catalogfile="/mnt2/scm/config/catalog.cfg"

checkfilesizes $targetdir $savedfilename $filename
if (( $? == 0 )) ; then
   echo "File $localtargetfile is uptodate"
else 
   echo "getting file $ftptargetfile ...."
   if (cd $targetdir; wget -O $localtargetfile ftp://w20M0695:ees695@ftp1.ingrambook.com/PubDescripi/$ftptargetfile) ; then
       echo "unzipping received zip file..."
       ( cd $targetdir; unzip $localtargetfile && mv $filename $savedfilename )
       if ( ! grep "$targetdir/$savedfilename" $catalogfile >/dev/null 2>&1 ) ; then
            echo "-z Ingrams $targetdir/$savedfilename" >> $catalogfile
       fi
    else
       echo "Failed to transfer $ftptargetfile from Ingram ftp server."
    fi
    ( cd $targetdir; rm -f $localtargetfile )
fi





