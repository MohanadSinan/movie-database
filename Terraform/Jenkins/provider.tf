terraform {
    required_providers {
      aws = {
        source  = "hashicorp/aws"
        version = "~> 4.0"
      }
    }
  }
  
  # Define AWS as a provider
  provider "aws" {
    profile = "nadaslissa"
    region = var.aws_region
  }