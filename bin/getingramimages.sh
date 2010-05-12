#!/bin/bash
if [ $# -ne 1 ] ; then
    echo "Not enough arguments...."; echo "Usage: $0 <date in MMDDYY format>" 
    exit 1;
fi;
d1=10#$1
tmpfile="./.newingramsimages"
archivedir='/mnt4/publisherdata/archives'
ftp ftp1.ingrambook.com > $tmpfile <<!
w20M0695
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
            wget -O $i ftp://w20M0695:ees695@ftp1.ingrambook.com/Imageswk/j400w/$i
            echo "unzipping file $i"
            (mkdir $dir; cd $dir; unzip ../$i)
            echo "archiving file $i"
            mv $i $archivedir 
    fi
done
rm $tmpfile 



