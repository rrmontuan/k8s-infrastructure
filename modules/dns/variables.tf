variable "region" {
  description = "AWS Region"
}

variable "environment" {
  description = "The infrastructure environment"
}

variable "domain" {
  description = "The Domain used to access resources"
}

variable "server_public_ip" {
  description = "The Rancher Server public IP"
}

variable "nodes_public_ips" {
  description = "An array with the public IPs from all the nodes"
}
