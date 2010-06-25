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
bannedbooksfile=$1
if [ ! -f $bannedbooksfile ] ; then 
    echo "Fatal: File '$bannedbooksfile' is not found or not readable." 
    exit 1;
fi
( cat  $bannedbooksfile | while read isbn; do 
   isbn=${isbn%% *}
   isbn=`echo $isbn`;
   if [[ "$isbn" =~ ^[0-9][0-9X]*$ ]] ; then
       if [ ${#isbn} == 10 ] ; then
            isbn=`php -r "include('$EKKITAB_HOME/bin/convertisbn.php'); echo convertisbn('$isbn');"`
       fi
       if [ ${#isbn} == 13 ] ; then
            echo "mysql -h $host -u $user -p$password reference -e \"delete from books where isbn = '${isbn}'\" "
       fi
   fi
done )
