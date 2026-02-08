output "subnet_id" {
  description = "ID of the subnet"
  value       = aws_subnet.this.id
}

output "subnet_cidr_block" {
  description = "CIDR block of the subnet"
  value       = aws_subnet.this.cidr_block
}

output "subnet_arn" {
  description = "ARN of the subnet"
  value       = aws_subnet.this.arn
}

output "availability_zone" {
  description = "Availability zone of the subnet"
  value       = aws_subnet.this.availability_zone
}
