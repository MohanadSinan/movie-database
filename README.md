# Movie Database

**(Simple Java Spring Boot Web Application)**

<p align="center">
<img src="https://i.imgur.com/Dg0Iixl.png" alt="movie-database screenshot" width=400 />
</p>

In this project we implemented what we learned in DevOps Bootcamp. We will deploy a simple java spring boot web application on AWS Elastic Beanstalk with high-availability infrastructure (Load Balanced) using Terraform as infrastructure as a code (IaC), Ansible as a configuration management tool and Jenkins as CI/CD.

## Tools used

- Ansible (Configuration management).
- Terraform (IaC).
- Jenkins (CI/CD).

## Steps

1. Create a Dockerfile and push it to dockerhub -------------------------------------> **Dockerfile 1**

   ↳  ([Dockerfile](/Dockerfile))

   ↳  ([Dockerrun.aws.json](/Dockerrun.aws.json))

2. Write Terraform to create EC2 (let's call it Jenkins) --------------------------------> **Terraform file 1**

   ↳  ([Jenkins.tf](Terraform/Jenkins/Jenkins.tf))

   ---

3. Install (Jenkins, Docker, AWS CLI) in that EC2 using Ansible ----------------------> **Ansible Playbook** with roles to install

   ↳  ([./Ansible/jenkins.yml](Ansible/jenkins.yml))

   ↳  ([./Ansible/roles/docker/tasks/main.ymlmain.yml](Ansible/roles/docker/tasks/main.yml))

   ↳  ([./Ansible/roles/jenkins/tasks/main.yml](Ansible/roles/jenkins/tasks/main.yml))

   ↳  ([./Ansible/roles/aws/tasks/main.yml](Ansible/roles/aws/tasks/main.yml))

   ↳  ([./Ansible/roles/terraform/tasks/main.yml](Ansible/roles/terraform/tasks/main.yml))

   ↳  ([./Ansible/vars/main.yml](Ansible/vars/main.yml))

   ↳  ([./Ansible/ansible.cfg](Ansible/ansible.cfg))

---

5. Write Terraform to create EB (most have load balancer) -------------------------> **Terraform file 2**

   ↳  ([EB.tf](Terraform/EB/EB.tf))

6. Write Jenkinsfile pipeline to apply Terraform file 2 (EB.tf) ------------------------> **Jenkinsfile 1**

   ↳  ([Jenkinsfile-EB](Jenkins/Jenkinsfile-EB))

7. Write Jenkinsfile pipeline to deploy (update) the EB -----------------------------> **Jenkinsfile 2**

   ↳  ([Jeinkinsfile-Deploy](Jenkins/Jeinkinsfile-Deploy))

   ---
   
8. Write Terraform to create CloudFront on EB --------------------------------------> **Terraform file 3**

   ↳  ([CloudFront.tf](Terraform/CloudFront/CloudFront.tf))

9. Write Jenkinsfile pipeline to apply Terraform file 3 (CloudFront.tf) ---------------> **Jenkinsfile 3**

   ↳  ([Jenkinsfile-CF](Jenkins/Jenkinsfile-CF))


---

## Script

This is a script to automate the ansible configuration (on ubuntu server):

```sh
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
read -p '--> The private key name: ' KEY_NAME
aws s3 cp s3://movie-database-key/movie.pem /home/ubuntu/.ssh/$KEY_NAME > /dev/null
sudo chmod 400 /home/ubuntu/.ssh/$KEY_NAME
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
```
