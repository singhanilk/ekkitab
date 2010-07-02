#!/bin/bash
if [ -z $EKKITAB_HOME ] ; then
    echo "EKKITAB_HOME is not set..."
    exit 1;
fi;
. $EKKITAB_HOME/bin/db.sh 
echo "Resetting reference database..."
mysql -s -h $host -u $user -p$password <<!
source $EKKITAB_HOME/db/reset_refdb.sql;
!
echo "Setting conversion rates..."
cat $EKKITAB_HOME/data/currencyrates.txt | while read line; do
  currency=`echo ${line%% *}`
  conversion=`echo ${line##* }`
  ( $EKKITAB_HOME/db/setcurrencyrate.sh $currency $conversion )
done
