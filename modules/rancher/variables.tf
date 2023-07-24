# Variables for rancher common module

# Required
variable "node_public_ip" {
  type        = string
  description = "Public IP of compute node for Rancher cluster"
}

variable "node_internal_ip" {
  type        = string
  description = "Internal IP of compute node for Rancher cluster"
  default     = ""
}

# Required
variable "node_username" {
  type        = string
  description = "Username used for SSH access to the Rancher server cluster node"
}

# Required
variable "ssh_private_key_pem" {
  type        = string
  description = "Private key used for SSH access to the Rancher server cluster node"
}

# Required
variable "rancher_server_dns" {
  type        = string
  description = "DNS host name of the Rancher server"
}

variable "domain" {
  type        = string
  description = "DNS Domain"
}

# Required
variable "admin_password" {
  type        = string
  description = "Admin password to use for Rancher server bootstrap, min. 12 characters"
}

# Required
variable "workload_cluster_name" {
  type        = string
  description = "Name for created custom workload cluster"
}

variable "nodes_dns" {
  type        = string
  description = "DNS host name of the cluster nodes"
}
