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
    a=`ls -lrt $archivedir/*j400*file*.zip | tail -1`
    a=${a##* }
    a=10#`echo $a | sed 's/.*\/\([0-9]*\)j400.*.zip/\1/g'`
    let a=a+100; if (( $a < 100000 )) ; then a=0$a; fi; 
    d1=10#$a
    echo "[Get Images] No date provided. Usage: $0 [ logfile ] [ <date in MMDDYY format> ]" 
    echo "[Get Images] Using $a as start date instead. " 
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
filestransferred=0
for i in $(cat $tmpfile | grep zip$ | sed 's/.* \([^ ]*.zip\)/\1/g') 
do 
    d2=10#`echo $i | sed 's/\([0-9]*\)j400.*/\1/g'`
    if (( $d2 >= $d1 )); then 
            dir=`echo $i | sed 's/^\([0-9]*\).*\([0-9]of[0-9]\).*/\1-\2/'`
            echo -n "[Get Images] Starting ftp for file $i"
            let filestransferred=$filestransferred+1;
            if (cd $imagedir; wget -O $i ftp://w20M0695:ees695@ftp1.ingrambook.com/Imageswk/j400w/$i >$logfile 2>&1); then
               echo "done."
               echo -n "[Get Images] Unzipping file $i..."
               if (cd $imagedir; mkdir $dir; cd $dir; unzip ../$i >$logfile 2>&1) ; then
                   echo "done."
                   echo -n "[Get Images] Archiving file $i"
                   (cd $imagedir; mv $i $archivedir)
                   echo "done."
                   echo -n "[Get Images] Distributing image files to production directories..."
                   if (cd $imagedir; php $EKKITAB_HOME/bin/copyimages.php $dir >/dev/null 2>&1) ; then
                        echo "done."
                   else
                        echo "failed."
                   fi
               else
                   echo "failed."
               fi
            else 
               echo "failed."
            fi
    fi
done
if (($filestransferred == 0)) ; then
    echo "[Get Images] No image files to transfer."
else
    echo "[Get Images] $filestransferred files were transferred and processed."
fi
    
rm $tmpfile 
echo "[Get Images] Completed."


