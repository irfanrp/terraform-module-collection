terraform { required_version = ">= 1.0" }
provider "aws" { region = var.aws_region }

module "u" {
  source            = "../../../modules/iam/submodules/user"
  name              = "example-user"
  groups            = ["developers"]
  create_access_key = true
}

output "user_name" { value = module.u.user_name }
output "access_id" { value = module.u.access_key_id }
output "access_secret" { value = module.u.access_key_secret }
