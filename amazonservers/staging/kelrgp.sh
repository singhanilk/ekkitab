# large  instance  

ec2-run-instances ami-976f84fe -k ekkitab3  --availability-zone us-east-1d --group default --instance-type m1.large  -b /dev/sda1=:100 -b /dev/sdb=ephemeral0 -b /dev/sdc=ephemeral1 

# sudo resize2fs /dev/sda1
# the above command should be run to resize the boot disk to 50GB .  As when the instance is created, it will still show just 15GB root disk.



