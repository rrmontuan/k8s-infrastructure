terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "3.4.0"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}


# Variables used across all modules
locals {
  env = {
    default = {
      environment            = terraform.workspace    
      availability_zones   = ["${var.region}a", "${var.region}b"]
      cluster_nodes         = ["k8s-1", "k8s-2", "k8s-3"]
    }
    dev = {
      vpc_cidr             = "192.168.0.0/24"
      public_subnets_cidr  = ["192.168.0.0/26", "192.168.0.64/26"]
    }

    stg = {
      vpc_cidr             = "192.168.1.0/24"
      public_subnets_cidr  = ["192.168.1.0/26", "192.168.1.64/26"]
    }
    prd = {
      vpc_cidr             = "192.168.2.0/24"
      public_subnets_cidr  = ["192.168.2.0/26", "192.168.2.64/26"]
    }
  }
  environmentvars = contains(keys(local.env), terraform.workspace) ? terraform.workspace : "default"
  workspace       = merge(local.env["default"], local.env[local.environmentvars])
}

module "networking" {
  source                = "./modules/networking"
  environment           = terraform.workspace
  region                = var.region
  availability_zones    = local.workspace["availability_zones"]
  vpc_cidr              = local.workspace["vpc_cidr"]
  public_subnets_cidr   = local.workspace["public_subnets_cidr"]
}

module "ec2" {
  source                              = "./modules/ec2"
  environment                         = terraform.workspace
  region                              = var.region
  cluster_nodes                       = local.workspace["cluster_nodes"]
  public_key                          = var.public_key 
  subnet                              = element(module.networking.subnets, 0)  
  rancher_server_dns                  = module.dns.rancher_dns
  domain                              = var.domain
  nodes_dns                           = module.dns.nodes_dns
  rancher_server_admin_password       = var.rancher_server_admin_password
  rancher_version                     = var.rancher_version
  aws_route_table_association         = element(module.networking.aws_route_table_association, 0)
  ec2_security_group_ids  = [
    module.networking.default_sg.id,
    module.networking.external_access_sg.id
  ]
}

module "dns" {
  source                  = "./modules/dns"
  environment             = terraform.workspace
  region                  = var.region
  domain                  = var.domain
  server_public_ip        = module.ec2.server_public_ip
  nodes_public_ips        = module.ec2.nodes_public_ips
}

