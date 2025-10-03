output "policy_arns" {
    description = "Map of policy_name => policy_arn for created policies"
    value       = { for k, r in aws_iam_policy.this : k => r.arn }
}

output "policy_names" {
    description = "Map of policy_name => actual created policy name"
    value       = { for k, r in aws_iam_policy.this : k => r.name }
}
