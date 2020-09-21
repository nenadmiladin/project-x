# Import Existing resourse group

#First Create a dummy file

########

#Configure the Microsoft Azure Provider
provider "azurerm" {
    # The "feature" block is required for AzureRM provider 2.x.
    # If you're using version 1.x, the "features" block is not allowed.
    version = "~>2.0"
    features {}
}

resource "azurerm_resource_group" "myResourceGroup" {
  # (resource arguments)
}

resource "azurerm_virtual_network" "Jenkins-MasterVNET" {
  # (resource arguments)
}

#######

Import with command
                           - NEW NAME , used old to keep track -                  - Subscription ID                  - Existing Resourse group 
terraform import azurerm_resource_group.myResourceGroup /subscriptions/65b39c88-21ee-4efa-b52c-fc8151f2a75d/resourceGroups/myResourceGroup

terraform import azurerm_virtual_network.Jenkins-MasterVNET /subscriptions/65b39c88-21ee-4efa-b52c-fc8151f2a75d/resourceGroups/myResourceGroup/providers/Microsoft.Network/virtualNetworks/Jenkins-MasterVNET
