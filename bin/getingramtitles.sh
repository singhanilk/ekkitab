#!/bin/bash
targetdir="/mnt4/publisherdata/Ingram"
targetfile="ttlingv2.zip"
echo "getting file $targetfile ...."
(cd $targetdir; wget -O $targetfile ftp://w20M0695:ees695@ftp1.ingrambook.com/titleswk/$targetfile)
echo "unzipping file $targetfile ..."
(cd $targetdir; unzip $targetfile)



