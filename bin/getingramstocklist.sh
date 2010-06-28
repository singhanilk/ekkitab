#!/bin/bash
checkfilesizes() {
    remotefile=$3;
    localfile=$1/$2;
    tmpfile=.getingramannt
    ftp ftp1.ingrambook.com > $tmpfile <<!
        passive
        binary
        cd Inventory
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
targetfile="stockv2@ingram.zip"
datafile="stockv2@ingram.dat"

checkfilesizes $targetdir $datafile $datafile

if (( $? == 0 )) ; then
   echo "File $datafile is uptodate"
else 
   echo "getting file $targetfile ...."
   (cd $targetdir; wget -O $targetfile ftp://w20M0695:ees695@ftp1.ingrambook.com/Inventory/$targetfile)
   echo "unzipping file $targetfile ..."
   (cd $targetdir; rm -f $datafile; unzip $targetfile; chmod a+r $datafile)
fi
