. ec2.sh
mv -f prod.out prodold.out

echo "*********ec2daddr**********" 
echo "*********ec2daddr**********" >> prod.out
ec2daddr >> prod.out
echo "*********ec2dgrp**********"
echo "*********ec2dgrp**********" >> prod.out
ec2dgrp >> prod.out
echo "***********ec2din*****************"
echo "***********ec2din*****************" >> prod.out
ec2din>>prod.out
echo "***********ec2dvol*****************"
echo "***********ec2dvol*****************" >> prod.out
ec2dvol>>prod.out
echo "***********ec2dsnap*****************" 
echo "***********ec2dsnap*****************" >>prod.out
ec2dsnap>>prod.out
echo "***********ec2dim*****************" 
echo "***********ec2dim*****************" >>prod.out
ec2dim>>prod.out

