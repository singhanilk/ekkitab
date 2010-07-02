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
   echo "[Get Stocklist] File $datafile is uptodate"
else 
   echo -n "[Get Stocklist] Getting file $targetfile ...."
   if (cd $targetdir; wget -O $targetfile ftp://w20M0695:ees695@ftp1.ingrambook.com/Inventory/$targetfile >/dev/null 2>&1) ; then
        echo "done."
   else
        echo "failed."
   fi
   echo -n "[Get Stocklist] Unzipping file $targetfile ..."
   (cd $targetdir; rm -f $datafile; unzip $targetfile >/dev/null 2>&1 ; chmod a+r $datafile)
   echo "done."
fi
echo "[Get Stocklist] Completed."
