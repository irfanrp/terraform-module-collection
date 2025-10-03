terraform { required_version = ">= 1.0" }
provider "aws" { region = var.aws_region }

module "p" {
  source = "../../../modules/iam/submodules/policy"
  name   = "example-read-only"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{ Effect = "Allow", Action = ["s3:ListBucket"], Resource = ["arn:aws:s3:::example-bucket"] }]
  })
  path = "/"
}

output "policy_arn" { value = module.p.policy_arn }
