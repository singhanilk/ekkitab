#!/bin/bash
dbconfig=`$EKKITAB_HOME/bin/readdbconfig.pl`
host=`echo $dbconfig | cut -d' ' -f1 | while read a; do echo $a; done`;
user=`echo $dbconfig | cut -d' ' -f2 | while read a; do echo $a; done`;
password=`echo $dbconfig | cut -d' ' -f3 | while read a; do echo $a; done`;

