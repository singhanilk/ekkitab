#!/bin/bash
java -cp ../java/bin:../java/lib/lucene-core-2.1.0.jar:../java/lib/lucene-memory-2.1.0.jar:../java/lib/mysql-connector-java-3.1.14-bin.jar BookIndex ../magento/search_index_dir $1 $2 $3 