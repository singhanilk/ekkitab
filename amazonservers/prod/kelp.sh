# large  instance  with our private image 
date

#ec2-run-instances  ami-e768838e  -k ekkitab  --availability-zone us-east-1d --group ekkitab --instance-type m1.large  -b /dev/sda1=:100 -b /dev/sdb=ephemeral0 -b /dev/sdc=ephemeral1 

# sudo resize2fs /dev/sda1
# the above command should be run to resize the boot disk to 50GB .  As when the instance is created, it will still show just 15GB root disk.


keypair=ekkitab
sshkey=$keypair.pem # or wherever you keep it
group=ekkitab
region=us-east-1 # pick your region
zone=${region}d # pick your availability zone
type=m1.large # pick your size
amiid=ami-e768838e # Ubuntu 9.10  our private image


instanceid=$(ec2-run-instances  $amiid --group $group  --key $keypair   --region $region   --availability-zone $zone   --instance-type $type    -b /dev/sda1=:100 -b /dev/sdb=ephemeral0 -b /dev/sdc=ephemeral1 | egrep ^INSTANCE | cut -f2)

echo "instanceid=$instanceid"

while host=$(ec2-describe-instances --region $region "$instanceid" | 
  egrep ^INSTANCE | cut -f4) && test -z $host; do echo -n .; sleep 1; done

echo host=$host


until  (ssh -q -i ekkitab.pem ubuntu@$host cat /dev/null)
 do
 echo "trying to login" ; 
 done



echo " System is up "
echo "run donotdeleterootpartion.sh  after modifying it"
