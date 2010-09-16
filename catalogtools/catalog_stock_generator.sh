#! /bin/sh
# The parameters are parent directory, supplier name , preorder
echo "Running catalog and stock";
excelFile=$1/$2.xls
noBisacFile=$1/$2-nobisac.txt
bisacFile=$1/$2.txt
stockListFile=$1/newarrivals-$2-stocklist.txt
preorder=$3
perl processors/catalog_stock_generator.pl $excelFile $noBisacFile $stockListFile $preorder
echo "Running biscac code generator";
php bookcrawlers/bisaccodes.php $noBisacFile $bisacFile
rm $noBisacFile
