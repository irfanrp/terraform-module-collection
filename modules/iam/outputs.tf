output "role_name" {
  description = "Name of the IAM role created (if any)"
  value       = var.create_role ? try(module.role[0].role_name, null) : null
}

output "role_arn" {
  description = "ARN of the IAM role created (if any)"
  value       = var.create_role ? try(module.role[0].role_arn, null) : null
}

output "instance_profile_name" {
  description = "Name of the instance profile created (if any)"
  value       = var.create_instance_profile && var.create_role ? try(module.role[0].instance_profile_name, null) : null
}

output "instance_profile_arn" {
  description = "ARN of the instance profile created (if any)"
  value       = var.create_instance_profile && var.create_role ? try(module.role[0].instance_profile_arn, null) : null
}

output "policy_arns" {
  description = "Map of standalone policy name => ARN"
  value       = length(keys(var.policies)) > 0 ? { for k, m in module.policy : k => m.policy_arn } : {}
}

output "user_names" {
  description = "List of user names created"
  value       = keys(var.users)
}

output "group_names" {
  description = "List of group names created"
  value       = keys(var.groups)
}

output "oidc_provider_arns" {
  description = "Map of oidc provider logical name => arn"
  value       = length(keys(var.oidc_providers)) > 0 ? { for k, m in module.oidc : k => m.oidc_provider_arn } : {}
}

output "service_linked_roles" {
  description = "List of created service-linked roles' service names"
  value       = length(var.service_linked_roles) > 0 ? [for s in aws_iam_service_linked_role.slr : s.aws_service_name] : []
}

output "user_access_key_ids" {
  description = "Map of user => access key id for users where access keys were created"
  value       = length(keys(var.users)) > 0 ? { for k, m in module.user : k => try(m.access_key_id, null) } : {}
}

output "user_access_key_secrets" {
  description = "Map of user => access key secret. Sensitive: this will be stored in state. Handle with care."
  value       = length(keys(var.users)) > 0 ? { for k, m in module.user : k => try(m.access_key_secret, null) } : {}
  sensitive   = true
}
