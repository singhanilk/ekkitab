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
   echo "[Get Promotions] File $localtargetfile is uptodate"
else 
   echo -n "[Get Promotions] Getting file $ftptargetfile ...."
   if (cd $targetdir; wget -O $localtargetfile ftp://w20M0695:ees695@ftp1.ingrambook.com/PubDescripi/$ftptargetfile >/dev/null 2>&1 ) ; then
       echo "done.";
       echo -n "[Get Promotions] Unzipping received zip file..."
       ( cd $targetdir; unzip $localtargetfile >/dev/null 2>&1 && mv $filename $savedfilename )
       echo "done."
       if ( ! grep "$targetdir/$savedfilename" $catalogfile >/dev/null 2>&1 ) ; then
            echo "-z Ingrams $targetdir/$savedfilename" >> $catalogfile
            echo "[Get Promotions] Updated catalog configuration file with entry for $savedfilename."
       fi
    else
       echo "failed."
    fi
    ( cd $targetdir; rm -f $localtargetfile )
fi
echo "[Get Promotions] Completed."





