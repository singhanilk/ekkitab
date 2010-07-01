#!/bin/bash
if [ -z $EKKITAB_HOME ] ; then
    echo "EKKITAB_HOME is not set..."
    exit 1;
fi;
excelConverter=$EKKITAB_HOME/bin/prepare_stock.php
stockProcessor=$EKKITAB_HOME/bin/process_stock.php
priceDirectory=$EKKITAB_HOME/chris/output/Prices
stockList=$EKKITAB_HOME/chris/stocklists
priceFile=$EKKITAB_HOME/chris/output/Prices/india-prices.txt
timestamp=$(date +%d%m%y)
savedFile=$EKKITAB_HOME/chris/output/Prices/saved/$timestamp-indiaprices.txt
echo $savedFile;
if [ -f $excelConverter ] ; then
    echo "Converting excel stocklist files to text..."; 
    php $excelConverter
else
    echo "$excelConverter Not Found";
    exit 1;
fi;

if (($? > 0)) ; then
    echo "Excel stocklist file conversion failed..."
    exit 1;
fi

if [ -f $stockProcessor ] ; then
     echo "Finding Missing Isbn's and Creating Price File...";
     php $stockProcessor $stockList
else
    echo "$stockProcessor Not Found";
    exit 1;
fi;

if (($? > 0)) ; then
    echo "Price file generation failed..."
    exit 1;
fi

if [ -f $priceFile ] ; then
	echo "moving $priceFile to backup directory";
        mv $priceFile $savedFile
else
    echo "$priceFile does not exist";
fi;
(
	echo "Concatenating new Price Files";
	cd $priceDirectory;
	cat *.txt >> india-prices.txt;
)
echo "Done";
