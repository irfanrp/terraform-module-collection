locals {
  role_name_final = var.role_name != null ? var.role_name : (var.name_prefix == "" ? "iam-role" : format("%s%s", var.name_prefix, substr(md5(timestamp()), 0, 6)))
  assume_role_policy_calc = var.assume_role_policy != null ? var.assume_role_policy : jsonencode({
    Version = "2012-10-17"
    Statement = concat([
      for svc in var.assume_services : {
        Effect    = "Allow"
        Principal = { Service = svc }
        Action    = "sts:AssumeRole"
      }
      ], [
      for acct in var.cross_account_principals : {
        Effect    = "Allow"
        Principal = { AWS = acct }
        Action    = "sts:AssumeRole"
      }
    ])
  })
}

// Delegate role creation to submodule (keeps same behaviour when create_role=true)
module "role" {
  count                   = var.create_role ? 1 : 0
  source                  = "./submodules/role"
  name                    = local.role_name_final
  assume_role_policy      = local.assume_role_policy_calc
  assume_services         = var.assume_services
  managed_policy_arns     = var.managed_policy_arns
  inline_policies         = var.inline_policies
  create_instance_profile = var.create_instance_profile
}

// Standalone policies via submodule (pass the whole map)
module "policy" {
  source   = "./submodules/policy"
  policies = var.policies
  path     = var.path
}

# OIDC providers
// OIDC providers via submodule
module "oidc" {
  for_each        = var.oidc_providers
  source          = "./submodules/oidc-provider"
  url             = each.value.url
  client_id_list  = try(each.value.client_id_list, [])
  thumbprint_list = try(each.value.thumbprint_list, [])
}

# Service-linked roles
resource "aws_iam_service_linked_role" "slr" {
  for_each         = toset(var.service_linked_roles)
  aws_service_name = each.value
}
// Groups via submodule (group submodule handles managed/inline attachments)
module "group" {
  for_each            = var.groups
  source              = "./submodules/group"
  name                = each.key
  path                = try(each.value.path, var.path)
  managed_policy_arns = try(each.value.managed_policy_arns, [])
  inline_policies     = try(each.value.inline_policies, {})
}

// Users via submodule (manages group membership and access keys)
module "user" {
  for_each          = var.users
  source            = "./submodules/user"
  name              = each.key
  path              = try(each.value.path, var.path)
  groups            = try(each.value.groups, [])
  create_access_key = try(each.value.create_access_key, false)
}
