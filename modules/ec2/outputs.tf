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
