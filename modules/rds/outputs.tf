output "endpoint" {
  description = "The RDS endpoint address"
  value       = try(aws_db_instance.this.endpoint, null)
}

output "port" {
  description = "The database port"
  value       = try(aws_db_instance.this.port, null)
}

output "id" {
  description = "The RDS DB instance id"
  value       = try(aws_db_instance.this.id, null)
}

output "proxy_endpoint" {
  description = "RDS Proxy endpoint (if created)"
  value       = var.create_proxy ? try(aws_db_proxy.this[0].endpoint, null) : null
}

output "proxy_port" {
  description = "RDS Proxy port (if created)"
  value       = var.create_proxy ? 3306 : null
}
