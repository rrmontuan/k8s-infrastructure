variable "region" {
  description = "AWS Region"
}

variable "environment" {
  description = "The infrastructure environment"
}

variable "cluster_nodes" {
  description = "The cluster nodes names"
}

variable "ec2_security_group_ids" {
  description = "List with the security group ids that must be used in EC2 Instances"
}

variable "public_key" {
  description = "The public key that will be registered with AWS to allow logging-in to EC2 Instances"
}

variable "subnet" {
  description = "The subnet where the EC2 instances will be created"
}

variable "rancher_server_admin_password" {
  type        = string
  description = "Admin password to use for Rancher server bootstrap, min. 12 characters"
}

variable "rancher_version" {
  type        = string
  description = "Rancher server version (format 0.0.0)"
}

# Required
variable "domain" {
  type        = string
  description = "DNS host name of the Rancher server"
}

variable "aws_route_table_association" {
  description = "AWS Route Table Association"
}

locals {
  node_username = "ubuntu"
}
