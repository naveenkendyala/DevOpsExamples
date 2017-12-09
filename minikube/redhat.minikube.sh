#Install kubectl,Make the kubectl binary executable,Move the binary in to your PATH
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && chmod +x ./kubectl && sudo mv ./kubectl /usr/local/bin/kubectl

#Linux
#VirtualBox or KVM
#NOTE: Minikube also supports a --vm-driver=none option that runs the Kubernetes components on the host and not in a VM. Docker is required to use this driver but no hypervisor.

#*** Adding packages for kvm/kvm2 driver - START
# Fedora/CentOS/RHEL
sudo yum install libvirt-daemon-kvm qemu-kvm

# Fedora/CentOS/RHEL
sudo usermod -a -G libvirt $(whoami)

# Fedora/CentOS/RHEL
newgrp libvirt

#Install the KVM2 driver [KVM is being decommissioned]
curl -LO https://storage.googleapis.com/minikube/releases/latest/docker-machine-driver-kvm2 && chmod +x docker-machine-driver-kvm2 && sudo mv docker-machine-driver-kvm2 /usr/local/bin/

#Install the kvm driver and move to the PATH for kvm
curl -L https://github.com/dhiltgen/docker-machine-kvm/releases/download/v0.10.0/docker-machine-driver-kvm-centos7 > /tmp/docker-machine-driver-kvm &&
    chmod +x /tmp/docker-machine-driver-kvm &&
    sudo cp /tmp/docker-machine-driver-kvm /usr/local/bin/docker-machine-driver-kvm
    
#*** Adding packages for kvm driver - END

#Install docker-machine for NONE driver
curl -L https://github.com/docker/machine/releases/download/v0.13.0/docker-machine-`uname -s`-`uname -m` >/tmp/docker-machine &&
    chmod +x /tmp/docker-machine &&
    sudo cp /tmp/docker-machine /usr/local/bin/docker-machine

#Install the minikube and move to the PATH
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/

#Start the minikube with the kvm driver
minikube start --vm-driver=kvm2
minikube start --vm-driver=none


