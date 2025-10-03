terraform { required_version = ">= 1.0" }
provider "aws" { region = var.aws_region }

module "g" {
  source = "../../../modules/iam/submodules/group"
  name   = "developers"
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"]
  inline_policies = {
    allow_ssm = jsonencode({
      Version = "2012-10-17",
      Statement = [{ Effect = "Allow", Action = ["ssm:DescribeInstanceInformation"], Resource = "*" }]
    })
  }
}

output "group_name" { value = module.g.group_name }
