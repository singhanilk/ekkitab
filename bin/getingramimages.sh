#!/bin/bash
if [ -z $EKKITAB_HOME ] ; then
    echo "EKKITAB_HOME is not set..."
    exit 1;
fi;
tmpfile="./.newingramsimages"
archivedir='/mnt4/publisherdata/archives'
imagedir='/mnt4/publisherdata/images'
if (( $# > 0 )) ; then
    logfile=$1 ;
else 
    logfile="$EKKITAB_HOME/logs/ingramimages.log"
fi

# Remove existing logfile.
rm -f $logfile

if [ $# -ne 2 ] ; then
    a=10#`ls -lrt $archivedir/*j400*file*.zip | tail -1 | cut -d' ' -f9 | sed 's/.*\/\([0-9]*\)j400.*.zip/\1/g'`
    let a=a+100; if (( $a < 100000 )) ; then a=0$a; fi; 
    d1=10#$a
    echo "No date provided. Usage: $0 [ logfile ] [ <date in MMDDYY format> ]" 
    echo "Using $a as start date instead. " 
else 
    d1=10#$2
fi;
#echo "Please input password 'ees695' when prompted."
ftp ftp1.ingrambook.com > $tmpfile <<!
passive
binary
cd Imageswk/j400w
ls
quit
!
for i in $(cat $tmpfile | grep zip$ | sed 's/.* \([^ ]*.zip\)/\1/g') 
do 
    d2=10#`echo $i | sed 's/\([0-9]*\)j400.*/\1/g'`
    if (( $d2 >= $d1 )) 
        then 
            dir=`echo $i | sed 's/^\([0-9]*\).*\([0-9]of[0-9]\).*/\1-\2/'`
            echo "starting ftp for file $i"
            (cd $imagedir; wget -O $i ftp://w20M0695:ees695@ftp1.ingrambook.com/Imageswk/j400w/$i >> $logfile)
            echo "unzipping file $i"
            (cd $imagedir; mkdir $dir; cd $dir; unzip ../$i >> $logfile)
            echo "archiving file $i"
            (cd $imagedir; mv $i $archivedir)
            echo "distributing image files to production directories."
            (cd $imagedir; php $EKKITAB_HOME/bin/copyimages.php $dir >> $logfile)
    fi
done
rm $tmpfile 


