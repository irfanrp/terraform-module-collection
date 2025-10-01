# Terraform syntax validation only - no AWS connection needed
terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Mock provider for syntax checking
provider "aws" {
  region = "us-west-2"

  # Skip all AWS API calls
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  # Mock credentials
  access_key = "mock"
  secret_key = "mock"
}

module "vpc" {
  source = "../../modules/vpc"

  name               = "test-vpc"
  cidr_block         = "10.0.0.0/16"
  availability_zones = ["us-west-2a", "us-west-2b"]
  enable_nat_gateway = false # Disable for faster testing

  tags = {
    Environment = "test"
    Project     = "syntax-check"
    ManagedBy   = "Terraform"
  }
}

# Example Security Group
resource "aws_security_group" "web" {
  name_prefix = "test-web-"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "test-web-sg"
    Environment = "test"
  }
}