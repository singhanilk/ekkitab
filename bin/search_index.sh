#!/bin/bash
java -cp ../java/bin:../java/lib/lucene-core-2.4.0.jar:../java/lib/lucene-memory-2.4.0.jar:../java/lib/lucene-queries-2.4.0.jar:../java/lib/mysql-connector-java-3.1.14-bin.jar:../java/lib/log4j-1.2.6.jar BookSearch ../magento/search_index_dir 
