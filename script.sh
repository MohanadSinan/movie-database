#!/bin/bash

echo -e "\n\n"
echo "====== Install Ansible and AWS CLI ======"
echo "--> Updating the list of available packages ..."
sudo apt update -y > /dev/null 2>&1
echo "Installing Ansible ..."
sudo apt install ansible -y > /dev/null 2>&1
echo "Installing AWS CLI ..."
sudo apt install awscli -y > /dev/null 2>&1

echo -e "\n\n"
echo "====== Configuring AWS CLI ======"
echo "Please enter the AWS credentials:"
read -p '--> AWS Access Key ID: ' AWS_ACCESS_KEY_ID
aws configure set aws_access_key_id "$AWS_ACCESS_KEY_ID"
read -p '--> AWS Secret Access Key: ' AWS_SECRET_ACCESS_KEY
aws configure set aws_secret_access_key "$AWS_SECRET_ACCESS_KEY"
read -p '--> Default region name: ' AWS_REGION
aws configure set region "$AWS_REGION"
read -p '--> Default output format: ' AWS_OUTPUT
aws configure set output "$AWS_OUTPUT"

echo -e "\n\n"
echo "====== Install Terraform ======"
echo "--> Ensure that your system have the gnupg, software-properties-common, and curl packages installed ..."
sudo apt-get install -y gnupg software-properties-common > /dev/null 2>&1
echo "--> Install the HashiCorp GPG key ..."
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "--> Verify the key's fingerprint ..."
gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint
echo "--> Add the official HashiCorp repository to your system ..."
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
echo "--> Download the package information from HashiCorp ..."
sudo apt-get update -y > /dev/null 2>&1
echo "--> Install Terraform from the new repository ..."
sudo apt-get install terraform

echo -e "\n\n"
echo "====== Clone the project ======"
git clone https://github.com/MohanadSinan/movie-database.git /home/ubuntu/movie-database

echo -e "\n\n"
echo "====== Creating Jenkins EC2 Instance ======"
echo "--> terraform init ..."
terraform -chdir=/home/ubuntu/movie-database/Terraform/Jenkins init > /dev/null
echo "--> terraform apply ..."
terraform -chdir=/home/ubuntu/movie-database/Terraform/Jenkins apply -auto-approve

echo -e "\n\n"
echo "====== Creating Ansible Inventory file ======"
echo -e "[jenkins]\nnode1 ansible_user=ubuntu ansible_host=$(terraform -chdir=/home/ubuntu/movie-database/Terraform/Jenkins output -raw instance_public_ip)\n\n[all:vars]\nansible_ssh_private_key_file=/home/ubuntu/.ssh/movie.pem" > /home/ubuntu/movie-database/Ansible/Hosts

echo -e "\n\n"
echo "====== Copy the private key from S3 ======"
aws s3 cp s3://movie-database-key/movie.pem /home/ubuntu/.ssh/movie.pem > /dev/null
sudo chmod 400 /home/ubuntu/.ssh/movie.pem

echo -e "\n\n"
echo "====== Ansible Playbook Start ======"
echo "--> Waiting for Jenkins insurance to be ready [0s]..."
sleep 30
echo "--> Waiting for Jenkins insurance to be ready [30s]..."
sleep 30
echo "--> Waiting for Jenkins insurance to be ready [60s]..."
sleep 30
echo "--> Waiting for Jenkins insurance to be ready [90s]..."
sleep 30
echo "--> Waiting for Jenkins insurance to be ready [120s]..."
sleep 20
echo "--> Almost there ..."
sleep 10

echo -e "\n\n"
ansible-playbook movie-database/Ansible/jenkins.yml -i /home/ubuntu/movie-database/Ansible/Hosts