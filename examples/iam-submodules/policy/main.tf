terraform { required_version = ">= 1.0" }
provider "aws" { region = var.aws_region }

module "p" {
  source = "../../../modules/iam/submodules/policy"
  policies = {
    "example-read-only" = jsonencode({
      Version = "2012-10-17",
      Statement = [{ Effect = "Allow", Action = ["s3:ListBucket"], Resource = ["arn:aws:s3:::example-bucket"] }]
    })
  }
  path = "/"
}

output "policy_arns" { value = module.p.policy_arns }
