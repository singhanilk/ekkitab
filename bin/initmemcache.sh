#!/bin/bash
if [ -z $EKKITAB_HOME ] ; then
    echo "EKKITAB_HOME is not set..."
    exit 1;
fi;
sudo mount -t tmpfs -o size=256M,mode=0744 tmpfs $EKKITAB_HOME/magento/var/cache/
sudo mount -t tmpfs -o size=64M,mode=0744 tmpfs $EKKITAB_HOME/magento/var/session/
