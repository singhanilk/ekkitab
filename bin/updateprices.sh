#!/bin/bash
if [ -z $EKKITAB_HOME ] ; then
    echo "EKKITAB_HOME is not set..."
    exit 1;
fi;
datadir=/mnt4/publisherdata
excelConverter=$EKKITAB_HOME/bin/prepare_stock.php
stockProcessor=$EKKITAB_HOME/bin/process_stock.php
inifile=$EKKITAB_HOME/config/stockprocess.ini
basedir=`cat $inifile | grep outputdir`
basedir=${basedir#*=}
priceDirectory=$basedir/prices
stockList=$datadir/stock/stocklists
priceFile=$priceDirectory/india-prices.txt
timestamp=$(date +%d)
savedFile=$priceDirectory/saved/indiaprices-$timestamp.txt
savedDir=$priceDirectory/saved

starttime=$(date +"%D [%T]")
echo "[Update Prices] started at: $starttime"

if [ -f $excelConverter ] ; then
    echo "[Update Prices] Converting excel stocklist files to text..."; 
    php $excelConverter
else
    echo "[Update Prices] [Fatal] $excelConverter Not Found";
    exit 1;
fi;

if (($? > 0)) ; then
    echo "[Update Prices] [Fatal] Excel stocklist file conversion failed."
    exit 1;
fi

if [ -f $stockProcessor ] ; then
     echo "[Update Prices] Finding missing isbn's and creating price file...";
     php $stockProcessor $stockList
else
    echo "[Update Prices] [Fatal] $stockProcessor Not Found";
    exit 1;
fi;

if (($? > 0)) ; then
    echo "[Update Prices] [Fatal] Price file generation failed..."
    exit 1;
fi

if [ -f $priceFile ] ; then
	echo "[Update Prices] Moving $priceFile to backup directory";
    if [ ! -d $savedDir ] ; then
        mkdir -p $savedDir;
    fi
    mv $priceFile $savedFile
fi;
(
	echo "[Update Prices] Concatenating new price files...";
	cd $priceDirectory;
	cat *.txt > india-prices.txt;
)

endtime=$(date +"%D [%T]")
echo "[Update Prices] ended at: $endtime"
