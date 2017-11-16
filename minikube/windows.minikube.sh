
#Install minikube from chocolatey
choco install minikube

#Upgrading minikube
choco upgrade minikube

#Ensure that the minikube is in the path. If you have installed via the choco, the path will be updated automatically
minikube version

#Create a External NAT switch in the Hypervisor

#Open a command prompt as an administrator

#Start the Minikube with the below options
# start                             Starts a local kubernetes cluster
# --vm-driver             string    VM driver is one of: [virtualbox hyperv] (default "virtualbox")
# --hyperv-virtual-switch string    The hyperv virtual switch name. Defaults to first found. (only supported with HyperV driver)
minikube start --vm-driver=hyperv --hyperv-virtual-switch=MinikubeNAT

#Check the status of minikube
minikube status
# minikube: Running
# cluster: Running
# kubectl: Correctly Configured: pointing to minikube-vm at 192.168.107.47

#Get the dashboard of the Kubernetes Cluster. This opens up the dashboard in the default browser
minikube dashboard

#Stop the minikube cluster
minikube stop



