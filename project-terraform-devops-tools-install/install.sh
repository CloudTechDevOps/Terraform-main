#!/bin/bash
sudo yum update -y

#---------------git install ---------------

sudo yum install git -y


#-------java dependency for jenkins------------

sudo yum install java-17-amazon-corretto.x86_64


#------------jenkins install-------------
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum install jenkins -y
sudo systemctl enable jenkins
sudo systemctl start jenkins


# ------------------install terraform ------------------

sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform

#---------------------------------install tomcat------------------
#sudo wget url https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.83/bin/apache-tomcat-9.0.83.tar.gz
#sudo tar -xvzf apache-tomcat-9.0.83.tar.gz #untar
#cd apache-tomcat-9.0.83
#cd bin
#chmod +x startup.sh



#---------------------------Maven install -------------
sudo yum install maven -y

#---------------------------kubectl install ---------------
sudo curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.19.6/2021-01-05/bin/linux/amd64/kubectl
sudo chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin 
# -----------------------------eksctl install--------------------------------
sudo curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin

#----------------------Trivy install---------------
sudo rpm -ivh https://github.com/aquasecurity/trivy/releases/download/v0.48.3/trivy_0.48.3_Linux-64bit.rpm

#----------------------sonarQube install-----------------------------------
sudo yum -y install wget nfs-utils
sudo wget -O /etc/yum.repos.d/sonar.repo http://downloads.sourceforge.net/project/sonar-pkg/rpm/sonar.repo
sudo yum -y install sonar
#-----------------------JFROg-----------------------------
sudo wget https://releases.jfrog.io/artifactory/artifactory-rpms/artifactory-rpms.repo -O jfrog-artifactory-rpms.repo;

sudo mv jfrog-artifactory-rpms.repo /etc/yum.repos.d/;

sudo yum update && sudo yum install jfrog-artifactory-oss -y

sudo systemctl start artifactory.service

#------------------Docker install-------------
#sudo amazon-linux-extras install docker #linux 2022
sudo yum install docker -y #linux 2023
sudo usermod -aG docker ec2-user
sudo usermod -aG docker jenkins 
newgrp docker
sudo chmod 777 /var/run/docker.sock
sudo service docker start
#------------------sonar install by using docker---------------
docker run -d --name sonar -p 9000:9000 sonarqube:lts-community
docker run -d --name tomcat -p 8089:8080 tomcat:lts-community


#------------------Terraformer----------------
export PROVIDER=all
curl -LO "https://github.com/GoogleCloudPlatform/terraformer/releases/download/$(curl -s https://api.github.com/repos/GoogleCloudPlatform/terraformer/releases/latest | grep tag_name | cut -d '"' -f 4)/terraformer-${PROVIDER}-linux-amd64"
chmod +x terraformer-${PROVIDER}-linux-amd64
sudo mv terraformer-${PROVIDER}-linux-amd64 /usr/local/bin/terraformer
