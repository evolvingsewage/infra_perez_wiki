variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "instance_type" {
  type    = string
  default = "t4g.medium"
}

variable "admin_cidr" {
  description = "CIDR allowed to reach the Jenkins UI (your IP, e.g. 203.0.113.4/32)"
  type        = string
}

variable "linode_host" {
  description = "Hostname of the Linode box the deploy job SSHes into"
  type        = string
  default     = "perez.wiki"
}

variable "state_bucket_prefix" {
  type    = string
  default = "infra-perez-wiki-tfstate"
}

variable "linode_ssh_private_key" {
  description = "SSH private key Jenkins uses to deploy to the Linode box"
  type        = string
  sensitive   = true
}

variable "exporter_basic_auth_hash" {
  description = "bcrypt hash for node_exporter's basic auth"
  type        = string
  sensitive   = true
}

variable "jenkins_admin_password" {
  description = "Password for the Jenkins 'admin' user, provisioned via JCasC"
  type        = string
  sensitive   = true
}
