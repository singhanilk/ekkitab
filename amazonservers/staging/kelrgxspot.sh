# spot instance  with public image with 200gb ebs /mnt2 200gb ebs /mnt3 200gbs /mnt4 (a copy of integration m/c ) 
ec2-request-spot-instances ami-7d43ae14 -k ekkitab3  --availability-zone us-east-1d --group default --instance-type m1.xlarge  -b /dev/sda1=:50 -b /dev/sdb=ephemeral0 -b /dev/sdc=ephemeral1 -b /dev/sdd=ephemeral2  -b /dev/sde=ephemeral3

# sudo resize2fs /dev/sda1
# the above command should be run to resize the boot disk to 50GB .  As when the instance is created, it will still show just 15GB root disk.
