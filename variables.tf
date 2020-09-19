## Azure config variables ##
variable "client_id" {}

variable "client_secret" {}

variable location {
  default = "East US"
}

## Resource group variables ##
variable resource_group_name {
  default = "cyrilic-rg"
}


## AKS kubernetes cluster variables ##
variable cluster_name {
  default = "cyrilic-cluster"
}

variable "agent_count" {
  default = 2
}

variable "dns_prefix" {
  default = "cyrilic"
}

variable "admin_username" {
    default = "cyrilic"
}
