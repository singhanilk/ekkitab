. ec2.sh
mv -f integ.out integold.out


echo "*********ec2daddr**********" 
echo "*********ec2daddr**********" >> integ.out
ec2daddr >> integ.out
echo "*********ec2dgrp**********"
echo "*********ec2dgrp**********" >> integ.out
ec2dgrp >> integ.out
echo "***********ec2din*****************"
echo "***********ec2din*****************" >> integ.out
ec2din>>integ.out
echo "***********ec2dvol*****************"
echo "***********ec2dvol*****************" >> integ.out
ec2dvol>>integ.out
echo "***********ec2dsnap*****************" 
echo "***********ec2dsnap*****************" >>integ.out
ec2dsnap>>integ.out
echo "***********ec2dim*****************" 
echo "***********ec2dim*****************" >>integ.out
ec2dim>>integ.out



