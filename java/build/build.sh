#!/bin/bash

javac -Xlint:deprecation -cp ../lib/lucene-core-2.4.0.jar:../lib/lucene-memory-2.4.0.jar:../lib/lucene-queries-2.4.0.jar:../bin:../lib/log4j-1.2.6.jar -d ../bin ../src/BookSearch.java
javac -Xlint:deprecation -cp ../lib/lucene-core-2.4.0.jar:../lib/lucene-memory-2.4.0.jar -d ../bin ../src/BookIndex.java
