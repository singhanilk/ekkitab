#!/bin/bash
java -Xmx256m -cp ../java/bin:../java/lib/lucene-core-2.4.0.jar:../java/lib/lucene-memory-2.4.0.jar:../java/lib/mysql-connector-java-3.1.14-bin.jar BookIndex ../magento/search_index_dir ../magento/categories.xml "true" $1 $2 $3 0 
