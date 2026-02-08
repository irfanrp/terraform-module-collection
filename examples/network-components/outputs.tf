output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "VPC CIDR block"
  value       = aws_vpc.main.cidr_block
}

output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = module.internet_gateway.internet_gateway_id
}

output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = {
    for az, subnet in module.public_subnets : az => subnet.subnet_id
  }
}

output "private_subnet_ids" {
  description = "IDs of private subnets"
  value       = {
    for az, subnet in module.private_subnets : az => subnet.subnet_id
  }
}

output "nat_gateway_ids" {
  description = "NAT Gateway IDs per AZ"
  value       = {
    for az, nat in module.nat_gateways : az => nat.nat_gateway_id
  }
}

output "nat_gateway_ips" {
  description = "Public IPs of NAT Gateways per AZ"
  value       = {
    for az, nat in module.nat_gateways : az => nat.nat_gateway_public_ip
  }
}

output "public_route_table_id" {
  description = "Public Route Table ID"
  value       = aws_route_table.public.id
}

output "private_route_table_ids" {
  description = "Private Route Table IDs per AZ"
  value       = {
    for az, rt in aws_route_table.private : az => rt.id
  }
}
