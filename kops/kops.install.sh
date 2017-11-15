#*********************************************KUBECTL BEGIN *****************************************************
#Get the latest of kubectl
wget -O kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl

#Change the permissions of the file
chmod +x ./kubectl

#Move the file to the user bin
sudo mv ./kubectl /usr/local/bin/kubectl

#*********************************************KUBECTL END *****************************************************


#*********************************************KOPS BEGIN *****************************************************
#Get the latest version of the kops
wget -O kops https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64

#Change the permissions of the file
chmod +x ./kops

#Move the file to the user bin
sudo mv ./kops /usr/local/bin/
#*********************************************KOPS END *****************************************************

#*********************************************AWS CLI BEGIN *****************************************************
#Installing the official pip (recommended by amazon)
sudo apt-get install python-pip

#Add the below variable to the .bash_profile	
export PATH=~/.local/bin:$PATH

#reload the profile into the session
source ~/.bash_profile

#Setup User == Create the by configuring a credential on kops and then changing it later
aws iam create-group --group-name kops-group

aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonEC2FullAccess --group-name kops-group
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonRoute53FullAccess --group-name kops-group
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess --group-name kops-group
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/IAMFullAccess --group-name kops-group
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonVPCFullAccess --group-name kops-group

aws iam create-user --user-name kops-user

aws iam add-user-to-group --user-name kops-user --group-name kops-group

aws iam create-access-key --user-name kops-user



# Because "aws configure" doesn't export these vars for kops to use, we export them now
export AWS_ACCESS_KEY_ID=`aws configure get aws_access_key_id`
export AWS_SECRET_ACCESS_KEY=`aws configure get aws_secret_access_key`

#Create a bucket for the east region
#S3 requires --create-bucket-configuration LocationConstraint=<region> for regions other than us-east-1
aws s3api create-bucket --bucket ticklemybrain-kubernetes-state-store --region us-east-1

#*********************************************AWS CLI END *****************************************************


#*********************************************KOPS BEGIN ******************************************************

#For a gossip-based cluster, make sure the name ends with k8s.local. For example:
export NAME=ticklemybrain-cluster.k8s.local
export KOPS_STATE_STORE=s3://ticklemybrain-kubernetes-state-store

#Generate the keys
ssh-keygen

#The below command will get the cluster configuration that is going to be created
kops create cluster --zones us-east-1a --node-size t2.micro --master-size t2.micro  ${NAME} --cloud=aws

#When you are sure about the config, issue the command with the --yes flag to provision the command.
kops create cluster --zones us-east-1a --node-size t2.micro --master-size t2.micro  ${NAME} --cloud=aws --yes


#Now we have a cluster configuration, we can look at every aspect that defines our cluster by editing the description.
kops edit cluster ${NAME}


#Now we take the final step of actually building the cluster. This'll take a while. Once it finishes you'll have to wait longer while the booted instances finish downloading Kubernetes components and reach a "ready"
kops update cluster ${NAME} --yes

#Validate the Cluster
kops validate cluster

#list nodes: 
kubectl get nodes --show-labels

#ssh to the master: 
ssh -i ~/.ssh/id_rsa admin@api.ticklemybrain-cluster.k8s.local


#You can preview all of the AWS resources that will be destroyed when the cluster is deleted by issuing the following command.
kops delete cluster --name ${NAME}

#When you are sure you want to delete your cluster, issue the delete command with the --yes flag. Note that this command is very destructive, 
#and will delete your cluster and everything contained within it!
kops delete cluster --name ${NAME} --yes


#*********************************************AWS CLI END *****************************************************
