terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
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
