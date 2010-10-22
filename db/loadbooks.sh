#!/bin/bash
if [ -z $EKKITAB_HOME ] ; then
    echo "EKKITAB_HOME is not set..."
    exit 1;
fi;

. $EKKITAB_HOME/bin/db.sh 

echo -n "[Info] Copying books table from reference to ekkitab_books ...";
mysql -s -h $host -u $user -p$password ekkitab_books <<!
    drop table if exists books;
    create table books like reference.books;
    insert into books select * from reference.books where title is not null;
!
echo "done."

## Decide whether it is necessary to transfer the books_promo table.
query="select max(id) from books_promo";

refmax=`mysql -u $user -p$password -h $host reference -e "$query"` ; 
refmax=`echo ${refmax##max(id)}`

ekkitabmax=`mysql -u $user -p$password -h $host ekkitab_books -e "$query"` ; 
ekkitabmax=`echo ${ekkitabmax##max(id)}`

if (( $ekkitabmax == $refmax )) ; then
    echo "[Info] Table books_promo is up to date. Not transferring from reference db."
    exit 0;
fi

echo -n "[Info] Copying books_promo table from reference to ekkitab_books ...";
mysql -s -h $host -u $user -p$password ekkitab_books <<!
    drop table if exists books_promo;
    create table books_promo like reference.books_promo;
    insert into books_promo select * from reference.books_promo;
!
echo "done."
