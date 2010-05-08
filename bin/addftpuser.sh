#!/bin/bash
if [ $# -ne 1 ] ; then
    echo "Not enough arguments...."; echo "Usage: $0 <partner>"
    exit 1;
fi;
sudo useradd -p azO65t0f76p5w -m -d /mnt4/publisherdata/$1/ftp $1ftp
