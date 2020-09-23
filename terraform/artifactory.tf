# Import Existing resourse group

#First Create a dummy file

###########################################################################

#Configure the Microsoft Azure Provider
#rovider "azurerm" {
    # The "feature" block is required for AzureRM provider 2.x.
    # If you're using version 1.x, the "features" block is not allowed.
#   version = "~>2.0"
#   features {}
#

#esource "azurerm_resource_group" "myResourceGroup" {
  # (resource arguments)
#

#esource "azurerm_virtual_network" "Jenkins-MasterVNET" {
  # (resource arguments)
#

# Import with command
#                           - NEW NAME , used old to keep track -                  - Subscription ID                  - Existing Resourse group 
# terraform import azurerm_resource_group.myResourceGroup /subscriptions/65b39c88-21ee-4efa-b52c-fc8151f2a75d/resourceGroups/myResourceGroup

# terraform import azurerm_virtual_network.Jenkins-MasterVNET /subscriptions/65b39c88-21ee-4efa-b52c-fc8151f2a75d/resourceGroups/myResourceGroup/providers/Microsoft.Network/virtualNetworks/Jenkins-MasterVNET

###################################################################################################################################

#Configure the Microsoft Azure Provider
provider "azurerm" {
    # The "feature" block is required for AzureRM provider 2.x.
    # If you're using version 1.x, the "features" block is not allowed.
    version = "~>2.0"
    features {}
}


#Create a resource group if it doesn't exist
resource "azurerm_resource_group" "myResourceGroup" {
    name     = "myResourceGroup"
    location = "eastus"

}

# Create virtual network
resource "azurerm_virtual_network" "Jenkins-MasterVNET" {
    name                = "Jenkins-MasterVNET"
    address_space       = ["10.0.0.0/16"]
    location            = "eastus"
    resource_group_name = azurerm_resource_group.myResourceGroup.name

}

# Create subnet
resource "azurerm_subnet" "myterraformsubnet" {
    name                 = "artifactorySubnet"
    resource_group_name  = azurerm_resource_group.myResourceGroup.name
    virtual_network_name = azurerm_virtual_network.Jenkins-MasterVNET.name
    address_prefixes       = ["10.0.1.0/24"]
}


# Create public IPs
resource "azurerm_public_ip" "myterraformpublicip" {
    name                         = "artifactoryPublicIP"
    location                     = "eastus"
    resource_group_name          = azurerm_resource_group.myResourceGroup.name
    allocation_method            = "Dynamic"

    }

# Create Network Security Group and rule
resource "azurerm_network_security_group" "myterraformnsg" {
    name                = "ArtifactoryNSG"
    location            = "eastus"
    resource_group_name = azurerm_resource_group.myResourceGroup.name

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

}

# Create network interface
resource "azurerm_network_interface" "myterraformnic" {
    name                      = "ArtifactoryNIC"
    location                  = "eastus"
    resource_group_name       = azurerm_resource_group.myResourceGroup.name

    ip_configuration {
        name                          = "myNicConfiguration"
        subnet_id                     = azurerm_subnet.myterraformsubnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.myterraformpublicip.id
    }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
    network_interface_id      = azurerm_network_interface.myterraformnic.id
    network_security_group_id = azurerm_network_security_group.myterraformnsg.id
}

 Create (and display) an SSH key
resource "tls_private_key" "example_ssh" {
  algorithm = "RSA"
  rsa_bits = 4096
}
output "tls_private_key" { value = "${tls_private_key.example_ssh.private_key_pem}" }

# Create virtual machine
resource "azurerm_linux_virtual_machine" "artifactoryvm" {
    name                  = "ArtifactoryVM"
    location              = "eastus"
    resource_group_name   = azurerm_resource_group.myResourceGroup.name
    network_interface_ids = [azurerm_network_interface.myterraformnic.id]
    size                  = "Standard_DS1_v2"

    os_disk {
        name              = "myOsDisk"
        caching           = "ReadWrite"
        storage_account_type = "Premium_LRS"
    }

  
    source_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }

    computer_name  = "artifactory"
    admin_username = "azureuser"
    disable_password_authentication = true

    admin_ssh_key {
        username       = "azureuser"
       public_key     = tls_private_key.example_ssh.public_key_openssh
        admin_password = "azure"
    }

}
