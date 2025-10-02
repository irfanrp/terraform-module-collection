output "instance_ids" {
  description = "IDs of the EC2 instances"
  value       = [for i in aws_instance.this : i.id]
}

output "public_ips" {
  description = "Public IPs (if associated)"
  value       = try([for e in aws_eip.this : e.public_ip], [])
}

output "private_ips" {
  description = "Private IPs of the instances"
  value       = [for i in aws_instance.this : i.private_ip]
}

output "arns" {
  description = "Instance ARNs"
  value       = [for i in aws_instance.this : i.arn]
}

output "ssm_instance_profile_name" {
  description = "Name of the SSM instance profile"
  value       = var.create_ssm_instance_profile ? aws_iam_instance_profile.ssm_instance_profile[0].name : null
}

output "ssm_instance_profile_arn" {
  description = "ARN of the SSM instance profile"
  value       = var.create_ssm_instance_profile ? aws_iam_instance_profile.ssm_instance_profile[0].arn : null
}

output "ssm_role_arn" {
  description = "ARN of the SSM IAM role"
  value       = var.create_ssm_instance_profile ? aws_iam_role.ssm_role[0].arn : null
}

output "availability_zones" {
  description = "Availability zones where instances are deployed"
  value       = [for i in aws_instance.this : i.availability_zone]
}

output "subnet_ids" {
  description = "Subnet IDs where instances are deployed"
  value       = [for i in aws_instance.this : i.subnet_id]
}

output "key_name" {
  description = "Key pair name used for instances"
  value       = var.key_name
}
