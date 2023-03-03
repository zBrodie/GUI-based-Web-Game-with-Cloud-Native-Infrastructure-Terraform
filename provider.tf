terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  profile = "capstone"
  region = var.region
}

provider "aws" {
  alias = "acm_provider"
  profile = "capstone"
  region = "us-east-1"
}