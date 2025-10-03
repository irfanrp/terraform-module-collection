output "policy_arn" {
  value = module.policy.policy_arns["example-read-only"]
}

output "group_name" {
  value = module.group_developers.group_name
}

output "role_arn" {
  value = module.role_ec2.role_arn
}

output "instance_profile_name" {
  value = module.role_ec2.instance_profile_name
}

output "user_name" {
  value = module.user_alice.user_name
}

output "user_access_key_id" {
  value = module.user_alice.access_key_id
}

output "user_access_key_secret" {
  value     = module.user_alice.access_key_secret
  sensitive = true
}
