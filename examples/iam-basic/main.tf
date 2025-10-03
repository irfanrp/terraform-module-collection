terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = { source = "hashicorp/aws" }
  }
}

provider "aws" {
  region = var.aws_region
}

module "iam_example" {
  source = "../../modules/iam"

  name_prefix             = "example-iam-"
  assume_services         = ["ec2.amazonaws.com"]
  managed_policy_arns     = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
  create_instance_profile = true
  tags = {
    Project = "iam-basic"
  }
}

output "role_arn" {
  value = module.iam_example.role_arn
}
