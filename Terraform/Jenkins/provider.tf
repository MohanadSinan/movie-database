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
    profile = "terraform"
    region = var.aws_region
    default_tags {
    tags = {
      Environment = "Development"
      Project     = "Movie Database"
      Version     = "1.0"
    }
  }
  }