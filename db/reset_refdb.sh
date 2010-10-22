#!/bin/bash
if [ -z $EKKITAB_HOME ] ; then
    echo "EKKITAB_HOME is not set..."
    exit 1;
fi;
droptables=( "books" "books_promo" "ek_import_state" );
. $EKKITAB_HOME/bin/db.sh 
echo "Resetting reference database..."
if (( $# == 1 )) && [ "$1" == "-f" ] ; then
    for ((i=0; i < ${#droptables[@]}; i++)) ; do
        table=${droptables[$i]};
        sql="drop table if exists $table";
        echo "[Info] Dropping table '$table'";
        mysql -h $host -u $user -p$password reference -e "$sql";
        if (( $? > 0 )) ; then
            echo "[Fatal] SQL '$sql' failed to execute correctly."; 
            exit 1;
        fi
    done
fi
mysql -s -h $host -u $user -p$password <<!
source $EKKITAB_HOME/db/reset_refdb.sql;
!
echo "Setting conversion rates..."
cat $EKKITAB_HOME/data/currencyrates.txt | while read line; do
  currency=`echo ${line%% *}`
  conversion=`echo ${line##* }`
  ( $EKKITAB_HOME/db/setcurrencyrate.sh $currency $conversion )
done
