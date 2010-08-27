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
    "EUR") ;;
    "SGD") ;;
    "AUD") ;;
    *) echo "Fatal: $1 is not a valid currency name."
       echo "Valid currencies are: 'USD', 'BRI', "EUR", "SGD", "AUD" and 'CAN' only."
       exit 1;;
esac

query="insert into ek_currency_conversion (currency, conversion) values ('$currency', $conversion) on duplicate key update conversion = $conversion"
if mysql -h $host -u $user -p$password reference -e "$query" >/dev/null 2>&1 ; then
    echo "Currency rate for $currency updated to $conversion"
else 
    echo "Failed to update currency rate for $currency."
fi

if [ "$currency" == "USD" ] && (( $conversion > 0 )) ; then
    reverseconversion=`echo "scale=4; 1/$conversion" | bc -l`;
    query="insert into directory_currency_rate (currency_from, currency_to, rate) values ('INR', 'USD', $reverseconversion) on duplicate key update rate = $reverseconversion"
    if mysql -h $host -u $user -p$password ekkitab_books -e "$query" >/dev/null 2>&1 ; then
        echo "Currency reverse conversion rate for $currency updated to $reverseconversion"
    else 
        echo "Failed to update reverse currency rate for $currency."
    fi
fi


