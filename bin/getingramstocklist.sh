#!/bin/bash
targetdir="/mnt4/publisherdata/Ingram"
targetfile="stockv2@ingram.zip"
datafile="stockv2@ingram.dat"
echo "getting file $targetfile ...."
(cd $targetdir; wget -O $targetfile ftp://w20M0695:ees695@ftp1.ingrambook.com/Inventory/$targetfile)
echo "unzipping file $targetfile ..."
(cd $targetdir; rm -f $datafile; unzip $targetfile)



