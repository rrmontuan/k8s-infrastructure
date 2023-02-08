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
