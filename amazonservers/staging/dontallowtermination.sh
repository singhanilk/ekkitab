INSTANCEID=$1
ec2-modify-instance-attribute --disable-api-termination true $INSTANCEID
ec2-modify-instance-attribute --instance-initiated-shutdown-behavior stop $INSTANCEID

