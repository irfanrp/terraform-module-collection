terraform { required_version = ">= 1.0" }
provider "aws" { region = var.aws_region }

module "oidc" {
  source = "../../../modules/iam/submodules/oidc-provider"
  url = "https://example-oidc.example.com"
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da0b6f3f0a6"]
}

output "oidc_arn" { value = module.oidc.oidc_provider_arn }
