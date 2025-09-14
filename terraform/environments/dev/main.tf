terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  
  default_tags {
    tags = {
      Environment = "dev"
      Project     = "eks-multi-az-cluster"
      ManagedBy   = "terraform"
    }
  }
}

locals {
  cluster_name = "eks-multi-az-cluster-dev"
  
  common_tags = {
    Environment = "dev"
    Project     = "eks-multi-az-cluster"
    ManagedBy   = "terraform"
  }
}

module "vpc" {
  source = "../../modules/vpc"
  
  cluster_name = local.cluster_name
  vpc_cidr     = "10.0.0.0/16"
  
  private_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnet_cidrs  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  
  tags = local.common_tags
}

module "security" {
  source = "../../modules/security"
  
  cluster_name         = local.cluster_name
  vpc_id              = module.vpc.vpc_id
  allowed_cidr_blocks = ["0.0.0.0/0"]
  
  tags = local.common_tags
}

module "eks" {
  source = "../../modules/eks"
  
  cluster_name               = local.cluster_name
  kubernetes_version         = "1.28"
  private_subnet_ids         = module.vpc.private_subnet_ids
  public_subnet_ids          = module.vpc.public_subnet_ids
  cluster_security_group_id  = module.security.cluster_security_group_id
  kms_key_arn               = module.security.kms_key_arn
  
  node_instance_types = ["t3.medium"]
  node_desired_size   = 3
  node_max_size       = 6
  node_min_size       = 1
  node_disk_size      = 20
  
  tags = local.common_tags
}