#!/bin/bash
datestr=`date +%B%Y`
targetdir="/mnt4/publisherdata/Ingram"
targetfile="ttlingv2"
fileextn="zip"

echo "getting file $targetfile.$fileextn ...."
(cd $targetdir; mkdir $datestr)
(cd $targetdir/$datestr; wget -O $targetfile-$datestr.$fileextn ftp://w20M0695:ees695@ftp1.ingrambook.com/titleswk/$targetfile.$fileextn)
echo "unzipping file $targetfile.$fileextn ..."
(cd $targetdir/$datestr; unzip $targetfile-$datestr.$fileextn)



