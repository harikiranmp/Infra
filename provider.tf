terraform {
    required_version = ">= 1.10, < 1.14"
  backend "s3" {
    bucket         = "demo-tfstate"        # Replace with your bucket name
    key            = "terraform/state.tfstate"
    region         = "us-east-1"
    encrypt        = true
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
