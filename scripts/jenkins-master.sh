#!/bin/bash
export resourceGroup=myResourceGroup
virtualMachine=Jenkins-Master
adminUser=azureuser
pathToKubeConfig=~/.kube/config

if [ -f $pathToKubeConfig ]
then

    # Create a resource group.
#    az group create --name $resourceGroup --location westeurope

    # Create a new virtual machine, this creates SSH keys if not present.
    az vm create --resource-group $resourceGroup --name $virtualMachine --admin-username $adminUser --image UbuntuLTS --generate-ssh-keys

    # Open port 80 to allow web traffic to host.
    az vm open-port --port 80 --resource-group $resourceGroup --name $virtualMachine  --priority 101

    # Open port 22 to allow ssh traffic to host.
    az vm open-port --port 22 --resource-group $resourceGroup --name $virtualMachine --priority 102

    # Open port 8080 to allow web traffic to host.
    az vm open-port --port 8080 --resource-group $resourceGroup --name $virtualMachine --priority 103

    # Use CustomScript extension to install NGINX.
#    az vm extension set --publisher Microsoft.Azure.Extensions --version 2.0 --name CustomScript --vm-name $virtualMachine --resource-group $resourceGroup --settings '{"fileUris": ["https://raw.githubuser
#content.com/nenadmiladin/project-x/master/scripts/config-jenkins.sh"],"commandToExecute": "./config-jenkins.sh"}'

    # Get public IP
    ip=$(az vm list-ip-addresses --resource-group $resourceGroup --name $virtualMachine --query [0].virtualMachine.network.publicIpAddresses[0].ipAddress -o tsv)

    echo $ip
    
    az vm run-command invoke -g myResourceGroup -n Jenkins-Master --command-id RunShellScript --scripts "sudo wget -qO - https://pkg.jenkins.io/debian-stable/jenkins.io.key | apt-key add -"

    scp -o stricthostkeychecking=no /home/$(whoami)/project-x/scripts/config-jenkins.sh $adminUser@$ip:/tmp

    ssh -o stricthostkeychecking=no $adminUser@$ip sh /tmp/config-jenkins.sh

    ssh -o stricthostkeychecking=no $adminUser@$ip sudo chmod 777 /var/lib/jenkins

    # Copy Kube config file to Jenkins
    ssh -o stricthostkeychecking=no $adminUser@$ip sudo chmod 777 /var/lib/jenkins
    yes | scp -o stricthostkeychecking=no $pathToKubeConfig $adminUser@$ip:/var/lib/jenkins/config
    ssh -o stricthostkeychecking=no $adminUser@$ip sudo chmod 777 /var/lib/jenkins/config

    # Get Jenkins Unlock Key
    url="http://$ip:8080"
    echo "Open a browser to $url"
    echo "Enter the following to Unlock Jenkins:"
    ssh -o "StrictHostKeyChecking no" $adminUser@$ip sudo "cat /var/lib/jenkins/secrets/initialAdminPassword"

else
    echo "Kubernetes configuration / authentication file not found. Run az aks get-credentials to download this file."
fi
