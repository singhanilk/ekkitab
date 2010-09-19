codename=$(lsb_release -cs)
echo "deb http://ppa.launchpad.net/alestic/ppa/ubuntu $codename main"| sudo tee /etc/apt/sources.list.d/alestic-ppa.list    
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys BE09C571
sudo apt-get update
sudo apt-get install -y ec2-consistent-snapshot


