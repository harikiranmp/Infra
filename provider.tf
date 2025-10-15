terraform {
    required_version = ">= 1.10, < 1.14"

  backend "s3" {
    bucket         = "hari-tfstate-2025"        
    key            = "terraform/state.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    use_lockfile    = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
