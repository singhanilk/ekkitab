#!/bin/bash
datestr=`date +%B%Y`
targetdir="/mnt4/publisherdata/Ingram"
localtargetfile="pmmnthy-13-$datestr.zip"
ftptargetfile="pmmnthy-13.zip"
filename="pmmnthy-13.txt"
savedfilename=${filename%.*}-$datestr.txt
catalogfile="/mnt2/scm/config/catalog.cfg"

echo $savedfilename
exit 1

echo "getting file $ftptargetfile ...."
(cd $targetdir; wget -O $localtargetfile ftp://w20M0695:ees695@ftp1.ingrambook.com/titleswk/$ftptargetfile)
echo "unzipping received zip file..."
( cd $targetdir; unzip $localtargetfile && mv $filename $savedfilename )

if ( ! grep "$targetdir/$savedfilename" $catalogfile >/dev/null 2>&1 ) ; then
   echo "# -z Ingrams $targetdir/$savedfilename" >> $catalogfile
fi




