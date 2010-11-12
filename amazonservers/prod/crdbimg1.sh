#Execute this script if 500 GB Img vol is existing
Imgdev=/dev/sdg
DBdev=/dev/sdh

#Put the last snapshot for DB vol here

Dbdisk200G=snap-8f8e01e5

#Put Image Volume Name in ImgVol
#
ImgVol=vol-60d2e109
echo "ImgVol $ImgVol"
DbVol=$(ec2addvol -s 200 -z us-east-1d  --snapshot $Dbdisk200G  | grep  ^VOL | cut -f2)
echo "DbVol $DbVol"
echo "Do you want to attach these volumes [y/n]:"
read answer
if [ $answer =  "n" ]
then
    exit 0
fi

echo "do you want to continue?input instanceid:"
read instanceid

retimg=$(ec2attvol $ImgVol -i $instanceid -d $Imgdev )
echo $retimg
retdb=$(ec2attvol $DbVol -i $instanceid -d $DBdev )
echo $retdb

echo "Do you want to reboot $instanceid ?[y/n] "
read answer
if [ $answer =  "n" ]
then
    exit 0
fi
