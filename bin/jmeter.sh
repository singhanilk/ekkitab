#!/bin/bash
# invoke the jmeter testscript 10searches.jmx , that bombards ekkitab.co.in with 100 virtual users in under a second
if [ $# -ne 1 ]; then
echo "Not Enough arguments! Enter the path where the jmeter test script is stored"; echo "Usage : $0 <jmeterTestScript> $1 <number_of_threads> $2 <ramp_up_time> $3"
exit 1;
fi;

echo " Launching jmeter"
jmeter -n -t $1
