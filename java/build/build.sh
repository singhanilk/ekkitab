#!/bin/bash

javac -cp ../lib/lucene-core-2.1.0.jar:../lib/lucene-memory-2.1.0.jar -d ../bin ../src/BookSearch.java
javac -cp ../lib/lucene-core-2.1.0.jar:../lib/lucene-memory-2.1.0.jar -d ../bin ../src/BookIndex.java
