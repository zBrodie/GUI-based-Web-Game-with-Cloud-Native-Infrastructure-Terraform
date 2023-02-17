terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region = var.region
}

provider "aws" {
  alias = "acm_provider"
  profile = "default"
  region = "us-east-1"
}