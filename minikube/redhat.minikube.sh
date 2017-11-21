#Download the kvm driver and move to the PATH
curl -L https://github.com/dhiltgen/docker-machine-kvm/releases/download/v0.10.0/docker-machine-driver-kvm-centos7 > /usr/local/bin/docker-machine-driver-kvm \ 
chmod +x /usr/local/bin/docker-machine-driver-kvm

# Fedora/CentOS/RHEL
sudo yum install libvirt-daemon-kvm qemu-kvm

# Fedora/CentOS/RHEL
sudo usermod -a -G libvirt $(whoami)

# Fedora/CentOS/RHEL
newgrp libvirt

#Install kubectl
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl

#Make the kubectl binary executable
chmod +x ./kubectl

#Move the binary in to your PATH
sudo mv ./kubectl /usr/local/bin/kubectl

#Install the minikube and move to the PATH
curl -Lo minikube https://storage.googleapis.com/minikube/releases/v0.23.0/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/

#Start the minikube with the kvm driver
minikube start --vm-driver=kvm


