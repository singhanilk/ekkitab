#!/bin/bash
if [ -z $EKKITAB_HOME ] ; then
    echo "EKKITAB_HOME is not set..."
    exit 1;
fi;
. $EKKITAB_HOME/bin/db.sh
if [ $# -ne 1 ] ; then
    echo "Not enough arguments...."; echo "Usage: $0 <banned books file>" 
    exit 1;
fi;
penguinbooksfile=$1
if [ ! -f $penguinbooksfile ] ; then
    echo "Fatal: File '$penguinbooksfile' is not found or not readable." 
    exit 1;
fi
( cat  $penguinbooksfile | while read isbn; do 
   isbn=${isbn%% *}
   isbn=`echo $isbn`;
   if [[ "$isbn" =~ ^[0-9][0-9X]*$ ]] ; then
       if [ ${#isbn} == 10 ] ; then
            isbn=`php -r "include('$EKKITAB_HOME/bin/convertisbn.php'); echo convertisbn('$isbn');"`
       fi
       if [ ${#isbn} == 13 ] ; then
            mysql -h $host -u $user -p$password reference -e "update books SET in_stock = 0 where isbn = '${isbn}'"
       fi
   fi
done )

