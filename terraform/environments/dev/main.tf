terraform {
  required_version = ">= 1.10"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Remote state: stored in the S3 bucket from the bootstrap step.
  # Backend blocks can't use variables, so the bucket name is written out.
  backend "s3" {
    bucket       = "zuri-tfstate-884404664929"
    key          = "dev/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}

provider "aws" {
  region = "us-east-1"
}

module "networking" {
  source = "../../modules/networking"

  name                 = "zuri-dev"
  vpc_cidr             = "10.0.0.0/16"
  azs                  = ["us-east-1a", "us-east-1b"]
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.101.0/24", "10.0.102.0/24"]
}

output "vpc_id" {
  value = module.networking.vpc_id
}

output "public_subnet_ids" {
  value = module.networking.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.networking.private_subnet_ids
}

module "ecr" {
  source       = "../../modules/ecr"
  name         = "zuri"
  repositories = ["backend", "frontend"]
}

output "ecr_repository_urls" {
  value = module.ecr.repository_urls
}

module "secrets" {
  source       = "../../modules/secrets"
  name         = "zuri-dev"
  secret_names = ["backend-api-key"]
}

output "secret_arns" {
  value = module.secrets.secret_arns
}
