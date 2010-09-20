# ami-4b4a522 is Lucid ebs boot 64 bit image
ec2-run-instances ami-4b4ba522  -k ekkitab3 -g default --availability-zone us-east-1d  --instance-type m1.large  -b /dev/sda1=:50 -b /dev/sdc=ephemeral0 -b /dev/sdd=ephemeral1

# sudo resize2fs /dev/sda1
# the above command should be run to resize the boot disk to 50GB .  As when the instance is created, it will still show just 15GB root disk.
