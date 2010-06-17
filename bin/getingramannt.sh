#!/bin/bash
datestr=`date +%B%Y`
targetdir="/mnt4/publisherdata/Ingram"
localtargetfile="antingrm-13-$datestr.txt"
ftptargetfile="antingrm-13.txt"
catalogfile="/mnt2/scm/config/catalog.cfg"

echo "getting file $ftptargetfile ...."
#(cd $targetdir; mkdir $datestr)
#(cd $targetdir/$datestr; wget -O $targetfile ftp://w20M0695:ees695@ftp1.ingrambook.com/titleswk/$targetfile)
(cd $targetdir; wget -O $localtargetfile ftp://w20M0695:ees695@ftp1.ingrambook.com/titleswk/$ftptargetfile)
if ( ! grep "$targetdir/$localtargetfile" $catalogfile >/dev/null 2>&1 ) ; then
   echo "-d Ingrams $targetdir/$localtargetfile" >> $catalogfile
fi




