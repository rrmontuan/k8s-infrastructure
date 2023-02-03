variable "region" {
  description = "AWS Region"
}

variable "environment" {
  description = "The infrastructure environment"
}

variable "availability_zones" {
  description = "The zones where the subnets will be available"
}

variable "vpc_cidr" {
  description = "The VPC CIDR"
}

variable "public_subnets_cidr" {
  description = "Subnets CIDRs"
}

