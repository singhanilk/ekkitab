#!/bin/bash
. $EKKITAB_HOME/bin/db.sh 
java -Xmx256m -cp ../java/bin:../java/lib/lucene-core-2.4.0.jar:../java/lib/lucene-memory-2.4.0.jar:../java/lib/mysql-connector-java-3.1.14-bin.jar BookIndex ../magento/search_index_dir ../magento/categories.xml "false" $host $user $password $1 
