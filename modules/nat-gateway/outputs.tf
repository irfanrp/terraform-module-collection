output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = aws_nat_gateway.this.id
}

output "nat_gateway_public_ip" {
  description = "Public IP address of the NAT Gateway"
  value       = aws_nat_gateway.this.public_ip
}

output "eip_id" {
  description = "ID of the Elastic IP (if created)"
  value       = var.create_eip ? aws_eip.this[0].id : null
}

output "eip_allocation_id" {
  description = "Allocation ID of the Elastic IP (if created)"
  value       = var.create_eip ? aws_eip.this[0].id : var.allocation_id
}

output "eip_public_ip" {
  description = "Public IP of the Elastic IP (if created)"
  value       = var.create_eip ? aws_eip.this[0].public_ip : null
}
