#!/bin/bash
if [ -z $EKKITAB_HOME ] ; then
    echo "EKKITAB_HOME is not set..."
    exit 1;
fi;
datadir=/mnt4/publisherdata
excelConverter=$EKKITAB_HOME/bin/prepare_stock.php
stockProcessor=$EKKITAB_HOME/bin/process_stock.php
priceDirectory=$datadir/India/Prices
stockList=$datadir/stock/stocklists
priceFile=$priceDirectory/india-prices.txt
timestamp=$(date +%d%m%y)
savedFile=$priceDirectory/saved/$timestamp-indiaprices.txt

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
    mv $priceFile $savedFile
fi;
(
	echo "[Update Prices] Concatenating new price files...";
	cd $priceDirectory;
	cat *.txt > india-prices.txt;
)

endtime=$(date +"%D [%T]")
echo "[Update Prices] ended at: $endtime"
