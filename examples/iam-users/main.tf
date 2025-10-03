terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = { source = "hashicorp/aws" }
  }
}

provider "aws" {
  region = var.aws_region
}

module "iam_users_example" {
  source = "../../modules/iam"

  name_prefix         = "example-iam-"
  create_instance_profile = false
  tags = { Project = "iam-users-example" }

  # Define groups and attach policies to groups (not users)
  groups = {
    developers = {
      managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"]
      inline_policies = {
        dev_allow_ssm = jsonencode({
          Version = "2012-10-17",
          Statement = [
            {
              Effect = "Allow",
              Action = ["ssm:DescribeInstanceInformation"],
              Resource = "*"
            }
          ]
        })
      }
    }

    ops = {
      managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
      inline_policies     = {}
    }
  }

  # Define users, assign them to groups, and optionally create access keys
  users = {
    alice = {
      path = "/developers/"
      groups = ["developers"]
      create_access_key = true
    }

    bob = {
      path = "/ops/"
      groups = ["ops"]
      create_access_key = false
    }
  }
}

output "user_names" {
  value = module.iam_users_example.user_names
}

output "user_access_key_ids" {
  value = module.iam_users_example.user_access_key_ids
}

# Note: access key secrets are exposed by the module as sensitive outputs if you enabled create_access_key.
# They will be present in state. Handle state securely.
