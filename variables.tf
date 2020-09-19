## Azure config variables ##
variable "client_id" {}

variable "client_secret" {}

variable location {
  default = "East US"
}

## Resource group variables ##
variable resource_group_name {
  default = "myResourceGroup"
}


## AKS kubernetes cluster variables ##
variable cluster_name {
  default = "myAKSCluster"
}

variable "agent_count" {
  default = 1
}

variable "dns_prefix" {
  default = "myAKSCluste"
}

variable "admin_username" {
    default = "azureuser"
}
