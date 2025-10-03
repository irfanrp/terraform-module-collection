output "role_name" {
  description = "Name of the IAM role created (if any)"
  value       = try(aws_iam_role.this[0].name, null)
}

output "role_arn" {
  description = "ARN of the IAM role created (if any)"
  value       = try(aws_iam_role.this[0].arn, null)
}

output "instance_profile_name" {
  description = "Name of the instance profile created (if any)"
  value       = try(aws_iam_instance_profile.this[0].name, null)
}

output "instance_profile_arn" {
  description = "ARN of the instance profile created (if any)"
  value       = try(aws_iam_instance_profile.this[0].arn, null)
}

output "policy_arns" {
  description = "Map of standalone policy name => ARN"
  value = length(keys(var.policies)) > 0 ? { for k, p in aws_iam_policy.standalone : k => p.arn } : {}
}

output "user_names" {
  description = "List of user names created"
  value = keys(var.users)
}

output "group_names" {
  description = "List of group names created"
  value = keys(var.groups)
}

output "oidc_provider_arns" {
  description = "Map of oidc provider logical name => arn"
  value = length(keys(var.oidc_providers)) > 0 ? { for k, p in aws_iam_openid_connect_provider.oids : k => p.arn } : {}
}

output "service_linked_roles" {
  description = "List of created service-linked roles' service names"
  value = length(var.service_linked_roles) > 0 ? [for s in aws_iam_service_linked_role.slr : s.aws_service_name] : []
}
