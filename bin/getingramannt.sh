#!/bin/bash
datestr=`date +%B%Y`
targetdir="/mnt4/publisherdata/Ingram"
targetfile="antingrm-13.txt"

echo "getting file $targetfile ...."
(cd $targetdir; mkdir $datestr)
(cd $targetdir/$datestr; wget -O $targetfile ftp://w20M0695:ees695@ftp1.ingrambook.com/titleswk/$targetfile)



