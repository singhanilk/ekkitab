#!/bin/bash
dirindex=`date +%H`
target=/mnt3/proddb_bkup/saved.$dirindex
source=prod:/mnt2/scm/db_backup
rm -rf $target
scp -r $source $target 
