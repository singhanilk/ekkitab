#!/bin/bash
#/mnt4/publisherdata/India/MissingISBNs
php -d include_path=$EKKITAB_HOME/tools/ZendGdata-1.10.2/library:$EKKITAB_HOME/bin:. updatecatalog.php $1
