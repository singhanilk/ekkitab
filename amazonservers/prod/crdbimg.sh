Imgdisk500G=snap-ee218d85
Imgdev=/dev/sdg
DBdev=/dev/sdh
Dbdisk200G=snap-daf84db1

ImgVol=$(ec2addvol -s 500 -z us-east-1d  --snapshot $Imgdisk500G | grep ^VOL | cut -f2 )
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

ec2-reboot-instances $instanceid

exit 0
