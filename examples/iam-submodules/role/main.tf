terraform { required_version = ">= 1.0" }
provider "aws" { region = var.aws_region }

module "r" {
  source = "../../../modules/iam/submodules/role"
  name   = "example-role"
  assume_services = ["ec2.amazonaws.com"]
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
  create_instance_profile = true
}

output "role_arn" { value = module.r.role_arn }
output "instance_profile" { value = module.r.instance_profile_name }
