#!/bin/bash
if [ -z $EKKITAB_HOME ] ; then
    echo "EKKITAB_HOME is not set..."
    exit 1;
fi;
. $EKKITAB_HOME/bin/db.sh 
echo "Resetting price and stock data ..."
mysql -s -h$host -u$user -p$password <<!
source $EKKITAB_HOME/db/reset_refdb_price_stock.sql;
!
