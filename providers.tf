terraform {
  required_version = ">= 0.13.0, < 0.16.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 3.1"
    }
  }

  backend "s3" {
    encrypt = true
    #region = "us-east-1"
  }

}

# Configure the AWS Provider
provider "aws" {
}


