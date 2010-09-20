#just an example 
# modify instance id and volume id
#it shows some java error, but works

ec2-modify-instance-attribute i-af911ac5 -b /dev/sda1=vol-0a96d263:false -v
