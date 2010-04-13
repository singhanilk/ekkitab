#!/bin/bash
if [ -z $EKKITAB_HOME ] ; then
    echo "EKKITAB_HOME is not set..."
    exit 1;
fi;
rm -rf $EKKITAB_HOME/magento/var/cache/*
