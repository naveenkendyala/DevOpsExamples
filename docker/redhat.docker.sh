
# pre-requisite for container-selinux-2.9-4.el7.noarch.rpm
sudo yum install policycoreutils-python

#Install selinux container
wget ftp://ftp.icm.edu.pl/vol/rzm6/linux-centos-vault/7.3.1611/extras/x86_64/Packages/container-selinux-2.9-4.el7.noarch.rpm
sudo rpm -i container-selinux-2.9-4.el7.noarch.rpm

#Set up the Docker CE repository on RHEL:
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# Install the latest version of Docker CE on RHEL:
sudo yum -y install docker-ce

#Start Docker:
sudo systemctl start docker

# configure Docker to start on boot
sudo systemctl enable docker

# add user to the docker group 
sudo groupadd docker
sudo usermod -aG docker $USER

#Test your Docker CE installation:
sudo docker run hello-world
