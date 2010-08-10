#!/bin/bash
if [ -z $EKKITAB_HOME ] ; then
    echo "EKKITAB_HOME is not set..."
    exit 1;
fi;
downtime=30
if (( $# > 0 )) ; then
    downtime=$1
fi
templatefile=$EKKITAB_HOME/magento/maintenance.html.template
if [ ! -f $templatefile ] ; then
    echo "[Error] No template of maintenance file found."
fi
actualfile=$EKKITAB_HOME/magento/maintenance.html
dstart=`date --date "5 hours 30 minutes" +%H:%M`
dend=`date --date "5 hours 30 minutes $downtime minutes" +%H:%M`
cat $templatefile | sed "s/DOWNTIME_START/$dstart/g"  | sed "s/DOWNTIME_END/$dend/g" >  $actualfile

