# Infrastructure Deployment:
:rocket:

As a showcase, 3 different ways for Infrastructure deployment were used: scripts, Ansible yaml files and Terraform files.

**\*This is not best practice and was utilized just as a demonstration of my skills.**

The infrastructure consists of 2 VMs (Jenkins-Master, Jenkins-Slave )and one Azure Kubernetes Cluster (AKS).

The free Azure account is limited to 4 vCPUs, while AKS needs to be run on at least 2 vCPUs.

Jenkins-Master VM was deployed utilizing the script: *project-x/scripts/jenkins-master.sh* and was **configured** with *project-x/scripts/config-jenkins.sh*

Jenkins-Slave VM was deployed utilizing ansible: *project-x/ansible/Jenkins-Slave.yaml*

AKS cluster was deployed with the use of Terraform files: *project-x/terraform/main.tf* and *project-x/terraform/variables.tf.*

Another option for privisioning of an AKS CLuster was also written out: *project-x/scripts/cluster.sh*

A Terraform showcase file for the deploymnet of an Artifactory VM on a preexisting infrastructure can be found here: *project-x/terraform/artifactory.tf*

# Infrastructure Overview:

![Image of Infrastructure](https://i.ibb.co/Ld8Vbz7/Screenshot-2020-09-23-212008.png)




# Applications

http://52.190.44.102/ - Kubernetes Cluster Azure Vote App (python)

http://52.147.205.42:8080/ - Jenkins (user: admin, password: Admin123!)

http://40.71.63.158:8081/artifactory - Artifactory (user: admin, password Admin123!)

http://52.147.205.42:9090/Lab6A/ - Tomcat app






