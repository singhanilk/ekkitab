#!/bin/bash
if [ -z $EKKITAB_HOME ] ; then
    echo "EKKITAB_HOME is not set..."
    exit 1;
fi;
#Create the boostbooks data file, everytime the index is created.
boostdir=$EKKITAB_HOME/data/boostbooks;
boostdatafile=$EKKITAB_HOME/data/boostbooks.txt;
boostfiles=`ls -1 $boostdir/*.txt`;
cat /dev/null > $boostdatafile;
for x in $boostfiles
do
    cat $x >> $boostdatafile;
done;
. $EKKITAB_HOME/bin/db.sh 
java -Xmx512m -cp ../java/bin:../java/lib/lucene-core-3.0.2.jar:../java/lib/lucene-memory-3.0.2.jar:../java/lib/mysql-connector-java-3.1.14-bin.jar:../java/lib/lucene-spellchecker-3.0.2.jar:../java/bin/ekkitabsearch.jar com.ekkitab.search.BookIndex ../magento/search_index_dir ../magento/categories.xml "true" $host $user $password "$EKKITAB_HOME/data/boostbooks.txt"
