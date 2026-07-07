variable "azure_region" {
  type    = string
  default = "eastus"
}

variable "cluster_name" {
  type    = string
  default = "infra-perez-wiki-monitoring"
}

# lowest possible tier for my cluster
variable "node_vm_size" {
  type    = string
  default = "Standard_D2s_v7"
}

# free trial nonsense
variable "node_count" {
  type    = number
  default = 2
}

variable "state_storage_account_prefix" {
  description = "Must match bootstrap/azure's storage_account_prefix."
  type        = string
  default     = "infraperezwiki"
}

variable "state_resource_group_name" {
  description = "Must match bootstrap/azure's resource_group_name."
  type        = string
  default     = "infra-perez-wiki-tfstate-rg"
}

variable "grafana_admin_password" {
  description = "Grafana admin password for the real deployment."
  type        = string
  sensitive   = true
}

variable "linode_exporter_password" {
  description = "node_exporter basic-auth password"
  type        = string
  sensitive   = true
}

# host:port of the Jenkins EC2 node_exporter (its EIP). Empty omits the job,
# so monitoring can deploy standalone without Jenkins up.
variable "jenkins_exporter_target" {
  type    = string
  default = ""
}

variable "jenkins_exporter_password" {
  description = "node_exporter basic-auth password on the Jenkins box"
  type        = string
  sensitive   = true
  default     = ""
}
