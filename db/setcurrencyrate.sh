#!/bin/bash
if [ -z $EKKITAB_HOME ] ; then
    echo "EKKITAB_HOME is not set..."
    exit 1;
fi;
. $EKKITAB_HOME/bin/db.sh 
if [ $# -ne 2 ] ; then
    echo "Not enough arguments...."; echo "Usage: $0 <currency> <rate>" 
    exit 1;
fi;
currency=$1;
conversion=$2;

case $currency in 
    "USD") ;;
    "BRI") ;;
    "CAN") ;;
    *) echo "Fatal: $1 is not a valid currency name."
       echo "Valid currencies are: 'USD', 'BRI' and 'CAN' only."
       exit 1;;
esac

query="insert into ek_currency_conversion (currency, conversion) values ('$currency', $conversion) on duplicate key update conversion = $conversion"
if mysql -h $host -u $user -p$password reference -e "$query" >/dev/null 2>&1 ; then
    echo "Currency rate for $currency updated to $conversion"
else 
    echo "Failed to update currency rate for $currency."
fi


